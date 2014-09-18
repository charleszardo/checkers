class Piece
  PAWN_MOVES = [[-1, 1], [1, 1]]
  KING_MOVES = [[-1,-1], [1,-1]]

  attr_reader :king, :color, :pos

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    @king = false
  end

  def symbols
    { :white => "◯", :black => "●" }
  end

  def render
    symbols[color]
  end

  def move_diffs
    #checks to see all available moves from current position
    #doesn't consider whether moves are legal or even on board
    d_moves = self.king ? PAWN_MOVES + KING_MOVES : PAWN_MOVES

    #returns array of coordinates of all moves from position
    d_moves.each_with_object([]) do |(dx, dy), moves|
      x, y = self.pos[0], self.pos[1]
      moves << [x + dx, y + dy]
    end
  end

  def perform_moves!

  end

  def perform_slide(pos)

  end

  def perform_jump(pos)

  end

end

