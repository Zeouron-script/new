local Supported = T.GetConfig("Supported")

for name,game in pairs(Supported) do
	if typeof(game) == "table" then
    	for i,v in pairs(game) do
        	if tonumber(i) == game.PlaceId then
            	if typeof(v) == "function" then v() end
             	if typeof(v) == "string" then T.GetFragment(v) end
              	return
            end
        end
    elseif typeof(game) == "function" then
    	if game() then
        	T.GetFragment(name)
         	return
        end
    end
end

T.Notification("Error","Zeouron doesnt support this game.",10)