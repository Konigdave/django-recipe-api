resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "@"                     # Root domain (david-cloud.site)
  value   = aws_lb.api.dns_name    # Dynamically tracking your live ALB address!
  type    = "CNAME"
  proxied = false                   # DNS Only (Gray Cloud)
}
