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

def check_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.print_board
  p board.check?(:white)
  board.move_piece("d5", "e5")
  board.print_board
  p board.check?(:white)
end

def check_moves_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.set_piece(3, 5, Rook.new(:black))
  board.set_piece(4, 3, Rook.new(:black))
  board.print_board
  p board.check_moves(:white)
end

def mate_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.set_piece(3, 5, Rook.new(:black))
  board.set_piece(4, 3, Rook.new(:black))
  board.print_board
  p board.check?(:white)
  p board.mate?(:white)
  board.move_piece("d5", "e5")
  board.set_piece(3, 3, Rook.new(:black))
  board.print_board
  p board.check?(:white)
  p board.mate?(:white)
end

def stalemate_test
  board = Board.new
  board.clear_board
  board.set_piece(4, 4, King.new(:white))
  board.set_piece(3, 3, Rook.new(:black))
  board.set_piece(3, 5, Rook.new(:black))
  board.print_board
  p board.stalemate?(:white)
  board.move_piece("d5", "e5")
  board.set_piece(3, 3, Rook.new(:black))
  board.print_board
  p board.stalemate?(:white)
  board.clear_board
  board.set_piece(0, 7, King.new(:white))
  board.set_piece(2, 6, Rook.new(:black))
  board.set_piece(2, 7, King.new(:black))
  board.print_board
  p board.stalemate?(:white)
end
