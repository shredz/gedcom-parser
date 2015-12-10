class Stack

  def initialize(elem = nil)
    @stack_arr = [elem].compact
  end

  def push(elem)
    @stack_arr.push(elem)
  end

  def pop
    @stack_arr.pop
  end

  def last_elem
    @stack_arr[-1]
  end

  def empty?
    @stack_arr.empty?
  end

  def clear
    @stack_arr = []
  end

  def length
    @stack_arr.length
  end

end
