class Piece
  PAWN_MOVES = [[ 1, -1], [  1, 1], [ 2, -2], [ 2, 2]]
  KING_MOVES = [[-1, -1], [ -1, 1], [-2, -2], [-2, 2]]

  attr_reader :king, :color, :pos, :board
  attr_accessor :pos

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

  def update_position(new_pos)
    self.pos = new_pos
  end

  def move_diffs
    #checks to see all available moves from current position
    #doesn't consider whether moves are legal or even on board
    d_moves = self.king ? PAWN_MOVES + KING_MOVES : PAWN_MOVES
    new_d = []
    if self.color == :black
      d_moves.each do |x, y|
        new_d << [x * -1, y * -1]
      end
      d_moves = new_d
    end

    #returns array of coordinates of all moves from position
    d_moves.each_with_object([]) do |(dx, dy), moves|
      x, y = self.pos[0], self.pos[1]
      moves << [x + dx, y + dy]
    end
  end

  def perform_moves!

  end

  def perform_slide(pos)
    self.board.move(self.pos, pos) if legal_slide?(pos)
  end

  def legal_slide?(pos)
    raise "there's a piece there!" if self.board.has_piece?(pos)
    raise "that's not in your range of moves!" unless move_diffs.include?(pos)
    true
  end

  def perform_jump(pos)
    mid = find_mid_piece(self.pos, pos)
    self.board.move(self.pos, pos) if legal_jump?(pos, mid)
    self.board[mid] = nil
  end

  def legal_jump?(pos, mid)
    unless self.board.has_piece?(mid) && self.board[mid].color != self.color
      raise "there's no piece to jump!"
    end
    true
  end

  def find_mid_piece(start, final)
    start_x, start_y = start
    final_x, final_y = final
    dx = final_x > start_x ? start_x + 1 : start_x - 1
    dy = final_y > start_y ? start_y + 1 : start_y - 1
    [dx, dy]
  end

end

