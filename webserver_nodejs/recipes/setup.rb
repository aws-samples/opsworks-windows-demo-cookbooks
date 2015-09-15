# Recipes to install software on initial boot
include_recipe "s3_file::dependencies"
include_recipe "opsworks_iis"
include_recipe "opsworks_nodejs"
include_recipe "opsworks_iisnode"
