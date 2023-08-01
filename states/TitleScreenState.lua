TitleScreenState = class{__includes = BaseState}

function TitleScreenState:update(dt)
    if not sounds['menu-music']:isPlaying() then 
        sounds['menu-music']:setLooping(true)
        sounds['menu-music']:play()
    end
end

function TitleScreenState:draw()
    push:start()
    love.graphics.setFont(pong_large_font)
    love.graphics.setColor(settings.main_color)
    love.graphics.printf('Ryan\'s Arcade', 0, 20, virtual_width, 'center')
    buttons:buttons('draw', title_screen_buttons, 20)    
    push:finish()
end
