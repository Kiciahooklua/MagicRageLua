-- discord.gg/syncrypt
-- UI ported to Sfix UI library

local LoadAI = 'pandadev_revision'

local random = math and math.random or function()
	return 0
end

local function v2()
	error("[Panda] This script could not verify its runtime environment.", 0)
end

local t1 = {}

t1[#t1 + 1] = function()
	if typeof(Enum.Material.Plastic) ~= "EnumItem" then error("x") end
end
t1[#t1 + 1] = function()
	local HttpService = game:GetService("HttpService")
	local json = HttpService:JSONEncode({ p = true })
	if type(json) ~= "string" then error("x") end
	local data = HttpService:JSONDecode(json)
	if type(data) ~= "table" or data.p ~= true then error("x") end
	local v7 = HttpService:GenerateGUID(false)
	if type(v7) ~= "string" or #v7 ~= 36 or string.sub(v7, 9, 9) ~= "-" then error("x") end
end
t1[#t1 + 1] = function()
	local color3 = Color3.fromRGB(255, 0, 0)
	if typeof(color3) ~= "Color3" then error("x") end
	if math.abs(color3.R - 1) > 0.001 or color3.G ~= 0 or color3.B ~= 0 then error("x") end
end
t1[#t1 + 1] = function()
	local v9 = Vector3.new(1, 2, 3) + Vector3.new(1, 1, 1)
	if typeof(v9) ~= "Vector3" then error("x") end
	if v9.X ~= 2 or v9.Y ~= 3 or v9.Z ~= 4 then error("x") end
end
t1[#t1 + 1] = function()
	if pcall(Instance.new, "NC_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))) then error("x") end
end
t1[#t1 + 1] = function()
	if pcall(getfenv, 2147483647) then error("x") end
end
t1[#t1 + 1] = function()
	local Workspace = game:GetService("Workspace")
	if typeof(Workspace) ~= "Instance" then error("x") end
	if Workspace:IsA("Workspace") ~= true then error("x") end
	if Workspace:IsA("NC_1I55UGrQXLhg") ~= false then error("x") end
end
t1[#t1 + 1] = function()
	if not rawequal(game, workspace.Parent) then error("x") end
	if not rawequal(game:GetService("Workspace"), workspace) then error("x") end
	if not rawequal(game:GetService("Players"), game:GetService("Players")) then error("x") end
end
t1[#t1 + 1] = function()
	if type(bit32) ~= "table" then error("x") end
end
t1[#t1 + 1] = function()
	local cFrame = CFrame.new(4, 5, 6)
	if typeof(cFrame) == "CFrame" then
		local Position = cFrame.Position
		if Position.X ~= 4 or Position.Y ~= 5 or Position.Z ~= 6 then error("x") end
	else
		error("x")
	end
end
t1[#t1 + 1] = function()
	if type(bit32) ~= "table" or type(bit32.extract) ~= "function" then error("x") end
	if pcall(bit32.extract, 0, 30, 10) then error("x") end
	if pcall(bit32.extract, 0, 40, 1) then error("x") end
end
t1[#t1 + 1] = function()
	if string.format("%d-%x", 255, 255) ~= "255-ff" then error("x") end
	if ("aB"):upper() ~= "AB" then error("x") end
end
t1[#t1 + 1] = function()
	local enumItems = Enum.Material:GetEnumItems()
	if type(enumItems) ~= "table" or #enumItems < 1 then error("x") end
	if Enum.Material.Plastic.Value ~= 256 then error("x") end
	if Enum.KeyCode.A.Value ~= 97 then error("x") end
end
t1[#t1 + 1] = function()
	if type(getgenv) ~= "function" then return end
	local genv = getgenv()
	local genv2 = getgenv()
	if not (type(genv) == "table" and rawequal(genv, genv2)) then error("x") end
end
t1[#t1 + 1] = function()
	if pcall(function() return game() end) then error("x") end
	if pcall(function() for _ in game, nil, nil do end end) then error("x") end
end
t1[#t1 + 1] = function()
	if pcall(function() return game["NP_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))] end) then error("x") end
	local function v18() game.ClassName = "NC_1I55UGrQXLhg" end
	if pcall(v18) then error("x") end
	if pcall(function() return #game end) then error("x") end
end
t1[#t1 + 1] = function()
	if typeof(game) ~= "Instance" then error("x") end
end
t1[#t1 + 1] = function()
	local vector3 = Vector3.new(1, 2, 3)
	if vector3 == Vector3.new(1, 2, 3) ~= true then error("x") end
	if pcall(function() return vector3 <= vector3 end) then error("x") end
	local Magnitude = Vector3.new(3, 4, 0).Magnitude
	if type(Magnitude) == "number" then
		if Magnitude < 4.999 or Magnitude > 5.001 then error("x") end
	else
		error("x")
	end
	if tostring(vector3) ~= "1, 2, 3" then error("x") end
end
t1[#t1 + 1] = function()
	local ok, result = pcall(Instance.new, "Part")
	if not ok or typeof(result) ~= "Instance" then error("x") end
	result.Name = "P_1I55UGrQXLhg"
	if result.Name ~= "P_1I55UGrQXLhg" then error("x") end
	if pcall(function() return result.NP_1I55UGrQXLhg end) then error("x") end
	pcall(function() result:Destroy() end)
end

local v23 = false
for _, v in ipairs(t1) do
	if not pcall(v) then v23 = true end
end

local n1 = 0
local function v27(p1)
	if not pcall(p1) then n1 += 1 end
end

local t2 = {}

t2[#t2 + 1] = function()
	if type(getfenv) ~= "function" or type(setfenv) ~= "function" then error("x") end
end
t2[#t2 + 1] = function()
	if type(require) ~= "function" then return end
	if pcall(require, "NR_" .. "1I55UGrQXLhg" .. tostring(random(1, 1000000))) then error("x") end
end
t2[#t2 + 1] = function()
	local now = os.clock()
	task.wait()
	if os.clock() - now <= 0 then error("x") end
end
t2[#t2 + 1] = function()
	if type(getmetatable) ~= "function" then return end
	if getmetatable(game) ~= "The metatable is locked" then error("x") end
end
t2[#t2 + 1] = function()
	if type(debug.info) == "function" and debug.info(print, "s") ~= "[C]" then error("x") end
end
t2[#t2 + 1] = function()
	local count = collectgarbage("count")
	local t3 = {}
	for i = 1, 400 do t3[i] = { i } end
	if collectgarbage("count") <= count then error("x") end
end
t2[#t2 + 1] = function()
	if tostring(game:GetService("Workspace")) ~= "Workspace" then error("x") end
end
t2[#t2 + 1] = function()
	local loadstring_ = loadstring or load
	if type(loadstring_) ~= "function" then return end
	local function v34(p2)
		local ok, result = pcall(loadstring_, p2)
		return ok and type(result) == "function"
	end
	if not v34("local x: number = 1 x += 1 return x") then error("x") end
	if not v34("for i = 1, 2 do continue end") then error("x") end
	if v34("return 1 & 2") then error("x") end
end
t2[#t2 + 1] = function()
	if type(debug.info) ~= "function" then return end
	local n2 = 0
	if debug.info(pcall, "s") ~= "[C]" then n2 += 1 end
	if debug.info(type, "s") ~= "[C]" then n2 += 1 end
	if debug.info(typeof, "s") ~= "[C]" then n2 += 1 end
	if n2 >= 2 then error("x") end
end
t2[#t2 + 1] = function()
	local RunService = game:GetService("RunService")
	if RunService:IsClient() ~= true then error("x") end
	if RunService:IsServer() ~= false then error("x") end
end
t2[#t2 + 1] = function()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	if typeof(LocalPlayer) ~= "Instance" then error("x") end
	local UserId = LocalPlayer.UserId
	if type(UserId) ~= "number" or UserId <= 0 then error("x") end
end
t2[#t2 + 1] = function()
	local u41 = false
	local function v42(...) if select("#", ...) > 0 then u41 = true end end
	v42()
	if u41 then error("x") end
end
t2[#t2 + 1] = function()
	if type(islclosure) ~= "function" and type(isexecutorclosure) ~= "function" then return end
	local t4 = {}
	local function v44(p3) if type(p3) == "function" then t4[#t4 + 1] = p3 end end
	v44(type) v44(typeof) v44(rawequal) v44(rawget) v44(rawset)
	v44(getmetatable) v44(setmetatable) v44(pcall) v44(xpcall) v44(select)
	v44(next) v44(tostring) v44(tonumber) v44(string.sub) v44(string.byte) v44(table.concat)
	local n3 = 0
	for i = 1, #t4 do
		local ok, result = pcall(islclosure, t4[i])
		local ok2, result2 = pcall(isexecutorclosure, t4[i])
		if ok and result == true or ok2 and result2 == true then n3 += 1 end
	end
	if n3 >= 3 then error("x") end
end
t2[#t2 + 1] = function()
	local t5 = { "_HOOKOP","_BYPASS","_bypassOnReset","_ENV_DUMP","_RTYPE","CODER_CALL","CODER_NAMECALL","checkwhileend","CHECKINDEX","LuraphContinue","PenguEnvContinue","__larry_native_string_pack_raw","__larry_native_string_unpack_raw","dumperState","_25msrobloxenv","__logservice_callbacks","__heartbeat_callbacks","__log_history_buf","__print_hooked","KittyWare" }
	local t6 = {}
	if type(getgenv) == "function" then
		local ok, result = pcall(getgenv)
		if ok and type(result) == "table" then t6[#t6 + 1] = result end
	end
	t6[#t6 + 1] = _G
	for i = 1, #t6 do
		for i2 = 1, #t5 do
			local ok, result = pcall(function() return t6[i][t5[i2]] end)
			if ok and result ~= nil then error("x") end
		end
	end
end
t2[#t2 + 1] = function()
	local loadstring_ = loadstring or load
	if type(loadstring_) ~= "function" or type(iscclosure) ~= "function" then return end
	local ok, result = pcall(loadstring_, "return 1")
	if not ok or type(result) ~= "function" then return end
	if iscclosure(result) ~= false then error("x") end
end
t2[#t2 + 1] = function()
	local n4 = 0
	local conn = game:GetService("RunService").Heartbeat:Connect(function() n4 += 1 end)
	local n5 = 0
	while true do
		task.wait()
		n5 += 1
		if n4 >= 2 then break elseif n5 >= 8 then break end
	end
	conn:Disconnect()
	if n4 < 2 then error("x") end
end
t2[#t2 + 1] = function()
	local t7 = {}
	local _, result = pcall(function() error(t7) end)
	if result ~= t7 then error("x") end
end
t2[#t2 + 1] = function()
	if string.dump ~= nil then error("x") end
	if io ~= nil or package ~= nil or arg ~= nil or dofile ~= nil then error("x") end
	if type(os) == "table" and (os.getenv ~= nil or os.exit ~= nil or os.remove ~= nil) then error("x") end
end

for _, v in ipairs(t2) do v27(v) end

if v23 or n1 >= 9 then
	v2()
	return
end

-- ============================================================
-- Services and config
-- ============================================================
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting    = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

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
	SkinChanger = { Enabled = false },
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
	Misc = { UIColor = Color3.fromRGB(155, 150, 219) }
}

local CamiloConfig = getgenv().CamiloConfig

-- ============================================================
-- Core logic helpers (unchanged)
-- ============================================================
local function v79(p4)
	if p4 == LocalPlayer then return true end
	if LocalPlayer.Team ~= nil then
		if p4.Team ~= nil then return LocalPlayer.Team == p4.Team end
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
	if not hit then return true end
	local Model = hit.Instance and hit.Instance:FindFirstAncestorOfClass("Model")
	if Model then
		if Players:GetPlayerFromCharacter(Model) then return true end
	end
	return (hit.Position - p6).Magnitude < 3
end

local t8 = { "PhysicalHitboxHead", "HitboxHead", "HitboxHeadSmall", "Head" }
local t9 = { "HitboxBody", "UpperTorso", "HumanoidRootPart", "LowerTorso" }

local function v90(p7, p8)
	if not p7 then return nil end
	local v91 = p8 == "Torso" and t9 or t8
	for _, v in ipairs(v91) do
		local v94 = p7:FindFirstChild(v)
		if v94 and v94:IsA("BasePart") then return v94 end
	end
	return p7:FindFirstChild("HumanoidRootPart")
end
local function v95(p9)
	if p9 == "MB1" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end
	if p9 == "MB2" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
	if p9 == "Always" then return true end
	local v96 = Enum.KeyCode[p9]
	if v96 then return UserInputService:IsKeyDown(v96) end
	return false
end
local function v97(p10, p11)
	if not p10 or p10 == LocalPlayer then return false end
	if CamiloConfig.TeamCheck and v79(p10) then return false end
	if not v80(p10) then return false end
	local Character = p10.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return false end
	local Character2 = LocalPlayer.Character
	local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart2 and CamiloConfig.MaxDistance < (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude then return false end
	if not p11 or v83(HumanoidRootPart.Position) then return true end
	return false
end
local function v102(p12)
	local v103 = p12 or {}
	local fov = v103.fov or 90
	local checkVis = v103.checkVis or false
	local partMode = v103.partMode or "Head"
	local ViewportSize = workspace.CurrentCamera.ViewportSize
	local vector2 = Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
	local v109, v110, huge = nil, nil, math.huge
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

-- Aimbot
local t10 = { enabled = false }
local function v119()
	if not CamiloConfig.Aimbot then return end
	if not v95(CamiloConfig.AimbotKey) then return end
	local v120, v121 = v102({ fov = CamiloConfig.AimbotFOVDeg * 5, checkVis = CamiloConfig.AimbotVisCheck, partMode = CamiloConfig.AimbotTargetPart })
	if v120 and v121 then
		local v122 = workspace.CurrentCamera:WorldToScreenPoint(v121.Position)
		if v122.Z > 0 then
			local ViewportSize = workspace.CurrentCamera.ViewportSize
			local vector2 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
			local v125 = Vector2.new(v122.X, v122.Y) - vector2
			local AimbotSmoothness = CamiloConfig.AimbotSmoothness or 0
			if AimbotSmoothness > 0 then v125 *= 1 - math.min(AimbotSmoothness / 100, 0.95) end
			if mousemoverel then mousemoverel(v125.X, v125.Y) end
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

-- Silent aim hook
task.spawn(function()
	local u127 = false
	while not u127 do
		task.wait(2)
		pcall(function()
			local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
			if not PlayerScripts then return end
			local Modules = PlayerScripts:FindFirstChild("Modules")
			if not Modules then return end
			local ItemTypes = Modules:FindFirstChild("ItemTypes")
			if not ItemTypes then return end
			local Gun = require(ItemTypes:FindFirstChild("Gun"))
			if not Gun or not Gun.StartShooting then return end
			local Utility = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Utility"))
			if not Utility then return end
			if shared._LH_GunOrig then pcall(function() Gun.StartShooting = shared._LH_GunOrig end) end
			shared._LH_GunOrig = Gun.StartShooting
			Gun.StartShooting = function(p13, ...)
				local t11 = { shared._LH_GunOrig(p13, ...) }
				pcall(function()
					if not p13.ClientFighter or not p13.ClientFighter.IsLocalPlayer then return end
					local v134 = t11[3]
					if v134 then
						if typeof(v134) == "table" then
							if CamiloConfig.SilentAim then
								local Position = workspace.CurrentCamera.CFrame.Position
								local v136, v137 = v102({ fov = CamiloConfig.SilentAimFOV, checkVis = CamiloConfig.SilentAimVisCheck, partMode = CamiloConfig.SilentAimTargetPart })
								if v136 and v137 then
									local vector3 = Vector3.zero
									if CamiloConfig.PredictiveLead then
										local HRP = v136.Character and v136.Character:FindFirstChild("HumanoidRootPart")
										if HRP then
											vector3 = HRP.AssemblyLinearVelocity * ((LocalPlayer:GetNetworkPing() or 0.05) + 0.03)
											if CamiloConfig.LeadCap < vector3.Magnitude then vector3 = vector3.Unit * CamiloConfig.LeadCap end
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

-- Triggerbot
local t12 = { enabled = false }
local function v147()
	if not CamiloConfig.Trigger then return end
	if not v95(CamiloConfig.TriggerKey) then return end
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
					for _, v in ipairs(t8) do if Name == v then v155 = true break end end
					if not v155 then return end
				end
				local FC = LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):FindFirstChild("FighterController")
				if FC then pcall(function() require(FC).LocalFighter:Input("StartShooting") end) end
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

-- Fake Underground
local t13 = { on = false, depth = 5.8, walk = true, hide = true, noclip = true, panic = false, virtualCF = nil, saved = nil, hb = nil }

local function v160()
	local Character = LocalPlayer.Character
	if not Character then return end
	t13.saved = {}
	for _, descendant in ipairs(Character:GetDescendants()) do
		if not descendant:IsA("BasePart") then
			if not descendant:IsA("Decal") then continue end
		end
		t13.saved[#t13.saved + 1] = { part = descendant, t = descendant.Transparency }
		pcall(function() descendant.Transparency = 1 end)
	end
end
local function v164()
	if not t13.saved then return end
	for _, v in ipairs(t13.saved) do
		if v.part and v.part.Parent then pcall(function() v.part.Transparency = v.t end) end
	end
	t13.saved = nil
end
local function v167()
	t13.on = false
	t13.virtualCF = nil
	if t13.hb then t13.hb:Disconnect() t13.hb = nil end
	v164()
	local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if HRP then pcall(function() HRP.AssemblyLinearVelocity = Vector3.zero HRP.AssemblyAngularVelocity = Vector3.zero end) end
end
local function v169()
	t13.on = true
	local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if HRP then t13.virtualCF = HRP.CFrame end
	if t13.hide then v160() end
	t13.hb = RunService.Heartbeat:Connect(function(dt)
		if not t13.on then return end
		local Character = LocalPlayer.Character
		local HRP2 = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if not HRP2 or not Humanoid then return end
		local LookVector = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, -1)
		local cFrame = CFrame.Angles(0, math.atan2(-LookVector.X, -LookVector.Z), 0)
		if not t13.virtualCF then t13.virtualCF = CFrame.new(HRP2.Position) * cFrame end
		local Position = t13.virtualCF.Position
		if t13.walk and Humanoid.MoveDirection.Magnitude > 0 then Position += Humanoid.MoveDirection * (Humanoid.WalkSpeed * dt) end
		t13.virtualCF = CFrame.new(Position) * cFrame
		local v177 = Position - Vector3.new(0, t13.depth, 0)
		if t13.panic then v177 += Vector3.new((math.random() - 0.5) * 10, 0, (math.random() - 0.5) * 10) end
		if t13.noclip then
			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then descendant.CanCollide = false end
			end
		end
		HRP2.AssemblyLinearVelocity = Vector3.zero
		HRP2.AssemblyAngularVelocity = Vector3.zero
		HRP2.CFrame = CFrame.new(v177) * cFrame
		if t13.hide and t13.saved then
			for _, v in ipairs(t13.saved) do
				if v.part and v.part.Parent and v.part.Transparency ~= 1 then pcall(function() v.part.Transparency = 1 end) end
			end
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	if t13.on then task.wait(1) v167() v169() end
end)

-- ESP renderer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CamiloESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 5
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local t14 = {}
local espConnection

local function v185(p14)
	local Frame = Instance.new("Frame")
	Frame.Name = p14.Name
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Visible = false
	Frame.Parent = ScreenGui
	local t15 = {}
	for k, v in pairs({ Top = { Pos = UDim2.new(0,0,0,0), Size = UDim2.new(1,0,0,1) }, Right = { Pos = UDim2.new(1,-1,0,0), Size = UDim2.new(0,1,1,0) }, Bottom = { Pos = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1) }, Left = { Pos = UDim2.new(0,0,0,0), Size = UDim2.new(0,1,1,0) } }) do
		local Frame2 = Instance.new("Frame")
		Frame2.Name = "Line_" .. k
		Frame2.Position = v.Pos
		Frame2.Size = v.Size
		Frame2.BackgroundColor3 = Color3.new(1,1,1)
		Frame2.BorderSizePixel = 0
		Frame2.ZIndex = 4
		Frame2.Visible = false
		Frame2.Parent = Frame
		t15[k] = Frame2
	end
	local HBar = Instance.new("Frame")
	HBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
	HBar.BorderSizePixel = 0
	HBar.Position = UDim2.fromOffset(-5,0)
	HBar.Size = UDim2.new(0,1,1,0)
	HBar.ZIndex = 7
	HBar.Visible = false
	HBar.Parent = Frame
	local HFill = Instance.new("Frame")
	HFill.BackgroundColor3 = Color3.fromRGB(61,224,122)
	HFill.BorderSizePixel = 0
	HFill.AnchorPoint = Vector2.new(0,1)
	HFill.Position = UDim2.new(0,0,1,0)
	HFill.Size = UDim2.new(1,0,1,0)
	HFill.ZIndex = 9
	HFill.Parent = HBar
	local NameLabel = Instance.new("TextLabel")
	NameLabel.BackgroundTransparency = 1
	NameLabel.AnchorPoint = Vector2.new(0.5,1)
	NameLabel.Position = UDim2.new(0.5,0,0,-3)
	NameLabel.Size = UDim2.fromOffset(250,16)
	NameLabel.TextColor3 = Color3.new(1,1,1)
	NameLabel.Font = Enum.Font.Code
	NameLabel.TextSize = 13
	NameLabel.ZIndex = 12
	NameLabel.TextXAlignment = Enum.TextXAlignment.Center
	NameLabel.Text = ""
	NameLabel.Parent = Frame
	local DistLabel = Instance.new("TextLabel")
	DistLabel.BackgroundTransparency = 1
	DistLabel.AnchorPoint = Vector2.new(0.5,0)
	DistLabel.Position = UDim2.new(0.5,0,1,3)
	DistLabel.Size = UDim2.fromOffset(250,13)
	DistLabel.TextColor3 = Color3.fromRGB(255,255,255)
	DistLabel.Font = Enum.Font.Code
	DistLabel.TextSize = 12
	DistLabel.ZIndex = 12
	DistLabel.TextXAlignment = Enum.TextXAlignment.Center
	DistLabel.Text = ""
	DistLabel.Parent = Frame
	return { Holder = Frame, BoxLines = t15, HealthBar = HBar, HealthFill = HFill, NameLabel = NameLabel, DistLabel = DistLabel, Cham = nil }
end
local function v195(p15)
	local Head = p15:FindFirstChild("Head")
	local HRP = p15:FindFirstChild("HumanoidRootPart")
	if not Head or not HRP then return nil end
	local v198 = workspace.CurrentCamera:WorldToViewportPoint(Head.Position + Vector3.new(0,0.5,0))
	local v199 = workspace.CurrentCamera:WorldToViewportPoint(HRP.Position - Vector3.new(0,3,0))
	if v198.Z <= 0 or v199.Z <= 0 then return nil end
	local v200 = math.abs(v199.Y - v198.Y) * 0.4
	return v198.X - v200/2, v198.Y, v198.X + v200/2, v199.Y
end
local function v201()
	local CC = getgenv().CamiloConfig
	if not CC.ESP then
		for _, v in pairs(t14) do v.Holder.Visible = false if v.Cham then v.Cham.Enabled = false end end
		return
	end
	local Character = LocalPlayer.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end
	for _, player in ipairs(Players:GetPlayers()) do
		local v209 = t14[player]
		if not v209 then v209 = v185(player) t14[player] = v209 end
		local Char2 = player.Character
		local Hum = Char2 and Char2:FindFirstChildOfClass("Humanoid")
		local HRP2 = Char2 and Char2:FindFirstChild("HumanoidRootPart")
		local visible = player ~= LocalPlayer and HRP2 and Hum and Hum.Health > 0
		if visible and CC.ESPTeamCheck and v79(player) then visible = false end
		local n6 = 0
		if visible then
			n6 = (HRP2.Position - HRP.Position).Magnitude
			if CC.ESPMaxDistance < n6 then visible = false end
		end
		if visible then
			local x1,y1,x2,y2 = v195(Char2)
			if x1 then
				v209.Holder.Position = UDim2.fromOffset(math.floor(x1), math.floor(y1))
				v209.Holder.Size = UDim2.fromOffset(math.floor(x2-x1), math.floor(y2-y1))
				for _, bl in pairs(v209.BoxLines) do bl.Visible = CC.ESPBox if CC.ESPBox then bl.BackgroundColor3 = CC.ESPBoxColor end end
				v209.HealthBar.Visible = CC.ESPHealth
				if CC.ESPHealth then
					v209.HealthFill.Size = UDim2.new(1, 0, math.clamp(Hum.Health / math.max(1, Hum.MaxHealth), 0, 1), 0)
					v209.HealthFill.BackgroundColor3 = CC.ESPHealthColor
				end
				v209.NameLabel.Visible = CC.ESPName
				if CC.ESPName then v209.NameLabel.Text = player.DisplayName or player.Name v209.NameLabel.TextColor3 = CC.ESPNameColor end
				v209.DistLabel.Visible = CC.ESPDistance
				if CC.ESPDistance then v209.DistLabel.Text = string.format("[ %dm ]", math.floor(n6)) end
				v209.Holder.Visible = true
				if CC.ESPChams then
					if not v209.Cham then v209.Cham = Instance.new("Highlight") v209.Cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop v209.Cham.Parent = Char2 end
					v209.Cham.FillColor = CC.ESPChamsFillColor
					v209.Cham.OutlineColor = Color3.fromRGB(255,255,255)
					v209.Cham.Enabled = true
				elseif v209.Cham then v209.Cham.Enabled = false end
			else
				v209.Holder.Visible = false
			end
		else
			v209.Holder.Visible = false
			if v209.Cham then v209.Cham.Enabled = false end
		end
	end
	for k, v in pairs(t14) do
		if not k.Parent then
			v.Holder:Destroy()
			if v.Cham then v.Cham:Destroy() end
			t14[k] = nil
		end
	end
end

ESP_enable = function()
	getgenv().CamiloConfig.ESP = true
	if not espConnection then espConnection = RunService.RenderStepped:Connect(v201) end
end
ESP_disable = function()
	getgenv().CamiloConfig.ESP = false
	if espConnection then espConnection:Disconnect() espConnection = nil end
end

-- Ragebot
local v225 = ReplicatedStorage
local Utility, EnumLibrary, FighterController, v229
local u230 = false
local n7, n8 = 0, 0
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
				local PS = LocalPlayer:FindFirstChild("PlayerScripts")
				local Controllers = PS and PS:FindFirstChild("Controllers")
				if Controllers then FighterController = FighterController or require(Controllers:FindFirstChild("FighterController")) end
			end)
			if not Utility or not EnumLibrary or not FighterController then task.wait(0.25) continue end
			return true
		end
		break
	end
	return Utility and EnumLibrary and FighterController
end
local function v240(p16) return Utility:EncodeCFrame(p16) end
local function v241(p17)
	if not p17 or p17 == LocalPlayer then return false end
	if CamiloConfig.Rage.TeamCheck then
		local ok, result = pcall(function() return p17.Team and LocalPlayer.Team and p17.Team == LocalPlayer.Team end)
		if not ok or not result then return true end
		return false
	end
	return true
end
local function v244(p18)
	if p18 then return p18:FindFirstChild("PhysicalHitboxHead") or p18:FindFirstChild("HitboxHead") or p18:FindFirstChild("HitboxHeadSmall") or p18:FindFirstChild("Head") end
	return nil
end
local function v245(p19) return p19 and (p19:FindFirstChild("HumanoidRootPart") or p19:FindFirstChild("HRP")) end
local function v246(p20)
	local Character = p20.Character
	if not Character then return false end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	return Humanoid and Humanoid.Health > 0
end
local function v249(p21)
	if not p21 then return true end
	if p21:FindFirstChildOfClass("ForceField") then return true end
	return false
end
local function v250()
	local v251 = v245(LocalPlayer.Character)
	if not v251 then return nil, nil, nil end
	local v252, v253, v254, n9 = nil, nil, nil, 1e9
	for _, player in ipairs(Players:GetPlayers()) do
		if v241(player) and v246(player) then
			local Char = player.Character
			local v259 = v244(Char)
			local v260 = v245(Char)
			if v259 and v260 and not v249(Char) then
				local Magnitude = (v260.Position - v251.Position).Magnitude
				if Magnitude < n9 and Magnitude < 2000 then
					n9 = Magnitude v252 = player v253 = v259 v254 = v260
				end
			end
		end
	end
	return v252, v253, v254
end
local function v262()
	local LF = FighterController and FighterController.LocalFighter
	return LF and LF.EquippedItem
end
local function v264(p22) pcall(function() if FighterController and FighterController.LocalFighter then FighterController.LocalFighter:EquipItem(p22) end end) end
local function v265()
	local Mode = CamiloConfig.Rage.Mode
	v262()
	if Mode == "knife" or Mode == "melee" then v264(3) return v262() end
	local v267 = CamiloConfig.Rage.PreferredWeapon == "secondary" and 2 or 1
	v264(v267)
	local v268 = v262()
	if not v268 and CamiloConfig.Rage.SwapWhenEmpty then v264(v267 == 1 and 2 or 1) v268 = v262() end
	if not v268 then v264(3) v268 = v262() end
	return v268
end
local function v269()
	if not CamiloConfig.Rage.VoidSpam then return false end
	local now = tick()
	if n7 <= now then u230 = not u230 n7 = now + (u230 and CamiloConfig.Rage.VoidHide or CamiloConfig.Rage.VoidAttack) end
	return u230
end
local function v271(p23)
	pcall(function()
		local v272 = v245(LocalPlayer.Character)
		if v272 then v272.CFrame = p23 v272.AssemblyLinearVelocity = Vector3.zero v272.AssemblyAngularVelocity = Vector3.zero end
	end)
end
local function v273(p24)
	local v274 = -80 - math.random() * 40
	return CFrame.new(p24.X + math.random(-8,8), v274, p24.Z + math.random(-8,8))
end
local function v275(p25, p26)
	local v276 = p26 or 5
	local Position = p25.Position
	v271(CFrame.new(Vector3.new(Position.X, Position.Y - v276, Position.Z)))
end
local function v279(p27, p28)
	local c0,c1,c2,c3 = utf8.char(0),utf8.char(1),utf8.char(2),utf8.char(3)
	local v284 = p27 + Vector3.one * 0.01
	local cFrame = CFrame.new(math.random()*0.1, math.random()*0.1, math.random()*0.1)
	return { [c1] = { [c0]=v240(p27), [c1]=v240(v284), [c2]=p28, [c3]=v240(cFrame) } }
end
local function v286(p29, p30)
	local StartAiming = EnumLibrary:ToEnum("StartAiming")
	local StartShooting = EnumLibrary:ToEnum("StartShooting")
	local ObjectID = p29:Get("ObjectID")
	local cFrame = CFrame.lookAt(p30.Position - p30.CFrame.LookVector*0.5 + Vector3.new(0,0.25,0), p30.Position)
	if not v269() then v271(cFrame) end
	local v291 = v279(cFrame, p30)
	for i = 1, 12 do
		pcall(function() v229:FireServer(ObjectID, StartAiming, v291, nil) end)
		pcall(function() v229:FireServer(ObjectID, StartShooting, v291, nil) end)
	end
end
local function v293(p31, p32, p33)
	local StartShooting = EnumLibrary:ToEnum("StartShooting")
	local StartAiming = EnumLibrary:ToEnum("StartAiming")
	local ObjectID = p31:Get("ObjectID")
	local v297 = v245(LocalPlayer.Character)
	local Position = v297 and v297.Position or p33.Position + Vector3.new(0,3,0)
	local cFrame = CFrame.lookAt(Position, p32.Position)
	if not v269() then v271(cFrame)
	elseif v269() then v271(v273(Position)) return end
	local v300 = v279(cFrame, p32)
	pcall(function() v229:FireServer(ObjectID, StartAiming, v300, nil) end)
	for i = 1, CamiloConfig.Rage.ShootAttempts do
		pcall(function() v229:FireServer(ObjectID, StartShooting, v300, nil) end)
	end
end

local t16 = {
	start = function()
		if u233 then return end
		u233 = true
		task.spawn(function()
			while getgenv().__Rage_Loaded do
				if CamiloConfig.Rage.Enabled then
					if not Utility or not EnumLibrary or not FighterController then v234() end
					if Utility and EnumLibrary and FighterController then
						local v303, v304, v305 = v250()
						if v303 then
							if v304 then
								local v306 = v265()
								if not v306 then task.wait(0.1)
								elseif tick() - n8 < CamiloConfig.Rage.FireRate then task.wait(0.01)
								else
									n8 = tick()
									if not v269() and CamiloConfig.Rage.TeleportUnder then v275(v305, CamiloConfig.Rage.TeleportOffset) end
									if CamiloConfig.Rage.Mode == "knife" then v286(v306, v304) else v293(v306, v304, v305) end
									task.wait(CamiloConfig.Rage.FireRate)
								end
								continue
							end
						end
						if CamiloConfig.Rage.VoidSpam and v269() then
							local v307 = v245(LocalPlayer.Character)
							if v307 then v271(v273(v307.Position)) end
						end
						task.wait(0.05)
					else task.wait(0.5) end
				else task.wait(0.15) end
			end
		end)
	end
}

getgenv().__Rage_Loaded = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightAlt then CamiloConfig.Rage.Enabled = not CamiloConfig.Rage.Enabled end
end)

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
		local t17, t18 = {}, {}
		local u316, u317

		local function v319(p34, p35, p36)
			local v320 = CosmeticLibrary.Cosmetics[p34]
			if not v320 then return nil end
			local t19 = {}
			for k, v in pairs(v320) do t19[k] = v end
			t19.Name = p34
			t19.Type = t19.Type or p35
			t19.Seed = t19.Seed or math.random(1, 1000000)
			if EnumLibrary2 then
				local ok, enum = pcall(EnumLibrary2.ToEnum, EnumLibrary2, p34)
				if ok and enum then t19.Enum = enum t19.ObjectID = t19.ObjectID or enum end
			end
			if p36 then
				if p36.inverted ~= nil then t19.Inverted = p36.inverted end
				if p36.favoritesOnly ~= nil then t19.OnlyUseFavorites = p36.favoritesOnly end
			end
			return t19
		end
		local function v327()
			if not writefile then return end
			pcall(function()
				local t20 = { equipped = {}, favorites = t18 }
				for k, v in pairs(t17) do
					t20.equipped[k] = {}
					for k2, v3 in pairs(v) do if v3 and v3.Name then t20.equipped[k][k2] = { name=v3.Name, seed=v3.Seed, inverted=v3.Inverted } end end
				end
				makefolder("unlockall")
				writefile("unlockall/config.json", HttpService:JSONEncode(t20))
			end)
		end
		local function v333()
			if readfile and isfile and isfile("unlockall/config.json") then
				pcall(function()
					local data = HttpService:JSONDecode(readfile("unlockall/config.json"))
					local favorites
					if data.equipped then
						for k, v in pairs(data.equipped) do
							t17[k] = {}
							for k2, v3 in pairs(v) do
								local v340 = v319(v3.name, k2, { inverted = v3.inverted })
								if v340 then v340.Seed = v3.seed t17[k][k2] = v340 end
							end
						end
						favorites = data.favorites or {}
					else favorites = data.favorites or {} end
					t18 = favorites
				end)
			end
		end
		local function v341(p37, p38)
			if not p38 then return false end
			local Type = p38.Type
			if Type == "Skin" or Type == "Charm" or Type == "Dance" or Type == "Emote" or Type == "Wrap" or Type == "Wrapping" or Type == "Finisher" then return true end
			local v343 = p37:lower()
			return (v343:find("charm") or v343:find("dance") or v343:find("emote") or v343:find("wrap") or v343:find("finisher")) ~= nil
		end

		local OwnsCosmetic = CosmeticLibrary.OwnsCosmetic
		CosmeticLibrary.OwnsCosmetic = function(p39, p40, p41, p42)
			if p41:find("MISSING_") then return OwnsCosmetic(p39, p40, p41, p42) end
			if v341(p41, CosmeticLibrary.Cosmetics[p41]) then return true end
			return OwnsCosmetic(p39, p40, p41, p42)
		end
		for _, v in ipairs({ "OwnsCosmeticNormally", "OwnsCosmeticUniversally", "OwnsCosmeticForWeapon" }) do
			local v347 = CosmeticLibrary[v]
			CosmeticLibrary[v] = function(p43, p44, p45, p46)
				if type(p45) == "string" and not p45:find("MISSING_") and v341(p45, CosmeticLibrary.Cosmetics[p45]) then return true end
				if v347 then return v347(p43, p44, p45, p46) end
				return false
			end
		end

		local function v348() return type(ItemLibrary.Items)=="table" and ItemLibrary.Items or type(ItemLibrary.Weapons)=="table" and ItemLibrary.Weapons or nil end
		local function v351(p48) return { Name=p48, Level=1, XP=0, Experience=0, Kills=0 } end

		local u352, u353, u354
		local Get = PlayerDataController.Get
		PlayerDataController.Get = function(p49, p50)
			local v356 = Get(p49, p50)
			if p50 == "CosmeticInventory" then
				if u352 and u353 == v356 and os.clock() - u354 < 0.25 then return u352 end
				local t21, v358 = {}, nil
				if v356 then for k, v in pairs(v356) do if CosmeticLibrary.Cosmetics[k] then t21[k]=v end if v358==nil then v358=v end end end
				for k in pairs(CosmeticLibrary.Cosmetics) do
					if t21[k] == nil then
						if type(v358)=="number" then t21[k]=1
						elseif type(v358)=="table" then t21[k]={}
						else t21[k]=true end
					end
				end
				setmetatable(t21, { __index = function(p51,p52) if CosmeticLibrary.Cosmetics[p52] then return true end return nil end })
				u352=t21 u353=v356 u354=os.clock()
				return t21
			end
			if p50 == "FavoritedCosmetics" then
				local v363 = v356 and table.clone(v356) or {}
				for k, v in pairs(t18) do v363[k]=v363[k] or {} for k2,v3 in pairs(v) do v363[k][k2]=v3 end end
				return v363
			end
			if p50 ~= "WeaponInventory" or type(v356) ~= "table" then return v356 end
			local v368 = table.clone(v356)
			local v369 = v348()
			if v369 then for k in pairs(v369) do if type(k)=="string" and v368[k]==nil then v368[k]=v351(k) end end end
			for k, v in pairs(t17) do
				local v373 = v368[k]
				if k ~= "Dances" and type(v373)=="table" then
					local v374 = table.clone(v373)
					for k2,v3 in pairs(v) do v374[k2]=v3 end
					v368[k] = v374
				end
			end
			return v368
		end

		v333()
		print("[Skin Changer] Loaded successfully!")
	end)
end)

-- ============================================================
-- Sfix UI
-- ============================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/SfixUiLib/refs/heads/main/Source.lua"))()

local window = library:window({
	name = "CamiloHook",
	suffix = "V1.5",
	gameInfo = "RIVALS",
	AccentColor = Color3.fromRGB(155, 150, 219),
	ConfigFolder = "CamiloHook",
})

-- ============================================================
-- Combat separator
-- ============================================================
window:seperator({ name = "Combat" })

do
	local aimbot_col, silent_col, trigger_col = window:tab({
		name = "Combat",
		icon = "crosshair",
		tabs = { "Aimbot", "Silent Aim", "Triggerbot" }
	})

	-- Aimbot
	local ab_sec = aimbot_col:column({}):section({ name = "Aimbot", icon = "crosshair", default = true })

	local ab_toggle = ab_sec:toggle({
		name = "Enable Aimbot",
		default = false,
		seperator = true,
		callback = function(p)
			CamiloConfig.Aimbot = p
			if p then t10.enable() else t10.disable() end
		end
	})
	local ab_opts = ab_toggle:group({})
	ab_opts:dropdown({
		name = "Activation",
		items = { "Always", "MB2", "MB1", "C", "E", "F", "Q", "V", "X", "LeftShift", "LeftAlt", "LeftControl" },
		default = "Always",
		seperator = true,
		callback = function(v) CamiloConfig.AimbotKey = v end
	})
	ab_opts:slider({
		name = "FOV (deg)",
		min = 1, max = 180, default = 20,
		suffix = "°", seperator = true,
		callback = function(v) CamiloConfig.AimbotFOVDeg = v end
	})
	ab_opts:dropdown({
		name = "Target Bone",
		items = { "Head", "Torso" },
		default = "Head",
		seperator = true,
		callback = function(v) CamiloConfig.AimbotTargetPart = v end
	})
	ab_opts:slider({
		name = "Smoothness (0=hard)",
		min = 0, max = 100, default = 0,
		suffix = "%", seperator = true,
		callback = function(v) CamiloConfig.AimbotSmoothness = v end
	})
	ab_opts:toggle({
		name = "Visibility Check",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.AimbotVisCheck = v end
	})
	ab_opts:toggle({
		name = "Team Check",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.TeamCheck = v end
	})
	ab_opts:slider({
		name = "Max Distance",
		min = 50, max = 2000, default = 1200,
		suffix = " studs", seperator = true,
		callback = function(v) CamiloConfig.MaxDistance = v end
	})

	-- Silent Aim
	local sa_sec = silent_col:column({}):section({ name = "Silent Aim", icon = "eye", default = true })

	local sa_toggle = sa_sec:toggle({
		name = "Enable Silent Aim",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.SilentAim = v end
	})
	local sa_opts = sa_toggle:group({})
	sa_opts:slider({
		name = "FOV Radius",
		min = 20, max = 2000, default = 250,
		seperator = true,
		callback = function(v) CamiloConfig.SilentAimFOV = v end
	})
	sa_opts:dropdown({
		name = "Target Bone",
		items = { "Head", "Torso" },
		default = "Head", seperator = true,
		callback = function(v) CamiloConfig.SilentAimTargetPart = v end
	})
	sa_opts:toggle({
		name = "Visibility Check",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.SilentAimVisCheck = v end
	})
	sa_opts:toggle({
		name = "Predictive Lead",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.PredictiveLead = v end
	})

	-- Triggerbot
	local tb_sec = trigger_col:column({}):section({ name = "Triggerbot", icon = "zap", default = true })

	local tb_toggle = tb_sec:toggle({
		name = "Enable Triggerbot",
		default = false, seperator = true,
		callback = function(p)
			CamiloConfig.Trigger = p
			if p then t12.enable() else t12.disable() end
		end
	})
	local tb_opts = tb_toggle:group({})
	tb_opts:dropdown({
		name = "Activation",
		items = { "Always", "MB2", "MB1", "C", "E", "F", "Q", "V", "X", "LeftShift", "LeftAlt", "LeftControl" },
		default = "Always", seperator = true,
		callback = function(v) CamiloConfig.TriggerKey = v end
	})
	tb_opts:toggle({
		name = "Head Only",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.TriggerHeadOnly = v end
	})
	tb_opts:slider({
		name = "Max Distance",
		min = 50, max = 400, default = 400,
		suffix = " studs", seperator = true,
		callback = function(v) CamiloConfig.TriggerMaxDist = v end
	})
end

-- ============================================================
-- Rage separator
-- ============================================================
window:seperator({ name = "Rage" })

do
	local rage_tab = window:tab({
		name = "Rage",
		icon = "flame",
		tabs = { "Ragebot" }
	})
	local rage_sec = rage_tab:column({}):section({ name = "Ragebot", icon = "flame", default = true })

	local rage_toggle = rage_sec:toggle({
		name = "Enable Ragebot",
		default = false, seperator = true,
		callback = function(p)
			CamiloConfig.Rage.Enabled = p
			if p then t16.start() end
		end
	})
	local r = rage_toggle:group({})
	r:dropdown({
		name = "Mode",
		items = { "gun", "knife", "melee" },
		default = "gun", seperator = true,
		callback = function(v) CamiloConfig.Rage.Mode = v end
	})
	r:dropdown({
		name = "Preferred Weapon",
		items = { "primary", "secondary" },
		default = "primary", seperator = true,
		callback = function(v) CamiloConfig.Rage.PreferredWeapon = v end
	})
	r:toggle({
		name = "Void Spam",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidSpam = v end
	})
	r:slider({
		name = "Void Hide Time",
		min = 0.05, max = 1, default = 0.25,
		suffix = "s", seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidHide = v end
	})
	r:slider({
		name = "Void Attack Time",
		min = 0.05, max = 1, default = 0.1,
		suffix = "s", seperator = true,
		callback = function(v) CamiloConfig.Rage.VoidAttack = v end
	})
	r:slider({
		name = "Shoot Attempts",
		min = 1, max = 4, default = 2,
		suffix = "x", seperator = true,
		callback = function(v) CamiloConfig.Rage.ShootAttempts = v end
	})
	r:toggle({
		name = "Swap When Empty",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.Rage.SwapWhenEmpty = v end
	})
	r:slider({
		name = "Fire Rate",
		min = 0.001, max = 0.1, default = 0.008,
		suffix = "s", seperator = true,
		callback = function(v) CamiloConfig.Rage.FireRate = v end
	})
	r:toggle({
		name = "Team Check",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.Rage.TeamCheck = v end
	})
	r:toggle({
		name = "Teleport Under Target",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.Rage.TeleportUnder = v end
	})
	r:slider({
		name = "Teleport Offset",
		min = 1, max = 20, default = 5,
		suffix = " studs", seperator = true,
		callback = function(v) CamiloConfig.Rage.TeleportOffset = v end
	})
	rage_sec:label({ name = "Keybind: RightAlt to toggle ragebot" })
end

-- ============================================================
-- ESP & Underground separator
-- ============================================================
window:seperator({ name = "ESP & UG" })

do
	local esp_tab, ug_tab = window:tab({
		name = "ESP & UG",
		icon = "scan-eye",
		tabs = { "ESP", "Underground" }
	})

	-- ESP
	local esp_sec = esp_tab:column({}):section({ name = "ESP", icon = "scan-eye", default = true })

	local esp_toggle = esp_sec:toggle({
		name = "Enable ESP",
		default = false, seperator = true,
		callback = function(p)
			CamiloConfig.ESP = p
			if p then ESP_enable() else ESP_disable() end
		end
	})
	local e = esp_toggle:group({})
	e:toggle({
		name = "Team Check",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.ESPTeamCheck = v end
	})
	e:slider({
		name = "Max Distance",
		min = 50, max = 2000, default = 1200,
		suffix = " studs", seperator = true,
		callback = function(v) CamiloConfig.ESPMaxDistance = v end
	})
	e:toggle({
		name = "Boxes",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.ESPBox = v end
	}):colorpicker({ color = Color3.fromRGB(255,255,255), callback = function(c) CamiloConfig.ESPBoxColor = c end })
	e:toggle({
		name = "Names",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.ESPName = v end
	}):colorpicker({ color = Color3.fromRGB(255,255,255), callback = function(c) CamiloConfig.ESPNameColor = c end })
	e:toggle({
		name = "Distance",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.ESPDistance = v end
	})
	e:toggle({
		name = "Health Bar",
		default = true, seperator = true,
		callback = function(v) CamiloConfig.ESPHealth = v end
	}):colorpicker({ color = Color3.fromRGB(61,224,122), callback = function(c) CamiloConfig.ESPHealthColor = c end })
	e:toggle({
		name = "Chams",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.ESPChams = v end
	}):colorpicker({ color = Color3.fromRGB(255,59,78), callback = function(c) CamiloConfig.ESPChamsFillColor = c end })

	-- Underground
	local ug_sec = ug_tab:column({}):section({ name = "Fake Underground", icon = "arrow-down", default = true })

	local ug_toggle = ug_sec:toggle({
		name = "Enable Underground",
		default = false, seperator = true,
		callback = function(p)
			CamiloConfig.FakeUnderground = p
			if p then v169() else v167() end
		end
	})
	local u = ug_toggle:group({})
	u:slider({
		name = "Depth",
		min = 0, max = 150, default = 5.8,
		suffix = " studs", seperator = true,
		callback = function(v) t13.depth = v end
	})
	u:toggle({
		name = "Walk Mode",
		default = true, seperator = true,
		callback = function(v) t13.walk = v end
	})
	u:toggle({
		name = "Auto Noclip",
		default = true, seperator = true,
		callback = function(v) t13.noclip = v end
	})
	u:toggle({
		name = "Hide Character",
		default = true, seperator = true,
		callback = function(p)
			t13.hide = p
			if t13.on then if p then v160() else v164() end end
		end
	})
	u:toggle({
		name = "Panic Jitter",
		default = false, seperator = true,
		callback = function(v) t13.panic = v end
	})
end

-- ============================================================
-- Skins separator
-- ============================================================
window:seperator({ name = "Skins" })

do
	local skins_tab = window:tab({
		name = "Skins",
		icon = "package",
		tabs = { "Skin Changer" }
	})
	local sk_sec = skins_tab:column({}):section({ name = "Skin Changer", icon = "package", default = true })
	sk_sec:toggle({
		name = "Enable Skin Changer",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.SkinChanger.Enabled = v end
	})
	sk_sec:label({ name = "Equip any skin in the game and it will be applied to all weapons." })
end

-- ============================================================
-- Movement separator
-- ============================================================
window:seperator({ name = "Movement" })

do
	local mov_tab = window:tab({
		name = "Movement",
		icon = "zap",
		tabs = { "Movement" }
	})
	local mov_sec = mov_tab:column({}):section({ name = "Movement", icon = "zap", default = true })

	mov_sec:toggle({
		name = "Flight",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Movement.FlightEnabled = v end
	})
	mov_sec:slider({
		name = "Flight Speed",
		min = 25, max = 500, default = 100,
		suffix = " studs/s", seperator = true,
		callback = function(v) CamiloConfig.Movement.FlightSpeed = v end
	})
	mov_sec:toggle({
		name = "Speed Hack",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Movement.SpeedHack = v end
	})
	mov_sec:slider({
		name = "WalkSpeed",
		min = 16, max = 250, default = 16,
		suffix = " ws", seperator = true,
		callback = function(v) CamiloConfig.Movement.SpeedValue = v end
	})
	mov_sec:toggle({
		name = "Spinbot",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Movement.Spinbot = v end
	})
	mov_sec:slider({
		name = "Spinbot Speed",
		min = 1, max = 100, default = 10,
		suffix = " spd", seperator = true,
		callback = function(v) CamiloConfig.Movement.SpinbotSpeed = v end
	})
	mov_sec:toggle({
		name = "Infinite Jump",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Movement.InfiniteJump = v end
	})
	mov_sec:toggle({
		name = "Auto BHop",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Movement.BHop = v end
	})
end

-- ============================================================
-- Visuals separator
-- ============================================================
window:seperator({ name = "Visuals" })

do
	local vis_tab = window:tab({
		name = "Visuals",
		icon = "eye",
		tabs = { "Visuals" }
	})
	local vis_sec = vis_tab:column({}):section({ name = "Visuals", icon = "eye", default = true })

	vis_sec:toggle({
		name = "Fullbright",
		default = false, seperator = true,
		callback = function(p)
			CamiloConfig.Visuals.Fullbright = p
			if p then
				Lighting.Brightness = 2
				Lighting.ClockTime = 14
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
				Lighting.Ambient = Color3.fromRGB(255,255,255)
			else
				Lighting.Brightness = 1
				Lighting.ClockTime = 14
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = true
				Lighting.Ambient = Color3.fromRGB(128,128,128)
			end
		end
	})
	vis_sec:toggle({
		name = "Custom Camera FOV",
		default = false, seperator = true,
		callback = function(v) CamiloConfig.Visuals.CameraFOVEnabled = v end
	})
	vis_sec:slider({
		name = "Camera FOV",
		min = 60, max = 130, default = 90,
		suffix = " deg", seperator = true,
		callback = function(v) CamiloConfig.Visuals.CameraFOV = v end
	})
end

-- ============================================================
-- Misc separator
-- ============================================================
window:seperator({ name = "Misc" })

do
	local misc_tab, anim_tab, settings_tab = window:tab({
		name = "Misc",
		icon = "settings",
		tabs = { "Misc", "Animations", "Settings" }
	})

	-- Misc
	local misc_sec = misc_tab:column({}):section({ name = "Misc", icon = "settings", default = true })
	misc_sec:button({
		name = "Reset Character",
		callback = function()
			local Character = LocalPlayer.Character
			if Character then Character:BreakJoints() end
		end
	})
	misc_sec:button({
		name = "Server Rejoin",
		callback = function()
			pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
		end
	})
	misc_sec:button({
		name = "Server Hop",
		callback = function()
			pcall(function()
				local TeleportService = game:GetService("TeleportService")
				for _, v in ipairs(HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
						break
					end
				end
			end)
		end
	})

	-- Animations
	local anim_sec = anim_tab:column({}):section({ name = "Animation Player", icon = "play", default = true })

	local u485, n10, u487, AnimID = nil, 1, false, nil
	local t24 = { { Name = "None", ID = nil }, { Name = "Solar System", ID = 102820461604639 } }

	local function v490(p125)
		if u485 and u487 then pcall(function() u485:Stop() end) u485 = nil u487 = false end
		if not p125 then return end
		local Character = LocalPlayer.Character
		if not Character then return end
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if not Humanoid then return end
		local Animator = Humanoid:FindFirstChildOfClass("Animator")
		if not Animator then Animator = Instance.new("Animator") Animator.Parent = Humanoid end
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://" .. p125
		local ok, result = pcall(function() return Animator:LoadAnimation(Animation) end)
		if ok and result then u485 = result result:AdjustSpeed(n10) result:Play() u487 = true end
	end

	anim_sec:dropdown({
		name = "Select Animation",
		items = { "None", "Solar System" },
		default = "None", seperator = true,
		callback = function(p)
			for _, v in ipairs(t24) do
				if v.Name == p then AnimID = v.ID v490(v.ID) break end
			end
		end
	})
	anim_sec:slider({
		name = "Animation Speed",
		min = 0.1, max = 10, default = 1,
		suffix = "x", seperator = true,
		callback = function(p)
			n10 = p
			if u485 and u487 then pcall(function() u485:AdjustSpeed(n10) end) end
		end
	})
	LocalPlayer.CharacterAdded:Connect(function()
		if u487 and AnimID then task.wait(1) v490(AnimID) end
	end)

	-- Settings
	local settings_sec = settings_tab:column({}):section({ name = "Settings", icon = "settings", default = true })
	settings_sec:colorpicker({
		name = "UI Accent Color",
		color = Color3.fromRGB(155, 150, 219),
		callback = function(c) CamiloConfig.Misc.UIColor = c end
	})
	settings_sec:button({
		name = "Test Notification",
		callback = function()
			library:notify({ name = "CamiloHook", info = "Test notification", duration = 3, icon = "check" })
		end
	})
end

-- ============================================================
-- Runtime loops (unchanged)
-- ============================================================
RunService.Heartbeat:Connect(function()
	local CC = getgenv().CamiloConfig
	if not CC.Movement.FlightEnabled and not CC.Movement.SpeedHack and not CC.Movement.Spinbot then return end
	local Character = LocalPlayer.Character
	if Character then
		local HRP = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local CurrentCamera = workspace.CurrentCamera
		if CC.Movement.FlightEnabled and not CC.Rage.Enabled and not t13.on and HRP and Humanoid and CurrentCamera and Humanoid.Health > 0 then
			local vector3 = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then vector3 += CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then vector3 -= CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then vector3 -= CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then vector3 += CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vector3 += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vector3 -= Vector3.new(0,1,0) end
			if vector3.Magnitude > 0.02 then HRP.AssemblyLinearVelocity = vector3.Unit * CC.Movement.FlightSpeed
			else HRP.AssemblyLinearVelocity = Vector3.zero end
		elseif HRP and Humanoid and Humanoid.Health > 0 then
			if CC.Movement.SpeedHack and not CC.Rage.Enabled and not t13.on then Humanoid.WalkSpeed = CC.Movement.SpeedValue end
			if CC.Movement.Spinbot and not CC.Rage.Enabled and not t13.on then
				HRP.CFrame *= CFrame.Angles(0, math.rad(CC.Movement.SpinbotSpeed), 0)
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if CamiloConfig.Movement.InfiniteJump and LocalPlayer.Character then
		local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

RunService.Stepped:Connect(function()
	if CamiloConfig.Movement.BHop and LocalPlayer.Character then
		local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Hum and Hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			Hum:ChangeState(Enum.HumanoidStateType.Jumping)
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

library:init_config(window)

task.delay(1, function()
	library:notify({ name = "CamiloHook V1.5", info = "Loaded successfully!", duration = 4, icon = "check" })
end)
print("[CamiloHook V1.5] Loaded successfully!")
print("[Ragebot] RightAlt to toggle | Mode: gun | knife | melee")
