--[[

    David Vandensteen
    2018

    Some extensions for my LUA code

--]]

function table.copy(_table)
  local rt = {}
  for i = 1,table.getn(_table) do table.insert(rt, _table[i]) end
  return rt
end

function table.trunc(_table, _remove)
  for i = (table.getn(_table) - _remove + 1), table.getn(_table) do _table[i] = nil end
  return _table
end

function fileExist(_name)
  local f=io.open(_name,"r")
  if f~=nil then io.close(f) return true else return false end
end

function sleep(n)
  if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
end