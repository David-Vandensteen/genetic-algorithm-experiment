--[[

    David Vandensteen
    2018

    Fceux LUA Afterburner agent
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

game.settings.joypad.none = 0
game.settings.joypad.right = 1
game.settings.joypad.left = 2
game.settings.joypad.up = 3
game.settings.joypad.down = 4
game.settings.joypad.a = 5
game.settings.joypad.b = 6

game.settings.joypad.rate = 40
game.settings.log = "afterburner.log"
game.settings.genFile = "afterburner-genetic-save" --(implicit .lua ext)
game.settings.genomeMax = 10
game.settings.genesAvailable = {
                                  game.settings.joypad.none,
                                  game.settings.joypad.right,
                                  game.settings.joypad.left,
                                  game.settings.joypad.up,
                                  game.settings.joypad.down,
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

function initLog(_logFile)
  logger.setFile(_logFile)
  logger.clear()
  logger.info(os.date())
  logger.info("")
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
  genetic.genomes[10] = genomeCopy(genetic.genomes[1])
  genetic.genomes[9] = genomeCopy(genetic.genomes[2])
  genetic.genomes[8] = genomeCopy(genetic.genomes[3])

  genomesTrunc(math.random(10, 20))          --  remove last genes
  --genomeMutate(genetic.genomes[10], 0.01, game.settings.genesAvailable)
  --genomeMutate(genetic.genomes[9], 0.02, game.settings.genesAvailable)
  --genomeMutate(genetic.genomes[8], 0.03, game.settings.genesAvailable)
  --genomesMutate(0.01, game.settings.genesAvailable)  --  mutate genes 0.1 -> 10%
end


--

function main()
  game.settings.speed.set.maximum()
  --game.settings.speed.set.normal()
  initLog(game.settings.log)
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
    --.hudUpdate()
    emu.frameadvance()
  end
end

main()