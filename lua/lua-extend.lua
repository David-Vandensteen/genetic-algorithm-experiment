--[[

    David Vandensteen
    2018

    Some extensions for my LUA code

--]]

function printTable(tableSrc) print(table.concat(tableSrc, ", ")) end

function table.copy(tableSrc)
  local rt = {}
  for i = 1, table.getn(tableSrc) do rt[i] = tableSrc[i] end
  return rt
end

function table.trunc(tableSrc, size)
  for i = size + 1 , table.getn(tableSrc) do tableSrc[i] = nil end
  return tableSrc
end