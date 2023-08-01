FlappyBirdPlayState = class{__includes = BaseState}

function FlappyBirdPlayState:update(dt)
    flappyBird:update(dt)
end
function FlappyBirdPlayState:draw()
    flappyBird:draw()
end