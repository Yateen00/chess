require_relative "../board/board"
require "yaml"
require "fileutils"
require_relative "../players/human"
require_relative "../players/computer"
# to do:
# repition check will be done in game
# implement other commands too
# implment check,stale,draw,mate
class Chess
  attr_reader :board, :player1, :player2, :turn

  def initialize
    intro_message
    puts "Do you want to load a saved game? (y/n)"
    load_game if gets.chomp.downcase == "y"
    create_new_game if player1.nil? || player2.nil?
  end

  def intro_message
    puts "Welcome to Chess!"
    puts "Enter 'exit' to quit the game"
    puts "Enter 'restart' to restart the game"
    puts "Enter 'save' to save the game"
    puts "Enter 'load' to load the game"
  end

  def create_new_game
    @board = Board.new
    @player1 = create_player(1)
    choose_side(player1)
    puts "#{player1.name} chose #{player1.symbol}"
    @player2 = create_player(2)
    choose_side(player2, player1.color)
    puts "#{player2.name} chose #{player2.symbol}"
    puts "The game is on!"
    @turn = :white
    @mated = false
  end

  def create_player(player_number)
    loop do
      puts "Is player #{player_number} a human or computer? (h/c)"
      player_type = gets.chomp.downcase
      case player_type
      when "h"
        puts "Player #{player_number}, what is your name?"
        name = gets.chomp
        puts "\n"
        return Human.new(nil, name)

      when "c"
        puts "\n"
        return Computer.new(nil, "Computer #{player_number}")
      else
        puts "Invalid input. Please enter 'h' for human or 'c' for computer."
      end
    end
  end

  def choose_side(player, other_color = nil)
    if player.is_a?(Human) && other_color.nil?
      puts "Choose your side: type 'white' or 'black' or anything else for random"
      color = gets.chomp
    end
    player.assign_color(color, other_color)
  end

  def play
    previous_move = []
    loop do
      puts "Enter your command: exit,restart,save,load or anything else to continue"
      command = gets.chomp
      case command
      when "exit"
        return nil
      when "restart"
        restart
      when "save"
        save_game
        return nil
      when "load"
        load_game
      else
        board.print_board
        move = play_turn
        previous_move << move unless move.nil?
        over = game_over?
        again = play_again?
        return nil if over && !again

        restart if over && again
      end
    end
  end

  include Commands

  def play_turn
    puts "#{turn.capitalize}'s turn"
    move = if turn == player1.color
             player1.make_move
           else
             player2.make_move
           end
    flip_turn unless move.empty?
    move
    # check is handled in move, for mate, returns [] and unflipped turn
  end

  def flip_turn
    @turn = turn == player1.color ? player2.color : player1.color
  end

  def game_over?
    loser = current_turn_player
    winner = loser == player1 ? player2 : player1
    if board.mate?(color)
      puts "Congratulations! #{winner.name} that is #{winner.color} wins!"
      return true
    elsif board.stalemate?(color)
      puts "It's a tie!"
      return true
    end
    false
  end

  def current_turn_player
    turn == player1.color ? player1 : player2
  end

  def play_again?
    puts "Do you want to play again? (y/n)"
    return true if gets.chomp.downcase == "y"

    false
  end
end
