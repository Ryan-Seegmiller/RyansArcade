--[[
    PONG GAME MADE IN lOVE 2D
    Created by Ryan Seegmiller
    For GD55 course
]]
-- Resolutions
    -- Sets window size
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

    --pong virtual window
    PONG_VIRTUAL_WIDTH = 432
    PONG_VIRTUAL_HEIGHT = 243

    --flappy bird virtual window
    FLAPPYBIRD_VIRTUAL_WIDTH = 512
    FLAPPYBIRD_VIRTUAL_HEIGHT = 288

    virtual_width = PONG_VIRTUAL_WIDTH
    virtual_height = PONG_VIRTUAL_HEIGHT
--librarys
    push = require 'push'

    class = require 'class'

    color = require('ColorLibrary')

    --Imports the different classes

    --imports the pong scripts
        require 'pong/Ball'
        require 'pong/Paddle'
        require 'pong/Pong'
    --imoprts the menu scripts 
        require 'menus/PongMenu'
        require 'menus/Settings'
        require 'menus/Buttons'
        require 'menus/FlappyBirdMenu'
    --imports the flappy bird scripts
        require 'flappybird/FlappyBird'
        require 'flappybird/bird'
        require 'flappybird/Pipe'
        require 'flappybird/PipePair'
    --Imports the state machines 
    require 'StateMachine'
        require 'states/BaseState'
        require 'states/TitleScreenState'
        require 'states/CountdownState'
        require 'states/PongMenuState'
        require 'states/FlappyBirdMenuState'
        require 'states/SettingsMenuState'
        require 'states/PongPlayState'
        require 'states/FlappyBirdPlayState'
        require 'states/FlappyBirdScoreState'
        require 'states/PausedState'

--settings vairbles
    settings = {
        volume = 50,
        main_color = Color:color('white'),
        paddle_color = Color:color('white')
    }
    all_colors = Color:getColors()
--Canvases
    push:setupCanvas({
        {name = 'pong'},
        {name = 'flappyBird'}
    })

--Runs when the game starts up to initialize the game
function love.load()

    -- removes filter for bluriness using the push librarys filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    
    --"seed" the RNG so that calls to reandom are always random
    -- uses the current time from the os
    math.randomseed(os.time())
    
    --set title
    love.window.setTitle('Pong')
    

    --fonts
        --pong fonts
        pong_small_font = love.graphics.newFont('fonts/font.ttf', 8)
        pong_score_font = love.graphics.newFont('fonts/font.ttf', 32)
        pong_large_font = love.graphics.newFont('fonts/font.ttf', 32)
        pong_menu_font = love.graphics.newFont('fonts/font.ttf', 16)
        pong_dropdown_font = love.graphics.newFont('fonts/font.ttf', 8)

        --flappy fonts
        flappy_small_font = love.graphics.newFont('fonts/font.ttf', 8)
        flappy_medium_font = love.graphics.newFont('fonts/flappy.ttf', 14)
        flappy_font = love.graphics.newFont('fonts/flappy.ttf', 28)
        hugefont = love.graphics.newFont('fonts/flappy.ttf', 56)

        --sets the default font
        love.graphics.setFont(pong_small_font)

        --sets colors
        fpsCounterColor = {0, 255, 0, 255}


        --Adds the screen in a lower resolution
        push:setupScreen(virtual_width, virtual_height, WINDOW_WIDTH, WINDOW_HEIGHT,{
            fullscreen = false,
            resizable = true,
            canvas = 'pong',
            vsync = true
        })

    --initializes sounds and images
        sounds = {
            ['explosion-score'] = love.audio.newSource('sounds/explosion-score.wav', 'static'),
            ['menu-music'] = love.audio.newSource('sounds/menu-music.mp3', 'static'),
            ['paddle-hit'] = love.audio.newSource('sounds/paddle-hit.wav', 'static'),
            ['play-state-music'] = love.audio.newSource('sounds/play-state-music.mp3', 'static'),
            ['wall-hit'] = love.audio.newSource('sounds/wall-hit.wav', 'static'),
            ['flappy-die'] = love.audio.newSource('sounds/die.mp3', 'static'),
            ['flappy-score'] = love.audio.newSource('sounds/point.mp3', 'static'),
            ['flappy-flap'] = love.audio.newSource('sounds/flap.mp3', 'static'),
            ['flappy-hit'] = love.audio.newSource('sounds/flappy-bird-hit-sound.mp3', 'static'),
            ['flappy-music'] = love.audio.newSource('sounds/flappy-music.mp3', 'static')
        }
        sound_names = {
            'explosion-score', 
            'menu-music',
            'paddle-hit', 
            'play-state-music',
            'wall-hit',
            'flappy-die',
            'flappy-score',
            'flappy-flap',
            'flappy-hit',
            'flappy-music'
        }
        images = {
            ['flappy-background'] = love.graphics.newImage('images/flappy-background.png'),
            ['flappy-ground'] = love.graphics.newImage('images/flappy-ground.png'),
            ['bird'] = love.graphics.newImage('images/bird.png'),
            ['pipe'] = love.graphics.newImage('images/pipe.png')
        }
        image_names = {
            'flappy-background',
            'flappy-ground',
            'bird',
            'pipe'
        }
    --sets the volume
        for sound_count in pairs(sound_names) do
            sounds[sound_names[sound_count]]:setVolume(settings.volume/100)  
        end
    --
        
    --pong classes
        ball = Ball(virtual_width/2 - 2, virtual_height/ 2 - 2, 4, 4)
        menu_ball = Ball(virtual_width/2 - 2, virtual_height/ 2 - 2, 4, 4)
        menu_ball.dx = 0
        menu_ball.dy = 100

        pong = Pong()

        player1 = Paddle(10, 30, 5, 20)
        player2 = Paddle(virtual_width - 10, virtual_height - 30, 5, 20)
        
    --menu classes
        settings_menu = Settings()
        buttons = Buttons()
        pong_menu = PongMenu()

        buttons:load()
    --Flappybird classes
        flappyBird = FlappyBird()
        flappybird_menu = FlappyBirdMenu()

        bird = Bird()

    --initalizes States
    g_state_machine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['pong-menu'] = function() return PongMenuState() end,
        ['flappyBird-menu'] = function() return FlappyBirdMenuState() end,
        ['settings-menu'] = function() return SettingsMenuState() end,
        ['pong-play'] = function() return PongPlayState() end,
        ['flappybird-play'] = function() return FlappyBirdPlayState() end,
        ['flappybird-score'] = function() return FlappyBirdScoreState() end,
        ['countdown-pong'] = function() return CountdownState('pong') end,
        ['countdown-flappybird'] = function() return CountdownState('flappybird') end,
        ['paused-state'] = function() return PausedState() end
    }
    g_state_machine:change('title')
    --creates a table to add keys
    love.keyboard.keysPressed = {}
end
   
-- function that updates the screen
function love.update(dt)
    g_state_machine:update(dt)
    --resets the keys
    love.keyboard.keysPressed = {}
end

function love.draw()
    g_state_machine:render()
end

-- allows for the window to be resized while keeping its main shape
function rezize(w,h)
    push.resize(w,h)
    end
--show fps
function displayFPS()
    love.graphics.setFont(pong_small_font)
    love.graphics.setColor(fpsCounterColor)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
-- Function to quit game when key pressed
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    -- Key is accesed by string(key name)
    if key == 'escape' then
        -- Function that quits the window
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'menu' or gameState == 'serve' then
            gameState = 'pong'
        end
    end

end
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else 
        return false
    end
end