begin
  require 'active_model'
rescue LoadError => e
  retry if require('rubygems')
end

require File.expand_path('../modest_model/hash', __FILE__)

module ModestModel
  autoload :Object, File.expand_path('../modest_model/object', __FILE__)
end