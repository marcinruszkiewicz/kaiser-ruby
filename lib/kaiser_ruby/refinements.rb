module KaiserRuby
  module Refinements
    if RUBY_VERSION =~ /2\.3\./
      refine Fixnum do
        alias_method :old_add, :+
        def +(other)
          other.is_a?(String) ? self.to_s + other : self.old_add(other)          
        end
      end
    else
      refine Integer do
        alias_method :old_add, :+
        def +(other)
          other.is_a?(String) ? self.to_s + other : self.old_add(other)          
        end
      end
    end
    
    refine Float do
      alias_method :old_add, :+
      def +(other)
        other.is_a?(String) ? self.to_s + other : self.old_add(other)
      end
    end

    refine String do
      alias_method :old_add, :+
      def +(other)
        other.is_a?(String) ? self.old_add(other) : self + other.to_s 
      end
    end
  end
end