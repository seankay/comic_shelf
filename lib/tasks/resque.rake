require 'resque/tasks'
require 'resque_scheduler/tasks'

# task "resque:setup" => :environment

namespace :resque do
  task :setup => :environment do
    require 'resque'
    require 'resque/scheduler'
    require 'resque_scheduler'
    require 'resque_scheduler/server'

    Resque.redis = 'localhost:6379'

    Resque.after_fork do |job|
      ActiveRecord::Base.establish_connection
    end
  end
end
