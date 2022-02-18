locals {
  name          = "openldap"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  service_url   = "http://${local.name}.${var.namespace}"
  service_name           = "openldap"
  sa_name                = "openldap"
  openldap_config ={    
  }


  layer = "services"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]

  values_content = {
   replicaCount = 1
   InitImage    = "docker.io/busybox"
   InitImageTag = "1.30.1"
   imagePullSecrets = []
   nameOverride = ""
   fullnameOverride = ""
   logLevel = "info"
   image = {
  repository = "osixia/openldap"
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
  org = "falconbanc"
  domain = "falconbanc.com"
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
  cpu = "100m"
  memory ="256Mi"
}
autoscaling = {
  enabled = false
  minReplicas =  1
  maxReplicas = 100
  targetCPUUtilizationPercentage = 80
  
}
nodeSelector = {}

tolerations = []

affinity = {}

service-account={
name = "openldap"
  sccs=[
     "anyuid"
  ]
}  
seedusers = {
  usergroup = "icpusers"
  userlist = "user1,user2,user3,user4"
  initialpassword = "changeme"
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
      VALUES_CONTENT = local.values_content
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
