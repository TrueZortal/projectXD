class CommandQueue
  def initialize(array_of_commands = [])
    @queue = []
    array_of_commands.each do |command|
      add(command)
    end
  end

  def empty?
    @queue.empty?
  end

  def add(string_element)
    @queue << string_element
  end

  def size
    @queue.size
  end

  def pop
    @queue.shift
  end
end