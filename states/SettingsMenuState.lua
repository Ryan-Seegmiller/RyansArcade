SettingsMenuState = class{__includes = BaseState}

function SettingsMenuState:update(dt)
    settings_menu:update(dt)
end

function SettingsMenuState:draw()
    settings_menu:draw()
end