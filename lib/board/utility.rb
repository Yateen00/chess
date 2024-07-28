module Utility
  def in_range?(row, col)
    row.between?(0, board.length - 1) && col.between?(0, board.length - 1)
  end

  # can be used to move
  def empty_tile?(row, col)
    @board[row][col].nil? if in_range?(row, col)
  end

  # can be used to capture
  def enemy_tile?(color, row, col)
    @board[row][col].color != color if in_range?(row, col) && !empty_tile?(row, col)
  end

  # can be used to capture and move
  def allowed_tile?(color, row, col)
    true if empty_tile?(row, col) || enemy_tile?(color, row, col)
  end

  def set_piece(row, col, piece)
    @board[row][col] = piece
  end

  def get_piece(row, col)
    @board[row][col]
  end

  def reset_board
    empty_board
    setup_pieces
  end

  def clear_board
    @board = Array.new(8) { Array.new(8) }
  end

  def decode_move(move)
    # move= "a2" a-h=row 1-8=col
    col = move[0].downcase.ord - 97
    row = move[1].to_i - 1
    row = 7 - row
    [row, col]
  end

  def encode_move(row, col)
    col = (col + 97).chr
    row = 8 - row
    "#{col}#{row}"
  end

  def to_yaml
    YAML.dump(self)
  end

  def self.from_yaml(string)
    YAML.load(string)
  end

end
