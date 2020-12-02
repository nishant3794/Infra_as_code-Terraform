data "template_file" "prod" {
  template = file("${path.module}/userdata.sh.tpl")
}
output "user-data" { value = data.template_file.prod.rendered }