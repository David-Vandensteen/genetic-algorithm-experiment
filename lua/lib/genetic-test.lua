--[[

    David Vandensteen
    2018

    Genetic test

--]]
local inspect = require "inspect"
require "lua-extend"
require "genetic"
print("")

--
newGenetic(10)
if genetic.geneIndex == 1 and genetic.generationIndex == 1 and genetic.genomeIndex == 1 and genetic.genomeMax == 10 then
  print("newGenetic() test passed")
else
  print("newGenetic() test failed")
end
--

--
geneProcess(8)
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
    geneProcess(math.random(0, 4))
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
    geneProcess(2)
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