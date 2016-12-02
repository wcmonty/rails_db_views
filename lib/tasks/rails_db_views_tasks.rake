namespace :db do

  desc "Generate all the database views of the current project"
  task :create_views => :environment do
    creator = RailsDbViews::DbViewsCreator.new

    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    views_path.each do |path|
      creator.register_files Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    creator.create_views
  end

  desc "Drop all the database views of the current project"
  task :drop_views => :environment do
    creator = RailsDbViews::DbViewsCreator.new

    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    views_path.each do |path|
      creator.register_files Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    creator.drop_views
  end

  task :migrate => :environment do
    Rake::Task['db:create_views'].invoke
  end

  task :rollback => :environment do
    Rake::Task['db:create_views'].invoke
  end

  namespace :schema do
    task :load => :environment do
      Rake::Task['db:create_views'].invoke
    end
  end

  namespace :test do
    task :load => :environment do
      Rake::Task['db:create_views'].invoke
    end

    task :prepare => :environment do
      Rake::Task['db:create_views'].invoke
    end
  end
end

# Before
Rake::Task['db:migrate'].enhance(['db:drop_views'])
Rake::Task['db:rollback'].enhance(['db:drop_views'])
Rake::Task['db:schema:load'].enhance(['db:drop_views'])
Rake::Task['db:test:load'].enhance(['db:drop_views'])
Rake::Task['db:test:prepare'].enhance(['db:drop_views'])
