module BasePage
  module ConfirmSendPage
    class << self
      include BasePage

      BUTTON_CONFIRM = { id: PACKAGE + ':id/btn_submit' }
      AVATAR = { id: PACKAGE + ':id/avatar' }
      BUTTON_PIN_CANCEL = { id: PACKAGE + ':id/btn_cancel' }

      def on_page?
        present?(BUTTON_CONFIRM)
      end

      def click_fee_payer(who)
        if [1, 2, 3].include?(who)
          path = "//*[@resource-id='#{PACKAGE}:id/fees_paid_by']/*/android.widget.TextView[#{who}]"
          btn_who_pays = { xpath: path }
          click(btn_who_pays)
          self
        else
          fail ArgumentError, 'Invalid value for #fee_payer. should be 1-3'
        end
      end

      def click_confirm
        click(BUTTON_CONFIRM)
        self
      end

      def type_pin_code(pin_code)
        enter(pin_code, nil, :custom)
        self
      end

      def cancel_pin_type
        click(BUTTON_PIN_CANCEL)
      end

      def confirm_send(pin_code, who = nil)
        click_fee_payer(who) unless who.nil?
        click_confirm
        type_pin_code(pin_code)
      end
    end # self
  end # ConfirmSendPage
end # BasePage

module Kernel
  def confirm_send_page
    BasePage::ConfirmSendPage
  end
end
