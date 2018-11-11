--[[

    David Vandensteen
    2018

    FCEUX api simulation

--]]
emu = {}
joypad = {}
gui = {}
rom = {}

emu.frame = 0

function emu.frameadvance() 
  sleep(1)
  emu.frame = emu.frame + 1
  print("frameAdvance...   " .. emu.frame)
end

function emu.speedmode() end
function emu.poweron() end
function emu.framecount() return emu.frame end
function joypad.write() end
function gui.text() end
function rom.readbyte() return 0x00 end
