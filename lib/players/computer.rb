class Computer
  def play_turn(board)
    moves = board.check_moves(color) if board.check?(color)
    move = random_move(board, moves)
    return [] if move.empty?

    board.move_piece(*move, moves)
    move
  end
end
