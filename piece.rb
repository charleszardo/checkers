class Piece
  PAWN_MOVES = [[ 1, -1], [  1, 1], [ 2, -2], [ 2, 2]]
  KING_MOVES = [[-1, -1], [ -1, 1], [-2, -2], [-2, 2]]

  attr_reader :king, :color, :pos, :board
  attr_accessor :pos

  def initialize(board, pos, color, king = false)
    @board, @pos, @color, @king = board, pos, color, king
  end

  def dup(board)
    Piece.new(board, self.pos, self.color, self.king)
  end

  def symbols
    unless self.king
      { :white => "◯", :black => "●" }
    else
      { :white => "W", :black => "B"}
    end
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
    poss_moves = self.king ? PAWN_MOVES + KING_MOVES : PAWN_MOVES
    poss_moves = relative_moves(poss_moves) if self.color == :black

    #returns array of coordinates of all moves from position
    poss_moves.each_with_object([]) do |(dx, dy), moves|
      x, y = self.pos
      moves << [x + dx, y + dy]
    end
  end

  def relative_moves(moves)
    moves.map do |x, y|
      [x * -1, y * -1]
    end
  end

  def valid_move_seq?(sequence)
    dup_board = self.board.dup
    perform_moves!(sequence, self.board.dup)
    begin
    rescue
      return false
    else
      return true
    end
  end

  def perform_moves!(moves, board)
    slides = 0
    jumps = 0
    current_tile = moves.shift
    until moves.empty?
      raise InvalidMoveError.new "can't do multiple slides!" if slides >= 1
      current_move = moves.shift unless moves.empty?
      raise InvalidMoveError.new "that's not in your range of moves!" unless move_diffs.include?(current_move)
      if self.legal_slide?(current_move)
        raise InvalidMoveError.new "can't slide after a jump" if jumps > 0
        self.perform_slide(current_move)
        slides += 1
      else
        self.perform_jump(current_move)
      end
      current_tile = current_move
    end
  end

  def perform_slide(pos)
    raise "there's a piece there!" if self.board.has_piece?(pos)
    self.board.move(self.pos, pos) if legal_slide?(pos)
  end

  def legal_slide?(new_pos)
    difference = new_pos[0] - self.pos[0]
    difference.between?(-1, 1)
  end

  def perform_jump(pos)
    mid = find_mid_piece(self.pos, pos)
    self.board.move(self.pos, pos) if legal_jump?(pos, mid)
    self.board[mid] = nil
  end

  def legal_jump?(pos, mid)
    raise "no piece to jump" if !self.board.has_piece?(mid)
    raise "can't jump your own piece" if self.board[mid].color == self.color
    true
  end

  def find_mid_piece(start, final)
    start_x, start_y = start
    final_x, final_y = final
    dx = final_x > start_x ? start_x + 1 : start_x - 1
    dy = final_y > start_y ? start_y + 1 : start_y - 1
    [dx, dy]
  end

  def king_check
    x = self.pos[0]
    if (self.color == :black && x == 0) || (self.color == :white && x == 7)
      @king = true
    end
  end

end

