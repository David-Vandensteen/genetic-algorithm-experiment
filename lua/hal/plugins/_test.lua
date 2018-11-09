--[[

    David Vandensteen
    2018

    Test H.A.L plugin

--]]

------------------------------
--  INIT\DEFINE\OVERRIDE HERE

--@override--------------------------------
--game.settings.genomeMax = 3 
--game.settings.joypad.rate = 30
--game.settings.geneticAutoBackup = 5000       -- backup each x game.frame (0 is off)
-------------------------------------------

game.settings.genFile = "test-genetic-save" --(implicit .lua ext)
game.settings.genesAvailable = {
                                  game.settings.joypad.none,
                                  game.settings.joypad.none, -- if u yant ponder none (for ex.)
                                  game.settings.joypad.right,
                                  game.settings.joypad.left,
                                  game.settings.joypad.up,
                                  game.settings.joypad.down,
                                  game.settings.joypad.ur,
                                  game.settings.joypad.dl,
                                  game.settings.joypad.dr
                                }

--

--@override----------------------------------------------------------
--function gameStartMacro() end
--function getScore() end
--[[
function updateHud()
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  gui.text(170, 10, "time " .. game.frame - genetic.genomeTime)
end
--]]
---------------------------------------------------------------------

                                                                
function getJoypad(value)
  local pad = {}
  if value == game.settings.joypad.none  then pad = {B = false, A = false , right = false, left = false, down = false, up = false} end --none
  if value == game.settings.joypad.right then pad = {B = false, A = false , right = true , left = false, down = false, up = false} end --r
  if value == game.settings.joypad.left  then pad = {B = false, A = false , right = false, left = true , down = false, up = false} end --l
  if value == game.settings.joypad.up    then pad = {B = false, A = false , right = false, left = false, down = false, up = true } end --u
  if value == game.settings.joypad.down  then pad = {B = false, A = false , right = false, left = false, down = true , up = false} end --d
  if value == game.settings.joypad.a     then pad = {B = false, A = true  , right = false, left = false, down = false, up = false} end --a
  if value == game.settings.joypad.b     then pad = {B = true , A = false , right = false, left = false, down = false, up = false} end --b
  if value == game.settings.joypad.ul    then pad = {B = false, A = false , right = false, left = true , down = false, up = true } end --ul
  if value == game.settings.joypad.ur    then pad = {B = false, A = false , right = true , left = false, down = false, up = true } end --ur
  if value == game.settings.joypad.dl    then pad = {B = false, A = false , right = false, left = true , down = true , up = false} end --dl
  if value == game.settings.joypad.dr    then pad = {B = false, A = false , right = true , left = false, down = true , up = false} end --dr
  return pad
end

function isDead()
  local rt = false
  while (memory.readbyte(0x00B1) == 0x01) do
    rt = true
    emu.frameadvance()
    while true do emu.frameadvance() end
  end
  return rt
end

--@override
--function update() end

function fitness()
  --sort
  --genomesSort()                                         

  --clone genome
  --genetic.genomes[3] = genomeCopy(genetic.genomes[1])

  --remove last genes
  --table.trunc(genetic.genomes[3] ,math.random(1, 15))

  --mutate at 10%. arg3 is the random table
  --genomeMutate(genetic.genomes[3], 0.10, game.settings.genesAvailable)
end

