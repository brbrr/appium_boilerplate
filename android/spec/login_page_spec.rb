require_relative '../spec/requires'

describe 'Login' do
  before(:all) do
    expect(pin_code_page).to be_on_page
    @phone = USER_TEST[:phone]
    @pin_code = USER_TEST[:pin]
    @login_limit = 5

    @invalid_pin = 9999
  end

  it 'successfully', depth: :shallow, positive: true do
    pin_code_page.login(@pin_code)
    expect(home_page).to be_on_page
    expect(home_page.title).to eq 'Your balance'

    home_page.logout
    home_page.start_app
    expect(pin_code_page).to be_on_page
  end

  it 'with empty PIN', depth: :shallow, negavite: true do
    empty_pin = nil

    before_counter = DB.login_attempts(@phone)
    p before_counter
    pin_code_page.login(empty_pin)
    expect(toast?(TOAST_EMPTY_PIN)).to be_truthy
    expect(login_attempts(@phone)).to equal before_counter
  end

  it 'with invalid PIN', depth: :shallow, negavite: true do
    before_counter = DB.login_attempts(@phone)

    pin_code_page.login(@invalid_pin)

    expect(toast?(TOAST_INVALID_LOGIN)).to be_truthy
    expect(DB.login_attempts(@phone)).to be > before_counter
  end

  it 'with long PIN' do
    long_pin = 999_999
    before_counter = DB.login_attempts(@phone)
    pin_code_page.login(long_pin)
    expect(toast?(TOAST_INVALID_LOGIN)).to be_truthy
    expect(DB.login_attempts(@phone)).to be > before_counter
  end

  it 'with blocked user', depth: :deep, negative: true do
    DB.block_user(@phone)
    pin_code_page.login(@pin_code)
    expect(toast?(TOAST_BLOCKED_USER)).to be_truthy

    DB.unblock_user(@phone)
  end

  it 'exceeding login attempts', depth: :deep, negative: true do
    DB.set_login_attempts(10, @phone)
    DB.block_user(@phone)

    pin_code_page.login(@invalid_pin)
    expect(toast?(TOAST_EXCEEDED_LOGIN)).to be_truthy

    DB.set_login_attempts(0, @phone)
    DB.unblock_user(@phone)
  end
end
