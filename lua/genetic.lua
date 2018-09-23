function table.copy(tableSrc)
  local rt = {}
  for i = 1, table.getn(tableSrc) do rt[i] = tableSrc[i] end
  return rt
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

function genomeTrunc(genome, indexMax)
  for i = indexMax + 1, table.getn(genome) do
    genome[i] = nil
  end
  return genome
end

function genomeCrossOver(genome1, genome2)
  local rt = {}
  if table.getn(genome1) > table.getn(genome1) then maxRandom = table.getn(genome1)
    else maxRandom = table.getn(genome2)
  end
  local cutIndex = math.random(0, maxRandom)
  for i = 0, cutIndex do
    rt[i] = genome1[i]
  end
  for i = cutIndex, table.getn(genome2) do
    rt[i] = genome2[i]
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