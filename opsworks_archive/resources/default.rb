actions :extract
default_action :extract

attribute :archive, :kind_of => String, :name_attribute => true, :required => true
attribute :destination, :kind_of => String, :required => true
