Pipe = class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')

PIPE_HEIGHT = PIPE_IMAGE:getHeight() --288
PIPE_WIDTH = PIPE_IMAGE:getWidth() --70

PIPE_SCROLL = 60

function Pipe:init(orientation, y)
    self.x = FLAPPYBIRD_VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
    0, --rotaion
    1, --x scale
    self.orientation == 'top' and -1 or 1) -- y scale ( applying -1 to scale flips the orientation on that axis)
end