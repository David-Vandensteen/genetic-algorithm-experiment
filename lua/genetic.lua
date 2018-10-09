--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]

require "lua-extend"
--local inspect = require "inspect"

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

function geneProcess(_gene)
  local rt = _gene
  if not genetic.genome[genetic.geneIndex] then
    table.insert(genetic.genome, _gene)
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
  genetic.generations[genetic.generationIndex] = genomesCopy(genetic.genomes)
  genetic.genomeIndex = 1
  genetic.geneIndex = 1
  genetic.generationIndex = genetic.generationIndex + 1
  genetic.scores = {}
end

function generationTrunc(_remove)
  local generationPreTrunc = genomesCopy(genetic.genomes)
  genetic.genomes = {}
  for i = 1, table.getn(generationPreTrunc) - _remove do
    table.insert(genetic.genomes, generationPreTrunc[i])
  end
  return genetic.genomes
end

function genomesTrunc(_remove)
  for i = 1, table.getn(genetic.genomes) do
    --table.trunc()
  end
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

--[[
genetic = {
  genomes = {},
  scores = {},
  genomeIndex = 0,
  geneIndex = 0,
  generationIndex = 0,
  genomeMax = 10,

  generationIsFinish = function(self)
    local rt = false
      if self.genomeIndex > self.genomeMax then
      rt = true
    else
      rt = false
    end
    return rt
  end,

  addGeneration = function(self)
    self.generationIndex = self.generationIndex + 1
    self.genomeIndex = 0
    self.geneIndex = 0
    self.scores = {}
    return self.generationIndex
  end,

  clearGenomes = function(self) self.genomes = {} end,

  processGene = function(self)
    if not self:generationIsFinish() then
      self.geneIndex = self.geneIndex + 1
      if not self.genomes[self.genomeIndex][self.geneIndex] then
        table.insert(self.genomes[self.genomeIndex], math.random(0, 4))
      end
    end
    return self.genomes[self.genomeIndex][self.geneIndex]
  end,

  addGenome = function(self)
    if not self:generationIsFinish() then
      self.genomeIndex = self.genomeIndex + 1
      self.geneIndex = 0
      if not self.genomes[self.genomeIndex] then table.insert(self.genomes, {}) end
    end
    return self.genomes[self.genomeIndex]
  end,

  crossOver = function(self, index1, index2) end,

  mutate = function(self) end,

  setScore = function(self, score)
    local ranking = 0
    if not self:generationIsFinish() then
      table.insert(
        self.scores,
        { 
          id = self.genomeIndex,
          score = score,
          genome = table.copy(self.genomes[self.genomeIndex])
        }
      )
    end
  end,

  sort = function(self)
    local bestScore = {}
    for i = 1, table.getn(self.scores) do table.insert(bestScore, self.scores[i].score) end
    table.sort(bestScore, function (a, b) return a > b end)
    for i = 1, table.getn(bestScore) do
      for j = 1, table.getn(self.scores) do
        if bestScore[i] == self.scores[j].score then self.scores[j].ranking = i end
      end
    end
  end,
}
]]--