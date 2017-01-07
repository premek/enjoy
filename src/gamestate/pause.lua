local Signal = require 'lib.hump.signal'

return require('gamestate._menu')('pause', function (dt, menu)

  menu:Label("Paused", menu.layout:row())

  local c = menu:Button("Continue", menu.layout:row())
  local q = menu:Button("Quit to main menu", menu.layout:row())

  if c.hit then Signal.emit('pause', false) end
  if q.hit then Signal.emit('mainmenu') end

  if c.hit or q.hit then Signal.emit('btnhit') end
  if c.entered or q.entered then Signal.emit('btnentered');  end
  if c.left or q.left then Signal.emit('btnleft');  end

end,

function (key)
  if key=='escape' then Signal.emit('pause', false) end
end
)
