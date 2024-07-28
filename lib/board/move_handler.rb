module MoveHandler
  protected

  def remove_castling(moves, row, col)
    moves.delete([row, col + 2])
    moves.delete([row, col - 2])
    moves
  end

  def handle_move(row, col, finish_row, finish_col, piece)
    case piece
    when Pawn
      handle_en_passant(row, col, finish_row, finish_col, piece)
      piece = handle_promotion(finish_row, finish_col, piece) || piece
    when King
      piece.first_move = false
      handle_castling(row, col, finish_row, finish_col, piece)
    when Rook
      piece.first_move = false
    end
    set_piece(finish_row, finish_col, piece)
    set_piece(row, col, nil)
    remove_en_passant
  end

  def remove_en_passant
    return if previous_move.nil?

    previous_piece = get_piece(previous_move[1][0], previous_move[1][1])
    return unless previous_piece.instance_of?(Pawn)

    previous_piece.took_double_step = false
  end

  def handle_en_passant(row, col, finish_row, finish_col, piece)
    return piece.took_double_step = true if (row - finish_row).abs == 2
    return if previous_move.nil?

    previous_piece = get_piece(*previous_move[1])
    captured = previous_piece.instance_of?(Pawn) &&
               (previous_move[1][0] - previous_move[0][0]).abs == 2 &&
               !enemy_tile?(piece.color, finish_row, finish_col)
    set_piece(*previous_move[1], nil) if captured
  end

  def handle_promotion(row, col, piece)
    return nil unless (piece.color == :white && row == 0) || (piece.color == :black && row == 7)

    puts "Promote to: (queen, rook, bishop, knight)"
    promotion = gets.chomp.downcase.to_sym
    until %i[queen rook bishop knight].include?(promotion)
      puts "Invalid promotion"
      promotion = gets.chomp.downcase.to_sym

    end
    create_piece(piece.color, promotion)
  end

  def handle_castling(row, col, finish_row, finish_col, piece)
    return unless (col - finish_col).abs == 2

    if finish_col > col
      set_piece(row, col + 1, get_piece(row, 7))
      set_piece(row, 7, nil)
    else
      set_piece(row, col - 1, get_piece(row, 0))
      set_piece(row, 0, nil)
    end
  end
end
