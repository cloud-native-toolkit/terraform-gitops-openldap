module "gitops" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops"

  host = var.git_host
  type = var.git_type
  org  = var.git_org
  repo = var.git_repo
  token = var.git_token
  username = var.git_username
  gitops_namespace = var.gitops_namespace
  public = true
  sealed_secrets_cert = module.cert.cert
}

resource null_resource gitops_output {
  provisioner "local-exec" {
    command = "echo -n '${module.gitops.config_repo}' > git_repo"
  }

  provisioner "local-exec" {
    command = "echo -n '${module.gitops.config_token}' > git_token"
  }
}
