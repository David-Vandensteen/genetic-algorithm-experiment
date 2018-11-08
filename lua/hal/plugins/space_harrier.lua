--[[

    David Vandensteen
    2018

    Space Harrier H.A.L plugin
      fitness on genome time life

--]]
game.settings.genomeMax = 3
game.settings.genFile = "space-harrier-genetic-save" --(implicit .lua ext)
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
  if (game.frame > 192600) then pad = {B = false, A = false , right = false, left = false, down = false, up = false} end --none --CRAP
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

function update()
  --[[
  if game.frame - genetic.genomeTime == 160000 then
    print("160000 save")
    geneticSave("160000")
  end
  if game.frame - genetic.genomeTime == 170000 then
    print("170000 save")
    geneticSave("170000")
  end
  if game.frame - genetic.genomeTime == 180000 then
    print("180000 save")
    geneticSave("180000")
  end
  if game.frame - genetic.genomeTime == 190000 then
    print("190000 save")
    geneticSave("190000")
    game.settings.speed.set.normal()
  end
  if game.frame - genetic.genomeTime == 200000 then
    print("200000 save")
    geneticSave("200000")
  end
  --]]
end

function fitness()
  genomesSort()                                         -- sort genomes by best score

  genetic.genomes[3] = genomeCopy(genetic.genomes[1])  -- clone the best
  genetic.genomes[2] = genomeCopy(genetic.genomes[1])   -- clone the best

  table.trunc(genetic.genomes[3] ,math.random(1, 15))  -- remove last genes
  table.trunc(genetic.genomes[2] ,math.random(1, 5))    -- remove last genes
end

