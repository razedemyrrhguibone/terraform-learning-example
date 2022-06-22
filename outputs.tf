# This is where you can put your outputs after execution
output "alb_dns" {
  value = aws_lb.tflearning-lb.dns_name
}
