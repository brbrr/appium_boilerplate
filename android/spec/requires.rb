# require the android pages
require_relative '../page-objects/pages/base_page'
Dir["#{File.dirname(__FILE__)}/pages/*_page.rb"].each { |r| require r }

# setup rspec | ONLY AFTER PAGES!
require_relative '../../common/spec_helper'

include MySQLHelper
include OCRHelper
include ConstHelper

DB = MySQLHelper
