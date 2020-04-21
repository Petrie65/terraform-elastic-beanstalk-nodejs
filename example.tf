##################################################
## AWS config
##################################################
provider "aws" {
  region = "${var.aws_region}"
  version = "~> 2.58"
}

##################################################
## Elastic Beanstalk config
##################################################
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${var.service_name}"
  description = "${var.service_description}"
}

module "app" {
  source     = ".//eb-env"
  aws_region = "${var.aws_region}"

  # Application settings
  service_name        = "${var.service_name}"
  service_description = "${var.service_description}"
  env                 = "dev"

  # Instance settings
  instance_type  = "t2.micro"
  min_instance   = "1"
  max_instance   = "1"

  # ELB
  enable_https           = "false"
  elb_connection_timeout = "120"

  # Security
  vpc_id          = "vpc-xxxxxxx"
  vpc_subnets     = "subnet-xxxxxxx"
  elb_subnets     = "subnet-xxxxxxx"
  security_groups = "sg-xxxxxxx"
}

##################################################
## Route53 config
##################################################
module "app_dns" {
  source      = ".//r53-alias"
  aws_region  = "${var.aws_region}"

  domain      = "example.io"
  domain_name = "app-test.example.io"
  eb_cname    = "${module.app.eb_cname}"
}
