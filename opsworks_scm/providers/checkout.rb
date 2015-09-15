def whyrun_supported?
  true
end

use_inline_resources

action :sync do
  # always converge - used scm resource (git, s3) will handle it
  converge_by("Create resource #{new_resource}}") do

    ssh_wrapper_path = ::File.join(Chef::Config["file_cache_path"], "opsworks_scm_checkout")

    directory "#{new_resource.destination}-delete" do
      path new_resource.destination
      action :delete
      recursive true
    end

    directory "#{new_resource.destination}-create" do
      path new_resource.destination
      action :create
      recursive true
      rights :full_control, "Administrators", :applies_to_children => true, :applies_to_self => true
      inherits false
    end

    case new_resource.type
    when "git"
      ssh_wrapper = nil

      if new_resource.ssh_key
        ssh_identity_file = ::File.join(ssh_wrapper_path, "git_ssh_key")
        ssh_wrapper = ::File.join(ssh_wrapper_path, "ssh_wrapper.bat")

        directory "#{new_resource.ssh_wrapper_path}-create" do
          path ssh_wrapper_path
          action :create
          recursive true
          rights :full_control, "Administrators", :applies_to_children => true, :applies_to_self => true
          inherits false
        end

        file ssh_identity_file do
          content new_resource.ssh_key
          rights :full_control, "Administrators", :applies_to_children => true, :applies_to_self => true
          inherits false
          sensitive true
        end

        template ::File.join(ssh_wrapper_path, "ssh_wrapper.bat") do
          source "ssh_wrapper.bat.erb"
          cookbook "opsworks_scm"
          variables ({
            :ssh_identity_file => ssh_identity_file
          })
          rights :full_control, "Administrators", :applies_to_children => true, :applies_to_self => true
          inherits false
        end
      end

      git "#{new_resource.name}_git" do
        action :checkout
        destination new_resource.destination
        depth nil
        enable_submodules true
        repository new_resource.repository
        revision new_resource.revision
        retries 2
        ssh_wrapper ssh_wrapper
      end

      if new_resource.ssh_key
        directory "#{ssh_wrapper_path}-delete" do
          path ssh_wrapper_path
          action :delete
          recursive true
        end
      end
    when "s3"
      bucket, remote_path = OpsWorks::SCM::S3.parse_uri(new_resource.repository)
      filename = remote_path.split("/")[-1]
      local_file = ::File.join(new_resource.destination, filename)

      s3_file local_file do
        bucket bucket
        remote_path remote_path
        aws_access_key_id new_resource.user
        aws_secret_access_key new_resource.password
        if platform_family?("windows")
          owner "Administrator"
          group "Administrators"
        end
        retries 2
      end

      opsworks_archive local_file do
        destination new_resource.destination
      end

      file local_file do
        action :delete
        not_if { new_resource.keep_downloaded_archive }
      end
    else
      Chef::Log.error "Unsupported type #{new_resource.type}. This should not happen."
    end
  end
end
