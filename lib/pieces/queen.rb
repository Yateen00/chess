require_relative "piece"
# no spec file as its a mix of bishop and rook
class Queen < Piece
  def initialize(color)
    symbol = color == :white ? :♕ : :♛
    super(color, symbol)
  end

  def valid_moves(board, row, col)
    queen_moves(board, row, col)
  end

  private

  def queen_moves(board, row, col)
    horizontal_moves(board, row, col) + vertical_moves(board, row, col) +
      left_diagonal(board, row, col) + right_diagonal(board, row, col)
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
