local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")

local UI = T.GetLibrary("UI Library")

local Mem = getsenv(game.Players.LocalPlayer.PlayerScripts.CoreScript)._G
local MenuConfig = require(game:GetService("ReplicatedStorage").MenuConfig)
local TalentConfig = require(game:GetService("ReplicatedStorage").TalentConfig)

local blatant = UI.NewTab("Blatant")
local stats = UI.NewTab("Stats")
local fun = UI.NewTab("Fun")
local misc = UI.NewTab("Misc")
local data = UI.NewTab("Data")

UI.OnContentsVisibility = function(val)
    Mem.SetCameraLock(val)
    Mem.Pause = val
end

local DataEditor = T.GetFragment("DataEditor")({
    Table = Mem,
    UI = UI
})

misc.NewModule(function(module)
    module.NewSwitch({
        Name = "Edit Memory",
        Tooltip = "Edit the very memory that hours uses\nwarning: can crash the game, softlock yourself, etc",
        Function = function(val)
            DataEditor.Visible = val
        end
    })
end)

misc.NewModule(function(module)
    timecontrol = module.NewSwitch({
        Name = "Time control",
        Tooltip = "Speeds/slows down time for your enemies or yourself"
    })

	yourself = timecontrol.NewSlider({
    	Name = "Yourself",
     	Min = 0,
      	Max = 10,
       	Default = 2
    })
	entities = timecontrol.NewSlider({
    	Name = "Entities",
     	Min = 0,
      	Max = 10,
       	Default = 0.5
    })
end)

misc.NewModule(function(module)
    nontarget = module.NewSwitch({
        Name = "Non target",
        Tooltip = "Makes it so entities dont go after you"
    })
end)

data.NewModule(function(module)
    module.NewButton({
        Name = "Unlock everything",
        Function = function(val)
        	for i,v in pairs(MenuConfig.Win) do
             	Mem.Unlocks[i] = true
                Mem.Unlocks[i.."Win"] = true
              	if Mem.Buttons[i] and Mem.TimeHues[i] then
                  	local color = Color3.fromHSV(Mem.TimeHues[i], 1, 1)
        			Mem.Buttons[i].BorderColor3 = color
        			Mem.Buttons[i].ImageColor3 = color
             	end
            end
        end
    })
end)

data.NewModule(function(module)
    module.NewSwitch({
        Name = "Hands of time",
        Function = function(val)
            Mem.Premium = val
        end
    })
end)

data.NewModule(function(module)
    module.NewSwitch({
        Name = "Cheat commands",
        Function = function(val)
            Mem.Cheats = val
        	Mem.AllGui.Menu.CheatLeft.Visible = val
        	Mem.AllGui.Menu.CheatRight.Visible = val
        end
    })
end)

stats.NewModule(function(module)
    local value
    local health = module.NewButton({
        Name = "Set Health",
        Function = function()
            Mem.Entities[1].Resources.Health = value.Value
        end
    })

	value = health.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 250,
       	Default = 100
    })
end)

stats.NewModule(function(module)
    local value
    local maxhealth = module.NewButton({
        Name = "Set MaxHealth",
        Function = function()
            Mem.Entities[1].Stats.MaxHealth[1], Mem.Entities[1].Stats.MaxHealth[2] = value.Value, value.Value
        end
    })

	value = maxhealth.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 250,
       	Default = 100
    })
end)

stats.NewModule(function(module)
    local value
    local speed = module.NewButton({
        Name = "Set Speed",
        Function = function()
            Mem.Entities[1].Stats.Speed[1], Mem.Entities[1].Stats.Speed[2] = 0, value.Value
        end
    })

	value = speed.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 50,
       	Default = 16
    })
end)

stats.NewModule(function(module)
    local value
    local power = module.NewButton({
        Name = "Set Power",
        Function = function()
            Mem.Entities[1].Stats.Power[1], Mem.Entities[1].Stats.Power[2] = value.Value, value.Value
        end
    })

	value = power.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 10,
       	Default = 1
    })
end)

stats.NewModule(function(module)
    local value
    local defense = module.NewButton({
        Name = "Set Defense",
        Function = function()
            print(1 /value.Value)
            Mem.Entities[1].Stats.Defense[1], Mem.Entities[1].Stats.Defense[2] = 1 /value.Value, 10 /value.Value
        end
    })

	value = defense.NewSlider({
    	Name = "Value",
     	Min = 0,
      	Max = 10,
       	Default = 1
    })
end)

blatant.NewModule(function(module)
    module.NewButton({
        Name = "Unlock all Talents",
        Function = function()
            if TalentConfig[Mem.Class] then
                for i,v in pairs(TalentConfig[Mem.Class]) do
                    Mem.AddTalent(i)
                end
            end
        end
    })
end)

blatant.NewModule(function(module)
    nocooldown = module.NewSwitch({
        Name = "No cooldown"
    })
end)

blatant.NewModule(function(module)
    invincibillity = module.NewSwitch({
        Name = "Invincibillity"
    })
end)

blatant.NewModule(function(module)
    fasttempo = module.NewSwitch({
        Name = "Fast Tempo"
    })
end)

blatant.NewModule(function(module)
    killall = module.NewButton({
        Name = "Kill all",
        Function = function()
            for i,v in pairs(Mem.Entities) do
                if i ~= 1 then
                    v.Resources.Health = 0
                end
            end
        end
    })
end)

local entitynames = {}
for i in pairs(Mem.CreatureDatabase) do
    table.insert(entitynames,i)
end

fun.NewModule(function(module)
    local entity,speed,health,power,defense
    local spawnentity = module.NewButton({
        Name = "Spawn entity",
        Function = function()
            local id = Mem.SpawnCreature({
                ["Name"] = entity.Selected,
                ["SpawnCFrame"] = CFrame.new((math.random() - 0.5) * 120, 0, (math.random() - 0.5) * 120),
                ["DamageTeam"] = team.Selected == "Enemy" and 2 or 1,
                ["IsBoss"] = false
            })
        	Mem.Entities[id].Resources.Health = maxhealth.Value,maxhealth.Value
          	Mem.Entities[id].Stats.MaxHealth[1], Mem.Entities[id].Stats.MaxHealth[2] = maxhealth.Value, maxhealth.Value
           	Mem.Entities[id].Stats.Speed[1], Mem.Entities[id].Stats.Speed[2] = 0, speed.Value
            Mem.Entities[id].Stats.Defense[1], Mem.Entities[id].Stats.Defense[2] = 1 /defense.Value, 1 /defense.Value
            Mem.Entities[id].Stats.Power[1], Mem.Entities[id].Stats.Power[2] = power.Value, power.Value
        end
    })

	entity = spawnentity.NewSelector({
    	Name = "Entity",
     	Table = entitynames,
      	Default = table.find(entitynames,"Super"),
       	Function = function(val)
            maxhealth.SetValue(Mem.CreatureDatabase[val].Stats.MaxHealth)
            speed.SetValue(Mem.CreatureDatabase[val].Stats.Speed)
        end
    })
	team = spawnentity.NewSelector({
    	Name = "Team",
     	Table = {"Ally","Enemy"},
      	Default = 2
    })
	maxhealth = spawnentity.NewSlider({
    	Name = "Health",
     	Min = 1,
      	Max = 1500,
      	Default = 1000
    })
	speed = spawnentity.NewSlider({
    	Name = "Speed",
     	Min = 1,
      	Max = 100,
      	Default = 16
    })
	power = spawnentity.NewSlider({
    	Name = "Power",
     	Min = 0,
      	Max = 10,
      	Default = 1
    })
	defense = spawnentity.NewSlider({
    	Name = "Defense",
     	Min = 0,
      	Max = 10,
      	Default = 1
    })
end)

GetHosts = function()
    local tble = {}
    for i,v in pairs(Mem.CreatureDatabase) do
        if v.IsHost then
            tble[i] = v
        end
    end
	return tble
end

GetHostNames = function()
    local tble = {}
    for i,v in pairs(GetHosts()) do
    	table.insert(tble,MenuConfig.Title[i] or i)
    end
	return tble
end

GetHostFromName = function(name)
    for i,v in pairs(GetHosts()) do
        if MenuConfig.Title[i] == name or i == name then
            return i
        end
    end
end

fun.NewModule(function(module)
    local entity,team
    local spawnhost = module.NewButton({
        Name = "Spawn host",
        Function = function()
            Mem.ScriptDatabase.Multiplayer:SpawnRandom(team.Selected == "Enemy" and true or false, true, 1, true, GetHostFromName(entity.Selected), math.round(upgrades.Value))
        end
    })

	entity = spawnhost.NewSelector({
    	Name = "Host",
     	Table = GetHostNames(),
      	Default = table.find(GetHostNames(),"Invader")
    })
	team = spawnhost.NewSelector({
    	Name = "Team",
     	Table = {"Ally","Enemy"},
      	Default = 2
    })
	upgrades = spawnhost.NewSlider({
    	Name = "Upgrades",
     	Min = 0,
      	Max = 25,
      	Default = 0
    })
end)

UI.Clean(RS.Stepped:Connect(function()
    Mem.NoCooldowns = nocooldown.Toggled
    Mem.GodMode = invincibillity.Toggled
    Mem.FastTempo = fasttempo.Toggled
    if not Mem.Entities[1] then return end
   	Mem.Entities[1].Targetable = not nontarget.Toggled
    if timecontrol.Toggled then
        Mem.TimeControl.TimeSpeed = math.round(entities.Value *10) /10
        Mem.Entities[1].TimeSpeed = math.round(yourself.Value *10) /10
    end
end))