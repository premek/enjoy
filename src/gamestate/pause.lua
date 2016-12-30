local Signal = require 'lib.hump.signal'
local suit = require 'lib.suit'
local assets = require 'assets'

local love=love
local menu

----------- love -----------
local p = {}
local lgw = love.graphics.getWidth()

function p:init()
end

function p:enter ()
  Signal.emit('state_entered', 'pause')

  menu = suit.new()
  menu.theme.color = { -- FIXME!
    normal  = {bg = { 66, 6, 66}, fg = {18,188,188}},
    hovered = {bg = { 120,153,187}, fg = {255,255,255}},
    active  = {bg = {255,153,  0}, fg = {225,225,225}}
  }

end

function p:update(dt)
  menu.layout:reset(lgw/4, 30, 10,10)
  menu.layout:row(lgw/2, 50.5)

  menu:Label("Paused", menu.layout:row())

  local c = menu:Button("Continue", menu.layout:row())
  local q = menu:Button("Quit to main menu", menu.layout:row())

  if c.hit then Signal.emit('pause', false) end
  if q.hit then Signal.emit('mainmenu') end

  if c.hit or q.hit then Signal.emit('btnhit') end
  if c.entered or q.entered then Signal.emit('btnentered');  end
  if c.left or q.left then Signal.emit('btnleft');  end

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
  if key=='escape' or key=='p' then Signal.emit('pause', false) end
end

function p:joystickpressed(joystick, button )

end

return p
