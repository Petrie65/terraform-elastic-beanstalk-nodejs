##################################################
## Your variables
##################################################
variable "aws_region" {
  type        = "string"
  description = "The AWS Region"
  default     = "eu-west-2"
}
variable "service_name" {
  type    = "string"
  default = "animocity-server"
}
variable "service_description" {
  type    = "string"
  default = "My awesome nodeJs App"
}

##################################################
## Cloudfront
##################################################
variable "env" {
  type    = "string"
  default = "dev"
}
variable "domain_name" {
  type    = "string"
  default = "pvz.ninja"
}