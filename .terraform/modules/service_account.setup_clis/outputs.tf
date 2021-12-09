output "bin_dir" {
  description = "Directory where the clis were downloaded"
  value       = local.bin_dir
  depends_on  = [null_resource.setup-binaries]
}
