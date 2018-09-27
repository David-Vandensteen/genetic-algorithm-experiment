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
local g = genome.add()
for i = 1, 20 do genome.add(g) end
printTable(g)
genome.mutate(g)
printTable(g)
print("")

print("genome.crossOver() test")
local gc = genome.crossOver{{0,0,0,0,0,0,0,0,0,0}, {1,1,1,1,1,1,1,1,1,1}}
printTable(gc)
print("")

print("genomes.sortByBests() test")
local gs = genomes.add()
for j = 1, 10 do
  for i = 1, 10 do
    genome.add(gs[j])
  end
  genomes.add(gs)
end
printGenomes(gs)
print("")

--print("genomeScores test")
--print("genomes.make(10, 3)")
--local genomesM = genomes.make(10, 3)

--printGenomes(genomesM)
--local bests = { 4, 3 ,2 ,1 ,6 ,5 ,9 ,8, 7, 10 }
--print("best genome table")
--printTable(bests)
--print("genomes.sortByBests(genomesM, bests)")
--printGenomes(genomes.sortByBests(genomesM, bests))
--print("genomes.sortByScores(genomesM, scores)")
--local scores = { 300, 250, 120, 600, 900, 270, 535, 699, 50, 122 }
--printTable(scores)
--printGenomes(genomes.sortByScores(genomesM, scores))
--print("")

--print("genomesTrunc(genomes, 3) test")
--printGenomes(genomes.trunc(genomesM, 3))
--print("")

--print("genomes.pad(genomes, 10, 10) test")
--printGenomes(genomes.pad(genomesM,10, 10))
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

print("genome add test")
local g = genome.add()
printTable(g)
genome.add(g)
printTable(g)
print("add")
genome.add(g)
printTable(g)
print("add")
genome.add(g)
printTable(g)
print("add")
genome.add(g)
printTable(g)
print("")

print("genomes add test")
local gs = genomes.add()
genome.add(gs[1])
genome.add(gs[1])
genome.add(gs[1])
genome.add(gs[1])
printGenomes(gs)
genomes.add(gs)
printGenomes(gs)
print("")
