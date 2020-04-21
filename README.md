# Terraform AWS Elastic Beanstalk NodeJS

Terraform script to setup AWS Elastic Beanstalk with a load-balanced NodeJS app

## What this script does

* Create an Elastic Beanstalk Application and environment.
* Setup the EB environment with NodeJS, an Elastic Loadbalancer and forward port from HTTP / HTTPS to the specified instance port.
* (Optionnal) Create a Route53 Alias to link your domain to the EB domain name
* (Optionnal) Create a Cloudfront distribution on top of your Elastic Beanstalk environment


## Usage

Create a `main.tf` file with the following configuration:

### Create an EB environment

```hcl
##################################################
## Your variables
##################################################
variable "aws_region" {
  type    = "string"
  default = "eu-west-1"
}
variable "service_name" {
  type    = "string"
  default = "nodejs-app-test"
}
variable "service_description" {
  type    = "string"
  default = "My awesome nodeJs App"
}
##################################################
## AWS config
##################################################
provider "aws" {
  region = "${var.aws_region}"
}

##################################################
## Elastic Beanstalk config
##################################################
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${var.service_name}"
  description = "${var.service_description}"
}

module "eb_env" {
  source = "github.com/BasileTrujillo/terraform-elastic-beanstalk-nodejs//eb-env"
  aws_region = "${var.aws_region}"

  # Application settings
  service_name = "nodejs-app-test"
  service_description = "My awesome nodeJs App"
  env = "dev"

  # Instance settings
  instance_type = "t2.micro"
  min_instance = "2"
  max_instance = "4"

  # ELB
  enable_https = "false" # If set to true, you will need to add an ssl_certificate_id (see L70 in app/variables.tf)

  # Security
  vpc_id = "vpc-xxxxxxx"
  vpc_subnets = "subnet-xxxxxxx"
  elb_subnets = "subnet-xxxxxxx"
  security_groups = "sg-xxxxxxx"
}
```

### Link your domain using Route53

Add to the previous script the following lines:

```hcl
##################################################
## Route53 config
##################################################
module "app_dns" {
  source      = "github.com/BasileTrujillo/terraform-elastic-beanstalk-nodejs//r53-alias"
  aws_region  = "${var.aws_region}"

  domain      = "example.io"
  domain_name = "my-app.example.io"
  eb_cname    = "${module.app.eb_cname}"
}
``` 

### Example

* Take a look at [example.tf](./example.tf) for an example with Elastic Beanstalk and Route53.
* Take a look at [example_with_cloudfront.tf](./example_with_cloudfront.tf) for an example with Elastic Beanstalk, Cloudfront and Route53.

## Customize

Many options are available through variables. Feel free to look into `variables.tf` inside each module to see all parameters you can setup.

## Terraform related documentation

* Elastic Beanstalk Application: https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_application.html
* Elastic Beanstalk Environment: https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_environment.html
* CloudFront: https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html
* Route53: https://www.terraform.io/docs/providers/aws/d/route53_zone.html