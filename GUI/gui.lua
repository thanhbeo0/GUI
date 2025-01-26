local GUI = {}
local configs = {} -- configs chỉ lưu những thứ đặc biệt

function GUI.Init()
    if not (configs.player or configs.screen) then
        local self = {}
        configs.Y = 0
        configs.player = game:GetService("Players").LocalPlayer
        local PlayerGui = configs.player:WaitForChild("PlayerGui")
        
        -- Tạo ScreenGui và gán vào configs.screen
        configs.screen = Instance.new("ScreenGui")
        configs.screen.Parent = PlayerGui

        -- Tạo UI Frame
        local UI = Instance.new("Frame")
        UI.Parent = configs.screen
        UI.Size = UDim2.new(0, 200, 0, 200)
        UI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UI.BorderSizePixel = 0
        UI.BorderColor3 = Color3.fromRGB(0, 0, 0)

        -- UICorner cho UI
        local UiCornerUI = Instance.new("UICorner")
        UiCornerUI.Parent = UI
        UiCornerUI.CornerRadius = UDim.new(0.5)

        -- UIAspectRatioConstraint cho UI
        local aspectRatioUI = Instance.new("UIAspectRatioConstraint")
        aspectRatioUI.AspectRatio = 1
        aspectRatioUI.Parent = UI

        -- Tạo icon ImageLabel
        local icon = Instance.new("ImageLabel")
        icon.Parent = configs.screen
        icon.ClipsDescendants = true
        icon.Size = UDim2.new(0, 50, 0, 50)
        icon.Position = UDim2.new(0, 200, 0, 100)

        -- Lấy avatar của người chơi
        local userID = configs.player.UserId
        local content = game:GetService("Players"):GetUserThumbnailAsync(userID, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size480x480)
        icon.Image = content

        -- UICorner cho icon
        local UiCornerIcon = Instance.new("UICorner")
        UiCornerIcon.Parent = icon
        UiCornerIcon.CornerRadius = UDim.new(0.5)

        -- UIAspectRatioConstraint cho icon
        local aspectRatioIcon = Instance.new("UIAspectRatioConstraint")
        aspectRatioIcon.AspectRatio = 1
        aspectRatioIcon.Parent = icon

        -- Lưu configs
        configs.UI = UI
        configs.touchPos, configs.Pos, configs.dragging = nil, nil, false

        -- Xử lý kéo thả
        for _, item in pairs({UI, icon}) do
            item.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    configs.touchPos = input.Position
                    configs.Pos = item.Position
                    configs.dragging = true
                end
            end)

            item.InputChanged:Connect(function(input)
                if configs.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - configs.touchPos
                    item.Position = UDim2.new(
                        configs.Pos.X.Scale,
                        configs.Pos.X.Offset + delta.X,
                        configs.Pos.Y.Scale,
                        configs.Pos.Y.Offset + delta.Y
                    )
                end
            end)

            item.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    configs.dragging = false
                end
            end)
        end

        -- Sự kiện click vào icon
        icon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                icon.Visible = false
                UI.Visible = true
            end
        end)

        -- Hàm tạo button
        function self.Button(Text)
            local button = Instance.new("TextButton")
            button.Parent = configs.UI
            button.BackgroundColor3 = Color3.fromRGB(125, 125, 125)
            button.Position = UDim2.new(0, 0, 0, configs.Y)
            button.Size = UDim2.new(0, 30, 0, 20)
            button.Text = Text
            configs.Y = configs.Y + 20

            local btnSelf = {}
            function btnSelf.OnClick(event)
                button.MouseButton1Click:Connect(function()
                    event()
                end)
            end
            return btnSelf
        end

        return self
    else
        print("Previously initialized")
        return nil
    end
end

return GUI
