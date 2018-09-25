require "genetic"

local logFile = "super_mario_bross.log"

function table.print(tableSrc) print(table.concat( tableSrc, ", ")) end

function genomesPrint(genomes)
  for i = 1, table.getn(genomes) do table.print(genomes[i]) end
end

function loggerSetFile(file)
  logFile = file
end

function loggerClear()
  local file = io.open(logFile, "w+")
  io.close(file)
end

function logger(value)
  local file = io.open(logFile, "a")
  io.output(file)
  io.write(value)
  io.write("\n")
  io.close(file)
end

function loggerGenome(genome)
  logger(table.concat(genome))
end

function loggerGenomes(genomes)
  for i = 1, table.getn(genomes) do loggerGenome(genomes[i]) end
end

print("table test")
print("create table (1, 2, 3)")
local tableSrc = {}
tableSrc[1] = 1
tableSrc[2] = 2
tableSrc[3] = 3
table.print(tableSrc)
print("")

print("table.copy(tableSrc) test")
local tableDest = table.copy(tableSrc)
tableDest[3 + 1] = 4
print("table source - result -> (1, 2, 3)")
table.print(tableSrc)
print("")
print("table dest (altered) - result -> (1, 2, 3, 4)")
table.print(tableDest)
print("table.trunc(tableSrc, 2) - result -> (1, 2)")
table.print(table.trunc(tableSrc, 2))
print('table.trunc({ 10, 11, 12, 20, 25}, 4) - result -> (10, 11, 12, 20)')
table.print(table.trunc({ 10, 11, 12, 20, 25}, 4))
print("")

print("genesMake(10) test")
local genes = genesMake(10)
table.print(genes)
print("")

print("genomesMake(3, 10) test - result -> 3 arrays of 10")
local genomes = genomesMake(3, 10)
genomesPrint(genomes)
print("")

print("genomeCrossOver{genomes[1], genomes[2]} test")
local genomeCross = genomeCrossOver{genomes[1], genomes[2]}
table.print(genomes[1])
table.print(genomes[2])
table.print(genomeCross)
print("")

print("genomeCrossOver with asymmetric table test")
local genomeA = genesMake(10)
local genomeB = genesMake(20)
table.print(genomeA)
table.print(genomeB)
table.print(genomeCrossOver{genomeA, genomeB})
print("")

print("x 4 - genomeMutate(genome) test")
table.print(genomeCross)
table.print(genomeMutate(genomeCross))
table.print(genomeMutate(genomeCross))
table.print(genomeMutate(genomeCross))
table.print(genomeMutate(genomeCross))
print("")

print("genomePad(genomes[1], 20) test - result (x * 20)")
table.print(genomePad(genomes[1], 20))
print("")

print("genomeScores test")
print("genomesMake(10, 3)")
local genomes = genomesMake(10, 3)
genomesPrint(genomes)
local bests = { 4, 3 ,2 ,1 ,6 ,5 ,9 ,8, 7, 10 }
print("best genome table")
table.print(bests)
print("genomesSortByBests(genomes, bests)")
genomesPrint(genomesSortByBests(genomes, bests))
print("genomesSortByScores(genomes, scores)")
local scores = { 300, 250, 120, 600, 900, 270, 535, 699, 50, 122 }
table.print(scores)
genomesPrint(genomesSortByScores(genomes, scores))
print("")

print("genomesTrunc(genomes, 3) test")
genomesPrint(genomesTrunc(genomes, 3))
print("")

print("genomesPad(genomes, 10, 10) test")
genomesPrint(genomesPad(genomes,10, 10))
print("")

print("logger test")
loggerSetFile("super_mario_bross.log")
loggerClear()
logger(os.date())
logger("Hello genome")
loggerGenome(genomes[1])
logger("Hello genomes")
loggerGenomes(genomes)
print("")