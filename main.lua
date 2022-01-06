io.stdout:setvbuf('no')
if arg[#arg] == '-debug' then require('mobdebug').start() end

Game = require('game')
Menu = require('menu')
Cars = require('cars')
Credits = require('credits')
Pages = require('pages')

screen = 'menu'

sound = {}
sound.coin = love.audio.newSource('sounds/coin.wav', 'static')
sound.horn = love.audio.newSource('sounds/klaxon.wav', 'static')
sound.explode = love.audio.newSource('sounds/explode.wav', 'static')
sound.ambient = love.audio.newSource('sounds/ambient.wav', 'stream')
sound.coin:setVolume(.2)
sound.horn:setVolume(.2)
sound.explode:setVolume(.2)
sound.ambient:setVolume(1)
sound.ambient:setLooping(true)

music = {}
music[1] = love.audio.newSource('musics/A Brand New Wisdom.ogg', 'stream')
music[2] = love.audio.newSource('musics/Just Saying Tho.ogg', 'stream')
music[3] = love.audio.newSource('musics/Swinging Sweet.ogg', 'stream')
music[4] = love.audio.newSource('musics/Winter Dust.ogg', 'stream')
music.menu = love.audio.newSource('musics/Spy.mp3', 'stream')

--[[
Attributions
- Klaxon : https://freesound.org/people/Julien%20Matthey/
- Explosion asset : https://weisinx7.itch.io/
- Musique menu : https://nicolemariet.itch.io/
- Voiture ambience : https://opengameart.org/users/freetousesounds
- Musique ambience : https://hernandack.itch.io/
]]

function love.load()
  love.window.setTitle('SUPER DRIVER')
  love.window.setMode(800, 600)
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  font = {}
  font.title = love.graphics.newFont('fonts/CaviarDreams_Bold.ttf', 80)
  font.menu = love.graphics.newFont('fonts/CaviarDreams.ttf', 35)
  font.score = love.graphics.newFont('fonts/CaviarDreams_Bold.ttf', 42)
  font.page = love.graphics.newFont('fonts/CaviarDreams_Bold.ttf', 80)
  font.default = love.graphics.newFont('fonts/CaviarDreams.ttf', 30)
  font.nbCoin = love.graphics.newFont('fonts/CaviarDreams_Bold.ttf', 30)
  font.credits = love.graphics.newFont('fonts/CaviarDreams.ttf', 22)
  
  cursor = {}
  cursor.hand = love.mouse.getSystemCursor('hand')
  cursor.arrow = love.mouse.getSystemCursor('arrow')
  
  if screen ~= "game" then
    music.menu:play()
    music.menu:setVolume(.1)
    music.menu:setLooping(true)
  end
  
  Game.load()
  Menu.load()
  Cars.load()
  Pages.load()
end

function love.update(dt)
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  
  Game.update(dt)
  Menu.update(dt)
  Credits.update(dt)
  Cars.update(dt)
  Pages.update(dt)
end

function love.draw()
  Game.draw()
  Menu.draw()
  Credits.draw()
  Cars.draw()
  Pages.draw()
end

function love.keypressed(key)  
  Game.keypressed(key)
  Cars.keypressed(key)
end

function love.mousepressed(x, y, button)
  Menu.mousepressed(x, y, button)
  Credits.mousepressed(x, y, button)
  Cars.mousepressed(x, y, button)
  Pages.mousepressed(x, y, button)
end
  
  
