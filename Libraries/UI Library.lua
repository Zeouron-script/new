local returntable = {}

local G = T.NewGui("UI Library")

local UIS = game:GetService("UserInputService")

local Data = T.GetTheme()

local cleant = {}
local clean = function(value)
    table.insert(cleant,value)
end

if getgenv().CleanUI then
    getgenv().CleanUI()
end

getgenv().CleanUI = function()
    for _,v in pairs(cleant) do
        if typeof(v) == "Instance" then
        	v:Destroy()
        elseif typeof(v) == "RBXScriptConnection" then
        	v:Disconnect()
        elseif typeof(v) == "function" then
        	v()
        end
    end
end

local UIContents = Instance.new("Frame")
UIContents.BackgroundTransparency = 1
UIContents.Parent = G

returntable.UIContents = UIContents

local Blur = Instance.new("BlurEffect",game.Lighting)
Blur.Size = 12
clean(Blur)

local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,game:GetService("GuiService"):GetGuiInset().Y)
background.Position = UDim2.new(0,0,0,-game:GetService("GuiService"):GetGuiInset().Y)
background.BackgroundColor3 = Color3.new(0,0,0)
background.BackgroundTransparency = 0.55
background.ZIndex = -999
background.Parent = G

returntable.Clean = clean

returntable.OnContentsVisibility = function() end

returntable.Enabled = true
returntable.Disable = function()
    task.spawn(returntable.OnContentsVisibility,false)
    T.Tween({
        Blur,
        "Size",
        0.2,
        0
    })
	T.Tween({
        background,
        "BackgroundTransparency",
        0.2,
        1
    })
	UIContents.Visible = false
end

returntable.Enable = function()
    task.spawn(returntable.OnContentsVisibility,true)
    T.Tween({
        Blur,
        "Size",
        0.2,
        12
    })
	T.Tween({
        background,
        "BackgroundTransparency",
        0.2,
        0.55
    })
	UIContents.Visible = true
end

local enablebutton = Instance.new("ImageButton")
enablebutton.Position = UDim2.new(1,-80,0.5)
enablebutton.AnchorPoint = Vector2.new(0,0.5)
enablebutton.Size = UDim2.new(0,45,0,45)
enablebutton.ZIndex = 5
enablebutton.BackgroundColor3 = Data.BgC
enablebutton.BorderColor3 = Data.Color
enablebutton.BorderSizePixel = 2
enablebutton.Image = T.LoadAsset("Logo.png")
enablebutton.ImageColor3 = Data.Color
enablebutton.ZIndex = 100000
enablebutton.AutoButtonColor = false
enablebutton.Parent = G

returntable.Toggle = function()
    returntable.Enabled = not returntable.Enabled
    if returntable.Enabled then
        returntable.Enable()
    else
    	returntable.Disable()
    end
end

enablebutton.Activated:Connect(returntable.Toggle)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        returntable.Toggle()
    end
end)

local tooltip = Instance.new("TextLabel")
tooltip.Position = UDim2.new(0,0,0)
tooltip.ZIndex = 5
tooltip.BackgroundColor3 = Data.DarkerC
tooltip.Text = ""
tooltip.TextColor3 = Data.Color
tooltip.TextSize = 18
tooltip.Font = Data.Font
tooltip.ZIndex = 10000
tooltip.Parent = G

T.AddRound(tooltip)
T.AddBlur(tooltip)

-- skidded from vape v4 :money:
local addtooltip = function(gui, text)
	if not text then return end

	local function tooltipMoved(x, y)
     	tooltip.Visible = true
		tooltip.Position = UDim2.new(0,x +5,0,y -game:GetService("GuiService"):GetGuiInset().Y +5)
	end

	gui.MouseEnter:Connect(function(x, y)
		local tooltipSize = game:GetService("TextService"):GetTextSize(text, 18, Data.Font, Vector2.new(math.huge,math.huge))
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
		tooltip.Text = text
		tooltipMoved(x, y)
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		tooltip.Position = UDim2.new(-1,0,-1)
	end)
end

-- thanks vape.
dark = function(col, num)
    local h, s, v = col:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(select(3, Data.BgC:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
end

light = function(col, num)
    local h, s, v = col:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(select(3, Data.BgC:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
end

local windows = 0
returntable.Tabs = {}
returntable.Modules = {}
returntable.NewTab = function(name)
 	windows = windows +1
  	local index = windows
  
    local window = Instance.new("Frame")
	window.Name = windows..name
	window.Size = UDim2.new(0,185,0,33)
 	window.Position = UDim2.new(0,25 +(windows *195) -195,0,10)
	window.BackgroundColor3 = Data.BgC
	window.Visible = true
	window.Parent = UIContents
	T.AddBlur(window)
	T.AddRound(window)
 
	local tabenv = {}
 	returntable.Tabs[name] = tabenv
 	tabenv.Index = index
 	tabenv.Frame = window
  	tabenv.Remove = function() 
       windows = windows -1
       for _,v in pairs(returntable.Tabs) do
           if v.Index > index then
               v.Frame.Position -= UDim2.new(0,195,0,0)
               v.Index -= 1
           end
       end
       window:Destroy()
    end
 
 	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,0,33)
	text.BackgroundTransparency = 1
	text.Text = name
 	text.TextSize = 22
  	text.Font = Data.Font
   	text.TextColor3 = Data.Color
	text.Parent = window
 
 	local line = Instance.new("Frame")
	line.Size = UDim2.new(1,0,0,1)
	line.BackgroundTransparency = 0.97
 	line.BackgroundColor3 = Color3.new(1,1,1)
 	line.Position = UDim2.new(0,0,0,33)  	
  	line.BorderSizePixel = 0
  	line.Parent = window
 
 	local arrow = Instance.new("TextButton")
 	arrow.Position = UDim2.new(1,-33)
  	arrow.Size = UDim2.new(0,33,0,33)
   	arrow.BackgroundTransparency = 1
    arrow.Parent = window
    arrow.ZIndex = 2
    arrow.Text = ""
    
    tabenv.Open = true
    local open = true
    local tablistsize = 33
    arrow.Activated:Connect(function()
        open = not open
        tabenv.Open = open
        arrow.Rotation = not open and 180 or 0
        if open then
            window.Size = UDim2.new(0,185,0,tablistsize)
        else
            window.Size = UDim2.new(0,185,0,33)
        end
    end)
    
    local icon = Instance.new("ImageLabel")
    icon.AnchorPoint = Vector2.new(0.5,0.5)
    icon.Position = UDim2.new(0.5,0,0.5)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0,17,0,8)
    icon.Image = T.LoadAsset("arrow.png")
    icon.ImageColor3 = Data.Color
    icon.Parent = arrow
    
    local modulelist = Instance.new("ScrollingFrame")
	modulelist.Size = UDim2.new(1,0,1,-33)
 	modulelist.Position = UDim2.new(0,0,0,33)
	modulelist.BackgroundColor3 = Data.BgC
 	modulelist.BackgroundTransparency = 1
	modulelist.Visible = true
    modulelist.ScrollBarImageColor3 = Data.DarkerC
    modulelist.CanvasSize = UDim2.new(0,0,0,0)
    modulelist.ElasticBehavior = "Never"
    modulelist.ScrollingDirection = "Y"
    modulelist.ScrollBarThickness = 0
	modulelist.Parent = window
 
 	local list = Instance.new("UIListLayout",modulelist)
  	list.SortOrder = "LayoutOrder"
 
 	local ModulePreset = function(args,env,tooltip)
    	local frame = Instance.new("Frame")
    	frame.Name = args.Name
    	frame.Size = UDim2.new(1,0,0,33)
    	frame.BackgroundTransparency = 1
    	frame.Visible = true
     
     	returntable.Modules[args.Name] = env
      	env.Remove = function() frame:Destroy() end
     
     	if tooltip == nil then
          	local tooltipframe = Instance.new("Frame")
        	tooltipframe.Size = UDim2.new(1,0,0,33)
        	tooltipframe.BackgroundTransparency = 1
        	tooltipframe.Parent = frame
         
         	addtooltip(tooltipframe,args.Tooltip)
      	end
     
     	local label = Instance.new("TextLabel")
      	label.Size = UDim2.new(1,0,0,33)
       	label.Position = UDim2.new(0,11)
        label.BackgroundTransparency = 1
        label.Text = args.Name
        label.TextColor3 = Data.Color
        label.TextSize = 22
        label.Font = Data.Font
        label.TextXAlignment = "Left"
        label.ZIndex = 2
        label.Parent = frame
       
     	env.Frame = frame
      	env.Label = label
      	return frame
    end

	local switch = function(args,parent)
    	local env = {}
     
     	local frame = ModulePreset(args,env)
      	frame.Parent = parent
       
       	local buttonframe = Instance.new("TextButton")
      	buttonframe.Size = UDim2.new(1,0,0,33)
        buttonframe.BackgroundTransparency = 1
        buttonframe.BackgroundColor3 = Data.Color
        buttonframe.BorderSizePixel = 0
        buttonframe.Text = ""
        buttonframe.AutoButtonColor = false
        buttonframe.Parent = frame
        
        local line = Instance.new("Frame")
    	line.Size = UDim2.new(1,0,0,1)
    	line.BackgroundTransparency = 0.8
     	line.BackgroundColor3 = Color3.new()
     	line.Position = UDim2.new(0,0,0,33)  	
      	line.BorderSizePixel = 0
       	line.Visible = false
        line.ZIndex = 2
      	line.Parent = frame
        
        local func = args.Function or function() end
        env.Function = func
        env.Toggled = false
        env.Toggle = function(val)
            local val = typeof(val) == "boolean" and val or not env.Toggled
            env.Toggled = val
            
            buttonframe.BackgroundTransparency = env.Toggled and 0 or 1
            env.Label.TextColor3 = env.Toggled and Color3.new(1,1,1) or Data.Color
            line.Visible = env.Toggled
            env.Dots.ImageLabel.ImageColor3 = env.Toggled and Color3.new(1,1,1) or Data.Color
            
            func(env.Toggled)
        end
        buttonframe.Activated:Connect(env.Toggle)
        
        clean(function()
            env.Toggled = false
            func(false)
        end)
     
     	return env
    end

	local button = function(args,parent)
    	local env = {}
     
     	local frame = ModulePreset(args,env)
      	frame.Parent = parent
       
       	local buttonframe = Instance.new("TextButton")
      	buttonframe.Size = UDim2.new(1,0,0,33)
        buttonframe.BackgroundTransparency = 1
        buttonframe.BorderSizePixel = 0
        buttonframe.Text = ""
        buttonframe.ClipsDescendants = true
        buttonframe.Parent = frame
        
    	local circle = Instance.new("Frame")
     	circle.AnchorPoint = Vector2.new(0.5,0.5)
     	circle.BackgroundColor3 = Data.DarkC
      	circle.ZIndex = 5
      	
        local round = Instance.new("UICorner")
        round.Parent = circle
        round.CornerRadius = UDim.new(1,0)
        
        local func = args.Function or function() end
        env.Function = func
        buttonframe.Activated:Connect(function()
            local clone = circle:Clone()
            local mousepos = UIS:GetMouseLocation()
            clone.Position = UDim2.new(0,mousepos.X -buttonframe.AbsolutePosition.X,0,mousepos.Y -buttonframe.AbsolutePosition.Y -game:GetService("GuiService"):GetGuiInset().Y)
            clone.Parent = buttonframe
            
            T.Tween({
                clone,
                "Size",
                1.5,
                UDim2.new(0,185,0,185)
            })
        	
         	local tween = T.Tween({
                clone,
                "BackgroundTransparency",
                1.5,
                1
            })
        
        	tween.Completed:Connect(function()
            	clone:Destroy()
            end)
            
            func()
        end)
     
     	return env
    end

	local toggle = function(args,parent)
    	local env = {}
     
     	local frame = ModulePreset(args,env)
      	frame.Parent = parent
       
       	--thanks vape v4 for the ui :money:
       	local knobholder = Instance.new("Frame")
		knobholder.Size = UDim2.fromOffset(22, 12)
		knobholder.Position = UDim2.new(1, -30, 0, 10)
		knobholder.BackgroundColor3 = Data.DarkC
		knobholder.Parent = frame
  
		T.AddRound(knobholder,1)
  
		local knob = knobholder:Clone()
		knob.Size = UDim2.new(0,8,0,8)
		knob.Position = UDim2.new(0,2,0,2)
		knob.BackgroundColor3 = Data.BgC
		knob.Parent = knobholder
  
  		local button = Instance.new("TextButton")
    	button.Text = ""
     	button.BackgroundTransparency = 1
      	button.Size = UDim2.new(0.5,0,0,33)
       	button.Position = UDim2.new(0.5)
        button.Parent = frame
        
        local func = args.Function or function() end
        env.Toggled = false
        env.Toggle = function(val)
            local val = typeof(val) == "boolean" and val or not env.Toggled
            env.Toggled = val
            
            T.Tween({
                knobholder,
                "BackgroundColor3",
                0.2,
                env.Toggled and Data.Color or Data.DarkC
            })
        
        	T.Tween({
                knob,
                "Position",
                0.2,
                env.Toggled and UDim2.new(1,-10,0,2) or UDim2.new(0,2,0,2)
            })
            
            func(env.Toggled)
        end
        button.Activated:Connect(env.Toggle)
        
        if args.Default then
        	env.Toggle()
        end
     
     	return env
    end

	local slider = function(args,parent)
    	local env = {}
     
     	local frame = ModulePreset(args,env,true)
      	env.Label:Destroy()
      	frame.Parent = parent
       
       	env.Value = args.Default
        
        local label = Instance.new("TextLabel")
      	label.Size = UDim2.new(1,0,0,33 /2)
       	label.Position = UDim2.new(0,11)
        label.BackgroundTransparency = 1
        label.Text = args.Name
        label.TextColor3 = Data.Color
        label.TextSize = 18
        label.Font = Data.Font
        label.TextXAlignment = "Left"
        label.ZIndex = 2
        label.Parent = frame
        
        addtooltip(label,args.Tooltip)
        
        local valuelabel = Instance.new("TextLabel")
      	valuelabel.Size = UDim2.new(1,0,0,33 /2)
       	valuelabel.AnchorPoint = Vector2.new(1)
       	valuelabel.Position = UDim2.new(1,-11)
        valuelabel.BackgroundTransparency = 1
        valuelabel.Text = env.Value
        valuelabel.TextColor3 = Data.Color
        valuelabel.TextSize = 18
        valuelabel.Font = Data.Font
        valuelabel.TextXAlignment = "Right"
        valuelabel.ZIndex = 2
        valuelabel.Parent = frame
        
        local backbar = Instance.new("Frame")
        backbar.Size = UDim2.new(1,-20,0,6)
        backbar.Position = UDim2.new(0,10,1,-11)
        backbar.BackgroundColor3 = Data.DarkC
        backbar.Parent = frame
        
        T.AddRound(backbar,2)
        
        local bar = backbar:Clone()
        bar.BackgroundColor3 = Data.Color
        bar.Size = UDim2.new(0.5,0,1)
        bar.Position = UDim2.new()
        bar.Parent = backbar
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0,10,0,10)
        dot.Position = UDim2.new(1,-5,0,-2.5)
        dot.BackgroundColor3 = Data.Color
        dot.Parent = bar
        
        local holdframe = Instance.new("TextButton")
      	holdframe.Size = UDim2.new(1,0,0.5)
       	holdframe.Position = UDim2.new(0,0,0.5)
        holdframe.BackgroundTransparency = 1
        holdframe.Text = ""
        holdframe.Parent = frame
        
        env.Value = args.Default
        
        local func = args.Function or function() end
        local holding = false
        
        local round = round or 1
        
        env.SetValue = function(val)
            env.Value = val
            valuelabel.Text = math.round(val *10) /10
            func(val)
        end
        
        local moved = function(x) 
            if not holding then return end
            local x = math.clamp(x -backbar.AbsolutePosition.X,0,backbar.AbsoluteSize.X)
            local val = args.Min + ((args.Max -args.Min) *(x /backbar.AbsoluteSize.X))
            env.Value = val
            
            -- theres probably a better way to do this but im not good at math alright
            local multi = 1
            if round >0 then
                for i=1,round do
                	multi = i *10
                end
        	end
            
            valuelabel.Text = args.Suffix and args.Suffix(val) or math.round(val *multi) /multi
            
            bar.Size = UDim2.new(0,x,1)
            func(val)
        end
        
    	holdframe.MouseMoved:Connect(moved)
    	holdframe.MouseLeave:Connect(function()
    		holding = false
    	end)
        holdframe.MouseButton1Down:Connect(function()
            holding = true
        end)
        
        T.AddRound(dot,2)
     
     	return env
    end

	local selector = function(args,parent)
    	local env = {}
     
     	local frame = ModulePreset(args,env,true)
      	env.Label:Destroy()
      	frame.Parent = parent
       
       	env.Value = args.Default
        
        local selector = Instance.new("Frame")
      	selector.Size = UDim2.new(1,-20,1,-18)
       	selector.Position = UDim2.new(0,10,0,9)
        selector.BackgroundColor3 = Data.DarkerC
        selector.ZIndex = 2
        selector.ClipsDescendants = true
        selector.Parent = frame
        
        local button = Instance.new("TextButton")
      	button.Size = UDim2.new(1,0,0,selector.AbsoluteSize.Y)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.ZIndex = 2
        button.Parent = selector
        
        env.Selected = args.Table[args.Default]
        
        local label = Instance.new("TextLabel")
      	label.Size = UDim2.new(1,0,0,selector.AbsoluteSize.Y)
        label.BackgroundTransparency = 1
        label.Text = args.Name.." - "..tostring(env.Selected)
        label.TextColor3 = Data.Color
        label.TextSize = 18
        label.Font = Data.Font
        label.ZIndex = 2
        label.Parent = selector
        
        local length = 0
        for _ in pairs(args.Table) do
            length += 1
        end
        
        local opened = false
        button.Activated:Connect(function()
            opened = not opened
            frame.Size = UDim2.new(1,0,0,opened and (33 +(length *18)) or 33)
        end)
     
     	local i = 0
    	for _,v in pairs(args.Table) do
         	i += 1
            local button = Instance.new("TextButton")
          	button.Size = UDim2.new(1,0,0,15)
           	button.Position = UDim2.new(0,0,0,i *18)
            button.BackgroundTransparency = 1
            button.Text = tostring(v)
            button.TextColor3 = Data.Color
            button.TextSize = 18
            button.Font = Data.Font
            button.ZIndex = 3
            button.Parent = selector
            
            local func = args.Function or function() end
            button.Activated:Connect(function()
                opened = false
                frame.Size = UDim2.new(1,0,0,33)
                env.Selected = v
                label.Text = args.Name.." - "..tostring(env.Selected)
                func(v)
            end)
        end
        
        T.AddStroke(selector,Data.DarkC)
        addtooltip(selector,args.Tooltip)
        T.AddRound(selector,1)
     
     	return env
    end

	local settings = function(env)
        local modulelist = Instance.new("Frame")
    	modulelist.Size = UDim2.new(1,0,1,-33)
     	modulelist.Position = UDim2.new(0,0,0,33)
    	modulelist.BackgroundColor3 = light(Data.BgC,0.01)
      	modulelist.BorderSizePixel = 0
    	modulelist.Visible = true
        modulelist.ClipsDescendants = true
    	modulelist.Parent = env.Frame
     
     	local dots = Instance.new("TextButton")
     	dots.Position = UDim2.new(1,-33)
      	dots.Size = UDim2.new(0,33,0,33)
       	dots.BackgroundTransparency = 1
        dots.Parent = env.Frame
        dots.ZIndex = 2
        dots.Text = ""
        
        local open = false
        local listsize = 33
        dots.Activated:Connect(function()
            open = not open
            if open then
                env.Frame.Size = UDim2.new(1,0,0,listsize)
            else
            	env.Frame.Size = UDim2.new(1,0,0,33)
            end
        end)
        
        env.Dots = dots
        
        local icon = Instance.new("ImageLabel")
        icon.AnchorPoint = Vector2.new(0.5,0.5)
        icon.Position = UDim2.new(0.5,0,0.5)
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0,3,0,12)
        icon.Image = "rbxassetid://14368314459"
        icon.ImageColor3 = Data.Color
        icon.Parent = dots
     
     	local list = Instance.new("UIListLayout",modulelist)
  		list.SortOrder = "LayoutOrder"
    
    	env.NewSwitch = function(args)
         	return toggle(args,modulelist)
        end
    
    	env.NewSlider = function(args)
         	return slider(args,modulelist)
        end
    
    	env.NewSelector = function(args)
         	return selector(args,modulelist)
        end

		list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        	local size = list.AbsoluteContentSize.Y
         	if open and tabenv.Open then
        		env.Frame.Size = UDim2.new(0,185,0,size +33)
          	end
       		listsize = size +33
    	end)
    end
  
  	tabenv.NewModule = function(func)
    	local env = {}
     
     	env.NewSwitch = function(args)
         	local env = switch(args,modulelist)
          	settings(env)
           	return env
        end
    
    	env.NewButton = function(args)
         	local env = button(args,modulelist)
          	settings(env)
           	return env
        end
     
     	func(env)
      	return env
    end

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local size = list.AbsoluteContentSize.Y
    	modulelist.CanvasSize = UDim2.new(0,0,0,size)
        tablistsize = math.clamp(size +33,0, 13 *33)
        if open then
        	window.Size = UDim2.new(0,185,0,tablistsize)
        end
    end)

	return tabenv
end

T.Notification("Zeouron", "Zeouron has successfully loaded, press M to open the UI",6)

return returntable
