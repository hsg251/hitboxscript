--Nếu script có bị lỗi thì ib fb: Thanh Sơn Lê; avt: thg da đen mắt lòi để đc sửa lỗi kịp thời
--link fb luôn cho nhanh=)): https://www.facebook.com/thanh.son.le.581360/
--nếu không đý thì ib tiktok: https://www.tiktok.com/@thanhdanhub124
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local enabled = false -- Trạng thái bật/tắt
local hitboxSize = Vector3.new(10, 10, 10) -- Kích thước hitbox mặc định
local countdownTime = 2 -- Thời gian mặc định (2 giây)

-- Tạo UI chính
local screenGui = Instance.new("ScreenGui")
local titleLabel = Instance.new("TextLabel")
local toggleButton = Instance.new("TextButton")
local sizeSlider = Instance.new("TextBox")
local countdownSlider = Instance.new("TextBox")

-- Gán UI vào CoreGui
screenGui.Parent = game.CoreGui

-- Cấu hình tiêu đề (xếp ngang, ở trên cùng)
titleLabel.Size = UDim2.new(0, 200, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 10) -- Góc trái trên cùng
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "ThanhDan Hub"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = screenGui

-- Nút bật/tắt hitbox (dưới tiêu đề)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 70) -- Dưới titleLabel
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Bật Hitbox"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

-- Ô nhập kích thước (bên phải tiêu đề)
sizeSlider.Size = UDim2.new(0, 150, 0, 50)
sizeSlider.Position = UDim2.new(0, 220, 0, 10) -- Bên phải titleLabel
sizeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeSlider.Text = "10" -- Kích thước mặc định
sizeSlider.Font = Enum.Font.SourceSans
sizeSlider.TextSize = 18
sizeSlider.PlaceholderText = "Kích thước"
sizeSlider.ClearTextOnFocus = true
sizeSlider.Parent = screenGui

-- Ô nhập thời gian đếm ngược (bên phải sizeSlider)
countdownSlider.Size = UDim2.new(0, 150, 0, 50)
countdownSlider.Position = UDim2.new(0, 380, 0, 10) -- Bên phải sizeSlider
countdownSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
countdownSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownSlider.Text = "2" -- Thời gian mặc định
countdownSlider.Font = Enum.Font.SourceSans
countdownSlider.TextSize = 18
countdownSlider.PlaceholderText = "Thời gian"
countdownSlider.ClearTextOnFocus = true
countdownSlider.Parent = screenGui

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

        -- Tự động tắt sau thời gian đếm ngược
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
        end)
    end
end

-- Cập nhật kích thước hitbox từ input
sizeSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSize = tonumber(sizeSlider.Text)
        if newSize and newSize > 0 then
            hitboxSize = Vector3.new(newSize, newSize, newSize)
        else
            sizeSlider.Text = tostring(hitboxSize.X)
        end
    end
end)

-- Cập nhật thời gian đếm ngược từ input
countdownSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newCountdownTime = tonumber(countdownSlider.Text)
        if newCountdownTime and newCountdownTime > 0 then
            countdownTime = newCountdownTime
        else
            countdownSlider.Text = tostring(countdownTime)
        end
    end
end)

-- Kết nối nút nhấn với hàm bật/tắt
toggleButton.MouseButton1Click:Connect(toggleHitbox)

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
            smoothColorTransition(target, endColor, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)), 3)
        end
    end
    updateColor()
end

-- Bắt đầu hiệu ứng đổi màu mượt
smoothColorTransition(titleLabel, Color3.fromRGB(255, 255, 255), Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)), 3)

print("UI đã sắp xếp lại: Nút bật Hitbox về chỗ cũ, các thành phần khác ngang trên cùng!")
