Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
}

Merb::BootLoader.after_app_loads do
	Merb::Fixtures.load
end