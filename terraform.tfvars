# this file is used is production/development this provide value of variable that is declared in another tf file 
# this file must be: terraform.tfvars 
# this used is production to provide  value safely  

aws_bucket = "my-bucket-jjjj-344833"
aws_ami    = "ami-test48743893"
aws_block = {
  name  = "test-name"
  class = "test-value"
}
map_variable = {
  key = "Value"
}
