module KaiserRuby
  module Refinements
    refine Integer do
      alias_method :old_add, :+
      def +(other)
        if other.is_a? String
          self.to_s + other
        else
          self.old_add(other)
        end
      end
    end

    refine Float do
      alias_method :old_add, :+
      def +(other)
        if other.is_a? String
          self.to_s + other
        else
          self.old_add(other)
        end
      end
    end

    refine String do
      alias_method :old_add, :+
      def +(other)
        unless other.is_a? String
          self + other.to_s
        else
          self.old_add(other)
        end
      end
    end
  end
end