require_relative "../lib/pieces/rook"
require_relative "..lib/board/board"
describe Rook do
  let(:piece) { Rook.new(:white) }
  let(:board) do
    board = Board.new
    board.clear_board
    board
  end
  describe "initialize" do
    it "color is white" do
      expect(piece.color).to eq(:white)
    end
    it "symbol is ♖" do
      expect(piece.symbol).to eq(:♖)
    end
  end
  describe "#valid_moves" do
    it "returns all possible moves" do
      expect(piece.valid_moves(board, 3,
                               3)).to contain_exactly([1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [3, 1], [3, 2], [3, 4],
                                                      [3, 5], [3, 6], [3, 7], [0, 3], [3, 0])
    end
    it "returns moves with enemy pieces but not ahead of them" do
      board.set_piece(1, 3, Rook.new(:black))
      board.set_piece(3, 1, Rook.new(:black))
      var = piece.valid_moves(board, 3, 3)
      expect(var).to include([1, 3], [3, 1], [6, 3], [3, 6])
      expect(var).to_not include([0, 3], [3, 0])
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(1, 3, Rook.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([1, 3], [0, 3])
    end
  end
end
