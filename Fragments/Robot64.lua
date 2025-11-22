local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")

local Mem = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.CharacterScript)

local rf = game:GetService("ReplicatedFirst")

local UI = T.GetLibrary("UI Library")

local blatant = UI.NewTab("Blatant")
local render = UI.NewTab("Render")
local misc = UI.NewTab("Misc")
local data = UI.NewTab("Data")

UI.OnContentsVisibility = function(val)
	if not val and Mem.UI then
        for i,v in pairs(lp.PlayerGui:GetChildren()) do
            if v.Name == "FakeUI" then
                v:Destroy()
            end
        end
     	Mem.UI.Enabled = true
 	elseif val == true and Mem.UI then
  		fakeui = Mem.UI:Clone()
    	fakeui.Name = "FakeUI"
    	fakeui.Parent = lp.PlayerGui
     	Mem.UI.Enabled = false
    end
	isinui = val
    Mem.pause(val)
end

render.NewModule(function(module)
    local speed
    local SetColor = function(color)
        local vs = Mem.vis
        for _, v in pairs(vs:GetDescendants()) do
            if v.ClassName == "MeshPart" then
                v.TextureID = ""
                v.Color = color
                v.Material = "Plastic"
            end
        end
    end

    rgb = module.NewSwitch({
        Name = "RGB skin",
        Tooltip = "Makes beboos skin a rainbow",
        Function = function(val)
            if not val and conn then
                conn:Disconnect()
                conn = nil
                return
            elseif not val then
        		return
            end
        	local hue = 0
        	conn = game:GetService("RunService").Stepped:Connect(function()
            	hue = (hue +(speed.Value /1000)) %1
             	
    			local color = Color3.fromHSV(hue, 1, 1)
     			Mem.vis.dot.Color = color
        		SetColor(color)
            end)
        end
    })

	speed = rgb.NewSlider({
    	Name = "Speed",
     	Max = 50,
      	Min = 0,
       	Default = 10
    })
end)

local assets = game:GetService("ReplicatedStorage"):FindFirstChild("Assets") or game:GetService("ReplicatedFirst")
local skins = assets:FindFirstChild("skins")
local hats = assets:FindFirstChild("hats")

local MaxSkins = #skins:GetChildren()
local MaxHats = #hats:GetChildren()
render.NewModule(function(module)
    local skin,hat
    randomize = module.NewButton({
        Name = "Randomize",
        Tooltip = "Randomizes your hat and skin",
        Function = function()
            local hat = math.random(1,MaxHats)
            local skin = math.random(1,MaxSkins)
            if rhat.Toggled then
            	Mem.hat = hat
            end
        	if rskin then
                Mem.toskin(skin)
                Mem.skin = CurrentSkin
            end
        end
    })

	rskin = randomize.NewSwitch({
    	Name = "Skin",
     	Default = true
    })

	rhat = randomize.NewSwitch({
    	Name = "Hat",
     	Default = true
    })
end)
render.NewModule(function(module)
    local delay
    spamhats = module.NewSwitch({
        Name = "Spam hats",
        Tooltip = "Loops thru every hat in the game",
        Function = function(val)
            local CurrentHat = 0
            repeat
                Mem.hat = CurrentHat
                CurrentHat = CurrentHat +1
                if CurrentHat > MaxHats then
                    CurrentHat = 1
                end
            	task.wait(delay.Value)
            until not spamhats.Toggled
        end
    })

	delay = spamhats.NewSlider({
    	Name = "Delay",
     	Max = 1,
      	Min = 0,
       	Default = 0.1
    })
end)

render.NewModule(function(module)
    local delay
    spamskins = module.NewSwitch({
        Name = "Spam skins",
        Tooltip = "Loops thru every skin in the game",
        Function = function(val)
            local CurrentSkin = 0
            repeat
            	Mem.toskin(CurrentSkin)
        		Mem.skin = CurrentSkin
            	CurrentSkin = CurrentSkin +1
            	if CurrentSkin > MaxSkins then
            	    CurrentSkin = 1
            	end
            	task.wait(delay.Value)
            until not spamskins.Toggled
        end
    })

	delay = spamskins.NewSlider({
    	Name = "Delay",
     	Max = 1,
      	Min = 0,
       	Default = 0.1
    })
end)

render.NewModule(function(module)
    local value
    scale = module.NewSwitch({
        Name = "Scale",
        Function = function(val)
            if not val then
                Mem.scale = Vector3.new(1,1,1)
                return
            end
            repeat
                Mem.scale = Vector3.new(value.Value,value.Value,value.Value)
                task.wait()
            until not scale.Toggled
        end
    })

	value = scale.NewSlider({
    	Name = "Value",
     	Max = 10,
      	Min = 0,
       	Default = 1.5
    })
end)

blatant.NewModule(function(module)
    local value
    speed = module.NewSwitch({
        Name = "Speed",
        --Tooltip = "Edit the very memory that hours uses\nwarning: can crash the game, softlock yourself, etc",
        Function = function(val)
            if not speed.Toggled then
                Mem.speed = 1
                return
            end
            repeat
            	Mem.speed = value.Value
             	task.wait() 
            until not speed.Toggled
        end
    })

	value = speed.NewSlider({
    	Name = "Value",
     	Max = 10,
      	Min = 0,
       	Default = 2
    })
end)

blatant.NewModule(function(module)
    local value
    infjump = module.NewSwitch({
        Name = "Infinite jump",
        Tooltip = "Allows you to double jump infinitely",
        Function = function(val)
            repeat
            	Mem.djump = false
             	task.wait() 
            until not infjump.Toggled
        end
    })
end)

-- shit feature 
--[[blatant.NewModule(function(module)
    local value
    waterfly = module.NewSwitch({
        Name = "Water fly",
        Tooltip = 'Uses "infwater" to allow you to swim in air, but makes you walk in water',
        Function = function(val)
            if not waterfly.Toggled then
                Mem.infwater = false
                return
            end
            repeat
            	Mem.infwater = true
             	task.wait() 
            until not waterfly.Toggled
        end
    })
end)]]

blatant.NewModule(function(module)
    local value
    fly = module.NewSwitch({
        Name = "Fly",
        --Tooltip = 'Uses "infwater" to allow you to swim in air, but makes you walk in water',
        Function = function(val)
            if not val then return end
        	local Y = 50
            repeat
            	workspace.char.Position += Vector3.new(0,Y -workspace.char.Position.Y,0)
             	task.wait()
            until not fly.Toggled
        end
    })
end)

blatant.NewModule(function(module)
    local value
    noclip = module.NewSwitch({
        Name = "Noclip",
        Tooltip = "Allows you to phase thru walls",
        Function = function(val)
        	workspace.char.CanCollide = not val
        end
    })
end)

blatant.NewModule(function(module)
    local value,oldfunction
    godmode = module.NewSwitch({
        Name = "Godmode",
        Function = function(val)
        	if val and mode.Selected == "Hook" then
            	oldfunction = Mem.damage
             	Mem.damage = function() end
            elseif mode.Selected == "Hook" then
            	Mem.damage = oldfunction
             	oldfunction = nil
           	elseif val and mode.Selected == "Value" then
            	repeat 
                	Mem.health = 4
                 	task.wait()
                until not godmode.Toggled 
            end
        end
    
    })

	mode = godmode.NewSelector({
    	Name = "Mode",
     	Table = {"Hook","Value"},
      	Tooltip = "Hook - Makes it so you cant take damage at all\nValue - Sets your health to max constantly",
       	Function = function(val)
        	if val == "Value" and oldfunction ~= nil then
            	Mem.damage = oldfunction
             	oldfunction = nil
            end
        	if godmode.Toggled then
        		godmode.Toggle()
          		godmode.Toggle()
           	end
        end,
      	Default = 1
    })
end)

blatant.NewModule(function(module)
    
    local powerup
    local powerups = {
        hasboard = "Skateboard",
        hasflame = "Flamethrower",
        hasfly = "Jetpack"
    }
    
    local getpowerup = module.NewButton({
        Name = "Get powerup",
        Function = function(val)
            local val
        	for i,v in pairs(powerups) do
            	Mem[i] = false
             	if v == powerup.Selected then
                	val = i
                end
            end
        	Mem[val] = true
        end
    
    })

	powerup = getpowerup.NewSelector({
    	Name = "Powerup",
     	Table = powerups,
      	Default = 1
    })
end)

local DataEditor = T.GetFragment("DataEditor")({
    Table = Mem,
    UI = UI
})


misc.NewModule(function(module)
    module.NewSwitch({
        Name = "Edit Memory",
        Tooltip = "Edit the very memory that robot64 uses\nwarning: can crash the game, softlock yourself, etc",
        Function = function(val)
            DataEditor.Visible = val
        end
    })
end)

data.NewModule(function(module)
    module.NewButton({
        Name = "Save",
        --Tooltip = "Edit the very memory that robot64 uses\nwarning: can crash the game, softlock yourself, etc",
        Function = function(val)
            Mem.savegame()
        end
    })
end)

data.NewModule(function(module)
    module.NewButton({
        Name = "Reset Clothing data",
        Tooltip = "Gets rid of your hats and skins",
        Function = function(val)
            for i,v in pairs(Mem.lockskin) do
            	Mem.lockskin[i] = false
        	end
        	for i,v in pairs(Mem.lockhats) do
            	Mem.lockhats[i] = false
        	end
        	Mem.lockhats[1] = true
         	Mem.lockskin[1] = true
        end
    })
end)

data.NewModule(function(module)
    module.NewButton({
        Name = "Unlock Hats",
        Function = function(val)
        	for i,v in pairs(Mem.lockhats) do
            	Mem.lockhats[i] = true
        	end
        end
    })
end)

data.NewModule(function(module)
    module.NewButton({
        Name = "Unlock Skins",
        Function = function(val)
            for i, v in pairs(Mem.lockskin) do
                local obt
                for _, v in pairs(skins:GetChildren()) do
                    if v.id.Value == i then
                        obt = v
                    	break
                	end
                end
                if obt and obt:FindFirstChild("icon") then
                    Mem.lockskin[i] = true
            	end
            end
        end
    })
end)

data.NewModule(function(module)
    local value
    local dd = module.NewButton({
        Name = "Set icecream",
        Function = function(val)
            Mem.icedcream = math.round(value.Value)
        end
    })

	value = dd.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 100,
       	Default = 64,
        Suffix = function(val) 
            return math.round(val)
        end
    })
end)

data.NewModule(function(module)
    local value
    local dd = module.NewButton({
        Name = "Set Candy",
        Function = function(val)
            Mem.candy = math.round(value.Value)
            Mem.scandy = math.round(value.Value) -1
        end
    })

	value = dd.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 10000,
       	Default = 1000,
        Round = 0,
        Suffix = function(val) 
            return math.round(val)
        end
    })
end)

data.NewModule(function(module)
    local value
    local dd = module.NewButton({
        Name = "Set Tokens",
        Function = function(val)
            Mem.tokens = math.round(value.Value)
        end
    })

	value = dd.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 100,
       	Default = 100,
        Suffix = function(val) 
            return math.round(val)
        end
    })
end)