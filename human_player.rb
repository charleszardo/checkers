class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def make_move
    name = self.color.to_s.capitalize
    puts "#{name}, make your move."
    gets.chomp


  end
end