# frozen_string_literal: true

require_relative "../lib/pieces/pawn"
require_relative "../lib/board2"
describe Pawn do
  let(:piece) { Pawn.new(:black) }
  let(:board) { Board.new }
  describe "initialize" do
    it "is blac" do
      expect(true).to eq(true)
    end
  end
end
