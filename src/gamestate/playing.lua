require "lib.require"
local pink = require 'lib.pink.pink.pink'
local Signal = require 'lib.hump.signal'
local Timer = require 'lib.hump.timer'

local love=love;
local assets = require 'assets'
local story = pink.getStory('game.ink')
local disableText = false

local p = {}
local lg = love.graphics
local lgw, lgh = lg.getWidth()/4, lg.getHeight()/4
local currentText = nil
local isQuestion = false
local rooms = require.tree("rooms")
local room, controlled

local joystick = require 'joystick'

local fade = {r=0, g=0, b=0, a = 255, inTime=.5, outTime=.9, text=''}
local interactionDisabled = true

local findObject = function(table, propertyName)
  for _,o in ipairs(table) do
    if o[propertyName] then return o end
  end
end

local fadeIn  = function () -- make it visible
  interactionDisabled = false
  Timer.tween(fade.inTime, fade, {a=0}, 'out-quad')
end

local fadeOut = function () -- make it black
  interactionDisabled = true
  Timer.tween(fade.outTime, fade, {a=255}, 'out-quad')
end

local function gotoRoom(name)
  local newRoom = rooms[name] or error('Room name "'..name..'" not found')

  fade.text = nil
  if newRoom.intro then
    story.choosePathString("intro_"..newRoom.intro)
    fade.text = story.continue()
  end

  Timer.script(function(wait)
    fadeOut()
    wait(fade.outTime)

    room = newRoom
    controlled = findObject(room.objects, 'controlled')
    controlled.speed = 0
    Signal.emit('room_loaded', name)

    wait(string.len(fade.text or '') / 12)
    fadeIn()
  end)
end

local function textbox ()
  if currentText then
    lg.setFont(assets.font.dialogs)
    local m = 4
    local w=lgw-7
    local _, lines = lg.getFont():getWrap(currentText, w)
    local h = lg.getFont():getHeight() * #lines + 3

    lg.setColor(0,0,0)
    lg.rectangle('fill', m-1,lgh-h-m-1,lgw-2*m+2,h+2)
    lg.setColor(255, 255, 255)
    lg.rectangle('fill', m,lgh-h-m,lgw-2*m,h)
    lg.setColor(0,0,0)
    lg.printf(currentText, m+2, lgh-h-m+2, w, 'left')
  end
end


function p:init()
  gotoRoom("0-0-start")
end

function p:resume ()
  Signal.emit('state_entered', 'playing')
end

function p:enter ()
  Signal.emit('state_entered', 'playing')
end

function p:update(dt)
  -- story text
  if not disableText then
    if currentText then return end
    isQuestion = false
    if story.canContinue then
      currentText = story.continue()
      return
    elseif #story.currentChoices > 0 then
      for i = 1, #story.currentChoices do
        currentText = (currentText or '') .. i .. "> " .. story.currentChoices[i].text .. '\n'
        isQuestion = true
      end
      return
    end
  end

  if not interactionDisabled then
  -- controls
  local axe1H = joystick and joystick:getAxes( ) or 0
  local hatR = joystick and string.find(joystick:getHat( 1 ), "r") and 1 or 0
  local hatL = joystick and string.find(joystick:getHat( 1 ), "l") and 1 or 0
  local arrR = love.keyboard.isDown("right", 'f') and 1 or 0
  local arrL = love.keyboard.isDown("left", 's') and 1 or 0

  local horizontal = axe1H + hatR - hatL + arrR - arrL

  controlled.speed = controlled.speed + horizontal * 15



  controlled.x = controlled.x + dt*controlled.speed
  controlled.speed = controlled.speed * .8
  controlled.speed = math.min(50, math.max(-50, controlled.speed))

  local r = 125
  local l = 0
  controlled.x = math.min(r, math.max(l, controlled.x))

  if controlled.x >= r and room.right then gotoRoom(room.right) end
  if controlled.x <= l and room.left  then gotoRoom(room.left)  end

  for _,o in ipairs(room.objects) do
    if o.speed and o.speed ~= 0 then
      assets.img[o.name].quads.current = assets.img[o.name].quads[math.floor(math.max(0,math.min(#assets.img[o.name].quads-1,o.x/5%#assets.img[o.name].quads)))]
    end
  end

  if room.events then
    for _, e in ipairs(room.events) do
      if not e.active then
        if controlled.x > e.x - 4 and controlled.x < e.x + 4 then
          e.active = true
          Signal.emit('roomevent', e)
        end
      elseif not(controlled.x > e.x - 4 and controlled.x < e.x + 4) then --FIXME !!!!!!!!
        e.active = false
      end
    end
  end


  end -- interactionDisabled
end


Signal.register('roomevent', function(e)
  if not currentText and e.knot and story.state.visitCountAtPathString(e.knot) == 0 then
    story.choosePathString(e.knot)
  end
end)

local function selectChoice(i)
  if isQuestion and tonumber(i) and story.currentChoices[tonumber(i)] then
    currentText=story.currentChoices[tonumber(i)].choiceText
    if isEmpty(currentText) then currentText = nil end
    story.chooseChoiceIndex(i)
    Signal.emit('storychoiceselected', i)
    return i
  end
  return nil
end

function p:keypressed(key)
  if interactionDisabled then return end

  Signal.emit('key', key)
  if key=='escape' or key=='p' then Signal.emit('pause', true) end

  if key=='space' then
    if currentText ~= nil then Signal.emit('storycontinue') end
    currentText=nil
  end

  selectChoice(key)

end

function p:joystickpressed(joystick, button )
  if interactionDisabled then return end

  Signal.emit('joystick', joystick, button)

  if not selectChoice(button) then
    if currentText ~= nil then Signal.emit('') end
    currentText=nil
  end

end


function p:draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.scale(4)
  love.graphics.setColor(255,255,255)
  if room then
    for _,o in ipairs(room.objects) do
      local flip = o.flip and -1 or 1
      local x = o.flip and o.x+25 or o.x -- fixme
      if o.noquads then love.graphics.draw(assets.img[o.name].img, x, o.y, 0, flip, 1)
      else love.graphics.draw(assets.img[o.name].img, assets.img[o.name].quads.current, x, o.y, 0, flip, 1)
      end
    end
  end
  textbox()
  love.graphics.setColor(fade.r,fade.g,fade.b,fade.a)
  lg.rectangle('fill', 0, 0, lgw, lgh)

  if fade.text then
    love.graphics.setColor(255,255,255,fade.a)
    lg.setFont(assets.font.dialogs)
    lg.printf(fade.text, 10, lgh/2-20, lgw-10*2, 'center')
  end

  love.graphics.setCanvas()

end

return p
