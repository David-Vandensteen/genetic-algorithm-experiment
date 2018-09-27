--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]
genome = {}
genomes = {}
gene = {}

function gene.add(_genome)
  local val = math.random(0, 4)
  if _genome ~= nil then table.insert(_genome, val) end
  return _genome or val
end

function genomes.add(_genomes)
  rt = _genomes or {}
  table.insert(rt, genome.add())
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

function genome.mutate(genome)
  local mutateIndex = math.random(1, table.getn(genome))
  genome[mutateIndex] = math.random(0, 4)
  return genome
end

function genomes.sortByBests(_genomes, _bests)
  local rt = {}
  for i = 1, table.getn(_genomes) do rt[i] = table.copy(_genomes[_bests[i]]) end
  for i = 1, table.getn(rt) do  _genomes[i] = table.copy(rt[i]) end
  return _genomes
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
