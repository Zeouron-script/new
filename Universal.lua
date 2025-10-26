local lp = game.Players.LocalPlayer

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local UI = T.GetLibrary("UI Library")

local Data = T.GetTheme()

movement = UI.NewTab("Movement")
blatant = UI.NewTab("Blatant")
render = UI.NewTab("Render")
util = UI.NewTab("Utillity")
--blatant = UI.NewTab("World")
misc = UI.NewTab("Misc")

blatant.NewModule(function(module)
    local value
    local conn
    spin = module.NewSwitch({
        Name = "Spin",
        Tooltip = "Makes you spin.",
        Function = function(val)
            if val then
            	conn = RS.Stepped:Connect(function()
                	if spin.Toggled and lp.character and lp.character:FindFirstChild("HumanoidRootPart") and lp.character:FindFirstChildWhichIsA("Humanoid") then
                     	lp.character:FindFirstChildWhichIsA("Humanoid").AutoRotate = false
                      	local root = lp.character:FindFirstChild("HumanoidRootPart")
                       	root.CFrame *= CFrame.fromEulerAngles(0, value.Value /50, 0)
                    end
                end)
            else
            	if conn then
                	conn:Disconnect()
                end
            	if lp.character:FindFirstChildWhichIsA("Humanoid") then
                	lp.character:FindFirstChildWhichIsA("Humanoid").AutoRotate = true
                end
            end
        end
    })

	value = spin.NewSlider({
    	Name = "Value",
     	Tooltip = "How fast you spin.",
      	Min = 0,
       	Max = 10,
        Default = 1
    })
end)

movement.NewModule(function(module)
    local value
    speed = module.NewSwitch({
        Name = "Speed",
        Tooltip = "Makes you walk/sprint faster.",
        Function = function(val)
        	RS.Stepped:Connect(function()
            	if speed.Toggled and lp.character and lp.character:FindFirstChild("HumanoidRootPart") and lp.character:FindFirstChildWhichIsA("Humanoid") then
                 	local movedir = lp.character:FindFirstChildWhichIsA("Humanoid").MoveDirection
                	local root = lp.character.HumanoidRootPart
                 	root.AssemblyLinearVelocity = movedir *Vector3.new(value.Value, 0, value.Value) +Vector3.new(0,root.AssemblyLinearVelocity.Y)
                end
            end)
        end
    })

	value = speed.NewSlider({
    	Name = "Value",
     	Tooltip = "How fast you go.",
      	Min = 0,
       	Max = 100,
        Default = 32
    })
end)

movement.NewModule(function(module)
    local value
    jumpheight = module.NewSwitch({
        Name = "Jump height",
        Tooltip = "Makes you jump higher.",
        Function = function(val)
        	RS.Stepped:Connect(function()
            	if jumpheight.Toggled and lp.character and lp.character:FindFirstChildWhichIsA("Humanoid") then
                	lp.character:FindFirstChildWhichIsA("Humanoid").JumpPower = value.Value
                end
            end)
        end
    })

	value = jumpheight.NewSlider({
    	Name = "Value",
     	Tooltip = "How high you jump.",
      	Min = 0,
       	Max = 100,
        Default = 50
    })
end)

movement.NewModule(function(module)
    local value,gravity,conn
    fly = module.NewSwitch({
        Name = "Fly",
        Tooltip = "Allows you to fly\nX = up\nZ = down",
        Function = function(val)
            local Y
            if val then
                repeat 
                   	task.wait()
                until lp.character and lp.character:FindFirstChild("HumanoidRootPart")
                Y = lp.character.HumanoidRootPart.Position.Y
            else
            	if conn then
                	conn:Disconnect()
                end
            	return
            end
        	conn = RS.Stepped:Connect(function()
            	if lp.character and lp.character:FindFirstChild("HumanoidRootPart") and lp.character:FindFirstChildWhichIsA("Humanoid") then
                 	if not Y then
                    	Y = lp.character.HumanoidRootPart.Position.Y
                    end
                 	local up = not T.IsMobile and ((UIS:IsKeyDown(Enum.KeyCode.X) and 1) or (UIS:IsKeyDown(Enum.KeyCode.Z) and -1) or 0) or (lp.PlayerGui.TouchGui.TouchControlFrame.JumpButton.ImageRectOffset.X == 146 and 1 or 0)
                 
                 	local movedir = lp.character:FindFirstChildWhichIsA("Humanoid").MoveDirection
                	local root = lp.character.HumanoidRootPart
                 	root.AssemblyLinearVelocity = (movedir *Vector3.new(value.Value, 0, value.Value))
                  
                  	local remove = gravity.Toggled and up == 0 and lp.character:FindFirstChildWhichIsA("Humanoid").FloorMaterial == Enum.Material.Air and 0.15 or 0
                  	Y += up *0.5 -remove
                  	root.CFrame *= CFrame.new(0,Y -root.Position.Y,0)
                elseif fly.Toggled then
                	Y = nil
                end
            end)
        end
    })

	value = fly.NewSlider({
    	Name = "Value",
     	Tooltip = "How fast you fly.",
      	Min = 0,
       	Max = 100,
        Default = 32
    })

	gravity = fly.NewSwitch({
    	Name = "Gravity",
     	Tooltip = "Makes you go down if you arent pressing X or Z\nUseful for mobile users that cant press X to go down."
    })
end)

movement.NewModule(function(module)
    local value
    infjump = module.NewSwitch({
        Name = "Infinite jump",
        Tooltip = "Allows you to jump in the air",
        Function = function(val)
            RS.Stepped:Connect(function()
                if infjump.Toggled and lp.character and lp.character:FindFirstChild("HumanoidRootPart") and lp.character:FindFirstChildWhichIsA("Humanoid") then
                    local jump = not T.IsMobile and (UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) or (lp.PlayerGui.TouchGui.TouchControlFrame.JumpButton.ImageRectOffset.X == 146 and 1 or 0)
                    if jump == 1 and lp.character:FindFirstChild("HumanoidRootPart") then
                        local root = lp.character.HumanoidRootPart
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X,lp.character:FindFirstChildWhichIsA("Humanoid").JumpPower,root.AssemblyLinearVelocity.Z)
                    end
            	end
            end)
        end
    })
end)

render.NewModule(function(module)
    local value
    local objs = {}
    local connection
    chams = module.NewSwitch({
        Name = "Chams",
        Tooltip = "Allows you to see people through walls",
        Function = function(val)
            if val then
                connection = RS.Stepped:Connect(function()
                    for _,v in pairs(game.Players:GetChildren()) do
                    	if v.character and not v.character:FindFirstChild("chams") and not table.find(objs,v.character:FindFirstChild("chams")) then
                        	local hl = Instance.new("Highlight")
                         	table.insert(objs,hl)
                          	hl.Name = "chams"
                           	hl.FillColor = Data.Color
                            hl.OutlineTransparency = 1
                            hl.Parent = v.character
                        end
                    end
                end)
            else
            	if connection then
                	connection:Disconnect()
                end
            	for _,v in pairs(objs) do
                	v:Destroy()
                end
        	end
        end
    })
end)

render.NewModule(function(module)
    local value
    local objs = {}
    local connection
    nametags = module.NewSwitch({
        Name = "Nametags",
        Tooltip = "Allows you to see people through walls using text",
        Function = function(val)
            if val then
                connection = RS.Stepped:Connect(function()
                    for _,v in pairs(game.Players:GetChildren()) do
                    	if v.character and v.character:FindFirstChild("Head") and not v.character:FindFirstChild("nametag") and not table.find(objs,v.character:FindFirstChild("chams")) then
                        	local nametag = Instance.new("BillboardGui")
                         	table.insert(objs,nametag)
                          	nametag.Name = "nametag"
                           	nametag.AlwaysOnTop = true
                            nametag.Size = UDim2.new(0,1,0,1)
                            nametag.Adornee = v.character.Head
                            nametag.Parent = v.character
	
 							--[[
                            local params = Instance.new("GetTextBoundsParams")
                            params.Text = v.Name
                            params.Size = 18
                            params.Font = Data.Font
                            params.Width = math.huge]]
                            
                            local frame = Instance.new("TextLabel")
                            frame.AnchorPoint = Vector2.new(0.5,0.5)
                            frame.BackgroundColor3 = Data.BgC
                            frame.BackgroundTransparency = 0.33
                            frame.BorderSizePixel = 0
                            frame.Size = UDim2.new(0,--[[game:GetService("TextService"):GetTextBoundsAsync(params)]] 100,0,20)
                            frame.Text = v.Name
                            frame.TextColor3 = Data.Color
                            frame.TextSize = 18
                            frame.Font = Data.Font
                            frame.Parent = nametag
                        end
                    end
                end)
            else
            	if connection then
                	connection:Disconnect()
                end
            	for _,v in pairs(objs) do
                	v:Destroy()
                end
        	end
        end
    })
end)

util.NewModule(function(module)
    local connections = {}
    antiafk = module.NewSwitch({
        Name = "Anti afk",
        Tooltip = "Makes it so you can stay afk for however long you want.",
        Function = function(val)
            if val then
				for _, v in getconnections(lp.Idled) do
					table.insert(connections, v)
					v:Disable()
				end
			else
				for _, v in connections do
					v:Enable()
				end
				table.clear(connections)
			end
        end
    })
end)

return UI