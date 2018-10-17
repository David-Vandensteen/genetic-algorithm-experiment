--[[

    David Vandensteen
    2018

    Genetic Algorithm lib test

--]]
local inspect = require "lib/inspect"
require "lib/lua-extend"
require "lib/genetic"
print("")

--
newGenetic(10)
if genetic.geneIndex == 1 and genetic.generationIndex == 1 and genetic.genomeIndex == 1 and genetic.genomeMax == 10 and genetic.genomeTime == 0 then
  print("newGenetic() test passed")
else
  print("newGenetic() test failed")
end
--

--
geneProcess({8})
if genetic.geneIndex == 2 and genetic.generationIndex == 1 and genetic.genomeIndex == 1 and genetic.genome[1] == 8 then
  print("geneProcess() test passed")
else
  print("geneProcess() test failed")
end
--

--
if not generationIsFinish() then
  print("generationIsFinish() test passed")
else
  print("generationIsFinish() test failed")
end
--

--
generationProcess()
if genetic.geneIndex == 1 and genetic.generationIndex == 2 then
  print("generationProcess() test passed")
else
  print("generationProcess() test failed")
end
--

--
newGenetic(3)
for i = 1, 3 do
  newGenome()
  for j = 1, 10 do
    geneProcess({0, 1, 2, 3, 4})
  end
  genomeProcess(1380)
end
if generationIsFinish() then
  print("generationIsFinish() test passed")
else
  print("generationIsFinish() test failed")
end
--

--
if genetic.scores[1] == 1380 then
  print("score test passed")
else
  print("score test failed")
end
--

--
newGenetic(3)
for i = 1, 3 do
  newGenome()
  for j = 1, 3 do
    geneProcess({2})
  end
  genomeProcess(math.random(1000, 10000))
end
local t = genomeCopy(genetic.genomes[1])
if t[1] == 2 and t[2] == 2 and t[3] == 2 then
  print("genomeCopy() test passed")
else
  print("genomeCopy() test failed")
end
--

--
newGenetic(3)

newGenome()
geneProcess({0})
genomeProcess()

newGenome()
geneProcess({1})
genomeProcess()

newGenome()
geneProcess({2})
genomeProcess()

genomesMutate(1, {4, 3})
if 
  (genetic.genomes[1][1] == 3 or genetic.genomes[1][1] == 4)
            and
  (genetic.genomes[2][1] == 3 or genetic.genomes[2][1] == 4)
            and
  (genetic.genomes[3][1] == 3 or genetic.genomes[3][1] == 4)
then
  print("genomesMutate() test passed")
else
  print("genomesMutate() test failed")
end
--

--
newGenetic(3)

newGenome()
geneProcess({0})
genomeProcess(1500)

newGenome()
geneProcess({1})
genomeProcess(1501)

newGenome()
geneProcess({2})
genomeProcess(1502)

if genetic.genomes[1][1] == 0 and genetic.genomes[2][1] == 1 and genetic.genomes[3][1] == 2 then
  print("geneProcess() test passed")
else
  print("geneProcess() test failed")
end
--

--
newGenetic(3)

newGenome(0)
geneProcess({0})
genomeTimeEnd(1000)
genomeProcess(1500)

newGenome(0)
geneProcess({1})
genomeTimeEnd(1001)
genomeProcess(1501)

newGenome(0)
geneProcess({2})
genomeTimeEnd(1002)
genomeProcess(1502)

if genetic.times[1] == 1000 and genetic.times[2] == 1001 and genetic.times[3] == 1002 then
  print("genomeTimeEnd() test passed")
else
  print("genomeTimeEnd() test failed")
end
--

--
newGenetic(3)

newGenome(0)
geneProcess({0})
genomeTimeEnd(1000)
genomeProcess(1500)

newGenome(0)
geneProcess({1})
genomeTimeEnd(1001)
genomeProcess(1501)

newGenome(0)
geneProcess({2})
genomeTimeEnd(1002)
genomeProcess(1502)

print(inspect(genetic))
genomesSort()
print(inspect(genetic))

if  genetic.genomes[1][1] == 2 and genetic.genomes[2][1] == 1 and
    genetic.genomes[3][1] == 0 and genetic.scores[1] == 1502 and
    genetic.scores[2] == 1501 and genetic.scores[3] == 1500 and
    genetic.times[1] == 1002 and
    genetic.times[2] == 1001 and
    genetic.times[3] == 1000
then
  print("genomesSort() test passed")
else
  print("genomesSort() test failed")
end
--
