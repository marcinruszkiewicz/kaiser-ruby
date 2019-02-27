module KaiserRuby
  module Refinements
    refine NilClass do
      def to_bool
        false
      end

      def +(other)
        'mysterious' + other if other.is_a?(String)
      end

      def -(other)
        'mysterious' + other if other.is_a?(String)
      end

      def to_s
        'mysterious'
      end
    end

    refine Float do
      alias_method :old_add, :+
      alias_method :old_mul, :*
      alias_method :old_div, :/
      alias_method :old_gt, :<
      alias_method :old_gte, :<=
      alias_method :old_lt, :>
      alias_method :old_lte, :>=
      alias_method :old_eq, :==

      def to_bool
        self.zero? ? false : true
      end

      def +(other)
        other.is_a?(String) ? self.to_s + other : self.old_add(other)
      end

      def *(other)
        other.is_a?(String) ? other * self : self.old_mul(other)
      end

      def /(other)
        raise ZeroDivisionError if other.zero?
        self.old_div(other)
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

      def ==(other)
        if other.is_a?(TrueClass) || other.is_a?(FalseClass)
          self.to_bool == other
        elsif other.is_a?(String)
          t = Float(other) rescue other
          self.old_eq(t)
        else
          self.old_eq(other)
        end
      end
    end

    refine String do
      alias_method :old_add, :+
      alias_method :old_gt, :<
      alias_method :old_gte, :<=
      alias_method :old_lt, :>
      alias_method :old_lte, :>=
      alias_method :old_eq, :==

      def to_bool
        self.size == 0 ? false : true
      end

      def __booleanize
        if self =~ /\A\bfalse\b|\bno\b|\blies\b|\bwrong\b\Z/i
          return false
        elsif self =~ /\A\btrue\b|\byes\b|\bok\b|\bright\b\Z/i
          return true
        end

        return self
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

      def ==(other)
        if other.is_a?(TrueClass) || other.is_a?(FalseClass)
          self.__booleanize == other
        elsif other.is_a?(Float)
          t = Float(self) rescue self
          t == other
        else
          self.old_eq(other)
        end
      end
    end

    refine TrueClass do
      alias_method :old_eq, :==

      def to_bool
        true
      end

      def +(other)
        return 'true' + other if other.is_a?(String)
        other.even? ? self : !self
      end

      def -(other)
        other.even? ? self : !self
      end

      def ==(other)
        if other.is_a?(Float)
          self == other.to_bool
        elsif other.is_a?(String)
          self.old_eq(other.__booleanize)
        else
          self.old_eq(other)
        end
      end
    end

    refine FalseClass do
      alias_method :old_eq, :==

      def to_bool
        false
      end

      def +(other)
        return 'false' + other if other.is_a?(String)
        other.even? ? self : !self
      end

      def -(other)
        other.even? ? self : !self
      end

      def ==(other)
        if other.is_a?(Float)
          self == other.to_bool
        elsif other.is_a?(String)
          self.old_eq(other.__booleanize)
        else
          self.old_eq(other)
        end
      end
    end

    refine BasicObject do
      alias_method :old_not, :!

      def !
        if self.is_a?(String)
          return self.size == 0 ? true : false
        elsif self.is_a?(Float)
          return self.zero? ? true : false
        elsif self.is_a?(NilClass)
          return true
        else
          self.old_not
        end
      end
    end
  end
end
