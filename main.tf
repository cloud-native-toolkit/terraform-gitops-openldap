locals {
  name          = "openldap"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  service_url   = "http://${local.name}.${var.namespace}"
  service_name           = "openldap"
  sa_name                = "openldap"
  type = "base"
  openldap_config ={    
  }

  namespace = var.namespace
  layer = "services"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]

  values_content = {
   replicaCount = var.deployment_replicacount
   InitImage    = "docker.io/busybox"
   InitImageTag = var.initimage_tag
   imagePullSecrets = []
   nameOverride = ""
   fullnameOverride = ""
   logLevel = var.loglevel
   image = {
  repository = var.image_repo
  pullPolicy = "Always"
  tag        = "latest"
  }
  serviceAccount={
  create = true
  name = ""
  annotations = {}
  
  }
  podAnnotations = {}
  podSecurityContext = {}
  securityContext = {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000
  service = {
  type = "LoadBalancer"
  name = "ldap-port"
  protocol = "TCP"
  ldapPort = 389
  sslLdapPort = 636
  }
  ldap = {
  org = var.ldap_org
  domain = var.ldap_domain
  }
  ingress = {
  enabled = false
  annotations = {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  }
  hosts = {
      host = "chart-example.local"
      paths = []
  }
  tls = []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

resources = {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
limits = {
  cpu = var.limits_cpu
  memory =var.limits_memory
}
autoscaling = {
  enabled = false
  minReplicas =  1
  maxReplicas = 100
  targetCPUUtilizationPercentage = var.targetCPUUtilizationPercentage
  
}
nodeSelector = {}

tolerations = []

affinity = {}

service-account={
name = local.name
  sccs=[
     "anyuid"
  ]
}  
seedusers = {
  usergroup = var.seedusers_usergroup
  userlist = var.seedusers_userlist
  initialpassword = var.seedusers_initialpwd
}
}

    values_file = "values-${var.server_name}.yaml"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}

module "service_account" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account.git"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.namespace
  name = local.sa_name
  sccs = ["anyuid", "privileged"]
  server_name = var.server_name
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml,module.service_account]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
