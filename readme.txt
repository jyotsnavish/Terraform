Install WGET:
sudo yum install wget

Install Terraform:
export VER="1.2.0"
wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
unzip terraform_${VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v



terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

terraform state list
terraform state show resource.resource_name
terraform refresh (refresh the state)
terraform destroy target resource.resource_name
terraform apply target resource.resource_name