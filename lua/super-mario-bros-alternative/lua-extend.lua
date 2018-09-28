--[[

    David Vandensteen
    2018

    Some extensions for my LUA code

--]]

function printTable(tableSrc)
  print(table.concat(tableSrc, ", "))
end

function table.copy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = setmetatable({}, getmetatable(obj))
  for k, v in pairs(obj) do res[table.copy(k)] = table.copy(v) end
  return res
end

function table.trunc(tableSrc, size)
  local _table = table.copy(tableSrc)
  for i = size + 1 , table.getn(_table) do
    _table[i] = nil
  end
  return _table
end
