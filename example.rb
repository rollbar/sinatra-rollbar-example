require 'sinatra'
require 'rollbar'

set :environment, :production

configure do
  Rollbar.configure do |config|
    config.access_token = 'aaaabbbbccccddddeeeeffff00001111'
    config.environment = Sinatra::Base.environment
    config.root = Dir.pwd
  end
end

# Adapter around the default RequestDataExtractor
class RequestDataExtractor
  include Rollbar::RequestDataExtractor
  def from_rack(env)
    extract_request_data_from_rack(env).merge({
      :route => env["PATH_INFO"]
    })
  end
    
  def rollbar_request_params(env)
    env['action_dispatch.request.parameters'] || {}
  end
end

error do
  # To send an arbitrary message:
  Rollbar.report_message("Something went wrong")
  # To send the exception traceback:
  request_data = RequestDataExtractor.new.from_rack(env)
  Rollbar.report_exception(env['sinatra.error'], request_data)
  
  "error"
end

get '/' do
  raise RuntimeError, "custom message"
  "Hello world!"
end
