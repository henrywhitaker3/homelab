locals {
  ipSplit = split(".", var.subnet)
  cidrBlock = split("/", var.subnet)[1]

  ipBit = split(".", var.ip)[3]

  ipPrefix = "${local.ipSplit[0]}.${local.ipSplit[1]}.${local.ipSplit[2]}"
}
