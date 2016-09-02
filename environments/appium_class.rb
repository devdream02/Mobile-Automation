# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld

end

World do
  AppiumWorld.new
end
