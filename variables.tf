
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}


variable "ldap_org" {
  type        = string
  description = "LDAP Org Name"
  default     = "falconbanc"
}

variable "ldap_domain" {
  type        = string
  description = "LDAP domain Name"
  default     = "falconbanc.com"
}

variable "initimage_tag" {
  type        = string
  description = "Tag for image of init container"
  default     = "1.30.1"
}

variable "loglevel" {
  type        = string
  description = "log level for deployment"
  default     = "info"
}

variable "image_repo" {
  type        = string
  description = "LDAP domain Name"
  default     = "falconbanc.com"
}

variable "seedusers_usergroup" {
  type        = string
  description = "seedusers user group for installing schema"
  default     = "icpusers"
}

variable "seedusers_userlist" {
  type        = string
  description = "seedusers users list for installing schema"
  default     = "user1,user2,user3,user4"
}

variable "seedusers_initialpwd" {
  type        = string
  description = "seedusers user group initial password for installing schema"
  default     = "changeme"
}

variable "limits_cpu" {
  type        = string
  description = "cpu limit"
  default     = "100m"
}

variable "limits_memory" {
  type        = string
  description = "limit for memory"
  default     = "256Mi"
}

variable "targetCPUUtilizationPercentage" {
  type        = number
  description = "target CPU Utilization Percent"
  default     = 80
}

variable "deployment_replicacount" {
  type        = number
  description = "replica count for deployment"
  default     = 1
}
