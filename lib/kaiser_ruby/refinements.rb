# frozen_string_literal: true
# rubocop:disable Style/RedundantSelf
module KaiserRuby
  # Rockstar introduces a new type that is similar to JS' undefined
  # Ruby obviously doesn't have that so we have to make our own
  class Mysterious
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

    def !
      true
    end

    def ==(other)
      return true if other.is_a?(KaiserRuby::Mysterious)

      false
    end
  end

  # Breaking Ruby for fun and profit!
  #
  # This module is required to run the code that the transpiler generated, as Rockstar
  # expects somewhat different behaviour of types than Ruby.
  #
  # Not a single method in here is a good idea and you should probably never use this code outside this gem.
  module Refinements
    refine NilClass do
      def to_bool
        false
      end

      def +(other)
        return 'null' + other if other.is_a?(String)

        0 + other
      end

      def -(other)
        return 'null' + other if other.is_a?(String)

        0 - other
      end

      def *(other)
        0 * other
      end

      def /(other)
        0 / other
      end

      def <(other)
        0 < other
      end

      def >(other)
        0 > other
      end

      def <=(other)
        0 <= other
      end

      def >=(other)
        0 >= other
      end

      def ==(other)
        return false if other.is_a?(String) || other.is_a?(KaiserRuby::Mysterious) || other.is_a?(FalseClass) || other.is_a?(TrueClass)

        0 == other
      end

      def to_s
        'null'
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
      alias_method :old_to_s, :to_s

      def to_bool
        self.zero? ? false : true
      end

      def +(other)
        if other.is_a?(String)
          self.to_s + other
        elsif other.is_a?(NilClass)
          self + 0
        else
          self.old_add(other)
        end
      end

      def *(other)
        if other.is_a?(String)
          other * self
        elsif other.is_a?(NilClass)
          self * 0
        else
          self.old_mul(other)
        end
      end

      def /(other)
        raise ZeroDivisionError if other.zero? || other.is_a?(NilClass)

        self.old_div(other)
      end

      def <(other)
        if other.is_a?(String)
          self < Float(other)
        elsif other.is_a?(NilClass)
          self < 0
        else
          self.old_gt(other)
        end
      end

      def <=(other)
        if other.is_a?(String)
          self <= Float(other)
        elsif other.is_a?(NilClass)
          self <= 0
        else
          self.old_gte(other)
        end
      end

      def >(other)
        if other.is_a?(String)
          self > Float(other)
        elsif other.is_a?(NilClass)
          self > 0
        else
          self.old_lt(other)
        end
      end

      def >=(other)
        if other.is_a?(String)
          self >= Float(other)
        elsif other.is_a?(NilClass)
          self >= 0
        else
          self.old_lte(other)
        end
      end

      def ==(other)
        if other.is_a?(TrueClass) || other.is_a?(FalseClass)
          self.to_bool == other
        elsif other.is_a?(String)
          t = Float(other) rescue other
          self.old_eq(t)
        elsif other.is_a?(NilClass)
          self.zero?
        else
          self.old_eq(other)
        end
      end

      def to_s
        self.modulo(1).zero? ? self.to_i.to_s : self.old_to_s
      end
    end

    refine Integer do
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
        if other.is_a?(String)
          self.to_s + other
        elsif other.is_a?(NilClass)
          self + 0
        else
          self.old_add(other)
        end
      end

      def *(other)
        if other.is_a?(String)
          other * self
        elsif other.is_a?(NilClass)
          self * 0
        else
          self.old_mul(other)
        end
      end

      def /(other)
        raise ZeroDivisionError if other.zero? || other.is_a?(NilClass)

        t = self.to_f.old_div(other)
        t.modulo(1).zero? ? t.to_i : t
      end

      def <(other)
        if other.is_a?(String)
          self < Float(other)
        elsif other.is_a?(NilClass)
          self < 0
        else
          self.old_gt(other)
        end
      end

      def <=(other)
        if other.is_a?(String)
          self <= Float(other)
        elsif other.is_a?(NilClass)
          self <= 0
        else
          self.old_gte(other)
        end
      end

      def >(other)
        if other.is_a?(String)
          self > Float(other)
        elsif other.is_a?(NilClass)
          self > 0
        else
          self.old_lt(other)
        end
      end

      def >=(other)
        if other.is_a?(String)
          self >= Float(other)
        elsif other.is_a?(NilClass)
          self >= 0
        else
          self.old_lte(other)
        end
      end

      def ==(other)
        if other.is_a?(TrueClass) || other.is_a?(FalseClass)
          self.to_bool == other
        elsif other.is_a?(String)
          t = Float(other) rescue other
          self.old_eq(t)
        elsif other.is_a?(NilClass)
          self.zero?
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
      alias_method :old_mul, :*

      def to_bool
        self.size.zero? ? false : true
      end

      def __booleanize
        return false if self =~ /\A\bfalse\b|\bno\b|\blies\b|\bwrong\b\Z/i
        return true if self =~ /\A\btrue\b|\byes\b|\bok\b|\bright\b\Z/i

        self
      end

      def +(other)
        other.is_a?(String) ? self.old_add(other) : self + other.to_s
      end

      def *(other)
        if other.is_a?(NilClass)
          self.old_mul(0)
        elsif other.is_a?(String)
          KaiserRuby::Mysterious.new
        else
          self.old_mul(other)
        end
      end

      def <(other)
        if other.is_a?(Float)
          Float(self) < other
        elsif other.is_a?(Integer)
          Integer(self) < other
        else
          self.old_gt(other)
        end
      end

      def <=(other)
        if other.is_a?(Float)
          Float(self) <= other
        elsif other.is_a?(Integer)
          Integer(self) <= other
        else
          self.old_gte(other)
        end
      end

      def >(other)
        if other.is_a?(Float)
          Float(self) > other
        elsif other.is_a?(Integer)
          Integer(self) > other
        else
          self.old_lt(other)
        end
      end

      def >=(other)
        if other.is_a?(Float)
          Float(self) >= other
        elsif other.is_a?(Integer)
          Integer(self) >= other
        else
          self.old_lte(other)
        end
      end

      def ==(other)
        if other.is_a?(TrueClass) || other.is_a?(FalseClass)
          self.__booleanize == other
        elsif other.is_a?(Float)
          t = Float(self) rescue self
          t == other
        elsif other.is_a?(Integer)
          t = Integer(self) rescue self
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
        if other.is_a?(Float) || other.is_a?(Integer) || other.is_a?(NilClass)
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
        if other.is_a?(Float) || other.is_a?(Integer) || other.is_a?(NilClass)
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
          self.size.zero?
        elsif self.is_a?(Float) || self.is_a?(Integer)
          self.zero?
        elsif self.is_a?(NilClass)
          true
        else
          self.old_not
        end
      end
    end
  end
end
