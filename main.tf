terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

provider "aws" {
  region = "eu-north-1"
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "tg_bot_key" {}
variable "tg_room_id" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-impish-21.10-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  name = "default"
}

resource "aws_launch_template" "ruslan" {
  name_prefix = "ruslan-"
  image_id    = data.aws_ami.ubuntu.id
  key_name    = "ruslan@aws"

  # TODO netfork interface tag

  # TODO
  user_data = base64encode(templatefile("user_data.sh.tftpl", {
    tg_bot_key            = var.tg_bot_key,
    tg_room_id            = var.tg_room_id,
    aws_access_key_id     = var.aws_access_key_id,
    aws_secret_access_key = var.aws_secret_access_key
  }))

  # TODO
  instance_initiated_shutdown_behavior = "terminate"

  vpc_security_group_ids = [
    data.aws_security_group.default.id
  ]

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ruslan"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ruslan" {
  name_prefix = "ruslan-"

  min_size         = 1
  desired_capacity = 1
  max_size         = 10

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0

      spot_allocation_strategy = "capacity-optimized-prioritized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ruslan.id
        # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#instance_refresh
        # A refresh will not start when version = "$Latest" is configured in the launch_template block.
        # To trigger the instance refresh when a launch template is changed, configure version to
        # use the latest_version attribute of the aws_launch_template resource.
        version = aws_launch_template.ruslan.latest_version
      }

      override {
        instance_type = "t4g.nano"
      }

      override {
        instance_type = "t4g.micro"
      }

      override {
        instance_type = "t4g.small"
      }
    }
  }

  capacity_rebalance = true

  target_group_arns = [
    aws_lb_target_group.nginx.arn
  ]

  health_check_grace_period = 30
  health_check_type         = "ELB"

  vpc_zone_identifier = data.aws_subnets.this.ids

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lb" {
  name_prefix = "ruslan-lb-"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    Name = "ruslan-lb"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # need to split "::/0" according to https://github.com/hashicorp/terraform/issues/14382#issuecomment-300769009
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name     = "ruslan"
  internal = false

  load_balancer_type = "application"

  security_groups = [
    data.aws_security_group.default.id,
    aws_security_group.lb.id
  ]

  subnets = data.aws_subnets.this.ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

resource "aws_lb_target_group" "nginx" {
  name = "ruslan-nginx"
  port = 80

  protocol = "HTTP"
  # safari WS fails to connect with status_code=464 on HTTP2
  # see https://forums.aws.amazon.com/thread.jspa?messageID=967355
  protocol_version = "HTTP1"

  # TODO
  deregistration_delay = 10

  vpc_id      = data.aws_vpc.this.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 2
    path                = "/"
  }
}
