--States that the class
Ball = class{}

-- initiates the ball
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(-50, 50)
    --makes sure the ball isnt super slow
    if self.dx <= 10 and self.dx >= -10 then 
        if self.dx >= 0 then
            self.dx = self.dx + 10
        else
            self.dx = self.dx + -10
        end
    end
end

    --[[
        places ball on the center of the screen giving it
        an inital velocity
    ]]
function Ball:reset()
    self.x = virtual_width / 2 - 2
    self.y = virtual_height / 2 - 2
    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(-50 ,50)
    
    --makes sure the ball isnt super slow
    if self.dx <= 10 and self.dx >= -10 then 
        if self.dx >= 0 then
            self.dx = self.dx + 20
        else
            self.dx = self.dx + -20
        end
    end

end

-- applies velocity to position
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:collides(paddle)
    -- check to see if the left edge is farther to the right 
    --than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    -- then check to see if the bottom edge of either is higher 
    --than the top edge on the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    --if the above arent true, theyre overlapping
    return true
end

function Ball:serve(playerServe)
    --ball goes towards player 2
    if playerServe == 1 then 
        self.dy = math.random(2) == 1 and 100 or -100
        self.dx = math.random(20, 50)
    --ball goes towards player 1
    else
        self.dy = math.random(2) == 1 and 100 or -100
        self.dx = math.random(-50, -20)
    end
end

function Ball:colideWall()
    --bounces off the top of the screen
    if self.y <= 0 then
        --plays sound
        sounds['wall-hit']:play()

        self.y= 0
        self.dy = -self.dy
    end
    -- bounces off the screen bottom
    if self.y >= virtual_height - 4 then 
        --plays sound
        sounds['wall-hit']:play()

        self.y = virtual_height - 4
        self.dy = -self.dy
    end
end