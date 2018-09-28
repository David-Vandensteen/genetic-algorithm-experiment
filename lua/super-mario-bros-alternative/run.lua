require "lua-extend"
require "genetic"
--require "hud"
require "mario"

--Supported are "normal","turbo","nothrottle","maximum"
--SPEED = "normal"
--SPEED = "turbo"
--SPEED = "maximum"

local JOYPAD_INPUT_COMBO = {
  {right = true},
  {A = true},
  {down = true},
  {A = true, right = true},
  {A = true, right = true, down = true}
}

local GENOME_MAX = 6
local JOYPAD_RATE = 40

function run()
  local _maxScore = 0
  local _generation = 1
  local _genomes, _scores = genomes.make(6)

  -- learn
  while true do -- Change to End of game condition
    -- Play genomes
    for i = 1, GENOME_MAX do
      local _genome = _genomes[i]
      local _improIndex = table.getn(_genome)
      local _joypadIndex = 1
      local _frameCount = 0
      local _currentScore = 0

      -- Play genome
      emu.softreset()
      mario.start()
      while not mario.isDead() do
        local _currentPosition = mario.getPosition()

        -- Generate next joypad input
        if _genome[_joypadIndex] == nil then
          _genome[_joypadIndex] = math.random(1, table.getn(JOYPAD_INPUT_COMBO))
        end

        -- Play joypad input
        joypad.write(1, JOYPAD_INPUT_COMBO[_genome[_joypadIndex]])

        -- Refresh hud
        _currentScore = mario.getScore()

        --[[
        hud.display({
          _generation, i, mario.getWorld(), mario.getLevel(), mario.getMode(),
          _joypadIndex, _improIndex, _currentScore,
          _maxScore, _currentPosition
        })
        --]]

        -- Change joypad input
        if _frameCount % JOYPAD_RATE == 0 then
          _joypadIndex = _joypadIndex + 1
        end

        -- Next frame
        _frameCount = _frameCount + 1
        emu.frameadvance()
      end

      -- Refresh scores
      _currentScore = mario.getScore()

      -- Refresh scores
      _scores[i] = _currentScore

      -- Refresh max score
      if _currentScore > _maxScore then
        _maxScore =_currentScore
      end

      -- Detect anomlies
      if _joypadIndex < _improIndex then
        emu.print(_generation, i, 'failed at', _joypadIndex, 'but impro after', _improIndex)
      end
    end

    -- Process genomes
    -- _genomes, _scores = mario.fitness(_genomes, _scores, GENOME_MAX)

    -- Debug start
    _newGenomes, _newScores = mario.fitness(_genomes, _scores, GENOME_MAX)

    local _joypadIndexes = {}
    local _newJoypadIndexes = {}

    for i = 1, table.getn(_genomes) do
      _joypadIndexes[i] = table.getn(_genomes[i])
      _newJoypadIndexes[i] = table.getn(_newGenomes[i])
    end

    emu.print(_generation, _joypadIndexes, _scores, '->', _newJoypadIndexes, _newScores)
    _genomes = _newGenomes
    _scores = _newScores

    -- Debug end

    _generation = _generation + 1
  end
end

run()
