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

error do
  # To send an arbitrary message:
  Rollbar.report_message("Something went wrong")
  # To send the exception traceback:
  Rollbar.report_exception(env['sinatra.error'])
  
  "error"
end



get '/' do
  raise RuntimeError, "custom message"
  "Hello world!"
end

