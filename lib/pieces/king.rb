require_relative "piece"
class King < Piece
  def valid_moves(board, row, col)
    king_moves(board, row, col)
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
  # to add: check conditions and castling
end
