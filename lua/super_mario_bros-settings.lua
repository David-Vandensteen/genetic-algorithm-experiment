--[[

    David Vandensteen
    2018

    Mario Bros settings agent
--]]

game = {}
game.settings = {}
--Speed Supported are "normal","turbo","nothrottle","maximum"
game.settings.speed = {}
game.settings.speed.value = "turbo"
game.settings.speed.set = {}
function game.settings.speed.set.maximum() end
function game.settings.speed.set.turbo() end
function game.settings.speed.set.normal() end
game.settings.joypad = {}
game.settings.joypad.rate = 40
game.genetic = {}
game.genetic.settings = {}
game.genetic.settings.genomes = {}
game.genetic.settings.gene = {}
game.genetic.settings.genomes.max = 10
game.genetic.scores = {}
game.genetic.scores.values = {}
game.genetic.scores.max = 0
function game.genetic.scores.set(value) table.insert(game.genetic.scores.values, value) end
game.genetic.generation = {}
game.genetic.generation.index = 1
game.genetic.genomes = {}
