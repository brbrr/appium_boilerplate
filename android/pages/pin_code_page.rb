module Android
  module PinCodePage
    class << self
      include BasePage

      FIELD_PIN_CODE = { id: PACKAGE + ':id/pin_code' }
      KEY_ACTION = { id: PACKAGE + ':id/key_action' }

      def type_pin_code(pin_code, custom = false)
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
        chars.times { press_keycode 22 }
        chars.times { press_keycode 67 }
      end
    end
  end

  def pin_code_page
    PinCodePage
  end
end
