local Signal = require 'lib.hump.signal'
local suit = require 'lib.suit'
local assets = require 'assets'
local love=love

return function (name, updatefn, keypressedfn)

local menu

local p = {}

function p:init()
end

function p:enter ()
  Signal.emit('state_entered', name)
  menu = suit.new()

  menu.theme.color = {
    normal  = {bg = { 0x9e, 0x86, 0xa6}, fg = {0x53, 0x4c, 0x53}},
    hovered = {bg = { 0xa0, 0x66, 0x6d}, fg = {0x53, 0x4c, 0x53}},
    active  = {bg = { 0xa0, 0x66, 0x6d}, fg = {0x53, 0x4c, 0x53}},
  }
end

function p:update(dt)
  menu.layout:reset(lgw/6, 30, 10,25)
  menu.layout:row(lgw/1.5, 35.5)
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
  if keypressedfn then keypressedfn(key) end
end

function p:joystickpressed(joystick, button )

end

return p

end -- return function
