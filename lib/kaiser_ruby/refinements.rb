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
      alias_method :old_mul, :*
      alias_method :old_gt, :<
      alias_method :old_gte, :<=
      alias_method :old_lt, :>
      alias_method :old_lte, :>=

      def to_bool
        self.zero? ? false : true
      end

      def +(other)
        other.is_a?(String) ? self.to_s + other : self.old_add(other)
      end

      def *(other)
        other.is_a?(String) ? other * self : self.old_mul(other)
      end

      def <(other)
        other.is_a?(String) ? self < Float(other) : self.old_gt(other)
      end

      def <=(other)
        other.is_a?(String) ? self <= Float(other) : self.old_gte(other)
      end

      def >(other)
        other.is_a?(String) ? self > Float(other) : self.old_lt(other)
      end

      def >=(other)
        other.is_a?(String) ? self >= Float(other) : self.old_lte(other)
      end
    end

    refine String do
      alias_method :old_add, :+
      alias_method :old_gt, :<
      alias_method :old_gte, :<=
      alias_method :old_lt, :>
      alias_method :old_lte, :>=

      def to_bool
        self.size == 0 ? false : true
      end

      def +(other)
        other.is_a?(String) ? self.old_add(other) : self + other.to_s
      end

      def <(other)
        other.is_a?(Float) ? Float(self) < other : self.old_gt(other)
      end

      def <=(other)
        other.is_a?(Float) ? Float(self) <= other : self.old_gte(other)
      end

      def >(other)
        other.is_a?(Float) ? Float(self) > other : self.old_lt(other)
      end

      def >=(other)
        other.is_a?(Float) ? Float(self) >= other : self.old_lte(other)
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