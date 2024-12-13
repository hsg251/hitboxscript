-- script này là script hitbox bạn có thể sử dụng trong tất cả các game:3
-- đặc biệt là: murderer vs sheriff; murder mystery 2
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local enabled = false -- Toggle state
local hitboxSize = Vector3.new(10, 10, 10) -- Default hitbox size

local screenGui = Instance.new("ScreenGui")
local toggleButton = Instance.new("TextButton")
local titleLabel = Instance.new("TextLabel")
local sizeSlider = Instance.new("TextBox")

-- Create UI
screenGui.Parent = game.CoreGui

-- Configure Title
titleLabel.Size = UDim2.new(0, 200, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "ThanhDan Hub"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = screenGui

-- Adjust button position below title
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Toggle Hitbox"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

-- Configure Size Input (for mobile touch input)
sizeSlider.Size = UDim2.new(0, 150, 0, 30)
sizeSlider.Position = UDim2.new(0, 10, 0, 130)
sizeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeSlider.Text = "10" -- Default size
sizeSlider.Font = Enum.Font.SourceSans
sizeSlider.TextSize = 18
sizeSlider.PlaceholderText = "Enter size"
sizeSlider.ClearTextOnFocus = true
sizeSlider.Parent = screenGui

-- Function to adjust hitbox size
local function adjustHitbox(player, size)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = size
        rootPart.Transparency = 0.5 -- Optional: make the hitbox visible
        rootPart.Massless = true
        rootPart.CanCollide = false
    end
end

-- Function to reset hitbox size
local function resetHitbox(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = Vector3.new(2, 2, 1) -- Default size
        rootPart.Transparency = 0 -- Reset visibility
        rootPart.Massless = false
        rootPart.CanCollide = true
    end
end

-- Toggle function
local function toggleHitbox()
    enabled = not enabled
    toggleButton.Text = enabled and "Disable Hitbox" or "Enable Hitbox"
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                adjustHitbox(player, hitboxSize)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                resetHitbox(player)
            end
        end
    end
end

-- Update hitbox size from input
sizeSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSize = tonumber(sizeSlider.Text)
        if newSize and newSize > 0 then
            hitboxSize = Vector3.new(newSize, newSize, newSize)
            print("Hitbox size updated to:", hitboxSize)
        else
            sizeSlider.Text = tostring(hitboxSize.X) -- Reset to current size if input is invalid
        end
    end
end)

-- Connect button tap to toggle function
toggleButton.MouseButton1Click:Connect(toggleHitbox)

-- Automatically reset hitboxes when a player leaves
Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        resetHitbox(player)
    end
end)

print("Hitbox script đã tải. Sử dụng UI để chuyển đổi và điều chỉnh kích thước.")
