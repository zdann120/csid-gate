require "OmniauthAccessGate/version"

module OmniauthAccessGate
end

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class AccessGate < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :access_gate

      option :client_options, {
        :site => "https://csid-gate.herokuapp.com",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          :csid => raw_info["csid"]
          # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
