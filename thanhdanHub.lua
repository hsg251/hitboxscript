local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local enabled = false -- Trạng thái bật/tắt
local hitboxSize = Vector3.new(10, 10, 10) -- Kích thước hitbox mặc định
local countdownTime = 2 -- Thời gian mặc định (2 giây)

-- Tạo UI chính
local screenGui = Instance.new("ScreenGui")
local toggleButton = Instance.new("TextButton")
local titleLabel = Instance.new("TextLabel")
local sizeSlider = Instance.new("TextBox")
local countdownSlider = Instance.new("TextBox") -- Ô nhập cho thời gian đếm ngược
local thankYouLabel = Instance.new("TextLabel")

-- Gán UI vào CoreGui
screenGui.Parent = game.CoreGui

-- Cấu hình tiêu đề
titleLabel.Size = UDim2.new(0, 200, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "ThanhDan Hub"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = screenGui

-- Nút bật/tắt
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Bật Hitbox"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

-- Ô nhập kích thước
sizeSlider.Size = UDim2.new(0, 150, 0, 30)
sizeSlider.Position = UDim2.new(0, 10, 0, 130)
sizeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeSlider.Text = "10" -- Kích thước mặc định
sizeSlider.Font = Enum.Font.SourceSans
sizeSlider.TextSize = 18
sizeSlider.PlaceholderText = "Nhập kích thước"
sizeSlider.ClearTextOnFocus = true
sizeSlider.Parent = screenGui

-- Ô nhập thời gian đếm ngược
countdownSlider.Size = UDim2.new(0, 150, 0, 30)
countdownSlider.Position = UDim2.new(0, 10, 0, 170)
countdownSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
countdownSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownSlider.Text = "2" -- Thời gian mặc định
countdownSlider.Font = Enum.Font.SourceSans
countdownSlider.TextSize = 18
countdownSlider.PlaceholderText = "Nhập giây"
countdownSlider.ClearTextOnFocus = true
countdownSlider.Parent = screenGui

-- Hiển thị thông báo cảm ơn
thankYouLabel.Size = UDim2.new(0, 300, 0, 100)
thankYouLabel.Position = UDim2.new(0.5, -150, 0.5, -50) -- Ở giữa màn hình
thankYouLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
thankYouLabel.BackgroundTransparency = 0.5
thankYouLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
thankYouLabel.Text = "thanks for using!"
thankYouLabel.Font = Enum.Font.SourceSansBold
thankYouLabel.TextSize = 36
thankYouLabel.Parent = screenGui

-- Tự động xóa thông báo sau 3 giây
task.delay(3, function()
    if thankYouLabel then
        thankYouLabel:Destroy()
    end
end)

-- Hàm điều chỉnh kích thước hitbox
local function adjustHitbox(player, size)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = size
        rootPart.Transparency = 0.5 -- Tùy chọn: làm hitbox dễ nhìn thấy
        rootPart.Massless = true
        rootPart.CanCollide = false
    end
end

-- Hàm đặt lại kích thước hitbox
local function resetHitbox(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Size = Vector3.new(2, 2, 1) -- Kích thước mặc định
        rootPart.Transparency = 0 -- Đặt lại độ hiển thị
        rootPart.Massless = false
        rootPart.CanCollide = true
    end
end

-- Hàm bật/tắt hitbox
local function toggleHitbox()
    enabled = not enabled
    if enabled then
        toggleButton.Text = "Tắt sau " .. countdownTime .. "s"
        -- Bật hitbox cho tất cả người chơi
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                adjustHitbox(player, hitboxSize)
            end
        end
        -- Đếm ngược theo thời gian tùy chỉnh và tự tắt
        task.delay(countdownTime, function()
            toggleButton.Text = "Bật Hitbox" -- Đổi lại tên nút sau khi hết thời gian
            -- Tắt hitbox cho tất cả người chơi
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    resetHitbox(player)
                end
            end
        end)
    else
        toggleButton.Text = "Bật Hitbox"
        -- Tắt hitbox ngay lập tức khi nhấn nút
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                resetHitbox(player)
            end
        end
    end
end

-- Cập nhật kích thước hitbox từ input
sizeSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSize = tonumber(sizeSlider.Text)
        if newSize and newSize > 0 then
            hitboxSize = Vector3.new(newSize, newSize, newSize)
            print("Kích thước hitbox đã cập nhật:", hitboxSize)
        else
            sizeSlider.Text = tostring(hitboxSize.X) -- Đặt lại kích thước hiện tại nếu input không hợp lệ
        end
    end
end)

-- Cập nhật thời gian đếm ngược từ input
countdownSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newCountdownTime = tonumber(countdownSlider.Text)
        if newCountdownTime and newCountdownTime > 0 then
            countdownTime = newCountdownTime
            print("Thời gian đếm ngược đã cập nhật:", countdownTime)
        else
            countdownSlider.Text = tostring(countdownTime) -- Đặt lại thời gian hiện tại nếu input không hợp lệ
        end
    end
end)

-- Kết nối nút nhấn với hàm bật/tắt
toggleButton.MouseButton1Click:Connect(toggleHitbox)

-- Tự động đặt lại hitbox khi người chơi rời khỏi
Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        resetHitbox(player)
    end
end)

-- Hàm đổi màu ngẫu nhiên
local function randomColor()
    return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

-- Vòng lặp đổi màu tiêu đề
task.spawn(function()
    while true do
        titleLabel.TextColor3 = randomColor() -- Đổi màu chữ
        task.wait(1) -- Đổi màu mỗi 1 giây
    end
end)

print("Script hitbox đã tải. Sử dụng giao diện để bật/tắt và điều chỉnh kích thước.")
