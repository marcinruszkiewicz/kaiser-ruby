require 'kaiser_ruby/refinements'
using KaiserRuby::Refinements

@nodeoperationread = 0
@nodeoperationwrite = 1
@nodevalueignored = 0
@nodevariablevalue = 0
@nodevariableleft = 1
@nodevariableright = 2
def makenode(value, left, righter)
  node = ->(operation, variable, newvalue) do
    if operation == @nodeoperationread
      if variable == @nodevariablevalue
        return value
      end

      if variable == @nodevariableleft
        return left
      end

      if variable == @nodevariableright
        return righter
      end

    end

    if operation == @nodeoperationwrite
      if variable == @nodevariablevalue
        value = newvalue
      end

      if variable == @nodevariableleft
        left = newvalue
      end

      if variable == @nodevariableright
        righter = newvalue
      end

    end

  end

  return node
end

def insertnode(node, newvalue)
  newnode = makenode(newvalue, nil, nil)
  if node == nil
    return newnode
  end

  originalroot = node
  parentnode = nil
  direction = @nodevariableright
  while node != nil
    value = node.call(@nodeoperationread, @nodevariablevalue, @nodevalueignored)
    direction = @nodevariableright
    if newvalue < value
      direction = @nodevariableleft
    end

    parentnode = node
    node = node.call(@nodeoperationread, direction, @nodevalueignored)
  end

  @unusedreturnvalue = parentnode.call(@nodeoperationwrite, direction, newnode)
  return originalroot
end

def inorder(node)
  if node == nil
    return nil
  end

  left = node.call(@nodeoperationread, @nodevariableleft, @nodevalueignored)
  @unusedreturnvalue = inorder(left)
  value = node.call(@nodeoperationread, @nodevariablevalue, @nodevalueignored)
  puts (value).to_s
  righter = node.call(@nodeoperationread, @nodevariableright, @nodevalueignored)
  @unusedreturnvalue = inorder(righter)
  return nil
end

def main(root)
  root = insertnode(root, 10097)
  root = insertnode(root, 32533)
  root = insertnode(root, 76520)
  root = insertnode(root, 13586)
  root = insertnode(root, 34673)
  root = insertnode(root, 54876)
  root = insertnode(root, 80959)
  root = insertnode(root, 9117)
  root = insertnode(root, 39292)
  root = insertnode(root, 74945)
  root = insertnode(root, 37542)
  root = insertnode(root, 4805)
  root = insertnode(root, 64894)
  root = insertnode(root, 74296)
  root = insertnode(root, 24805)
  root = insertnode(root, 24037)
  root = insertnode(root, 20636)
  root = insertnode(root, 10402)
  root = insertnode(root, 822)
  root = insertnode(root, 91665)
  @unusedreturnvalue = inorder(root)
end

@unusedreturnvalue = main(nil)
