require_relative "piece"
class Queen < Piece
  def valid_moves(board, row, col)
    king_moves(board, row, col) + horizontal_moves(board, row, col) +
      vertical_moves(board, row, col) + left_diagonal(board, row, col) +
      right_diagonal(board, row, col)
  end

  def king_moves(board, row, col)
    moves = []
    move_offset = [-1, 0, 1]
    # basically generates all combination of above moves
    move_offset.each do |row_offset|
      move_offset.each do |col_offset|
        offseteted_row = row + row_offset
        offseteted_col = col + col_offset
        next if (row_offset.zero? && col_offset.zero?) || !board.allowed_tile?(color, offseteted_row, offseteted_col)

        moves << [offseteted_row, offseteted_col]
      end
    end
    moves
  end

  def horizontal_moves(board, row, col)
    move_offset = [-1, 1]
    moves = []
    index = 0
    while index < move_offset.length

      if board.enemy_tile?(color, row, col + move_offset[index])
        moves << [row, col + move_offset[index]]
        index += 1
      elsif board.empty_tile?(row, col + move_offset[index])
        moves << [row, col + move_offset[index]]
        move_offset[index] += move_offset[index].positive? ? 1 : -1
      else
        index += 1
      end
    end
    moves
  end

  def vertical_moves(board, row, col)
    move_offset = [-1, 1]
    moves = []
    index = 0
    while index < move_offset.length
      if board.enemy_tile?(color, row + move_offset[index], col)
        moves << [row + move_offset[index], col]
        index += 1
      elsif board.empty_tile?(row + move_offset[index], col)
        moves << [row + move_offset[index], col]
        move_offset[index] += move_offset[index].positive? ? 1 : -1
      else
        index += 1
      end
    end
    moves
  end

  def left_diagonal(board, row, col)
    moves = []
    move_offset = [-1, 1]
    index = 0
    while index < move_offset.length
      if board.enemy_tile?(color, row + move_offset[index], col + move_offset[index])
        moves << [row + move_offset[index], col + move_offset[index]]
        index += 1
      elsif board.empty_tile?(row + move_offset[index], col + move_offset[index])
        moves << [row + move_offset[index], col + move_offset[index]]
        move_offset[index] += move_offset[index].positive? ? 1 : -1
      else
        index += 1
      end
    end
    moves
  end

  def right_diagonal(board, row, col)
    moves = []
    move_offset = [-1, 1]
    index = 0
    while index < move_offset.length
      if board.enemy_tile?(color, row + move_offset[index], col - move_offset[index])
        moves << [row + move_offset[index], col - move_offset[index]]
        index += 1
      elsif board.empty_tile?(row + move_offset[index], col - move_offset[index])
        moves << [row + move_offset[index], col - move_offset[index]]
        move_offset[index] += move_offset[index].positive? ? 1 : -1
      else
        index += 1
      end
    end
    moves
  end
end
