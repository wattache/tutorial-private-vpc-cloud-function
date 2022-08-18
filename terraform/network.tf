module "network" {
    source  = "terraform-google-modules/network/google"
    version = "5.0.0"

    project_id   = var.project_id
    network_name = "my-vpc"
    routing_mode = "REGIONAL"

    subnets = [
        {
            subnet_name           = "my-subnet"
            subnet_ip             = "10.10.10.0/28"
            subnet_region         = var.region
        },
        
    ]
}

module "serverless_connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version = "5.0.0"

  project_id = var.project_id
  vpc_connectors = [{
        name        = var.connector_name
        region      = var.region
        subnet_name = module.network.subnets_names[0]
        machine_type  = "f1-micro"
        min_instances = 2
        max_instances = 3
    }
  ]
  
  depends_on = [
    module.network
  ]

}
