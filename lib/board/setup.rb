module Setup
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
end
