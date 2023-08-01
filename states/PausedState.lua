PausedState = class{__include = BaseState}

function PausedState:draw()
    push:start()
    love.graphics.clear(45, 45, 52, .5)
    buttons:buttons('draw', pause_menu_buttons)
    for sound_count in pairs(sound_names) do
        if sounds[sound_names[sound_count]]:isPlaying() then
            love.audio.pause(sounds[sound_names[sound_count]])
            paused_audio = sounds[sound_names[sound_count]]
        end
    end
    push:finish()
end