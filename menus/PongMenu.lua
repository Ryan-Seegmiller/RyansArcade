PongMenu = class{}

function PongMenu:update(dt)
    title = 'PONG'
    if not sounds['menu-music']:isPlaying() then 
        sounds['menu-music']:setLooping(true)
        sounds['menu-music']:play()
    end
    menu_ball:update(dt)
    menu_ball:colideWall()
    if sounds['play-state-music'] then
        sounds['play-state-music']:setLooping(false)
        love.audio.stop(sounds['play-state-music'])
    end
end

function PongMenu:draw()
    push:start()
        love.graphics.clear(45, 45, 52, 0)
        love.graphics.setColor(settings.main_color, 1)
        --sets the title
        love.graphics.setFont(pong_large_font)
        love.graphics.printf(tostring(title),0,20,virtual_width,'center')
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
        buttons:buttons('draw', pong_menu_buttons)
    push:finish()
end