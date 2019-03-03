#Keypair for instances
resource "aws_key_pair" "aws_access" {
  key_name   = "${var.aws_key_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDp+XKyf5MNuQ5kUU1h471zZTcLJLl1SCJ6OVRLW6fkxa4ED1P+A6T9aLuUjQMpy2zdNT312WsuVQoWmRhAaOy45tcR8lLdvAqRFQZ0RSNC+aeQVgZ0fBGlXrNnGW8FJJjS/183NakqxXic1KO0LGAhqr0fO468jd/w3rzwivHnD3ika9oLbm1nX2UXQxU8R6cHFVLTrhf0esGmt05AsYgdrMdQus7n5cICePWSh/IoM6BKiYrDZeDSRcWFsVDQOMbxPn2Pn2mrtqmSiqipLkAJO2mU6NNKN8tjkQnzbdOd1Xu2S1gDteiMAQRWcfWI3bphYB9scRfmmzHgiXNq4jmV root@ubuntu-bionic"
}

resource "null_resource" "tests" {
   provisioner "local-exec" {
      command = "chmod 600 ${path.root}/keys/priv.key"
   }
}



