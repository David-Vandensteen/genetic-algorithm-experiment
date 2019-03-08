--[[

    David Vandensteen
    2018

    H.A.L test
    Fceux LUA
        Supported games:
          - Afterburner
          - Space Harrier
          - Gradius
          - Road Fighter
--]]

inspect = require "lib/inspect" -- deep table displaying
require "lib/lua-extend"              -- table.copy, table.trunc, sleep ...
require "lib/genetic"                 -- generation, genome, gene handling

require "lib/fceux-simul"

-- default settings
game = {}
game.settings = {}
game.settings.speed = {}
game.settings.speed.set = {}
game.settings.joypad = {}
game.settings.joypad.rate = 40            -- default
game.settings.genomeMax = 10              -- default
game.settings.geneticAutoBackup = 0       -- backup each x game.frame (0 is off)
game.frame = 0
--Speed Supported are "normal","turbo","nothrottle","maximum"
game.settings.speed.value = "maximum"
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
game.settings.genomeMax = 10

function gameStartMacro()                  -- default
  wait(100)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
end

function gameDetect()
  local rt = false
  local headMario =        {0x4E, 0x45, 0x53, 0x1A, 0x02, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headAfterburner =  {0x4E, 0x45, 0x53, 0x1A, 0x08, 0x20, 0x40, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headSpaceHarrier = {0x4E, 0x45, 0x53, 0x1A, 0x08, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headGradius =      {0x4E, 0x45, 0x53, 0x1A, 0x02, 0x04, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headRoadFighter =  {0x4E, 0x45, 0x53, 0x1A, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local headTest =         {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
  local head = {}
  for i = 1, 16 do
    table.insert(head ,rom.readbyte(i -1))
  end
  if table.compare(head, headMario) then rt = "Super Mario Bros" end
  if table.compare(head, headAfterburner) then rt = "Afterburner" end
  if table.compare(head, headSpaceHarrier) then rt = "Space Harrier" end
  if table.compare(head, headGradius) then rt = "Gradius" end
  if table.compare(head, headRoadFighter) then rt = "Road Fighter" end
  if table.compare(head, headTest) then rt = "Test" end
  print(rt .. " detected")
  return rt
end

function wait(frameMax)
  local curF = emu.framecount()
  while emu.framecount() < curF + frameMax do
    emu.frameadvance()
  end
end

function autoBackup()
  if game.settings.geneticAutoBackup ~= 0 then            -- autobackup
    if (game.frame % game.settings.geneticAutoBackup) == 0 then
      geneticSave(game.settings.genFile .."-auto-" .. game.frame)
    end
  end
end

function nextFrame()
  game.frame = game.frame + 1         -- inc. cycle counter
  emu.frameadvance()                  -- emulator next frame
end

function updateHud() -- default hud
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  gui.text(170, 10, "time " .. game.frame - genetic.genomeTime)
end

function getScore() return genetic.genomeTime end -- default scoring
function update() end -- to be implemented in plugins if needed (optional)

--
if gameDetect() == "Afterburner" then require "plugins/afterburner" end -- overide with settings & functions from game
if gameDetect() == "Space Harrier" then require "plugins/space_harrier" end
if gameDetect() == "Gradius" then require "plugins/gradius" end
if gameDetect() == "Road Fighter" then require "plugins/road_fighter" end
if gameDetect() == "Test" then require "plugins/_test" end
--

function game.settings.speed.set.maximum() 
  game.settings.speed.value = "maximum" 
  emu.speedmode(game.settings.speed.value)
end

function game.settings.speed.set.turbo()
  game.settings.speed.value = "turbo"
  emu.speedmode(game.settings.speed.value)
end 

function game.settings.speed.set.normal()
  game.settings.speed.value = "normal"
  emu.speedmode(game.settings.speed.value)
end


function init(_speed)
  if _speed == "normal" then
    game.settings.speed.set.normal()
  else
    game.settings.speed.set.maximum()
  end
  emu.poweron()
  game.frame = 0
end

function saveState()
  print("saveState")
  savestate.save(savestate.object(1))
  savestate.persist(savestate.object(1))
end

function loadState()
  print("loadState")
  savestate.load(savestate.object(1))
end
--

function main(_speed)
  local control = 0                     -- set control none
  geneticLoad(game.settings.genomeMax, game.settings.genFile) 
                                        -- load genetic instance from file(.lua) or start new Genetic with max genome
  while true do                         -- infinite loop
    init(_speed)                        -- set speed & reset emul
    gameStartMacro()                    -- wait & press start macro (main game menu)
    newGenome(game.frame)               -- set a new genome with start time

    -- ALIVE --------------------------------------------------------
    while not isDead() do -- process & update
      if (game.frame % game.settings.joypad.rate) == 0 then --refresh control each x frames
        control = geneProcess(game.settings.genesAvailable)
      end
      joypad.write(1, getJoypad(control)) -- write joypad
      update()                            -- (optional) override to plugin if needed
                                              -- implement update function to the game plugin (optional)
      updateHud()                         -- refresh hud
      --autoBackup()                        -- auto backup if setting is <> 0
      nextFrame()                         -- increment game cycle counter & advance the frame emulator
    end
    -----------------------------------------------------------------

    -- DEAD ---------------------------------------------------------
    print("dead...")
    genomeTimeEnd(game.frame)         -- calculate the life time
    genomeProcess(getScore())         -- genome score
                                      -- end current genome
    if generationIsFinish() then
      fitness()                       -- fitness (to be implemented in plugin)
      print(genetic.scores)           -- display scores at console
      generationProcess(game.settings.genFile)  -- optional arg save file
                                                -- end current generation
    end
    -----------------------------------------------------------------
  end
end

main(arg)