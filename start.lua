--start.lua

print("Starting SmartPIR")

--set the GPIO for reset button GPIO02 - 4
btn = 4
gpio.mode(btn, gpio.INPUT, gpio.PULLUP)

-- check if reset button is pushed
if (gpio.read(btn) == 0) then
print("Reset button is pressed...resetting")
wifi.sta.disconnect()
wifi.sta.config("","")
file.remove('customurl.txt')   
end   

--variable for connecting retries
cnt = 0

--simple function to check for a file and content
function file_exists(name)
   fileresult=file.open(name,"r")
   if fileresult~=nil then file.close(fileresult) return true else return false end
end

-- if customurl file is set (exists) then we load the url
if file_exists("customurl.txt") then 
    print("Custom URL")
    file.open("customurl.txt", "r")
    customurl = file.readline()
    if customurl ~= nil then customurl = string.gsub(customurl,'\n','') else customurl="" end

    mqtt_broker_ip = file.readline()
    if mqtt_broker_ip ~= nil then mqtt_broker_ip = string.gsub(mqtt_broker_ip,'\n','') else mqtt_broker_ip="" end
    mqtt_broker_port = file.readline()
    mqtt_broker_port = string.gsub(mqtt_broker_port,'\n','')
    mqtt_broker_port = tonumber(mqtt_broker_port)
    mqtt_username = file.readline()
    if mqtt_username ~= nil then mqtt_username = string.gsub(mqtt_username,'\n','') else mqtt_username = "" end
    mqtt_password = file.readline()
    if mqtt_password ~= nil then mqtt_password = string.gsub(mqtt_password,'\n','') else mqtt_password = "" end
    mqtt_topic = file.readline()
    if mqtt_topic ~= nil then mqtt_topic = string.gsub(mqtt_topic,'\n','') else mqtt_topic = "" end
    
    file.close()
    customhost = customurl:match('^%w+://([^/]+)')
    print("URL: "..customurl.."!")
    print("Host: "..customhost.."!")
    print("MQTT IP: "..mqtt_broker_ip.."!")
    print("MQTT Port: "..mqtt_broker_port.."!")
    print("MQTT User: "..mqtt_username.."!")
    print("MQTT Password: "..mqtt_password.."!")
    print("MQTT Topic: "..mqtt_topic.."!")

 
-- try to connect to Wi-Fi ten times
-- if dont get a valid IP go to Wi-Fi set up
-- else do main stuff
   tmr.alarm(1, 1000, 1, function()
   if wifi.sta.getip()== nil then
    cnt = cnt + 1
    print("(" .. cnt .. ") Waiting for IP...")
    else
    tmr.stop(1)
    print("Connected to Wifi")
    print(wifi.sta.getip())
    dofile("action.lua")
   end
  end)
    
-- if custom url is not defined, then reset all Wi-Fi information and change to OTA config mode
else
 wifi.sta.disconnect()
 wifi.sta.config("","")
 dofile("setwifi.lua")
end
