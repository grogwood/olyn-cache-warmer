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

# Create an array of URLs we find in sitemaps
urls = []

# Loop through each set of sitemaps in the data bag
data_bag('sitemaps').each do |sitemap_item|

  # Load the data bag item
  sitemap = data_bag_item('sitemaps', sitemap_item)

  # Purge the sitemap URL so it isn't cached
  execute "purge sitemap #{sitemap[:url]}" do
    command "curl #{node[:olyn_warmer][:purge][:flags].join(' ')} #{node[:olyn_warmer][:purge][:command]} #{sitemap[:url]}"
    action :run
  end

  # Process the URLs in the sitemap
  ruby_block "process sitemap #{sitemap[:url]}" do
    block do

      # Load the sitemap from its URL and ignore blank
      sitemap = Nokogiri::XML(open(sitemap[:url])) do |config|
        config.strict.noblanks
      end

      # Loop through each URL found and add it into the list of URLs
      sitemap.css('url loc').each do |url|
        # Add the URL into the list
        urls << url.text
      end

    end
    action :run
  end
end

# Save the harvested URLs to the temp file
template node[:olyn_warmer][:url_file] do
  source 'url_file.erb'
  variables(
    urls: urls
  )
end
