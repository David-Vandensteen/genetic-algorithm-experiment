--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]
genome = {}
genomes = {}

function genome.add(genome)
  if genome ~= nil then
    table.insert(genome, math.random(0, 4))
  end
  return genome or {}
end

function genomes.add(genomes)
  genomes = genomes or {}
  table.insert(genomes, genome.add())
  return genomes
end

function genome.crossOver(genomes)
  local rt = {}
  if table.getn(genomes[1]) > table.getn(genomes[1]) then maxRandom = table.getn(genomes[1])
    else maxRandom = table.getn(genomes[2])
  end
  local cutIndex = math.random(0, maxRandom)
  for i = 0, cutIndex do
    rt[i] = genomes[1][i]
  end
  for i = cutIndex, table.getn(genomes[2]) do
    rt[i] = genomes[2][i]
  end
  return rt
end

function genome.mutate(genome)
  local mutateIndex = math.random(1, table.getn(genome))
  genome[mutateIndex] = math.random(0, 4)
  return genome
end

function genomes.sortByBests(genomes, bests)
  local rt = {}
  for i = 1, table.getn(genomes) do rt[i] = genomes[bests[i]] end
  genomes = table.copy(rt)
  return rt
end

function genomes.sortByScores(pgenomes, scores)
  local bests = {}
  for i = 1, table.getn(scores) do
    bests[i] = i
  end
  for i = 1, table.getn(scores) do
    for j = 1, table.getn(scores) do
      if scores[i] > scores[j] then
        tmp = scores[i]
        scores[i] = scores[j]
        scores[j] = tmp
        
        tmpBest = bests[i]
        bests[i] = bests[j]
        bests[j] = tmpBest
      end
    end
  end
  return genomes.sortByBests(pgenomes, bests)
end
