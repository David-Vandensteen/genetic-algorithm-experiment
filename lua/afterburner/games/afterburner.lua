--[[

    David Vandensteen
    2018

    Afterburner H.A.L settings a functions

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

function joypadUpdate(value)
  if value == game.settings.joypad.none  then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = false}) end --none
  if value == game.settings.joypad.right then joypad.write(1, {B = false, A = true , right = true , left = false, down = false, up = false}) end --r
  if value == game.settings.joypad.left  then joypad.write(1, {B = false, A = true , right = false, left = true , down = false, up = false}) end --l
  if value == game.settings.joypad.up    then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = true }) end --u
  if value == game.settings.joypad.down  then joypad.write(1, {B = false, A = true , right = false, left = false, down = true , up = false}) end --d
  if value == game.settings.joypad.a     then joypad.write(1, {B = false, A = true , right = false, left = false, down = false, up = false}) end --a
  if value == game.settings.joypad.b     then joypad.write(1, {B = true , A = true , right = false, left = false, down = false, up = false}) end --b
  if value == game.settings.joypad.ul    then joypad.write(1, {B = false, A = true , right = false, left = true , down = false, up = true }) end --ul
  if value == game.settings.joypad.ur    then joypad.write(1, {B = false, A = true , right = true , left = false, down = false, up = true }) end --ur
  if value == game.settings.joypad.dl    then joypad.write(1, {B = false, A = true , right = false, left = true , down = true , up = false}) end --dl
  if value == game.settings.joypad.dr    then joypad.write(1, {B = false, A = true , right = true , left = false, down = true , up = false}) end --dr  
end

function hudUpdate()
  gui.text(0, 10, "generation " .. genetic.generationIndex)
  gui.text(0, 20, "genome    " .. genetic.genomeIndex)
  gui.text(100, 20, "score " .. emu.framecount() - genetic.genomeTime)
end

function isDead()
  local rt = false
  while (memory.readbyte(0x0096) == 0xFF) and (memory.readbyte(0x00A8) == 0xFF) do
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

