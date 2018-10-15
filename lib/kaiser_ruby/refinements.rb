module KaiserRuby
  module Refinements
    refine Integer do
      alias_method :old_add, :+
      def +(other)
        other.is_a?(String) ? self.to_s + other : self.old_add(other)          
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