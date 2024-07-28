# to do:
# merge the two to implment print board/generate_board ✅
# move piece and capture piece
# display possible moves for a piece
# save board state(yaml) ✅
# reset board ✅
# load board state(yaml) ✅
# checkmate check and stalemate check
# check check
# seperate fucntions in file, reorder and sort them, anything that makes it look cleaner
require_relative "pieces/require_pieces"
class Board
  attr_reader :board, :previous_move

  def initialize
    @board = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def move_piece(start, finish, moves = nil) # assuming valid start,end
    start_row, start_col = move_parser(start)
    finish_row, finish_col = move_parser(finish)
    piece = get_piece(start_row, start_col)
    return false if piece.nil?

    moves = piece.valid_moves(self, start_row, start_col) if moves.nil?
    return false unless moves.include?([finish_row, finish_col])

    handle_move(start_row, start_col, finish_row, finish_col, piece)
    @previous_move = [[start_row, start_col], [finish_row, finish_col]]
    true
  end

  def checkmate_moves(color)
    king_row, king_col = find_king(color)
    piece_and_moves = Hash.new { |h, k| h[k] = [] } # {piece_position: [valid_moves]}
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        next if piece.nil? || piece.color != color

        pos = move_encoder(row, col)
        if piece.instance_of?(King)
          piece.valid_moves(self, row, col).each do |move|
            piece_and_moves[pos] << move_encoder(*move)
          end
        else
          piece.valid_moves(self, row, col).each do |move|
            temp = get_piece(*move)
            set_piece(*move, piece)
            piece_and_moves[pos] << move_encoder(*move) unless king_in_check?(color, king_row, king_col)
            set_piece(*move, temp)
          end
        end
      end
    end
    piece_and_moves
  end

  def handle_move(row, col, finish_row, finish_col, piece)
    case piece.class.to_s
    when "Pawn"
      handle_en_passant(row, col, finish_row, finish_col, piece)
      piece = handle_promotion(finish_row, finish_col, piece) || piece
    end
    set_piece(finish_row, finish_col, piece)
    set_piece(row, col, nil)
    remove_en_passant
  end

  # tested
  # #
  #
  #
  #
  #
  def king_in_check?(color, king_row = nil, king_col = nil)
    king_row, king_col = find_king(color) if king_row.nil? || king_col.nil?
    board.each_index do |row|
      board[row].each_index do |col|
        piece = get_piece(row, col)
        next if piece.nil? || piece.color == color

        return true if piece.valid_moves(self, row, col).include?([king_row, king_col])
      end
    end
    false
  end

  def set_piece(row, col, piece)
    @board[row][col] = piece
  end

  def find_king(color)
    board.each_index do |row|
      board[row].each_index do |col|
        piece = get_piece(row, col)
        return [row, col] if piece.instance_of?(King) && piece.color == color
      end
    end
  end

  def print_possible_moves(position, moves = nil)
    if moves.nil?
      row, col = move_parser(position)
      piece = get_piece(row, col)
      return if piece.nil?
    end
    moves = piece.valid_moves(self, row, col)
    green_bg = "\e[42m"
    reset_bg = "\e[0m"
    temp_pieces = moves.map do |move|
      piece = get_piece(*move)
      set_piece(*move, green_bg + piece.to_s + reset_bg)
      set_piece(*move, "•") if piece.nil?
      [piece, move]
    end
    print_board
    temp_pieces.each do |piece, move|
      set_piece(*move, piece)
    end
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

  def reset_board
    empty_board
    setup_pieces
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

  # assuming valid move
  def move_parser(move)
    # move= "a2" a-h=row 1-8=col
    col = move[0].downcase.ord - 97
    row = move[1].to_i - 1
    row = 7 - row
    [row, col]
  end

  def move_encoder(row, col)
    col = (col + 97).chr
    row = 8 - row
    "#{col}#{row}"
  end

  def print_board
    print "    0   1   2   3   4   5   6   7\n"
    print_top_border
    board.each_index do |row|
      print "#{8 - row} " # Row label
      print_row(row)

      print_middle_border unless row == 7
    end
    print_bottom_border
    print "    a   b   c   d   e   f   g   h\n"
  end

  def clear_board
    @board = Array.new(8) { Array.new(8) }
  end

  def in_range?(row, col)
    row.between?(0, board.length - 1) && col.between?(0, board.length - 1)
  end

  # can be used to move
  def empty_tile?(row, col)
    @board[row][col].nil? if in_range?(row, col)
  end

  def remove_en_passant
    return if previous_move.nil?

    previous_piece = get_piece(previous_move[1][0], previous_move[1][1])
    return unless previous_piece.instance_of?(Pawn)

    previous_piece.took_double_step = false
  end

  def handle_en_passant(row, col, finish_row, finish_col, piece)
    return piece.took_double_step = true if (row - finish_row).abs == 2
    return if previous_move.nil?

    previous_piece = get_piece(previous_move[1][0], previous_move[1][1])
    captured = previous_piece.instance_of?(Pawn) &&
               (previous_move[1][0] - previous_move[0][0]).abs == 2 &&
               !enemy_tile?(piece.color, finish_row, finish_col)
    set_piece(previous_move[1][0], previous_move[1][1], nil) if captured
  end

  def handle_promotion(row, col, piece)
    return nil unless (piece.color == :white && row == 0) || (piece.color == :black && row == 7)

    puts "Promote to: (queen, rook, bishop, knight)"
    promotion = gets.chomp.downcase.to_sym
    until %i[queen rook bishop knight].include?(promotion)
      puts "Invalid promotion"
      promotion = gets.chomp.downcase.to_sym

    end
    create_piece(piece.color, promotion)
  end

  def get_piece(row, col)
    @board[row][col]
  end

  # can be used to capture
  def enemy_tile?(color, row, col)
    @board[row][col].color != color if in_range?(row, col) && !empty_tile?(row, col)
  end

  # can be used to capture and move
  def allowed_tile?(color, row, col)
    true if empty_tile?(row, col) || enemy_tile?(color, row, col)
  end

  def to_yaml
    YAML.dump(self)
  end

  def self.from_yaml(string)
    YAML.load(string)
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
    puts "  ┌───#{'┬───' * 7}┐"
  end

  def print_middle_border
    puts "  ├───#{'┼───' * 7}┤"
  end

  def print_bottom_border
    puts "  └───#{'┴───' * 7}┘"
  end
end

def test_en_passant
  board = Board.new
  board.clear_board
  board.set_piece(6, 0, Pawn.new(:white))
  board.set_piece(4, 1, Pawn.new(:black))
  board.print_board
  board.move_piece("a2", "a4")
  board.print_board
  board.move_piece("b4", "a3")
  board.print_board
end

def test_promotion
  board = Board.new
  board.clear_board
  board.set_piece(1, 0, Pawn.new(:white))
  board.print_board
  board.move_piece("a7", "a8")
  board.print_board
end

def test_possible_moves
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, Queen.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.print_possible_moves("e4")
end

# test_possible_moves
def king_in_check_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.print_board
  p board.king_in_check?(:white)
  board.move_piece("d5", "e5")
  board.print_board
  p board.king_in_check?(:white)
end

# king_in_check_test
def checkmate_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.set_piece(3, 5, Rook.new(:black))
  board.set_piece(4, 3, Rook.new(:black))
  board.print_board
  p board.checkmate_moves(:white)
end
checkmate_test
