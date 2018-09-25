--[[

    David Vandensteen
    2018

    Mario Bross agent for Fceux LUA
    Genetic algorithm is used for agent learning

--]]

require "lua-extend"
require "genetic"

--Supported are "normal","turbo","nothrottle","maximum"
--SPEED = "normal"
--SPEED = "turbo"
SPEED = "maximum"
frameCount = 0

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
local mario = {}
function mario.start()
  wait(50)
  joypad.write(1, {start = true})
  frameEnd()
  joypad.write(1, {start = true})
  frameEnd()
end

function mario.getPosition()
  local marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
  return marioX or 0
end

function mario.isDead()
  local deathMusicLoaded = 0x0712
  local playerState = 0x000E
  local rt = false
  while (memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B) do
    rt = true
    frameEnd()
  end
  return rt
end

function mario.getMaxDist(currentMax, scores)
  local rt = currentMax
  for i = 1, table.getn(scores) do
    if scores[i] > rt then rt = scores[i] end
  end
  return rt
end

function mario.fitness(pgenomes, scores, genomeMax, geneMax)
  genomes.sortByScores(pgenomes, scores)
  for i = 1, (table.getn(pgenomes) - 2) do
    table.trunc(pgenomes[i], table.getn(pgenomes[i]) - 3)
  end
  genomes.pad(pgenomes, genomeMax, geneMax)
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
  _genomes = genomes.make(GENOME_MAX, GENE_MAX)
  local scores = { 0 }
  mario.start()
  while true do
    mario.getPosition()
    if (frameCount % JOYPAD_RATE) == 0 then geneIndex = geneIndex + 1      
    else joypadUpdate(_genomes[genomeIndex][geneIndex]) end
    if mario.isDead() then
      scores[genomeIndex] = mario.getPosition()
      maxDist = mario.getMaxDist(maxDist, scores)
      table.trunc(_genomes[genomeIndex], geneIndex)
      genomeIndex = genomeIndex + 1
      geneIndex = 1
      if genomeIndex > GENOME_MAX then
        mario.fitness(_genomes, scores, GENOME_MAX, GENE_MAX)
        emu.print(scores)
        geneIndex = 1
        genomeIndex = 1
        generationIndex = generationIndex + 1
      end  
      emu.softreset()
      mario.start()
    end
    hud(generationIndex, genomeIndex, maxDist)
    frameEnd()
  end
end
main()