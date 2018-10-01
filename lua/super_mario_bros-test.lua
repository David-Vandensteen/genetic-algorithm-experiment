--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "inspect"

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

  processGene = function(self)
    self.geneIndex = self.geneIndex + 1
    if not self:generationIsFinish() then
      if not self.genomes[self.genomeIndex][self.geneIndex] then
        table.insert(self.genomes[self.genomeIndex], math.random(0, 4))
      end
    end
    return self.genomes[self.genomeIndex][self.geneIndex]
  end,

  processGenome = function(self)
  end,

  addGene = function(self)
    self.geneIndex = self.geneIndex + 1
    if not self:generationIsFinish() then table.insert(self.genomes[self.genomeIndex], math.random(0, 4)) end
  end,

  addGenome = function(self)
    self.genomeIndex = self.genomeIndex + 1
    self.geneIndex = 0
    if not self:generationIsFinish() then table.insert(self.genomes, {}) end
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
          genome = self.genomes[self.genomeIndex] 
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

function main()
  genetic.genomeMax = 10
  genetic:addGenome()
  while true do
    print("------------------------------------- cycle start --")
    --genetic:addGene()
    genetic:processGene()
    if math.random(0, 9) == 0 then
      genetic:setScore(math.random(100, 10000))
      genetic:sort()
      genetic:addGenome()
    end
    if genetic:generationIsFinish() then
      print("    ------ GENERATION END")      
    end
    print("generation : ", genetic.generationIndex)
    print("genome : ", genetic.genomeIndex)
    print("gene :   ", genetic.geneIndex)
    print("")
    print(inspect(genetic.genomes))
    print("")
    print("scores")
    print(inspect(genetic.scores))
    print("")

    print("")
    print("-------------------------------------- cycle end --")
    io.read()
  end
end

main()