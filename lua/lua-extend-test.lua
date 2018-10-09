--[[

    David Vandensteen
    2018

    lua-extend-test.lua
    unit tests
--]]

require "lua-extend"

--
local t = table.copy({0, 1, 2, 3})
if t[1] == 0 and t[2] == 1 and t[3] == 2 and t[4] == 3 then
  print("table.copy test passed")
else
  print("table.copy test failed")
end
--
local t = {0, 1, 2, 3, 4, 5, 6}
table.trunc(t, 2)

--

--