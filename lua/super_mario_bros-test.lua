--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "lib/inspect"
require "lib/lua-extend"
require "lib/genetic"
require "lib/logger"

simul = {
  frame = 0
}

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

mario = {}
emu = {}
joypad ={}
gui = {}

mario.score = {}
mario.score.position = 0
mario.score.world = 0
mario.score.level = 0
mario.score.worldCoef = 10000
mario.score.levelCoef = 100000
mario.score.timePenalty = 0


function emu.softreset()
  print("call emu.softreset()")
end

function gui.text(x, y, msg) end

function joypad.write()
  print("call joypad.write()")
end

function emu.framecount()
  print("frame : ", simul.frame)
  return simul.frame
end

function emu.frameadvance()
  simul.frame = simul.frame + 1
  --io.read()
  --sleep(1)
  print(inspect(genetic))
  print("")
  return simul.frame
end

function emu.print(arg) print(arg) end

function mario.start() print("call mario.start()") end

function mario.isDead()
  local rt = false
  if math.random(1, 300) == 1 then
    rt = true
    print("Mario is dead...")
  end
  return rt
end

function mario.getWorld() return 1 end
function mario.getLevel() return 1 end
function mario.getPosition() return math.random(100, 1400) end

function mario.getScore() 
  return mario.getPosition()
                                + 
          ( (mario.getWorld() * mario.score.worldCoef) - mario.score.worldCoef)
                                + 
          ( (mario.getLevel() * mario.score.levelCoef) - mario.score.levelCoef)
end


function mario.hudUpdate()
  print("call mario.hudUpdate()")
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

function init()
  print("call init()")
end

function initLog(_logFile)
  logger.setFile(_logFile)
  logger.clear()
  logger.info(os.date())
  logger.info("")
end


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

function mario.fitness()
  genomesSort()                             --  sort genomes by best score
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