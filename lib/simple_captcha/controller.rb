module SimpleCaptcha #:nodoc
  module ControllerHelpers #:nodoc
    # This method is to validate the simple captcha in controller.
    # It means when the captcha is controller based i.e. :object has not been passed to the method show_simple_captcha.
    #
    # *Example*
    #
    # If you want to save an object say @user only if the captcha is validated then do like this in action...
    #
    #  if simple_captcha_valid?
    #   @user.save
    #  else
    #   flash[:notice] = "captcha did not match"
    #   redirect_to :action => "myaction"
    #  end
    def simple_captcha_valid?(object = nil)
      return true if SimpleCaptcha.always_pass
      return @_simple_captcha_result unless @_simple_captcha_result.nil?

      captcha_params = object && params[object] || params

      if captcha_params[:captcha]
        data = SimpleCaptcha::Utils::simple_captcha_value(captcha_params[:captcha_key] || session[:captcha])
        result = data == captcha_params[:captcha].delete(" ").upcase
        SimpleCaptcha::Utils::simple_captcha_passed!(session[:captcha]) if result
        @_simple_captcha_result = result
        result
      else
        false
      end
    end
  end
end
