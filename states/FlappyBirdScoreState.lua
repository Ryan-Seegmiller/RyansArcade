FlappyBirdScoreState = class{__includes = BaseState}

function FlappyBirdScoreState:enter(params)
    self.score = params.score
end

function FlappyBirdScoreState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        g_state_machine:change('flappyBird-menu')
    end
end

function FlappyBirdScoreState:draw()
    push:start()
    love.graphics.draw(images['flappy-background'], -background_scroll, 0)

    love.graphics.draw(images['flappy-ground'], -ground_scroll ,virtual_height - 16)
    
    love.graphics.setFont(flappy_font)
    love.graphics.printf('YOU LOST!', 0, 64, FLAPPYBIRD_VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(flappy_medium_font)
    love.graphics.printf('Score: '.. tostring(self.score), 0, 140, FLAPPYBIRD_VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to go to menu!', 0, 160, virtual_width, 'center')
    push:finish()
end