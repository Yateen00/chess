require_relative "piece"
class Pawn < Piece
  def first_move?(row)
    row == (color == :white ? 6 : 1)
  end

  def valid_moves(board, row, col)
    forward_moves(board, row, col) + diagonal_moves(board, row, col) + en_passant_moves(board, row, col)
  end

  def forward_moves(board, row, col)
    moves = []
    move_offset = color == :white ? [-1, -2] : [1, 2]
    times = first_move?(row) ? 2 : 1
    times.times do |i|
      offseteted_row = row + move_offset[i]
      break unless board.allowed_tile?(color, offseteted_row, col)

      moves << [offseteted_row, col]
    end
    moves
  end

  def capture_moves(board, row, col)
    moves = []
    move_offsets = color == :white ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]]
    move_offsets.each do |row_offset, col_offset|
      offsetted_row = row + row_offset
      offsetted_col = col + col_offset
      moves << [offsetted_row, offsetted_row] if board.enemy_tile?(color, offsetted_row, offsetted_col) ||
                                                 en_passant?(board, row, col, row, offsetted_col)
    end
    moves
  end

  def en_passant?(board, my_row, my_col, enemy_row, enemy_col)
    true if my_row == enemy_row && my_row.modulo(enemy_col) == 1 && board.enemy_tile?(color, enemy_row, enemy_col)
  end
end
