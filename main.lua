local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local host = Players:FindFirstChild("devcoopr")
local players, replicatedStorage = game:GetService("Players"), game:GetService("ReplicatedStorage");
local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents");
local onMessageDoneFiltering = defaultChatSystemChatEvents:FindFirstChild("OnMessageDoneFiltering");

local drop = nil

local ats = {
    ["1"] = "tonytheboy",
    ["2"] = "mycoopis",
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

function redeemcodes()

    for _, code in pairs(codes) do
        local args = {
                [1] = "EnterPromoCode",
                [2] = code
            }

        game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
        wait(10)
    end
        
end

function dropmoney(amount)
        local args = {
            [1] = "DropMoney",
            [2] = amount
        }

        game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))

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



function chat(msg) 
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, 'All')
    print(msg)
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
        print("looking")
        if plr.Name == host.Name then
            for index, altName in pairs(ats) do
                local altPlayer = game.Players:FindFirstChild(altName)
                if altPlayer and altPlayer.Character and altPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local newPosition = startPosition + (tonumber(index) * offset)
                    altPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition)
                    print(altName .. " teleported to new position")
                end
            end
        end
    end
end


onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
    local speaker, message = players[messageData.FromSpeaker], messageData.Message
    if speaker == host then
        print("Found host")
        if message == "bring" then
            brings()
        elseif message == "drop true" then
                 local walletTool = player.Backpack:FindFirstChild("Wallet")
                    if walletTool then
                        player.Character.Humanoid:EquipTool(walletTool)
                    else
                    end
            autodrop(true)
        elseif message == "drop false" then
            autodrop(false)
        elseif message == "redeem codes" then
            redeemcodes()
        end
    end
end)


