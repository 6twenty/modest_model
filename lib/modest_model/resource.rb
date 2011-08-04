module ModestModel
  autoload :Tenacity,  File.expand_path('../tenacity',  __FILE__)
  autoload :Callbacks, File.expand_path('../callbacks', __FILE__)
  
  class Resource < Base
    include ModestModel::Tenacity
    include ModestModel::Callbacks
  end
end