module GetttingStartedBalloons
  module Helpers
    
    def getting_started_balloon(target_selector, *args, &block)
      options = {}
      arg = args.shift
      if arg.is_a?(String)
        content = arg
        options = args.shift || {}
      elsif arg.nil? || arg.is_a?(Hash)
        raise ArgumentError, "Missing block" unless block_given?
        content = capture(&block)
        options = arg || {}
      end
      
      options[:content] = content
      js_options = options.map do |k,v|
        case k
        when :close
          "\"#{k}\": #{v}"
        else
          "\"#{k}\": #{v.to_json}"
        end
      end
      
      # Make sure that everything is loaded before we try to place the balloon.
      "(function(){
        function createBalloon() {
          setTimeout(function() {
            $('#{target_selector}').gettingStartedBalloon({#{js_options.join(',')}});
          }, 500);
        };
        
        $(function() { createBalloon(); });
        $(document).one('page:change', function() { createBalloon(); });
      })();".html_safe
    end
  end
end