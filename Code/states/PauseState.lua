PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
	self.params = params
	love.audio.pause()
	sounds['pause']:play()
end

local pause = love.graphics.newImage('images/pause.png')



function PauseState:update(dt)
	if(love.keyboard.wasPressed('p')) then
		gStateMachine:change('play',self.params)
	end
end

function PauseState:render()
	local width = pause:getWidth()
	love.graphics.draw(pause, ((VIRTUAL_WIDTH / 2) - (width / 2)), 30)
end

function PauseState:exit()
	sounds['pause']:play()
	love.audio.resume()
end