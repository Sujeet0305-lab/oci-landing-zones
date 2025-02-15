######################################################################
#                Support for multi-region deployments                #
######################################################################
locals {
  region_subscriptions = data.oci_identity_region_subscriptions.regions.region_subscriptions
  home_region          = [for region in local.region_subscriptions : region.region_name if region.is_home_region == true]
  region_key           = [for region in local.region_subscriptions : region.region_key if region.region_name == var.region]
}
######################################################################
#                    Get Tenancy OCID From the Region                #
######################################################################
data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.tenancy_ocid
}

######################################################################
#              Get the Private IPs using Trust Subnet                #
######################################################################
data "oci_core_private_ips" "firewall_subnet_private_ip" {
  subnet_id  = var.nfw_subnet_type == "public" ? oci_core_subnet.hub_public_subnet.id : oci_core_subnet.hub_private_subnet.id
  #subnet_id  = oci_core_subnet.hub_public_subnet.id
  depends_on = [
    oci_network_firewall_network_firewall.network_firewall
  ]
}
