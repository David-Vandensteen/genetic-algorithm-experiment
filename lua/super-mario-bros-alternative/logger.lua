--[[

    David Vandensteen
    2018

    write a log file...

--]]

logger = {}
logger.file = "super_mario_bros.log"

function logger.setFile(file)
  logger.file = file
end

function logger.clear()
  local file = io.open(logger.file, "w+")
  io.close(file)
end

function logger.info(value)
  local file = io.open(logger.file, "a")
  io.output(file)
  io.write(value)
  io.write("\n")
  io.close(file)
end