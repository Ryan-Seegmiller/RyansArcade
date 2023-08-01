PongPlayState = class{__includes = BaseState}

function PongPlayState:update(dt)
    pong:update_explosions(dt)
    if gameState == 'serve' then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'none'
        end
    else
        pong:update(dt)
    end
end

function PongPlayState:draw()
    pong:draw()
end