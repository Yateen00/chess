# to do:
# merge the two to implment print board/generate_board ✅
# move piece and capture piece ✅
# display possible moves for a piece ✅
# save board state(yaml) ✅
# reset board ✅
# load board state(yaml) ✅
# castling ✅
# check check and stalemate check ✅
# mate check ✅
# repition check will be done in game
# seperate fucntions in file, reorder and sort them, anything that makes it look cleaner
require_relative "pieces/require_pieces"
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

    moves = if moves.nil?
              piece.valid_moves(self, start_row, start_col)
            else
              moves.map { |move| decode_move(move) }
            end

    return false unless moves.include?([finish_row, finish_col])

    handle_move(start_row, start_col, finish_row, finish_col, piece)
    @previous_move = [[start_row, start_col], [finish_row, finish_col]]
    true
  end

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

  def mate?(color, moves = nil)
    moves || check_moves(color).empty?
  end

  def stalemate?(color)
    return false if check?(color)

    mate?(color)
  end

  def check?(color, king_row = nil, king_col = nil)
    king_row, king_col = find_king(color) if king_row.nil? ||
                                             king_col.nil? ||
                                             get_piece(king_row, king_col).nil?
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        next if piece.nil? || piece.color == color

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
        next if piece.nil? || piece.color != color

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

  def print_possible_moves(position, moves = nil)
    if moves.nil?
      row, col = decode_move(position)
      piece = get_piece(row, col)
      return if piece.nil?

      moves = piece.valid_moves(self, row, col)
    else
      moves = moves.map { |move| decode_move(move) }
    end

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

  def to_yaml
    YAML.dump(self)
  end

  def self.from_yaml(string)
    YAML.load(string)
  end

  def decode_move(move)
    # move= "a2" a-h=row 1-8=col
    col = move[0].downcase.ord - 97
    row = move[1].to_i - 1
    row = 7 - row
    [row, col]
  end

  protected

  def remove_castling(moves, row, col)
    moves.delete([row, col + 2])
    moves.delete([row, col - 2])
    moves
  end

  def handle_move(row, col, finish_row, finish_col, piece)
    case piece
    when Pawn
      handle_en_passant(row, col, finish_row, finish_col, piece)
      piece = handle_promotion(finish_row, finish_col, piece) || piece
    when King
      piece.first_move = false
      handle_castling(row, col, finish_row, finish_col, piece)
    when Rook
      piece.first_move = false
    end
    set_piece(finish_row, finish_col, piece)
    set_piece(row, col, nil)
    remove_en_passant
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

    previous_piece = get_piece(*previous_move[1])
    captured = previous_piece.instance_of?(Pawn) &&
               (previous_move[1][0] - previous_move[0][0]).abs == 2 &&
               !enemy_tile?(piece.color, finish_row, finish_col)
    set_piece(*previous_move[1], nil) if captured
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

  def handle_castling(row, col, finish_row, finish_col, piece)
    return unless (col - finish_col).abs == 2

    if finish_col > col
      set_piece(row, col + 1, get_piece(row, 7))
      set_piece(row, 7, nil)
    else
      set_piece(row, col - 1, get_piece(row, 0))
      set_piece(row, 0, nil)
    end
  end

  def find_king(color)
    board.each_with_index do |arr, row|
      arr.each_with_index do |piece, col|
        return [row, col] if piece.instance_of?(King) && piece.color == color
      end
    end
    nil
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

  def encode_move(row, col)
    col = (col + 97).chr
    row = 8 - row
    "#{col}#{row}"
  end

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
