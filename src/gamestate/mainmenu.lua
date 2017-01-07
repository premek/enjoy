local Signal = require 'lib.hump.signal'

return require('gamestate._menu')('mainmenu', function (dt, menu)
  menu:Label("(ゲーム名を挿入)", menu.layout:row())
  local ng = menu:Button("New game", menu.layout:row())
  local q = menu:Button("Quit", menu.layout:row())
  menu:Label("メロン 2017", menu.layout:row())


  if ng.hit then Signal.emit('newgame') end
  if q.hit then Signal.emit('quit') end

  if ng.hit or q.hit then Signal.emit('btnhit') end
  if ng.entered or q.entered then Signal.emit('btnentered');  end
  if ng.left or q.left then Signal.emit('btnleft');  end

end
)
