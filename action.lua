--action.lua

curenttime = "NA"

--- MQTT ---
--mqtt_broker_ip = "broker.mqttdashboard.com"     
--mqtt_broker_port = 1883
--mqtt_username = ""
--mqtt_password = ""
mqtt_client_id = "SmartPIR"..node.chipid()
--mqtt_topic = "bobby/pir"

-- Setup MQTT client and events
m = mqtt.Client(mqtt_client_id, 120, mqtt_username, mqtt_password)

-- Set up Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline"
-- to topic "/lwt" if client don't send keepalive packet
m:lwt(mqtt_topic.."/"..node.chipid().."/status", "Offline", 0, 0)

m:on("connect", function(con) 
 print ("Connected to MQTT host") 
  --print("IP: ".. mqtt_broker_ip)
  --print("Port: ".. mqtt_broker_port)
  --print("Client ID: ".. mqtt_client_id)
  --print("Username: ".. mqtt_username)

  -- Subscribe to the topic where the ESP8266 will get commands from 
  --m:subscribe(mqtt_topic.."/available",1, function(con) print("subscribed successfully") end)
  -- Say hello
  print ("\n"..curenttime)
  m:publish(mqtt_topic.."/"..node.chipid().."/motion",curenttime, 0, 1, function(con) print("Sent to server") end)    
  print ("\n\nPublished")  
end)

-- When client disconnects, print a message and list space left on stack
m:on("offline", function(con) 
 print ("\n\nDisconnected from broker")
 print("Heap: ", node.heap())
end)

-- Connect to the broker
function connecttoserver() 
 --if wifi.sta.status() == 5 then
 if (wifi.sta.getip() ~= nil and mqtt_broker_ip ~= nil) then
  m:connect( mqtt_broker_ip , mqtt_broker_port, 0, 1)
 end
end

-- retrieve the current time from Google
conn=net.createConnection(net.TCP, 0) 
conn:on("connection",function(conn, payload)
            conn:send("HEAD / HTTP/1.1\r\n".. 
                      "Host: google.com\r\n"..
                      "Accept: */*\r\n"..
                      "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                      "\r\n\r\n") 
            end)
            
conn:on("receive", function(conn, payload)
    print('\nRetrieved in '..((tmr.now()-t)/1000)..' milliseconds.')
    print('Google says it is '..string.sub(payload,string.find(payload,"Date: ")
           +6,string.find(payload,"Date: ")+35))
    curenttime = string.sub(payload,string.find(payload,"Date: ")+6,string.find(payload,"Date: ")+35)
    conn:close()
    connecttoserver()
    end) 
t = tmr.now()    
conn:connect(80,'google.com') 

--URL and host come out of customurl.txt file
print("URL: " .. customurl)
print("Host: " .. customhost)
connn = nil
connn=net.createConnection(net.TCP, 0) 
-- sent to url if set
if (customurl ~= nil) then
 print("Sending URL")
 connn:on("connection", function(connn, payload) 
     connn:send("GET " .. customurl 
      .." HTTP/1.1\r\n" 
      .."Host: " .. customhost .. "\r\n"
      .."Accept: */*\r\n" 
      .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" 
      .."\r\n") 
      print("URL request sent.") 
end) 
end


print ("\n\nJob complete")
