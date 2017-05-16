// resource "null_resource" "ansible_dynamic_inventory" {
//   triggers = {
//     instance_count_changed = "${var.aws_instances_count}"
//   }

//   provisioner "local-exec" {
//     command = "grep '\"private_ip\":' terraform.tfstate | grep -P '(?:[0-9]{1,3}\\.){3}[0-9]{1,3}' -o | sed '/${aws_instance.ansible.private_ip}/d' > ansible/inventory"
//   }

//   depends_on = ["aws_instance.web", "aws_instance.lb"]
// }

// resource "null_resource" "ansible_copy" {
//   triggers = {
//     instance_count_changed = "${var.aws_instances_count}"
//   }

//   provisioner "file" {
//     source      = "ansible/"
//     destination = "/home/ubuntu"
//   }

//   connection {
//     user        = "ubuntu"
//     private_key = "${file("demo.pem")}"
//     host	= "${aws_instance.ansible.public_ip}"
//   }

//   depends_on = ["null_resource.ansible_dynamic_inventory"]
// }

// resource "null_resource" "ssh_copy" {
//   provisioner "file" {
//     source      = "demo.pem"
//     destination = "/home/ubuntu/demo.pem"
//   }

//   connection {
//     user        = "ubuntu"
//     private_key = "${file("demo.pem")}"
//     host	= "${aws_instance.ansible.public_ip}"
//   }
// }

// resource "null_resource" "ansible_exec" {
//   triggers = {
//     instance_count_changed = "${var.aws_instances_count}"
//   }

//   provisioner "remote-exec" {
//     inline = [
//       "chmod 400 demo.pem",
//       "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook install.yml -i inventory --key-file=demo.pem",
//       "ansible-playbook site.yml -i 'localhost,' -v"
//     ]
//   }

//   connection {
//     user        = "ubuntu"
//     private_key = "${file("demo.pem")}"
//     host        = "${aws_instance.ansible.public_ip}"
//   }

//   depends_on = ["null_resource.ansible_copy", "null_resource.ssh_copy"]
// }
