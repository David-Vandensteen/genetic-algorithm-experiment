--[[

    David Vandensteen
    2018

    Space Harrier H.A.L plugin
      fitness on genome time life

--]]

game.settings.joypad.rate = 20
remainingDistances = {}
distances = {}
game.settings.genomeMax = 10
game.settings.genFile = "road-fighter-genetic-save" --(implicit .lua ext)
game.settings.genesAvailable = {
                                  game.settings.joypad.none,
                                  game.settings.joypad.none,
                                  game.settings.joypad.none,
                                  game.settings.joypad.none,
                                  game.settings.joypad.right,
                                  game.settings.joypad.left
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
  while (memory.readbyte(0x00C8) == 0x00) do
    wait(1)
  end
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
  pad.A = true --auto accelerate
  return pad
end

function isDead()
  local rt = false
  while (memory.readbyte(0x00C8) == 0x00) do
    rt = true
    emu.frameadvance()
  end
  return rt
end

function getRemainingDistance() return memory.readbyte(0x009C) end

function update()
  if not distances[genomeIndex] then table.insert(distances, 0) end
  if remainingDistances[genetic.genomeIndex] then                 -- calculate dist.
    distances[genetic.genomeIndex] = distances[genetic.genomeIndex] + (remainingDistances[genetic.genomeIndex] - getRemainingDistance()) -- update dist.
  end
  remainingDistances[genetic.genomeIndex] = getRemainingDistance() -- update remaining dist.
  gui.text(170, 20, "remaining " .. remainingDistances[genetic.genomeIndex])  -- specific hud
  gui.text(170, 30, "distance " .. distances[genetic.genomeIndex])  -- specific hud
end

function getScore() return distances[genetic.genomeIndex] end

function fitness()
  genomesSort()                                                        -- sort genomes by best score
  remainingDistances = {}                                              -- reset dist array
  distances = {}                                                       -- reset dist array
  genetic.genomes[10] = genomeCopy(genetic.genomes[1])                  -- clone the best
  genetic.genomes[9] = genomeCopy(genetic.genomes[2])                  -- clone the best
  genetic.genomes[8] = genomeCopy(genetic.genomes[3])                  -- clone the best
  genetic.genomes[7] = genomeCopy(genetic.genomes[4])                  -- clone the best
  genetic.genomes[6] = genomeCopy(genetic.genomes[5])                  -- clone the best

  table.trunc(genetic.genomes[10], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[9], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[8], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[7], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[6], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[5], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[4], math.random(1, 15))                  -- remove las genes
  table.trunc(genetic.genomes[3], math.random(1, 5))                  -- remove las genes
  table.trunc(genetic.genomes[2], math.random(1, 5))                  -- remove las genes

  genomeMutate(genetic.genomes[10], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[9], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[8], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[7], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[6], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[5], 0.1, game.settings.genesAvailable) -- mutate genome at 5%
  genomeMutate(genetic.genomes[4], 0.1, game.settings.genesAvailable) -- mutate genome at 5%

end

