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