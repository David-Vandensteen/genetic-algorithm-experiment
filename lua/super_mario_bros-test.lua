--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "inspect"
require "lua-extend"
require "genetic"

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