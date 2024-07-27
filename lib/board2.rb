class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def print_board
    print_top_border
    (0...8).each do |row|
      print_row(row)
      print_middle_border if row < 7
    end
    print_bottom_border
  end

  private

  def print_square(row, col)
    piece = @board[row][col] || " "
    piece_color = if piece.match?(/[\u2654-\u2659]/)
                    "\e[37m" # White pieces
                  else
                    "\e[30m" # Black pieces
                  end

    print "│ #{piece_color}#{piece}\e[0m "
  end

  def print_row(row)
    (0...8).each do |col|
      print_square(row, col)
    end
    print "│\n"
  end

  def print_top_border
    print "┌───" + ("┬───" * 7) + "┐\n"
  end

  def print_middle_border
    print "├───" + ("┼───" * 7) + "┤\n"
  end

  def print_bottom_border
    print "└───" + ("┴───" * 7) + "┘\n"
  end

  row.between?(0, 7) && column.between?(0, 7)
  allowed_tile?(color, row + move_offset[0], col)
  # allowed tile checks for tile in range, empty or enemy tile
  enemy_tile?(color, row + move_offset[0], col)
  empty_tile?(row + move_offset[0], col)
  in_range?(row + move_offset[0], col)

  # enemy tile checks for tile in range and enemy tile
end
