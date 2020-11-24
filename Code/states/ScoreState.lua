ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
	self.score = params.score
end

function ScoreState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('countdown')
	end
end

function ScoreState:render()

	if(self.score >= 10) then
		ScoreState:drawMedal(medals['crown'])
	elseif(self.score >= 7) then
		ScoreState:drawMedal(medals['gold'])
	elseif(self.score >= 5) then
		ScoreState:drawMedal(medals['silver'])
	elseif(self.score >= 2) then
		ScoreState:drawMedal(medals['bronze'])
	else
		ScoreState:drawMedal(medals['rock'])
	end
	

	love.graphics.setFont(hugeFont)
	love.graphics.printf("Game Over", 0 , 130, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Your Score is : " .. tostring(self.score), 0, 190, VIRTUAL_WIDTH, 'center')

	love.graphics.printf("Press Enter to play again", 0, 214, VIRTUAL_WIDTH, 'center')

	love.graphics.printf("Press ESC to Exit", 0, 240, VIRTUAL_WIDTH, 'center')
end

function ScoreState:drawMedal(image)
	local width = image:getWidth()
	love.graphics.draw(image, ((VIRTUAL_WIDTH / 2) - (width / 2)), 10)
end
