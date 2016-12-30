local Signal = require 'lib.hump.signal'
local suit = require 'lib.suit'
local assets = require 'assets'

local love=love
local menu

--TODO too much code copied in pause.lua

----------- love -----------
local p = {}
local lgw = love.graphics.getWidth()

function p:init()
end

function p:enter ()
  Signal.emit('state_entered', 'mainmenu')
  menu = suit.new()
  menu.theme.color = {
    normal  = {bg = { 66, 6, 66}, fg = {18,188,188}},
    hovered = {bg = { 120,153,187}, fg = {255,255,255}},
    active  = {bg = {255,153,  0}, fg = {225,225,225}}
  }
end

function p:update(dt)
  menu.layout:reset(lgw/4, 30, 10,10)
  menu.layout:row(lgw/2, 50.5)

  local ng = menu:Button("New game", menu.layout:row())
  local q = menu:Button("Quit", menu.layout:row())

  if ng.hit then Signal.emit('newgame') end
  if q.hit then Signal.emit('quit') end

  if ng.hit or q.hit then Signal.emit('btnhit') end
  if ng.entered or q.entered then Signal.emit('btnentered');  end
  if ng.left or q.left then Signal.emit('btnleft');  end

end


function p:draw()
  love.graphics.setFont(assets.font.menu)
  menu:draw()
end

function p:textinput(t)
  menu:textinput(t)
end

function p:keypressed(key)
  menu:keypressed(key)
  if key=='escape' then Signal.emit('quit') end
end

function p:joystickpressed(joystick, button )

end

return p
