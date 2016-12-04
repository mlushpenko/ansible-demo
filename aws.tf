provider "aws" {
  access_key = "${var.aws_keys["access"]}"
  secret_key = "${var.aws_keys["secret"]}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "ansible" {
  tags = {
    Name  = "${var.user_prefix}-ansible"
    group = "mgmt"
  }

  instance_type          = "m1.small"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  subnet_id              = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.ansible.id}"]

  connection {
    # The default username for our AMI
    user        = "ubuntu"
    private_key = "${file("demo.pem")}"
  }

  key_name = "demo"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y install python-software-properties",
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt-get -y update",
      "sudo apt-get -y install ansible python-pip python-dev",
      "sudo pip install ansible-lint"
    ]
  }
}

resource "aws_instance" "lb" {
  tags = {
    Name  = "${var.user_prefix}-lb"
    group = "lb"
  }

  instance_type = "m1.small"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  key_name      = "demo"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.lb.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"
}

resource "aws_instance" "web" {
  tags = {
    Name  = "${var.user_prefix}-web-${count.index}"
    group = "web"
  }

  instance_type = "m1.small"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  key_name      = "demo"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  # This will create a number of instances idicated below
  count = "${var.aws_instances_count}"
}
