require 'sinatra'
require 'rollbar'

configure do
  Rollbar.configure do |config|
    config.access_token = 'aaaabbbbccccddddeeeeffff00001111'
    config.environment = 'sinatra-test'
    config.root = Dir.pwd
  end
end

get '/' do
  begin
    foo = bar
  rescue => e
    Rollbar.report_exception(e)
  end

  Rollbar.report_message("test message")

  "Hello world!"
end

