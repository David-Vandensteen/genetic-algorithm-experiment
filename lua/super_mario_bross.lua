-- Supported are "normal","turbo","nothrottle","maximum". But know that except for "normal", all other modes will run as "turbo" for now.
--SPEED = "normal"
SPEED = "turbo"
frameCount = 0

function wait(frameMax) for i = 0, frameMax do frameEnd() end end

function genesMake(geneMax)
  local genes = {}
  for i = 0, geneMax do genes[i] = math.random(0,4) end
  return genes
end

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
  return genome
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
  --if(memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B)then
  -- return true
  -- else
  -- return false
  -- end
end

function marioFitness(genomes, scores)
  emu.print(table.sort(scores))
  emu.pause()
end
---

function genomeTrunc(genome, indexMax)
  for i = indexMax, table.getn(genome) do
    genome[i] = nil
  end
end

function hud(generation, genome)
  gui.text(0, 0, "generation")
  gui.text(50, 0, generation)
  gui.text(0, 10, "genome")
  gui.text(50, 10, genome)
end

function frameEnd()
  frameCount = frameCount + 1
  emu.frameadvance()
end

function main()  
  init()
  local GENOME_MAX = 10
  local GENE_MAX = 10
  local JOYPAD_RATE = 30
  local generationIndex = 0
  local genomeIndex = 0
  local geneIndex = 0
  genomes = genomesMake(GENOME_MAX, GENE_MAX)
  local genomesScores = {}
  marioStart()
  while true do
    --gui.text(0, 0, frameCount)
    hud(generationIndex, genomeIndex)
    marioGetPosition()
    if (frameCount % JOYPAD_RATE) == 0 then 
      geneIndex = geneIndex + 1
    end
    joypadUpdate(genomes[genomeIndex][geneIndex])
    if marioIsDead() then
      genomesScores[genomeIndex] = marioGetPosition()
      genomeTrunc(genomes[genomeIndex], geneIndex)
      emu.print("MARIO IS DEAD")
      --emu.print(genomes[genomeIndex])
      emu.print(genomesScores)
      genomeIndex = genomeIndex + 1
      geneIndex = 0
      if genomeIndex > GENOME_MAX then
        local genomesBest = {}
        genomesBest = marioFitness(genomes, genomesScores)
        emu.print("END")
        emu.pause()
      end  
      emu.softreset()
      marioStart()
    end
    frameEnd()
  end
end

main()