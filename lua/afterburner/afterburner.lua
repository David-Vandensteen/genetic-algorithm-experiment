--[[

    David Vandensteen
    2018

    Fceux LUA Afterburner agent
        Genetic algorithm is used for agent learning
--]]

local inspect = require "lib/inspect" -- deep table displaying
require "lib/lua-extend"              -- table.copy, table.trunc ...
require "lib/genetic"                 -- generation, genome, gene handling

-- settings
game = {}
game.settings = {}
--Speed Supported are "normal","turbo","nothrottle","maximum"
game.settings.speed = {}
game.settings.speed.value = "maximum"
game.settings.speed.set = {}
game.settings.joypad = {}

game.settings.joypad.none = 0
game.settings.joypad.right = 1
game.settings.joypad.left = 2
game.settings.joypad.up = 3
game.settings.joypad.down = 4
game.settings.joypad.a = 5
game.settings.joypad.b = 6

game.settings.joypad.rate = 40
--game.settings.log = "afterburner.log"
game.settings.genFile = "afterburner-genetic-save" --(implicit .lua ext)
game.settings.genomeMax = 2
game.settings.genesAvailable = {
                                  game.settings.joypad.none,
                                  game.settings.joypad.right,
                                  game.settings.joypad.right,
                                  game.settings.joypad.left,
                                  game.settings.joypad.left,
                                  game.settings.joypad.up,
                                  game.settings.joypad.down,
                                  game.settings.joypad.a,
                                  game.settings.joypad.a,
                                  game.settings.joypad.a,
                                  game.settings.joypad.a,
                                  game.settings.joypad.a,
                                  game.settings.joypad.b
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
  if value == 0 then joypad.write(1, {B = false, A = false, right = false, left = false, down = false, up = false}) end --none
  if value == 1 then joypad.write(1, {B = false, A = false, right = true , left = false, down = false, up = false}) end --r
  if value == 2 then joypad.write(1, {B = false, A = false, right = false, left = true , down = false, up = false}) end --l
  if value == 3 then joypad.write(1, {B = false, A = false, right = false, left = false, down = false, up = true }) end --u
  if value == 4 then joypad.write(1, {B = false, A = false, right = false, left = false, down = true , up = false}) end --d
  if value == 5 then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = false}) end --a
  if value == 6 then joypad.write(1, {B = true , A = false, right = false, left = false, down = false, up = false}) end --b
end

function init()
  emu.softreset()
  emu.speedmode(game.settings.speed.value)
end

function hudUpdate()
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  --gui.text(100, 10, "time " .. emu.framecount() - genetic.genomeTime)
  gui.text(100, 20, "score " .. emu.framecount() - genetic.genomeTime)
end

-- Afterburner Functions
local afterburner = {}

function afterburner.start()
  wait(100)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
end

function afterburner.isDead()
  local rt = false
  while (memory.readbyte(0x0096) == 0xFF) do
    rt = true
    emu.frameadvance()
  end
  return rt
end

function afterburner.fitness()
  genomesSort()                             --  sort genomes by best score
  genetic.genomes[2] = genomeCopy(genetic.genomes[1]) -- clone the best
  table.trunc(genetic.genomes[2] ,math.random(1, 5)) -- remove last genes
  --table.trunc(genetic.genomes[3] ,math.random(1, 5))
end


--

function main()
  game.settings.speed.set.maximum()
  --game.settings.speed.set.normal()
  init()
  afterburner.start()
  geneticLoad(game.settings.genomeMax, game.settings.genFile) -- load genetic instance from file(.lua) or start new Genetic with max genome
  newGenome(emu.framecount()) -- start time

  -- learn
  while true do
    if (emu.framecount() % game.settings.joypad.rate) == 0 then control = geneProcess(game.settings.genesAvailable) end
    joypadUpdate(control)
    if afterburner.isDead() then
      genomeTimeEnd(emu.framecount()) -- calculate the life time
      genomeProcess(genetic.genomeTime) -- genome score
      -- end current genome
      if generationIsFinish() then
        afterburner.fitness()
        print(genetic.scores)
        generationProcess(game.settings.genFile) -- optionnal save file
        -- end current generation
        wait(50)
      end
      control = 4
      emu.softreset()
      afterburner.start()
      newGenome(emu.framecount()) -- must be call after softreset (timer)
    end
    hudUpdate()
    emu.frameadvance()
  end
end

main()