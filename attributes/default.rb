# Temp file for URL compilation
default[:olyn_warmer][:url_file] = "#{Chef::Config[:file_cache_path]}/olyn_warmer.urls"

# Purge command
default[:olyn_warmer][:purge][:command] = 'PURGE'
default[:olyn_warmer][:purge][:flags]   = ['-v', '-k', '-X']