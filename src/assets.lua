-- assets are loaded when this is require'd first time
-- when it is required again, the same table is returned with the content that was already loaded before
-- TODO make it more library-like

local Timer = require 'lib.hump.timer'

local love = love

local a = {
  music = {},
  img = {},
  sfx = {},
  font = {}
}


a.music[1] = love.audio.newSource( 'music/Jonas K - Tonight (Original).mp3', 'stream' )
a.music[1]:setLooping(true)

a.music[2] = love.audio.newSource( 'music/song_002_r1_session.ogg', 'stream' )
a.music[2]:setLooping(true)

a.music.volume = 0
a.music.fadein = 1.7
a.music.fadeout = .1
a.music.current = nil

a.music.play = function (i)
  if not a.music[i] or a.music[i]:isPlaying() then return end

  Timer.tween(a.music.fadeout, a.music, {volume=0}, 'out-quad', function ()
    if a.music.current then a.music.current:pause() end
    a.music.current = a.music[i]
    a.music.current:play()
    Timer.tween(a.music.fadein, a.music, {volume=.85}, 'out-quad')
  end)

  Timer.during(a.music.fadeout + a.music.fadein + .2, function(dt)
    if a.music.current then a.music.current:setVolume(a.music.volume) end
  end)

end




for _,v in ipairs(love.filesystem.getDirectoryItems("sfx")) do
  local k = v:match("^(.+)%..+$")
  a.sfx[k] = love.audio.newSource("sfx/"..v, "static")
  a.sfx[k]:setVolume(0.9)
end
--for _,v in ipairs({"idle", "going"}) do sfx[v]:setLooping(true) end
--sfx.radiofm:setVolume(1)



local getQuads = function(image)
  local s = 64
  local quads={}
  for i=0,image:getWidth()/s do
    quads[i] = love.graphics.newQuad(s*i, 0, s, s, image:getWidth(), image:getHeight())
  end
  return quads
end


love.graphics.setDefaultFilter("nearest")

for _,v in ipairs(love.filesystem.getDirectoryItems("img")) do
  local f = v:match("^(.+)%..+$")
  a.img[f] = {}
  a.img[f].img = love.graphics.newImage("img/"..v)
  a.img[f].quads = getQuads(a.img[f].img)
  a.img[f].quads.current = a.img[f].quads[0]
end


a.font.dialogs = love.graphics.newFont( "font/tom-thumb.bdf", 6 )
a.font.menu = love.graphics.newFont( "font/FUTRFW.TTF", 18 )

return a
