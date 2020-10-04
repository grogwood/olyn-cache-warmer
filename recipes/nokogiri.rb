# Install the nokogiri gem into ruby
gem_package 'nokogiri' do
  action :install
end

# Install the nokogiri gem into chef
chef_gem 'nokogiri' do
  action :install
end

# Test all required gems and libraries are installed
begin
  require 'open-uri'
  require 'nokogiri'
rescue LoadError
  warn 'Required gems and libraries need to be installed this run'
  return 1
end
