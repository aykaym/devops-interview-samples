variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "The DB name"
  type        = string
  default     = "mydb"
}

variable "username" {
  description = "The username for the DB"
  type        = string
  default     = "foo"
}

variable "password" {
  description = "The password for the DB"
  type        = string
  default     = "foobarbaz"
}