# frozen_string_literal: true

require_relative "../lib/pieces/pawn"
require_relative "../lib/board2"
describe Pawn do
  let(:piece) { Pawn.new(:black) }
  let(:board) { Board.new }
  describe "initialize" do
    it "color is black" do
      expect(piece.color).to eq(:black)
    end
    it "symbol is ♟" do
      expect(piece.symbol).to eq(:♟)
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
end
