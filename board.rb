require_relative 'piece.rb'
require 'colorize'

class Board
  SIZE = 8

  attr_reader :winner

  attr_accessor :grid

  def self.make_grid
    Array.new(SIZE) { Array.new(SIZE) }
  end

  def initialize
    @grid = self.class.make_grid
    self.initial_piece_placements
    @winner = nil
  end

  def dup
    duped_board = Board.new
    duped_board.clear_board

    self.grid.flatten.compact.each do |piece|
      duped_board[piece.pos] = piece.dup(duped_board)
    end

    duped_board
  end

  #sets up board with pieces in their starting positions
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
    puts "    0  1  2  3  4  5  6  7"

    #render tiles and pieces on board
    self.grid.each do |row|
      letter = " #{alpha.shift} "
      print letter
      row.each do |cell|
        tile = cell.is_a?(Piece) ? " #{cell.render} " : "   "

        print counter.even? ? tile : tile.on_white
        counter += 1
      end
      print letter
      counter += 1
      print "\n"

    end
    puts "    0  1  2  3  4  5  6  7\n"
    puts ""
    puts "Move format: C0 D1\n"
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

  def game_over?
    pieces = self.grid.flatten.compact
    if pieces.each.all? {|piece| piece.color == :white}
      self.winner = :white
      return true
    elsif pieces.each.all? {|piece| piece.color == :black}
      self.winner = :black
      return true
    else
      false
    end
  end

  ###EVERYTHING BELOW IS FOR TESTING####
  def place_piece(piece, pos)
    self[pos] = piece
  end

  ######################################
  protected

  def clear_board
    self.grid = Array.new(SIZE) { Array.new(SIZE) }
  end

end