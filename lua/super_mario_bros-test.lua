--[[

    David Vandensteen
    2018

    Mario Bros agent "simulation" for testing without FCEUX
--]]

local inspect = require "inspect"
require "lua-extend"
require "genetic"
require "logger"

simul = {
  frame = 0
}


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


mario = {}
emu = {}
joypad ={}
gui = {}

function emu.softreset()
  print("emu.softreset()")
end

function gui.text(x, y, msg) print(msg) end

function joypad.write()
  print("joypad.write()")
end

function emu.framecount()
  print("frame : ", simul.frame)
  return simul.frame
end

function emu.frameadvance()
  simul.frame = simul.frame + 1
  io.read()
  return simul.frame
end

function emu.print(arg) print(arg) end

function mario.start() print("mario.start()") end

function mario.isDead()
  local rt = false
  if math.random(1, 9) == 1 then rt = true end
  return rt
end

function mario.getWorld() return 1 end
function mario.getLevel() return 1 end
function mario.getScore() return 1 end
function mario.getPosition() return 1 end

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

function init()
  print("init()")
end

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
end

function test()
  while true do
    genetic.generation:add()
    genetic.generation.genome:add()
    genetic.generation.genome:processGene()

    genetic.generation.genome:setScore()
    genetic.generation:sort()

    emu.frameadvance()
  end
end

--main()
test()