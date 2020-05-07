resource "aws_db_parameter_group" "db-pg" {
    name = "knowledge"
    family = "postgres9.6"
    description = "knowledge"

    parameter {
        name = "log_min_duration_statement"
        value = "100"
    }
}

resource "aws_db_instance" "posgre" {
    identifier = "knowledge"
    allocated_storage = 10
    engine = "postgres"
    engine_version = "9.6.2"
    instance_class = var.rds_instance_class
    name = var.database_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
    vpc_security_group_ids = ["${aws_security_group.posgre_security_group.id}"]
    parameter_group_name = "${aws_db_parameter_group.db-pg.name}"
    multi_az = false
    backup_retention_period = "7"
    backup_window = "19:00-19:30"
    apply_immediately = "true"
    auto_minor_version_upgrade = false
}

output "rds_endpoint" {
    value = "${aws_db_instance.posgre.address}"
}
