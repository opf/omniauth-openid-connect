require_relative '../../../test_helper'

module OmniAuth
  module Strategies
    class LogoutTokenTest < StrategyTestCase

      def encoded_logout_token
        @encoded_logout_token ||= File.read('test/fixtures/logout_token.txt').chomp
      end

      def logout_token
        @logout_token = ::OmniAuth::OpenIDConnect::LogoutToken.decode encoded_logout_token, :skip_verification
      end

      def correct_validation_args
        {
          issuer: 'http://localhost:8080/realms/test',
          client_id: 'http://localhost:3000',
        }
      end

      def test_logout_token_parse
        assert logout_token
        assert_equal '9c6b1b0e-8cd1-4df0-8112-c9380713f16d', logout_token.sid
        assert_equal 'http://localhost:8080/realms/test', logout_token.iss
      end

      def test_logout_verify_success
        assert logout_token.verify!(correct_validation_args)
      end

      def test_logout_verify_invalid_issuer
        expected = correct_validation_args.merge(issuer: 'foobar')

        assert_raises ::OmniAuth::OpenIDConnect::LogoutToken::InvalidIssuer do
          logout_token.verify!(expected)
        end
      end

      def test_logout_verify_invalid_audience
        expected = correct_validation_args.merge(client_id: 'foobar')

        assert_raises ::OmniAuth::OpenIDConnect::LogoutToken::InvalidAudience do
          logout_token.verify!(expected)
        end
      end

      def test_backchannel_logout_phase
        request.stubs(:params).returns('logout_token' => encoded_logout_token)
        strategy.options.issuer = 'http://localhost:8080/realms/test'
        strategy.options.client_options.identifier = 'http://localhost:3000'

        callback = stub
        callback.expects(:call)
        strategy.options.backchannel_logout_callback = callback

        request.stubs(:path).returns('/auth/openidconnect/backchannel-logout')
        strategy.other_phase
      end

      def test_backchannel_logout_phase_invalid_issuer
        strategy.options.issuer = 'example.com'
        strategy.options.client_options.identifier = 'http://localhost:3000'

        callback = stub
        callback.expects(:call).never
        strategy.options.backchannel_logout_callback = callback

        request.stubs(:path).returns('/auth/openidconnect/backchannel-logout')
        assert_raises(OmniAuth::OpenIDConnect::LogoutToken::InvalidIssuer) do
          strategy.perform_backchannel_logout!(encoded_logout_token)
        end
      end

      def test_backchannel_error_response
        strategy
          .stubs(:perform_backchannel_logout!)
          .raises(OmniAuth::OpenIDConnect::LogoutToken::InvalidIssuer.new('foo'))

        strategy.options.backchannel_logout_callback = -> {}

        request.stubs(:path).returns('/auth/openidconnect/backchannel-logout')
        code, _headers, message = strategy.other_phase
        assert 400, code
        assert "foo", message.first
      end

      def test_backchannel_without_callback
        stub = strategy
          .stubs(:perform_backchannel_logout!)

        stub.expects(:call).never

        strategy.options.backchannel_logout_callback = nil

        request.stubs(:path).returns('/auth/openidconnect/backchannel-logout')
        strategy.other_phase
      end
    end
  end
end
