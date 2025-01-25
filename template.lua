local repo = 'https://raw.githubusercontent.com/y2kzonk/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Example menu',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox on Main Tab
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Settings')

-- Add Labels to the groupbox
LeftGroupBox:AddLabel('Welcome to the Settings Window')
LeftGroupBox:AddLabel('Customize your experience here.')

-- Groupbox for UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu Settings')

-- Button to unload the library (close the menu)
MenuGroup:AddButton('Unload', function() Library:Unload() end)

-- Add a keybind for the menu
MenuGroup:AddLabel('Menu keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

-- Addons: Setup ThemeManager and SaveManager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- Set folders for saving configuration
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Build config menu on the right side of the UI Settings tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Build theme menu on the left side of the UI Settings tab
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Automatically load the config on startup
SaveManager:LoadAutoloadConfig()

-- Example of dynamically-updating watermark with FPS and ping
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('LinoriaLib demo | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library.KeybindFrame.Visible = true

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end)
