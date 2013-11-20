class Game
  attr_accessor :board, :current_player
  attr_reader :players


  def initialize(player1, player2)
    @board = Array.new(3) { ["-", "-","-"] }
    @players = [player1, player2]
    @current_player = @players[0]
  end

  def win?

    flat_board = board.flatten.join('')

    ["X","O"].each do |m|
      return true if
      flat_board[0..2] == m * 3 ||
      flat_board[3..5] == m * 3 ||
      flat_board[6..8] == m * 3 ||
      flat_board[0]+flat_board[3]+flat_board[6] == m*3 ||
      flat_board[1]+flat_board[4]+flat_board[7] == m*3 ||
      flat_board[2]+flat_board[5]+flat_board[8] == m*3 ||
      flat_board[1]+flat_board[4]+flat_board[8] == m*3 ||
      flat_board[2]+flat_board[4]+flat_board[6] == m*3
    end

    false
  end

  def get_mark
    if current_player == players[0]
      mark = "X"
    else
      mark = "O"
    end
  end    

  def get_move
    i,j = current_player.make_move(self)
    self.board[i][j] = get_mark
  end

  def switch_player
    if current_player == players[0]
      self.current_player = players[1]
    else
      self.current_player = players[0]
    end
  end

  def print_board
    board.each { |row| p row }
  end

  def play
    while true
      print_board
      get_move
      
      #stop play and declare winner
      if win?
        player_num = players.index(current_player)+1
        puts "Player #{player_num} wins!"
        print_board
        break
      end

      switch_player
    end
  end
end


#players
class HumanPlayer
  def make_move(current_game)
    while true
      puts "Enter move: "
      move = gets.chomp
      i = move[0].to_i
      j = move[1].to_i
      return [i,j] if current_game.board[i][j] == "-"
      puts "Invalid move"
    end
  end
end

class ComputerPlayer
  def make_move(current_game)
    #winning move possible
    (0..2).each do |i|
      (0..2).each do |j|
        test_game = Marshal.load ( Marshal.dump(current_game) )
        if test_game.board[i][j] == "-"
          #p test_game.board.object_id, current_game.board.object_id       
          test_game.board[i][j] = current_game.get_mark
          return [i,j] if test_game.win?
        end
      end
    end
    #random move
    #puts "No winning move"
    while true
      i,j = rand(3), rand(3)
      return [i,j] if current_game.board[i][j] == "-"
    end
  end
end

while true
  puts "Do you want to keep playing? (y/n)"
  input = gets.chomp
  break if input == "n"
  p1,p2 = HumanPlayer.new, ComputerPlayer.new
  game = Game.new(p1, p2)
  game.play
end

