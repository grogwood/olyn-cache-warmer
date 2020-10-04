# Path to the Warmer URL cache directory
default[:olyn_warmer][:cache][:dir] = "#{Chef::Config[:olyn_application_data_path]}/warmer"

# Purge HTTP command
default[:olyn_warmer][:purge][:command] = 'PURGE'

# Flags to use for the Purge command
# -i = Include headers in output
# -v = Verbose output (needed for dev and if URL fails)
# -X = Use proxy
default[:olyn_warmer][:purge][:flags]   = ['-i', '-v', '-X']
