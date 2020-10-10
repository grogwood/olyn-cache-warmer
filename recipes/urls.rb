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

    # Pull the URL into an object for manipulation
    url_object = URI.parse(url)

    # Get the base file name and query string
    url_filename = url_object.path.split('/').last
    url_query_string = if url_object.query.nil?
                         ''
                       else
                         url_object.query.insert(0, '?')
                       end

    # If this is a URL with no base file name, add the default file name to the URL (required for litespeed cache purge)
    purge_url = if url_filename.nil? || File.extname(url_filename).empty?
                  URI.join("#{url_object.scheme}://#{url_object.host}#{url_object.path}", "index.php#{url_query_string}")
                else
                  url
                end

    # Purge the URL from the cache
    execute "purge #{purge_url}" do
      command "curl #{node[:olyn_warmer][:purge][:flags].join(' ')} #{node[:olyn_warmer][:purge][:command]} #{purge_url}"
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
