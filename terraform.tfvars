# rg_name = "newrg1"
location = "uksouth"
resource_prefix = "home"
environment      = "dev"

# Define multiple resource groups using for_each
resource_groups = {
  "app" = {
    location = "uksouth"
  }
  "data" = {
    location = "uksouth"
  }
  "network" = {
    location = "uksouth"
  }
}

# Virtual Network definitions
vnets = {
  "primary" = {
    resource_group = "network"
    location       = "uksouth"
    address_space  = "10.1.0.0/24"
    subnets = {
      "subnet-1" = "10.1.0.0/26"
      "subnet-2" = "10.1.0.64/26"
      "subnet-3" = "10.1.0.128/26"
      "subnet-4" = "10.1.0.192/26"
    }
  }
  "secondary" = {
    resource_group = "data"
    location       = "uksouth"
    address_space  = "10.2.0.0/24"
    subnets = {
      "subnet-1" = "10.2.0.0/26"
      "subnet-2" = "10.2.0.64/26"
      "subnet-3" = "10.2.0.128/26"
      "subnet-4" = "10.2.0.192/26"
    }
  }
}
