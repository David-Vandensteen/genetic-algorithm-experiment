--[[

    David Vandensteen
    2018

    Mario Bros agent test
--]]

require "lua-extend"
require "genetic"
require "super_mario_bros-settings"
function printGenomes(genomes)
  for i = 1, table.getn(genomes) do printTable(genomes[i]) end
end

myObject = {
  _genomes = {},
  add = function(self, msg)
    table.insert(self._genomes, msg)
  end,
}


function main()  
  while true do
    print("------------------------------------- cycle start --")
    myObject:add(math.random(1, 10))
    printGenomes(myObject._genomes)
    print("-------------------------------------- cycle end --")
    io.read()
  end
end

main()