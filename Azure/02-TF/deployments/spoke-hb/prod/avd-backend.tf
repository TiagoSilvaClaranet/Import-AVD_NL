module "avd-backend" {
  source              = "./avd-backend"
  nlcnumber           = var.nlcnumber
  hostpool_name       = "generic"
  hostpool_name_short = "hb"
  spokename           = "hb"
}