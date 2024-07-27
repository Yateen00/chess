# frozen_string_literal: true

require_relative "../lib/pieces/pawn"
require_relative "../lib/board2"
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
  describe "#first_move?" do
    it "returns true if row is 6" do
      expect(piece.first_move?(6)).to be true
    end
    it "returns false if row is not 6" do
      expect(piece.first_move?(5)).to be false
    end
  end
  describe "#forward_moves" do
    it "returns 2 forward moves if first move" do
      expect(piece.forward_moves(board, 6, 0)).to eq([[5, 0], [4, 0]])
    end
    it "returns 1 forward move if not first move" do
      expect(piece.forward_moves(board, 5, 0)).to eq([[4, 0]])
    end
    it "returns no forward moves if blocked and not first move" do
      board.set_piece(4, 0, Pawn.new(:white))
      expect(piece.forward_moves(board, 5, 0)).to eq([])
    end
    it "returns no forward moves if blocked and first move" do
      board.set_piece(5, 0, Pawn.new(:white))
      expect(piece.forward_moves(board, 6, 0)).to eq([])
    end
    it "returns one forward move if first move and blocked 2 steps away" do
      board.set_piece(4, 0, Pawn.new(:white))
      expect(piece.forward_moves(board, 6, 0)).to eq([[5, 0]])
    end
  end
  describe "#diagonal_moves" do
    it "returns no diagonal moves if no enemy pieces" do
      expect(piece.diagonal_moves(board, 6, 0)).to eq([])
    end
    it "returns diagonal moves if enemy piece" do
      board.set_piece(5, 1, Pawn.new(:black))
      board.set_piece(6, 2, piece)
      expect(piece.diagonal_moves(board, 6, 2)).to eq([[5, 1]])
      board.set_piece(5, 3, Pawn.new(:black))
      expect(piece.diagonal_moves(board, 6, 2)).to include([5, 3], [5, 1])
    end
    it "returns no diagonal moves if friendly piece in diagonal" do
      board.set_piece(5, 1, Pawn.new(:white))
      expect(piece.diagonal_moves(board, 6, 0)).to eq([])
    end
    it "returns diagonal moves if en passant" do
      board.set_piece(6, 3, Pawn.new(:black))
      expect(piece.diagonal_moves(board, 6, 2)).to include([5, 3])
      board.set_piece(6, 1, Pawn.new(:black))
      expect(piece.diagonal_moves(board, 6, 2)).to include([5, 3], [5, 1])
    end
  end
end
