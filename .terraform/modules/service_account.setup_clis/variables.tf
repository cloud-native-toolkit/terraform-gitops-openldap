variable "bin_dir" {
  type        = string
  description = "The directory where the clis should be downloaded. If not provided will default to ./bin"
  default     = ""
}

variable "clis" {
  type        = list(string)
  description = "The list of clis that should be made available in the bin directory. Supported values are yq, jq, igc, and helm. (If not provided the list will default to yq, jq, and igc)"
  default     = ["yq", "jq", "igc"]
}
