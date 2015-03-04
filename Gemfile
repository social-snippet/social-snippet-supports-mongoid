source 'https://rubygems.org'

# Specify your gem's dependencies in social_snippet-supports-mongoid.gemspec
gemspec

group :test do
  if ::Dir.exists? "../social-snippet"
    gem "social_snippet", :path => "../social-snippet"
  elsif ENV["TRAVIS"] === "true"
    gem "social_snippet", :github => "social-snippet/social-snippet" # TODO: remove
  end
end

