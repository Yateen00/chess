require_relative "piece"
class Bishop < Piece
  def valid_moves(board, row, col)
    left_diagonal(board, row, col) + right_diagonal(board, row, col)
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
