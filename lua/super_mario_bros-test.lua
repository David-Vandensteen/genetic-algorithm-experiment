--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "inspect"

genetic = {
  genomes = {},
  scores = {},
  generationIndex = 1,
  genomeMax = 10,  

  generationIsFinish = function(self)
    local rt = false
    if self:getGenomeIndex() > self.genomeMax then
      rt = true
    else
      rt = false
    end
    return rt
  end,

  getGenomeIndex = function(self) return table.getn(self.genomes) end,

  addGene = function(self)
    if not self:generationIsFinish() then table.insert(self.genomes[self:getGenomeIndex()], math.random(0, 4)) end
  end,

  addGenome = function(self)
    if not self:generationIsFinish() then table.insert(self.genomes, {}) end
  end,

  crossOver = function(self, index1, index2) end,

  mutate = function(self) end,

  setScore = function(self, score)
    local ranking = 10    
    if not self:generationIsFinish() then
      table.insert(
        self.scores,
        { 
          id = self:getGenomeIndex(),
          score = score, ranking = ranking,
          genome = self.genomes[self:getGenomeIndex()] 
        }
      )
    end
  end,

  sort = function(self)
    local bests = {}
    for i = 1, table.getn(self.scores) do
      bests[i] = i
    end
    for i = 1, table.getn(self.scores) do
      for j = 1, table.getn(self.scores) do
        if self.scores[i] > self.scores[j] then
          tmp = self.scores[i]
          self.scores[i] = self.scores[j]
          self.scores[j] = tmp
          
          tmpBest = bests[i]
          bests[i] = bests[j]
          bests[j] = tmpBest
        end
      end
    end
  return bests
  end,
}

function main()
  genetic.genomeMax = 10
  genetic:addGenome()
  while true do
    print("------------------------------------- cycle start --")
    genetic:addGene()
    if math.random(0, 9) == 0 then
      genetic:setScore(math.random(100, 10000))
      genetic:addGenome()
    end
    if genetic:generationIsFinish() then print("    ------ GENERATION END") end
    print("generation : ", genetic.generationIndex)
    print("genomes : ", genetic:getGenomeIndex())
    --printGenomes(genetic.genomes)
    print(inspect(genetic.genomes))
    print("")
    print("scores")
    print(inspect(genetic.scores))
    print("")




    print("sort table test")
    local bestScore = {}
    for i = 1, table.getn(genetic.scores) do table.insert(bestScore, genetic.scores[i].score) end

    print("best table to sort")
    print(inspect(bestScore))
    print("")

    print("best table sorted")
    table.sort(bestScore, function (a, b) return a > b end)
    print(inspect(bestScore))
    print("")

    print("")
    print("-------------------------------------- cycle end --")
    io.read()
  end
end

main()