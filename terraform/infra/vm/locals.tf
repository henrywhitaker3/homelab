locals {
  cidrBlock = split("/", var.subnet)[1]

  info = [for i in range(0, var.instances) :
    {
      name = "${var.name}${var.instances > 1 ? "-${i + 1}" : ""}",
      ip   = var.ips[i]
    }
  ]
}
