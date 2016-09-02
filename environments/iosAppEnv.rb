require 'rspec/expectations'
require 'appium_lib'
require 'cucumber/ast'
require_relative 'appium_class'
require_relative '../IVSDM/IVSDM_JSON'
@@report_path = "html_reports"
FileUtils.rm Dir.glob(@@report_path + "/*")

def take_screenshot
	# Wait for everything to settle
	sleep 1
	prefix = "png"
	filename = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
	filenameJoin = (0...50).map { filename[rand(filename.length)] }.join
	screenshot "#{@@report_path}/#{filenameJoin}.#{prefix}"
	embed(File.basename("#{@@report_path}/#{filenameJoin}.#{prefix}"), "image/png")
end

Before do |scenario|
  @envtype = ENV['envtype']
	$device = ENV['handset']
	$data_url = 'http://10.10.194.93/index.php?data='
	if $passthrough.nil?
		mobile_handset_server_start_json $device
	end

	case $testType
		when 'android'
			abort 'Please use the Android automation Suite to test the Android App'

		when 'ios'
			opts = {
					"appium_lib" => {
							"server_url" => "http://#{$serverIP}:#{$port}/wd/hub"
					},
					"caps" => {
							"platformName" => 'ios',
							"deviceName" => 'PEIIVSAUTOMATION',
							"udid" 		=> $udid,
							"app" 		=> $app_path,
							"name"  	=> "IVS Automation"
					}
			}
			Appium::Driver.new(opts)
			Appium.promote_appium_methods AppiumWorld
			sleep(10)
			$driver.start_driver
	end
end

After do |scenario|
	take_screenshot
end

at_exit do
	#DO NOT REMOVE THE BELOW LINE
	mobile_handset_server_stop_json $device
	$driver.driver_quit
end