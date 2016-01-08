# Create an AWS Internet Gateway in the specified VPC
resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.name}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create the VPC Public Subnets in the specified VPC
resource "aws_subnet" "public" {
  count = "${length(split(",", var.cidrs))}"

  vpc_id = "${var.vpc_id}"

  # Determine the Availability Zone and CIDR block for this Subnet instance
  availability_zone = "${element(split(",", var.availability_zones), count.index % length(split(",", var.availability_zones)))}"
  cidr_block = "${element(split(",", var.cidrs), count.index)}"

  # Default to creating public ip addresses for instances in this Subnet
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.name}.${element(split(",", var.availability_zones), count.index % length(split(",", var.availability_zones)))}"
    Environment = "${var.environment}"
    Service     = "public subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a route table for the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  # Route all non-subnet traffic through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Service     = "public subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Associate the Public Subnets to the Internet Gateway route table
resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.cidrs))}"

  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"

  lifecycle {
    create_before_destroy = true
  }
}
