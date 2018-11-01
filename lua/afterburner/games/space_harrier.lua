--[[

    David Vandensteen
    2018

    Afterburner H.A.L settings and functions

--]]

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
game.settings.genFile = "space-harrier-genetic-save" --(implicit .lua ext)
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
                                  game.settings.joypad.dr
                                }

function gameStart()
  wait(100)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
  wait(100)
  joypad.write(1, {start = true})
  emu.frameadvance()
  joypad.write(1, {start = true})
  emu.frameadvance()
end
                                                                
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
  if (game.frame % 2) == 0 then pad.A = not pad.A end --autofire
  return pad
end

function hudUpdate()
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  gui.text(100, 20, "score " .. emu.framecount() - genetic.genomeTime)
end

function isDead()
  local rt = false
  while (memory.readbyte(0x00B1) == 0x01) do
    rt = true
    emu.frameadvance()
  end
  return rt
end

function fitness()
  genomesSort()                                         -- sort genomes by best score

  genetic.genomes[10] = genomeCopy(genetic.genomes[1])  -- clone the best
  genetic.genomes[9] = genomeCopy(genetic.genomes[2])   -- clone the best
  genetic.genomes[8] = genomeCopy(genetic.genomes[3])   -- clone the best

  table.trunc(genetic.genomes[10] ,math.random(1, 15))  -- remove last genes
  table.trunc(genetic.genomes[9] ,math.random(1, 10))   -- remove last genes
  table.trunc(genetic.genomes[8] ,math.random(1, 5))    -- remove last genes
  table.trunc(genetic.genomes[7] ,math.random(1, 5))    -- remove last genes
  table.trunc(genetic.genomes[6] ,math.random(1, 5))    -- remove last genes
  table.trunc(genetic.genomes[5] ,math.random(1, 5))    -- remove last genes
  table.trunc(genetic.genomes[4] ,math.random(1, 5))    -- remove last genes
end

