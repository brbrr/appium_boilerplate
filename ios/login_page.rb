module BasePage
  module LoginPage
    class << self
      # include Pages

      FIELD_PHONE_NUMBER = { id: PACKAGE + ':id/phone_number' }
      FIELD_PIN_CODE = { id: PACKAGE + ':id/pin_code' }
      BUTTON_LOGIN = { id: PACKAGE + ':id/btn_login' }

      def type_phone(phone_number = nil)
        p FIELD_PHONE_NUMBER
        phone_field = base_page.find(FIELD_PHONE_NUMBER)
        base_page.type(phone_number, phone_field)
      end

      def type_pin_code(pin_code)
        pin_filed = base_page.find(FIELD_PIN_CODE)
        base_page.type(pin_code, pin_filed)
      end

      def login_with(pin_code)
        type_pin_code(pin_code)
        login
      end

      def login
        base_page.click(BUTTON_LOGIN)
      end

      def on_page?
        base_page.present?(FIELD_PIN_CODE)
      end
    end
  end
end

module Kernel
  def login_page
    BasePage::LoginPage
  end
end
