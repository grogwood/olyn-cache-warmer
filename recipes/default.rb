# Check to make sure there are sitemaps to work with
sitemaps =
  begin
    data_bag('sitemaps')
  rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
    nil
  end

# Install nokogiri gem
include_recipe 'olyn_warmer::nokogiri'

# Include the sitemap parsing recipe
include_recipe 'olyn_warmer::sitemaps' if sitemaps

# Warm the URLs found in the sitemaps
include_recipe 'olyn_warmer::urls' if sitemaps
