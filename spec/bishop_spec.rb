require_relative "../lib/pieces/bishop"
require_relative "../lib/board"
describe Bishop do
  let(:piece) { Bishop.new(:white) }
  let(:board) { Board.new }
  describe "initialize" do
    it "color is white" do
      expect(piece.color).to eq(:white)
    end
    it "symbol is ♗" do
      expect(piece.symbol).to eq(:♗)
    end
  end
  describe "#valid_moves" do
    it "returns all possible moves" do
      expect(piece.valid_moves(board, 3, 3)).to include([1, 1], [1, 5], [5, 1], [5, 5])
    end
    it "returns moves with enemy pieces but not ahead of them" do
      board.set_piece(1, 1, Bishop.new(:black))
      board.set_piece(5, 1, Bishop.new(:black))
      var = piece.valid_moves(board, 3, 3)
      expect(var).to include([1, 1], [5, 1], [6, 6], [0, 6])
      expect(var).to_not include([0, 0], [6, 0])
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(1, 1, Bishop.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([1, 1], [0, 0])
    end
  end
end
