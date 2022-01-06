
local cars = {}
cars.defaultColor = 1
cars.color = 1
cars.type = 1
cars.nbType = 6
cars.id = 1
cars.cars = {}
cars.selectBtn = {}
cars.selectBtn.width = 160
cars.selectBtn.height = 30
cars.selectBtn.color = {1, 1, 1}
cars.btnDirection = {}
cars.btnDirection.img = love.graphics.newImage('assets/btnDirection.png')
cars.hover = true
cars.hoverID = ""


function loadCars()
  local id = 1
  for i = 1, Game.nbCars do
    cars.cars[id] = love.graphics.newImage("assets/cars/car"..tostring(i)..".png")
    id = id + 1
  end
end

function cars.load()
  loadCars()
  
  cars.selectBtn.x = screenWidth/2 - cars.selectBtn.width/2
  cars.selectBtn.y = screenHeight-200
  
  cars.btnDirection.x1 = 50
  cars.btnDirection.x2 = screenWidth - 50
  cars.btnDirection.y = screenHeight/2
end

function cars.update(dt)
  if screen == "choose" then
    local btnSelect = cars.selectBtn
    local btnDir = cars.btnDirection
    if mouseX > btnSelect.x and mouseX < btnSelect.x + btnSelect.width and
    mouseY > btnSelect.y and mouseY < btnSelect.y + btnSelect.height then
      love.mouse.setCursor(cursor.hand)
      cars.hover = true
      cars.hoverID = "btnSelect"
    elseif mouseX > btnDir.x1 - btnDir.img:getWidth()/2 and mouseX < btnDir.x1 + btnDir.img:getWidth()/2 and
    mouseY > btnDir.y - btnDir.img:getHeight()/2 and mouseY < btnDir.y + btnDir.img:getHeight()/2 then
      love.mouse.setCursor(cursor.hand)
      cars.hover = true
      cars.hoverID = "btn1"
    elseif mouseX > btnDir.x2 - btnDir.img:getWidth()/2 and mouseX < btnDir.x2 + btnDir.img:getWidth()/2 and
    mouseY > btnDir.y - btnDir.img:getHeight()/2 and mouseY < btnDir.y + btnDir.img:getHeight()/2 then
      love.mouse.setCursor(cursor.hand)
      cars.hover = true
      cars.hoverID = "btn2"
    else
      love.mouse.setCursor(cursor.arrow)
      cars.hover = false
    end
  end
end

function cars.draw()
  if screen == "choose" then
    love.graphics.setColor(0, 0, 0, .55)
    love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 10, 10, screenWidth-20, screenHeight-20)
    
    love.graphics.draw(cars.cars[cars.id], screenWidth/2, screenHeight/2-50, math.rad(45), 1.4, 1.4, cars.cars[cars.id]:getWidth()/2, cars.cars[cars.id]:getHeight()/2)
    
    local btn = cars.selectBtn
    love.graphics.setColor(btn.color)
    love.graphics.rectangle('fill', btn.x, btn.y, btn.width, btn.height, 2)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font.credits)
    local textWidth = font.credits:getWidth("Choisir")
    love.graphics.print("Choisir", screenWidth/2-textWidth/2, btn.y+2)
    love.graphics.setColor(1, 1, 1)
    
    local btnDir = cars.btnDirection
    love.graphics.draw(btnDir.img, btnDir.x1, btnDir.y, math.rad(180), 1, 1, btnDir.img:getWidth()/2, btnDir.img:getHeight()/2)
    love.graphics.draw(btnDir.img, btnDir.x2, btnDir.y, 0, 1, 1, btnDir.img:getWidth()/2, btnDir.img:getHeight()/2)
    
  end
end

function cars.keypressed(key)
  if screen == "choose" then
    if key == 'left' then
      if cars.id > 1 then
        cars.id = cars.id - 1
      end
    end
    if key == 'right' then
      if cars.id < Game.nbCars then
        cars.id = cars.id + 1
      end
    end
  end
end

function cars.mousepressed(x, y, button)
  if screen == "choose" and button == 1 and cars.hover == true then
    if cars.hoverID == "btnSelect" then
      Game.carsID = cars.id
      newPlayer()
      screen = 'game'
      Game.cars = {}
      Game.coins = {}
      Game.loadSounds()
    elseif cars.hoverID == "btn1" then
      if cars.id > 1 then
        cars.id = cars.id - 1
      end
    else
      if cars.id < Game.nbCars then
        cars.id = cars.id + 1
      end
    end
  end
end

return cars
