--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]
require "lua-extend"

genetic = {
  genomes = {},
  scores = {},
  genomeIndex = 0,
  geneIndex = 0,
  generationIndex = 1,
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
    self:addGenome()
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
