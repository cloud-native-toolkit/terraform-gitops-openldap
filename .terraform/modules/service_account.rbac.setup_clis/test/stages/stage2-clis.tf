module "clis" {
  source = "./module"

  clis = ["yq", "jq", "igc", "helm"]
}

resource null_resource write_path {
  provisioner "local-exec" {
    command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
  }
}
