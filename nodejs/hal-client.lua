fileExec = "halexec_spool"

function fileExist(_name)
  local f=io.open(_name,"r")
  if f~=nil then io.close(f) return true else return false end
end

function writeFile (filePath, text)
  output = io.open(filePath, "w");
  io.output(output);
  io.write(text);
  io.close(output);
end;

function sleep(n) --todo test OS env
  --if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end --Windows
  --if n > 0 then os.execute("ping -c " .. tonumber(n+1) .. " localhost > NUL") end --NIX
  local ntime = os.time() + n
  repeat until os.time() > ntime
end

function requireExec (filePath)
  if fileExist(filePath..".lua") then
    print("load "..filePath)
    if needExecute == true then require (filePath) end
    writeFile(filePath..".lua", "")
  else
    -- file doesn t exist
    -- nothung to do
  end
end

function handleExec()
  requireExec(fileExec)
end

function main()
  while true do
    print(handleExec())
    print("Waiting code ...")
    sleep(10)
  end
end

main()
