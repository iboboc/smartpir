--init.lua

function abortInit()
 -- initialize abort boolean flag
 abort = false
 print('Press ENTER to abort startup')
 -- if <CR> is pressed, call abortTest
 uart.on('data','\r', abortTest, 0)
 -- start timer to execute startup function in 3 seconds
 tmr.alarm(0,3000,0,startup)
end
    
function abortTest(data)
 -- user requested abort
 abort = true
 -- turns off uart scanning
 uart.on('data')
end

function startup()
 uart.on('data')
 if abort == true then
  print('Startup aborted...')
  return
 end
 -- otherwise, start up
 print('Starting main script...')
 dofile('start.lua')
end

tmr.alarm(0,1000,0,abortInit)           -- call abortInit after 1s
