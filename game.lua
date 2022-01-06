
game = {}
game.animation = true
game.gameover = false
game.pause = false
game.nbCars = 19
game.score = 0

game.road = {}
game.road.img = love.graphics.newImage('assets/road.png')
game.road.width = game.road.img:getWidth()
game.road.height = game.road.img:getHeight()
game.road.y1 = -200
game.road.y2 = game.road.y1 + game.road.height
game.road.speed = 100

game.player = {}
game.player.skin = 1
game.player.x = 0
game.player.y = 0
game.player.speed = 80
game.player.life = 3
game.player.coin = 0
game.heart = love.graphics.newImage('assets/UI/heart.png')
game.coinUI = love.graphics.newImage('assets/UI/coinUI.png')

game.cars = {}
game.coins = {}
game.explosionTiles = {}

game.explosion = {}
game.explosion.x = 0
game.explosion.y = 0
game.explosion.id = 1
game.explosionTimer = 0
game.isExplode = false

game.coinsWidth = 40
game.coinsHeight = 40
game.coinsTimer = 0
game.newCoinSpeed = .4

game.carsID = 1
game.carsSpeed = 180
game.carsTimer = 0
game.newCarsSpeed = 1

function resetGame()
  game.pause = false
  game.gameover = false
  game.isExplode = false
  game.animation = true
  game.cars = {}
  game.coins = {}
  game.score = 0
  game.player.life = 3
  game.player.coin = 0
  game.player.x = 400
  game.player.y = screenHeight - 150
end

function newCars()  
  local car = {}
  car.type = math.random(1, game.nbCars)
  car.img = love.graphics.newImage('assets/cars/car'..tostring(car.type)..'.png')
  car.width = car.img:getWidth()
  car.height = car.img:getHeight()
  
  car.y = -100
  car.pos = math.random(1, 5)
  if car.pos == 1 then car.x = 242 end
  if car.pos == 2 then car.x = 320 end
  if car.pos == 3 then car.x = 400 end
  if car.pos == 4 then car.x = 480 end
  if car.pos == 5 then car.x = 558 end
  car.delete = false
  table.insert(game.cars, car)
end

function newCoin()
  math.randomseed(os.time() * math.random(1, os.time()))
  local coin = {}
  coin.type = math.random(1, 3)
  coin.img = love.graphics.newImage('assets/coins/coin'..tostring(coin.type)..'.png')
  coin.y = -50
  coin.pos = math.random(1, 5)
  if coin.pos == 1 then coin.x = 247 end
  if coin.pos == 2 then coin.x = 325 end
  if coin.pos == 3 then coin.x = 405 end
  if coin.pos == 4 then coin.x = 485 end
  if coin.pos == 5 then coin.x = 563 end
  coin.delete = false
  table.insert(game.coins, coin)
end

function dist(x1, y1, x2, y2, w1, h1, w2, h2)
  local distX = math.abs(x2-x1)
  local distY = math.abs(y2-y1)
  local distW = w1/2 + w2/2
  local distH = h1/2 + h2/2
  
  if distX < distW and distY < distH then
    return true
  else
    return false
  end
end

function loadExplosion()
  for i = 1, 35 do
    game.explosionTiles[i] = love.graphics.newImage('assets/explosion/img_'..tostring(i-1)..'.png')
  end
end

function game.loadSounds()
  music.menu:stop()    
  music.ambient = music[math.random(1, 4)]
  music.ambient:setVolume(.01)
  music.ambient:setLooping(true)
  music.ambient:play()
  sound.ambient:play()
end

function newPlayer()
  game.player.img = love.graphics.newImage('assets/cars/car'..tostring(game.carsID)..'.png')
  game.player.width = game.player.img:getWidth()
  game.player.height = game.player.img:getHeight()
end

function game.load()
  loadExplosion()
  newPlayer()
  
  if screen == "game" then
    loadSounds()
  end
  
  resetGame()
end

function carAnimation(dt)
  -- New Cars
  if game.carsTimer >= 1 then
    game.carsTimer = 0
    newCars()
  else
    game.carsTimer = game.carsTimer + game.newCarsSpeed*dt
  end
  
  -- Animation Cars
  for i = #game.cars, 1, -1 do
    local cars = game.cars[i]
    cars.y = cars.y + game.carsSpeed*dt

    if cars.y - cars.height/2 > screenHeight+10 then
      cars.delete = true
    end
  end
end

function explosionAnimation(dt)
  -- Animation Explosion
  if game.isExplode == true then
    if game.explosionTimer >= 1 then
      game.explosionTimer = 0
      if game.explosion.id >= 34 then
        game.explosion.id = 1
        if game.player.life > 0 then
          game.isExplode = false
        end
      else
        game.explosion.id = game.explosion.id + 1
      end
    else
      game.explosionTimer = game.explosionTimer + 200*dt
    end
  end
end

function coinAnimation(dt)
  -- New Coin
  if game.coinsTimer >= 1 then
    game.coinsTimer = 0
    newCoin()
  else
    game.coinsTimer = game.coinsTimer + game.newCoinSpeed*dt
  end
  
  -- Animation Coin
  for i = #game.coins, 1, -1 do
    local coin = game.coins[i]
    coin.y = coin.y + game.road.speed*dt

    if coin.y - game.coinsHeight/2 > screenHeight+10 then
      coin.delete = true
    end
  end
end

function checkCollisions(dt)
  -- Collisions coins
  for i = #game.coins, 1, -1 do
    local coin = game.coins[i]
    local player = game.player
    local isCollision = dist(coin.x, coin.y, player.x, player.y, game.coinsWidth, game.coinsHeight, 
      game.player.width, game.player.height)
    
    if isCollision == true then
      
      if coin.type == 1 then game.player.coin = game.player.coin + 1
      elseif coin.type == 2 then game.player.coin = game.player.coin + 5
      else game.player.coin = game.player.coin + 10 end
      
      coin.delete = true
      sound.coin:stop()
      sound.coin:play()
    end        
  end
  
  -- Collisions cars
  for i = #game.cars, 1, -1 do
    local cars = game.cars[i]
    local player = game.player
    local isCollision = dist(cars.x, cars.y, player.x, player.y, cars.width, cars.height-1, 
      game.player.width, game.player.height)
    
    if isCollision == true then          
      game.player.life = game.player.life - 1
      sound.explode:stop()
      sound.explode:play()
      game.isExplode = true
      
      if game.player.life == 0 then
        game.animation = false
        game.gameover = true
      else
        game.cars = {}
        game.coins = {}
      end
      break
    end        
  end
end

function game.update(dt)
  math.randomseed(os.time() * math.random(1, os.time()))
  
  if screen == "game" then
    game.explosion.x = game.player.x 
    game.explosion.y = game.player.y - game.player.height/2+20
    explosionAnimation(dt)
  end
  
  -- Animation
  if game.animation == true then
    game.road.y1 = game.road.y1 + game.road.speed*dt
    game.road.y2 = game.road.y2 + game.road.speed*dt
    
    if game.road.y1 > screenHeight then
      game.road.y1 = game.road.y2 - game.road.height
    end  
    if game.road.y2 > screenHeight then
      game.road.y2 = game.road.y1 - game.road.height
    end 
    
    carAnimation(dt)
    coinAnimation(dt)
    
    -- Controls
    if screen == 'game' then
      checkCollisions(dt)
      
      if love.keyboard.isDown('left') and game.player.x-game.player.width/2-8 > screenWidth/2 - game.road.width/2 then
        game.player.x = game.player.x - game.player.speed*dt
      elseif love.keyboard.isDown('right') and game.player.x+game.player.width/2+8 < screenWidth/2 + game.road.width/2 then
        game.player.x = game.player.x + game.player.speed*dt
      end    
      
      -- Score update
      game.score = game.score + 1
      
    end
    
    -- Remove Sprites
    for i = #game.coins, 1, -1 do
      local coin = game.coins[i]
      if coin.delete == true then
        table.remove(game.coins, i)
      end
    end
    for i = #game.cars, 1, -1 do
      local car = game.cars[i]
      if car.delete == true then
        table.remove(game.cars, i)
      end
    end
  end
end

function game.draw()
  love.graphics.draw(game.road.img, screenWidth/2, game.road.y1, 0, 1, 1, game.road.width/2)
  love.graphics.draw(game.road.img, screenWidth/2, game.road.y2, 0, 1, 1, game.road.width/2)
    
  for i = 1, #game.coins do
    love.graphics.draw(game.coins[i].img, game.coins[i].x, game.coins[i].y, 0, 1, 1, 
      game.coinsWidth/2, game.coinsHeight/2)
  end
  
  for i = 1, #game.cars do
    love.graphics.draw(game.cars[i].img, game.cars[i].x, game.cars[i].y, math.rad(180), 1, 1, 
      game.cars[i].width/2, game.cars[i].height/2)
  end
  
  if screen == 'game' then
    love.graphics.draw(game.player.img, game.player.x, game.player.y, 0, 1, 1, game.player.width/2, game.player.height/2)
  
    if game.isExplode == true then
      love.graphics.draw(game.explosionTiles[game.explosion.id], game.explosion.x, game.explosion.y, 0, 1, 1,
        game.explosionTiles[1]:getWidth()/2, game.explosionTiles[1]:getHeight()/2)
    end
    
    dx = 15
    for i = 1, game.player.life do
      love.graphics.draw(game.heart, dx, 15, 0, 2, 2)
      dx = dx + 25
    end
  
    love.graphics.setFont(font.score)
    
    love.graphics.setColor(1, 1, 1)
    local fontWidth = font.score:getWidth(game.score)
    if game.score < 99999 then
      love.graphics.print(math.floor(game.score), screenWidth/2 - fontWidth/2, 20)
    else
      fontWidth = font.score:getWidth(tostring(math.floor(game.score/1000))..'K')
      
      if game.score < 99999 then
        love.graphics.print(math.floor(game.score/1000)..'K', screenWidth/2 - fontWidth/2, 20)
      else
        love.graphics.print(math.floor(game.score/1000)..'M', screenWidth/2 - fontWidth/2, 20)
      end
    end
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.draw(game.coinUI, screenWidth - game.coinUI:getWidth()-15, 15)
    love.graphics.setFont(font.nbCoin)
    love.graphics.print(game.player.coin, screenWidth-game.coinUI:getWidth() + 32, 17)
  end
  
end

function game.keypressed(key)
  if screen == 'game' then
    if key == 'space' then
      sound.horn:stop()
      sound.horn:play()
    end
    if key == 'escape' and game.gameover == false then
      if game.pause == false then
        game.animation = false
        game.pause = true
      else
        game.animation = true
        game.pause = false
      end
    end
  end
end

return game