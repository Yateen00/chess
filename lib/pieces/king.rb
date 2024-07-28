require_relative "piece"
class King < Piece
  attr_accessor :first_move

  def initialize(color)
    symbol = color == :white ? :♔ : :♚
    super(color, symbol)
    @first_move = true
  end

  def valid_moves(board, row, col)
    king_moves(board, row, col)
  end

  private

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
    # not added check check here as leads to infinite loop:
    # black calls white check, white calls black check check,etc
    moves = add_castling_moves(moves, board, row, col)
    moves = remove_blocked_moves(moves, board, row, col)
    verify_castling(moves, board, row, col)
  end

  def add_castling_moves(moves, board, row, col)
    moves = castling_kingside(moves, board, row, col)
    castling_queenside(moves, board, row, col)
  end

  def castling_kingside(moves, board, row, col)
    return moves unless first_move

    piece = board.get_piece(row, 7)
    return moves unless piece.instance_of?(Rook) && piece.first_move

    moves << [row, col + 2] if board.empty_tile?(row, col + 1) &&
                               board.empty_tile?(row, col + 2)
    moves
  end

  def castling_queenside(moves, board, row, col)
    return moves unless first_move

    piece = board.get_piece(row, 0)
    return moves unless piece.instance_of?(Rook) && piece.first_move

    moves << [row, col - 2] if board.empty_tile?(row, col - 1) &&
                               board.empty_tile?(row, col - 2) &&
                               board.empty_tile?(row, col - 3)
    moves
  end

  def verify_castling(moves, board, row, col)
    moves.delete([row, col + 2]) unless moves.include?([row, col + 1])
    moves.delete([row, col - 2]) unless moves.include?([row, col - 1])
    moves
  end

  # internal needs to be at start
  def remove_blocked_moves(moves, board, my_row, my_col)
    board.set_piece(my_row, my_col, nil)
    moves = remove_internal_blocked_moves(moves, board)
    moves = remove_externally_blocked_moves(moves, board)
    board.set_piece(my_row, my_col, self)
    moves
  end

  def remove_externally_blocked_moves(moves, board)
    temp_pieces = moves.each_with_object([]) do |move, obj|
      piece = board.get_piece(*move)
      next if piece.nil?

      board.set_piece(*move, self)
      obj << [piece, move]
    end
    board.board.each_with_index do |subarr, row|
      subarr.each_with_index do |piece, col|
        next if piece.nil? || piece.color == color || moves.empty?

        moves -= piece.valid_moves(board, row, col)
      end
    end
    temp_pieces.each do |piece, move|
      board.set_piece(*move, piece)
    end
    moves
  end

  def remove_internal_blocked_moves(moves, board)
    filtered_moves = moves.dup
    moves.each do |move|
      piece = board.get_piece(*move)
      next if piece.nil?

      filtered_moves -= piece.valid_moves(board, *move)
      board.set_piece(*move, nil)
      moves.each do |move2|
        piece2 = board.get_piece(*move2)
        filtered_moves -= piece2.valid_moves(board, *move2) unless piece2.nil? || piece2 == piece
      end
      board.set_piece(*move, piece)
    end

    filtered_moves
  end
  # to add: check conditions and castling
end
