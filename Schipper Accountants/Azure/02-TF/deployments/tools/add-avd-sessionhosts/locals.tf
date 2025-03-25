locals {
  #nlcnumber = var.prefix
  subnet_id = var.avd_subnet_id

  #vmprefix = "SH${formatdate("YYMMDDhhmm",timestamp())}"
  vmprefix = "SH${formatdate("YYMMDDhhmm",time_static.vmtimestamp.rfc3339)}"

  # Fabricate used image tag for tagging the sessionhost  
  sig_image_tag_parts             = split("/", var.source_image_id)
  sig_name                        = element(local.sig_image_tag_parts, 8)
  sig_image_name                  = element(local.sig_image_tag_parts, 10)
  sig_image_recourcegroup         = element(local.sig_image_tag_parts, 4)
  sig_image_version               = element(local.sig_image_tag_parts, 12)
  sig_image_tag                   = "${lower(local.sig_name)}/${lower(local.sig_image_name)}/${lower(local.sig_image_version)}"

}
