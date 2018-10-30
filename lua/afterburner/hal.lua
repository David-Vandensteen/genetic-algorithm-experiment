--[[

    David Vandensteen
    2018

    H.A.L (Heuristic Agent Learning)
    Fceux LUA
        Supported games:
          - Afterburner
--]]

local inspect = require "lib/inspect" -- deep table displaying
require "lib/lua-extend"              -- table.copy, table.trunc ...
require "lib/genetic"                 -- generation, genome, gene handling

-- settings objects
game = {}
game.settings = {}
game.settings.speed = {}
game.settings.speed.set = {}
game.settings.joypad = {}
game.settings.joypad.rate = 40        -- default
game.settings.genomeMax = 10          -- default

function gameStart()                  -- default
  wait(100)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
end

function gameDetect()
  local rt = false
  local headMario =       {0x4E, 0x45, 0x53, 0x1A, 0x02, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headAfterburner = {0x4E, 0x45, 0x53, 0x1A, 0x08, 0x20, 0x40, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local head = {}
  for i = 1, 16 do
    table.insert(head ,rom.readbyte(i -1))
  end
  if table.compare(head, headMario) then rt = "Super Mario Bros" end
  if table.compare(head, headAfterburner) then rt = "Afterburner" end
  print(rt .. " detected")
  return rt
end

--
if gameDetect() == "Afterburner" then require "games/afterburner" end
--

function game.settings.speed.set.maximum() game.settings.speed.value = "maximum" end
function game.settings.speed.set.turbo() game.settings.speed.value = "turbo" end 
function game.settings.speed.set.normal() game.settings.speed.value = "normal" end

function wait(frameMax)
  local curF = emu.framecount()
  while emu.framecount() < curF + frameMax do
    emu.frameadvance()
  end
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
--

function main(_speed)
  local control = 0                     -- set control none
  geneticLoad(game.settings.genomeMax, game.settings.genFile) 
                                        -- load genetic instance from file(.lua) or start new Genetic with max genome
  while true do                         -- infinite loop

    init(_speed)                        -- set speed & reset emul
    gameStart()                         -- wait & press start macro (main game menu)
    newGenome(emu.framecount())         -- set a new genome with start time

    -- ALIVE --------------------------------------------------------
    while not isDead() do -- process & update
      if (emu.framecount() % game.settings.joypad.rate) == 0 then
        control = geneProcess(game.settings.genesAvailable)
      end
      joypadUpdate(control)              -- write joypad
      hudUpdate()                        -- refresh hud
      emu.frameadvance()                 -- nex frame
    end
    -----------------------------------------------------------------

    -- DEAD ---------------------------------------------------------
    genomeTimeEnd(emu.framecount())   -- calculate the life time
    genomeProcess(genetic.genomeTime) -- genome score
                                      -- end current genome
    if generationIsFinish() then
      fitness()                       -- fitness
      print(genetic.scores)           -- display scores at console
      generationProcess(game.settings.genFile)  -- optional arg save file
                                                -- end current generation
    end
    -----------------------------------------------------------------

  end
end

main(arg)