class Human
  def start_move(board, moves)
    puts "Enter the start position of the piece you want to move: "
    start = gets.chomp
    until board.valid_starting_tile?(start, color)
      puts "Invalid start position, please enter a valid start position: "
      start = gets.chomp
    end
    board.print_possible_moves(start, moves[start])
    if board.piece_has_moves?(start, moves)
      puts "Do you want to choose another piece? (y/n)"
      start_move(board, moves) if gets.chomp.downcase == "y"
    else
      puts "This piece has no valid moves, please choose another piece: "
      start_move(board, moves)
    end
    start
  end

  def finish_move(board, start, moves)
    puts "Enter the finish position of the piece you want to move: "
    finish = gets.chomp
    until board.move_piece(start, finish, moves[start])
      puts "Invalid finish position, please enter a valid finish position: "
      finish = gets.chomp
    end
    finish
  end

  def play_turn(board)
    moves = nil
    if board.check?(color)
      moves = board.check_moves(color)
      return [] if board.mate?(color, moves)

      print_valid_pieces(board, moves)
    end
    start = start_move(board, moves)
    finish = finish_move(board, start, moves)
    [start, finish]
  end

  def print_valid_pieces(board, moves)
    puts "You are in check, you must move one of the following pieces:"
    puts moves.keys.join(", ")
  end
end
