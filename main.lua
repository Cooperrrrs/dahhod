pcall(function()
	if getgenv().Aimbot and getgenv().Aimbot.Functions and getgenv().Aimbot.Functions.Exit then
		getgenv().Aimbot.Functions:Exit()
	end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local players, replicatedStorage = game:GetService("Players"), game:GetService("ReplicatedStorage");
local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents");
local onMessageDoneFiltering = defaultChatSystemChatEvents:FindFirstChild("OnMessageDoneFiltering");
local VirtualUser = game:GetService("VirtualUser")
local isUpdating = false
local updateConnection
local RunService = game:GetService("RunService")
local targetname = nil
local botname = nil
local drop = nil
local plrtobring = nil
local plrtogoto = nil
local botgoing = nil
local bkill = nil
local pkill = nil
local ats = _G.alts
local codes = _G.codes
local hideplace = CFrame.new(342.968323, 21.7499905, 130.013672, 0.0817344561, 5.39478862e-08, 0.996654153, 7.82229215e-09, 1, -5.47704921e-08, -0.996654153, 1.22727561e-08, 0.0817344561)
local buyAR = CFrame.new(490.781281, 48.0704956, -633.840515, 0.998062134, -6.59853505e-10, 0.062225379, 2.78090906e-09, 1, -3.40000561e-08, -0.062225379, 3.41072131e-08, 0.998062134)
local buyAmmo = CFrame.new(496.255707, 48.6713295, -634.311401, 0.977370262, -3.59791485e-08, -0.211535782, 4.6179089e-08, 1, 4.32783445e-08, 0.211535782, -5.20674952e-08, 0.977370262)
getgenv().Aimbot = {}
local Environment = getgenv().Aimbot
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local TargetPlayerName = nil
local ServiceConnections = {}
local PredictionTime = 0.3




loadstring(game:HttpGet('https://raw.githubusercontent.com/luca5432/Roblox-ANTI-AFK-SCRIPT/main/Script'))()



function chat(msg) 
	ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, 'All')
	print(msg)
end

function redeemcodes()
	for _, code in pairs(codes) do
		local args = {
			[1] = "EnterPromoCode",
			[2] = code
		}

		game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
		chat("Redeeming code: "..code)
		wait(5)
	end

end

function dropmoney(amount)
	local args = {
		[1] = "DropMoney",
		[2] = amount
	}

	game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
	chat("Dropping: "..amount)
end


function autodrop(bool)
	if bool then
		drop = task.spawn(function()
			while true do
				dropmoney(10000)
				wait(10)
			end
		end)
	else
		if drop then
			task.cancel(drop)
			drop = nil
		end
	end
end




function pickupmoney()
	for _, money in pairs(workspace.Ignored.Drop:GetChildren()) do
		if money.Name == "MoneyDrop" then
			--fireclickdetector(money.ClickDetector)
		end
	end
end


function  brings()
	print("startinmg function")
	local host = Players:FindFirstChild(_G.host)
	local playerfolder =  workspace:WaitForChild("Players")

	for _, plr in pairs(playerfolder:GetChildren()) do
		if plr.Name == host.Name then
			for index, altName in pairs(ats) do
				local altPlayer = game.Players:FindFirstChild(altName)
				if altPlayer and altPlayer.Character and altPlayer.Character:FindFirstChild("HumanoidRootPart") then
					altPlayer.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, -index * -5)
				end
			end
		end
	end
end

function  bringsmall()
	local playerfolder =  workspace:WaitForChild("Players")
	local host = Players:FindFirstChild(_G.host)
	for _, plr in pairs(playerfolder:GetChildren()) do
		if plr.Name == host.Name then
			for index, altName in pairs(ats) do
				local altPlayer = game.Players:FindFirstChild(altName)
				if altPlayer and altPlayer.Character and altPlayer.Character:FindFirstChild("HumanoidRootPart") then
					altPlayer.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
				end
			end
		end
	end
end



function killnbring(target, acc)
	wait(2)
	local host = Players:FindFirstChild(_G.host)
	if acc ~= player.Name then return end

	chat(_G.Pickup)

	local RTARGET = game.Players:WaitForChild(target)
	if RTARGET == nil then
		chat("Player isnt found!")
		return
	else
	end

	local function getPredictedPosition(target)
		local targetHRP = RTARGET.Character:FindFirstChild("HumanoidRootPart")
		if not targetHRP then return nil end

		local targetVelocity = targetHRP.Velocity
		local predictionTime = 0.2
		local predictedPosition = targetHRP.Position + targetVelocity * predictionTime

		return CFrame.new(predictedPosition)
	end

	local function stopUpdating()
		if isUpdating then
			isUpdating = false
			if updateConnection then
				updateConnection:Disconnect()
				updateConnection = nil
			end
		end
	end

	-- Function to update position
	local function updatePosition()
		wait(0.001)
		if not isUpdating then return end  -- Only update if isUpdating is true

		if RTARGET and RTARGET.Character and RTARGET.Character:FindFirstChild("HumanoidRootPart") then
			local targetPredictedCFrame = getPredictedPosition(RTARGET)
			if targetPredictedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local playerHRP = player.Character.HumanoidRootPart
				playerHRP.CFrame = targetPredictedCFrame * CFrame.new(0,3,0)
			end
		else
			stopUpdating()
			player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
			chat("User has left or not found!")
			wait(2)

			plrtobring = nil
			plrtogoto = nil
			botgoing = nil
		end
	end

	-- Function to start updating position
	local function startUpdating()
		if not isUpdating then
			isUpdating = true
			if not updateConnection then
				local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat")
				cc.Parent = game.Players.LocalPlayer.Character
				updateConnection = RunService.RenderStepped:Connect(updatePosition)
			end
		end
	end

	-- Function to stop updating position


	startUpdating()

	while true do
		if isUpdating then 
			if RTARGET.Character.Humanoid.Health <= 4 then
				stopUpdating()
				wait(0.4)
				player.Character.HumanoidRootPart.CFrame = player.Character.Head.CFrame
				wait(0.5)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
				wait(0.2)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
				local distance = (RTARGET.Character.HumanoidRootPart.Position - player.Character.UpperTorso.Position).Magnitude
				if distance <= 4 then
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					targetname = nil
					botname = nil
				else
					player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					targetname = nil
					botname = nil
				end
				break
			else
				print("clicking")
				VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
				wait(2)
				VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
			end
		else
			break
		end
	end
end








function tphost(target, acc)
	wait(2)
	local host = Players:FindFirstChild(_G.host)
	print(target, acc)
	if acc ~= player.Name then  print("NOT VALID") return end
	chat(_G.Pickup)
	local RTARGET = game.Players:WaitForChild(target)
	if RTARGET == nil then
		chat("Player isnt found!")
		return
	else
	end
	print("TARGET IS CALLED: "..RTARGET.Name)
	local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat")
	cc.Parent = game.Players.LocalPlayer.Character

	-- Function to update position
	local function updatePosition()
		wait(0.001)

		if host and host.Character and host.Character:FindFirstChild("HumanoidRootPart") then
			local playerHRP = player.Character.HumanoidRootPart
			playerHRP.CFrame =  host.Character.HumanoidRootPart.CFrame
		end
	end

	updatePosition()


	while true do
		if host.Character.Humanoid.Health <= 4 then
			wait(1)
			player.Character.HumanoidRootPart.CFrame = host.Character.UpperTorso.CFrame
			wait(0.4)
			player.Character.HumanoidRootPart.CFrame = host.Character.UpperTorso.CFrame
			local distance = (host.Character.HumanoidRootPart.Position - player.Character.UpperTorso.Position).Magnitude
			if distance <= 4 then
				print("OOGGAAA")
				wait(0.4)
				local args = {
					[1] = "Grabbing",
					[2] = false
				}

				game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame  * CFrame.new(0, 0, 0)
				wait(0.3)
				local args = {
					[1] = "Grabbing",
					[2] = false
				}

				game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
				targetname = nil
				botname = nil
			else
				player.Character.HumanoidRootPart.CFrame = host.Character.UpperTorso.CFrame
				print("OOGGAAA")
				wait(0.4)
				local args = {
					[1] = "Grabbing",
					[2] = false
				}

				game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame  * CFrame.new(0, 0, 0)
				wait(0.3)
				local args = {
					[1] = "Grabbing",
					[2] = false
				}

				game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
				targetname = nil
				botname = nil
			end

			break
		else
			print("clicking")
			VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
			wait(2)
			VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
		end
	end
end


function tpo(plrtobring, plrtogoto, botgoing)
	wait(2)
	local host = Players:FindFirstChild(_G.host)
	if botgoing ~= player.Name then return end

	chat(_G.Pickup)

	local TPTARGET = game.Players:WaitForChild(plrtobring)
	if RTARGET == nil then
		chat("Player isnt found!")
		return
	else
	end
	local BTARGET = game.Players:WaitForChild(plrtogoto)
	if BTARGET == nil then
		chat("Player isnt found!")
		return
	else
	end

	local function getPredictedPosition(target)
		local targetHRP = TPTARGET.Character:FindFirstChild("HumanoidRootPart")
		if not targetHRP then return nil end

		local targetVelocity = targetHRP.Velocity
		local predictionTime = 0.3
		local predictedPosition = targetHRP.Position + targetVelocity * predictionTime

		return CFrame.new(predictedPosition)
	end

	local function stopUpdating()
		if isUpdating then
			isUpdating = false
			if updateConnection then
				updateConnection:Disconnect()
				updateConnection = nil

			end
		end
	end

	-- Function to update position
	local function updatePosition()
		wait(0.001)
		if not isUpdating then return end  -- Only update if isUpdating is true

		if TPTARGET and TPTARGET.Character and TPTARGET.Character:FindFirstChild("HumanoidRootPart") then
			local targetPredictedCFrame = getPredictedPosition(TPTARGET)
			if targetPredictedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local playerHRP = player.Character.HumanoidRootPart
				playerHRP.CFrame = targetPredictedCFrame * CFrame.new(0,2,0)
				print(targetPredictedCFrame)
			end
		else
			stopUpdating()
			player.Character.HumanoidRootPart.CFrame = BTARGET.Character.HumanoidRootPart.CFrame
			chat("User has left or not found!")
			wait(2)
			player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
			plrtobring = nil
			plrtogoto = nil
			botgoing = nil
		end
	end

	-- Function to start updating position
	local function startUpdating()
		if not isUpdating then
			isUpdating = true
			if not updateConnection then
				local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat")
				cc.Parent = game.Players.LocalPlayer.Character
				updateConnection = RunService.RenderStepped:Connect(updatePosition)
			end
		end
	end

	-- Function to stop updating position


	startUpdating()

	while true do
		if isUpdating then 
			if TPTARGET.Character.Humanoid.Health <= 4 then
				stopUpdating()
				wait(0.4)
				player.Character.HumanoidRootPart.CFrame = player.Character.UpperTorso.CFrame
				wait(0.5)
				player.Character.HumanoidRootPart.CFrame = TPTARGET.Character.UpperTorso.CFrame
				wait(0.2)
				player.Character.HumanoidRootPart.CFrame = TPTARGET.Character.UpperTorso.CFrame
				local distance = (host.Character.HumanoidRootPart.Position - player.Character.UpperTorso.Position).Magnitude
				if distance <= 4 then
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = BTARGET.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					plrtobring = nil
					plrtogoto = nil
					botgoing = nil
				else
					player.Character.HumanoidRootPart.CFrame = TPTARGET.Character.UpperTorso.CFrame
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = BTARGET.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					plrtobring = nil
					plrtogoto = nil
					botgoing = nil
				end

				chat("Here is the person you requested!")
				wait(2)
				player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)

				break
			else
				print("clicking")
				VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
				wait(2)
				VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
			end
		else
			break
		end
	end
end


function tpgun(target, acc)
	wait(2)
	local host = Players:FindFirstChild(_G.host)
	if acc ~= player.Name then return end

	chat(_G.Pickup)

	local RTARGET = game.Players:WaitForChild(target)
	if RTARGET == nil then
		chat("Player isnt found!")
		return
	else
	end


	--// Core Functions

	local function LockOnTargetPlayer()
		for _, player in pairs(Players:GetPlayers()) do
			if player.Name == TargetPlayerName then
				if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
					Environment.Locked = player
					break
				end
			end
		end
	end

	local function UnlockOnDeath()
		if Environment.Locked and Environment.Locked.Character and Environment.Locked.Character:FindFirstChildOfClass("Humanoid") then
			if Environment.Locked.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				Environment.Locked = nil
			end
		end
	end

	local function GetPredictedPosition()
		if Environment.Locked and Environment.Locked.Character and Environment.Locked.Character:FindFirstChild("Head") then
			local head = Environment.Locked.Character.Head
			if head and head:IsA("BasePart") then
				local velocity = head.Velocity
				if velocity then
					return head.Position + (velocity * PredictionTime)
				end
			end
		end
		return nil
	end

	--// Load

	local function Load()
		ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
			if not Environment.Locked then
				LockOnTargetPlayer()
			else
				UnlockOnDeath()
				if Environment.Locked then
					local predictedPosition = GetPredictedPosition()
					if predictedPosition then
						Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)
					end
				end
			end
		end)
	end

	--// Functions

	Environment.Functions = {}

	function Environment.Functions:Exit()
		for _, v in pairs(ServiceConnections) do
			v:Disconnect()
		end
		getgenv().Aimbot.Functions = nil
		getgenv().Aimbot = nil
	end




	local function getPredictedPosition(target)
		local targetHRP = RTARGET.Character:FindFirstChild("HumanoidRootPart")
		if not targetHRP then return nil end

		local targetVelocity = targetHRP.Velocity
		local predictionTime = 0.2
		local predictedPosition = targetHRP.Position + targetVelocity * predictionTime

		return CFrame.new(predictedPosition)
	end

	local function stopUpdating()
		if isUpdating then
			isUpdating = false
			if updateConnection then
				updateConnection:Disconnect()
				updateConnection = nil
			end
		end
	end

	-- Function to update position
	local function updatePosition()
		wait(0.001)
		if not isUpdating then return end  -- Only update if isUpdating is true

		if RTARGET and RTARGET.Character and RTARGET.Character:FindFirstChild("HumanoidRootPart") then
			local targetPredictedCFrame = getPredictedPosition(RTARGET)
			if targetPredictedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local playerHRP = player.Character.HumanoidRootPart
				playerHRP.CFrame = targetPredictedCFrame * CFrame.new(0,3,0)
			end
		else
			stopUpdating()
			player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
			chat("User has left or not found!")
			wait(2)

			plrtobring = nil
			plrtogoto = nil
			botgoing = nil
			Environment.Locked = nil
			for _, v in pairs(ServiceConnections) do
				v:Disconnect()
			end
		end
	end


	-- Function to handle the value change
	local function onAmmoChanged()
		local ammoValue = game.Players.LocalPlayer.Character:WaitForChild("[SilencerAR]"):WaitForChild("Ammo")
		print("Ammo value changed to: " .. ammoValue.Value)
		if ammoValue.Value == 0 then
			local args = {
				[1] = "Reload",
				[2] = game:GetService("Players").LocalPlayer.Character:FindFirstChild("[SilencerAR]")
			}

			game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
		end
	end

	-- Connect the function to the Changed event




	-- Function to start updating position
	local function startUpdating()
		if not isUpdating then
			isUpdating = true
			if not updateConnection then
				local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("[SilencerAR]")
				if cc then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = buyAmmo
					for i = 1, 2 do
						wait(2)
						fireclickdetector(game.Workspace.Ignored.Shop["120 [SilencerAR Ammo] - $80"].ClickDetector)
					end
					cc.Parent = game.Players.LocalPlayer.Character
				else

					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = buyAR
					wait(3)
					fireclickdetector(game.Workspace.Ignored.Shop["[SilencerAR] - $1326"].ClickDetector)
					wait(0.2)

					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = buyAmmo
					for i = 1, 2 do
						fireclickdetector(game.Workspace.Ignored.Shop["120 [SilencerAR Ammo] - $80"].ClickDetector)
					end
					wait(0.2)
					local cc2 = game.Players.LocalPlayer.Backpack:FindFirstChild("[SilencerAR]")
					cc2.Parent = game.Players.LocalPlayer.Character
				end
				local args = {
					[1] = "Reload",
					[2] = game:GetService("Players").LocalPlayer.Character:FindFirstChild("[SilencerAR]")
				}

				game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
				wait(0.6)
				TargetPlayerName = RTARGET.Name
				Load()
				updateConnection = RunService.RenderStepped:Connect(updatePosition)
			end
		end
	end

	-- Function to stop updating position


	startUpdating()
	local f = nil
	while true do
		if isUpdating then
			local ammoValue = game.Players.LocalPlayer.Character:WaitForChild("[SilencerAR]"):WaitForChild("Ammo")
			ammoValue.Changed:Connect(onAmmoChanged)
			if RTARGET.Character.Humanoid.Health <= 4 then
				task.cancel(f)
				Environment.Locked = nil
				for _, v in pairs(ServiceConnections) do
					v:Disconnect()
				end
				stopUpdating()
				wait(0.4)
				player.Character.HumanoidRootPart.CFrame = player.Character.Head.CFrame
				wait(0.5)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
				wait(0.2)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
				local distance = (RTARGET.Character.HumanoidRootPart.Position - player.Character.UpperTorso.Position).Magnitude
				if distance <= 4 then
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					targetname = nil
					botname = nil
				else
					player.Character.HumanoidRootPart.CFrame = RTARGET.Character.UpperTorso.CFrame
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

					player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
					wait(0.3)
					local args = {
						[1] = "Grabbing",
						[2] = false
					}

					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
					targetname = nil
					botname = nil
				end
				break
			else
				print("clicking")
				f = task.spawn(function()
					VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
					wait(5)
					VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
				end)
			end
		else
			break
		end
	end
end




function stop(acc)
	local host = Players:FindFirstChild(_G.host)
	if acc ~= player.Name then return end
	if isUpdating then
		targetname = nil
		botname = nil
		isUpdating = false
	end
	wait(0.2)
	player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, -5)
end

function hide(acc)
	if acc == "All" then
		player.Character.HumanoidRootPart.CFrame = hideplace
	else
		if acc ~= player.Name then return end
		player.Character.HumanoidRootPart.CFrame = hideplace
	end
end

function unhide(acc)
	if acc == "All" then
		brings()
	else
		if acc ~= player.Name then return end
		brings()
	end
end



function cmds()
	chat("Bring, drop, tp, tph, tpo, ss, msg, hide, unhide, kick, rejoin")
end

function rejoin()
	local TeleportService = game:GetService("TeleportService")
	local placeId = game.PlaceId
	local jobId = game.JobId 

	TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
end

onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
	local host = Players:FindFirstChild(_G.host)
	local speaker, message = players[messageData.FromSpeaker], messageData.Message
	if speaker == host then
		local parts = string.split(message, " ")
		local part1 = parts[1]
		local splitMessage = parts[2]
		print(splitMessage)  -- Output: hello

		print("Found host")
		if string.lower(message) == "bring" then
			chat("Returning back to ".._G.host.."!")
			brings()
		elseif string.lower(message) == "drop true" then
			if string.find(player.DisplayName, "BodyGuard") then return end
			chat("Started Droping")
			local walletTool = player.Backpack:FindFirstChild("Wallet")
			if walletTool then
				player.Character.Humanoid:EquipTool(walletTool)
			else
			end
			autodrop(true)
		elseif string.lower(message) == "drop false" then
			chat("Stopped Droping")
			autodrop(false)
		elseif string.lower(message) == "redeem codes" then
			redeemcodes()
		elseif string.lower(part1) == "msg" then
			local command, restOfMessage = message:match("^(%S+)%s+(.+)$")
			chat(restOfMessage)
		elseif string.lower(message) == "bring small" then
			chat("Returning back to ".._G.host.."!")
			bringsmall()
		elseif string.lower(part1) == "tp" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
					print("Username: " .. Player.Name .. ", Display Name: " .. Player.DisplayName)
					targetname = Player.Name
				end
			end

			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[3]) or Player.DisplayName:find(parts[3]) then
					print("Username: " .. Player.Name .. ", Display Name: " .. Player.DisplayName)
					botname = Player.Name
				end
			end
			killnbring(targetname, botname)

		elseif string.lower(part1) == "ss" then
			chat("Returning back to ".._G.host.."!")
			for _,Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or  Player.DisplayName:find(splitMessage) then
					stop(Player.Name)
				end
			end
		elseif string.lower(part1) == "tph" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
					print("Username: " .. Player.Name .. ", Display Name: " .. Player.DisplayName)
					targetname = Player.Name
				end
			end

			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[3]) or Player.DisplayName:find(parts[3]) then
					print("Username: " .. Player.Name .. ", Display Name: " .. Player.DisplayName)
					botname = Player.Name
				end
			end
			tphost(targetname, botname)
		elseif string.lower(part1) == "hide" then
			if splitMessage == "All" then
				hide("All")
			else
				for _, Player in pairs(Players:GetPlayers()) do
					if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
						hide(Player.Name)
					end
				end
			end
		elseif string.lower(part1) == "unhide" then
			if splitMessage == "All" then
				unhide("All")
			else
				for _, Player in pairs(Players:GetPlayers()) do
					if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
						unhide(Player.Name)
					end
				end
			end
		elseif string.lower(part1) == "tpo" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[2]) or Player.DisplayName:find(parts[2]) then
					plrtobring = Player.Name
				end
			end

			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[3]) or Player.DisplayName:find(parts[3]) then
					plrtogoto = Player.Name
				end
			end

			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[4]) or Player.DisplayName:find(parts[4]) then
					botgoing = Player.Name
				end
			end

			tpo(plrtobring, plrtogoto, botgoing)
		elseif string.lower(message) == "cmds" then
			cmds()
		elseif string.lower(part1) == "kick" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[2]) or Player.DisplayName:find(parts[2]) then
					Player:Kick("The host has requested to kick you")
				end
			end
		elseif string.lower(part1) == "rejoin" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[2]) or Player.DisplayName:find(parts[2]) then
					chat("I am rejoining!")
					rejoin()
				end
			end
		elseif string.lower(part1) == "tpg" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[2]) or Player.DisplayName:find(parts[2]) then
					pkill = Player.Name
				end
			end

			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(parts[3]) or Player.DisplayName:find(parts[3]) then
					bkill = Player.Name
				end
			end
			tpgun(pkill, bkill)
		end
	end
end)



game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	wait(2)
	if isUpdating == true then
		killnbring(targetname, botname)
	else
		brings()
	end
end)


local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
ScreenGui.ResetOnSpawn = false

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(1, 0, 1, 0)



TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Your on an alt"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true


if string.find(player.DisplayName, "BodyGuard") then
	ScreenGui.Enabled = false
else
	ScreenGui.Enabled = false
end



