require_relative "piece"
class Knight < Piece
  def initialize(color)
    symbol = color == :white ? :♘ : :♞
    super(color, symbol)
  end

  def valid_moves(board, row, col)
    knight_moves(board, row, col)
  end

  private

  def knight_moves(board, row, col)
    moves = []
    # Knight moves in chess: 2 in one direction, 1 in the other
    move_offsets = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
    move_offsets.each do |row_offset, col_offset|
      offsetted_row = row + row_offset
      offsetted_col = col + col_offset
      moves << [offsetted_row, offsetted_col] if board.allowed_tile?(color, offsetted_row, offsetted_col)
    end
    moves
  end
end
