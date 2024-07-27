require_relative "piece"
class Knight < Piece
  def valid_moves(board, row, col)
    knight_moves(board, row, col)
  end

  def knight_moves(board, my_row, my_col)
    moves = []
    # Knight moves in chess: 2 in one direction, 1 in the other
    move_offsets = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
    move_offsets.each do |row_offset, col_offset|
      row_offset = my_row + row_offset
      col_offset = my_col + col_offset
      moves << [row_offset, col_offset] if board.allowed_tile?(color, row_offset, col_offset)
    end
    moves
  end
end
