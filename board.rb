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
  end

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
    x, y = pos[0], pos[1]
    @grid[x][y] = piece
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def render
    #counter used as an index for tile colors
    counter = 0

    alpha = ("A".."H").to_a
    puts "   0  1  2  3  4  5  6  7"

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
    [pos[0], pos[1]].all? {|coord| coord >= 0 && coord < SIZE}
  end

  #returns whether pos has piece
  def has_piece?(pos)
    self[pos].is_a?(Piece)
  end

  ###EVERYTHING BELOW IS FOR TESTING####
  def place_piece(piece, pos)
    self[pos] = piece
  end

  def move(from_pos, to_pos)
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.initial_piece_placements
  b.render

  b.move([0,2], [4,5])
  b.render

end