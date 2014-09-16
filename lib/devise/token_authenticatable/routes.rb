module ActionDispatch::Routing
  class Mapper
    protected

      def devise_authentication_token(mapping, controllers)
        resource :authentication_token, :only => [:create], :path => :authentication_token, :controller => controllers[:authentication_token]
      end
  end
end
