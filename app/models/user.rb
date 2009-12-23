class User < ActiveRecord::Base
  
  is_gravtastic :email
  
  acts_as_authentic do |c| 
    c.validate_login_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
    # fetch email by ax
    # c.openid_required_fields = [:nickname, :email]
    c.openid_required_fields = [
                                  "http://axschema.org/contact/email",
                                  "http://axschema.org/namePerson/first",
                                  "http://axschema.org/namePerson/last"
                                 ]
    # c.openid_required_fields = [:email,"http://axschema.org/contact/email"]
    #c.openid_required_fields = [:language, "http://axschema.org/pref/language"]
  end
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.birthday = facebook_session.user.birthday_date
    self.about = facebook_session.user.about_me
    self.locale = facebook_session.user.locale
    #self.website = facebook_session.user.website
  end
  
  def name
    self.first_name + ' ' + self.last_name
  end
  
  private
  
  def map_openid_registration(registration)
    if registration.empty?
      # no email returned
      self.email_autoset = false
    else
      registration_email = registration["http://axschema.org/contact/email"].first
      self.first_name = registration["http://axschema.org/namePerson/first"].first
      self.last_name = registration["http://axschema.org/namePerson/last"].first
      
      # email by sreg
      unless registration_email.nil? && registration_email.blank? 
        self.email = registration_email 
        self.email_autoset = true
      else
        # email by ax
        unless registration['http://axschema.org/contact/email'].nil? && registration['http://axschema.org/contact/email'].first.blank?
          self.email = registration['http://axschema.org/contact/email'].first
          self.email_autoset = true
        else
          # registration-hash seems to contain information other than the email-address
          self.email_autoset = false
        end
      end
    end

  end
  
end