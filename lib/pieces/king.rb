require_relative "piece"
class King < Piece
  def initialize(color)
    symbol = color == :white ? :♔ : :♚
    super(color, symbol)
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
    remove_blocked_moves(moves, board)
  end

  # internal needs to be at start
  def remove_blocked_moves(moves, board)
    moves = remove_internal_blocked_moves(moves, board)
    temp_pieces = moves.each_with_object([]) do |move, obj|
      piece = board.get_piece(move[0], move[1])
      next if piece.nil?

      board.set_piece(move[0], move[1], self)
      obj << [piece, move]
    end
    moves = remove_externally_blocked_moves(moves, board)
    temp_pieces.each do |piece, move|
      board.set_piece(move[0], move[1], piece)
    end
    moves
  end

  def remove_externally_blocked_moves(moves, board)
    board.board.each_with_index do |subarr, row|
      subarr.each_with_index do |piece, col|
        next if piece.nil? || piece.color == color || moves.empty?

        moves -= piece.valid_moves(board, row, col)
      end
    end
    moves
  end

  def remove_internal_blocked_moves(moves, board)
    filtered_moves = moves.dup
    moves.each do |move|
      piece = board.get_piece(move[0], move[1])
      next if piece.nil?

      filtered_moves -= piece.valid_moves(board, move[0], move[1])
    end
    filtered_moves
  end
  # to add: check conditions and castling
end
