local IgnoredValues = {
    "Instance"
}

local ValueData = {
    number = {
        FrameType = "TextBox",
        TextSet = function(val)
            return tostring(math.round(val *100) /100)
        end,
    	OnFocus = function(table,index) end,
     	OnLostFocus = function(table,index,frame) 
        	table[index] = tonumber(string.split(frame.Text," = ")[2])
        end,
    	TextChanged = function() end,
     	ValidCheck = function(val)
        	return tonumber(val)
        end,
     	Default = 0
    },
	string = {
        FrameType = "TextBox",
        TextSet = function(val)
            return '"'..val..'"'
        end,
    	OnFocus = function(table,index,frame)
        	frame.Text = index.." = "..table[index]
        end,
     	OnLostFocus = function(table,index,frame) 
        	table[index] = string.split(frame.Text," = ")[2]
        end,
    	TextChanged = function() end,
     	ValidCheck = function(val)
        	return true
        end,
     	Default = 0
    },
	boolean = {
        FrameType = "TextBox",
        TextSet = function(val)
            return tostring(val)
        end,
    	OnFocus = function(table,index,frame) end,
     	OnLostFocus = function(table,index,frame) 
        	table[index] = string.split(frame.Text," = ")[2] == "true" and true or false
        end,
    	TextChanged = function() end,
     	ValidCheck = function(val)
        	if val == "true" then
            	return true
            end
        end,
     	Default = false
    },
	table = {
        FrameType = "TextButton",
        TextSet = function(val)
            return "{    }"
        end,
    },
	func = {
        FrameType = "TextButton",
        TextSet = function(val)
            return "function( ):"
        end,
    	Clicked = function(val)
        	val()
        end
    }
}

local DefaultData = {
    FrameType = "TextLabel",
    TextSet = function(val)
        return tostring(val)
    end,
}

return function(args)
    UI = args.UI
    Table = args.Table
    
    local Data = T.GetTheme()
    
    local G = UI.UIContents
    local scaleup = UI.Scale
    
    local window = Instance.new("Frame")
	window.AnchorPoint = Vector2.new(0.5,0.5)
	window.Size = UDim2.new(0,350,0,400)
 	window.Position = UDim2.new(0,(workspace.CurrentCamera.ViewportSize.X /2) *scaleup,0,(workspace.CurrentCamera.ViewportSize.Y /2) *scaleup)
	window.BackgroundColor3 = Data.BgC
	window.Visible = false
 	window.ZIndex = 1000
	window.Parent = G
	T.AddBlur(window)
	T.AddRound(window)
 
 	window.DescendantAdded:Connect(function(v)
    	v.ZIndex += 1000
    end)
 
 	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1,0,0,25)
	textlabel.BackgroundTransparency = 1
	textlabel.Text = "Memory editor"
 	textlabel.TextSize = 22
  	textlabel.Font = Data.Font
   	textlabel.TextColor3 = Data.Color
	textlabel.Parent = window
 
 	local searchbutton = Instance.new("TextButton")
	searchbutton.Size = UDim2.new(0,25,0,25)
	searchbutton.BackgroundTransparency = 1
	searchbutton.Text = ""
	searchbutton.Parent = window
 
 	local searchlabel = Instance.new("ImageLabel")
	searchlabel.Size = UDim2.new(0,15,0,15)
 	searchlabel.Position = UDim2.new(0.5,0,0.5)
  	searchlabel.AnchorPoint = Vector2.new(0.5,0.5)
	searchlabel.BackgroundTransparency = 1
	searchlabel.Image = T.GetLibrary("Icons").search
   	searchlabel.ImageColor3 = Data.Color
	searchlabel.Parent = searchbutton
 
 	local closebutton = Instance.new("TextButton")
	closebutton.Size = UDim2.new(0,25,0,25)
 	closebutton.Position = UDim2.new(1,-25)
	closebutton.BackgroundTransparency = 1
	closebutton.Text = ""
	closebutton.Parent = window
 
 	local closelabel = Instance.new("ImageLabel")
	closelabel.Size = UDim2.new(0,17,0,17)
 	closelabel.Position = UDim2.new(0.5,0,0.5)
  	closelabel.AnchorPoint = Vector2.new(0.5,0.5)
	closelabel.BackgroundTransparency = 1
	closelabel.Image = T.GetLibrary("Icons").x
   	closelabel.ImageColor3 = Data.Color
	closelabel.Parent = closebutton
 
 	local searchbox = Instance.new("TextBox")
	searchbox.Size = UDim2.new(0,0,0,18)
 	searchbox.Position = UDim2.new(0,25,0,25 /2)
  	searchbox.AnchorPoint = Vector2.new(0,0.5)
	searchbox.BackgroundColor3 = Data.DarkC
 	searchbox.BorderColor3 = Data.DarkerC
  	searchbox.BorderSizePixel = 2
	searchbox.Text = ""
 	searchbox.ClearTextOnFocus = false
 	searchbox.TextSize = 22
  	searchbox.Font = Data.Font
   	searchbox.ZIndex = 2
   	searchbox.TextColor3 = Data.Color
    searchbox.Visible = false
	searchbox.Parent = window
 
 	searchbox:GetPropertyChangedSignal("Text"):Connect(function(txt)
      	local txt = searchbox.Text
        searchbox.Visible = txt ~= "" and true or false
        searchbox.Size = UDim2.new(0,game:GetService("TextService"):GetTextSize(txt, 22, Data.Font, Vector2.new(250,0)).X,0,18)
    end)
 
 	searchbutton.Activated:Connect(function()
    	searchbox:CaptureFocus()
    end)
 
 	local modulelist = Instance.new("ScrollingFrame")
	modulelist.Size = UDim2.new(1,-8,1,-33)
 	modulelist.Position = UDim2.new(0,8,0,26)
	modulelist.BackgroundColor3 = Data.BgC
 	modulelist.BackgroundTransparency = 1
	modulelist.Visible = true
    modulelist.ScrollBarImageColor3 = Data.DarkerC
    modulelist.CanvasSize = UDim2.new(0,0,0,0)
    modulelist.ElasticBehavior = "Never"
    modulelist.ScrollingDirection = "Y"
    modulelist.ScrollBarThickness = 0
	modulelist.Parent = window
 
 	local line = Instance.new("Frame")
	line.Size = UDim2.new(1,0,0,1)
	line.BackgroundTransparency = 0.97
 	line.BackgroundColor3 = Color3.new(1,1,1)
 	line.Position = UDim2.new(0,0,0,25)  	
  	line.BorderSizePixel = 0
  	line.Parent = window
 
 	local list = Instance.new("UIListLayout",modulelist)
  	list.SortOrder = "LayoutOrder"
 
 	update = function(Table,Parent)
    	for _,v in pairs(Parent:GetChildren()) do
        	if v.Name ~= "UIListLayout" then
            	v:Destroy()
            end
        end
    
    	for i,value in pairs(Table) do
         	if not table.find(IgnoredValues,typeof(value)) then
              	local ValueData = ValueData[typeof(value) == "function" and "func" or typeof(value)] or DefaultData
              
             	local frame = Instance.new("Frame")
            	frame.Size = UDim2.new(1,0,0,25)
            	frame.BackgroundTransparency = 1
             	frame.ClipsDescendants = true
            	frame.Parent = Parent
             
             	local label = Instance.new(ValueData.FrameType)
            	label.Size = UDim2.new(1,0,0,25)
            	label.BackgroundTransparency = 1
            	label.Text = i.." = "..ValueData.TextSet(value)
             	label.TextSize = 22
              	label.Font = Data.Font
               	label.TextColor3 = Data.Color
                label.TextXAlignment = "Left"
            	label.Parent = frame
             
             	if typeof(value) ~= "table" then
                 	UI.Clean(game:GetService("RunService").Stepped:Connect(function()
                      	if frame.Parent == nil or game:GetService("UserInputService"):GetFocusedTextBox() then return end
                       	if string.lower(i):match(string.lower(searchbox.Text)) then
                            frame.Visible = true
                        else
                        	frame.Visible = false
                         	return
                        end
                       	if typeof(Table[i]) ~= typeof(value) then
                            frame:Destroy()
                            return
                        end
                    	label.Text = i.." = "..ValueData.TextSet(Table[i])
                    end))
                else
                	UI.Clean(game:GetService("RunService").Stepped:Connect(function()
                		if frame.Parent == nil or game:GetService("UserInputService"):GetFocusedTextBox() then return end
                       	if tostring(i):match(searchbox.Text) or tostring(Table[i]):match(searchbox.Text) then
                            frame.Visible = true
                        else
                        	frame.Visible = false
                         	return
                        end
                    end))
            	end
            
            	if ValueData.FrameType == "TextBox" then
                	label.ClearTextOnFocus = false
                 	label.FocusLost:Connect(function(enter)
                      	if not enter then return end
                       	if not ValueData.ValidCheck(string.split(label.Text," = ")[2]) then
                            label.Text = i.." = "..ValueData.TextSet(ValueData.Default)
                        end
                    	ValueData.OnLostFocus(Table,i,label)
                    end)
                	label.Focused:Connect(function()
                    	ValueData.OnFocus(Table,i,label)
                    end)
                	label.Changed:Connect(function(val)
                     	if label.Text:len() <tostring(i):len()+3 then
                        	label.Text = i.." = "
                        end
                    	ValueData.TextChanged(label)
                    end)
                end
            	
             	if ValueData.FrameType == "TextButton" then
                	label.Activated:Connect(function()
                    	ValueData.Clicked(Table[i])
                    end)
                end
            
            	if typeof(value) == "table" then
                 	local modulelist = Instance.new("Frame")
                	modulelist.Size = UDim2.new(1,0,1,-50)
                 	modulelist.Position = UDim2.new(0,25,0,25)
                 	modulelist.BackgroundTransparency = 1
                	modulelist.Visible = true
                	modulelist.Parent = frame
                 
                 	local bottom = Instance.new(ValueData.FrameType)
                	bottom.Size = UDim2.new(1,0,0,25)
                 	bottom.Position = UDim2.new(0,0,1,-25)
                	bottom.BackgroundTransparency = 1
                	bottom.Text = "}"
                 	bottom.TextSize = 22
                  	bottom.Font = Data.Font
                   	bottom.TextColor3 = Data.Color
                    bottom.TextXAlignment = "Left"
                    bottom.Visible = false
                	bottom.Parent = frame
                 
                 	local list = Instance.new("UIListLayout",modulelist)
  					list.SortOrder = "LayoutOrder"
            
            		local open = false
              		local tablistsize = 0
                	local loaded = false
                    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        local size = list.AbsoluteContentSize.Y *scaleup
                        tablistsize = size
                        if open then
                        	frame.Size = UDim2.new(1,0,0,tablistsize +50)
                        end
                    end)
                
                	local loadedlength
                	label.Activated:Connect(function()
                    	open = not open	
                    	frame.Size = UDim2.new(1,0,0,open and (tablistsize +50) or 25)
                     	label.Text = i.." = "..(open and "{" or "{    }")
                      	bottom.Visible = open
                       	modulelist.Visible = open
                       	if open and not loaded then
                            update(Table[i],modulelist)
                            loadedlength = #Table[i]
                            loaded = true
                        end
                    end)
                	
                 	UI.Clean(game:GetService("RunService").Stepped:Connect(function()
                    	if loaded and loadedlength ~= #Table[i] then
                        	loadedlength = #Table[i]
                         	update(Table[i],modulelist)
                        end
                    end))
                end
         	end
        end
    end

	update(Table,modulelist)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        modulelist.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y *scaleup)
    end)

	return window
end