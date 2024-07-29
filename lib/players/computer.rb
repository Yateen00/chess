require_relative "player"
require_relative "../board/board"
class Computer < Player
  def make_move(board)
    moves = board.check_moves(color) if board.check?(color)
    return [] if !moves.nil? && moves.empty?

    move = board.random_move(color, moves)

    board.move_piece(*move, moves)
    move
  end
end
