require 'zlib'

namespace :db do
  namespace :data do
    def anonymize_helper
      format_class = ENV['class'] || "YamlDb::Anonymizer::Helper"
      require format_class.split('::').first.underscore
      helper = format_class.constantize
    end

    desc 'Dump anonymized database contents to db/data.yml'
    task :dump_anonymized => :environment do
      SerializationHelper::Base.new(anonymize_helper).dump File.join(Rails.root, 'db', "data.#{helper.extension}")
    end

    desc 'Dump anonymized and gzipped database contents to stdout'
    task :dump_anonymized_gzipped_stdout => :environment do
      gz = Zlib::GzipWriter.new($stdout.dup)
      SerializationHelper::Base.new(anonymize_helper).dump_to_io gz
      gz.close
    end
  end
end
