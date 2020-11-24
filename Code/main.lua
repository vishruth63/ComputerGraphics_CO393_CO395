push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/PauseState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont("fonts/font.ttf", 8)
    mediumFont = love.graphics.newFont("fonts/flappy.ttf", 14)
    flappyFont = love.graphics.newFont("fonts/flappy.ttf", 28)
    hugeFont = love.graphics.newFont("fonts/flappy.ttf", 56)
    love.graphics.setFont(flappyFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end,
        ['play'] = function () return PlayState() end,
        ['score'] = function () return ScoreState() end,
        ['countdown'] = function () return CountdownState() end,
        ['pause'] = function () return PauseState() end
    }
    gStateMachine:change('title')

    sounds = {
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav','static')
    }

    medals = {
        ['rock'] = love.graphics.newImage('images/medals/rock.png'),
        ['bronze'] = love.graphics.newImage('images/medals/bronze.png'),
        ['silver'] = love.graphics.newImage('images/medals/silver.png'),
        ['gold'] = love.graphics.newImage('images/medals/gold.png'),
        ['crown'] = love.graphics.newImage('images/medals/crown.png')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end


end

function love.keyboard.wasPressed( key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)

    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

    gStateMachine:update(dt)

        

    love.keyboard.keysPressed = {}   

    love.mouse.buttonsPressed = {}


end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end