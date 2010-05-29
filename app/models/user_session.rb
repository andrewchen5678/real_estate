class UserSession < Authlogic::Session::Base
  authenticate_with UserAuth
  generalize_credentials_error_messages true
end