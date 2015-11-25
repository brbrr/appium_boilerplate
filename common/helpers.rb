require 'rspec'
require 'selenium-webdriver'
require 'appium_lib'

require 'yaml'
require 'pry'

# load all of the support files
Dir["#{File.dirname(__FILE__)}/utils/*_helper.rb"].each { |h| require h }
