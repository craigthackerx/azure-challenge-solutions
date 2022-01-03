data "local_file" "cloud_init" {
  filename = "${path.cwd}../azure-init/scropts/cloud-init.yml"
}