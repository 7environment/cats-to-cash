local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")

local LocalPlayer = game:GetService("Players").LocalPlayer

local Area
for _,v in ipairs(game:WaitForChild("Workspace"):WaitForChild("Map"):WaitForChild("GameArea"):GetChildren()) do
    if tostring(v.PlayerOwner.Value) == game:GetService("Players").LocalPlayer.Name then
        Area = v
    end
end

local Window = Rayfield:CreateWindow({
    Name = "Rayfield Example Window",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil, -- Create a custom folder for your hub/game
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },

    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

local MainTab = Window:CreateTab("Main Tab", "rewind")

local Section = MainTab:CreateSection("Main Section")

local collecting = false
local PickUpToggle = MainTab:CreateToggle({
    Name = "Auto pick up everything on",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        collecting = Value
        local goal = {}
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart)
        while collecting do
            for _, land in ipairs(Area.Lands:GetChildren()) do
                for _, pickup in ipairs(land.Pickup:GetChildren()) do
                    pickup.CanCollide = false
                    local PlayerPos = game:WaitForChild("Workspace"):WaitForChild(tostring(LocalPlayer.Name)):WaitForChild("HumanoidRootPart").Position
                    goal.Position = Vector3.new(PlayerPos.X, PlayerPos.Y-2, PlayerPos.Z)
                    local tween = TweenService:Create(pickup, tweenInfo, goal)
                    tween:Play()
                    task.wait()
                end
            end
            task.wait()
        end
    end,
})

local autobuyupgrades = false
local BuyToggle = MainTab:CreateToggle({
    Name = "Autobuy upgrades",
    CurrentValue = false,
    Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autobuyupgrades = Value
        while autobuyupgrades do
            for _, land in ipairs(Area.Lands:GetChildren()) do
                local args = {
                    "BuxLevel",
                    land.Name
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):FireServer(unpack(args))
                task.wait(.5)
                local args = {
                    "MainLevel",
                    land.Name
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):FireServer(unpack(args))
                task.wait(.5)
            end
            task.wait()
        end
    end,
})

local autobuylocation = false
local BuyLocToggle = MainTab:CreateToggle({
    Name = "Autobuy new location (broken)",
    CurrentValue = false,
    Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autobuylocation = Value
        while autobuylocation do
            local args = {
	            "2"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyArea"):FireServer(unpack(args))
            task.wait()
        end
    end,
})

local autoclickcats = false
local ClickCatToggle = MainTab:CreateToggle({
    Name = "Auto click cats",
    CurrentValue = false,
    Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoclickcats = Value
        while autoclickcats do
            for _, land in ipairs(Area.Lands:GetChildren()) do
                for _, cat in ipairs(land.CatFolder:GetChildren()) do
                    fire = false
                    for _, v in ipairs(cat:GetChildren()) do
                        if tostring(v) == "Base" then
                            fire = true
                        end
                    end
                    if fire then
                        fireclickdetector(cat.Base.ClickDetector)
                        task.wait()
                    end
                end
            end
            task.wait()
        end
    end,
})

local autowish = false
local AutoWishToggle = MainTab:CreateToggle({
    Name = "Autowish",
    CurrentValue = false,
    Flag = "Toggle5", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autowish = Value
        while autowish do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WishWell"):WaitForChild("RequestWish"):FireServer()
            task.wait()
        end
    end,
})
