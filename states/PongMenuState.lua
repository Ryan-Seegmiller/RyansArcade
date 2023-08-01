PongMenuState = class{__includes = BaseState}

function PongMenuState:update(dt)
    pong_menu:update(dt)
end

function PongMenuState:draw()
    pong_menu:draw()
end
