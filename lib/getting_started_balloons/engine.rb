module GettingStartedBalloons
  module Rails
    class Engine < ::Rails::Engine
      initializer "setup for rails" do
        ActionView::Base.send(:include, GetttingStartedBalloons::Helpers)
      end
    end
  end
end