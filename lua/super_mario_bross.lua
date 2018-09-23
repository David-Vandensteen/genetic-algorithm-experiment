-- Supported are "normal","turbo","nothrottle","maximum". But know that except for "normal", all other modes will run as "turbo" for now.
--SPEED = "normal"
--SPEED = "turbo"
SPEED = "maximum"
frameCount = 0

require "genetic"

function wait(frameMax) for i = 0, frameMax do frameEnd() end end

function joypadUpdate(value)
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
  for i = 1, table.getn(genomesScores) do
    if genomesScores[i] > rt then rt = genomesScores[i] end
  end
  return rt
end

function marioFitness(genomes, genomesScores, geneMax)
  local rt = {}
  local bestsScores = {}
  local bestsIds = {}
  for i = 0, table.getn(genomesScores) do
    bestsScores[i] = genomesScores[i]
  end
  table.sort(bestsScores, function(a, b) return a > b end)
  for i = 1, table.getn(genomesScores) do
    if genomesScores[i] == bestsScores[1] then bestsIds[1] = i end
    if genomesScores[i] == bestsScores[2] then bestsIds[2] = i end
    if genomesScores[i] == bestsScores[3] then bestsIds[3] = i end
    if genomesScores[i] == bestsScores[4] then bestsIds[4] = i end
    if genomesScores[i] == bestsScores[5] then bestsIds[5] = i end
    if genomesScores[i] == bestsScores[6] then bestsIds[6] = i end
    if genomesScores[i] == bestsScores[7] then bestsIds[7] = i end
    if genomesScores[i] == bestsScores[8] then bestsIds[8] = i end
  end
  rt[1] = genomeCrossOver(genomes[bestsIds[1]], genomes[bestsIds[2]])
  rt[2] = genomeCrossOver(genomes[bestsIds[3]], genomes[bestsIds[4]])
  rt[3] = genomeCrossOver(genomes[bestsIds[5]], genomes[bestsIds[6]])
  rt[4] = genomeCrossOver(genomes[bestsIds[7]], genomes[bestsIds[8]])
  genomeMutate(rt[1])
  genomeMutate(rt[2])
  genomeMutate(rt[3])
  genomeMutate(rt[4])
  genomePad(rt[1], geneMax)
  genomePad(rt[2], geneMax)
  genomePad(rt[3], geneMax)
  genomePad(rt[4], geneMax)
  return rt
end

function genomeTrunc(genome, indexMax)
  for i = indexMax, table.getn(genome) do genome[i] = nil end
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
  local generationIndex = 1
  local genomeIndex = 1
  local geneIndex = 1
  local maxDist = 0
  genomes = genomesMake(GENOME_MAX, GENE_MAX)
  local genomesScores = { 0 }
  marioStart()
  while true do
    marioGetPosition()
    if (frameCount % JOYPAD_RATE) == 0 then 
      geneIndex = geneIndex + 1
    end
    joypadUpdate(genomes[genomeIndex][geneIndex])
    if marioIsDead() then
      genomesScores[genomeIndex] = marioGetPosition()
      maxDist = marioGetMaxDist(maxDist, genomesScores)
      genomeTrunc(genomes[genomeIndex], geneIndex)
      genomeIndex = genomeIndex + 1
      geneIndex = 1
      if genomeIndex > GENOME_MAX then
        local genomesBest = marioFitness(genomes, genomesScores, GENE_MAX)
        genomes = genomesMake(GENOME_MAX, GENE_MAX)

        genomes[1] = genomesBest[1]
        genomes[2] = genomesBest[2]
        genomes[3] = genomesBest[3]
        genomes[5] = genomesBest[4]

        emu.print(genomesScores)
        geneIndex = 1
        genomeIndex = 1
        generationIndex = generationIndex + 1
      end  
      emu.softreset()
      marioStart()
    end
    hud(generationIndex, genomeIndex, maxDist)
    frameEnd()
  end
end
main()
