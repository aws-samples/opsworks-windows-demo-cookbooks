name        "webserver_nodejs"
description "Install and configure a IIS based Node.JS webserver"
license     "Apache 2.0"
version     "0.0.1"

supports    "windows"

depends "s3_file"
depends "opsworks_iis"
depends "opsworks_nodejs"
depends "opsworks_iisnode"
depends "opsworks_app_nodejs"

