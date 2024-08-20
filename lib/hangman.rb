# Hangman class to run game
class Hangman
  DICTONARY = 'google-10000-english-no-swears.txt'.freeze
  MAX_ATTEMPTS = 6

  def initialize
    @solution = random_word
    @attempts = MAX_ATTEMPTS
    @board = Array.new(@solution.length, '_')
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
      @attempts -= 1
    end

    p "Board: #{@board.join(' ')}"
  end

  def user_input
    valid_letter = false
    until valid_letter
      letter = gets.chomp.downcase
      if !letter.length.eql?(1) || @board.include?(letter)
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
      puts "The solution was #{@solution}"
    end
  end

  def play_game
    puts 'game started'
    puts @solution
    until @game_over
      puts "Attempts left: #{@attempts}"
      puts 'Make a guess'
      add_to_board(user_input)
      check_win
    end
  end
end
