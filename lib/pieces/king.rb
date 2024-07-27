require_relative "piece"
class King < Piece
  def initialize(color)
    symbol = color == :white ? :♔ : :♚
    super(color, symbol)
  end

  def valid_moves(board, row, col)
    king_moves(board, row, col)
  end

  def king_moves(board, row, col)
    moves = []
    move_offset = [-1, 0, 1]
    # basically generates all combination of above moves
    move_offset.each do |row_offset|
      move_offset.each do |col_offset|
        offsetted_row = row + row_offset
        offsetted_col = col + col_offset
        moves << [offsetted_row, offsetted_col] unless (row_offset.zero? && col_offset.zero?) ||
                                                       !board.allowed_tile?(color, offsetted_row, offsetted_col)
      end
    end
    moves
  end
  # to add: check conditions and castling
end
