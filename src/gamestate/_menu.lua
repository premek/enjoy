local Signal = require 'lib.hump.signal'
local suit = require 'lib.suit'
local assets = require 'assets'
local love=love

return function (name, updatefn)

local menu

local p = {}

function p:init()
end

function p:enter ()
  Signal.emit('state_entered', name)
  menu = suit.new()
  menu.theme.color = {
    normal  = {bg = { 66, 6, 66}, fg = {18,188,188}},
    hovered = {bg = { 120,153,187}, fg = {255,255,255}},
    active  = {bg = {255,153,  0}, fg = {225,225,225}}
  }
end

function p:update(dt)
  updatefn(dt, menu)
end

function p:draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.setColor(0xd1, 0xcc, 0xd2)
  lg.rectangle('fill', 0,0, lgw, lgh)
  love.graphics.setFont(assets.font.menu)
  menu:draw()
  love.graphics.setCanvas()

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

end -- return function
