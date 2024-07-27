# frozen_string_literal: true

require_relative "../lib/pieces/pawn"
require_relative "../lib/board"
describe Pawn do
  let(:piece) { Pawn.new(:white) }
  let(:board) { Board.new }
  describe "initialize" do
    it "color is white" do
      expect(piece.color).to eq(:white)
    end
    it "symbol is ♟" do
      expect(piece.symbol).to eq(:♙)
    end
  end
  describe "#valid_moves" do
    context "when the pawn is at the starting position" do
      it "returns 2 possible moves" do
        expect(piece.valid_moves(board, 6, 0)).to contain_exactly([5, 0], [4, 0])
      end
    end
    context "when the pawn is not at the starting position" do
      it "returns 1 possible move" do
        expect(piece.valid_moves(board, 5, 0)).to contain_exactly([4, 0])
      end
    end
    context "when there is a piece in front of the pawn" do
      it "returns no moves" do
        board.set_piece(5, 0, Pawn.new(:white))
        expect(piece.valid_moves(board, 6, 0)).to be_empty
      end
    end
    it "returns moves with enemy pieces" do
      board.set_piece(5, 0, Pawn.new(:black))
      expect(piece.valid_moves(board, 6, 1)).to include([5, 0])
      board.set_piece(5, 2, Pawn.new(:black))
      expect(piece.valid_moves(board, 6, 1)).to include([5, 2], [5, 0])
    end
    it "returns en passant move" do
      board.set_piece(3, 0, Pawn.new(:black))
      expect(piece.valid_moves(board, 3, 1)).to include([2, 0])
      board.set_piece(3, 2, Pawn.new(:black))
      expect(piece.valid_moves(board, 3, 1)).to include([2, 2], [2, 0])
    end
  end
end
