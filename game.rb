require "myArray.rb"

class Game
	
	# external variables
	@scoreboard
	@pins_standing
		
	attr_reader :scoreboard
	attr_reader :pins_standing
		
	# game configuration variables
	@last_frame
	@pins_per_frame
	
	# track keeping variables
	@rollboard
	@current_frame
	@current_score_frame
	
	# constants
	Invalid_frame = -1
	
	
	def initialize(total_frames = 10, pins_per_frame = 10)
		unless total_frames.is_a?(Numeric)
			raise Exception, 'Frames must be numeric'
		end
		unless total_frames > 0
			raise Exception, 'Frames must be > 0'
		end
		unless pins_per_frame.is_a?(Numeric)
			raise Exception, 'Pins must be numeric'
		end
		unless pins_per_frame > 0
			raise Exception, 'Pins must be > 0'
		end
		@rollboard = []
		@scoreboard = []
		@current_frame = Invalid_frame
		@current_score_frame = 0
		@last_frame = total_frames - 1
		@pins_per_frame = pins_per_frame
		@pins_standing = @pins_per_frame
	end
	
	def roll(pins)
		unless pins.is_a?(Numeric)
			raise Exception, 'Rolls must be numeric'
		end
		unless pins >= 0
			raise Exception, 'Rolls must be >= 0'
		end
		unless pins <= @pins_standing
			raise Exception, 'Cannot roll more than the pins standing'
		end
		unless not finished?
			raise Exception, 'Cannot roll after game is finished'
		end
		advanceFrameIfNew
		addRoll pins
		updateScoreboard
		updatePinsStanding
	end
	
	def score
		if @current_score_frame == 0
			0
		else 
			@scoreboard[@current_score_frame - 1][1]
		end
	end
	
	def finished?
		lastFrame? and currentFrameFinished?
	end
		
	def deleteLastFrame
		unless not finished?
			raise Exception, 'Cannot delete after game is finished'
		end
		
		if not beforeFirstFrame?
			@current_frame -= 1
			@rollboard = @rollboard[0...(@rollboard.length - 1)]
			@scoreboard = @scoreboard[0...(@scoreboard.length - 1)]
									
			while (not canCalculateFrameScore?) and (not beforeFirstScoreFrame?)
				if @scoreboard[@current_score_frame] != nil
					@scoreboard[@current_score_frame] = [@scoreboard[@current_score_frame][0]]
				end
				@current_score_frame -= 1
			end
			@current_score_frame += 1
						
			@pins_standing = @pins_per_frame
		end
	end
	
private

	def addRoll(pins)
		@rollboard[@current_frame].concat [pins]
	end
	
	def updateScoreboard
		rolls = @rollboard[@current_frame].clone
		markSpecialShots! rolls
		@scoreboard[@current_frame] = [rolls]
		while canCalculateFrameScore?
			score =  previousScore + @rollboard[@current_score_frame].sum
			if not lastScoreFrame?
				if isSpare?
					next_rolls = nextRolls
					score += next_rolls[0]
				end
				if isStrike?
					next_rolls = nextRolls
					score += next_rolls[0] + next_rolls[1]
				end
			end
			@scoreboard[@current_score_frame] =  @scoreboard[@current_score_frame][0], score
			@current_score_frame += 1
		end
	end
	
	def updatePinsStanding
		if not lastFrame?
			if currentFrameFinished?
				@pins_standing = @pins_per_frame
			else
				@pins_standing = @pins_per_frame - @rollboard[@current_frame][0]
			end
		else
			number_of_rolls = @rollboard[@last_frame].length
			if currentFrameFinished?
				@pins_standing = @pins_per_frame
			elsif number_of_rolls == 0
				@pins_standing = @pins_per_frame
			elsif number_of_rolls == 2 and @rollboard[@last_frame].sum == @pins_per_frame
				@pins_standing = @pins_per_frame
			else
				@pins_standing = @pins_per_frame - @rollboard[@last_frame][number_of_rolls - 1]
				if @pins_standing == 0
					@pins_standing = @pins_per_frame
				end
			end	
		end
	end
			
	def advanceFrameIfNew
		if currentFrameFinished?
			nextFrame
			@rollboard[@current_frame] = []
			@scoreboard[@current_frame] = []
		end
	end	
	
	def nextFrame
		if beforeFirstFrame?
			@current_frame = 0
		else
			@current_frame += 1
		end
	end
	
	def previousScore
		previous_score = 0
		if @current_score_frame != 0
			previous_score = @scoreboard[@current_score_frame - 1][1]
		end
		previous_score
	end
	
	def currentFrameFinished?
		if not lastFrame?
			is_finished = beforeFirstFrame?
			is_finished = (is_finished or @rollboard[@current_frame].length == 2)
			is_finished = (is_finished or (@rollboard[@current_frame].length == 1 and @rollboard[@current_frame][0] == @pins_per_frame))
		else
			is_finished = beforeFirstFrame?
			is_finished = (is_finished or ((not isSpare?) and (not isStrike?) and @rollboard[@current_frame].length == 2))
			is_finished = (is_finished or ((isSpare? or isStrike?) and @rollboard[@current_frame].length == 3))
		end
	end
	
	def canCalculateFrameScore?
		if not lastScoreFrame?
			can_calculate_on_normal = (currentFrameFinished? and (@current_score_frame <= @current_frame) and (not isSpare?) and (not isStrike?))
			can_calculate_on_spare = (isSpare? and nextRolls.length >= 1)
			can_calculate_on_strike = (isStrike? and nextRolls.length >= 2)
			can_calculate_on_normal or can_calculate_on_spare or can_calculate_on_strike
		else
			currentFrameFinished? and (@current_score_frame <= @current_frame)
		end			
	end
	
	def isSpare?
		if @rollboard[@current_score_frame] != nil
			(not isStrike?) and @rollboard[@current_score_frame].sum >= @pins_per_frame
		else
			false
		end
	end
	
	def isStrike?
		if @rollboard[@current_score_frame] != nil
			@rollboard[@current_score_frame][0] == @pins_per_frame
		else
			false
		end
	end
	
	def markGutter!(rolls)
		for i in 0...rolls.length
			if rolls[i] == 0
				rolls[i] = '-'
			end
		end
	end
	
	def markClosed!(rolls)
		closed = (rolls.sum >= @pins_per_frame)
		for i in 0..rolls.length
			if rolls[i] == @pins_per_frame
				rolls[i] = 'X'
			end
		end
		if rolls[0] != 'X' and closed
			rolls[1] = '/'
		end
	end
	
	def markSpecialShots!(rolls)
		markClosed! rolls
		markGutter! rolls
	end

	def nextRolls
		if not lastScoreFrame?
			next_rolls = (@rollboard[(@current_score_frame + 1)..@rollboard.length]).flatten
		else
			next_rolls = @rollboard[@current_score_frame][1...(@rollboard[@current_score_frame].length)]
		end
	end
	
	def lastFrame?
		@current_frame == @last_frame
	end
	
	def lastScoreFrame?
		@current_score_frame == @last_frame
	end
	
	def beforeFirstFrame?
		@current_frame == Invalid_frame
	end
	
	def beforeFirstScoreFrame?
		@current_score_frame == Invalid_frame
	end
	
end