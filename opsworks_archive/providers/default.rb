Chef::Resource::Execute.send(:include, OpsWorks::Archive::Helper)

def whyrun_supported?
  true
end

use_inline_resources

action :extract do
  converge_by("Create resource #{new_resource}}") do

    case file_type = file_type(new_resource.archive)
    when "x-gzip", "tgz", "gz"
      execute "untar #{new_resource.archive}" do
        command "#{tar} -x -v -z -f \"#{::File.basename(new_resource.archive)}\" -C \"#{new_resource.destination}\""
        cwd ::File.dirname(new_resource.archive)
      end
    when "zip"
      powershell_script "unzip #{new_resource.archive}" do
        code <<-EOH
          $zip_file = Convert-Path("#{new_resource.archive}")
          $target_dir = Convert-Path("#{new_resource.destination}")
          $shell = new-object -com shell.application
          $zip = $shell.NameSpace($zip_file)
          foreach( $item in $zip.items() ) {
            $shell.NameSpace($target_dir).copyhere($item)
          }
        EOH
      end
    else
      fail "Unknown file type #{file_type}"
    end

  end
end

def file_type(archive)
  file_command = Mixlib::ShellOut.new("file -bi \"#{archive}\"")
  file_command.run_command
  file_type = file_command.stdout
  file_command.error!
  file_type.match(/\Aapplication\/(.+);/)[1]
rescue
  Chef::Log.info("Trying to guess file type by extension.")
  ::File.extname(archive).tr(".", "").downcase
end
