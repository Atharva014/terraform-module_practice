module "vpc-module" {
  source = "./modules/vpc-module"
  vpc_cidr_block = "192.168.0.0/16"
  web_pub_sub_cidr = [ "192.168.1.0/24", "192.168.2.0/24" ]
  app_priv_sub_cidr = [ "192.168.3.0/24", "192.168.4.0/24" ]
  db_priv_sub_cidr = [ "192.168.5.0/24", "192.168.6.0/24" ]
  key_pair = "linux-key"
  root_volume_size = 8
}