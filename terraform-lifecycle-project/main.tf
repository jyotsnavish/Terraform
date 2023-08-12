resource "aws_instance" "lifecycle_example_one" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance_type
  
  tags          = local.ctags
  
  #lifecycle {
    #create_before_destroy = true
    #prevent_destroy = true
  #}
}
