require_relative "../lib/board"
require_relative "../lib/pieces/knight"
describe Knight do
  let(:piece) { Knight.new(:white) }
  let(:board) { Board.new }
  describe "initialize" do
    it "color is white" do
      expect(piece.color).to eq(:white)
    end
    it "symbol is ♘" do
      expect(piece.symbol).to eq(:♘)
    end
  end
  describe "#valid_moves" do
    it "returns all possible moves" do
      expect(piece.valid_moves(board, 3,
                               3)).to contain_exactly([1, 2], [1, 4], [2, 1], [2, 5], [4, 1], [4, 5], [5, 2], [5, 4])
    end
    it "returns moves with enemy pieces" do
      board.set_piece(1, 4, Knight.new(:black))
      board.set_piece(2, 1, Knight.new(:black))
      expect(piece.valid_moves(board, 3, 3)).to include([1, 4], [2, 1])
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(2, 1, Knight.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([2, 1])
    end
  end
end
