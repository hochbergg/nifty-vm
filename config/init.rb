#
# ==== Structure of Merb initializer
#
# 1. Load paths.
# 2. Dependencies configuration.
# 3. Libraries (ORM, testing tool, etc) you use.
# 4. Application-specific configuration.

#
# ==== Set up load paths
#

# Add the app's "gems" directory to the gem load path.
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

# Lib path
Merb.push_path(:lib, Merb.root / "lib") # uses **/*.rb as path glob.

# ==== Dependencies

dependency 'merb-assets'

Merb::BootLoader.after_app_loads do
  dependency 'nifty_base_fieldlets'

	# load schema
 	VM::Schema.load! if Merb.config[:auto_load_schema]
end

# ==== Libraries

# ORM
use_orm :sequel

# TESTING
use_test :rspec

#
# ==== Set up your basic configuration
#

Merb::Config.use do |c|

  # Sets up a custom session id key which is used for the session persistence
  # cookie name.  If not specified, defaults to '_session_id'.
  c[:session_id_key] = '_nifty_session_id'
  
  
  # There are various options here, by default Merb comes with 'cookie', 
  # 'memory' or 'memcached'.  You can of course use your favorite ORM 
  # instead: 'datamapper', 'sequel' or 'activerecord'.
  c[:session_store] = 'memory'
end
