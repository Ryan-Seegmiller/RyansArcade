Buttons = class {}

--button constant
MENU_BUTTON_HEIGHT = 32
MENU_BUTTON_WIDTH = virtual_width * (1/3)

function Buttons:load()
    pong_menu_buttons = {}
    settings_buttons = {}
    dropdown_color_buttons = {}
    flappybird_menu_buttons = {}
    title_screen_buttons = {}
    pause_menu_buttons = {}
    pause_button = {}
    --pong menu Buttons
        table.insert(pong_menu_buttons, self:new_button(
            'button',
            "Start Game",
            function()
                g_state_machine:change('countdown-pong')
            end
        ))
        table.insert(pong_menu_buttons, self:new_button(
            'button',
            "Title",
            function()
                g_state_machine:change('title')
            end
        ))
        table.insert(pong_menu_buttons, self:new_button(
            'button',
            "Quit",
            function()
                love.event.quit()
            end
        ))

    --settings buttons/volume slider
        table.insert(settings_buttons, self:new_button(
            'slider',
            "volume          ".. tostring(settings.volume),
            function(movedX, button)
                settings_menu:volume_set(movedX, button)
            end
        ))
        table.insert(settings_buttons, self:new_button(
            'dropdown',
            'Main Color',
            function()
                self:buttons('dropdown', dropdown_color_buttons)
            end
        ))
        table.insert(settings_buttons, self:new_button(
            'dropdown',
            'Paddle Color',
            function()
                self:buttons('dropdown', dropdown_color_buttons)
            end
        ))
        table.insert(settings_buttons, self:new_button(
            'button',
            'Title',
            function()
                g_state_machine:change('title')
            end
        ))
    -- adds in the buttons for the new colors
        for index in pairs(all_colors) do
            table.insert(dropdown_color_buttons, self:new_button(
                'button',
                all_colors[index],
                function(type)
                    settings_menu:change_color(type, index)
                end
            ))
        end
    -- flappy bird menu buttons
        table.insert(flappybird_menu_buttons, self:new_button(
        'button',
        'Start',
        function()
            flappy_score = 0
            pipe_pairs = {}
            g_state_machine:change('countdown-flappybird')
        end
        ))
        table.insert(flappybird_menu_buttons, self:new_button(
            'button',
            'Title',
            function()
                g_state_machine:change('title')
            end
        ))
        table.insert(flappybird_menu_buttons, self:new_button(
            'button',
            'Quit',
            function()
                love.event.quit()
            end
        ))

    --title screen buttons
        table.insert(title_screen_buttons, self:new_button(
            'button',
            'Pong',
            function()
                g_state_machine:change('pong-menu')
            end
        ))
        table.insert(title_screen_buttons, self:new_button(
            'button',
            'Flappy Bird',
            function()
                FlappyBird:load()
                g_state_machine:change('flappyBird-menu')
            end
        ))
        table.insert(title_screen_buttons, self:new_button(
            'button',
            'Settings',
            function()
                g_state_machine:change('settings-menu')
            end
        ))
        table.insert(title_screen_buttons, self:new_button(
            'button',
            "Quit",
            function()
                love.event.quit()
            end
        ))
    --Pause menu buttons
        table.insert(pause_menu_buttons, self:new_button(
            'button',
            'title',
            function()
                g_state_machine:pause(false)
                g_state_machine:change('title')
            end
        ))
        table.insert(pause_menu_buttons, self:new_button(
            'button',
            'settings',
            function ()
                g_state_machine:pause(false)
                g_state_machine:change('settings-menu')
            end
        ))
        table.insert(pause_menu_buttons, self:new_button(
            'button',
            "Resmue",
            function()
                love.audio.play(paused_audio)
                g_state_machine:pause(false)
            end
        ))
        table.insert(pause_menu_buttons, self:new_button(
            'button',
            "Quit",
            function()
                love.event.quit()
            end
        ))
    --pause_button
        table.insert(pause_button, self:new_button(
            'pause',
            '',
            function ()

                g_state_machine:pause(true)
            end
        ))
end
function Buttons:buttons(type, button_screen, title_height, colorType, startingY)
    --sets the variebles so if they are not called nothing breaks
    type = type or 'none'
    local button_screen = button_screen or 'none'
    colorType = colorType or 'none'
    startingY = startingY or 0

    -- sets the title height on the settings screen
    local title = title_height or 0

    --button render
    local cursor_y = 0
    local dropdown_cursor_y = 0
    local margin = 16
    local total_height = (MENU_BUTTON_HEIGHT + margin) * #button_screen
    local box_hieght = #button_screen*(MENU_BUTTON_HEIGHT/4 + 1)
    local mouse_x_relative = WINDOW_WIDTH / virtual_width
    local mouse_y_relative = WINDOW_HEIGHT / virtual_height
    for i, button in ipairs(button_screen) do 
        --resets the buttons state 
        button.last = button.now
        --calclates placement
         bx =  virtual_width / 2 - MENU_BUTTON_WIDTH / 2
        local by = (virtual_height / 2) - (total_height / 2) + cursor_y + (title * 2)
        --slider placemnt
        local slidery = by + (MENU_BUTTON_HEIGHT / 2 + margin / 2)
        local sliderHeight = MENU_BUTTON_HEIGHT/5
        --slider box placement
        sliderBox = {
           Height = MENU_BUTTON_WIDTH / 6,
           Width = sliderHeight + 10,
           X = (MENU_BUTTON_WIDTH * (settings.volume/100)) + bx - (sliderHeight + 10) / 2,
           Y = slidery - sliderHeight
        }
        --outline for the color dropdown menu
        outline = {
            x = bx + MENU_BUTTON_WIDTH + 18,
            y = startingY - 2,
            width = MENU_BUTTON_WIDTH / 2 + 4,
            height = box_hieght + 2
        }
        --dropdown postions
        dropdownButtonWidth = MENU_BUTTON_WIDTH * .75
        dropdownOutlineWidth = MENU_BUTTON_WIDTH
        colorButtons = {
            x = bx + MENU_BUTTON_WIDTH + 20,
            y = startingY + dropdown_cursor_y,
            width = MENU_BUTTON_WIDTH / 2,
            height = MENU_BUTTON_HEIGHT / 4
        } 
        --pause button
        local pause_button_placement = {
            x = virtual_width - 40,
            y = 5,
            width = 10,
            height = 20
        }
        --gets mouse position
        local mx, my = love.mouse.getPosition()

        --sets the button color
        local buttonColor = {.4,.4,.5,1}
        -- determines if button has cursor over it
        local hot = (mx / mouse_x_relative) > bx and (mx / mouse_x_relative) < bx + MENU_BUTTON_WIDTH and 
        (my / mouse_y_relative) > by and (my / mouse_y_relative) < by + MENU_BUTTON_HEIGHT

        --determines if dropdown box has cursor over it 
        local dropdownButtonhot = (mx / mouse_x_relative) > bx and (mx / mouse_x_relative) < bx + MENU_BUTTON_WIDTH + 20 and 
        (my / mouse_y_relative) > by and (my / mouse_y_relative) < by + MENU_BUTTON_HEIGHT

        --determines if color buttons has cursor over it
        local colorButtonHot = (mx / mouse_x_relative) > colorButtons.x and (mx / mouse_x_relative) < colorButtons.x + colorButtons.width and 
        (my / mouse_y_relative) > colorButtons.y and (my / mouse_y_relative) < colorButtons.y + colorButtons.height

        --determines if dropdown box or the color button box has cursor over it
        local dropdownHot = dropdownButtonhot or (mx / mouse_x_relative) > outline.x and (mx / mouse_x_relative) <  outline.x + outline.width and 
        (my / mouse_y_relative) > outline.y and (my / mouse_y_relative) < outline.y + virtual_height

        local pause_hot = (mx / mouse_x_relative) > pause_button_placement.x and (mx / mouse_x_relative) < pause_button_placement.x + 25 and 
        (my / mouse_y_relative) > pause_button_placement.y and (my / mouse_y_relative) < pause_button_placement.y + 20

      

        --if the mouse is on the button set the color lighter
        if (hot or colorButtonHot) and (button.type == 'button' or button.type == 'dropdown' or button.type == 'slider') then
            buttonColor = {.8,.8,.9,1}
        end

        if pause_hot and button.type == 'pause' then 
            buttonColor = {.8,.8,.9,1}
        end
        --checks if the mouse id down
        button.now = love.mouse.isDown(1)

        --lets the slider move with the mouse 
        if type == 'update' then button.last = false end
        -- sets the volumes based off where the user clicks or drags
        if button.now and hot and not button.last and button.type == 'slider'  then
            --[[uses the current postion to get a percentage of where the mouse 
            is relative to the x cooridantaes inside the slider
            range a - b  x = number inside range
            percentage = (x,a,b) = ((x - a)/(b-a)) * 100
                ]]
           current_x = (love.mouse.getX() / 3) - bx
           SliderEndX = MENU_BUTTON_WIDTH + bx
           sliderPercentage = ((current_x - bx) / (SliderEndX - bx)) * 100
           mouseMovedX = math.floor((math.abs(sliderPercentage))+.5)
           current_x = (sliderPercentage/100) * (SliderEndX - bx) + bx
           --rounds the number but makes sure that it can still be 0
           if current_x < 1 then 
            current_x = math.floor((math.abs(current_x)))
           else
            current_x = math.floor((math.abs(current_x))+.5)
           end
           button.fn(current_x, button)

        --sets the new collor based of the type
        elseif  type == 'dropdown' and button.now and not button.last and colorButtonHot then
            button.fn(colorType)
        --does whatever function the button has in it
        elseif button.now and not button.last and ((hot and (button.type == 'button' or button.type == 'dropdown' or button.type == 'slider'))  or (pause_hot and button.type == 'pause'))then
            button.fn()
        end
        --determines what the color setting will be
        if (dropdownButtonhot) and (button.type == 'dropdown') then
            dropdownEnabeled = true
            colorMain = false
            colorPaddle = false
            dropdownOutlineWidth = dropdownOutlineWidth + 18
            if button.text == 'Main Color' then 
                colorMain = true
            else
                colorPaddle = true
            end
        end
        if button.type == 'dropdown' then
            love.graphics.rectangle(
                    'line',  
                    bx, 
                    by, 
                    dropdownOutlineWidth, 
                    MENU_BUTTON_HEIGHT )
        end
        --determines wether the dropdown is enabled
        if dropdownEnabeled and not dropdownHot then
            dropdownEnabeled = false
        --if dropdown is enabled then check what object the color is being set to
        elseif dropdownEnabeled and (button.type == 'dropdown') then 
            dropdownOutlineWidth = dropdownOutlineWidth + 18
            --display the buttons based on the color setting
            if colorMain and button.text == 'Main Color' then
                colorType = 'main'
                self:buttons('dropdown', dropdown_color_buttons,0 ,colorType, by * .75)
            elseif colorPaddle and button.text == 'Paddle Color'then
                colorType = 'paddle'
                self:buttons('dropdown', dropdown_color_buttons,0 ,colorType, by * .75)
            end
         end
        --sets the box color
        love.graphics.setColor(unpack(buttonColor))
        -- renders the box
        if button.type == 'slider' then 
           love.graphics.rectangle(
            'fill',  
            bx, 
            slidery, 
            MENU_BUTTON_WIDTH, 
            sliderHeight )
           love.graphics.rectangle(
               'fill',
               sliderBox.X,
               sliderBox.Y,
               sliderBox.Width,
               sliderBox.Height
           )
        elseif button.type == 'dropdown' then
            love.graphics.rectangle(
               'fill',  
               bx, 
               by, 
               dropdownButtonWidth, 
               MENU_BUTTON_HEIGHT )
        elseif type == 'dropdown' then
            love.graphics.rectangle(
                'line',  
                outline.x, 
                outline.y, 
                outline.width, 
                outline.height)
            love.graphics.rectangle(
               'fill',  
               colorButtons.x, 
               colorButtons.y, 
               colorButtons.width, 
               colorButtons.height )
        elseif button.type == 'pause' then
            love.graphics.rectangle(
                'fill',
                pause_button_placement.x,
                pause_button_placement.y,
                pause_button_placement.width,
                pause_button_placement.height
            )
            love.graphics.rectangle(
                'fill',
                pause_button_placement.x + pause_button_placement.width + 5,
                pause_button_placement.y,
                pause_button_placement.width,
                pause_button_placement.height
            )

        else
           love.graphics.rectangle(
               'fill',  
               bx, 
               by, 
               MENU_BUTTON_WIDTH, 
               MENU_BUTTON_HEIGHT )
        end
           
        --sets the text color 
            if button.type == 'slider'then 
                love.graphics.setColor(settings.main_color, 1)
            else
                love.graphics.setColor(0, 0, 0, 1)
            end

     --renders the text 
        if type == 'dropdown' then 
            love.graphics.print(
            button.text,
            pong_dropdown_font,
            colorButtons.x,
            colorButtons.y
        )
        else
           love.graphics.print(
                button.text,
                pong_menu_font,
                bx,
                by
            )
        end
        if button.type == 'dropdown' then
            love.graphics.setColor(settings.main_color, 1)
            love.graphics.print(
                '>',
                pong_menu_font,
                bx + MENU_BUTTON_WIDTH - 20,
                by + 10
            )
        end
        love.graphics.setColor(settings.main_color, 1)
        if type == 'dropdown' then 
            dropdown_cursor_y = dropdown_cursor_y + MENU_BUTTON_HEIGHT / 4 + 1
        else
            cursor_y = cursor_y + MENU_BUTTON_HEIGHT + margin
        end
       end
end
function Buttons:new_button(type, text, fn)
    return {
        type = type,
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end