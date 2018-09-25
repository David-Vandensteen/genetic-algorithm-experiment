--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]

function table.copy(tableSrc)
  local rt = {}
  for i = 1, table.getn(tableSrc) do rt[i] = tableSrc[i] end
  return rt
end

function table.trunc(tableSrc, size)
  for i = size + 1 , table.getn(tableSrc) do tableSrc[i] = nil end
  return tableSrc
end

function genesMake(geneMax)
  local genes = {}
  for i = 1, geneMax do genes[i] = math.random(0,4) end
  return genes
end

function genomesMake(genomeMax, geneMax)
  local genomes = {}
  for i = 1, genomeMax do genomes[i] = genesMake(geneMax) end
  return genomes
end

function genomeCrossOver(genomes)
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

function genomePad(genome, geneMax)
  for i = 1, geneMax do
    if genome[i] == nil then genome[i] = math.random(0, 4) end
  end
  return genome
end

function genomeMutate(genome)
  local mutateIndex = math.random(1, table.getn(genome))
  genome[mutateIndex] = math.random(0, 4)
  return genome
end

function genomesTrunc(genomes, size)
  for i = size + 1, table.getn(genomes) do genomes[i] = nil end
  return genomes
end

function genomesSortByBests(genomes, bests)
  local rt = {}
  for i = 1, table.getn(genomes) do rt[i] = genomes[bests[i]] end
  genomes = table.copy(rt)
  return rt
end

function genomesSortByScores(genomes, scores)
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
  return genomesSortByBests(genomes, bests)
end

function genomesPad(genomes, genomeMax, geneMax)
  for i = 1, genomeMax do
    if genomes[i] == nil then 
      genomes[i] = genesMake(geneMax)
    else
      genomePad(genomes[i], geneMax)
    end
  end
  return genomes
end

