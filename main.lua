local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local host = Players:FindFirstChild(_G.host)
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
local ats = _G.alts
local codes = _G.codes
local hideplace = CFrame.new(342.968323, 21.7499905, 130.013672, 0.0817344561, 5.39478862e-08, 0.996654153, 7.82229215e-09, 1, -5.47704921e-08, -0.996654153, 1.22727561e-08, 0.0817344561)

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
			fireclickdetector(money.ClickDetector)
		end
	end
end


function  brings()
	print("startinmg function")
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
	if acc ~= player.Name then return end

	chat("Hey ive come to get you please do not run!")

	local RTARGET = game.Players:WaitForChild(target)

	local function getPredictedPosition(target)
		local targetHRP = RTARGET.Character:FindFirstChild("HumanoidRootPart")
		if not targetHRP then return nil end

		local targetVelocity = targetHRP.Velocity
		local predictionTime = 0.3
		local predictedPosition = targetHRP.Position + targetVelocity * predictionTime

		return CFrame.new(predictedPosition)
	end

	-- Function to update position
	local function updatePosition()
		wait(0.001)
		if not isUpdating then return end  -- Only update if isUpdating is true

		if RTARGET and RTARGET.Character and RTARGET.Character:FindFirstChild("HumanoidRootPart") then
			local targetPredictedCFrame = getPredictedPosition(RTARGET)
			if targetPredictedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local playerHRP = player.Character.HumanoidRootPart
				playerHRP.CFrame = targetPredictedCFrame * CFrame.new(0, 3, 0) -- Adjust the offset as needed
				print(targetPredictedCFrame)
			end
		end
	end

	-- Function to start updating position
	local function startUpdating()
		if not isUpdating then
			isUpdating = true
			if not updateConnection then
				local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat")
				player.Character.Humanoid:EquipTool(cc)
				updateConnection = RunService.RenderStepped:Connect(updatePosition)
			end
		end
	end

	-- Function to stop updating position
	local function stopUpdating()
		if isUpdating then
			isUpdating = false
			if updateConnection then
				updateConnection:Disconnect()
				updateConnection = nil
			end
		end
	end

	startUpdating()

	while true do
		if isUpdating then 
			if RTARGET.Character.Humanoid.Health <= 4 then
				stopUpdating()
				wait(1)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.HumanoidRootPart.CFrame
				player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
				wait(0.4)
				player.Character.HumanoidRootPart.CFrame = RTARGET.Character.HumanoidRootPart.CFrame
				wait(0.6)
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
				break
			else
				print("clicking")
				VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
				wait(3)
				VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
			end
		else
			break
		end
	end
end


function tphost(target, acc)
	wait(2)
	print(target, acc)
	if acc ~= player.Name then  print("NOT VALID") return end
	chat("Hey ive come to get you please do not run!")
	local RTARGET = game.Players:WaitForChild(target)
	print("TARGET IS CALLED: "..RTARGET.Name)
	local cc = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat")
	player.Character.Humanoid:EquipTool(cc)

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
			player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
			wait(0.4)
			player.Character.HumanoidRootPart.CFrame = host.Character.HumanoidRootPart.CFrame
			print("OOGGAAA")
			wait(0.4)
			local args = {
				[1] = "Grabbing",
				[2] = false
			}

			game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

			player.Character.HumanoidRootPart.CFrame = RTARGET.Character.HumanoidRootPart.CFrame  * CFrame.new(0, 0, 0)
			wait(0.3)
			local args = {
				[1] = "Grabbing",
				[2] = false
			}

			game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
			targetname = nil
			botname = nil
			break
		else
			print("clicking")
			VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
			wait(3)
			VirtualUser:Button1Up(Vector2.new(0, 0), game:GetService("Workspace").CurrentCamera.CFrame)
		end
	end
end



function stop(acc)
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
	if acc ~= player.Name then return end
	player.Character.HumanoidRootPart.CFrame = hideplace
end

function unhide(acc)
	if acc ~= player.Name then return end
	brings()
	player.Character.HumanoidRootPart.Anchored = false
end


onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
	local speaker, message = players[messageData.FromSpeaker], messageData.Message
	if speaker == host then
		local parts = string.split(message, " ")
		local part1 = parts[1]
		local splitMessage = parts[2]
		print(splitMessage)  -- Output: hello

		print("Found host")
		if message == "bring" then
			chat("Returning back to weareout!")
			brings()
		elseif message == "drop true" then
			if game.Players.LocalPlayer.DisplayName == "BodyGuard" then return end
			chat("Started Droping")
			local walletTool = player.Backpack:FindFirstChild("Wallet")
			if walletTool then
				player.Character.Humanoid:EquipTool(walletTool)
			else
			end
			autodrop(true)
		elseif message == "drop false" then
			chat("Stopped Droping")
			autodrop(false)
		elseif message == "redeem codes" then
			redeemcodes()
		elseif part1 == "msg" then
			local command, restOfMessage = message:match("^(%S+)%s+(.+)$")
			chat(restOfMessage)
		elseif message == "bring small" then
			chat("Returning back to weareout!")
			bringsmall()
		elseif part1 == "tp" then
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

		elseif part1 == "ss" then
			chat("Returning back to weareout!")
			for _,Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or  Player.DisplayName:find(splitMessage) then
					stop(Player.Name)
				end
			end
		elseif part1 == "tph" then
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
		elseif part1 == "hide" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
					hide(Player.Name)
				end
			end
		elseif part1 == "unhide" then
			for _, Player in pairs(Players:GetPlayers()) do
				if Player.Name:find(splitMessage) or Player.DisplayName:find(splitMessage) then
					unhide(Player.Name)
				end
			end
		end
	end
end)



game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	print("died")
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


ScreenGui.Enabled = false
