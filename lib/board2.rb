class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def in_range?(row, col)
    row.between?(0, board.length) && col.between?(0, board.length)
  end

  def empty_tile?(row, col)
    @board[row][col].nil? if in_range?(row, col)
  end

  def put(row, col, piece)
    @board[row][col] = piece
  end

  def enemy_tile?(color, row, col)
    return false if empty_tile?(row, col) || !in_range?(row, col)

    @board[row][col].color != color
  end

  def allowed_tile?(color, row, col)
    true if empty_tile?(row, col) || enemy_tile?(color, row, col)
  end
end

# allowed tile checks for tile in range, empty or enemy tile

# enemy tile checks for tile in range and enemy tile
