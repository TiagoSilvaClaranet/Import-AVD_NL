output "mt01-localpassword" {
   value       = random_password.mt01-local-password.result
   sensitive   = true
} 
