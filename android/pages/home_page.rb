module Android
  module HomePage
    class << self
      include BasePage

      # Header
      TITLE = { id: PACKAGE + ':id/title' }
      BALANCE = { id: PACKAGE + ':id/balance' }

      # Main buttons
      SEND_MONEY_BUTTON = { id: PACKAGE + ':id/btn_send_money' }
      REQUEST_PAYMENT_BUTTON = { id: PACKAGE + ':id/request_money' }
      SIGN_OPERATION_BUTTON = { id: PACKAGE + ':id/btn_pay' }

      # Side menu
      AVATAR = { id: PACKAGE + ':id/avatar' }
      MENU_BUTTON = { name: 'Open' }
      TRANSACTION_HISTORY_BUTTON = {}
      S_M_SEND_MONEY_BUTTON = {}
      LOGOUT_BUTTON = { id: PACKAGE + ':id/btn_logout' }

      def on_page?
        info 'checking is Home screen is shown'
        present? SEND_MONEY_BUTTON
        wait_until(10) { !balance.empty? }
      end

      def title
        find(TITLE).text
      end

      def swipe_transaction_history
        arrow = find TOGGLER
        x = arrow.location.x + arrow.size.width / 2
        y = arrow.location.y + arrow.size.height / 2
        swipe start_x: x, start_y: y, end_x: x, end_y: y + 300, touchCount: 1, duration: 1
      end

      def balance
        find(BALANCE).text
      end

      def open_side_menu(swipe = false)
        if swipe
          # swipe opening
        else
        click(MENU_BUTTON)
        end
      end

      def side_menu?
        present?(AVATAR)
      end

      def close_side_menu(swipe = false)
        if swipe
          # swipe opening
        end
      end

      def s_m_transaction_history
      end

      def s_m_send_money
      end

      def logout
        open_side_menu
        click(LOGOUT_BUTTON)
      end

      def navigate(where)
        case where.inspect
        when send_money_page.inspect
          click(SEND_MONEY_BUTTON)
        when '1' # request_payment_page
          click(REQUEST_PAYMENT_BUTTON)
        when '2' # sign_operation
          click(SIGN_OPERATION_BUTTON)
        else
          info "you give me #{where}, but I dont know what is that"
        end
      end
    end # self
  end # HomePage

  def home_page
    HomePage
  end
end # Android
