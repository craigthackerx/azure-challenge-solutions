data "local_file" "cloud_init" {
  filename = "${path.cwd}/cloud-init.yml"
}