class Chef
  module ReservedNames::Win32
    module API
      module Installer
        # windows_package resource has a bug for Chef 12.2.1
        # See https://github.com/chef/chef/issues/3316

        if RUBY_PLATFORM =~ /mingw32/
          alias_method :_get_installed_version, :get_installed_version
          def get_installed_version(product_code)
            v = _get_installed_version(product_code)
            v.nil? ? v : v.chomp(0.chr)
          end
        end
      end
    end
  end
end
