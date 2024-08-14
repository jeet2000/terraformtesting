locals {
  environment                 = "Prod"
  ec2_key_name                = "Wordpres-website"
  ec2_name                    = "ci/cd-test"
  ec2_ingress_rules           = [
    {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22
    },

    ]
  ec2_egress_rules            = [{
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
        }]
  ec2_ami_id                  = "ami-0c2af51e265bd5e0e"
  ec2_instance_type           = "t3a.micro"
  ec2_iam_role_name           = "test"
  ec2_iam_role_policies       = ""
  ec2_volume_type             = "gp3"
  ec2_volume_size             = "20"
  ec2_kms_key_id              = ""
  ec2_root_encrypted          = "true"
  #ec2_ebs_block_devices       = 
  ec2_tags                    = {
    "Implementedby" = "Workmates"
  }
  ec2_disable_api_termination = "false"
  ec2_iam_instance_profile    = "CWMManagedInstanceRole"

}

data "aws_key_pair" "app" {
  key_name           = local.ec2_key_name
  include_public_key = true
}

module "securtiy-group" {
  source      = "./modules/sg"
  name        = "${title(local.ec2_name)}-SG"
  description = "${title(local.ec2_name)} Security group"
  vpc_id      = "vpc-08ffa5185952fadc5"

  ingress_rules = local.ec2_ingress_rules
  egress_rules  = local.ec2_egress_rules
}
module "app-1a" {
  source     = "./modules/ec2"
  depends_on = [module.securtiy-group]
  create     = true
  name       = "${local.ec2_name}-1a"

  ami                         = local.ec2_ami_id
  instance_type               = local.ec2_instance_type
  availability_zone           = "ap-south-1a"
  subnet_id                   = "subnet-0d364fae1a11c7b30"
  vpc_security_group_ids      = [module.securtiy-group.security_group_id]
  key_name                    = data.aws_key_pair.app.key_name
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = local.ec2_disable_api_termination
  ebs_optimized               = true
  source_dest_check           = false
  #private_ip                  = ""

  create_iam_instance_profile = false
  iam_instance_profile        = local.ec2_iam_instance_profile
  #iam_role_name               = local.ec2_iam_role_name
  #iam_role_description        = "IAM role for EC2 instance"
  #iam_role_policies           = local.ec2_iam_role_policies


  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = local.ec2_root_encrypted
      kms_key_id  = local.ec2_kms_key_id
      volume_type = local.ec2_volume_type
      volume_size = local.ec2_volume_size
      tags = {
        Name = "test-root"
      }
    }
  ]

  #   user_data = templatefile("pritunl.sh", { S3_BUCKET_NAME = aws_s3_bucket.fci-credential-bucket.bucket })
  #ebs_block_device = local.ec2_ebs_block_devices

  tags = local.ec2_tags
}