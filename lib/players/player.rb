class Player
  attr_reader :color, :name

  def initialize(color = nil, name = nil)
    @color = color
    @name = name
  end

  # moves: {"start":["end"]}, default value []
  def play_turn(board)
    raise NotImplementedError
  end

  def assign_color(color = nil, other_color = nil)
    @color = if color.nil? && other_color.nil?
               %i[black white].sample
             elsif color.nil?
               other_color.to_sym == :black ? :white : :black
             else
               color.to_sym
             end
  end
end
