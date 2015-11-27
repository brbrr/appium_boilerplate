require 'rspec'
require 'appium_lib'
require 'page-object'
require 'pry'

require_relative '../pages/pin_code_page'

describe 'Test' do

    before(:all) do
      caps = Appium.load_appium_txt(file: File.join(Dir.pwd, '/appium.txt'))
      @driver = Appium::Driver.new(caps)
      @driver.start_driver
      Appium.promote_singleton_appium_methods Android
      include Android
    end

    it 'should type pin_code' do
      binding.pry
      # pin_code = { id: 'com.accelior.mars.monniz:id/pin_code' }
      # #field = Selenium::WebDriver::Wait.new(timeout: 5).until { @driver.find_element pin_code }
      # field = @driver.wait(timeout: 5) { @driver.find_element pin_code }
      # field.clear
      # field.send_keys '1111'
    end

    after(:all) do
      @driver.driver_quit
    end
  end
