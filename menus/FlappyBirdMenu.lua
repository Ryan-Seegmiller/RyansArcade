FlappyBirdMenu = class{}

function FlappyBirdMenu:update(dt)
    title = 'FlappyBird'

    if not sounds['menu-music']:isPlaying() then 
        sounds['menu-music']:setLooping(true)
        sounds['menu-music']:play()
    end
    if sounds['flappy-music'] then
        sounds['flappy-music']:setLooping(false)
        love.audio.stop(sounds['flappy-music'])
    end
    background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUD_LOOPING_POINT

    ground_scroll = ((background_scroll + GROUND_SCROLL_SPEED * dt)
        % virtual_width)
    bird.y = 40
end

function FlappyBirdMenu:draw()
    push:start()
        love.graphics.draw(images['flappy-background'], -background_scroll, 0)

        love.graphics.draw(images['flappy-ground'], -ground_scroll ,virtual_height - 16)

        love.graphics.setColor(settings.main_color, 1)
        --sets the title
        love.graphics.setFont(flappy_medium_font)
        love.graphics.printf(tostring(title),0,20,virtual_width,'center')

        --Creates the ball
        bird:render()

        --button render
        buttons:buttons('draw', flappybird_menu_buttons)
    push:finish()
end