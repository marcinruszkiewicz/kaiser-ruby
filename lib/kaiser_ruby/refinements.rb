module KaiserRuby
  module Refinements
    refine NilClass do
      def to_bool
        false
      end

      def +(other)
        'mysterious' + other if other.is_a?(String)
      end

      def to_s
        'mysterious'
      end
    end
    
    refine Float do
      alias_method :old_add, :+
      def +(other)
        other.is_a?(String) ? self.to_s + other : self.old_add(other)
      end

      def to_bool
        return false if self.zero?
        true
      end
    end

    refine String do
      alias_method :old_add, :+
      def +(other)
        other.is_a?(String) ? self.old_add(other) : self + other.to_s 
      end

      def to_bool
        return false if self.size == 0

        true
      end
    end

    refine TrueClass do
      def to_bool
        true
      end

      def +(other)
         'true' + other if other.is_a?(String)
      end
    end

    refine FalseClass do
      def to_bool
        false
      end

      def +(other)
        'false' + other if other.is_a?(String)
      end
    end
  end
end