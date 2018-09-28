require "genetic"
require "lua-extend"

-- Mario Bros Functions
mario = {}

function mario.start()
  for i = 1, 50 do emu.frameadvance() end

  joypad.write(1, {start = true})
  emu.frameadvance()

  joypad.write(1, {start = true})
  emu.frameadvance()
end

function mario.getWorld()
  local world = memory.readbyte(0x75f)
  return (world + 1) or 1
end

function mario.getLevel()
  local level = memory.readbyte(0x75c)
  return (level + 1) or 1
end

function mario.getPosition()
  local marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
  return marioX or 0
end

function mario.getTimer()
  return memory.readbyte(0x7f8) * 100 + memory.readbyte(0x7f9) * 10 + memory.readbyte(0x7fa)
end

function mario.getMode()
  return memory.readbyte(0xe)
end

function mario.isDead()
  local deathMusicLoaded = 0x0712
  local playerState = 0x000E
  local rt = false
  while (memory.readbyte(deathMusicLoaded) == 0x01 or memory.readbyte(playerState) == 0x0B) do
    rt = true
    emu.frameadvance()
  end
  return rt
end

function mario.getScore()
  return  mario.getPosition() + mario.getLevel() * 10000 + mario.getWorld() * 100000
end

function mario.getMaxScore(currentMax, scores)
  local rt = currentMax
  for i = 1, table.getn(scores) do
    if scores[i] > rt then rt = scores[i] end
  end
  return rt
end

function mario.fitness(pgenomes, scores, genomeMax)
  local _genomeLimit = genomeMax / 2

  --[[
  for i = 1, table.getn(pgenomes) do
    emu.print(scores[i], pgenomes[i])
  end
  --]]
  local _genomes, _scores = genomes.sortByScores(pgenomes, scores)
  --[[
  emu.print('')
  for i = 1, table.getn(_genomes) do
    emu.print(_scores[i], _genomes[i])
  end
  --]]

  local _newScores = {}
  for i = 1, table.getn(_genomes) - _genomeLimit do
    _genomes[i] = table.trunc(_genomes[i], table.getn(_genomes[i]) - 3)
    _genomes[i + _genomeLimit] = table.trunc(_genomes[i], table.getn(_genomes[i]) - 3)
    _newScores[i] = _scores[i]
    _newScores[i + _genomeLimit] = _scores[i]
  end

  return _genomes, _newScores
end
