module OpsWorks
  module Archive
    module Helper
      def tar
        "#{::File.dirname($PROGRAM_NAME)}/tar"
      end
    end
  end
end
