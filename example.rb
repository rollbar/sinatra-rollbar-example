require 'sinatra'
require 'rollbar'

configure do
  Rollbar.configure do |config|
    config.access_token = 'aaaabbbbccccddddeeeeffff00001111'
    config.environment = Sinatra::Base.environment
    config.root = Dir.pwd
  end
end

error do
  # 
  Rollbar.report_message("Custom message")
  #
  Rollbar.report_exception(env['sinatra.error'])
  #
  "error"
end



get '/' do
  raise RuntimeError, "custom message"
  "Hello world!"
end

