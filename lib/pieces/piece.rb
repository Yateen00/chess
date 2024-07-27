class Piece
  attr_reader :color, :symbol

  # color: symbol
  def initialize(color, symbol)
    @color = color
    @symbol = nil
  end

  def to_s
    @symbol
  end

  def valid_moves(board, row, col)
    raise NotImplementedError
  end
end
