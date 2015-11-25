module BasePage
  module SendMoneyPage
    class << self
      include BasePage

      FIELD_BENEFICIARY = { id: PACKAGE + ':id/phone' }
      FIELD_AMOUNT = { id: PACKAGE + ':id/amount' }
      FIELD_MESSAGE = { id: PACKAGE + ':id/message' }
      BUTTON_NEXT = { id: PACKAGE + ':id/btn_next' }

      def on_page?
        displayed?(BUTTON_NEXT)
      end

      def set_beneficiary(phone, dropdown = nil)
        # click(FIELD_BENEFICIARY)
        if dropdown
          enter(phone.to_s[0..3], FIELD_BENEFICIARY, true)
          tap_on_text(phone)

        else
          enter(phone, FIELD_BENEFICIARY)
          tap_with_offset(FIELD_BENEFICIARY, 40, 0)
        end
        self
      end

      def set_amount(value, custom = false)
        custom = true if value.is_a? Float
        tap_with_offset(FIELD_AMOUNT, -100, 0)

        enter(value, FIELD_AMOUNT, custom)
        self
      end

      def message=(value)
        enter(value, FIELD_MESSAGE)
        self
      end

      def click_next
        click(BUTTON_NEXT)
        confirm_send_page
      end

      def send_money(phone, amnt = nil, mess = nil)
        set_beneficiary(phone) unless phone.nil?
        set_amount(amnt) unless amnt.nil?
        message = (mess) unless mess.nil?
        click_next
      end

      def name_from_field
        # code here
        locator = '//android.widget.TextView[contains(@resource-id,"phone")]'
        list = find_elements(:xpath, locator)
        list[1].text.split('. ')[1]
      end

      def phone_and_name_from_field
        # code here
        result = []
        locator = '//android.widget.TextView[contains(@resource-id,"phone")]'
        list = find_elements(:xpath, locator)
        result << list[0].text.split('. ')[1]
        result << list[1].text.split('. ')[1]
        result
      end

      def clear_field(field, chars = 7)
        case field
        when :phone
          locator = FIELD_BENEFICIARY
          chars = 12
        when :amount
          locator = FIELD_AMOUNT
        end
        click(locator)
        # move to rightmost
        chars.times { press_keycode 22 }
        # deleting
        chars.times { press_keycode 67 }
      end
    end # self
  end # SendMoneyPage
end # BasePage

module Kernel
  def send_money_page
    BasePage::SendMoneyPage
  end
end
