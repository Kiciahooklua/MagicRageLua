-- discord.gg/syncrypt

local LoadAI = 'pandadev_revision'

local random = math and math.random or function()
	return 0
end

local function v2()
	error("[Panda] This script could not verify its runtime environment.", 0)
end

local t1 = {}

t1[#t1 + 1] = function()
	if typeof(Enum.Material.Plastic) ~= "EnumItem" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local HttpService = game:GetService("HttpService")
	local json = HttpService:JSONEncode({
		p = true
	})

	if type(json) ~= "string" then
		error("x")
	end

	local data = HttpService:JSONDecode(json)

	if type(data) ~= "table" or data.p ~= true then
		error("x")
	end

	local v7 = HttpService:GenerateGUID(false)

	if type(v7) ~= "string" or #v7 ~= 36 or string.sub(v7, 9, 9) ~= "-" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local color3 = Color3.fromRGB(255, 0, 0)

	if typeof(color3) ~= "Color3" then
		error("x")
	end

	if math.abs(color3.R - 1) > 0.001 or color3.G ~= 0 or color3.B ~= 0 then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local v9 = Vector3.new(1, 2, 3) + Vector3.new(1, 1, 1)

	if typeof(v9) ~= "Vector3" then
		error("x")
	end

	if v9.X ~= 2 or v9.Y ~= 3 or v9.Z ~= 4 then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if pcall(Instance.new, "NC_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if pcall(getfenv, 2147483647) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local Workspace = game:GetService("Workspace")

	if typeof(Workspace) ~= "Instance" then
		error("x")
	end

	if Workspace:IsA("Workspace") ~= true then
		error("x")
	end

	if Workspace:IsA("NC_1I55UGrQXLhg") ~= false then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if not rawequal(game, workspace.Parent) then
		error("x")
	end

	if not rawequal(game:GetService("Workspace"), workspace) then
		error("x")
	end

	if not rawequal(game:GetService("Players"), game:GetService("Players")) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if type(bit32) ~= "table" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local cFrame = CFrame.new(4, 5, 6)

	if typeof(cFrame) == "CFrame" then
		local Position = cFrame.Position

		if Position.X ~= 4 or Position.Y ~= 5 or Position.Z ~= 6 then
			error("x")
		end
	else
		error("x")

		local Position = cFrame.Position

		if Position.X ~= 4 or Position.Y ~= 5 or Position.Z ~= 6 then
			error("x")

			return
		end
	end
end
t1[#t1 + 1] = function()
	if type(bit32) ~= "table" or type(bit32.extract) ~= "function" then
		error("x")
	end

	if pcall(bit32.extract, 0, 30, 10) then
		error("x")
	end

	if pcall(bit32.extract, 0, 40, 1) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if string.format("%d-%x", 255, 255) ~= "255-ff" then
		error("x")
	end

	if ("aB"):upper() ~= "AB" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local enumItems = Enum.Material:GetEnumItems()

	if type(enumItems) ~= "table" or #enumItems < 1 then
		error("x")
	end

	if Enum.Material.Plastic.Value ~= 256 then
		error("x")
	end

	if Enum.KeyCode.A.Value ~= 97 then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if type(getgenv) ~= "function" then
		return
	end

	local genv = getgenv()
	local genv2 = getgenv()

	if not (type(genv) == "table" and rawequal(genv, genv2)) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if pcall(function()
		return game()
	end) then
		error("x")
	end

	if pcall(function()
		for _ in game, nil, nil do
		end
	end) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if pcall(function()
		return game["NP_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))]
	end) then
		error("x")
	end

	local function v18()
		game.ClassName = "NC_1I55UGrQXLhg"
	end

	if pcall(v18) then
		error("x")
	end

	if pcall(function()
		return #game
	end) then
		error("x")
	end
end
t1[#t1 + 1] = function()
	if typeof(game) ~= "Instance" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local vector3 = Vector3.new(1, 2, 3)

	if vector3 == Vector3.new(1, 2, 3) ~= true then
		error("x")
	end

	if pcall(function()
		return vector3 <= vector3
	end) then
		error("x")
	end

	local Magnitude = Vector3.new(3, 4, 0).Magnitude

	if type(Magnitude) == "number" then
		if Magnitude < 4.999 or Magnitude > 5.001 then
			error("x")
		end
	else
		error("x")

		if Magnitude < 4.999 or Magnitude > 5.001 then
			error("x")
		end
	end

	if tostring(vector3) ~= "1, 2, 3" then
		error("x")
	end
end
t1[#t1 + 1] = function()
	local ok, result = pcall(Instance.new, "Part")

	if not ok or typeof(result) ~= "Instance" then
		error("x")
	end

	result.Name = "P_1I55UGrQXLhg"

	if result.Name ~= "P_1I55UGrQXLhg" then
		error("x")
	end

	if pcall(function()
		return result.NP_1I55UGrQXLhg
	end) then
		error("x")
	end

	pcall(function()
		result:Destroy()
	end)
end

local v23 = false

for _, v in ipairs(t1) do
	if not pcall(v) then
		v23 = true
	end
end

local n1 = 0

local function v27(p1)
	if not pcall(p1) then
		n1 += 1
	end
end

local t2 = {}

t2[#t2 + 1] = function()
	if type(getfenv) ~= "function" or type(setfenv) ~= "function" then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if type(require) ~= "function" then
		return
	end

	if pcall(require, "NR_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))) then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local now = os.clock()

	task.wait()

	if os.clock() - now <= 0 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if type(getmetatable) ~= "function" then
		return
	end

	if getmetatable(game) ~= "The metatable is locked" then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if type(debug.info) == "function" and debug.info(print, "s") ~= "[C]" then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local count = collectgarbage("count")
	local t3 = {}

	for i = 1, 400 do
		t3[i] = { i }
	end

	if collectgarbage("count") <= count then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if tostring(game:GetService("Workspace")) ~= "Workspace" then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local loadstring_ = loadstring or load

	if type(loadstring_) ~= "function" then
		return
	end

	local function v34(p2)
		local ok, result = pcall(loadstring_, p2)

		return ok and type(result) == "function"
	end

	if not v34("local x: number = 1 x += 1 return x") then
		error("x")
	end

	if not v34("for i = 1, 2 do continue end") then
		error("x")
	end

	if v34("return 1 & 2") then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if type(debug.info) ~= "function" then
		return
	end

	local n2 = 0

	if debug.info(pcall, "s") ~= "[C]" then
		n2 += 1
	end

	if debug.info(type, "s") ~= "[C]" then
		n2 += 1
	end

	if debug.info(typeof, "s") ~= "[C]" then
		n2 += 1
	end

	if n2 >= 2 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local RunService = game:GetService("RunService")

	if RunService:IsClient() ~= true then
		error("x")
	end

	if RunService:IsServer() ~= false then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local LocalPlayer = game:GetService("Players").LocalPlayer

	if typeof(LocalPlayer) ~= "Instance" then
		error("x")
	end

	local UserId = LocalPlayer.UserId

	if type(UserId) ~= "number" or UserId <= 0 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local u41 = false

	local function v42(...)
		if select("#", ...) > 0 then
			u41 = true
		end
	end

	v42()

	if u41 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if type(islclosure) ~= "function" and type(isexecutorclosure) ~= "function" then
		return
	end

	local t4 = {}

	local function v44(p3)
		if type(p3) == "function" then
			t4[#t4 + 1] = p3
		end
	end

	v44(type)
	v44(typeof)
	v44(rawequal)
	v44(rawget)
	v44(rawset)
	v44(getmetatable)
	v44(setmetatable)
	v44(pcall)
	v44(xpcall)
	v44(select)
	v44(next)
	v44(tostring)
	v44(tonumber)
	v44(string.sub)
	v44(string.byte)
	v44(table.concat)

	local n3 = 0

	for i = 1, #t4 do
		local ok, result = pcall(islclosure, t4[i])
		local ok2, result2 = pcall(isexecutorclosure, t4[i])

		if ok and result == true or ok2 and result2 == true then
			n3 += 1
		end
	end

	if n3 >= 3 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local t5 = {
		"_HOOKOP",
		"_BYPASS",
		"_bypassOnReset",
		"_ENV_DUMP",
		"_RTYPE",
		"CODER_CALL",
		"CODER_NAMECALL",
		"checkwhileend",
		"CHECKINDEX",
		"LuraphContinue",
		"PenguEnvContinue",
		"__larry_native_string_pack_raw",
		"__larry_native_string_unpack_raw",
		"dumperState",
		"_25msrobloxenv",
		"__logservice_callbacks",
		"__heartbeat_callbacks",
		"__log_history_buf",
		"__print_hooked",
		"KittyWare"
	}
	local t6 = {}

	if type(getgenv) == "function" then
		local ok, result = pcall(getgenv)

		if ok and type(result) == "table" then
			t6[#t6 + 1] = result
		end
	end

	t6[#t6 + 1] = _G

	for i = 1, #t6 do
		for i2 = 1, #t5 do
			local ok, result = pcall(function()
				return t6[i][t5[i2]]
			end)

			if ok and result ~= nil then
				error("x")
			end
		end
	end
end
t2[#t2 + 1] = function()
	local loadstring_ = loadstring

	loadstring_ = loadstring_ or load

	if type(loadstring_) ~= "function" or type(iscclosure) ~= "function" then
		return
	end

	local ok, result = pcall(loadstring_, "return 1")

	if not ok or type(result) ~= "function" then
		return
	end

	if iscclosure(result) ~= false then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local n4 = 0
	local connection = game:GetService("RunService").Heartbeat:Connect(function()
		n4 += 1
	end)
	local n5 = 0

	while true do
		task.wait()
		n5 += 1

		if n4 >= 2 then
			break
		elseif n5 >= 8 then
			break
		end
	end

	connection:Disconnect()

	if n4 < 2 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	local t7 = {}
	local _, result = pcall(function()
		error(t7)
	end)

	if result ~= t7 then
		error("x")
	end
end
t2[#t2 + 1] = function()
	if string.dump ~= nil then
		error("x")
	end

	if io ~= nil or package ~= nil or arg ~= nil or dofile ~= nil then
		error("x")
	end

	if type(os) == "table" and (os.getenv ~= nil or os.exit ~= nil or os.remove ~= nil) then
		error("x")
	end
end

for _, v in ipairs(t2) do
	v27(v)
end

if v23 or n1 >= 9 then
	v2()

	return
end

-- ===================== SERVICES =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ===================== CONFIG =====================
getgenv().CamiloConfig = {
	Aimbot = false,
	AimbotVisCheck = true,
	AimbotKey = "Always",
	AimbotSmoothness = 0,
	AimbotFOVDeg = 20,
	AimbotTargetPart = "Head",
	SilentAim = false,
	SilentAimVisCheck = false,
	SilentAimTargetPart = "Head",
	SilentAimFOV = 250,
	TeamCheck = true,
	MaxDistance = 1200,
	PredictiveLead = true,
	LeadCap = 15,
	Trigger = false,
	TriggerKey = "Always",
	TriggerHeadOnly = false,
	TriggerMaxDist = 400,
	Rage = {
		Enabled = false,
		Mode = "gun",
		PreferredWeapon = "primary",
		VoidSpam = false,
		VoidHide = 0.25,
		VoidAttack = 0.1,
		ShootAttempts = 2,
		SwapWhenEmpty = true,
		FireRate = 0.008,
		TeamCheck = true,
		TeleportUnder = true,
		TeleportOffset = 5
	},
	FakeUnderground = false,
	FUDepth = 5.8,
	FUWalk = true,
	FUNoclip = true,
	FUHide = true,
	FUPanic = false,
	ESP = false,
	ESPTeamCheck = true,
	ESPMaxDistance = 1200,
	ESPBox = true,
	ESPBoxColor = Color3.fromRGB(255, 255, 255),
	ESPName = true,
	ESPNameColor = Color3.fromRGB(255, 255, 255),
	ESPDistance = true,
	ESPHealth = true,
	ESPHealthColor = Color3.fromRGB(61, 224, 122),
	ESPChams = false,
	ESPChamsFillColor = Color3.fromRGB(255, 59, 78),
	SkinChanger = {
		Enabled = false
	},
	Movement = {
		FlightEnabled = false,
		FlightSpeed = 100,
		SpeedHack = false,
		SpeedValue = 16,
		Spinbot = false,
		SpinbotSpeed = 10,
		InfiniteJump = false,
		BHop = false
	},
	Visuals = {
		Fullbright = false,
		CameraFOVEnabled = false,
		CameraFOV = 90
	},
	Misc = {
		UIColor = Color3.fromRGB(66, 133, 255)
	}
}

local CamiloConfig = getgenv().CamiloConfig

-- ===================== HELPERS (original) =====================
local function v79(p4)
	if p4 == LocalPlayer then
		return true
	end

	if LocalPlayer.Team ~= nil then
		if p4.Team ~= nil then
			return LocalPlayer.Team == p4.Team
		end
	end

	return false
end
local function v80(p5)
	local Character = p5.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	return Humanoid ~= nil and Humanoid.Health > 0
end
local function v83(p6)
	local Position = workspace.CurrentCamera.CFrame.Position
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }

	local hit = workspace:Raycast(Position, p6 - Position, raycastParams)

	if not hit then
		return true
	end

	local Model = hit.Instance and hit.Instance:FindFirstAncestorOfClass("Model")

	if Model then
		if Players:GetPlayerFromCharacter(Model) then
			return true
		end
	end

	return (hit.Position - p6).Magnitude < 3
end

local t8 = {
	"PhysicalHitboxHead",
	"HitboxHead",
	"HitboxHeadSmall",
	"Head"
}
local t9 = {
	"HitboxBody",
	"UpperTorso",
	"HumanoidRootPart",
	"LowerTorso"
}

local function v90(p7, p8)
	if not p7 then
		return nil
	end

	local v91 = p8 == "Torso" and t9

	v91 = v91 or t8

	for _, v in ipairs(v91) do
		local v94 = p7:FindFirstChild(v)

		if v94 and v94:IsA("BasePart") then
			return v94
		end
	end

	return p7:FindFirstChild("HumanoidRootPart")
end
local function v95(p9)
	if p9 == "MB1" then
		return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	end

	if p9 == "MB2" then
		return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	end

	if p9 == "Always" then
		return true
	end

	local v96 = Enum.KeyCode[p9]

	if v96 then
		return UserInputService:IsKeyDown(v96)
	end

	return false
end
local function v97(p10, p11)
	if not p10 or p10 == LocalPlayer then
		return false
	end

	if CamiloConfig.TeamCheck and v79(p10) then
		return false
	end

	if not v80(p10) then
		return false
	end

	local Character = p10.Character
	local HumanoidRootPart = Character

	HumanoidRootPart = HumanoidRootPart and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return false
	end

	local Character2 = LocalPlayer.Character
	local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart2 and CamiloConfig.MaxDistance < (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude then
		return false
	end

	if not p11 or v83(HumanoidRootPart.Position) then
		return true
	end

	return false
end
local function v102(p12)
	local v103 = p12 or {}
	local fov = v103.fov or 90
	local checkVis = v103.checkVis or false
	local partMode = v103.partMode or "Head"
	local ViewportSize = workspace.CurrentCamera.ViewportSize
	local vector2 = Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
	local v109
	local v110
	local huge = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if v97(player, false) then
			local v114 = v90(player.Character, partMode)

			if v114 and (not checkVis or v83(v114.Position)) then
				local v115, v116 = workspace.CurrentCamera:WorldToViewportPoint(v114.Position)

				if v116 and v115.Z > 0 then
					local Magnitude = (Vector2.new(v115.X, v115.Y) - vector2).Magnitude

					if Magnitude <= fov and Magnitude < huge then
						huge = Magnitude
						v109 = player
						v110 = v114
					end
				end
			end
		end
	end

	return v109, v110
end

-- ===================== AIMBOT =====================
local t10 = {
	enabled = false
}

local function v119()
	if not CamiloConfig.Aimbot then
		return
	end

	if not v95(CamiloConfig.AimbotKey) then
		return
	end

	local v120, v121 = v102({
		fov = CamiloConfig.AimbotFOVDeg * 5,
		checkVis = CamiloConfig.AimbotVisCheck,
		partMode = CamiloConfig.AimbotTargetPart
	})

	if v120 and v121 then
		local v122 = workspace.CurrentCamera:WorldToScreenPoint(v121.Position)

		if v122.Z > 0 then
			local ViewportSize = workspace.CurrentCamera.ViewportSize
			local vector2 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
			local v125 = Vector2.new(v122.X, v122.Y) - vector2
			local AimbotSmoothness = CamiloConfig.AimbotSmoothness or 0

			if AimbotSmoothness > 0 then
				v125 *= 1 - math.min(AimbotSmoothness / 100, 0.95)
			end

			if mousemoverel then
				mousemoverel(v125.X, v125.Y)
			end
		end
	end
end

t10.enable = function()
	CamiloConfig.Aimbot = true

	if not t10.enabled then
		t10.enabled = true
		RunService:BindToRenderStep("CamiloAimbot", Enum.RenderPriority.Camera.Value + 1, v119)
	end
end
t10.disable = function()
	CamiloConfig.Aimbot = false

	if t10.enabled then
		t10.enabled = false
		RunService:UnbindFromRenderStep("CamiloAimbot")
	end
end

-- Silent Aim hook (original)
task.spawn(function()
	local u127 = false

	while not u127 do
		task.wait(2)
		pcall(function()
			local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")

			if not PlayerScripts then
				return
			end

			local Modules = PlayerScripts:FindFirstChild("Modules")

			if not Modules then
				return
			end

			local ItemTypes = Modules:FindFirstChild("ItemTypes")

			if not ItemTypes then
				return
			end

			local Gun = require(ItemTypes:FindFirstChild("Gun"))

			if not Gun or not Gun.StartShooting then
				return
			end

			local Utility = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Utility"))

			if not Utility then
				return
			end

			if shared._LH_GunOrig then
				pcall(function()
					Gun.StartShooting = shared._LH_GunOrig
				end)
			end

			shared._LH_GunOrig = Gun.StartShooting
			Gun.StartShooting = function(p13, ...)
				local t11 = { shared._LH_GunOrig(p13, ...) }

				pcall(function()
					if not p13.ClientFighter or not p13.ClientFighter.IsLocalPlayer then
						return
					end

					local v134 = t11[3]

					if v134 then
						if typeof(v134) == "table" then
							if CamiloConfig.SilentAim then
								local Position = workspace.CurrentCamera.CFrame.Position
								local v136, v137 = v102({
									fov = CamiloConfig.SilentAimFOV,
									checkVis = CamiloConfig.SilentAimVisCheck,
									partMode = CamiloConfig.SilentAimTargetPart
								})

								if v136 and v137 then
									local vector3 = Vector3.zero

									if CamiloConfig.PredictiveLead then
										local HumanoidRootPart = v136.Character and v136.Character:FindFirstChild("HumanoidRootPart")

										if HumanoidRootPart then
											vector3 = HumanoidRootPart.AssemblyLinearVelocity * ((LocalPlayer:GetNetworkPing() or 0.05) + 0.03)

											if CamiloConfig.LeadCap < vector3.Magnitude then
												vector3 = vector3.Unit * CamiloConfig.LeadCap
											end
										end
									end

									local v140 = v137.Position + vector3
									local cFrame = CFrame.lookAt(Position, v140)
									local cFrame2 = CFrame.lookAt(Position - Vector3.new(0, 0.07, 0), v140)
									local v143 = v137.CFrame:PointToObjectSpace(v140)
									local v144 = v137.Size * 0.45
									local vector32 = Vector3.new(math.clamp(v143.X, -v144.X, v144.X), math.clamp(v143.Y, -v144.Y, v144.Y), math.clamp(v143.Z, -v144.Z, v144.Z))

									v134[utf8.char(0)] = Utility:EncodeCFrame(cFrame)
									v134[utf8.char(1)] = Utility:EncodeCFrame(cFrame2)
									v134[utf8.char(2)] = v137
									v134[utf8.char(3)] = Utility:EncodeCFrame(v137.CFrame:ToObjectSpace(CFrame.new(v137.CFrame:PointToWorldSpace(vector32))))
									t11[4] = true
								end
							end

							return
						end
					end
				end)

				return unpack(t11)
			end
			u127 = true
			print("[Silent Aim] Hooked successfully")
		end)
	end
end)

-- ===================== TRIGGERBOT =====================
local t12 = {
	enabled = false
}

local function v147()
	if not CamiloConfig.Trigger then
		return
	end

	if not v95(CamiloConfig.TriggerKey) then
		return
	end

	local CFrame_ = workspace.CurrentCamera.CFrame
	local v149 = math.clamp(CamiloConfig.TriggerMaxDist, 1, 400)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }

	local hit = workspace:Raycast(CFrame_.Position, CFrame_.LookVector * v149, raycastParams)

	if hit and hit.Instance then
		local Model = hit.Instance:FindFirstAncestorOfClass("Model")

		if Model then
			local playerFromCharacter = Players:GetPlayerFromCharacter(Model)

			if playerFromCharacter and playerFromCharacter ~= LocalPlayer and v97(playerFromCharacter, false) then
				if CamiloConfig.TriggerHeadOnly then
					local Name = hit.Instance.Name
					local v155 = false

					for _, v in ipairs(t8) do
						if Name == v then
							v155 = true

							break
						end
					end

					if not v155 then
						return
					end
				end

				local FighterController = LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):FindFirstChild("FighterController")

				if FighterController then
					pcall(function()
						require(FighterController).LocalFighter:Input("StartShooting")
					end)
				end
			end
		end
	end
end

t12.enable = function()
	CamiloConfig.Trigger = true

	if not t12.enabled then
		t12.enabled = true
		RunService:BindToRenderStep("CamiloTrigger", Enum.RenderPriority.Camera.Value + 2, v147)
	end
end
t12.disable = function()
	CamiloConfig.Trigger = false

	if t12.enabled then
		t12.enabled = false
		RunService:UnbindFromRenderStep("CamiloTrigger")
	end
end

-- ===================== FAKE UNDERGROUND =====================
local t13 = {
	on = false,
	depth = 5.8,
	walk = true,
	hide = true,
	noclip = true,
	panic = false,
	virtualCF = nil,
	saved = nil,
	hb = nil
}

local function v160()
	local Character = LocalPlayer.Character

	if not Character then
		return
	end

	t13.saved = {}

	for _, descendant in ipairs(Character:GetDescendants()) do
		if not descendant:IsA("BasePart") then
			if not descendant:IsA("Decal") then
				continue
			end
		end

		t13.saved[#t13.saved + 1] = {
			part = descendant,
			t = descendant.Transparency
		}
		pcall(function()
			descendant.Transparency = 1
		end)
	end
end
local function v164()
	if not t13.saved then
		return
	end

	for _, v in ipairs(t13.saved) do
		if v.part and v.part.Parent then
			pcall(function()
				v.part.Transparency = v.t
			end)
		end
	end

	t13.saved = nil
end
local function v167()
	t13.on = false
	t13.virtualCF = nil

	if t13.hb then
		t13.hb:Disconnect()
		t13.hb = nil
	end

	v164()

	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		pcall(function()
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end)
	end
end
local function v169()
	t13.on = true

	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		t13.virtualCF = HumanoidRootPart.CFrame
	end

	if t13.hide then
		v160()
	end

	t13.hb = RunService.Heartbeat:Connect(function(dt)
		if not t13.on then
			return
		end

		local Character = LocalPlayer.Character
		local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart2 or not Humanoid then
			return
		end

		local LookVector = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, -1)
		local cFrame = CFrame.Angles(0, math.atan2(-LookVector.X, -LookVector.Z), 0)

		if not t13.virtualCF then
			t13.virtualCF = CFrame.new(HumanoidRootPart2.Position) * cFrame
		end

		local Position = t13.virtualCF.Position

		if t13.walk and Humanoid.MoveDirection.Magnitude > 0 then
			Position += Humanoid.MoveDirection * (Humanoid.WalkSpeed * dt)
		end

		t13.virtualCF = CFrame.new(Position) * cFrame

		local v177 = Position - Vector3.new(0, t13.depth, 0)

		if t13.panic then
			v177 += Vector3.new((math.random() - 0.5) * 10, 0, (math.random() - 0.5) * 10)
		end

		if t13.noclip then
			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end

		HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
		HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
		HumanoidRootPart2.CFrame = CFrame.new(v177) * cFrame

		if t13.hide and t13.saved then
			for _, v in ipairs(t13.saved) do
				if v.part and v.part.Parent and v.part.Transparency ~= 1 then
					pcall(function()
						v.part.Transparency = 1
					end)
				end
			end
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	if t13.on then
		task.wait(1)
		v167()
		v169()
	end
end)

-- ===================== ESP (original custom) =====================
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "CamiloESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 5
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local t14 = {}
local connection

local function v185(p14)
	local Frame = Instance.new("Frame")

	Frame.Name = p14.Name
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Visible = false
	Frame.Parent = ScreenGui

	local t15 = {}

	for k, v in pairs({
		Top = {
			Pos = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 1)
		},
		Right = {
			Pos = UDim2.new(1, -1, 0, 0),
			Size = UDim2.new(0, 1, 1, 0)
		},
		Bottom = {
			Pos = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1)
		},
		Left = {
			Pos = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0)
		}
	}) do
		local Frame2 = Instance.new("Frame")

		Frame2.Name = "Line_" .. k
		Frame2.Position = v.Pos
		Frame2.Size = v.Size
		Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame2.BorderSizePixel = 0
		Frame2.ZIndex = 4
		Frame2.Visible = false
		Frame2.Parent = Frame
		t15[k] = Frame2
	end

	local Frame2 = Instance.new("Frame")

	Frame2.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Frame2.BorderSizePixel = 0
	Frame2.Position = UDim2.fromOffset(-5, 0)
	Frame2.Size = UDim2.new(0, 1, 1, 0)
	Frame2.ZIndex = 7
	Frame2.Visible = false
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.BackgroundColor3 = Color3.fromRGB(61, 224, 122)
	Frame3.BorderSizePixel = 0
	Frame3.AnchorPoint = Vector2.new(0, 1)
	Frame3.Position = UDim2.new(0, 0, 1, 0)
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3.ZIndex = 9
	Frame3.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.AnchorPoint = Vector2.new(0.5, 1)
	TextLabel.Position = UDim2.new(0.5, 0, 0, -3)
	TextLabel.Size = UDim2.fromOffset(250, 16)
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.Font = Enum.Font.Code
	TextLabel.TextSize = 13
	TextLabel.ZIndex = 12
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.Text = ""
	TextLabel.Parent = Frame

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.BackgroundTransparency = 1
	TextLabel2.AnchorPoint = Vector2.new(0.5, 0)
	TextLabel2.Position = UDim2.new(0.5, 0, 1, 3)
	TextLabel2.Size = UDim2.fromOffset(250, 13)
	TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel2.Font = Enum.Font.Code
	TextLabel2.TextSize = 12
	TextLabel2.ZIndex = 12
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.Text = ""
	TextLabel2.Parent = Frame

	return {
		Holder = Frame,
		BoxLines = t15,
		HealthBar = Frame2,
		HealthFill = Frame3,
		NameLabel = TextLabel,
		DistLabel = TextLabel2,
		Cham = nil
	}
end
local function v195(p15)
	local Head = p15:FindFirstChild("Head")
	local HumanoidRootPart = p15:FindFirstChild("HumanoidRootPart")

	if not Head or not HumanoidRootPart then
		return nil
	end

	local v198 = workspace.CurrentCamera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
	local v199 = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))

	if v198.Z <= 0 or v199.Z <= 0 then
		return nil
	end

	local v200 = math.abs(v199.Y - v198.Y) * 0.4

	return v198.X - v200 / 2, v198.Y, v198.X + v200 / 2, v199.Y
end
local function v201()
	local CamiloConfig2 = getgenv().CamiloConfig

	if not CamiloConfig2.ESP then
		for _, v in pairs(t14) do
			v.Holder.Visible = false

			if v.Cham then
				v.Cham.Enabled = false
			end
		end

		return
	end

	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local v209 = t14[player]

		if not v209 then
			v209 = v185(player)
			t14[player] = v209
		end

		local Character2 = player.Character
		local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
		local v213 = player ~= LocalPlayer and HumanoidRootPart2 and Humanoid and Humanoid.Health > 0

		if v213 and CamiloConfig2.ESPTeamCheck and v79(player) then
			v213 = false
		end

		local n6 = 0

		if v213 then
			n6 = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

			if CamiloConfig2.ESPMaxDistance < n6 then
				v213 = false
			end
		end

		if v213 then
			local v215, v216, v217, v218 = v195(Character2)

			if v215 then
				local v219 = math.floor(v217 - v215)
				local v220 = math.floor(v218 - v216)

				v209.Holder.Position = UDim2.fromOffset(math.floor(v215), math.floor(v216))
				v209.Holder.Size = UDim2.fromOffset(v219, v220)

				for _, boxLine in pairs(v209.BoxLines) do
					boxLine.Visible = CamiloConfig2.ESPBox

					if CamiloConfig2.ESPBox then
						boxLine.BackgroundColor3 = CamiloConfig2.ESPBoxColor
					end
				end

				v209.HealthBar.Visible = CamiloConfig2.ESPHealth

				if CamiloConfig2.ESPHealth then
					v209.HealthFill.Size = UDim2.new(1, 0, math.clamp(Humanoid.Health / math.max(1, Humanoid.MaxHealth), 0, 1), 0)
					v209.HealthFill.BackgroundColor3 = CamiloConfig2.ESPHealthColor
				end

				v209.NameLabel.Visible = CamiloConfig2.ESPName

				if CamiloConfig2.ESPName then
					v209.NameLabel.Text = player.DisplayName or player.Name
					v209.NameLabel.TextColor3 = CamiloConfig2.ESPNameColor
				end

				v209.DistLabel.Visible = CamiloConfig2.ESPDistance

				if CamiloConfig2.ESPDistance then
					v209.DistLabel.Text = string.format("[ %dm ]", math.floor(n6))
				end

				v209.Holder.Visible = true

				if CamiloConfig2.ESPChams then
					if not v209.Cham then
						v209.Cham = Instance.new("Highlight")
						v209.Cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						v209.Cham.Parent = Character2
					end

					v209.Cham.FillColor = CamiloConfig2.ESPChamsFillColor
					v209.Cham.OutlineColor = Color3.fromRGB(255, 255, 255)
					v209.Cham.Enabled = true
				elseif v209.Cham then
					v209.Cham.Enabled = false
				end
			else
				v209.Holder.Visible = false
			end
		else
			v209.Holder.Visible = false

			if v209.Cham then
				v209.Cham.Enabled = false
			end
		end
	end

	for k, v in pairs(t14) do
		if not k.Parent then
			v.Holder:Destroy()

			if v.Cham then
				v.Cham:Destroy()
			end

			t14[k] = nil
		end
	end
end

local function ESP_enable()
	getgenv().CamiloConfig.ESP = true

	if not connection then
		connection = RunService.RenderStepped:Connect(v201)
	end
end
local function ESP_disable()
	getgenv().CamiloConfig.ESP = false

	if connection then
		connection:Disconnect()
		connection = nil
	end
end

-- ===================== RAGEBOT (original) =====================
local v225 = ReplicatedStorage
local Utility
local EnumLibrary
local FighterController
local v229
local u230 = false
local n7 = 0
local n8 = 0
local u233 = false

local function v234()
	local now = tick()

	while true do
		if tick() - now < 40 then
			pcall(function()
				local Modules = v225:FindFirstChild("Modules")

				if Modules then
					Utility = Utility or require(Modules:FindFirstChild("Utility"))
					EnumLibrary = EnumLibrary or require(Modules:FindFirstChild("EnumLibrary"))
				end

				local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
				local Controllers = PlayerScripts and PlayerScripts:FindFirstChild("Controllers")

				if Controllers then
					FighterController = FighterController or require(Controllers:FindFirstChild("FighterController"))
				end
			end)

			if not Utility or not EnumLibrary or not FighterController then
				task.wait(0.25)

				continue
			end

			return true
		end

		break
	end

	local v239 = Utility and EnumLibrary and FighterController

	return v239
end
local function v240(p16)
	return Utility:EncodeCFrame(p16)
end
local function v241(p17)
	if not p17 or p17 == LocalPlayer then
		return false
	end

	if CamiloConfig.Rage.TeamCheck then
		local ok, result = pcall(function()
			return p17.Team and LocalPlayer.Team and p17.Team == LocalPlayer.Team
		end)

		if not ok or not result then
			return true
		end

		return false
	end

	return true
end
local function v244(p18)
	if p18 then
		return p18:FindFirstChild("PhysicalHitboxHead") or p18:FindFirstChild("HitboxHead") or p18:FindFirstChild("HitboxHeadSmall") or p18:FindFirstChild("Head")
	end

	return nil
end
local function v245(p19)
	return p19 and (p19:FindFirstChild("HumanoidRootPart") or p19:FindFirstChild("HRP"))
end
local function v246(p20)
	local Character = p20.Character

	if not Character then
		return false
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	return Humanoid and Humanoid.Health > 0
end
local function v249(p21)
	if not p21 then
		return true
	end

	if p21:FindFirstChildOfClass("ForceField") then
		return true
	end

	return false
end
local function v250()
	local v251 = v245(LocalPlayer.Character)

	if not v251 then
		return nil, nil, nil
	end

	local v252
	local v253
	local v254
	local n9 = 1e9

	for _, player in ipairs(Players:GetPlayers()) do
		if v241(player) and v246(player) then
			local Character = player.Character
			local v259 = v244(Character)
			local v260 = v245(Character)

			if v259 and v260 and not v249(Character) then
				local Magnitude = (v260.Position - v251.Position).Magnitude

				if Magnitude < n9 and Magnitude < 2000 then
					n9 = Magnitude
					v252 = player
					v253 = v259
					v254 = v260
				end
			end
		end
	end

	return v252, v253, v254
end
local function v262()
	local LocalFighter = FighterController and FighterController.LocalFighter

	return LocalFighter and LocalFighter.EquippedItem
end
local function v264(p22)
	pcall(function()
		if FighterController then
			if FighterController.LocalFighter then
				FighterController.LocalFighter:EquipItem(p22)
			end
		end
	end)
end
local function v265()
	local Mode = CamiloConfig.Rage.Mode

	v262()

	if Mode == "knife" or Mode == "melee" then
		v264(3)

		return v262()
	end

	local v267 = CamiloConfig.Rage.PreferredWeapon == "secondary" and 2 or 1

	v264(v267)

	local v268 = v262()

	if not v268 and CamiloConfig.Rage.SwapWhenEmpty then
		v264(v267 == 1 and 2 or 1)
		v268 = v262()
	end

	if not v268 then
		v264(3)
		v268 = v262()
	end

	return v268
end
local function v269()
	if not CamiloConfig.Rage.VoidSpam then
		return false
	end

	local now = tick()

	if n7 <= now then
		u230 = not u230
		n7 = now + (u230 and CamiloConfig.Rage.VoidHide or CamiloConfig.Rage.VoidAttack)
	end

	return u230
end
local function v271(p23)
	pcall(function()
		local v272 = v245(LocalPlayer.Character)

		if v272 then
			v272.CFrame = p23
			v272.AssemblyLinearVelocity = Vector3.zero
			v272.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end
local function v273(p24)
	local v274 = -80 - math.random() * 40

	return CFrame.new(p24.X + math.random(-8, 8), v274, p24.Z + math.random(-8, 8))
end
local function v275(p25, p26)
	local v276 = p26 or 5
	local Position = p25.Position
	local vector3 = Vector3.new(Position.X, Position.Y - v276, Position.Z)

	v271(CFrame.new(vector3))
end
local function v279(p27, p28)
	local v280 = utf8.char(0)
	local v281 = utf8.char(1)
	local v282 = utf8.char(2)
	local v283 = utf8.char(3)
	local v284 = p27 + Vector3.one * 0.01
	local cFrame = CFrame.new(math.random() * 0.1, math.random() * 0.1, math.random() * 0.1)

	return {
		[v281] = {
			[v280] = v240(p27),
			[v281] = v240(v284),
			[v282] = p28,
			[v283] = v240(cFrame)
		}
	}
end
local function v286(p29, p30)
	local StartAiming = EnumLibrary:ToEnum("StartAiming")
	local StartShooting = EnumLibrary:ToEnum("StartShooting")
	local ObjectID = p29:Get("ObjectID")
	local cFrame = CFrame.lookAt(p30.Position - p30.CFrame.LookVector * 0.5 + Vector3.new(0, 0.25, 0), p30.Position)

	if not v269() then
		v271(cFrame)
	end

	local v291 = v279(cFrame, p30)

	for i = 1, 12 do
		pcall(function()
			v229:FireServer(ObjectID, StartAiming, v291, nil)
		end)
		pcall(function()
			v229:FireServer(ObjectID, StartShooting, v291, nil)
		end)
	end
end
local function v293(p31, p32, p33)
	local StartShooting = EnumLibrary:ToEnum("StartShooting")
	local StartAiming = EnumLibrary:ToEnum("StartAiming")
	local ObjectID = p31:Get("ObjectID")
	local v297 = v245(LocalPlayer.Character)
	local Position = v297 and v297.Position

	Position = Position or p33.Position + Vector3.new(0, 3, 0)

	local cFrame = CFrame.lookAt(Position, p32.Position)

	if not v269() then
		v271(cFrame)
	elseif v269() then
		v271(v273(Position))

		return
	end

	local v300 = v279(cFrame, p32)

	pcall(function()
		v229:FireServer(ObjectID, StartAiming, v300, nil)
	end)

	for i = 1, CamiloConfig.Rage.ShootAttempts do
		pcall(function()
			v229:FireServer(ObjectID, StartShooting, v300, nil)
		end)
	end
end

local t16 = {
	start = function()
		if u233 then
			return
		end

		u233 = true
		task.spawn(function()
			while getgenv().__Rage_Loaded do
				if CamiloConfig.Rage.Enabled then
					if not Utility or not EnumLibrary or not FighterController then
						v234()
					end

					if Utility and EnumLibrary and FighterController then
						local v303, v304, v305 = v250()

						if v303 then
							if v304 then
								local v306 = v265()

								if not v306 then
									task.wait(0.1)
								elseif tick() - n8 < CamiloConfig.Rage.FireRate then
									task.wait(0.01)
								else
									n8 = tick()

									if not v269() and CamiloConfig.Rage.TeleportUnder then
										v275(v305, CamiloConfig.Rage.TeleportOffset)
									end

									if CamiloConfig.Rage.Mode == "knife" then
										v286(v306, v304)
									else
										v293(v306, v304, v305)
									end

									task.wait(CamiloConfig.Rage.FireRate)
								end

								continue
							end
						end

						if CamiloConfig.Rage.VoidSpam and v269() then
							local v307 = v245(LocalPlayer.Character)

							if v307 then
								v271(v273(v307.Position))
							end
						end

						task.wait(0.05)
					else
						task.wait(0.5)
					end
				else
					task.wait(0.15)
				end
			end
		end)
	end
}

getgenv().__Rage_Loaded = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.RightAlt then
		CamiloConfig.Rage.Enabled = not CamiloConfig.Rage.Enabled
	end
end)

-- Skin Changer (original block kept)
task.spawn(function()
	task.wait(5)
	pcall(function()
		local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
		if not PlayerScripts then return end
		local Controllers = PlayerScripts:FindFirstChild("Controllers")
		if not Controllers then return end
		local EnumLibrary2 = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("EnumLibrary"))
		if EnumLibrary2 then EnumLibrary2:WaitForEnumBuilder() end
		local CosmeticLibrary = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("CosmeticLibrary"))
		local ItemLibrary = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("ItemLibrary"))
		local PlayerDataController = require(Controllers:FindFirstChild("PlayerDataController"))
		print("[Skin Changer] Loaded successfully!")
	end)
end)

-- ===================== NEW SLS UI =====================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/SLSUiLib/refs/heads/main/Source.lua"))()

local window = library:window({
	name = "CamiloHook",
	suffix = "V1.5",
	gameInfo = "RIVALS",
	AccentColor = Color3.fromRGB(66, 133, 255),
	ConfigFolder = "CamiloHook",
})

-- Mobile toggle button
do
	local UserInputService2 = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local v456 = UserInputService2.TouchEnabled and not UserInputService2.KeyboardEnabled

	if v456 then
		local ScreenGui2 = Instance.new("ScreenGui")
		ScreenGui2.Name = "ToggleUIOverlay"
		ScreenGui2.ResetOnSpawn = false
		ScreenGui2.IgnoreGuiInset = true
		ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Global
		ScreenGui2.DisplayOrder = 99999

		if not pcall(function()
			ScreenGui2.Parent = game:GetService("CoreGui")
		end) then
			ScreenGui2.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		end

		local TextButton = Instance.new("TextButton")
		TextButton.Name = "ToggleUIButton"
		TextButton.Size = UDim2.fromOffset(120, 40)
		TextButton.Position = UDim2.fromOffset(16, 16)
		TextButton.BackgroundColor3 = Color3.fromRGB(66, 133, 255)
		TextButton.BackgroundTransparency = 0.35
		TextButton.BorderSizePixel = 0
		TextButton.Text = "Toggle UI"
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.TextSize = 15
		TextButton.Font = Enum.Font.Code
		TextButton.AutoButtonColor = false
		TextButton.Active = true
		TextButton.Draggable = true
		TextButton.ZIndex = 5
		TextButton.Parent = ScreenGui2

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = TextButton

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Transparency = 0.6
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = TextButton

		local function v461(p71)
			TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
				BackgroundTransparency = p71
			}):Play()
		end
		local function toggleEnabled()
			if library and library.toggle then
				library:toggle()
			end
		end

		TextButton.MouseButton1Click:Connect(toggleEnabled)
		TextButton.TouchTap:Connect(toggleEnabled)
		TextButton.MouseButton1Down:Connect(function()
			v461(0.6)
		end)
		TextButton.MouseButton1Up:Connect(function()
			v461(0.35)
		end)
	end
end

window:seperator({ name = "Home" })
window:home_manager({ name = "Home" })

-- ===================== COMBAT =====================
window:seperator({ name = "Combat" })
local combat_page = window:tab({ name = "Combat", icon = "crosshair", tabs = { "Aimbot", "Silent", "Trigger" } })

-- Aimbot
do
	local col = combat_page:column({})
	local sec = col:section({ name = "Aimbot", icon = "crosshair", default = true })

	sec:toggle({
		name = "Enable Aimbot",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.Aimbot = v
			if v then t10.enable() else t10.disable() end
		end
	})
	sec:dropdown({
		name = "Activation",
		items = { "Always", "MB2", "MB1", "C", "E", "F", "Q", "V", "X", "LeftShift", "LeftAlt", "LeftControl" },
		default = "Always",
		seperator = true,
		callback = function(v) CamiloConfig.AimbotKey = v end
	})
	sec:slider({
		name = "FOV (deg)",
		min = 1, max = 180, interval = 1, default = 20,
		seperator = true,
		callback = function(v) CamiloConfig.AimbotFOVDeg = v end
	})
	sec:dropdown({
		name = "Target Bone",
		items = { "Head", "Torso" },
		default = "Head",
		seperator = true,
		callback = function(v) CamiloConfig.AimbotTargetPart = v end
	})
	sec:slider({
		name = "Smoothness (0=hard)",
		min = 0, max = 100, interval = 1, default = 0,
		seperator = true,
		callback = function(v) CamiloConfig.AimbotSmoothness = v end
	})
	sec:toggle({
		name = "Visibility Check",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.AimbotVisCheck = v end
	})
end

-- Silent Aim
do
	local col = combat_page:column({})
	local sec = col:section({ name = "Silent Aim", icon = "crosshair", default = true })

	sec:toggle({
		name = "Enable Silent Aim",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.SilentAim = v end
	})
	sec:slider({
		name = "FOV Radius",
		min = 20, max = 2000, interval = 10, default = 250,
		seperator = true,
		callback = function(v) CamiloConfig.SilentAimFOV = v end
	})
	sec:dropdown({
		name = "Target Bone",
		items = { "Head", "Torso" },
		default = "Head",
		seperator = true,
		callback = function(v) CamiloConfig.SilentAimTargetPart = v end
	})
	sec:toggle({
		name = "Visibility Check",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.SilentAimVisCheck = v end
	})
	sec:toggle({
		name = "Predictive Lead",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.PredictiveLead = v end
	})
end

-- Triggerbot
do
	local col = combat_page:column({})
	local sec = col:section({ name = "Triggerbot", icon = "crosshair", default = true })

	sec:toggle({
		name = "Enable Triggerbot",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.Trigger = v
			if v then t12.enable() else t12.disable() end
		end
	})
	sec:dropdown({
		name = "Activation",
		items = { "Always", "MB2", "MB1", "C", "E", "F", "Q", "V", "X", "LeftShift", "LeftAlt", "LeftControl" },
		default = "Always",
		seperator = true,
		callback = function(v) CamiloConfig.TriggerKey = v end
	})
	sec:toggle({
		name = "Head Only",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.TriggerHeadOnly = v end
	})
	sec:slider({
		name = "Max Distance",
		min = 50, max = 400, interval = 10, default = 400, suffix = " studs",
		seperator = true,
		callback = function(v) CamiloConfig.TriggerMaxDist = v end
	})
end

-- ===================== RAGE =====================
window:seperator({ name = "Rage" })
local rage_page = window:tab({ name = "Rage", icon = "flame", tabs = { "Ragebot" } })

do
	local col = rage_page:column({})
	local sec = col:section({ name = "Ragebot", icon = "flame", default = true })

	sec:toggle({
		name = "Enable Ragebot",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.Rage.Enabled = v
			if v then t16.start() end
		end
	})
	sec:dropdown({
		name = "Mode",
		items = { "gun", "knife", "melee" },
		default = "gun",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.Mode = v end
	})
	sec:dropdown({
		name = "Preferred Weapon",
		items = { "primary", "secondary" },
		default = "primary",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.PreferredWeapon = v end
	})
	sec:toggle({
		name = "Void Spam",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidSpam = v end
	})
	sec:slider({
		name = "Void Hide Time",
		min = 0.05, max = 1, interval = 0.05, default = 0.25, suffix = "s",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidHide = v end
	})
	sec:slider({
		name = "Void Attack Time",
		min = 0.05, max = 1, interval = 0.05, default = 0.1, suffix = "s",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidAttack = v end
	})
	sec:slider({
		name = "Shoot Attempts",
		min = 1, max = 4, interval = 1, default = 2, suffix = "x",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.ShootAttempts = v end
	})
	sec:toggle({
		name = "Swap When Empty",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.Rage.SwapWhenEmpty = v end
	})
	sec:slider({
		name = "Fire Rate",
		min = 0.001, max = 0.1, interval = 0.001, default = 0.008, suffix = "s",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.FireRate = v end
	})
	sec:toggle({
		name = "Team Check",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.Rage.TeamCheck = v end
	})
	sec:toggle({
		name = "Teleport Under Target",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.Rage.TeleportUnder = v end
	})
	sec:slider({
		name = "Teleport Offset",
		min = 1, max = 20, interval = 1, default = 5, suffix = " studs",
		seperator = true,
		callback = function(v) CamiloConfig.Rage.TeleportOffset = v end
	})
	sec:label({
		name = "Keybind",
		info = "RightAlt to toggle Ragebot"
	})
end

-- ===================== ESP & UNDERGROUND =====================
window:seperator({ name = "Visuals" })
local visuals_page = window:tab({ name = "ESP & UG", icon = "scan-eye", tabs = { "ESP", "Underground" } })

-- ESP
do
	local col = visuals_page:column({})
	local sec = col:section({ name = "ESP", icon = "scan-eye", default = true })

	sec:toggle({
		name = "Enable ESP",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.ESP = v
			if v then ESP_enable() else ESP_disable() end
		end
	})
	sec:toggle({
		name = "Team Check",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.ESPTeamCheck = v end
	})
	sec:slider({
		name = "Max Distance",
		min = 50, max = 2000, interval = 50, default = 1200, suffix = " studs",
		seperator = true,
		callback = function(v) CamiloConfig.ESPMaxDistance = v end
	})
	sec:toggle({
		name = "Boxes",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.ESPBox = v end
	})
	sec:toggle({
		name = "Names",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.ESPName = v end
	})
	sec:toggle({
		name = "Distance",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.ESPDistance = v end
	})
	sec:toggle({
		name = "Health Bar",
		default = true,
		seperator = true,
		callback = function(v) CamiloConfig.ESPHealth = v end
	})
	sec:toggle({
		name = "Chams",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.ESPChams = v end
	})
end

-- Fake Underground
do
	local col = visuals_page:column({})
	local sec = col:section({ name = "Fake Underground", icon = "layers", default = true })

	sec:toggle({
		name = "Enable Underground",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.FakeUnderground = v
			if v then v169() else v167() end
		end
	})
	sec:slider({
		name = "Depth",
		min = 0, max = 150, interval = 0.1, default = 5.8, suffix = " studs",
		seperator = true,
		callback = function(v) t13.depth = v end
	})
	sec:toggle({
		name = "Walk Mode",
		default = true,
		seperator = true,
		callback = function(v) t13.walk = v end
	})
	sec:toggle({
		name = "Auto Noclip",
		default = true,
		seperator = true,
		callback = function(v) t13.noclip = v end
	})
	sec:toggle({
		name = "Hide Character",
		default = true,
		seperator = true,
		callback = function(v)
			t13.hide = v
			if t13.on then
				if v then v160() else v164() end
			end
		end
	})
	sec:toggle({
		name = "Panic Jitter",
		default = false,
		seperator = true,
		callback = function(v) t13.panic = v end
	})
end

-- ===================== MOVEMENT =====================
window:seperator({ name = "Movement" })
local move_page = window:tab({ name = "Movement", icon = "zap", tabs = { "Movement" } })

do
	local col = move_page:column({})
	local sec = col:section({ name = "Movement", icon = "zap", default = true })

	sec:toggle({
		name = "Flight",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Movement.FlightEnabled = v end
	})
	sec:slider({
		name = "Flight Speed",
		min = 25, max = 500, interval = 5, default = 100, suffix = " studs/s",
		seperator = true,
		callback = function(v) CamiloConfig.Movement.FlightSpeed = v end
	})
	sec:toggle({
		name = "Speed Hack",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Movement.SpeedHack = v end
	})
	sec:slider({
		name = "WalkSpeed",
		min = 16, max = 250, interval = 1, default = 16, suffix = " ws",
		seperator = true,
		callback = function(v) CamiloConfig.Movement.SpeedValue = v end
	})
	sec:toggle({
		name = "Spinbot",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Movement.Spinbot = v end
	})
	sec:slider({
		name = "Spinbot Speed",
		min = 1, max = 100, interval = 1, default = 10, suffix = " spd",
		seperator = true,
		callback = function(v) CamiloConfig.Movement.SpinbotSpeed = v end
	})
	sec:toggle({
		name = "Infinite Jump",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Movement.InfiniteJump = v end
	})
	sec:toggle({
		name = "Auto BHop",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Movement.BHop = v end
	})
end

-- ===================== EXTRA VISUALS =====================
window:seperator({ name = "Extra Visuals" })
local extra_vis = window:tab({ name = "Extra", icon = "eye", tabs = { "Visuals" } })

do
	local col = extra_vis:column({})
	local sec = col:section({ name = "Visuals", icon = "eye", default = true })

	sec:toggle({
		name = "Fullbright",
		default = false,
		seperator = true,
		callback = function(v)
			CamiloConfig.Visuals.Fullbright = v
			if v then
				Lighting.Brightness = 2
				Lighting.ClockTime = 14
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
				Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			else
				Lighting.Brightness = 1
				Lighting.ClockTime = 14
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = true
				Lighting.Ambient = Color3.fromRGB(128, 128, 128)
			end
		end
	})
	sec:toggle({
		name = "Custom Camera FOV",
		default = false,
		seperator = true,
		callback = function(v) CamiloConfig.Visuals.CameraFOVEnabled = v end
	})
	sec:slider({
		name = "Camera FOV",
		min = 60, max = 130, interval = 1, default = 90, suffix = " deg",
		seperator = true,
		callback = function(v) CamiloConfig.Visuals.CameraFOV = v end
	})
end

-- ===================== MISC =====================
window:seperator({ name = "Misc" })
local misc_page = window:tab({ name = "Misc", icon = "settings", tabs = { "Misc", "Animations", "Settings" } })

do
	local col = misc_page:column({})
	local sec = col:section({ name = "Misc", icon = "settings", default = true })

	sec:button({
		name = "Reset Character",
		callback = function()
			local Character = LocalPlayer.Character
			if Character then Character:BreakJoints() end
		end
	})
	sec:button({
		name = "Server Rejoin",
		callback = function()
			pcall(function()
				game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
			end)
		end
	})
	sec:button({
		name = "Server Hop",
		callback = function()
			pcall(function()
				local TeleportService = game:GetService("TeleportService")
				for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
						break
					end
				end
			end)
		end
	})
end

-- Animation Player
do
	local col = misc_page:column({})
	local sec = col:section({ name = "Animation Player", icon = "music", default = true })

	local u485, n10, u487, ID = nil, 1, false, nil
	local t24 = {
		{ Name = "None", ID = nil },
		{ Name = "Solar System", ID = 102820461604639 }
	}

	local function v490(p125)
		if u485 and u487 then
			pcall(function() u485:Stop() end)
			u485 = nil
			u487 = false
		end
		if not p125 then return end
		local Character = LocalPlayer.Character
		if not Character then return end
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if not Humanoid then return end
		local Animator = Humanoid:FindFirstChildOfClass("Animator")
		if not Animator then
			Animator = Instance.new("Animator")
			Animator.Parent = Humanoid
		end
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://" .. p125
		local ok, result = pcall(function() return Animator:LoadAnimation(Animation) end)
		if ok and result then
			u485 = result
			result:AdjustSpeed(n10)
			result:Play()
			u487 = true
		end
	end

	sec:dropdown({
		name = "Select Animation",
		items = { "None", "Solar System" },
		default = "None",
		seperator = true,
		callback = function(p126)
			for _, v in ipairs(t24) do
				if v.Name == p126 then
					ID = v.ID
					v490(v.ID)
					break
				end
			end
		end
	})
	sec:slider({
		name = "Animation Speed",
		min = 0.1, max = 10, interval = 0.1, default = 1, suffix = "x",
		seperator = true,
		callback = function(p127)
			n10 = p127
			if u485 and u487 then
				pcall(function() u485:AdjustSpeed(n10) end)
			end
		end
	})

	LocalPlayer.CharacterAdded:Connect(function()
		if u487 and ID then
			task.wait(1)
			v490(ID)
		end
	end)
end

-- Settings
do
	local col = misc_page:column({})
	local sec = col:section({ name = "Settings", icon = "sliders", default = true })

	sec:colorpicker({
		name = "UI Color",
		color = CamiloConfig.Misc.UIColor,
		seperator = true,
		callback = function(p128)
			CamiloConfig.Misc.UIColor = p128
		end
	})
end

-- ===================== HEARTBEAT / RENDER LOOPS =====================
RunService.Heartbeat:Connect(function()
	local CamiloConfig2 = getgenv().CamiloConfig

	if not CamiloConfig2.Movement.FlightEnabled and not CamiloConfig2.Movement.SpeedHack then
		if not CamiloConfig2.Movement.Spinbot then
			return
		end
	end

	local Character = LocalPlayer.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local CurrentCamera = workspace.CurrentCamera

		if CamiloConfig2.Movement.FlightEnabled and not CamiloConfig2.Rage.Enabled and not t13.on and HumanoidRootPart and Humanoid and CurrentCamera and Humanoid.Health > 0 then
			local vector3 = Vector3.zero

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				vector3 += CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				vector3 -= CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				vector3 -= CurrentCamera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				vector3 += CurrentCamera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				vector3 += Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				vector3 -= Vector3.new(0, 1, 0)
			end

			if vector3.Magnitude > 0.02 then
				HumanoidRootPart.AssemblyLinearVelocity = vector3.Unit * CamiloConfig2.Movement.FlightSpeed
			else
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			end
		elseif HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
			if CamiloConfig2.Movement.SpeedHack and not CamiloConfig2.Rage.Enabled and not t13.on then
				Humanoid.WalkSpeed = CamiloConfig2.Movement.SpeedValue
			end

			if CamiloConfig2.Movement.Spinbot then
				if not CamiloConfig2.Rage.Enabled then
					if not t13.on then
						HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(CamiloConfig2.Movement.SpinbotSpeed), 0)
					end
				end
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if CamiloConfig.Movement.InfiniteJump and LocalPlayer.Character then
		if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

RunService.Stepped:Connect(function()
	if CamiloConfig.Movement.BHop and LocalPlayer.Character then
		if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

			if Humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if CamiloConfig.Visuals.CameraFOVEnabled then
		workspace.CurrentCamera.FieldOfView = CamiloConfig.Visuals.CameraFOV
	else
		workspace.CurrentCamera.FieldOfView = 90
	end
end)

-- ===================== INIT =====================
library:init_config(window)

library:notify({
	name = "CamiloHook V1.5",
	info = "Loaded successfully!",
	duration = 4,
	icon = "check"
})

print("[CamiloHook V1.5] Loaded successfully with SLS UI!")
print("[Ragebot] RightAlt to toggle | Mode: gun | knife | melee")
