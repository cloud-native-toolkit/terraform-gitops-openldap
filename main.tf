locals {
  name          = "openldap"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  ingress_host  = "${local.name}-${var.namespace}.${var.cluster_ingress_hostname}"
  ingress_url   = "https://${local.ingress_host}"
  service_url   = "http://${local.name}.${var.namespace}"
  
  # OpenLDAP Values.yaml
  service_name           = "openldap-openldap"
  sa_name                = "openldap-openldap"
  config_sa_name         = "openldap-config"

  global_config          = {
    clusterType = var.cluster_type
    ingressSubdomain = var.cluster_ingress_hostname
    tlsSecretName = var.tls_secret_name
  }

  openldap_config ={    
  }


  layer = "services"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]

  values_content = {
    openldap = local.openldap_config
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

module "config_service_account" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.namespace
  name = local.config_sa_name
  rbac_rules = [{
    apiGroups = [
      ""
    ]
    resources = [
      "secrets",
      "configmaps"
    ]
    verbs = [
      "*"
    ]
  }]
  server_name = var.server_name
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
