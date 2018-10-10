--[[

    David Vandensteen
    2018

    Mario Bros agent for Fceux LUA
    Genetic algorithm is used for agent learning

--]]

local inspect = require "inspect"
require "lua-extend"
require "genetic"
require "logger"

game = {}
game.settings = {}
--Speed Supported are "normal","turbo","nothrottle","maximum"
game.settings.speed = {}
game.settings.speed.value = "turbo"
game.settings.speed.set = {}
function game.settings.speed.set.maximum() end
function game.settings.speed.set.turbo() end
function game.settings.speed.set.normal() end
game.settings.joypad = {}
game.settings.joypad.rate = 40


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

function mario.fitness(pgenomes, scores, genomeMax, geneMax)
  genomes.sortByScores(pgenomes, scores)
  for i = 1, (table.getn(pgenomes) - 2) do
    table.trunc(pgenomes[i], table.getn(pgenomes[i]) - 3)
  end
end

function mario.hud()
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

function updateLog()
  emu.print("GENERATION : ", genetic.generationIndex)
  emu.print(genetic.scores)
  logger.info("-- GENERATION : ")
  logger.info(genetic.generationIndex)
  logger.info("--")
  logger.info(inspect(genetic.genomes))
  logger.info("")
  genetic:sort() --TODO
  logger.info("-- SCORES :")
  logger.info(inspect(genetic.scores))
  logger.info("")
  logger.info("-------------------------------------------")
  logger.info("")
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
  while true do
    if (emu.framecount() % game.settings.joypad.rate) == 0 then
      control = geneProcess(math.random(0, 4))
    end
    joypadUpdate(control)
    if mario.isDead() then
      genomeProcess(mario.getScore())
      if generationIsFinish() then
        print(genetic.scores)
        genomesSort()         --  sort genomes by best score
        generationTrunc(2)    --  keep bests genomes for next generation
        genomesTrunc(5)       --  re-random the last genes
        generationProcess()
        wait(50)
      end
      newGenome()
      emu.softreset()
      mario.start()
    end
    mario.hud()
    emu.frameadvance()
  end
end

main()
