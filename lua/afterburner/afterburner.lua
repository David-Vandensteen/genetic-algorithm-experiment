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
game.settings.joypad.ul = 7
game.settings.joypad.ur = 8
game.settings.joypad.dl = 9
game.settings.joypad.dr = 10

game.settings.joypad.rate = 40
--game.settings.log = "afterburner.log"
game.settings.genFile = "afterburner-genetic-save" --(implicit .lua ext)
game.settings.genomeMax = 10
game.settings.genesAvailable = {
                                  game.settings.joypad.none,
                                  game.settings.joypad.right,
                                  game.settings.joypad.right,
                                  game.settings.joypad.left,
                                  game.settings.joypad.left,
                                  game.settings.joypad.up,
                                  game.settings.joypad.down,
                                  game.settings.joypad.ul,
                                  game.settings.joypad.ur,
                                  game.settings.joypad.dl,
                                  game.settings.joypad.dr,
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
  if value == 0  then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = false}) end --none
  if value == 1  then joypad.write(1, {B = false, A = true , right = true , left = false, down = false, up = false}) end --r
  if value == 2  then joypad.write(1, {B = false, A = true , right = false, left = true , down = false, up = false}) end --l
  if value == 3  then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = true }) end --u
  if value == 4  then joypad.write(1, {B = false, A = true , right = false, left = false, down = true , up = false}) end --d
  if value == 5  then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = false}) end --a
  if value == 6  then joypad.write(1, {B = true , A = true , right = false, left = false, down = false, up = false}) end --b
  if value == 7  then joypad.write(1, {B = false, A = true , right = false, left = true , down = false, up = true }) end --ul
  if value == 8  then joypad.write(1, {B = false, A = true , right = true , left = false, down = false, up = true }) end --ur
  if value == 9  then joypad.write(1, {B = false, A = true , right = false, left = true , down = true , up = false}) end --dl
  if value == 10 then joypad.write(1, {B = false, A = true , right = true , left = false, down = true , up = false}) end --dr
  
end

function init(_speed)
  if _speed == "normal" then
    game.settings.speed.set.normal()
  else
    game.settings.speed.set.maximum()
  end
  emu.speedmode(game.settings.speed.value)
  emu.softreset()
end

function hudUpdate()
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  --gui.text(100, 10, "time " .. emu.framecount() - genetic.genomeTime)
  gui.text(100, 20, "score " .. emu.framecount() - genetic.genomeTime)
end

-- Afterburner Functions
local afterburner = {}

function gameStart()
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
  genetic.genomes[10] = genomeCopy(genetic.genomes[1]) -- clone the best
  genetic.genomes[9] = genomeCopy(genetic.genomes[2]) -- clone the best
  genetic.genomes[8] = genomeCopy(genetic.genomes[3]) -- clone the best
  table.trunc(genetic.genomes[10] ,math.random(1, 15)) -- remove last genes
  table.trunc(genetic.genomes[9] ,math.random(1, 10)) -- remove last genes
  table.trunc(genetic.genomes[8] ,math.random(1, 5)) -- remove last genes

  table.trunc(genetic.genomes[7] ,math.random(1, 5)) -- remove last genes
  table.trunc(genetic.genomes[6] ,math.random(1, 5)) -- remove last genes
  table.trunc(genetic.genomes[5] ,math.random(1, 5)) -- remove last genes
  table.trunc(genetic.genomes[4] ,math.random(1, 5)) -- remove last genes
end


--

function main(_speed)
  if _speed == "normal" then
    game.settings.speed.set.normal()
  else
    game.settings.speed.set.maximum()
  end
  geneticLoad(game.settings.genomeMax, game.settings.genFile) -- load genetic instance from file(.lua) or start new Genetic with max genome
  init()
  local control = 0
  gameStart()
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
      end
      control = 0
      emu.softreset()
      gameStart()
      newGenome(emu.framecount()) -- must be call after softreset (timer)
    end
    hudUpdate()
    emu.frameadvance()
  end
end

function main2(_speed)
  local control = 0
  geneticLoad(game.settings.genomeMax, game.settings.genFile) -- load genetic instance from file(.lua) or start new Genetic with max genome
  while true do                         -- infinite loop

    control = 0                         -- set control none
    init(_speed)                        -- set speed & reset emul
    gameStart()                         -- wait & press start macro
    newGenome(emu.framecount())         -- start time

    -- ALIVE
    while not afterburner.isDead() do -- process & update
      if (emu.framecount() % game.settings.joypad.rate) == 0 then 
        control = geneProcess(game.settings.genesAvailable)
      end
      joypadUpdate(control)
      hudUpdate()
      emu.frameadvance()  
    end
    --

    -- DEAD
    genomeTimeEnd(emu.framecount())   -- calculate the life time
    genomeProcess(genetic.genomeTime) -- genome score
                                      -- end current genome
    if generationIsFinish() then
      afterburner.fitness()           -- fitness
      print(genetic.scores)
      generationProcess(game.settings.genFile)  -- optional save file
                                                -- end current generation
    end
    --

  end
end

--main(arg)
main2(arg)