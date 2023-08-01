Bird = class{}

local GRAVITY = 5
local ANTI_GRAVITY = -(GRAVITY * .35)

function Bird:init()
    --load the bird image and assign its width and height
    self.image = images['bird']
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --postion birdin the middle of the screen
    self.x = FLAPPYBIRD_VIRTUAL_WIDTH / 2 - (self.width/2)
    self.y = FLAPPYBIRD_VIRTUAL_HEIGHT / 2 - (self.height/2)

    self.dy = 0
end
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    --sets the velocity using the gravity constant multiplied by deltatime
    self.dy = self.dy + GRAVITY * dt
    --jumps using the anti gravity constant
    if love.keyboard.wasPressed('space') then
        self.dy = ANTI_GRAVITY
        sounds['flappy-flap']:play()
    end
    --adds to the y value every frame
    self.y = self.y + self.dy 
end
-- AABB collision detection
function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true 
        end
    end

    return false
end 