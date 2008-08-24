Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5

  c[:testing] = true
  c[:exception_details] = true
  c[:log_auto_flush ] = true
}

