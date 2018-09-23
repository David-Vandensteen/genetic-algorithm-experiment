require "genetic"
function table.print(tableSrc) print(table.concat( tableSrc, ", ")) end

function genomesPrint(genomes)
  for i = 1, table.getn(genomes) do table.print(genomes[i]) end
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
print("")


print("genesMake(10) test")
local genes = genesMake(10)
table.print(genes)
print("")

print("genomesMake(3, 10) test - result -> 3 arrays of 10")
local genomes = genomesMake(3, 10)
genomesPrint(genomes)
print("")

print("genomeTrunc(genomes[3], 3) test - result -> (x, x, x)")
table.print(genomeTrunc(genomes[3], 3))
print("")

print("genomeCrossOver(genomes[1], genomes[2]) test")
local genomeCross = genomeCrossOver(genomes[1], genomes[2])
table.print(genomes[1])
table.print(genomes[2])
table.print(genomeCross)
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

