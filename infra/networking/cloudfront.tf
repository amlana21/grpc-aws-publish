locals {
  s3_origin_id           = "${var.s3_bucket_name}-origin"
  s3_domain_name         = "${var.s3_bucket_name}.s3-website-${var.region}.amazonaws.com"
  backend_lb_origin_id   = "${aws_lb.app_lb.name}-backend-lb-origin"
  backend_lb_domain_name = aws_lb.app_lb.dns_name
}

resource "aws_cloudfront_distribution" "this" {

  enabled = true

  origin {
    origin_id   = local.s3_origin_id
    domain_name = local.s3_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {

    target_origin_id = local.s3_origin_id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_200"

}

resource "aws_cloudfront_distribution" "backend_lb" {

  enabled = true

  origin {
    origin_id   = local.backend_lb_origin_id
    domain_name = local.backend_lb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {

    target_origin_id         = local.backend_lb_origin_id
    allowed_methods          = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id          = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_200"

}
