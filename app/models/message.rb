class Message < ActiveRecord::Base
  validates :body, presence: true
  validates :to, presence: true
  validates :from, presence: true
  before_create :send_message

  def formatted_number(number)
    if number.length == 10
      result = "("
      result += number[0,3]
      result +=  ") "
      result += number[3,3]
      result += "-"
      result += number[6,4]
    elsif number.length == 7
      result += number[0,3]
      result += "-"
      result += number[3,4]
    end
  end

  private

  def send_message
    response = RestClient::Request.new(
      :method => :post,
      :url => "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json",
      :user => ENV['TWILIO_ACCOUNT_SID'],
      :password => ENV['TWILIO_AUTH_TOKEN'],
      :payload => { :Body => body,
                    :To => to,
                    :From => from }
    ).execute
  end

end
