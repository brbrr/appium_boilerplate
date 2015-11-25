require_relative 'requires'

describe 'Send Money' do
  pin_code = USER_TEST[:pin]
  recipient_phone = 79_263_333_333
  recipient_int_phone = 32_499_486_698
  amnt = 23.1
  mess = 'hello there'
  self_phone = USER_TEST[:phone]
  CONTACT = { phone: 79_264_444_444, name: 'Qqqq' }
  invalid_pin = 1234

  before(:all) do
    if pin_code_page.on_page?
      expect(pin_code_page).to be_on_page
      pin_code_page.login pin_code
    end
  end

  before(:each) do
    expect(home_page).to be_on_page
    home_page.navigate(send_money_page)
    expect(send_money_page).to be_on_page
  end

  context 'make transfer' do
    it 'to valid user', depth: :shallow, type: :positive do
      send_money_page.send_money(recipient_phone, amnt, mess)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.confirm_send(pin_code)

      expect(payment_done_page).to be_on_page
      # expect(payment_done_page.amount).to eq amnt
      payment_done_page.click_ok
    end

    it 'to international user', depth: :deep, type: :positive do
      send_money_page.send_money(recipient_int_phone, amnt, mess)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.confirm_send(pin_code, 1)

      expect(payment_done_page).to be_on_page
      # expect(payment_done_page.amount).to eq amnt
      payment_done_page.click_ok
    end

    it 'to blocked user', depth: :deep, type: :positive do
      DB.block_user(recipient_phone)

      send_money_page.send_money(recipient_phone, amnt, mess)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.confirm_send(pin_code, 3)

      expect(payment_done_page).to be_on_page
      # expect(payment_done_page.amount).to eq amnt
      payment_done_page.click_ok

      DB.unblock_user(recipient_phone)
    end
  end

  context 'phone field validation' do
    # implemented
    it 'with empty phone number', depth: :deep, type: :negative do
      send_money_page.send_money(nil)
      expect(toast?(TOAST_COUNTRY_NOT_COVERED)).to be_truthy
      send_money_page.cancel
    end

    it 'to self phone', depth: :shallow, type: :negative do
      send_money_page.send_money(self_phone, amnt)
      expect(toast?(TOAST_CANT_SEND_TO_SELF)).to be_truthy
      send_money_page.cancel
    end

    it 'select from dropdown', depth: :shallow, type: :positive do
      send_money_page.set_beneficiary(CONTACT[:phone], true)
      send_money_page.set_amount(12)
      expect(send_money_page.name_from_field).to include CONTACT[:name]
      debug send_money_page.phone_and_name_from_field

      send_money_page.cancel
    end
  end

  context 'amount validation' do
    it 'with zero amount', depth: :shallow, type: :negative do
      send_money_page.send_money(recipient_phone)
      expect(toast?(TOAST_AMOUNT)).to be_truthy

      send_money_page.cancel
    end

    it 'starting with dot', depth: :deep, type: :positive do
      send_money_page.set_beneficiary(recipient_int_phone)
        .set_amount('.12', :custom)
        .click_next

      expect(confirm_send_page).to be_on_page
      confirm_send_page.cancel
    end
  end

  context 'message validation' do
    after(:each) do
      send_money_page.send_money(recipient_phone, amnt, @msg)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.cancel
    end

    it 'very long value' do
      @msg = 'test ' * 50
    end

    it 'russian values' do
      @msg = 'Здесь присутсвует русский текст'
    end

    it 'french values' do
      @msg = 'Très chers compatriotes, vous le savla onnait notre pays oblige à'
    end

    it 'all symbols' do
      @msg = ALL_CHARS
    end
  end

  context 'type pin code' do
    before(:each) do
      send_money_page.send_money(recipient_phone, amnt, mess)
      expect(confirm_send_page).to be_on_page
    end

    it 'incorrect', depth: :shallow, type: :negative do
      confirm_send_page.confirm_send(invalid_pin)

      confirm_send_page.on_page?
      expect(toast?(TOAST_INVALID_LOGIN)).to be_truthy
      send_money_page.cancel
    end

    it 'clear and type', depth: :deep, type: :positive do
      confirm_send_page.click_confirm
        .type_pin_code('123ddd')
        .type_pin_code(pin_code)

      expect(payment_done_page).to be_on_page
      # expect(payment_done_page.amount).to eq amnt
      payment_done_page.click_ok
    end

    it 'mistaken', depth: :deep, type: :positive do
      confirm_send_page.confirm_send(invalid_pin)

      confirm_send_page.on_page?
      expect(toast?(TOAST_INVALID_LOGIN)).to be_truthy
      confirm_send_page.confirm_send(pin_code)

      expect(payment_done_page).to be_on_page
      payment_done_page.click_ok
    end

    it 'canceled', depth: :deep, type: :positive do
      confirm_send_page.click_confirm
        .type_pin_code(123)
        .cancel_pin_type

      confirm_send_page.confirm_send(pin_code)

      expect(payment_done_page).to be_on_page
      payment_done_page.click_ok
    end
  end

  context 'fee payer' do
    it 'recipient pays', depth: :deep, type: :positive do
      send_money_page.send_money(recipient_phone, amnt, mess)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.confirm_send(pin_code, 2)

      expect(payment_done_page).to be_on_page
      expect(payment_done_page.amount).to eq amnt
      p payment_done_page.amount
      payment_done_page.click_ok
    end

    it 'shared 50/50', depth: :deep, type: :positive do
      send_money_page.send_money(recipient_phone, amnt, mess)

      expect(confirm_send_page).to be_on_page
      confirm_send_page.confirm_send(pin_code, 3)

      expect(payment_done_page).to be_on_page
      # expect(payment_done_page.amount).to eq amnt
      payment_done_page.click_ok
    end
  end

  context 'error handling' do
    # implemented
    it 'invalid country code', depth: :shallow, type: :negative do
      send_money_page.send_money(87_435)
      expect(toast?(TOAST_COUNTRY_NOT_COVERED)).to be_truthy

      send_money_page.cancel
    end

    it 'invalid phone length', depth: :deep, type: :negative do
      send_money_page.send_money(7_926_423, amnt)
      expect(toast?(TOAST_INVALID_PHONE)).to be_truthy

      send_money_page.cancel
    end

    it 'with amount over users account', depth: :shallow, type: :negative do
      amount = DB.get_account(self_phone)
      debug amount
      send_money_page.send_money(recipient_phone, amount)

      expect(toast?(TOAST_NOT_ENOUGH_MONEY)).to be_truthy
      confirm_send_page.cancel
    end

    it 'with amount over currency limit', depth: :shallow, type: :negative do
      limit = DB.currency_limit(CURRENCY)
      DB.set_account(self_phone, limit + 1000)

      send_money_page.send_money(recipient_phone, limit + 1)

      expect(toast?(TOAST_CURRENCY_LIMIT, pre_pause: 1)).to be_truthy
      confirm_send_page.cancel
    end
  end
end
