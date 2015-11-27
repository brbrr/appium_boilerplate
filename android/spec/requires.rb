# require the android pages
require 'pry'
require 'require_all'
require_relative '../pages/base_page'
require_all 'pages/*.rb'
# puts '=='*10, Dir["#{File.dirname(__FILE__)}/pages/*_page.rb"].each {|r| load r }
# Dir[File.dirname(__FILE__) + '/pages/*.rb'].each do |file|
#   binding.pry
#   require file
# end

# setup rspec | ONLY AFTER PAGES!
require_relative '../../common/spec_helper'

include OCRHelper
include ConstHelper
