module BasePage
  module PinCodePage
    class << self
      include BasePage

      FIELD_PIN_CODE = { id: PACKAGE + ':id/pin_code' }
      KEY_ACTION = { id: PACKAGE + ':id/key_action' }

      def type_pin_code(pin_code, custom = false)
        # click(FIELD_PIN_CODE)
        # type_keys(pin_code, FIELD_PIN_CODE)
        clear_pin_field(FIELD_PIN_CODE)
        enter(pin_code, FIELD_PIN_CODE, custom)
      end

      def login(pin_code, custom = false)
        type_pin_code(pin_code, custom) unless pin_code.nil?
        click_login
      end

      def click_login
        click(KEY_ACTION)
      end

      def on_page?
        present? KEY_ACTION
      end

      def clear_pin_field(locator, chars = 6)
        click(locator)
        # move to rightmost
        chars.times { press_keycode 22 }
        # deleting
        chars.times { press_keycode 67 }
      end
    end
  end
end

module Kernel
  def pin_code_page
    BasePage::PinCodePage
  end
end
