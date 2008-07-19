Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false

	c[:auto_load_schema] = true
	c[:auto_generate_js] = true
}