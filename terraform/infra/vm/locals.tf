locals {
  ipSplit   = split(".", var.subnet)
  cidrBlock = split("/", var.subnet)[1]

  ipBit = tonumber(split(".", var.ip)[3])

  ipPrefix = "${local.ipSplit[0]}.${local.ipSplit[1]}.${local.ipSplit[2]}"

  info = [for i in range(0, var.instances) :
    {
      name = "${var.name}${var.instances > 1 ? "-${i + 1}" : ""}",
      ip   = "${local.ipPrefix}.${local.ipBit + i}"
    }
  ]
}
