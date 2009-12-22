class UserSession < Authlogic::Session::Base
  # TODO: auto_register does NOT fetch email etc.. http://stackoverflow.com/questions/1748629/authlogic-autoregister-feature-using-my-options
  # auto_register
  logout_on_timeout true

end