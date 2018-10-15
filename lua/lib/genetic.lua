--[[

    David Vandensteen
    2018

      Genetic Algorithm lib for LUA

--]]

require "lib/lua-extend"
local inspect = require "lib/inspect"

genetic = {}

function newGenetic(_genomeMax)
  genetic.genomeMax = _genomeMax
  genetic.geneIndex = 1
  genetic.genomeIndex = 1
  genetic.genome = {}
  genetic.genomes = {}
  genetic.generations = {}
  genetic.generationIndex = 1
  genetic.scores = {}
end

function newGenome()
  genetic.genome = {}
  if genetic.genomes[genetic.genomeIndex] then
    genetic.genome = genomeCopy(genetic.genomes[genetic.genomeIndex])
  end
end

function geneProcess(_randomTable)
  local rt = _randomTable[math.random(1, table.getn(_randomTable))]
  if not genetic.genome[genetic.geneIndex] then
    table.insert(genetic.genome, rt)
  else
    rt = genetic.genome[genetic.geneIndex]
  end
  genetic.geneIndex = genetic.geneIndex + 1
  return rt
end

function genomeCopy(_genome)
  local rt = {}
  for i = 1, table.getn(_genome) do table.insert(rt, _genome[i]) end
  return rt
end

function genomeMutate(_genome, _pourcent)
  local iterationMax = table.getn(_genome) * _pourcent
  for i = 1, iterationMax do
    local randomIndex = math.random(1, table.getn(_genome))
    _genome[randomIndex] = math.random(0, 3)
  end
  return _genome
end

function genomesMutate(_pourcent)
  for i = 1, table.getn(genetic.genomes) do
    genomeMutate(genetic.genomes[i], _pourcent)
  end
  return genetic.genomes
end

function genomesCopy(_genomes)
  local rt = {}
  for i = 1, table.getn(_genomes) do table.insert(rt, genomeCopy(_genomes[i])) end
  return rt
end

function genomeProcess(_score)
  table.insert(genetic.scores, _score)
  genetic.genomes[genetic.genomeIndex] = genomeCopy(genetic.genome)
  genetic.genomeIndex = genetic.genomeIndex + 1
  genetic.geneIndex = 1
end

function generationProcess()
  --genetic.generations[genetic.generationIndex] = genomesCopy(genetic.genomes)
  genetic.genomeIndex = 1
  genetic.geneIndex = 1
  genetic.generationIndex = genetic.generationIndex + 1
  genetic.scores = {}
  return genetic
end

function generationTrunc(_remove)
  for i = (table.getn(genetic.genomes) - _remove + 1), table.getn(genetic.genomes) do
    genetic.genomes[i] = nil
  end
  return genetic.genomes
end

function genomesTrunc(_remove)
  for i = 1, table.getn(genetic.genomes) do
    table.trunc(genetic.genomes[i], _remove)
  end
  return genetic.genomes
end

function genomesSort()
  local scoresPreSort = table.copy(genetic.scores)
  local genomesPreSort = genomesCopy(genetic.genomes)
  local bestId = {}
  table.sort(genetic.scores, function (a, b) return a > b end)
  for i = 1, table.getn(genetic.scores) do
    for j = 1, table.getn(scoresPreSort) do
      if genetic.scores[i] == scoresPreSort[j] then
        table.insert(bestId, j)
      end
    end
  end
  for i = 1, table.getn(genomesPreSort) do
    genetic.genomes[i] = genomeCopy(genomesPreSort[bestId[i]])
  end
  return genetic.scores
end

function generationIsFinish()
  local rt = false
  if genetic.genomeIndex > genetic.genomeMax then rt = true end
  return rt
end

function geneticLoad(_file)
  local rt = false
  if fileExist(_file .. ".lua") then
    print("load ".._file)
    require (_file)
    rt = true
  else
    print(_file.. " not found")
    rt = false
  end
  return rt
end

function geneticSave(_file)
  local file = io.open(_file .. ".lua", "w+") --clear
  io.close(file)
  local file = io.open(_file .. ".lua", "a")
  io.output(file)
  io.write("-- genetic dump instance\n")
  io.write("-- " .. os.date() .. "\n")
  io.write("genetic = "..inspect(genetic))
  io.write("\n")
  io.close(file)
end

function genomesSave(_file)
  local file = io.open(_file .. ".lua", "w+") --clear
  io.close(file)
  local file = io.open(_file .. ".lua", "a")
  io.output(file)
  io.write("genomesSaved = ".. inspect(genetic.genomes))
  io.write("\n")
  io.close(file)
end

function genomesLoad(_file)
  if fileExist(_file..".lua") then
    print("load " .. _file)
    require (_file)
    genetic.genomes = genomesCopy(genomesSaved)
  else
    print(_file .. " file not found ...")
  end
end