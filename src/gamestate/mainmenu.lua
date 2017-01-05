local Signal = require 'lib.hump.signal'

return require('gamestate._menu')('mainmenu', function (dt, menu)

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
)
