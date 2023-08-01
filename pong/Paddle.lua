Paddle = class{}
-- initalizes the attributes
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end
--updates based off key press
function Paddle:update(dt)
    if self.dy < 0 then
        -- determines wether the paddle can move up
        self.y = math.max(0, self.y + self.dy * dt)

    else
        --determines if the paddle can move down
        self.y = math.min(virtual_height - self.height, self.y + self.dy * dt)
    end
end
--renders based on x and y of postioning
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end