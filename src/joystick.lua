local Signal = require 'lib.hump.signal'
local joysticks = love.joystick.getJoysticks()
Signal.emit("joysticks_found", joysticks)

if #joysticks > 0 then
  Signal.emit("joystick_set", joysticks[1]:isGamepad(), joysticks[1]:getName(), joysticks[1]:getAxes())
  return joysticks[1]
end

return false
