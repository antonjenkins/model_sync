require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('model_sync', '0.1.4') do |p|
  p.description    = "Sync changes to an ActiveRecord model to another model"
  p.url            = "http://github.com/antonjenkins/model_sync"
  p.author         = "Anton Jenkins"
  p.email          = "info@pixellatedvisions.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }