module EndConditions
  def mate?(color, moves = nil)
    moves || check_moves(color).empty?
  end

  def stalemate?(color)
    return false if check?(color)

    mate?(color)
  end

  def find_king(color)
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        return [row, col] if piece.instance_of?(King) && piece.color == color
      end
    end
    nil
  end

  def check?(color, king_row = nil, king_col = nil)
    king_row, king_col = find_king(color) if king_row.nil? ||
                                             king_col.nil? ||
                                             get_piece(king_row, king_col).nil?
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        next unless enemy_tile?(color, row, col)
        # if piece.nil? || piece.color == color

        return true if piece.valid_moves(self, row, col).include?([king_row, king_col])
      end
    end
    false
  end

  def check_moves(color)
    king_row, king_col = find_king(color)
    piece_and_moves = Hash.new { |h, k| h[k] = [] } # {piece_position: [valid_moves]}
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        next unless friendly_tile?(color, row, col)

        # !piece.nil? && piece.color == color

        pos = encode_move(row, col)
        if piece.instance_of?(King)
          moves = piece.valid_moves(self, row, col)
          moves = remove_castling(moves, row, col)
          moves.each do |move|
            piece_and_moves[pos] << encode_move(*move)
          end
        else
          piece.valid_moves(self, row, col).each do |move|
            temp = get_piece(*move)
            set_piece(*move, piece)
            piece_and_moves[pos] << encode_move(*move) unless check?(color, king_row, king_col)
            set_piece(*move, temp)
          end
        end
      end
    end
    piece_and_moves
  end
end
