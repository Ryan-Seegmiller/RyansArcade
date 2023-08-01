FlappyBird = class {}
--parallax scroll variebles
background_scroll = 0
ground_scroll = 0

BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60

BACKGROUD_LOOPING_POINT = 568

function FlappyBird:load()

    virtual_width = FLAPPYBIRD_VIRTUAL_WIDTH
    virtual_height = FLAPPYBIRD_VIRTUAL_HEIGHT

    --fliters the pixels so its not blurry
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --sets the window title
    love.window.setTitle('Flappy Bird')

    --sets up new screen width
    love.graphics.setCanvas()
    push:setupScreen(virtual_width, virtual_height, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        canvas = 'flappyBird',
        resizable = true
    })
    love.graphics.setFont(flappy_font)

    flappy_score = 0
    pipe_pairs = {}
end
function FlappyBird:draw()
    push:start()
    --draw image at its neagtive looping point
    love.graphics.draw(images['flappy-background'], -background_scroll, 0)

    --draws the pipe_pairs to teh screen
    for k, pair in pairs(pipe_pairs) do
        pair:render()
    end

    --draw image at its neagtive looping point
    love.graphics.draw(images['flappy-ground'], -ground_scroll ,virtual_height - 16)

    buttons:buttons('draw', pause_button)

    love.graphics.setFont(flappy_font)
    love.graphics.print('Score: '.. tostring(flappy_score), 8, 8)

    bird:render()

    push:finish()
end
function FlappyBird:update(dt)
    sounds['menu-music']:setLooping(false)
    love.audio.stop(sounds['menu-music'])
    sounds['flappy-music']:setLooping(true)
    sounds['flappy-music']:play()

    background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUD_LOOPING_POINT

    ground_scroll = ((background_scroll + GROUND_SCROLL_SPEED * dt)
        % virtual_width)

    --adds second to the pipe timer
    pipe_timer = pipe_timer + dt

    --adds new pipe pair to scene every 3 seconds
    if pipe_timer > 2 then
        y = math.max(-PIPE_HEIGHT + 10, 
            math.min(last_y + math.random(-50, 40), 
            virtual_height - 90 - PIPE_HEIGHT))
        last_y = y

        table.insert(pipe_pairs, PipePair(y))
        pipe_timer = 0
    end

    bird:update(dt)
    
    --updates the specific pairs of pipes
    for k, pair in pairs(pipe_pairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < bird.x then
                flappy_score = flappy_score + 1
                pair.scored = true
                sounds['flappy-score']:play()
            end
        end
        pair:update(dt)
    end
    --Check to see if the bird collided with pipe
    for k, pair in pairs(pipe_pairs) do
        for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
                --transistion to score state
                sounds['flappy-hit']:play()
                sounds['flappy-die']:play()
                g_state_machine:change('flappybird-score', { 
                    score = flappy_score
            })
            end
        end
    end
    if bird.y > FLAPPYBIRD_VIRTUAL_HEIGHT - 15 then
        sounds['flappy-hit']:play()
        sounds['flappy-die']:play()
        g_state_machine:change('flappybird-score', { 
            score = flappy_score
        })
    end
    --deletes the pairs when no longer visible
    for k, pair in pairs(pipe_pairs) do
        if pair.remove then
            table.remove(pipe_pairs, k)
        end
    end
end
