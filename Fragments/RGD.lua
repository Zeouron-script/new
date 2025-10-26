local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local UI = T.GetFragment("Universal")

misc.Remove()
render.Remove()

local notifications = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.Notifier.NotificationMaker)


local notouch = function(v)
    for _,v in pairs(v:GetDescendants()) do
        if v:IsA("TouchTransmitter") then
            v:Destroy()
        elseif v:IsA("BasePart") then
        	v.CanTouch = false
        end
    end
end

GetRooms = function()
    local tble = {}
    for _,v in pairs(workspace:GetChildren()) do
        if v.Name == "Room" or v.Name == "Old Room" then
        	table.insert(tble,v)
        end
    end
	return tble
end
GetEnemies = function()
    local tble = {}
    for _,v in pairs(GetRooms()) do
        if v:FindFirstChild("Enemies") then
            for _,v in pairs(v.Enemies:GetChildren()) do
                if v:FindFirstChild("Enemy") then
                	table.insert(tble,v)
                end
            end
        end
    end
	return tble
end

local Data = T.GetTheme()

local world = UI.NewTab("World")
local misc = UI.NewTab("Misc")

misc.NewModule(function(module)
    local msg = "reminder to add textboxes to ui library"
    module.NewButton({
        Name = "Notify",
        Tooltip = "Makes a notification with the rgd ui",
        Function = function(val)
            notifications.addNotification(msg)
        end
    })
end)

world.NewModule(function(module)
    antihazard = module.NewSwitch({
        Name = "Anti Hazard",
        Tooltip = "Makes it so you dont take damage from lava,water,acid etc",
        Function = function(val)
            repeat
                for _,v in pairs(GetRooms()) do
                	for _,v in pairs(v:GetChildren()) do
                    	if v.Name == "Sand" or v.Name == "Water" or v.Name == "Lava" or v.Name == "Acid" or v.Name == "Killer" or v.Name == "Hazard" or v:FindFirstChild("KillerScript") then
                        	notouch(v)
                        end
                    end
                end
            	task.wait(0.25)
            until not antihazard.Toggled
        end
    })
end)

util.NewModule(function(module)
    autoclicker = module.NewSwitch({
        Name = "Autoclicker",
        Function = function(val)
            repeat
                if lp.character:FindFirstChildWhichIsA("Tool") and lp.character:FindFirstChildWhichIsA("Tool"):FindFirstChild("SwordScript") then
                    lp.character:FindFirstChildWhichIsA("Tool"):Activate()
                end 
            	task.wait(0.1)
            until not autoclicker.Toggled
        end
    })
end)

util.NewModule(function(module)
    autobutton = module.NewSwitch({
        Name = "Auto button",
        Tooltip = "Clicks buttons necessary for progression (mystery buttons, regular buttons etc)",
        Function = function(val)
            repeat
                for _,v in pairs(GetRooms()) do
                	if v:FindFirstChild("Enemies") then
                    	for _,v in pairs(v.Enemies:GetChildren()) do
                        	if (v.Name == "Button" or v.Name == "MysteryButton") and v:FindFirstChild("ClickDetector") then
                            	fireclickdetector(v.ClickDetector)
                            end
                        end
                    end
                end
            	task.wait(0.25)
            until not autobutton.Toggled
        end
    })
end)

util.NewModule(function(module)
    local pickup = function(v)
        v.Transparency = 1
        v.Anchored = true
        v.CanCollide = false
        v.Position = lp.character.Torso.Position
    end
    autopickup = module.NewSwitch({
        Name = "Auto pickup",
        Tooltip = "Automatically picks up circuits and items.",
        Function = function(val)
            repeat
                for _,v in pairs(workspace:GetChildren()) do
                	if v:FindFirstChild("CircuitScript") then
                    	pickup(v)
                    end
                end
            	task.wait(0.25)
            until not autopickup.Toggled
        end
    })
end)

util.NewModule(function(module)
    antighost = module.NewSwitch({
        Name = "Anti invisible",
        Tooltip = "Makes it so you can see ghost droids while theyre invisible",
        Function = function(val)
            repeat
                for _,v in pairs(GetEnemies()) do
                	if v.Tags.Source.Value == "Ghost Droid" or v.Tags.Source.Value == "Camo Droid" then
                 		for _,v in pairs(v:GetChildren()) do
                       		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                            	v.Transparency = 0
                            end
                      	end
                	end
                end
            	task.wait(0.25)
            until not antighost.Toggled
        end
    })
end)

blatant.NewModule(function(module)
    godmode = module.NewSwitch({
        Name = "Godmode",
        Function = function(val)
            repeat
                for _,v in pairs(GetEnemies()) do
                	notouch(v)
                end
            	task.wait(0.25)
            until not godmode.Toggled
        end
    })
end)

blatant.NewModule(function(module)
    local friendly,anti
    killall = module.NewButton({
        Name = "Kill all",
        Function = function()
            for _,v in pairs(GetEnemies()) do
            	v.Enemy.Health = 0
            end
        	if friendly.Toggled or anti.Toggled then
            	for _,v in pairs(workspace.PassiveDroids:GetChildren()) do
             		if (v.Name == "Anti Droid" and anti.Toggled) or (v.Name == "Friendly Droid" and friendly.Toggled) then
                   		v:FindFirstChildWhichIsA("Humanoid").Health = 0
                  	end
             	end
            end
        end
    })

	friendly = killall.NewSwitch({
    	Name = "Kill friendly"
    })

	anti = killall.NewSwitch({
    	Name = "Kill anti"
    })
end)

blatant.NewModule(function(module)
    autokill = module.NewSwitch({
        Name = "Auto Kill",
        Tooltip = "(settings convert to this module aswell)",
        Function = function()
            repeat
                killall:Function()
                task.wait(0.25)
            until not autokill.Toggled
        end
    })
end)

blatant.NewModule(function(module)
    freeze = module.NewSwitch({
        Name = "Freeze Droids",
        Tooltip = "Makes droids unable to move",
        Function = function()
            repeat
                for _,v in pairs(GetEnemies()) do
                	v.Enemy.WalkSpeed = 0
                end
                task.wait(0.25)
            until not freeze.Toggled
        end
    })
end)

blatant.NewModule(function(module)
    freeze = module.NewButton({
        Name = "Skip Room",
        Function = function()
            game:GetService("ReplicatedStorage"):WaitForChild("PANIC"):FireServer()
        end
    })
end)

RS.Stepped:Connect(function()
    if godmode.Toggled then
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name == "Bullet" then
                notouch(v)
            end
        end
    end
end)