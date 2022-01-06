
credits = {}
credits.cross = {}
credits.cross.x = 5
credits.cross.y = 5
credits.cross.img = love.graphics.newImage('assets/cross.png')
credits.hover = false

function credits.update(dt)
  if screen == 'credits' then
    if mouseX < credits.cross.img:getWidth() + credits.cross.x and
    mouseY < credits.cross.img:getHeight() + credits.cross.y then
      love.mouse.setCursor(cursor.hand)
      credits.hover = true
    else
      love.mouse.setCursor(cursor.arrow)
      credits.hover = false
    end
  end
end

function credits.draw()
  if screen == 'credits' then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    
    local cross = credits.cross
    love.graphics.draw(cross.img, cross.x, cross.y)
    
    love.graphics.setFont(font.credits)
    love.graphics.print("Credits", 20, 50)
    love.graphics.print("- Klaxon : https://freesound.org/people/Julien%20Matthey/", 30, 80)
    love.graphics.print("- Explosion asset : https://weisinx7.itch.io/", 30, 110)
    love.graphics.print("- Musique menu : https://nicolemariet.itch.io/", 30, 140)
    love.graphics.print("- Voiture ambience : https://opengameart.org/users/freetousesounds", 30, 170)
    love.graphics.print("- Musique ambience : https://hernandack.itch.io/", 30, 200)
  end
end

function credits.mousepressed(x, y, button)
  if screen == 'credits' then
    if button == 1 and credits.hover == true then
      screen = 'menu'
    end
  end
end

return credits