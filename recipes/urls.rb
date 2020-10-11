# Loop through each set of sitemaps in the data bag
data_bag('sitemaps').each do |sitemap_item|

  # Load the data bag item
  sitemap = data_bag_item('sitemaps', sitemap_item)

  # Skip this sitemap if no URL cache exists
  next unless File.exist?("#{node[:olyn_warmer][:cache][:dir]}/#{sitemap[:id]}.cache")

  # Begin loop through each URL in our saved temporary file generated from the sitemap routine
  File.readlines("#{node[:olyn_warmer][:cache][:dir]}/#{sitemap[:id]}.cache").each do |raw_url|

    # Clean trailing spaces from the URL
    url = raw_url.strip

    # Purge the URL from cache
    execute "purge #{url}" do
      command "curl #{node[:olyn_warmer][:purge][:flags].join(' ')} PURGE #{url}"
      action :run
    end

    # Request the URL again
    http_request url do
      url url
      action :get
      headers({})
    end

  end

end
