module Print
  def print_board
    print "    0   1   2   3   4   5   6   7\n"
    print_top_border
    board.each_index do |row|
      print "#{8 - row} " # Row label
      print_row(row)

      print_middle_border unless row == 7
    end
    print_bottom_border
    print "    a   b   c   d   e   f   g   h\n"
  end

  def print_possible_moves(position, moves = nil)
    if moves.nil?
      row, col = decode_move(position)
      piece = get_piece(row, col)
      return if piece.nil?

      moves = piece.valid_moves(self, row, col)
    else
      moves = moves.map { |move| decode_move(move) }
    end

    green_bg = "\e[42m"
    reset_bg = "\e[0m"
    temp_pieces = moves.map do |move|
      piece = get_piece(*move)
      set_piece(*move, green_bg + piece.to_s + reset_bg)
      set_piece(*move, "•") if piece.nil?
      [piece, move]
    end
    print_board
    temp_pieces.each do |piece, move|
      set_piece(*move, piece)
    end
  end

  protected

  def print_square(row, col)
    piece = @board[row][col] || " "
    print "│ #{piece} "
  end

  def print_row(row)
    board.each_index do |col|
      print_square(row, col)
    end
    print "│\n"
  end

  def print_top_border
    puts "  ┌───#{'┬───' * 7}┐"
  end

  def print_middle_border
    puts "  ├───#{'┼───' * 7}┤"
  end

  def print_bottom_border
    puts "  └───#{'┴───' * 7}┘"
  end
end
