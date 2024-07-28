require_relative "../lib/board"
require_relative "../lib/pieces/king"
require_relative "../lib/pieces/rook"
describe King do
  let(:piece) { King.new(:white) }
  let(:board) do
    board = Board.new
    board.clear_board
    board
  end
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
      board.set_piece(2, 2, Rook.new(:black))

      board.set_piece(3, 3, piece)
      board.set_piece(4, 3, Rook.new(:white))
      board.set_piece(4, 4, Rook.new(:white))
      board.set_piece(3, 4, Rook.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to contain_exactly([2, 2])
      board.set_piece(1, 2, Rook.new(:black))
      expect(piece.valid_moves(board, 3, 3)).to_not include([2, 2], [2, 3], [2, 4], [3, 2], [4, 2])
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(2, 2, King.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([2, 2])
    end
  end
end
