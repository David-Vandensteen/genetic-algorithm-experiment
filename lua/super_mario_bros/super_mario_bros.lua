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
game.settings.speed.value = "maximum"
game.settings.speed.set = {}
game.settings.joypad = {}

game.settings.joypad.right = 0
game.settings.joypad.jump = 1
game.settings.joypad.down = 2
game.settings.joypad.jumpRight = 3
game.settings.joypad.none = 4
game.settings.joypad.rightDash = 5
game.settings.joypad.jumpRightDash = 6
game.settings.joypad.left = 7

game.settings.joypad.rate = 40
game.settings.log = "super_mario_bros.log"
game.settings.genFile = "super_mario_bros-genetic-save" --(implicit .lua ext)
game.settings.genomeMax = 10
game.settings.genesAvailable = {
                                  game.settings.joypad.right,
                                  game.settings.joypad.right,
                                  game.settings.joypad.jump,
                                  game.settings.joypad.down,
                                  game.settings.joypad.jumpRight,
                                  game.settings.joypad.none,
                                  game.settings.joypad.none,
                                  game.settings.joypad.rightDash,
                                  game.settings.joypad.jumpRightDash,
                                  game.settings.joypad.jumpRightDash,
                                  game.settings.joypad.left
                                }


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
  if value == 0 then joypad.write(1, {B = false, A = false, right = true, left = false, down = false}) end --r
  if value == 1 then joypad.write(1, {B = false, A = true, right = false, left = false, down = false}) end --a
  if value == 2 then joypad.write(1, {B = false, A = false, right = false, left = false, down = true}) end --d
  if value == 3 then joypad.write(1, {B = false, A = true, right = true, left = false, down = false}) end --ar
  if value == 4 then joypad.write(1, {B = false, A = false, right = false, left = false, down = false}) end --non
  if value == 5 then joypad.write(1, {B = true, A = false, right = true, left = false, down = false}) end
  if value == 6 then joypad.write(1, {B = true, A = true, right = true, left = false, down = false}) end
  if value == 7 then joypad.write(1, {B = false, A = false, right = false, left = true, down = false}) end
end

function init()
  emu.softreset()
  emu.speedmode(game.settings.speed.value)
end

function initLog(_logFile)
  logger.setFile(_logFile)
  logger.clear()
  logger.info(os.date())
  logger.info("")
end

-- Mario Bros Functions
local mario = {}
mario.score = {}
mario.score.position = 0
mario.score.world = 0
mario.score.level = 0
mario.score.worldCoef = 10000
mario.score.levelCoef = 100000
--mario.score.timePenalty = 0.0000021
mario.score.timePenalty = 0.000000001

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

function mario.getScore()
  local rt = mario.getPosition()
  local levelBonus = mario.getWorld() * mario.score.worldCoef
  levelBonus = levelBonus + (mario.getLevel() * mario.score.levelCoef )
  local timePenalty = genetic.genomeTime * ((mario.score.timePenalty * mario.score.levelCoef) * mario.score.worldCoef)
  timePenalty = math.floor(timePenalty)
  rt = rt + levelBonus
  rt = rt - timePenalty
  print("timePenalty : " .. timePenalty .." score : " .. rt)
  return rt
end

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
  --gui.text(210, 10, mario.getScore())
  gui.text(150, 40, "cur. position")
  gui.text(210, 40, mario.getPosition())
end

function mario.fitness()
  genomesSort()                             --  sort genomes by best score
  genetic.genomes[10] = genomeCopy(genetic.genomes[1])
  genetic.genomes[9] = genomeCopy(genetic.genomes[2])
  genetic.genomes[8] = genomeCopy(genetic.genomes[3])

  genomesTrunc(math.random(10, 20))          --  remove last genes
  genomeMutate(genetic.genomes[10], 0.01, game.settings.genesAvailable)
  genomeMutate(genetic.genomes[9], 0.02, game.settings.genesAvailable)
  genomeMutate(genetic.genomes[8], 0.03, game.settings.genesAvailable)
  --genomesMutate(0.01, game.settings.genesAvailable)  --  mutate genes 0.1 -> 10%
end

function main()
  initLog(game.settings.log)
  init()
  mario.start()
  geneticLoad(game.settings.genomeMax, game.settings.genFile) -- load genetic instance from file(.lua) or start new Genetic with max genome
  newGenome(emu.framecount()) -- start time

  -- learn
  while true do
    if (emu.framecount() % game.settings.joypad.rate) == 0 then control = geneProcess(game.settings.genesAvailable) end
    joypadUpdate(control)
    if mario.isDead() then
      genomeTimeEnd(emu.framecount()) -- calculate the life time
      genomeProcess(mario.getScore()) -- genome score
      -- end current genome
      if generationIsFinish() then
        mario.fitness()
        print(genetic.scores)
        generationProcess(game.settings.genFile) -- optionnal save file
        -- end current generation
        wait(50)
      end
      control = 4
      emu.softreset()
      mario.start()
      newGenome(emu.framecount()) -- must be call after softreset (timer)
    end
    mario.hudUpdate()
    emu.frameadvance()
  end
end

main()