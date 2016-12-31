require "lib.util"
require "lib.require"
local assets = require 'assets'

local Signal = require 'lib.hump.signal'
local Timer = require 'lib.hump.timer'
local Gamestate = require "lib.hump.gamestate"

local love = love

local state = require.tree("gamestate")

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(state.mainmenu)
  Signal.emit('game_loaded')
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw(dt)
end

function love.keypressed(key)
end

Signal.register('newgame', function() Gamestate.switch(state.playing) end) -- TODO reset game
Signal.register('pause', function(pause) if pause then Gamestate.push(state.pause) else Gamestate.pop() end end)
Signal.register('quit', love.event.quit)
Signal.register('mainmenu', function() Gamestate.switch(state.mainmenu) end)

local state_music = {mainmenu=2,pause=2,playing=1}
Signal.register('state_entered', function(stt) assets.music.play(state_music[stt]) end)

-- sfx
Signal.register('btnhit', function() assets.sfx.click:play() end)
Signal.register('btnentered', function() assets.sfx.click1:play() end)
Signal.register('btnleft', function() assets.sfx.click1:play() end)
Signal.register('storycontinue', function() assets.sfx.click:play() end)
Signal.register('storychoiceselected', function() assets.sfx.click:play() end)
