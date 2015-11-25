require 'rspec'
require 'selenium-webdriver'
require 'appium_lib'

require 'yaml'
require 'pry'

# load all of the support files
Dir.glob('./utils/*_helper.rb').each { |h| require h }
