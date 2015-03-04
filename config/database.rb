# Connection.new takes host and port.

host = 'localhost'
port = 27017

env = ENV["RACK_ENV"].to_sym unless ENV["RACK_ENV"].nil?
env ||= :test

database_name = case env
  when :test        then 'social_snippet_mongoid_test'
end

# Use MONGO_URI if it's set as an environmental variable.
Mongoid::Config.sessions =
  if ENV['MONGO_URI']
    {default: {uri: ENV['MONGO_URI'] }}
  else
    {default: {hosts: ["#{host}:#{port}"], database: database_name}}
  end
