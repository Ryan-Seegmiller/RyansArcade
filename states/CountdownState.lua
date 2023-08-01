CountdownState = class{__includes = BaseState}

--takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init(game)
    self.count = 3
    self.timer = 0
    self.bg = 'none'
    
    if game == 'pong' then
        self.game = 'pong-play'
        self.bg = pong
        self.height = virtual_height * 1.5
        self.width = virtual_width - 5
    elseif  game == 'flappybird' then
        self.game = 'flappybird-play'
        self.bg = flappyBird
        self.height = virtual_height
        self.width = virtual_width * .75
    end
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            g_state_machine:change(self.game)
        end
    end
end

function CountdownState:draw()
    self.bg:draw()
    love.graphics.setFont(hugefont)
    love.graphics.printf(tostring(self.count), self.width, self.height, virtual_width, 'center')
end

