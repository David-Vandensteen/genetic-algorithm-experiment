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

print("table test")
print("create table (1, 2, 3)")
local tableSrc = {}
tableSrc[1] = 1
tableSrc[2] = 2
tableSrc[3] = 3
printTable(tableSrc)
print("")

print("table.copy(tableSrc) test")
local tableDest = table.copy(tableSrc)
tableDest[3 + 1] = 4
print("table source - result -> (1, 2, 3)")
printTable(tableSrc)
print("")
print("table dest (altered) - result -> (1, 2, 3, 4)")
printTable(tableDest)
print("table.trunc(tableSrc, 2) - result -> (1, 2)")
printTable(table.trunc(tableSrc, 2))
print('table.trunc({ 10, 11, 12, 20, 25}, 4) - result -> (10, 11, 12, 20)')
printTable(table.trunc({ 10, 11, 12, 20, 25}, 4))
print("")

print("genome.make(10) test")
local genes = genome.make(10)
printTable(genes)
print("")

print("genomes.make(3, 10) test - result -> 3 arrays of 10")
local genomesM = genomes.make(3, 10)
printGenomes(genomes)
print("")

print("genome.crossOver{genomesM[1], genomesM[2]} test")
local genomeCross = genome.crossOver{genomesM[1], genomesM[2]}
printTable(genomesM[1])
printTable(genomesM[2])
printTable(genomeCross)
print("")

print("genomeCrossOver with asymmetric table test")
local genomeA = genome.make(10)
local genomeB = genome.make(20)
printTable(genomeA)
printTable(genomeB)
printTable(genome.crossOver{genomeA, genomeB})
print("")

print("x 4 - genomeMutate(genome) test")
printTable(genomeCross)
printTable(genome.mutate(genomeCross))
printTable(genome.mutate(genomeCross))
printTable(genome.mutate(genomeCross))
printTable(genome.mutate(genomeCross))
print("")

print("genome.pad(genomes[1], 20) test - result (x * 20)")
printTable(genome.pad(genomesM[1], 20))
print("")

print("genomeScores test")
print("genomes.make(10, 3)")
local genomesM = genomes.make(10, 3)

printGenomes(genomesM)
local bests = { 4, 3 ,2 ,1 ,6 ,5 ,9 ,8, 7, 10 }
print("best genome table")
printTable(bests)
print("genomes.sortByBests(genomesM, bests)")
printGenomes(genomes.sortByBests(genomesM, bests))
print("genomes.sortByScores(genomesM, scores)")
local scores = { 300, 250, 120, 600, 900, 270, 535, 699, 50, 122 }
printTable(scores)
printGenomes(genomes.sortByScores(genomesM, scores))
print("")

print("genomesTrunc(genomes, 3) test")
printGenomes(genomes.trunc(genomesM, 3))
print("")

print("genomes.pad(genomes, 10, 10) test")
printGenomes(genomes.pad(genomesM,10, 10))
print("")

print("logger test")
logger.setFile("super_mario_bross.log")
logger.clear()
logger.info(os.date())
logger.info("Hello genome")
logger.genome(genomesM[1])
logger.info("Hello genomes")
logger.genomes(genomesM)
print("")

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
