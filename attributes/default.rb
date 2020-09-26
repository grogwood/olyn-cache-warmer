# Temp file for URL compilation
# todo Move this to the app data folder
# todo multiple files for each site map, instead of one file
default[:olyn_warmer][:cache][:path] = "#{Chef::Config[:file_cache_path]}/olyn_warmer.urls"

# Purge command
default[:olyn_warmer][:purge][:command] = 'PURGE'
default[:olyn_warmer][:purge][:flags]   = ['-v', '-k', '-X']
