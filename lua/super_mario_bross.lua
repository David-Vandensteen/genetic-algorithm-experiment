-- Supported are "normal","turbo","nothrottle","maximum". But know that except for "normal", all other modes will run as "turbo" for now.
--SPEED = "normal"
--SPEED = "turbo"
SPEED = "maximum"
frameCount = 0

require "genetic"

function wait(frameMax) for i = 0, frameMax do frameEnd() end end


function genomesMake(genomeMax, geneMax)
  local genomes = {}
  for i = 0, genomeMax do genomes[i] = genesMake(geneMax) end
  return genomes
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

function genomeMutate(genome)
  local mutateIndex = math.random(0, table.getn(genome))
  genome[mutateIndex] = math.random(0, 4)
  return rt
end


function joypadUpdate(value)
  --emu.print(gene)
  if value == 0 then joypad.write(1, {A = false, right = false, left = false, down = false}) end  
  if value == 1 then joypad.write(1, {right = true}) end  
  if value == 2 then joypad.write(1, {left = true}) end  
  if value == 3 then joypad.write(1, {down = true}) end  
  if value == 4 then joypad.write(1, {A = true}) end  
end

function init()
  emu.softreset()
  emu.speedmode(SPEED)
end

-- Mario Bros Functions
function marioStart()
  wait(50)
  joypad.write(1, {start = true})
  frameEnd()
  joypad.write(1, {start = true})
  frameEnd()
end

function marioGetPosition()
  local marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
  --gui.text(0, 10, marioX)
  return marioX or 0
end

function marioIsDead()
  local deathMusicLoaded = 0x0712
  local playerState = 0x000E
  local rt = false
  while (memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B) do
    rt = true
    frameEnd()
  end
  return rt
end

function marioGetMaxDist(currentMax, genomesScores)
  local rt = currentMax
  for i = 0, table.getn(genomesScores) do
    if genomesScores[i] > rt then rt = genomesScores[i] end
  end
  return rt
end

function marioFitness(genomes, genomesScores)
  local rt = {}
  local bestsScores = {}
  local bestsIds = {}
  for i = 0, table.getn(genomesScores) do
    bestsScores[i] = genomesScores[i]
  end
  table.sort(bestsScores, function(a, b) return a > b end)
  for i = 0, table.getn(genomesScores) do
    if genomesScores[i] == bestsScores[0] then bestsIds[0] = i end
    if genomesScores[i] == bestsScores[1] then bestsIds[1] = i end
    if genomesScores[i] == bestsScores[2] then bestsIds[2] = i end
    if genomesScores[i] == bestsScores[3] then bestsIds[3] = i end
    if genomesScores[i] == bestsScores[4] then bestsIds[4] = i end
    if genomesScores[i] == bestsScores[5] then bestsIds[5] = i end
    if genomesScores[i] == bestsScores[5] then bestsIds[6] = i end
    if genomesScores[i] == bestsScores[5] then bestsIds[7] = i end
  end
  rt[0] = genomeCrossOver(genomes[bestsIds[0]], genomes[bestsIds[1]])
  rt[1] = genomeCrossOver(genomes[bestsIds[2]], genomes[bestsIds[3]])
  rt[2] = genomeCrossOver(genomes[bestsIds[4]], genomes[bestsIds[5]])
  rt[3] = genomeCrossOver(genomes[bestsIds[6]], genomes[bestsIds[7]])
  genomeMutate(rt[0])
  genomeMutate(rt[1])
  return rt
end
---

function genomeTrunc(genome, indexMax)
  for i = indexMax, table.getn(genome) do
    genome[i] = nil
  end
end

function hud(generation, genome, maxDist)
  gui.text(0, 0, "generation")
  gui.text(50, 0, generation)
  gui.text(0, 10, "genome")
  gui.text(50, 10, genome)
  gui.text(150, 0, "max dist")
  gui.text(200, 0, maxDist)

end

function frameEnd()
  frameCount = frameCount + 1
  emu.frameadvance()
end

function main()  
  init()
  local GENOME_MAX = 10
  local GENE_MAX = 1000
  local JOYPAD_RATE = 30
  local generationIndex = 0
  local genomeIndex = 0
  local geneIndex = 0
  local maxDist = 0
  genomes = genomesMake(GENOME_MAX, GENE_MAX)
  local genomesScores = { 0 }
  marioStart()
  while true do
    --gui.text(0, 0, frameCount)
    marioGetPosition()
    if (frameCount % JOYPAD_RATE) == 0 then 
      geneIndex = geneIndex + 1
    end
    joypadUpdate(genomes[genomeIndex][geneIndex])
    if marioIsDead() then
      genomesScores[genomeIndex] = marioGetPosition()
      maxDist = marioGetMaxDist(maxDist, genomesScores)
      genomeTrunc(genomes[genomeIndex], geneIndex)
      emu.print("MARIO IS DEAD")
      --emu.print(genomes[genomeIndex])
      --emu.print(genomesScores)
      genomeIndex = genomeIndex + 1
      geneIndex = 0
      if genomeIndex > GENOME_MAX then
        local genomesBest = marioFitness(genomes, genomesScores)
        genomes = genomesMake(GENOME_MAX, GENE_MAX)

        genomes[0] = genomesBest[0]
        genomes[1] = genomesBest[1]
        genomes[2] = genomesBest[2]
        genomes[3] = genomesBest[3]

        emu.print("END")
        emu.print(genomesScores)
        geneIndex = 0
        genomeIndex = 0
        generationIndex = generationIndex + 1
      end  
      emu.softreset()
      marioStart()
    end
    hud(generationIndex, genomeIndex, maxDist)
    frameEnd()
  end
end

function test()
  init()
  local genomes = genomesMake(4, 6)
  local genomeCross = genomeCrossOver(genomes[0], genomes[1])
  local genomesScores = {12, 13, 14, 15}
  marioFitness(genomes, genomesScores)

  frameEnd()  
end

main()
--test()