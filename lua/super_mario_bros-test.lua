--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "inspect"
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

function main()
  genetic.genomeMax = 10
  genetic:addGenome()
  while true do
    print("------------------------------------- cycle start --")
    genetic:processGene()
    if math.random(0, 9) == 0 then
      genetic:setScore(math.random(100, 10000))
      genetic:addGenome()
    end
    if genetic:generationIsFinish() then
      print("    ------ GENERATION END")      
      genetic:sort()
      print("scores")
      print(inspect(genetic.scores))
      print("")
      print("clear genomes")
      genetic:clearGenomes()
      print("")
      print("print genomes")
      print(inspect(genetic.genomes))
      print("")
      print("copy the 2 bests genomes")
      for j = 1, table.getn(genetic.scores) do
        for i = 1, 2 do
          if genetic.scores[j].ranking == i then
            genetic.genomes[i] = table.copy(genetic.scores[j].genome)
          end
        end
      end
      print("")
      print("print genomes")
      print(inspect(genetic.genomes))
      print("")
      print("reset index")
      genetic.genomeIndex = 0
      genetic.geneIndex = 0
      genetic.generationIndex = genetic.generationIndex + 1
      genetic:addGenome()
    end
    print("generation : ", genetic.generationIndex)
    print("genome : ", genetic.genomeIndex)
    print("gene :   ", genetic.geneIndex)
    print("")
    print(inspect(genetic.genomes))
    print("")
    print("")

    print("")
    print("-------------------------------------- cycle end --")
    io.read()
  end
end

main()