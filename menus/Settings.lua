Settings = class {}

function Settings:update(dt)
    --sets the volume
    for sound_count in pairs(sound_names) do
        sounds[sound_names[sound_count]]:setVolume(settings.volume/100)  
    end

    --sets the ball to move
    menu_ball:update(dt)
    menu_ball:colideWall()

    --makes sure the meun music dosent end
    if not sounds['menu-music']:isPlaying() then 
        sounds['menu-music']:play()
    end

    --button render
    buttons:buttons('update', settings_buttons, 20)
end
function Settings:draw()
    push:apply('start')
        love.graphics.clear(45, 45, 52, 0)
        --sets the title
        title = 'settings'
        love.graphics.setFont(pong_large_font)
        love.graphics.printf(title,0,20,virtual_width,'center')
        --renders the first player
        love.graphics.setColor(settings.paddle_color, 1)
        player1:render()
        --Creates second rectangle (right)
        love.graphics.setColor(settings.paddle_color, 1)
        player2:render()

        love.graphics.setColor(settings.main_color, 1)
        --Creates the ball
        menu_ball:render()
        
        --button render
        buttons:buttons('draw', settings_buttons, 20)

    push:apply('end')
end
function Settings:volume_set(movedX, button)
    -- makes sure the volume is accuratley displayed
    button.text = "volume          ".. tostring(settings.volume)
    -- moves the slider accoriding to the volume
    sliderBox.X = sliderBox.X + movedX
    --sets the volume to the percentage 
    settings.volume = movedX
    --makes sure the colume cannot surpass or go under the max and min
    if settings.volume >= 100 then
        settings.volume = 100
        sliderBox.x = MENU_BUTTON_WIDTH - sliderBox.Width
    elseif settings.volume <= 0 then
        settings.volume = 0
        sliderBox.x = MENU_BUTTON_WIDTH - bx
    end
end
function Settings:change_color(type, index)
    if type == 'main' then
        settings.main_color = Color:color((all_colors[index]))
    else 
        settings.paddle_color = Color:color((all_colors[index]))
    end
end