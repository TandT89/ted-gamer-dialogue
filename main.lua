-- Attach plugin to the game window
game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

-- Initialize local constants
local necromancyTutQuest = config.Quest.QUEST_NECROMANCY_TUTORIAL
local BOX_ID = id.Interface.CHAT_V2_LEFT -- 1184 is the most common chat box type
local BOX_TITLE_ID = id.Component.CHAT_V2_LEFT__TITLE_TEXT
local BOX_TEXT_ID = id.Component.CHAT_V2_LEFT__CHAT_TEXT
local NAME_ID = 4 --speaker's name is component 4 in the chatbox 
local TEXT_ID = 10 -- text spoken is component 10
local TED_TUTORIAL_CONFIG_NAME = "QUEST_NECROMANCY_TUTORIAL_TED"
local TED_NON_TUTORIAL_CONFIG_NAME = ""
local TED_DIALOGUE_1 = "<p=1>Oh, hey there, buds!"
local TED_DIALOGUE_2 = "<p=2>Hey there, bud! Can I help you with anything?"
local TED_DIALOGUE_3 = "<p=1>Don't worry. Ya doin' great, bud!"
local TED_DIALOGUE_REPLACE_1 = "whats poppin gamers"
local TED_DIALOGUE_REPLACE_2 = "whats poppin gamer"
local TED_DIALOGUE_REPLACE_3 = "like and subscribe"

local framesLeft = 0

log("Plugin Activated.")

--Function to retrieve labels from active dialogue boxes
local function boxLabel(staticID)
    local ok, label = pcall(function()
        if ui.Interfaces:GetInterface(BOX_ID) == nil then return nil end
        local component = ui.Interfaces:GetComponent(BOX_ID, staticID)
        if component ~= nil and component.visibleGlobal == true then return component end
        return nil
    end)
    return ok and label or nil
end

--Function for replacing lines in the dialogue box
local function replaceLine()
    local name, text = boxLabel(NAME_ID), boxLabel(TEXT_ID)

    if name == nil or text == nil or name.content ~= "Ted" then return end

    if text.content ~= TED_DIALOGUE_1 and text.content ~= TED_DIALOGUE_2 and text.content ~= TED_DIALOGUE_3 then log("Incorrect dialogue.") return end
    if text.content == TED_DIALOGUE_1 then text.content = TED_DIALOGUE_REPLACE_1 end
    if text.content == TED_DIALOGUE_2 then text.content = TED_DIALOGUE_REPLACE_2 end
    if text.content == TED_DIALOGUE_3 then text.content = TED_DIALOGUE_REPLACE_3 end
end

--Runs each frame after a chat update until the box has text, then replaces the line
local function waitForFilledBox()
    framesLeft = framesLeft - 1
    local text = boxLabel(BOX_TEXT_ID)
    if (text ~= nil and text.content ~= "") or framesLeft <= 0 then
        Event.Draw.Unsubscribe("replaceTedLine")
        replaceLine()
    end
end


--Debug function for returning transmitted VarPlayers and their values
local function detectVar(varDetected)
    local var = varDetected.var.configName

    if string.find(var,"NECROMANCY") or string.find(var,"CHAT") then
        log("Var transmitted: " .. var .. "\n Old var value: " .. varDetected.oldValue .. "\n New var value: " .. varDetected.newValue)
    end

    if string.find(var,"CHAT_V3") and #NPCList.ByName("Ted") ~= 0 then
        framesLeft = 3
        Event.Draw.Subscribe("replaceTedLine", waitForFilledBox)
    end
end

--Event subscriptions for when Vars are transmitted by the game and when an NPC is added to the screen
Event.VarTransmit.Subscribe("varDetectEvent", detectVar)
--Event.NPCEntityAdded.Subscribe("npcDetectEvent", detectNPC)
--1458
--245318