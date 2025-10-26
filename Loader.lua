local Supported = T.GetConfig("Supported")

for name,value in pairs(Supported) do
	if typeof(value) == "table" then
    	for i,v in pairs(value) do
        	if tonumber(i) == game.PlaceId then
            	if typeof(v) == "function" then v() end
             	if typeof(v) == "string" then T.GetFragment(v) end
              	return
            end
        end
    elseif typeof(value) == "function" then
    	if value() then
        	T.GetFragment(name)
         	return
        end
    end
end

T.Notification("Error","Zeouron doesnt support this game.",10)

