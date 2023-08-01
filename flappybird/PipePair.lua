PipePair = class{}

local GAP_HEIGHT = math.random(60, 120)

--holds teh pipe_pairs for flappys bird
pipe_pairs = {}

--initalize our last recorded y value for a gap placement
last_y = -PIPE_HEIGHT + math.random(80) + 20

--timer for pipe spawn
pipe_timer = 0

function PipePair:init(y)
    --initializes pipes past the edge of the screen
    self.x = FLAPPYBIRD_VIRTUAL_WIDTH + PIPE_WIDTH

    --y value is for the topmost pipe; gap is a vertical shift of the second
    self.y = y

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    --wether this pipe pair is ready to removed from the scene
    self.remove = false

    --wether or not this pair of pipes has been scored
    self.scorerd = false
end
function PipePair:update(dt)
    --remove the pipe if its moved off the screen  
    --else move it from left to right
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SCROLL * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end
function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end