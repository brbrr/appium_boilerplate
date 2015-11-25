require_relative 'helpers'

# class NavigationListener < Selenium::WebDriver::Support::AbstractEventListener
#       def initialize() end
#       def before_find(by, what, driver) end
#       def before_click(element, driver) end
#     end
#  listener = NavigationListener.new
#  caps[:caps][:listener] = listener

def setup_driver
  return if $driver
  caps = Appium.load_appium_txt file: File.join(Dir.pwd, 'appium.txt')
  Appium::Driver.new caps
  debug "setting up driver using #{caps.to_yaml}"
end

def promote_methods
  info 'promoting methods'
  Appium.promote_singleton_appium_methods BasePage
  # Appium.promote_appium_methods RSpec::Core::ExampleGroup
end

def take_screenshot
  p ex = example.metadata[:description].tr(' ', '_')
  path = "#{Dir.pwd}/gen/screenshots/#{DateHelper.set_log_timestamp + ex}.png"
  debug "screenshot path: #{path}"
  $driver.screenshot(path)
end

def start_proxy
  $t = Thread.new do
    $s = ProxyHelper.init_proxy
    ProxyHelper.start($s)
  end
end

RSpec.configure do |config|
  $env = TCFG.tcfg[:ENV]

  config.before(:all) do
    # config.include AllureRSpec::Adaptor #problems when with #start_proxy
    info 'before :agit add .gitmodulesll config'
    setup_driver
    promote_methods
    $driver.start_driver
    # start_proxy
  end

  config.after(:all) do
    info 'after :all. quiting driver'
    $driver.driver_quit
    # ProxyHelper::stop($s)
  end
end
