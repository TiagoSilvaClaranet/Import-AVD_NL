locals {

  # Level 1 Intermediate root management group
  level_1 = {
    intermediate_root = {
      display_name = local.customer_name
      name         = "mg-${local.short_customer_name}"
    }
  }

  # Level 2 Management groups
  level_2 = {
    platform = {
      display_name            = "Platform",
      name                    = "mg-${local.short_customer_name}-platform"
      parent_management_group = "intermediate_root"
      subscription_ids        = ["63cf28ad-7dcb-431b-a539-58a6e358db3d"]

    },
    landing-zones = {
      display_name            = "Landing Zones"
      name                    = "mg-${local.short_customer_name}-landing-zones"
      parent_management_group = "intermediate_root"
      subscription_ids        = []
    },
    sandbox = {
      display_name            = "Sandbox"
      name                    = "mg-${local.short_customer_name}-sandbox"
      parent_management_group = "intermediate_root"
      subscription_ids        = []
    },
    decomissioned = {
      display_name            = "Decomissioned"
      name                    = "mg-${local.short_customer_name}-decomissioned"
      parent_management_group = "intermediate_root"
      subscription_ids        = []
    }
  }

  # Level 3 Management groups
  level_3 = {
    identity = {
      display_name            = "Identity",
      name                    = "mg-${local.short_customer_name}-identity"
      parent_management_group = "platform"
      subscription_ids        = []
    },
    management = {
      display_name            = "Management",
      name                    = "mg-${local.short_customer_name}-management"
      parent_management_group = "platform"
      subscription_ids        = []
    },
    connectivity = {
      display_name            = "Connectivity",
      name                    = "mg-${local.short_customer_name}-connectivity"
      parent_management_group = "platform"
      subscription_ids        = []
    },
    corp = {
      display_name            = "Corp",
      name                    = "mg-${local.short_customer_name}-corp"
      parent_management_group = "landing-zones"
      subscription_ids        = []
    },
    online = {
      display_name            = "Online",
      name                    = "mg-${local.short_customer_name}-online"
      parent_management_group = "landing-zones"
      subscription_ids        = []
    }
  }

  # Level 4 Management groups
  level_4 = {}
  # level_4 = {
  #   lab01 = {
  #     display_name            = "landing-zone-1",
  #     name                    = "mg-${local.short_customer_name}-landing-zone-1"
  #     parent_management_group = "corp"
  #     subscription_ids        = []
  #   }
  # }

  # Level 5 Management groups
  level_5 = {}

  # Level 6 Management groups
  level_6 = {}

  # No more then 6 levels are allowed by Microsoft!






}
