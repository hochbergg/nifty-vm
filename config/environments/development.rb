Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_templates] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:log_auto_flush ] = true
  c[:ignore_tampered_cookies] = true
  c[:log_level] = :debug

	c[:auto_load_schema] = true
	c[:auto_generate_js] = true
	
	c[:nifty_q] = {
		:provider => :sequel,
		:provider_options => {},
		:use_default_db => true
	}
}

