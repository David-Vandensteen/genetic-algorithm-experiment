--[[

    David Vandensteen
    2018

    Genetic lib for LUA

--]]

genomes = {}

function genomes.make(value)
  local _genomes = {}
  local _scores = {}
  for i = 1, value do
    _genomes[i] = {}
    _scores[i] = 0
  end
  return _genomes, _scores
end

function genomes.sortByScores(pgenomes, scores)
  local _genomes = {}
  for i = 1, table.getn(pgenomes) do
    _genomes[i] = table.copy(pgenomes[i])
  end

  local _sortedScores = table.copy(scores)

  for i = 1, table.getn(_sortedScores) - 1 do
    for j = 1, table.getn(_sortedScores) - 1 do
      if (_sortedScores[j] < _sortedScores[j + 1]) then
        local _bestScore = _sortedScores[j + 1]
        _sortedScores[j + 1] = _sortedScores[j]
        _sortedScores[j] = _bestScore

        local _bestGenome = _genomes[j + 1]
        _genomes[j + 1] = _genomes[j]
        _genomes[j] = _bestGenome
      end
    end
  end

  return _genomes, _sortedScores
end
