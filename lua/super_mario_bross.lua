-- Supported are "normal","turbo","nothrottle","maximum". But know that except for "normal", all other modes will run as "turbo" for now.
--SPEED = "normal"
--SPEED = "turbo"
SPEED = "maximum"
LOG = "super_mario_bross.log"
frameCount = 0

require "genetic"

function wait(frameMax) for i = 0, frameMax do frameEnd() end end

function logWrite(value)
  emu.print(value)
  file = io.open(LOG, "a")
  io.output(file)
  io.write(value["message"])
  io.write("\n")
  io.close(file)
end

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

function marioGetMaxDist(currentMax, scores)
  local rt = currentMax
  for i = 1, table.getn(scores) do
    if scores[i] > rt then rt = scores[i] end
  end
  return rt
end

function marioFitness(genomes, scores, genomeMax, geneMax)
  genomesSortByScores(genomes, scores)
  for i = 2, (table.getn(genomes) - 2) do
    genomes[i] = table.copy(genomes[1])
    table.trunc(genomes[i], table.getn(genomes[i]) - 10)
  end
  genomesPad(genomes, genomeMax, geneMax)
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
  local JOYPAD_RATE = 40
  local generationIndex = 1
  local genomeIndex = 1
  local geneIndex = 1
  local maxDist = 0
  genomes = genomesMake(GENOME_MAX, GENE_MAX)
  local scores = { 0 }
  marioStart()
  while true do
    marioGetPosition()
    if (frameCount % JOYPAD_RATE) == 0 then 
      geneIndex = geneIndex + 1
    end
    joypadUpdate(genomes[genomeIndex][geneIndex])
    if marioIsDead() then
      scores[genomeIndex] = marioGetPosition()
      maxDist = marioGetMaxDist(maxDist, scores)
      table.trunc(genomes[genomeIndex], geneIndex + 1)
      genomeIndex = genomeIndex + 1
      geneIndex = 1
      if genomeIndex > GENOME_MAX then
        marioFitness(genomes, scores, GENOME_MAX, GENE_MAX)
        emu.print(scores)
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
--main()
logWrite{"message" = "TEST"})
