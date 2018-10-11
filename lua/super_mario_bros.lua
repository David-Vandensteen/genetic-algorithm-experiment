--[[

    David Vandensteen
    2018

    Fceux LUA Mario Bros agent
        Genetic algorithm is used for agent learning
--]]

local inspect = require "lib/inspect" -- deep table displaying
require "lib/lua-extend"              -- table.copy, table.trunc ...
require "lib/genetic"                 -- generation, genome, gene handling
require "lib/logger"                  -- writing a log file

-- settings
game = {}
game.settings = {}
--Speed Supported are "normal","turbo","nothrottle","maximum"
game.settings.speed = {}
game.settings.speed.value = "turbo"
game.settings.speed.set = {}
game.settings.joypad = {}
game.settings.joypad.rate = 40

function game.settings.speed.set.maximum() game.settings.speed.value = "maximum" end
function game.settings.speed.set.turbo() game.settings.speed.value = "turbo" end 
function game.settings.speed.set.normal() game.settings.speed.value = "normal" end

function wait(frameMax)
  local curF = emu.framecount()
  while emu.framecount() < curF + frameMax do
    emu.frameadvance()
  end
end

function joypadUpdate(value)
  if value == 0 then joypad.write(1, {A = false, right = true, left = false, down = false}) end
  if value == 1 then joypad.write(1, {A = true, right = false, left = false, down = false}) end
  if value == 2 then joypad.write(1, {A = false, right = false, left = false, down = true}) end
  if value == 3 then joypad.write(1, {A = true, right = true, left = false, down = false}) end
  if value == 4 then joypad.write(1, {A = true, right = true, left = false, down = true}) end
end

function init()
  emu.softreset()
  emu.speedmode(game.settings.speed.value)
end

-- Mario Bros Functions
local mario = {}
function mario.start()
  wait(50)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
end

function mario.getWorld()
  local world = memory.readbyte(0x75f)
  return (world + 1) or 1
end

function mario.getLevel()
  local level = memory.readbyte(0x75c)
  return (level + 1) or 1
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
    emu.frameadvance()
  end
  return rt
end

function mario.getMaxScore(currentMax, scores)
  local rt = currentMax
  for i = 1, table.getn(scores) do
    if scores[i] > rt then rt = scores[i] end
  end
  return rt
end

function mario.getScore() return mario.getPosition() + (mario.getLevel() * 10000) end

-- not used
--[[
function mario.getTimer()
  return memory.readbyte(0x7f8) * 100 + memory.readbyte(0x7f9) * 10 + memory.readbyte(0x7fa)
end

function mario.getMode()
  return memory.readbyte(0xe)
end
--]]

function mario.hudUpdate()
  gui.text(0, 0, "generation")
  gui.text(50, 0, genetic.generationIndex)
  gui.text(0, 10, "genome")
  gui.text(50, 10, genetic.genomeIndex)
  gui.text(0, 40, "world")
  gui.text(0, 50, "level")
  gui.text(50, 40, mario.getWorld())
  gui.text(50, 50, mario.getLevel())
  gui.text(150, 0, "max. score")
  --gui.text(210, 0, game.genetic.scores.max)
  gui.text(150, 10, "cur. score")
  gui.text(210, 10, mario.getScore())
  gui.text(150, 40, "cur. position")
  gui.text(210, 40, mario.getPosition())
end

function main()  
  logger.setFile("super_mario_bros.log")
  logger.clear()
  logger.info(os.date())
  logger.info("")
  init()
  mario.start()
  newGenetic(10) --genome max
  newGenome()

  -- learn
  while true do
    if (emu.framecount() % game.settings.joypad.rate) == 0 then
      control = geneProcess(math.random(0, 4))
    end
    joypadUpdate(control)
    if mario.isDead() then
      -- append logfile
      logger.info("world :")
      logger.info(mario.getWorld())
      logger.info("")
      logger.info("level :")
      logger.info(mario.getLevel())
      genomeProcess(mario.getScore()) -- genome score
      -- end current genome
      if generationIsFinish() then
        -- append logfile
        logger.info("generation: ")
        logger.info(genetic.generationIndex)
        logger.info("")
        print(genetic.scores)
        genomesSort()                           --  sort genomes by best score
        --generationTrunc(2)                    --  keep bests genomes for next generation
        genomesTrunc(math.random(5, 30))        --  re-random the last genes
        --
        generationProcess()
        -- end current generation
        wait(50)
      end
      newGenome()
      emu.softreset()
      mario.start()
    end
    mario.hudUpdate()
    emu.frameadvance()
  end
end

main()
