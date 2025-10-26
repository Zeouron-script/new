return {
    RGD = {
        ["6312903733"] = "RGD",
        ["5561268850"] = function()
            T.Notification("Error","Please go in a match before executing Zeouron",7)
        end
    },
	Robot64 = function()
    	if game.Players.LocalPlayer.PlayerScripts:FindFirstChild("CharacterScript") then
        	return true
        end
    end,
	Hours = function()
    	if game.Players.LocalPlayer.PlayerScripts:FindFirstChild("CoreScript") then
        	return true
        end
    end
}