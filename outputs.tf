output "lb-link" {
	value = "${aws_instance.lb.public_ip}"
}