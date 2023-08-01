StateMachine = class{}

function StateMachine:init(states)
    self.empty = {
        draw = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    self.states = states or {} -- [name] -> [uunction that returns states]
    self.current = self.empty
    self.paused = false
end

function StateMachine:change(state_name, eneter_params)
    assert(self.states[state_name]) --state must exist!
    self.current:exit()
    self.current = self.states[state_name]()
    self.current:enter(eneter_params)
end 
function StateMachine:pause(paused)
    self.paused = paused
end
function StateMachine:update(dt)
    if not self.paused then
        self.current:update(dt)
    end
end
function StateMachine:render()
    self.current:draw()
    if self.paused then 
        self.states['paused-state']():draw()
    end
end