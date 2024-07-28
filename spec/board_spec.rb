require_relative "../lib/board"
require_relative "../lib/pieces/require_pieces"

describe Board do
  let(:board) do
    temp = Board.new
    temp.clear_board
    temp
  end

  describe "#en_passant" do
    it "executes en passant correctly" do
      board.set_piece(6, 0, Pawn.new(:white))
      board.set_piece(4, 1, Pawn.new(:black))

      board.move_piece("a2", "a4")
      board.move_piece("b4", "a3")
      expect(board.get_piece(*board.decode_move("a4"))).to be_nil

      # Add assertions here if needed
    end
  end

  describe "#promotion" do
    it "promotes a pawn correctly" do
      board.set_piece(1, 0, Pawn.new(:white))
      allow(board).to receive(:gets).and_return("a", "queen")
      allow(board).to receive(:puts)
      board.move_piece("a7", "a8")
      expect(board.get_piece(0, 0)).to be_instance_of(Queen)
    end
  end

  describe "#possible_moves" do
    it "prints possible moves correctly" do
      board.set_piece(4, 4, Queen.new(:white))
      board.set_piece(3, 3, Rook.new(:black))
      board.print_possible_moves("e4")
      board.print_board
    end
  end

  describe "#check" do
    it "checks if the king is in check" do
      board.set_piece(4, 4, King.new(:white))
      board.set_piece(3, 3, Rook.new(:black))
      expect(board.check?(:white)).to be false
      board.move_piece("d5", "e5")

      expect(board.check?(:white)).to be true
    end
  end

  describe "#check_moves" do
    it "returns correct check moves" do
      board.set_piece(4, 4, King.new(:white))
      board.set_piece(3, 3, Rook.new(:black))
      board.set_piece(3, 5, Rook.new(:black))
      board.set_piece(4, 3, Rook.new(:black))

      expect(board.check_moves(:white)).to eq({ "e4" => ["e3"] })
    end
  end

  describe "#mate" do
    it "checks for checkmate correctly" do
      board.set_piece(4, 4, King.new(:white))
      board.set_piece(3, 3, Rook.new(:black))
      board.set_piece(3, 5, Rook.new(:black))
      board.set_piece(4, 3, Rook.new(:black))

      expect(board.check?(:white)).to be true
      expect(board.mate?(:white)).to be false
      board.move_piece("d5", "e5")
      board.set_piece(3, 3, Rook.new(:black))

      expect(board.check?(:white)).to be true
      expect(board.mate?(:white)).to be true
    end
  end

  describe "#stalemate" do
    it "checks for stalemate correctly" do
      board.set_piece(4, 4, King.new(:white))
      board.set_piece(3, 3, Rook.new(:black))
      board.set_piece(3, 5, Rook.new(:black))
      expect(board.stalemate?(:white)).to be false
      board.move_piece("d5", "e5")
      board.set_piece(3, 3, Rook.new(:black))
      expect(board.stalemate?(:white)).to be false
      board.clear_board
      board.set_piece(0, 7, King.new(:white))
      board.set_piece(2, 6, Rook.new(:black))
      board.set_piece(2, 7, King.new(:black))
      expect(board.stalemate?(:white)).to be true
    end
  end
end
