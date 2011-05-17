require "test/unit"
require "game"

class GameTest < Test::Unit::TestCase

	def test_emptyGame
		expected_scoreboard = []
		expected_score = 0
		game = Game.new
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end

	def test_gutterGame
		expected_scoreboard = [[['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0], \
			[['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0], [['-', '-'], 0]]
		expected_score = 0
		game = Game.new
		(1..20).each do
			game.roll 0
		end
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end
	
	def test_noClosedFrameGame
		expected_scoreboard = []
		game = Game.new
		(0..9).each do |i|
			roll_one = rand 5
			roll_two = rand 5
			game.roll roll_one
			game.roll roll_two
			roll_one_representation = (roll_one == 0 ? '-' : roll_one)
			roll_two_representation = (roll_two == 0 ? '-' : roll_two)
			if i == 0
				expected_scoreboard.concat [[[roll_one_representation, roll_two_representation], roll_one + roll_two]]
			else
				expected_scoreboard.concat [[[roll_one_representation, roll_two_representation], expected_scoreboard.last[1] + roll_one + roll_two]]
			end
		end
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_halfFrame
		expected_scoreboard = [[[4, 3], 7], [[2]]]
		expected_score = 7
		game = Game.new
		game.roll 4
		game.roll 3
		game.roll 2
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end

	def test_spare
		expected_scoreboard = [[[7, '/'], 14], [[4, '/'], 27], [[3, 2], 32]]
		game = Game.new
		game.roll 7
		game.roll 3
		game.roll 4
		game.roll 6
		game.roll 3
		game.roll 2
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_spareAndHalfFrame
		expected_scoreboard = [[[7, '/'], 14], [[4]]]
		game = Game.new
		game.roll 7
		game.roll 3
		game.roll 4
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_spareUnfinished
		expected_scoreboard = [[[7, '/']]]
		game = Game.new
		game.roll 7
		game.roll 3
		assert_equal expected_scoreboard, game.scoreboard
	end

	def test_strike
		expected_scoreboard = [[['X'], 18], [[3, 5], 26]]
		game = Game.new
		game.roll 10
		game.roll 3
		game.roll 5
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_spareAndStrike
		expected_scoreboard = [[['X'], 20], [[4, '/'], 32], [[2, 7], 41]]
		game = Game.new
		game.roll 10
		game.roll 4
		game.roll 6
		game.roll 2
		game.roll 7
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_twoStrikesAndAHalfFrame
		expected_scoreboard = [[['X'], 22], [['X']], [[2]]]
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 2
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_turkey
		expected_scoreboard = [[['X'], 30], [['X']], [['X']]]
		expected_score = 30
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 10
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end
	
	def test_turkeyFinished
		expected_scoreboard = [[['X'], 30], [['X'], 51], [['X'], 62], [[1, '-'], 63], [[4]]]
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 10
		game.roll 1
		game.roll 0
		game.roll 4
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameSimple
		expected_scoreboard = [[[4, 2], 6], [[3, 5], 14]]
		game = Game.new 2
		game.roll 4
		game.roll 2
		game.roll 3
		game.roll 5
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameSpare
		expected_scoreboard = [[['X'], 20], [[3, '/', 4], 34]]
		game = Game.new 2
		game.roll 10
		game.roll 3
		game.roll 7
		game.roll 4
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameStrike
		expected_scoreboard = [[['X'], 30], [['X', 'X', 4], 54]]
		game = Game.new 2
		game.roll 10
		game.roll 10
		game.roll 10
		game.roll 4
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameSpareStrike
		expected_scoreboard = [[['X'], 20], [[3, '/', 'X'], 40]]
		game = Game.new 2
		game.roll 10
		game.roll 3
		game.roll 7
		game.roll 10
		assert_equal expected_scoreboard, game.scoreboard
	end 
	
	def test_complete
		expected_scoreboard = [[['X'], 24], [['X'], 44], [[4, '/'], 57], [[3, '/'], 77], [['X',], 96], [[2, 7], 105], \
			[['-', 3], 108], [['-', '-'], 108], [['X'], 138], [['X', 'X', 2], 160]]
		expected_score = 160
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 4
		game.roll 6
		game.roll 3
		game.roll 7
		game.roll 10
		game.roll 2
		game.roll 7
		game.roll 0
		game.roll 3
		game.roll 0
		game.roll 0
		game.roll 10
		game.roll 10
		game.roll 10
		game.roll 2
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end
	
	def test_pinsStart
		expected_pins = 10
		game = Game.new
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsOneRoll
		expected_pins = 4
		game = Game.new
		game.roll 6
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsNormalFrame
		expected_pins = 10
		game = Game.new
		game.roll 6
		game.roll 2
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsSpare
		expected_pins = 10
		game = Game.new
		game.roll 6
		game.roll 4
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsStrike
		expected_pins = 10
		game = Game.new
		game.roll 10
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsLastFrameNormal
		expected_pins = 10
		game = Game.new 1
		game.roll 6
		game.roll 2
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsLastFrameStrike
		expected_pins = 7
		game = Game.new 1
		game.roll 10
		game.roll 3
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_pinsLastFrameSpare
		expected_pins = 10
		game = Game.new 1
		game.roll 7
		game.roll 3
		assert_equal expected_pins, game.pins_standing
	end
	
	def test_fourPinGame
		expected_scoreboard = [[['X'], 8], [[2, '/', 'X'], 16]]
		expected_score = 16
		game = Game.new 2, 4
		game.roll 4
		expected_pins = 4
		assert_equal expected_pins, game.pins_standing
		game.roll 2
		expected_pins = 2
		assert_equal expected_pins, game.pins_standing
		game.roll 2
		expected_pins = 4
		assert_equal expected_pins, game.pins_standing
		game.roll 4
		assert_equal expected_scoreboard, game.scoreboard
		assert_equal expected_score, game.score
	end
	
	def test_raiseIncorrectFrames
		assert_raise(Exception) do
			Game.new -1
		end
		assert_raise(Exception) do
			Game.new 0
		end
		assert_raise(Exception) do
			Game.new 'a'
		end
	end
	
	def test_raiseIncorrectPins
		assert_raise(Exception) do
			Game.new 1, -1
		end
		assert_raise(Exception) do
			Game.new 1, 0
		end
		assert_raise(Exception) do
			Game.new 1, 'a'
		end
	end
	
	def test_validRoll
		game = Game.new
		assert_raise(Exception) do
			game.roll -1
		end
		assert_raise(Exception) do
			game.roll 4
			game.roll 9
		end
		assert_raise(Exception) do
			game.roll 'a'
		end
		assert_raise(Exception) do
			game.roll 19
		end
	end
	
	def test_noRollAfterFinished
		game = Game.new 1
		assert_raise(Exception) do
			game.roll 0
			game.roll 0
			game.roll 0
		end
	end
	
	def test_rollAndDelete
		expected_scoreboard = []
		game = Game.new
		game.roll 3
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_spareAndDelete
		expected_scoreboard = [[[5, '/']]]
		game = Game.new
		game.roll 5
		game.roll 5
		game.roll 2
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_normalSpareAndDelete
		expected_scoreboard = [[[3, 4], 7], [[5, '/']]]
		game = Game.new
		game.roll 3
		game.roll 4
		game.roll 5
		game.roll 5
		game.roll 2
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_strikeAndDelete
		expected_scoreboard = [[['X']]]
		game = Game.new
		game.roll 10
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_doubleStrikeAndDelete
		expected_scoreboard = [[['X']], [['X']]]
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastNormalFrameDelete
		expected_scoreboard = []
		game = Game.new 1
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameSpareDelete
		expected_scoreboard = []
		game = Game.new 1
		game.roll 5
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_lastFrameStrikeDelete
		expected_scoreboard = []
		game = Game.new 1
		game.roll 10
		game.roll 10
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_noDeleteAfterFinished
		game = Game.new 1
		game.roll 4
		game.roll 3
		assert_raise(Exception) do
			game.deleteLastFrame
		end
	end
	
	def test_spareAndStrikeDeleteAndContinue
		expected_scoreboard = [[['X'], 23], [['X'], 43], [[3, '/'], 55], [[2, 6], 63], [[8, 1], 72]]
		game = Game.new
		game.roll 10
		game.roll 10
		game.roll 5
		game.deleteLastFrame
		game.roll 3
		game.roll 7
		game.roll 8
		game.deleteLastFrame
		game.roll 2
		game.roll 6
		game.roll 5
		game.deleteLastFrame
		game.roll 8
		game.roll 1
		assert_equal expected_scoreboard, game.scoreboard
	end

	def test_deleteEmptyGame
		expected_scoreboard = []
		game = Game.new
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_rollDeleteDelete
		expected_scoreboard = []
		game = Game.new
		game.roll 2
		game.deleteLastFrame
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_rollDeleteDeleteContinue
		expected_scoreboard = [[[6, 3], 9]]
		game = Game.new
		game.roll 2
		game.roll 4
		game.deleteLastFrame
		game.deleteLastFrame
		game.roll 6
		game.roll 3
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_sequenceStrikeSpareDeleteContinue
		expected_scoreboard = [[['X'], 20], [[6, '/'], 40], [['X'], 60], [[4, '/'], 80], [['X'], 107], \
			[['X'], 127], [[7, '/'], 140], [[3, 1], 144]]
		game = Game.new 8
		game.deleteLastFrame
		game.deleteLastFrame
		game.roll 10
		game.roll 10
		game.roll 5
		game.roll 3
		game.deleteLastFrame
		game.deleteLastFrame
		game.roll 6
		game.roll 4
		game.roll 2
		game.roll 3
		game.deleteLastFrame
		game.roll 10
		game.roll 2
		game.deleteLastFrame
		game.roll 4
		game.roll 6
		game.roll 10
		game.deleteLastFrame
		game.roll 10
		game.roll 10
		game.roll 10
		game.deleteLastFrame
		game.roll 7
		game.roll 3
		game.roll 0
		game.roll 10
		game.deleteLastFrame
		game.roll 3
		game.roll 1
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_moreDeleteSequences
		expected_scoreboard = [[['X'], 20], [[3, '/']]]
		game = Game.new
		game.roll 10
		game.roll 3
		game.roll 7
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X']]]
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X']]]
		game.roll 3
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X']], [['X']]]
		game.roll 10
		game.roll 4
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X']], [['X']]]
		game.roll 10
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X']]]
		game.roll 10
		game.deleteLastFrame
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[[2, 4], 6]]
		game.deleteLastFrame
		game.roll 2
		game.roll 4
		game.roll 7
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[[2, 4], 6]]
		game.roll 7
		game.roll 1
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[['X'], 30], [['X']], [['X']]]
		game.deleteLastFrame
		game.roll 10
		game.roll 4
		game.deleteLastFrame
		game.roll 10
		game.roll 10
		assert_equal expected_scoreboard, game.scoreboard
		expected_scoreboard = [[[5, '/']]]
		game.deleteLastFrame
		game.deleteLastFrame
		game.deleteLastFrame
		game.roll 5
		game.roll 5
		game.roll 3
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_scoreboard, game.scoreboard
	end
	
	def test_pinsAfterDelete
		expected_pins = 9
		game = Game.new 10, 9
		game.roll 5
		game.deleteLastFrame
		assert_equal expected_pins, game.pins_standing
		expected_pins = 5
		game.roll 4
		assert_equal expected_pins, game.pins_standing
	end
	
end