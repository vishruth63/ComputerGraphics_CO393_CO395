PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60

PIPE_HEIGHT = 288

PIPE_WIDTH = 70

BIRD_HEIGHT = 24

BIRD_WIDTH = 38

function PlayState:enter(params)
	self.bird = params.bird
	self.pipePairs = params.pipePairs
	self.timer = params.timer
	self.pipeGap = params.pipeGap
	self.lastY = params.lastY
	self.score = params.score
	self.show = true
	self.showTimer = 0
end

function PlayState:update(dt)
	self.timer = self.timer + dt
	self.showTimer = self.showTimer + dt

	if(self.showTimer > 0.25) then
		if(self.show) then
			self.show = false
		else
			self.show = true
		end
		self.showTimer = 0
	end

	if self.timer > self.pipeGap then
		local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 -PIPE_HEIGHT))
		self.lastY = y

		table.insert(self.pipePairs, PipePair(y, math.random(90, 110)))

		self.timer = 0
		self.pipeGap = math.random(2000, 5000) / 1000

	end

	for k, pair in pairs(self.pipePairs) do
		if not pair.scored then
			if pair.x + PIPE_WIDTH < self.bird.x then
				self.score = self.score + 1
				pair.scored = true
				sounds['score']:play()
			end
		end

		pair:update(dt)
	end

	for k, pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs, k)
		end
	end


	self.bird:update(dt)

	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if(self.bird:collides(pipe)) then
				sounds['explosion']:play()
				sounds['hurt']:play()

				gStateMachine:change('score',{
					score = self.score
				})
			end
		end
	end

	if(self.bird.y > VIRTUAL_HEIGHT - 15) then
		sounds['explosion']:play()
		sounds['hurt']:play()


		gStateMachine:change('score',{
					score = self.score
					})
	end

	if(love.keyboard.wasPressed('p')) then
		gStateMachine:change('pause',{
			score = self.score, 
			bird = self.bird, 
			pipePairs = self.pipePairs,
			timer = self.timer, 
			pipeGap = self.pipeGap,
			lastY = self.lastY
		})
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(mediumFont)
	love.graphics.print('Score : ' .. tostring(self.score), 8, 8)

	if self.show then
		love.graphics.print("Press SpaceBar or Left Click to jump", 8, 34)
		love.graphics.print("Press p to pause",8,56)
	end

	self.bird:render()
end