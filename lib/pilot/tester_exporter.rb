require "fastlane_core"

module Pilot
  class TesterExporter < Manager
    def export_testers(options)

      raise "Export file path is required".red unless options[:testers_file_path]

      start(options)
      require 'csv'

      testers = Spaceship::Tunes::Tester::External.all

      file = config[:testers_file_path]

      CSV.open(file, "w") do |csv|

        csv << ['First', 'Last', 'Email', 'Devices', 'Groups', 'Installed Version', 'Install Date']

        testers.each do |tester|

          groups = tester.raw_data.get("groups")

          group_names = ""
          if groups && groups.length > 0
            names = groups.map { |group| group["name"]["value"] }
            group_names = names.join(';')
          end

          csv << [tester.first_name, tester.last_name, tester.email, tester.devices.count, group_names]
        end

        Helper.log.info "Successfully exported CSV to #{file}".green
      end

    end
  end
end
