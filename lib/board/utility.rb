module Utility
  # alternate: using resevior sampling. counter, rand(counter).zero?
  # reason:
  # first: probaility :1
  # second: prob of 1 remaining: 1*1/2=1/2, prob of 2 remaining: 1/2
  # third: prob of 1 remaining: 1*1/2*2/3=1/3, prob of 2 remaining: 1/2*2/3=1/3, prob of 3 remaining: 1/3

  # does not work while in check
  # returns nil if no valid moves
  def random_move(color, moves = nil)
    return random_move_from_given(color, moves) unless moves.nil?

    pieces = all_friendly_pieces(color)
    selected_move = nil
    len = pieces.length
    pieces.each do |row, col|
      moves = get_piece(row, col).valid_moves(self, row, col)
      next if moves.empty?

      random_match = rand(0..len - 1).zero?
      selected_move = [encode_move(row, col), encode_move(*moves.sample)] if random_match || selected_move.nil?
      return selected_move if random_match && !selected_move.nil?
    end
    selected_move
  end

  def decode_moves(moves)
    result = []
    moves.each_value do |final_arr|
      final_arr.each do |move|
        result << decode_move(move)
      end
    end
    result
  end

  def random_move_from_given(color, moves)
    # { "e4" => ["e3"] }

    key = moves.keys.sample

    value = moves[key].sample

    [key, value]
  end

  def piece_has_moves?(move, moves = nil)
    return moves[move].empty? && moves.delete(move) unless moves.nil?

    pos = decode_move(move)
    get_piece(pos).valid_moves(self, *pos).empty?
  end

  def all_friendly_pieces(color)
    board.each_with_index.with_object([]) do |(arr, row), obj|
      arr.each_index do |col|
        obj << [row, col] if friendly_tile?(color, row, col)
        # !piece.nil? && piece.color == color
      end
    end
  end

  def in_range?(row, col)
    row.between?(0, board.length - 1) && col.between?(0, board.length - 1)
  end

  # can be used to move
  def empty_tile?(row, col)
    in_range?(row, col) && get_piece(row, col).nil?
  end

  # can be used to capture
  def enemy_tile?(color, row, col)
    in_range?(row, col) && !empty_tile?(row, col) && get_piece(row, col).color != color
  end

  def valid_starting_tile?(pos, color)
    !board.enemy_tile?(color, *decode_move(pos))
  end

  def friendly_tile?(color, row, col)
    in_range?(row, col) && !empty_tile?(row, col) && get_piece(row, col).color == color
  end

  # can be used to capture and move
  def allowed_tile?(color, row, col)
    empty_tile?(row, col) || enemy_tile?(color, row, col)
  end

  def set_piece(row, col, piece)
    @board[row][col] = piece
  end

  def get_piece(row, col)
    @board[row][col]
  end

  def reset_board
    clear_board
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
