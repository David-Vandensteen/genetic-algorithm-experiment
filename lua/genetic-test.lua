--[[

    David Vandensteen
    2018

    Genetic test

--]]
require "lua-extend"
require "logger"
require "genetic"

--extend logger
function logger.genome(genome)
  logger.info(table.concat(genome))
end

function logger.genomes(genomes)
  for i = 1, table.getn(genomes) do logger.genome(genomes[i]) end
end
--

function printGenomes(genomes)
  for i = 1, table.getn(genomes) do printTable(genomes[i]) end
end

print("table.copy() test - result -> (1, 2, 3)")
local t = table.copy({1, 2, 3})
printTable(t)
print("")
print("table.trunc() - result -> (1, 2)")
printTable(table.trunc(t, 2))
print("")
print('table.trunc({ 10, 11, 12, 20, 25}, 4) - result -> (10, 11, 12, 20)')
printTable(table.trunc({ 10, 11, 12, 20, 25}, 4))
print("")

print("genome.mutate() test")
local g = {}
for i = 1, 20 do gene.add(g) end
printTable(g)
genome.mutate(g)
printTable(g)
print("")

print("genome.crossOver() test")
local gc = genome.crossOver{{0,0,0,0,0,0,0,0,0,0}, {1,1,1,1,1,1,1,1,1,1}}
printTable(gc)
print("")

print("genomes.sortByBests() test")
local gs = {}
for j = 1, 10 do
  gs[j] = {}
  for i = 1, 10 do
    gene.add(gs[j])
  end
end
printGenomes(gs)
print("")

print("table sort")
local b = {   math.random( 1,10), math.random( 1,10), math.random( 1,10),
              math.random( 1,10), math.random( 1,10), math.random( 1,10),
              math.random( 1,10), math.random( 1,10), math.random( 1,10),
              math.random( 1,10)
          }
printTable(b)
print("")
print("grenomes sort")
genomes.sortByBests(gs, b)
printGenomes(gs)
print("")

print("genomes.sortByScores() test")
local gs = {}
for j = 1, 10 do
  gs[j] = {}
  for i = 1, 10 do
    gene.add(gs[j])
  end
end
printGenomes(gs)
print("")
local s = {   math.random( 100,1000), math.random( 100,1000), math.random( 100,1000),
              math.random( 100,1000), math.random( 100,1000), math.random( 100,1000),
              math.random( 100,1000), math.random( 100,1000), math.random( 100,1000),
              math.random( 100,1000)
          }
printTable(s)
print("")
print("genomes sort")
genomes.sortByScores(gs, s)
printGenomes(gs)
print("")

--print("genomesTrunc(genomes, 3) test")
--printGenomes(genomes.trunc(genomesM, 3))
--print("")

--print("logger test")
--logger.setFile("super_mario_bross.log")
--logger.clear()
--logger.info(os.date())
--logger.info("Hello genome")
--logger.genome(genomesM[1])
--logger.info("Hello genomes")
--logger.genomes(genomesM)
--print("")
