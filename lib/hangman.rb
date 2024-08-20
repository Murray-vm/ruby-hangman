require 'yaml'

# Hangman class to run game
class Hangman
  DICTONARY = 'google-10000-english-no-swears.txt'.freeze
  MAX_ATTEMPTS = 6
  SAVE_FILE = 'save-file.ymal'.freeze

  def initialize
    @solution = random_word
    @attempts = MAX_ATTEMPTS
    @board = Array.new(@solution.length, '_')
    @attempted_letters = []
    @game_over = false
  end

  def random_word
    lines = File.readlines(DICTONARY)
    words = lines.map(&:chomp).select { |word| word.length.between?(5, 12) }
    words.sample
  end

  def add_to_board(letter)
    if @solution.include?(letter)
      @solution.split('').each_with_index do |character, index|
        @board[index] = letter if character.eql?(letter)
      end
    else
      @attempted_letters << letter
      @attempts -= 1
    end
  end

  def user_input
    valid_letter = false
    until valid_letter
      letter = gets.chomp.downcase
      if !letter.length.eql?(1) || @board.include?(letter) || @attempted_letters.include?(letter)
        puts 'Invalid input please enter a single unused character only '
      else
        valid_letter = true
      end
    end
    letter
  end

  def check_win
    if @board.join.eql?(@solution)
      @game_over = true
      puts 'You win'
    elsif @attempts.eql?(0)
      @game_over = true
      puts 'You loose'
      puts "The solution was: '#{@solution}'"
    end
  end

  def play_turn
    puts 'Make a guess'
    input = user_input
    if input == '*'
      save_game
    else
      add_to_board(input)
      check_win
    end
  end

  def to_yaml
    YAML.dump({
                solution: @solution,
                attempts: @attempts,
                board: @board,
                attempted_letters: @attempted_letters
              })
  end

  def save_game
    File.write(SAVE_FILE, to_yaml)
    puts 'Game Saved'
  end

  def load_game
    return unless File.exist?(SAVE_FILE)

    puts 'Load Game? [y/n]'
    return unless gets.chomp.downcase == 'y'

    loaded_data = YAML.load File.read(SAVE_FILE)
    @solution = loaded_data[:solution]
    @attempts = loaded_data[:attempts]
    @board = loaded_data[:board]
    @attempted_letters = loaded_data[:attempted_letters]
  end

  def play_game
    puts 'New game started'
    puts 'enter "*" at anytime to save the game'
    load_game
    until @game_over
      puts "Board: #{@board.join(' ')}"
      puts "Attempted letters: #{@attempted_letters.join(' ')}"
      puts "Attempts left: #{@attempts}"
      play_turn
    end
  end
end
