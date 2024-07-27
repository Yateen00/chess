require_relative "../lib/board"
require_relative "../lib/pieces/king"
describe King do
  let(:piece) { King.new(:white) }
  let(:board) { Board.new }
  describe "initialize" do
    it "color is white" do
      expect(piece.color).to eq(:white)
    end
    it "symbol is ♔" do
      expect(piece.symbol).to eq(:♔)
    end
  end
  describe "#valid_moves" do
    it "returns all possible moves" do
      expect(piece.valid_moves(board, 3,
                               3)).to contain_exactly([2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4])
    end
    it "returns moves with enemy pieces" do
      board.set_piece(2, 2, King.new(:black))
      board.set_piece(2, 3, King.new(:black))
      expect(piece.valid_moves(board, 3, 3)).to include([2, 2], [2, 3])
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(2, 2, King.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([2, 2])
    end
  end
end
