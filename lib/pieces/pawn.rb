require_relative "piece"
class Pawn < Piece
  attr_accessor :took_double_step

  def initialize(color)
    symbol = color == :white ? :♙ : :♟
    super(color, symbol)
    @took_double_step = false
  end

  def valid_moves(board, row, col)
    forward_moves(board, row, col) + diagonal_moves(board, row, col)
  end

  def en_passant?(board, row, col, enemy_row, enemy_col)
    board.get_piece(row, enemy_col)&.took_double_step &&
      board.enemy_tile?(color, row, enemy_col) &&
      enemy_row == row
  end

  private

  def first_move?(row)
    row == (color == :white ? 6 : 1)
  end

  def forward_moves(board, row, col)
    moves = []
    move_offset = color == :white ? [-1, -2] : [1, 2]
    times = first_move?(row) ? 2 : 1
    times.times do |i|
      offsetted_row = row + move_offset[i]
      break unless board.empty_tile?(offsetted_row, col)

      moves << [offsetted_row, col]
    end
    moves
  end

  def diagonal_moves(board, row, col)
    moves = []
    move_offsets = color == :white ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]]
    move_offsets.each do |row_offset, col_offset|
      offsetted_row = row + row_offset
      offsetted_col = col + col_offset

      moves << [offsetted_row, offsetted_col] if board.enemy_tile?(color, offsetted_row, offsetted_col) ||
                                                 en_passant?(board, row, col, row, offsetted_col)
    end
    moves
  end
end
