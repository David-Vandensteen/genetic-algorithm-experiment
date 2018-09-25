--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]
genome = {}
genomes = {}

function genome.make(geneMax)
  local genes = {}
  for i = 1, geneMax do genes[i] = math.random(0,4) end
  return genes
end

function genomes.make(genomeMax, geneMax)
  local rt = {}
  for i = 1, genomeMax do rt[i] = genome.make(geneMax) end
  return rt
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

function genome.pad(genome, geneMax)
  for i = 1, geneMax do
    if genome[i] == nil then genome[i] = math.random(0, 4) end
  end
  return genome
end

function genome.mutate(genome)
  local mutateIndex = math.random(1, table.getn(genome))
  genome[mutateIndex] = math.random(0, 4)
  return genome
end

function genomes.trunc(genomes, size)
  for i = size + 1, table.getn(genomes) do genomes[i] = nil end
  return genomes
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

function genomes.pad(genomes, genomeMax, geneMax)
  for i = 1, genomeMax do
    if genomes[i] == nil then 
      genomes[i] = genome.make(geneMax)
    else
      genome.pad(genomes[i], geneMax)
    end
  end
  return genomes
end

