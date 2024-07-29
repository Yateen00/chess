# to do:
# repition check will be done in game
# seperate fucntions in file, reorder and sort them, anything that makes it look cleaner
require_relative "../pieces/require_pieces"
require_relative "require_modules"
class Board
  attr_reader :board, :previous_move

  def initialize
    @board = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def move_piece(start, finish, moves = nil)
    start_row, start_col = decode_move(start)
    finish_row, finish_col = decode_move(finish)
    piece = get_piece(start_row, start_col)
    return false if piece.nil?

    moves = moves.nil? ? piece.valid_moves(self, start_row, start_col) : decode_moves(moves)

    return false unless moves.include?([finish_row, finish_col])

    handle_move(start_row, start_col, finish_row, finish_col, piece)
    @previous_move = [[start_row, start_col], [finish_row, finish_col]]
    true
  end

  include AllModules
end
