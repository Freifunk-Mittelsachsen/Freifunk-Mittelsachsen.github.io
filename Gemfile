source 'https://rubygems.org'

require 'json'
require 'net/http'
versions = JSON.parse(Net::HTTP.get(URI('https://pages.github.com/versions.json')))

gem 'github-pages', versions['github-pages']
gem 'jekyll'
gem 'jekyll-paginate'
gem 'rake'

#gem 'jekyll-admin', group: :jekyll_plugins
