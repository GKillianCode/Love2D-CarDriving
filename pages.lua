
local page = {}
page.type = "pause"
page.title = ''
page.titleY = 150

page.opt1 = ''
page.opt2 = 'Quitter'
page.y1 = 340
page.y2 = 400
page.over = false

function page.load()
  
end

function page.update(dt)
  if screen == "game" then
    if Game.gameover == true then
      page.title = "GAMEOVER"
      page.opt1 = "Recommencer"
    elseif Game.pause == true then
      page.title = "PAUSE"
      page.opt1 = "Rejouer"
    end
    
    if mouseX > screenWidth/2 - 10 and mouseX < screenWidth/2 + 100 and
    mouseY > page.y1 and mouseY < page.y1 + 35 then
      love.mouse.setCursor(cursor.hand)
      page.hover = true
      page.hoverID = "1"
    elseif mouseX > screenWidth/2 - 10 and mouseX < screenWidth/2 + 100 and
    mouseY > page.y2 and mouseY < page.y2 + 35 then
      love.mouse.setCursor(cursor.hand)
      page.hover = true
      page.hoverID = "2"
    else
      love.mouse.setCursor(cursor.arrow)
      page.hover = false
    end
    
  end

end

function page.draw()
  if Game.pause == true or Game.gameover == true then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(font.page)
    local fontWidth = font.page:getWidth(page.title)
    love.graphics.print(page.title, screenWidth/2 - fontWidth/2, page.titleY)
    
    love.graphics.setFont(font.default)
    fontWidth = font.default:getWidth(page.opt1)
    love.graphics.print(page.opt1, screenWidth/2 - fontWidth/2, page.y1)

    fontWidth = font.default:getWidth(page.opt2)
    love.graphics.print(page.opt2, screenWidth/2 - fontWidth/2, page.y2)
  end
end

function page.mousepressed(x, y, button)
  if screen == "game" and page.hover == true and button == 1 then
    if Game.pause == true then
      if page.hoverID == "1" then
        Game.pause = false
      elseif page.hoverID == "2" then
        love.event.quit()
      end
    elseif Game.gameover == true then
      if page.hoverID == "1" then
        screen = "choose"
        resetGame()
      elseif page.hoverID == "2" then
        love.event.quit()
      end
    end
  end
end

return page