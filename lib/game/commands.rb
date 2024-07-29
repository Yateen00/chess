module Commands
  protected

  def restart
    board.reset_board
    @turn = :white
  end

  def load_file(file)
    game = YAML.load_file("saves/#{file}")
    @board = game.board
    @player1 = game.player1
    @player2 = game.player2
    @turn = game.turn
  rescue StandardError => e
    puts "Error loading file: #{e.message}"
    puts e.backtrace.join("\n")
  end

  def loaded_files
    files = begin Dir.entries("saves")
    rescue StandardError
      []
    end
    files.select { |file| file.include?(".yaml") }
  end

  def load_game
    files = loaded_files
    puts "No saves found" if files.empty?
    files_len = files.length
    load_game_menu(files)
    loop do
      file = gets.chomp
      break load_file(file) if files.include?(file)
      break load_file(files[file.to_i - 1]) if file.to_i.between?(1, files_len)

      puts "Invalid input. Please enter a valid file name."
    end
  end

  def load_game_menu(files)
    puts "Select a save to load. enter number of file name/nIf file name is a number, file name takes priority"
    files.each_with_index do |file, index|
      puts "#{index + 1}. #{file}"
    end
  end

  def save_game
    FileUtils.mkdir_p("saves")
    loop do
      puts "Enter a name for the save"
      name = gets.chomp
      file_name = "#{name}.yaml"
      break if overwrite_save?(file_name)
    end
    File.write("saves/#{file_name}", YAML.dump(obj), mode: "w")
  end

  def overwrite_save?(file_name)
    if loaded_files.include?(file_name)
      puts "Save already exists. Do you want to overwrite it? (y/n)"
      return false if gets.chomp.downcase == "n"
    end
    true
  end
end
