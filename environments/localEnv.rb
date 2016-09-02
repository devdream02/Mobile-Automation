require 'selenium-webdriver'
require 'rspec'
require 'watir-webdriver'
require 'watir-webdriver/wait'
require 'yaml'
require 'rspec/expectations'
require 'cucumber'
require 'time'
require 'appium_lib'
require_relative '../environments/appium_class'
require_relative '../IVSDM/IVSDM_JSON'


@@report_path = "html_reports"
FileUtils.rm Dir.glob(@@report_path + "/*")
$local_config= YAML.load_file('../host_config/local_handset.yml')
$data_url = $local_config["android"]["data_url"]
$serverIP = $local_config["android"]['serverIP']
$port = $local_config["android"]['port']

Before do |scenario|
  $device = ENV['handset']
  $testType= ENV['os']
  @envtype = ENV['envtype']
  # Start the local appium server
  # $pid = spawn('appium --log-level error:debug')
  # This sleep is required to give the server enough time to start finish it's startup
  # sleep(15)
  # Process.detach($pid)

    case $testType
      when 'android'
        opts = {
            "appium_lib" => {
                "server_url" => "http://#{$serverIP}:#{$port}/wd/hub"
            },
            "caps" => {
                "platformName" => $local_config["android"]['platformName'],
                "appActivity" => $local_config["android"]['appActivity'],
                'newCommandTimeout'=> 900,
                'noSign' => false,
                'enablePerformanceLogging'=> false,
                "appPackage" =>  $local_config["android"]['appPackage'],
                "deviceName" => $local_config["android"]['handset'],
                "app" => $local_config["android"]['app'],
                "fullReset" => false
            }
        }
        #clears the app data
        pid = spawn('adb shell pm clear au.com.optus.selfservice')
        #to give enough time for process to clear the data
        sleep(5)
        Process.detach(pid)
        Appium::Driver.new(opts)
        Appium.promote_appium_methods AppiumWorld
        $driver.start_driver
        # $driver.manage.timeouts.implicit_wait=60

      when 'ios'
        opts = {
            "appium_lib" => {
                "server_url" => "http://#{$serverIP}:#{$port}/wd/hub"
            },
            "caps" => {
                "platformName" => $local_config['ios']['platformName'],
                "deviceName" => $local_config['ios']['handset'],
                "udid" => $local_config['ios']['udid'],
                "app" => $local_config['ios']['app'],
                'newCommandTimeout'=> 900
            }
        }
        Appium::Driver.new(opts)
        Appium.promote_appium_methods AppiumWorld
        $driver.start_driver
    end

end

def take_screenshot
  # Wait for everything to settle
  sleep 1
  prefix = "png"
  filename = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  filenameJoin = (0...50).map { filename[rand(filename.length)] }.join
	filename = "#{@@report_path}/#{filenameJoin}.#{prefix}"
	screenshot filename
	Dir.chdir(File.dirname(filename))
	embed(File.basename(filename), "image/png")
	rootdir = File.expand_path("..",Dir.pwd)
	Dir.chdir rootdir
end


After do |scenario|
      take_screenshot
      $driver.driver_quit
end

at_exit do
  #DO NOT REMOVE THE BELOW LINE
   # mobile_handset_server_stop_json $device
  # Process.kill "TERM" , $pid
end


