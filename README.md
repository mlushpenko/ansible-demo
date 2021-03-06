# ansible-demo

Inspired by SysAdmin casts https://sysadmincasts.com/episodes/43-19-minutes-with-ansible-part-1-4

ansible version: `2.2.0.0`

ansible-lint version: `3.4.7`

terraform version: `0.7.7`

# Run instructions (manual)

Create demo key in us-west-2 region and download into the root directory of the project

Create aws_keys.tf file with the following content:
```
variable "aws_keys" {
  default = {
    access = "key_id"
    secret = "key_secret"
  }
}
```

Replace `key_id` and `key_secret` with AWS API access credentials (don't use root account). Create a private key in EC2 console and add it to the root directory with a name `demo.pem`

Run `terraform plan` to see if connectivity to AWS is working properly

Run `terraform apply`

Go to the output IP address to see webpage `index.html` or to `/haproxy?stats` to see haproxy statistics page
