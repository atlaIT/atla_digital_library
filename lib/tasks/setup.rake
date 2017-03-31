require Rails.root.join('lib', 'importers', 'collection_importer')

namespace :setup do
  desc 'Import a cdri metadata xml export'
  task :import_metadata, [:filepath, :user_email] => :environment do |_t, args|
    file_path = args[:filepath]
    user_email = args[:user_email]
    puts "#{file_path} will import metadata as #{user_email}"
    logger = Logger.new(Rails.root.join('log', 'importer.log'), 10, 1_024_000)
    Atla::CollectionImporter.new(file_path, user_email, logger).process
  end

  desc 'Import files from dir to exsiting works'
  task :import_files, [:dir] => :environment do |_t, args|
    dirs = Dir["#{args[:dir]}/*"]
    logger = Logger.new(Rails.root.join('log', 'file_importer.log'), 10, 1_024_000)
    puts dirs
    dirs.each do |dir|
      image_paths = Dir[dir + '/*']
      puts image_paths
      match_path = dir.match(/([A-Z]+)/)
      next if match_path.nil?
      name_code = match_path[1]
      puts name_code
      collection = Collection.where(name_code: name_code).first
      works = collection.works
      works.each do |work|
        file_path = image_paths.detect do |i|
          i =~ Regexp.new(work.file_name.first, true)
        end
        if file_path.blank?
          msg = "no file for work id #{work.id} in dir #{dir}"
          puts msg
          logger.info(msg)
          next
        end
        File.open(file_path) do |file|
          begin
            work.add_file(file, mime_type: 'image/jpeg', original_name: work.file_name.first)
            work.save
          rescue Exception => e
            msg = "#{e}, could not add file at #{file_path}, to #{work.inspect}"
            puts msg
            logger.error(msg)
          end
        end
      end
    end
  end
end