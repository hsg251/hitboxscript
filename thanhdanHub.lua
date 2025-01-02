-- Me ri chít mợt
-- Thanks for using
-- Mình là hacker số 1 châu á
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local enabled = false -- Trạng thái bật/tắt
local hitboxSize = Vector3.new(10, 10, 10) -- Kích thước hitbox mặc định
local countdownTime = 2 -- Thời gian mặc định (2 giây)

-- Tạo UI chính
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local toggleButton = Instance.new("TextButton")
local sizeSlider = Instance.new("TextBox")
local countdownSlider = Instance.new("TextBox")
local menuButton = Instance.new("ImageButton")
local musicButton = Instance.new("TextButton")

-- Đặt UI vào PlayerGui nếu executor không cho truy cập CoreGui
local success, err = pcall(function()
    screenGui.Parent = game.CoreGui
end)
if not success then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Cấu hình nút mở menu
menuButton.Size = UDim2.new(0, 50, 0, 50)
menuButton.Position = UDim2.new(1, -60, 0.5, -200) -- Phía bên phải màn hình
menuButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuButton.Image = "rbxassetid://118921567222422"
menuButton.Parent = screenGui

-- Cấu hình menu chính
mainFrame.Size = UDim2.new(0, 250, 0, 450) -- Adjusted height to fit additional elements
mainFrame.Position = UDim2.new(1, -310, 0.5, -225) -- Bên phải, gần nút mở menu
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Ẩn menu khi bắt đầu
mainFrame.Parent = screenGui

-- Cấu hình tiêu đề (trên cùng menu)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "ThanhDan Hub"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

-- Hàm chuyển đổi màu mượt mà
local function smoothColorTransition(target, startColor, endColor, duration)
    local startTime = tick() -- Lấy thời gian hiện tại
    local function updateColor()
        local elapsed = tick() - startTime
        local progress = math.clamp(elapsed / duration, 0, 1) -- Tính toán tiến độ (0 đến 1)

        -- Sử dụng Lerp để chuyển màu
        target.TextColor3 = startColor:Lerp(endColor, progress)

        if progress < 1 then
            task.wait(0.03) -- Cập nhật mỗi 30ms để có hiệu ứng mượt mà
            updateColor()
        else
            -- Khi đã xong, đổi màu mới và tiếp tục chuyển đổi
            smoothColorTransition(target, endColor, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)), duration)
        end
    end
    updateColor()
end

-- Bắt đầu hiệu ứng đổi màu mượt
smoothColorTransition(titleLabel, Color3.fromRGB(255, 255, 255), Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)), 3)

-- Nút bật/tắt hitbox (dưới tiêu đề menu)
toggleButton.Size = UDim2.new(1, -20, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Bật Hitbox"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18
toggleButton.Parent = mainFrame

-- Ô nhập kích thước hitbox
sizeSlider.Size = UDim2.new(1, -20, 0, 50)
sizeSlider.Position = UDim2.new(0, 10, 0, 120)
sizeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeSlider.Text = "10"
sizeSlider.Font = Enum.Font.SourceSans
sizeSlider.TextSize = 18
sizeSlider.PlaceholderText = "Kích thước"
sizeSlider.ClearTextOnFocus = true
sizeSlider.Parent = mainFrame

-- Ô nhập thời gian đếm ngược
countdownSlider.Size = UDim2.new(1, -20, 0, 50)
countdownSlider.Position = UDim2.new(0, 10, 0, 180)
countdownSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
countdownSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownSlider.Text = "2"
countdownSlider.Font = Enum.Font.SourceSans
countdownSlider.TextSize = 18
countdownSlider.PlaceholderText = "Thời gian"
countdownSlider.ClearTextOnFocus = true
countdownSlider.Parent = mainFrame

-- Nút nghe nhạc
musicButton.Size = UDim2.new(1, -20, 0, 50)
musicButton.Position = UDim2.new(0, 10, 0, 240)
musicButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
musicButton.Text = "Nghe nhạc Chill"
musicButton.Font = Enum.Font.SourceSans
musicButton.TextSize = 18
musicButton.Parent = mainFrame

-- Menu lựa chọn nhạc
local musicSelectionFrame = Instance.new("Frame")
musicSelectionFrame.Size = UDim2.new(0, 300, 0, 300)
musicSelectionFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
musicSelectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
musicSelectionFrame.BorderSizePixel = 0
musicSelectionFrame.Visible = false
musicSelectionFrame.Parent = screenGui

-- Danh sách bài hát
local songs = {
    {"Lo-fi Chill A", "rbxassetid://9043887091"},
    {"Sunset Chill (Bed Version)", "rbxassetid://9046862941"},
    {"Sad / Chill Beat", "rbxassetid://1137575800"},
    {"Chill LoFi Hip-Hop Music", "rbxassetid://2023642240"},
    {"Chill Day", "rbxassetid://4552200821"}
}

-- Tạo các nút lựa chọn nhạc
for i, song in ipairs(songs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, (i - 1) * 50 + 10)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = song[1]
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = musicSelectionFrame

    button.MouseButton1Click:Connect(function()
        musicSelectionFrame.Visible = false
        local sound = Instance.new("Sound")
        sound.SoundId = song[2]
        sound.Volume = 0.5
        sound.Looped = true
        sound.Parent = SoundService
        sound:Play()
        musicSelectionFrame.Visible = false -- Ẩn menu nhạc khi chọn bài hát
    end)
end

-- Hiện menu nhạc khi nhấn nút
musicButton.MouseButton1Click:Connect(function()
    musicSelectionFrame.Visible = true
end)

-- Hàm điều chỉnh kích thước hitbox
local function adjustHitbox(player, size)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = size
        rootPart.Transparency = 0.5
        rootPart.Massless = true
        rootPart.CanCollide = false
    end
end

-- Hàm đặt lại kích thước hitbox
local function resetHitbox(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = Vector3.new(2, 2, 1)
        rootPart.Transparency = 0
        rootPart.Massless = false
        rootPart.CanCollide = true
    end
end

-- Hàm bật/tắt hitbox
local function toggleHitbox()
    if enabled then
        enabled = false
        toggleButton.Text = "Bật Hitbox"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                resetHitbox(player)
            end
        end
    else
        enabled = true
        toggleButton.Text = "Tắt Hitbox"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                adjustHitbox(player, hitboxSize)
            end
        end

        -- Nếu countdownTime không phải là 0, tự động tắt sau thời gian đếm ngược
        if countdownTime > 0 then
            task.delay(countdownTime, function()
                if enabled then
                    enabled = false
                    toggleButton.Text = "Bật Hitbox"
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            resetHitbox(player)
                        end
                    end
                end
