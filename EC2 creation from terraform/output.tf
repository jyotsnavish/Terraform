output "aws_private_ip" {
 value = aws_instance.instance_server.private_ip
}

output "aws_tags" {
 value = aws_instance.instance_server.tags
}

output "server_id" {
    value = aws_instance.instance_server.id 
}

output "public-ip" {
    value = aws_eip.one.public_ip
  
}