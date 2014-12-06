desc 'Commit the code'
task :commit do
  $LOAD_PATH << File.expand_path('../..', __FILE__)

  puts 'Loading models:'

  Maglev.persistent do
    load './models/entity.rb'
    Dir['./models/*.rb'].each do |model|
      next if model =~ /entity\.rb$/
      puts '  - %s' % File.basename(model)
      load model
    end
  end
  Maglev.commit
end
