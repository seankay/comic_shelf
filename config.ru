# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run ComicShelf::Application

require 'resque_scheduler'
require 'resque/scheduler'
require 'resque_scheduler/server'
