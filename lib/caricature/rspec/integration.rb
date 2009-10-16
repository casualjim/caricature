module Caricature
  module RSpecAdapter

    def setup_mocks_for_rspec
      # No setup required
    end

    def verify_mocks_for_rspec
    end

    def teardown_mocks_for_rspec
    end
  end

  module RSpecMatchers

    class HaveReceived
      def initialize(expected)
        @expected = expected
        @block_args, @error, @args = nil, "", [:any]
      end

      def matches?(target)
        @target = target

        veri = @target.did_receive?(@expected).with(*@args)
        veri.with_block_args(*@block_args) if @block_args
        result = veri.successful?

        @error = "\n#{veri.error}" unless result

        result
      end

      def failure_message_for_should
        "expected #{@target.inspect} to have received #{@expected}" + @error
      end

      def failure_message_for_should_not
        "expected #{@target.inspect} not to have received #{@expected}" + @error
      end

      # constrain this verification to the provided arguments
      def with(*args)
        ags = *args
        @args = args
        @args = [:any] if (args.first.is_a?(Symbol) and args.first == :any) || ags.nil?
        # @callback = b if b
        self
      end

      def with_block_args(*args)
        @block_args = args
        self
      end

      # allow any arguments ignore the argument constraint
      def allow_any_arguments
        @args = :any
        self
      end
    end
    
    class HaveRaised
      def initialize(expected)
        @expected = expected
        @block_args, @error, @args = nil, "", [:any]
      end

      def matches?(target)
        @target = target

        veri = @target.did_raise_event?(@expected).with(*@args)
        result = veri.successful?

        @error = "\n#{veri.error}" unless result

        result
      end

      def failure_message_for_should
        "expected #{@target.inspect} to have received #{@expected}" + @error
      end

      def failure_message_for_should_not
        "expected #{@target.inspect} not to have received #{@expected}" + @error
      end

      # constrain this verification to the provided arguments
      def with(*args)
        ags = *args
        @args = args
        @args = [:any] if (args.first.is_a?(Symbol) and args.first == :any) || ags.nil?
        # @callback = b if b
        self
      end

      # allow any arguments ignore the argument constraint
      def allow_any_arguments
        @args = :any
        self
      end
    end

    def have_received(method_name, *args)
      HaveReceived.new(method_name).with(*args)
    end

    def have_raised(event_name, *args)
      HaveRaised.new(event_name).with(*args)
    end
  end
end

#Spec::Runner.configure do |config|
#  config.mock_with Caricature::RSpecAdapter
#  config.include Caricature::RSpecMatchers
#end
