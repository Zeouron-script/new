local lp = game.Players.LocalPlayer

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local UI = T.GetLibrary("UI Library")

local Data = T.GetTheme()

movement = UI.NewTab("Movement")
blatant = UI.NewTab("Blatant")
render = UI.NewTab("Render")
util = UI.NewTab("Utillity")
--world = UI.NewTab("World")
misc = UI.NewTab("Misc")

Universal = {}
Universal.IsValidEntity = function(ent,death)
    local death = death or false
    if not ent then return false end
    local hum = ent:FindFirstChildWhichIsA("Humanoid")
    return (hum and (not death or hum.Health > 0) and ent:FindFirstChild("Head") and ent:FindFirstChild("HumanoidRootPart")) and true or false
end
Universal.GetTargets = function()
    local t = {}
	for _,v in pairs(game.Players:GetChildren()) do
     	if v ~= lp then
    		table.insert(t,v.Character)
     	end
    end
	return t
end
Universal.GetColorForTarget = function(char)
    local plr = game.Players:GetPlayerFromCharacter(char)
    return plr and plr.TeamColor.Color or Color3.new(1,1,1)
end
Universal.GetNameForTarget = function(char)
    return char:FindFirstChildWhichIsA("Humanoid") and char:FindFirstChildWhichIsA("Humanoid").DisplayName or char.Name
end

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
            	if speed.Toggled and Universal.IsValidEntity(lp.character,true) then
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
            	if jumpheight.Toggled and Universal.IsValidEntity(lp.character,true) then
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
    local value,gravity,conn,touchframe,downbutton

    if T.IsMobile then
        touchframe = lp.PlayerGui.TouchGui.TouchControlFrame
         
        downbutton = touchframe.JumpButton:Clone()
        downbutton.Size = UDim2.new(1,0,1)
        downbutton.Position = UDim2.new(-1,-20)
        downbutton.Rotation = 180
        downbutton.Visible = false
        downbutton.Parent = touchframe.JumpButton
        
        downbutton.MouseButton1Down:Connect(function()
            downbutton.ImageRectOffset = Vector2.new(146,146)
        end)
    
    	downbutton.MouseLeave:Connect(function()
            downbutton.ImageRectOffset = Vector2.new(1,146)
        end)
    	UI.Clean(downbutton)
    end
    
    fly = module.NewSwitch({
        Name = "Fly",
        Tooltip = "Allows you to fly\nX = up\nZ = down",
        Function = function(val)
         	if downbutton then
        		downbutton.Visible = val
          	end
       
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
            	if Universal.IsValidEntity(lp.character,true) then
                 	if not Y then
                    	Y = lp.character.HumanoidRootPart.Position.Y
                    end
                 	local up = not T.IsMobile and ((UIS:IsKeyDown(Enum.KeyCode.X) and 1) or (UIS:IsKeyDown(Enum.KeyCode.Z) and -1) or 0) or 
                  	((touchframe.JumpButton.ImageRectOffset.X == 146 and 1) or (downbutton.ImageRectOffset.X == 146 and -1) or 0)
                 
                 	local movedir = lp.character:FindFirstChildWhichIsA("Humanoid").MoveDirection
                	local root = lp.character.HumanoidRootPart
                 	root.AssemblyLinearVelocity = (movedir *Vector3.new(value.Value, 0, value.Value))
                  	Y += up *0.5
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
                    for _,v in pairs(Universal.GetTargets()) do
                    	if not v:FindFirstChild("chams") and not table.find(objs,v:FindFirstChild("chams")) then
                        	local hl = Instance.new("Highlight")
                         	table.insert(objs,hl)
                          	hl.Name = "chams"
                           	hl.FillColor = Universal.GetColorForTarget(v)
                            hl.OutlineTransparency = 1
                            hl.Parent = v
                        else
                        	v:FindFirstChild("chams").FillColor = Universal.GetColorForTarget(v)
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

espgui = T.NewGui("ESP",-2000001000)
render.NewModule(function(module)
    local value
    local objs = {}
    local affected = {}
    local connection
    nametags = module.NewSwitch({
        Name = "Nametags",
        Tooltip = "Allows you to see people through walls using text",
        Function = function(val)
            if val then
                connection = RS.Stepped:Connect(function()
                    for _,v in pairs(Universal.GetTargets()) do
                        local plr = game.Players:GetPlayerFromCharacter(v)
                        local name = (plr and plr.Name) or v.Name
                        local frame,normalsize
                    	if Universal.IsValidEntity(v) and not table.find(affected,v) then
                            local conn
                            frame = Instance.new("TextLabel")
                            frame.AnchorPoint = Vector2.new(0.5,0.5)
                            frame.BackgroundColor3 = Data.BgC
                            frame.BackgroundTransparency = 0.33
                            frame.BorderSizePixel = 0
                            frame.Size = UDim2.new(0,game:GetService("TextService"):GetTextSize(v.Name, 18, Data.Font, Vector2.new(math.huge, math.huge)).X +2,0,20)
                            frame.Name = name
                            frame.Text = v.Name
                            frame.TextColor3 = Universal.GetColorForTarget(v)
                            frame.TextSize = 18
                            frame.Font = Data.Font
                            frame.Parent = espgui
                            table.insert(affected,v)
                            conn = game:GetService("RunService").RenderStepped:Connect(function()
                                if not Universal.IsValidEntity(v) or not nametags.Toggled then frame:Destroy() conn:Disconnect() return end
                            	frame.TextColor3 = Universal.GetColorForTarget(v)
                             	local normalsize = UDim2.new(0,game:GetService("TextService"):GetTextSize(v.Name, 18, Data.Font, Vector2.new(math.huge, math.huge)).X +2,0,20)
                            	local pos,vis = workspace.CurrentCamera:WorldToScreenPoint(v.Head.Position)
                            	local dis = (v.Head.Position -workspace.CurrentCamera.CFrame.Position).Magnitude
                             	frame.Visible = vis
                            	frame.Position = UDim2.new(0,pos.x,0,pos.y)
                             	local multi = math.clamp(1 +(dis /300),1,2)
                             	frame.Size = UDim2.new(0,normalsize.X.Offset /multi,0,normalsize.Y.Offset /multi)
                              	frame.TextSize = 18 /multi
                            end)
                        end
                    end
                end)
            else
            	if connection then
                	connection:Disconnect()
                end
            	for _,v in pairs(espgui:GetChildren()) do
                	v:Destroy()
                end
        	end
        end
    })
end)

render.NewModule(function(module)
    local isdisguised = false
    local setdesc = function(desc)
        repeat task.wait() until lp.character and Universal.IsValidEntity(lp.character)
        
        for _,v in pairs(lp.character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("Accessory") then
                v:Destroy()
            end
        end
        
        lp.character.Humanoid:ApplyDescriptionClientServer(desc)
    end
    
    disguise = module.NewSwitch({
        Name = "Disguise",
        Tooltip = "Sets your avatar to anyone/anything (client sided)",
        Function = function(val)
            if val then
                setdesc(game.Players:GetHumanoidDescriptionFromUserId(tonumber(id.Value) or 10))
            elseif isdisguised then
            	setdesc(game.Players:GetHumanoidDescriptionFromUserId(lp.UserId))
            end
            isdisguised = val
        end
    })

	id = disguise.NewTextBox({
    	Name = "Player ID",
     	Default = "1",
      	Function = function(v)
           if disguise.Toggled and tonumber(v) then
               setdesc(game.Players:GetHumanoidDescriptionFromUserId(v))
           end
        end
    })

	lp.CharacterAdded:Connect(function()
     	if not disguise.Toggled then return end
    	task.wait(1)
     	setdesc(game.Players:GetHumanoidDescriptionFromUserId(tonumber(id.Value) or 10))
    end)
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
