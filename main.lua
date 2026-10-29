-- Code section 1
-- Attach plugins to the game window
game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

necromancyTutQuest = config.Quest.QUEST_NECROMANCY_TUTORIAL

print(necromancyTutQuest.params)

for param in necromancyTutQuest.params do
    print(param)
end

-- Code section 2
-- Create a new group box for components
local myGroupBox = ui.GroupBox.new(game_window)
myGroupBox.stylesheetID = id.StyleSheet.DEFAULT
myGroupBox:SetHeaderLayout(0,0,0,0,0)
myGroupBox:SetSize(250,200)
myGroupBox:SetPos(0,0,0.6,0.4)

-- Code section 3
-- Add some text
local myText = ui.Text.new(myGroupBox)
myText:SetSize(0,0,1.0,0.5)
myText:SetPos(0,0)
myText.content = "Hello world!"
myText.font = id.Font.MUSEO_SANS_15PT_REGULAR
myText:AlignTo(ui.AlignMode.CENTRE)

-- Code section 4 version 2
-- Add a button
local myButton = ui.Button.new(myGroupBox)
myButton:SetPos(0,0,0.0,0.5)
myButton:SetSize(0,0,1.0,0.5)
myButton.label = "Push this button"
myButton.stylesheetID = id.StyleSheet.BUTTON_DEFAULT

-- Code section 5 version 2
-- Creating the button callback function relies on information defined later in the script
local function buttonPress()
    myText.content = myText.content.."!"
end
myButton:Subscribe(ui.Hook.ONBUTTONPRESSED, buttonPress)

-- Code section 6
-- Get the config for the Lumbridge guards
local lumGuardConfig = config.NPC.FAI_LUMBRIDGE_GUARD_PATROL
local lumGuardName = lumGuardConfig.name
myText.content = lumGuardConfig.name .. " is size " .. tostring(lumGuardConfig.gridSize)

-- Code section 7 version 3
-- When the button is pressed: Find all nearby NPCs that match the config and display their location
local function buttonPress()
    localLumGuards = NPCList.ByName('Lumbridge Guardsman')
    for _,npc in pairs(localLumGuards) do
        myText.content = formatStr('{} is at position {} and is facing {}',npc.config.name,tostring(npc.coordGrid),npc.facing)
    end
end
myButton:Subscribe(ui.Hook.ONBUTTONPRESSED, buttonPress)