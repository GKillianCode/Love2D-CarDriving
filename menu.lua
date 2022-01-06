
menu = {}
menu.title = ""
menu.titleY = -100
menu.titleTimer = 0
menu.timer = 0
menu.animation = false
menu.titleAnimation = false
menu.hover = false
menu.hoverID = nil

menu.opt = {}
menu.opt[1] = {}
menu.opt[1].title = 'Jouer'
menu.opt[1].y = 0
menu.opt[2] = {}
menu.opt[2].title = 'Credits'
menu.opt[2].y = 0
menu.opt[3] = {}
menu.opt[3].title = 'Quitter'
menu.opt[3].y = 0

function menu.load()
  
  menu.title = love.window.getTitle()
  
  menu.animation = true
  menu.titleAnimation = true
  
  menu.opt[1].y = screenHeight - 330
  menu.opt[2].y = screenHeight - 280
  menu.opt[3].y = screenHeight - 230
  menu.optX = screenWidth/2 - Game.road.width/2 + 20
  
end

function menu.update(dt)
  if screen == 'menu' and menu.animation == true then
    if menu.titleY < 150 then
      menu.titleY = menu.titleY + Game.road.speed*dt
    end
    
    if mouseX >= menu.optX and mouseX < menu.optX + 120 and 
    mouseY > menu.opt[1].y and mouseY < menu.opt[3].y + 40 then
      love.mouse.setCursor(cursor.hand)
      menu.hover = true
      
      if mouseY < menu.opt[2].y then
        menu.hoverID = 1
      elseif mouseY > menu.opt[2].y and mouseY < menu.opt[3].y then
        menu.hoverID = 2
      else
        menu.hoverID = 3
      end
    else
      love.mouse.setCursor(cursor.arrow)
      menu.hover = false
    end
    
  end
end

function menu.draw()
  if screen == 'menu' then
    love.graphics.setColor(0, 0, 0, .4)
    love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, .4, .4)
    love.graphics.setFont(font.title)
    local fontWidth = font.title:getWidth(menu.title)
    love.graphics.print(menu.title, screenWidth/2 - fontWidth/2, menu.titleY)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font.menu)
    for i = 1, #menu.opt do
      if menu.hover == true then
        if menu.hoverID == i then
          love.graphics.setColor(1, 0, 0)
        else
          love.graphics.setColor(1, 1, 1)
        end
      end
      local fontWidth = font.menu:getWidth(menu.opt[i].title)
      love.graphics.print(menu.opt[i].title, menu.optX, menu.opt[i].y)
    end
    love.graphics.setColor(1, 1, 1)
    
  end
end

function menu.mousepressed(x, y, button)
  if screen == 'menu' and menu.hover == true then
    if menu.hoverID == 1 then
      screen = "choose"
      --[[screen = 'game'
      Game.cars = {}
      Game.coins = {}
      Game.loadSounds()]]
    elseif menu.hoverID == 2 then
      screen = 'credits'
    else
      love.event.quit()
    end
  end
end

return menu