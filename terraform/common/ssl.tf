
resource "tls_private_key" "companynews" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "companynews" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.companynews.private_key_pem}"

  subject {
    common_name  = "companynews.org"
    organization = "Company News"
  }

  validity_period_hours = 219000

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "companynews" {
  private_key      = "${tls_private_key.companynews.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.companynews.cert_pem}"
}

output "ssl_private_key" {
   value = "${tls_private_key.companynews.private_key_pem}"
}
