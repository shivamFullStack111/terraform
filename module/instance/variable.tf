variable "instance_config" {
  type = object({
    instance_type = string
    ami           = string
    name          = string
  })
  default = {
    ami = ""
    instance_type = ""
    name = ""
  }
}
