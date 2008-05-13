module ActionController
  
  module IphoneController
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_iphone_controller(iphone_test_mode = nil)
        include ActionController::IphoneController::InstanceMethods
        if iphone_test_mode 
          before_filter :force_iphone_format
        else
          before_filter :set_iphone_format
        end
        helper_method :is_iphone_request?
      end
      
      def iphone_test_mode?
        @@iphone_test_mode
      end
    end
    
    module InstanceMethods
      
      def force_iphone_format
        request.format = :iphone
      end
      
      def set_iphone_format
        if is_iphone_request? || is_iphone_format? || is_iphone_subdomain?
          request.format = if cookies["browser"] == "desktop" 
                           then :html 
                           else :iphone 
                           end
        end
      end
      
      def is_iphone_format?
        request.format.to_sym == :iphone
      end

      def is_iphone_request?
        request.user_agent =~ /(Mobile\/.+Safari)/
      end
      
      def is_iphone_subdomain?
        request.subdomains.first == "iphone"
      end
    end
    
  end
  
end

ActionController::Base.send(:include, ActionController::IphoneController)