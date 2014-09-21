require_relative 'board'
require_relative 'piece'
require_relative 'human_player'
require_relative 'checkers_errors'

class Game
  attr_accessor :game_over, :turns, :current_player

  attr_reader :player1, :player2, :board, :turns, :players

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @players = [self.player1, self.player2]
    @board = Board.new
    @game_over = false
    @turns = 0
  end

  def play
    until game_over
      self.board.render
      self.current_player = self.players[turns % 2]
      self.play_turn
      self.turns += 1
    end
    self.board.render
  end

  def play_turn
    #ask player for move(s)
    move_seq = current_player.make_move
    #convert move(s) to array of moves
    move_seq_arr = handle_moves(move_seq)

    #starting position
    piece = move_seq_arr[0]

    raise "that's not your piece" if self.board[piece].color != current_player.color

    self.board[piece].perform_moves!(move_seq)
  rescue StandardError => e
    puts "Error: #{e.message}"
    print "\n"
    retry

    self.game_over = self.board.game_over?
  end

  #convert move(s) to array of moves
  def handle_moves(move_sequence)
    moves = move_sequence.split(' ')
    moves.map {|move| move_conversion(move)}
  end

  #converts alpha-numeric moves to numeric-numeric moves so game can understand
  def move_conversion(move)
    alpha = ("a".."h").to_a
    move = move.split('')
    x = alpha.index(move[0].downcase)
    y = move[1].to_i

    move_check(move, x, y)
   
    [x, y]
  end

  #checks to make sure input can be converted to location on grid
  def move_check(move, x, y)
    if x > Board::SIZE || y > Board::SIZE || move.count != 2
      raise InvalidInputError.new "Invalid input, try again."
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new(:white)
  p2 = HumanPlayer.new(:black)
  game = Game.new(p1, p2)
  game.play
end