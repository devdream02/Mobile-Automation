#------------IVS MyOptus App Automation Environment variables List -------#
#                MANDATORY                                                #
#   token     --- User starting the test		                          #
#   platform  --- android_app or ios_app		                          #
#   handset   --- device name in the DB (mobile_handsets table)           #
#   app		  --- app under test                                          #
#                                                                         #
#                OPTIONAL                                                 #
#   domain    --- ALM Domain to update results                            #
#   project   --- ALM Project name                                        #
#   qctestset --- ALM Testset name-uses regular expression to find        #
#   qcpath    --- ALM Test set path                                       #
#  Example::: qctestset=cycle1 qcpath='Root\Prepaid-unleashed'            #
#------------------------------------------------------------------------ #



$platform = ENV['platform']
require_relative '../../../IVSDM/IVSDM_JSON'


if !ENV['app']
	$app = "nil"
else
	#installable available in the shared location
	$app = ENV['app']
end

if !ENV['token']
	abort "Error: Please enter your token e.g. token=xxxxx if you do not have a token please follow the instructions on the wiki"
else
	$token = ENV['token']
end

case $platform
	when "android_app"
		require_relative '../../../environments/androidAppEnv'
		$testType ='android'
	when "local_app"
		require_relative '../../../environments/localEnv'
		$testType= ENV['os'] || 'android'
	when "ios_app"
		require_relative '../../../environments/iosAppEnv'
		$testType ='ios'
	else
		abort("ERROR: Please specify the platform you wish to test - e.g. platform=android_app OR ios_app OR local_app ")
end