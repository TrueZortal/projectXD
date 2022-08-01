class Inputs
  def self.get
    call_gets.downcase
  end

  def self.get_position
  call_gets.split(',')
  end

  def self.call_gets
    gets.chomp
  end
end