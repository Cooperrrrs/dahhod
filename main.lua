local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local host = Players:FindFirstChild("devcoopr")
local players, replicatedStorage = game:GetService("Players"), game:GetService("ReplicatedStorage");
local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents");
local onMessageDoneFiltering = defaultChatSystemChatEvents:FindFirstChild("OnMessageDoneFiltering");

local drop = nil

local ats = {
    ["1"] = "diamondgamer72",
    ["2"] = "SixterYeeter",
    ["3"] = "isimsizzz1234566",
    ["4"] = "ravena_mexirica",
    ["5"] = "ObamaThePresident198",
    ["6"] = "CoolgAmer30328",
}

local codes = {
    "PENGUIN",
    "BLAZE",
    "RUBY",
    "pumpkins2023",
    "TRADEME!",
    "DAUP",
}

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
        wait(10)
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
        -- Start dropping money
        drop = task.spawn(function()
            while true do
                
                dropmoney(10000) -- Assuming dropmoney is a function that handles the drop
                wait(10) -- Wait 10 seconds before dropping again
            end
        end)
    else
        -- Stop dropping money
        if drop then
            task.cancel(drop)
            drop = nil -- Clear the drop reference
        end
    end
end




function pickupmoney()
    for _, money in pairs(workspace.Ignored.Drop:GetChildren()) do
        if money.Name == "MoneyDrop" then
            --money.ClickDetector:Fire("MouseClick", player)
        end
    end
end


function  brings()
    print("startinmg function")
    local playerfolder =  workspace:WaitForChild("Players")
    local startPosition = host.Character.HumanoidRootPart.Position
    local offset = Vector3.new(0, 0, 7)

    for _, plr in pairs(playerfolder:GetChildren()) do
        if plr.Name == host.Name then
            for index, altName in pairs(ats) do
                 print("11")
                local altPlayer = game.Players:FindFirstChild(altName)
                if altPlayer and altPlayer.Character and altPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local newPosition = startPosition + (tonumber(index) * offset)
                    altPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition)
                end
            end
        end
    end
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
            brings()
        elseif message == "drop true" then
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
            chat(splitMessage)
        end
    end
end)


player.CharacterAdded:Connect(function(character)
    brings()
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
