# Base module for pages
module BasePage
  PACKAGE = 'com.accelior.mars.monniz'

  TOGGLER = { id: PACKAGE + ':id/btn_toggler' }
  ALERT_TITLE = { id: 'android:id/message' }
  BUTTON_CANCEL = { name: 'Cancel' } # {id: PACKAGE + 'id:/action_cancel'}

  def wait_until(seconds = 5)
    Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
  end

  def find(locator)
    debug "Finding element by: #{locator}"
    wait_until { find_element locator }
  end

  def enter(text, locator, custom = false)
    debug "Sending text: '#{text}'"

    return type_keys(text, locator) if custom
    # if not custom
    field = find(locator)
    field.clear
    field.send_keys text
  end

  def click(locator)
    find(locator).click
  end

  def text?(text)
    wait { text_exact text }
  end

  def click_back
    back
  end

  def submit(locator)
    find(locator).submit
  end

  def get_value(locator)
    find(locator).value
  end

  def get_text(locator)
    find(locator).text
  end

  def text_include?(text, locator)
    find(locator).text.include?(text)
  end

  def displayed?(locator)
    find(locator).displayed?
  rescue Selenium::WebDriver::Error::NoSuchElementError
    info "element is not displayed: #{locator}"
    false
  end

  def present?(locator, secs: 8, size: 0)
    set_wait(secs)
    result = find_elements(locator).size > size
    result = find_element(locator).displayed? if result
    no_wait
    result
  end

  def scroll_to(locator)
    element = find_element(locator)
    execute_script 'mobile: scrollTo', element: element.ref
  end

  def tap_on_text(text)
    pos = OCRHelper.text_position(text)
    tap_on(pos) # pos[:x], pos[:y]
  end

  def tap_on(hash) # x_cord, y_cord
    Appium::TouchAction.new.tap(hash).release.perform # x: x_cord, y: y_cord
  end

  def tap_with_offset(locator, off_x = 0, off_y = 0)
    # by default it is typing in to center of element
    el = find_element(locator)
    loc = el.location
    size = el.size
    debug "element location: #{loc} and size: #{size}"
    offset = {
      x: (loc[:x] + size[:width] / 2 + off_x),
      y: (loc[:y] + size[:height] / 2 + off_y)
    }
    debug "tapping on #{offset}"
    tap_on(offset)
  end

  def background_app
    background_app
  end

  def current_activity
    current_activity
  end

  def start_app
    wait_until(10) { start_driver }
    debug current_activity
  end

  def manage_alert(what)
    debug get_text(ALERT_TITLE)
    alert_click(what)
  end

  def cancel
    click(BUTTON_CANCEL)
    manage_alert(:yes)
  end

  private

  #
  # type @value using custom keyboard
  #   use 'd' to delete 1 char
  #   use '.' for dot key
  #   use '+' for + sign
  #
  # passing empty @value will return nothing
  def type_keys(value, locator)
    str = value.to_s
    # for empty input i.e. login without pin code
    return if str.empty?

    # for cases like pin code dialog in send money screen
    click(locator) unless locator.nil?
    str.each_char do |c|
      if c == '.' || c == '+'
        locator = PACKAGE + ':id/key_action'
      elsif c == 'd'
        locator = PACKAGE + ':id/key_backspace'
      else
        locator = PACKAGE + ':id/key_' + c
      end
      debug "Custom key press: #{locator}"
      click(id: locator)
    end
  end
end

module Kernel
  def base_page
    BasePage
  end
end
