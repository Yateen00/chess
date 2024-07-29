require_relative "../lib/players/computer"
require_relative "../lib/board/board"
require_relative "../lib/pieces/king"
require_relative "../lib/pieces/rook"

describe Computer do
  let(:board) { Board.new }
  let(:computer) { Computer.new(:black, "Computer") }
  let(:king) { King.new(:black) }

  before do
    board.clear_board
    board.set_piece(0, 0, king)
  end

  context "when not in check" do
    it "makes a move" do
      expect(%w[b7 a7 b8]).to include(computer.make_move(board)[1])
    end
  end

  context "when in check" do
    before do
      board.set_piece(2, 1, Rook.new(:white))
      board.set_piece(0, 2, Rook.new(:white))
      board.set_piece(2, 1, nil)
    end

    it "makes a valid move" do
      expect(%w[b7 a7 b8]).to include(computer.make_move(board)[1])
      expect(board.check?(:black)).to be false
    end
  end

  context "when in checkmate" do
    before do
      board.set_piece(0, 1, Rook.new(:white))
      board.set_piece(1, 1, Rook.new(:white))
    end

    it "does not make a move" do
      expect(computer.make_move(board)).to eq([])
      expect(board.mate?(:black)).to be true
    end
  end
end
