require 'logger'

# module for intelgence logging
module RestLogger
  LogFormatter = proc do |severity, datetime, _progname, msg|
    "#{severity[0]}: [#{datetime.strftime('%m/%d/%y %H:%M:%S')}] - #{msg}\n"
  end

  @@loggers = {}
  def loggers
    @@loggers
  end

  def add_logger(name, handle)
    new_logger = Logger.new handle
    new_logger.progname = 'tests'
    new_logger.formatter = LogFormatter
    @@loggers[name.to_sym] = new_logger
    new_logger
  end

  def set_log_level(name, level)
    level = Logger.const_get(level.to_s.upcase)
    @@loggers[name.to_sym].level = level
  end

  def log(level, msg)
    @@loggers.each_value { |logger| logger.send(level, msg) }
    msg
  end

  [:fatal, :error, :warn, :info, :debug].each do |log_method|
    define_method log_method do |msg|
      # if msg.to_s.include?("\n")
      #   msg.split("\n").each { |l| log(log_method, l) }
      # else
      log(log_method, msg)
      # end
    end
  end

  def logger
    self
  end
end

RSpec.configure do |config|
  config.include LogHelper

  # log the start of each test to make debugging easier
  config.before(:each) do |example|
    debug ''
    debug '============================='
    debug "Starting test: #{example.full_description}"
    debug "From file    : #{example.file_path}"
    debug '-----------------------------'
  end

  config.after(:each) do |example|
    debug ''
    debug '-----------------------------'
    debug "Completed test: #{example.full_description}"
    debug "From file     : #{example.file_path}"
    if example.exception
      take_screenshot if $DEBUG

      debug "Result        : Fail - #{example.exception}"
      # debug current_activity.to_s
      debug '----------- TEST FAILED -----------'
    else
      debug 'Result        : Pass'
    end
    debug '============================='
  end
end

# setup logging to both console and to a log file
include LogHelper
FileUtils.mkdir_p 'gen/screenshots'
FileUtils.mkdir_p 'gen/reports'
add_logger(:console, STDOUT)
add_logger(:test_run, File.open('gen/reports/test_run.log', 'a'))
# add_logger(:proxy_run, File.open('gen/reports/proxy_test_run.log', 'a'))

set_log_level :console, TCFG.tcfg.fetch('LOG_LEVEL')
set_log_level :test_run, 'debug'
# set_log_level :proxy_run, 'debug'

Appium::Logger.level = Logger::DEBUG
