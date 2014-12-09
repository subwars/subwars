desc 'Commit the code'
task :commit do
  $LOAD_PATH << File.expand_path('../..', __FILE__)

  load_proc = Proc.new do |path|
    puts '  - %s' % File.basename(path, '.rb')
    load path
  end

  Maglev.persistent do
    puts 'Loading libs:'
    Dir['./lib/persistent/*.rb'].each do |lib|
      load_proc.call(lib)
    end

    puts 'Loading models:'
    pre_models = %w[ entity geocell geocell_root ]
    pre_models.each do |model|
      load_proc.call("./models/#{model}.rb")
    end
    Dir['./models/*.rb'].each do |model|
      next if pre_models.any?{|pm| model =~ /#{pm}\.rb$/}
      load_proc.call(model)
    end
  end
  Maglev.commit
end
