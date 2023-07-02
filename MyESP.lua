local ESP = {
	Enabled = false,
	BoxShift = CFrame.new(0,-1.5,0),
	Size = Vector3.new(4,6,0),
	AttachShift = 1,
	Categories = {}
}
ESP.__index = ESP


local UIS = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local GetCharacter = function() return LocalPlayer.Character end
local GetCamera = function() return workspace.CurrentCamera end

local function Draw(Type, Properties)
	local Element = Drawing.new(Type)

	for Name, Property in pairs(Properties) do
		Element[Name] = Property
	end

	return Element
end

local function GetScreenPoints(CF)
	local Camera = GetCamera()
	local Locations = {
		TopLeft = CF * ESP.BoxShift * CFrame.new(ESP.Size.X/2,ESP.Size.Y/2,0),
		TopRight = CF * ESP.BoxShift * CFrame.new(-ESP.Size.X/2,ESP.Size.Y/2,0),
		BottomLeft = CF * ESP.BoxShift * CFrame.new(ESP.Size.X/2,-ESP.Size.Y/2,0),
		BottomRight = CF * ESP.BoxShift * CFrame.new(-ESP.Size.X/2,-ESP.Size.Y/2,0),
		TagPos = CF * ESP.BoxShift * CFrame.new(0,ESP.Size.Y/2,0),
		Torso = CF * ESP.BoxShift
	}

	local TopLeft, Visible1 = Camera:WorldToViewportPoint(Locations.TopLeft.Position)
	local TopRight, Visible2 = Camera:WorldToViewportPoint(Locations.TopRight.Position)
	local BottomLeft, Visible3 = Camera:WorldToViewportPoint(Locations.BottomLeft.Position)
	local BottomRight, Visible4 = Camera:WorldToViewportPoint(Locations.BottomRight.Position)
	local TargetPos, Visible5 = Camera:WorldToViewportPoint(Locations.TagPos.Position)
	local TorsoPos, Visible6 = Camera:WorldToViewportPoint(Locations.Torso.Position)

	local ScreenPoints = {
		TopLeft = TopLeft,
		TopRight = TopRight,
		BottomLeft = BottomLeft,
		BottomRight = BottomRight,
		QuadVisible = Visible1 or Visible2 or Visible3 or Visible4,

		TargetPos = TargetPos,
		TargetVisible = Visible5,

		TorsoPos = TorsoPos,
		TorsoVisible = Visible6
	}

	return ScreenPoints
end

function ESP:CreateCategory(Parent, Properties)
	local Category = setmetatable({
		Objects = {},
		Color = Properties.Color,
		Enabled = Properties.Enabled,
		Names = Properties.Names,
		Boxes = Properties.Boxes,
		Tracers = Properties.Tracers,
		Distance = Properties.Distance
	}, {})

	function Category:CreateObject(Instance)
		local Object = setmetatable({
			Instance = Instance,
			Elements = {},
			PrimaryPart = Instance:IsA('Model') and Instance:FindFirstChild(Properties.PrimaryPart) or Instance
		}, {})

		function Object:Remove()
			Category.Objects[Object.Instance] = nil
			for Type, Element in pairs(Object.Elements) do
				Element.Visible = false
				Element:Remove()
				Object.Elements[Type] = nil
			end
		end

		function Object:AddElements()
			Object.Elements['Quad'] = Draw('Quad', {
				Thickness = 2,
				Color = Category.Color,
				Transparency = 1,
				Filled = false,
				Visible = Category.Enabled
			})

			Object.Elements['Name'] = Draw('Text', {
				Text = Object.Instance.Name,
				Color = Category.Color,
				Center = true,
				Outline = true,
				Visible = Category.Enabled
			})

			Object.Elements['Distance'] = Draw('Text', {
				Color = Category.Color,
				Center = true,
				Outline = true,
				Size = 19,
				Visible = Category.Enabled
			})

			Object.Elements['Tracer'] = Draw('Line', {
				Thickness = 2,
				Color = Category.Color,
				Transparency = 1,
				Visible = Category.Enabled
			})
		end

		function Object:Update()
			local Camera = GetCamera()
			local CF = Object.PrimaryPart.CFrame
			
			if Category.Enabled and Properties.Distance <= (Camera.CFrame.Position - CF.Position).Magnitude then
				local ScreenPoints = GetScreenPoints(CF)

				local Quad = Object.Elements['Quad']
				Quad.Visible = ScreenPoints.QuadVisible and Category.Boxes

				if ScreenPoints.QuadVisible then
					Quad.PointA = Vector2.new(ScreenPoints.TopRight.X, ScreenPoints.TopRight.Y)
					Quad.PointB = Vector2.new(ScreenPoints.TopLeft.X, ScreenPoints.TopLeft.Y)
					Quad.PointC = Vector2.new(ScreenPoints.BottomLeft.X, ScreenPoints.BottomLeft.Y)
					Quad.PointD = Vector2.new(ScreenPoints.BottomRight.X, ScreenPoints.BottomRight.Y)
					Quad.Color = Category.Color
				end

				local Name = Object.Elements['Name']
				Name.Visible = ScreenPoints.TargetVisible and Category.Names

				local Distance = Object.Elements['Distance']
				Distance.Visible = ScreenPoints.TargetVisible and Category.Distances

				if ScreenPoints.TargetVisible then
					Name.Position = Vector2.new(ScreenPoints.TargetPos.X, ScreenPoints.TargetPos.Y)
					Name.Color = Category.Color

					Distance.Position = Vector2.new(ScreenPoints.TargetPos.X, ScreenPoints.TargetPos.Y + 14)
					Distance.Text = math.floor((Camera.CFrame.Position - CF.Position).Magnitude) .. 'm away'
					Distance.Color = Category.Color
				end

				local Tracer = Object.Elements['Tracer']
				Tracer.Visible = ScreenPoints.TorsoVisible and Category.Tracers

				if ScreenPoints.TorsoVisible then
					Tracer.From = Vector2.new(ScreenPoints.TorsoPos.X, ScreenPoints.TorsoPos.Y)
					Tracer.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / ESP.AttachShift)
					Tracer.Color = Category.Color
				end
			else
				for i, Element in pairs(Object.Elements) do
					Element.Visible = false
				end
			end
		end

		Category.Objects[Object.Instance] = Object

		Object.Instance.AncestryChanged:Connect(function(Child, Parent)
			if not Parent then
				Object:Remove()
			end
		end)

		Object.Instance:GetPropertyChangedSignal("Parent"):Connect(function()
			if not Object.Parent then
				Object:Remove()
			end
		end)
		
		local Humanoid = Object.Instance:FindFirstChildOfClass('Humanoid')
		if Humanoid then
			Humanoid.Died:Connect(function()
				Object:Remove()
			end)
		end

		return Object
	end

	for i, Child in pairs(Parent:GetChildren()) do
		local Object = Category:CreateObject(Child)
		Object:AddElements()
	end

	Parent.ChildAdded:Connect(function(Child)
		repeat wait() until Child.Parent and Child

		local Object = Category:CreateObject(Child)
		Object:AddElements()
	end)

	ESP.Categories[Properties.Name] = Category

	return Category
end

--local Category = ESP:CreateCategory(game:GetService("Workspace").NPCS, {
--	Name = 'NPCS',
--	Color = Color3.new(255, 0, 0),
--	Distance = 1000,
--	PrimaryPart = 'HumanoidRootPart',
--	Enabled = true,
--	Names = true,
--	Boxes = false,
--	Tracers = false,
--	Distances = false,
--})

RunService.RenderStepped:Connect(function()
	for i, Category in pairs(ESP.Categories) do
		for j, Object in pairs(Category.Objects) do
			if Object.Update then
				local Success, Error = pcall(Object.Update, Object)
				if not Success then
					warn(Error, j)
				end
			end
		end
	end
end)

return ESP
