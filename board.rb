require_relative 'piece.rb'
require 'colorize'

class Board
  SIZE = 8

  attr_accessor :grid

  def self.make_grid
    Array.new(SIZE) { Array.new(SIZE) }
  end

  def initialize
    @grid = self.class.make_grid
    self.initial_piece_placements
  end

  #setups board with pieces in their starting positions
  def initial_piece_placements
    self.grid.each_with_index do |row, row_idx|
      row.each_with_index do |cell, cell_idx|
        pos = [row_idx, cell_idx]
        if pos.all? {|coord| coord.even?} || pos.all? {|coord| coord.odd?}
          if row_idx < 3
            self[pos] = Piece.new(self, pos, :white)
          elsif row_idx >= 5
            self[pos] = Piece.new(self, pos, :black)
          end
        end
      end
    end
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def render
    #counter used as an index for tile colors
    counter = 0

    #axis labels
    alpha = ("A".."H").to_a
    puts "   0  1  2  3  4  5  6  7"

    #render tiles and pieces on board
    self.grid.each do |row|
      print "#{alpha.shift} "
      row.each do |cell|
        tile = cell.is_a?(Piece) ? " #{cell.render} " : "   "

        print counter.even? ? tile : tile.on_white
        counter += 1
      end
      counter += 1
      print "\n"

    end
    print "\n"

    nil
  end

  #returns whether pos is on board
  def on_board?(pos)
    pos.all? {|coord| coord.between?(0, SIZE - 1)}
  end

  #returns whether pos has piece
  def has_piece?(pos)
    self[pos].is_a?(Piece)
  end

  def move(from_pos, to_pos)
    raise 'move not on board' if !on_board?(to_pos)

    self[from_pos].update_position(to_pos) if has_piece?(from_pos)
                                              #self[from_pos].nil?
    self[to_pos].update_position(from_pos) if has_piece?(to_pos)
                                              #self[to_pos].nil?
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]

    self[to_pos].king_check
    nil
  end

  ###EVERYTHING BELOW IS FOR TESTING####
  def place_piece(piece, pos)
    self[pos] = piece
  end




end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  piece = b[[2,2]]
  piece2 = b[[5,5]]
  b.render
  piece.perform_moves!("C2 D3")
  b.render
  piece2.perform_moves!("F5 E6")
  piece.perform_moves!("D3 E2")
  piece3 = b[[2,6]]
  piece3.perform_moves!("C6 D7")
  piece4 = b[[1,5]]
  piece4.perform_moves!("B5 C6")
  piece5 = b[[5,1]]
  piece5.perform_moves!("F1 D3 B5")
  b.render
#
#   piece2.perform_moves!("F5 E4")
#   b.render
#   piece.perform_moves!("D3 F5")
#   b.render

  # piece2 = b[[5,3]]
#   piece2.perform_slide([4,2])
#   b.render
#   piece.perform_jump([5,3])
#   b.render
#   piece3 = b[[6,4]]
#   piece3.perform_jump([4,2])
#   b.render
end