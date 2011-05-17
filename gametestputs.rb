require "game"




		game = Game.new
		game.roll 10
		game.roll 3
		game.roll 7
		game.roll 5
		puts '1: ' + game.current_score_frame.to_s
		game.deleteLastFrame
		puts '2: ' + game.current_score_frame.to_s
		puts 'sb: ' + game.scoreboard.to_s
		game.deleteLastFrame
		puts '3: ' + game.current_score_frame.to_s
		puts 'sb: ' + game.scoreboard.to_s
		game.roll 3
		game.deleteLastFrame
		puts '4: ' + game.current_score_frame.to_s
		game.roll 10
		puts '5: ' + game.current_score_frame.to_s
		game.roll 4
	