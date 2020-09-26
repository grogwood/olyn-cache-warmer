# Begin loop through each URL in our saved temporary file generated from the sitemap routine
File.readlines(node[:olyn_warmer][:cache][:path]).each do |raw_url|

  # Clean trailing spaces from the URL
  url = raw_url.strip

  # Purge the URL from cache
  execute "purge #{url}" do
    command "curl #{node[:olyn_warmer][:purge][:flags].join(' ')} #{node[:olyn_warmer][:purge][:command]} #{url}"
    action :run
  end

  # Request the URL again
  http_request url do
    url url
    action :get
    headers({})
  end

end
