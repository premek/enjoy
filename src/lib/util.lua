function isEmpty(s)
  return s==nil or (s:match "^%s*(.-)%s*$") == ''
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..tostring(pos).."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(tostring(pos))+8))
                        print(indent..string.rep(" ",string.len(tostring(pos))+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..tostring(pos)..'] => "'..val..'"')
                    else
                        print(indent.."["..tostring(pos).."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


function Proxy(f)
  return setmetatable({}, {__index = function(self, k)
    local v = f(k)
    rawset(self, k, v)
    return v
  end})
end

--Image = Proxy(function(k) return love.graphics.newImage('img/' .. k .. '.png') end)
