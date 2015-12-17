# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

Rake::Task['test:run'].clear

namespace :test do

  Rake::TestTask.new(:_run) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb'].exclude(
      'test/features/**/*_test.rb'
    )
  end

  Rake::TestTask.new('features' => 'test:prepare') do |t|
    t.libs << 'test'
    t.pattern = 'test/features/**/*_test.rb'
  end

  task :run => ['test:_run']

end
