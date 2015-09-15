opsworks_archive node["opsworks_archive"]["lwrp_test"]["name"] do
  archive node["opsworks_archive"]["lwrp_test"]["archive"]
  destination "/tmp/"
end
