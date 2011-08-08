begin
  require 'active_model'
rescue LoadError => e
  retry if require('rubygems')
end

module ModestModel
  autoload :Object, File.expand_path('../modest_model/object', __FILE__)
end