-- Supported are "normal","turbo","nothrottle","maximum". But know that except for "normal", all other modes will run as "turbo" for now.
speed = "normal"
frameCount = 0

function makeGenes(geneMax)
  local genes = {}
  for i = 0, geneMax do
    genes[i] = math.random(0,4)
  end
  return genes
end

function makeGenomes(genomeMax, geneMax)
  local genomes = {}
  for i = 0, genomeMax do
    genomes[i] = makeGenes(geneMax)
  end
  return genomes
end

function marioIsDead()
  local deathMusicLoaded = 0x0712
  local playerState = 0x000E
  local rt = false
  while (memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B) do
    rt = true
    frameEnd()
  end
  return rt
  --if(memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B)then
  -- return true
  -- else
  -- return false
  -- end
end 
  

function joypadUpdate(value)
  --emu.print(gene)
  if value == 0 then joypad.write(1, {A = false, right = false, left = false, down = false}) end  
  if value == 1 then joypad.write(1, {right = true}) end  
  if value == 2 then joypad.write(1, {left = true}) end  
  if value == 3 then joypad.write(1, {down = true}) end  
  if value == 4 then joypad.write(1, {A = true}) end  
end

function marioGetPosition()
  local marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
  gui.text(0, 10, marioX)
  return marioX
end

function init()
  emu.speedmode(speed)
end

function frameEnd()
  frameCount = frameCount + 1
  emu.frameadvance()
end

function main()
  local geneIndex = 0
  local genomeIndex = 0
  init()
  genomes = makeGenomes(10, 1000)
  local score = {}
  --emu.print(genomes)
  while true do
    emu.print(score)
    gui.text(0, 0, frameCount)
    marioGetPosition()
    if (frameCount % 30) == 0 then 
      geneIndex = geneIndex + 1
    end
    joypadUpdate(genomes[genomeIndex][geneIndex])
    if marioIsDead() then
      score[genomeIndex] = getMarioPosition();
      emu.print("MARIO IS DEAD")
      genomeIndex = genomeIndex + 1
      geneIndex = 0
      for i = 0, 500 do frameEnd()
      end
      joypad.write(1, {start = true})
      for i = 0, 500 do 
        frameEnd()
      end
    end
    frameEnd()
  end
end

main()