actions :sync
default_action :sync

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :type, :kind_of => String, :regex => [/^(git|s3)$/], :required => true
attribute :repository, :kind_of => String, :required => true
attribute :user, :kind_of => String, :default => nil
attribute :password, :kind_of => String, :default => nil
attribute :ssh_key, :kind_of => String, :default => nil
attribute :ssh_wrapper_path, :kind_of => String, :default => nil
attribute :revision, :kind_of => String, :default => nil
attribute :destination, :kind_of => String, :required => true
attribute :retries, :kind_of => Fixnum, :default => 2
attribute :keep_downloaded_archive, :kind_of => [TrueClass, FalseClass], :default => false
