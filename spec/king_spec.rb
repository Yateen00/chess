require_relative "..lib/board/board"
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
    context "when king cant capture the piece and protecting piece is in king's circle" do
      it "returns moves that wont lead to checkmate" do
        board.set_piece(2, 2, Rook.new(:black))

        board.set_piece(3, 3, piece)

        board.set_piece(2, 4, Rook.new(:black))

        expect(piece.valid_moves(board, 3, 3)).to contain_exactly([4, 3])
      end
    end

    context "when king cant capture the piece and protecting piece is not in king's circle" do
      it "returns moves that wont lead to checkmate" do
        board.set_piece(2, 2, Rook.new(:black))

        board.set_piece(3, 3, piece)
        board.set_piece(1, 2, Rook.new(:black))

        expect(piece.valid_moves(board, 3, 3)).to contain_exactly([4, 3], [3, 4], [4, 4])
        expect(piece.valid_moves(board, 3, 3)).to_not include([2, 2])
      end
    end
    it "returns only allowed moves" do
      board.set_piece(3, 3, piece)
      board.set_piece(2, 2, King.new(:white))
      expect(piece.valid_moves(board, 3, 3)).to_not include([2, 2])
    end
    context "when castling is possible" do
      it "returns both castling moves" do
        board.set_piece(0, 7, Rook.new(:white))
        board.set_piece(0, 0, Rook.new(:white))
        board.set_piece(0, 4, piece)

        expect(piece.valid_moves(board, 0, 4)).to include([0, 6], [0, 2])
      end
      it "doesnt return castling moves when rook or king has moved" do
        piece2 = Rook.new(:white)
        board.set_piece(0, 7, piece2)
        board.set_piece(0, 4, piece)
        piece2.first_move = false
        expect(piece.valid_moves(board, 0, 4)).to_not include([0, 2])
        piece2.first_move = true
        piece.first_move = false
        expect(piece.valid_moves(board, 0, 4)).to_not include([0, 2])
      end
    end
  end
end
# [2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]
