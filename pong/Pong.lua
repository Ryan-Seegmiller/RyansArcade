Pong = class {}
-- speed that the paddle will move
PADDLE_SPEED = 200
paddle_boost = 1

--initialize variebles for score
player1Score = 0
player2Score = 0

--tables
explosions = {}

--game state declared as start for running
gameState = 'none'
--updates the pong game
function Pong:update(dt)
    --sets the explosion blast size 
    blast = self:getBlast(200)
    --stops the menu music
    sounds['menu-music']:setLooping(false)
    love.audio.stop(sounds['menu-music'])
    --Sets the title
    title = 'GAME ON'

    --starts the music
    sounds['play-state-music']:setLooping(true)
    sounds['play-state-music']:play()
    -- detect ball colison with paddles, reversing dx if true and
    -- slightly increasing it then altering the dy based on the position
    if ball:collides(player1) then
        --plays sound
        sounds['paddle-hit']:play()
        
        ball.dx = -ball.dx * 1.4
        --boosts the paddle to make it easier to hit fastballs
        paddle_boost = paddle_boost * 1.1
        ball.x = player1.x + 5

        -- keep velocity going in the same direction
        if ball.dy < 0 then 
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    -- detect ball colison with paddles, reversing dx if true and
    -- slightly increasing it then altering the dy based on the position
    if ball:collides(player2) then
        --plays sound
        sounds['paddle-hit']:play()
            
        ball.dx = -ball.dx * 1.4
        --boosts the paddle to make it easier to hit fastballs
        paddle_boost = paddle_boost * 1.1
        ball.x = player2.x - 4

        -- keep velocity going in the same direction
        if ball.dy < 0 then 
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    -- bounces off walls
    ball:colideWall()
    --determines score
    if ball.x < 0 then
        --sets the serving player
        servingPlayer = 1
        --sets the player score to +1
        player2Score = player2Score + 1

        --plays an explosion effect
        explosion = self:getExplosion(blast)
        explosion:setPosition(ball.x, ball.y)
        explosion:emit(20)
        table.insert(explosions,explosion)

        --plays sound
        sounds['explosion-score']:play()

        --determines if the player has won
        if player2Score >= 10 then
            winningPlayer = 2
            gameState = 'menu'
            title = 'Player 2 Wins'
            ball:reset()
            player1Score = 0
            player2Score = 0
        else
            --resets back to serve
            ball:reset()
            paddle_boost = 1
            gameState = 'serve'
            title = "Now serving player " .. tostring(servingPlayer) .. "\n\n press enter to serve"

            --Calls the serve method to determine which side the 
            --ball will go to
            ball:serve(servingPlayer)
        end
    end
    if ball.x > virtual_width then
        --sets whos serving
        servingPlayer = 2
        --increments 1 onto the score
        player1Score = player1Score + 1

        --plays an explosion effect
        explosion = self:getExplosion(blast)
        explosion:setPosition(ball.x, ball.y)
        explosion:emit(20)
        table.insert(explosions,explosion)
        --updateExplosions(dt)
        
        --plays sound
        sounds['explosion-score']:play()

        --determins if the player has won
        if player1Score >= 10 then
            winningPlayer = 1
            g_state_machine('pong-menu')
            title = 'Player 1 wins'
            ball:reset()
            player1Score = 0
            player2Score = 0
        else
            --resets back to serve
            ball:reset()
            paddle_boost = 1
            gameState = 'serve'
            title = "Now serving player " .. tostring(servingPlayer) .. "\n\n press enter to serve"

            --Calls the serve method to determine which side the 
            --ball will go to
            ball:serve(servingPlayer)
        end
    end
    --player movement  
        --player 1 movemnt
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED * paddle_boost
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED * paddle_boost
        else
            player1.dy = 0
        end

        --player 2 movement
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED * paddle_boost
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED * paddle_boost
        else
            player2.dy = 0
        end
        --update the ball bassed of its dx and dy only if the state is in play
        ball:update(dt)
        player1:update(dt)
        player2:update(dt)
 end
-- draws the pong game
function Pong:draw()
    push:apply('start')

        -- begins rendering at virtual resolution

        --clears the screen with a specific color
        love.graphics.clear(45, 45, 52, 0)
        love.graphics.setColor(settings.main_color, 1)


        love.graphics.setFont(pong_small_font)
        love.graphics.printf(title,0,20,virtual_width,'center')

        --Creates the score graphic
        --switchs font
        love.graphics.setFont(pong_score_font)

        --player 1 score
        love.graphics.print(tostring(player1Score), virtual_width / 2 - 50, 
        PONG_VIRTUAL_HEIGHT / 3)
        --player 2 score
        love.graphics.print(tostring(player2Score), virtual_width / 2 + 30, 
        PONG_VIRTUAL_HEIGHT / 3)

        buttons:buttons('draw', pause_button)
        --Creates first rectangle (left)
        love.graphics.setColor(settings.paddle_color, 1)
        player1:render()
        --Creates second rectangle (right)
        love.graphics.setColor(settings.paddle_color, 1)
        player2:render()

        love.graphics.setColor(settings.main_color, 1)

        --Creates the ball
        ball:render()

        --displays the current fps
        displayFPS()

        -- ends rendering at virtual resolution
        push:apply('end')

    push:apply('start')
    for index, explosion in ipairs(explosions) do
        love.graphics.draw(explosion, 0, 0)
    end
    push:apply('end')
 end
--removes explosion after its been destroyed
function Pong:update_explosions(dt)
    for i = table.getn(explosions), 1, -1 do
        local explosion = explosions[i]
        explosion:update(dt)
        if explosion:getCount() == 0 then
          table.remove(explosions, i)
        end
      end
 end
-- gets the explosion paramaters
function Pong:getExplosion(image) 

    pSystem = love.graphics.newParticleSystem(image, 30)
    pSystem:setParticleLifetime(0.5, 0.5)
    pSystem:setLinearAcceleration(-100, -100, 100, 100)
    pSystem:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    pSystem:setSizes(0.5, 0.5)
    return pSystem
  end
--sets up a blast for score explosion
function Pong:getBlast(size)
    local blast = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(blast)
    love.graphics.setColor(255, 255, 100, 255)
    love.graphics.circle("fill", size/2, size/2, size/2)
    love.graphics.setCanvas()
    return blast
 end
