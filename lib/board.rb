# to do:
# merge the two to implment print board/generate_board ✓
# move piece and capture piece
# save board state(yaml)
# reset board
# load board state(yaml)
# checkmate check and stalemate check
# check check
require_relative "pieces/require_pieces"
class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def setup_pieces
    pieces = %i[rook knight bishop queen king bishop knight rook]
    board.each_index do |col|
      @board[0][col] = create_piece(:black, pieces[col])
      @board[1][col] = create_piece(:black, :pawn)
      @board[7][col] = create_piece(:white, pieces[col])
      @board[6][col] = create_piece(:white, :pawn)
    end
  end

  def create_piece(color, name)
    case name
    when :pawn then Pawn.new(color)
    when :rook then Rook.new(color)
    when :knight then Knight.new(color)
    when :bishop then Bishop.new(color)
    when :queen then Queen.new(color)
    when :king then  King.new(color)
    end
  end

  def print_board
    print_top_border
    board.each_index do |row|
      print_row(row)
      print_middle_border unless row == 7
    end
    print_bottom_border
  end

  def empty_board
    @board = Array.new(8) { Array.new(8) }
  end

  def in_range?(row, col)
    row.between?(0, board.length - 1) && col.between?(0, board.length - 1)
  end

  # can be used to move
  def empty_tile?(row, col)
    @board[row][col].nil? if in_range?(row, col)
  end

  def set_piece(row, col, piece)
    @board[row][col] = piece
  end

  # can be used to capture
  def enemy_tile?(color, row, col)
    @board[row][col].color != color if in_range?(row, col) && !empty_tile?(row, col)
  end

  # can be used to capture and move
  def allowed_tile?(color, row, col)
    true if empty_tile?(row, col) || enemy_tile?(color, row, col)
  end

  private

  def print_square(row, col)
    piece = @board[row][col] || " "
    print "│ #{piece} "
  end

  def print_row(row)
    board.each_index do |col|
      print_square(row, col)
    end
    print "│\n"
  end

  def print_top_border
    print "┌───" + ("┬───" * 7) + "┐\n"
  end

  def print_middle_border
    print "├───" + ("┼───" * 7) + "┤\n"
  end

  def print_bottom_border
    print "└───" + ("┴───" * 7) + "┘\n"
  end
end
board = Board.new
board.print_board
