Dir.glob(Merb.root / 'lib/nifty_fieldlets_base/fieldlets/*.rb').each do |f|
	require f
end