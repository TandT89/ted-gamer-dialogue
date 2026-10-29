-- Attach plugin to the game window
game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

-- Initialize local constants
local necromancyTutQuest = config.Quest.QUEST_NECROMANCY_TUTORIAL
local BOX_ID = id.Interface.CHAT_V2_LEFT -- 1184 is the most common chat box type
local NAME_ID = 4 --speaker's name is component 4 in the chatbox 
local TEXT_ID = 10 -- text spoken is component 10
local TED_TUTORIAL_CONFIG_NAME = ""
local TED_DIALOGUE_1 = ""
local TED_DIALOGUE_2 = ""
local TED_DIALOGUE_REPLACE = "whats poppin gamer"

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
    if name == nil or text == nil then return end
    if name.content ~= TED_DIALOGUE_1 then return end
    if text.content == TED_DIALOGUE_1 then text.content = TED_DIALOGUE_REPLACE .. "s" end
end

--Debug function for detecting NPCs and returning their config names
local function detectNPC(npcEntityAddedEvent)
    log("NPC " .. npcEntityAddedEvent.npcEntity.config.configName .. " appeared.")

    if npcEntityAddedEvent.npcEntity.config.configName == TED_TUTORIAL_CONFIG_NAME then
        replaceLine()
    end

end

--Debug function for returning transmitted VarPlayers and their values
local function detectVar(varDetected)
    log(varDetected.valueType)
    --log("Var transmitted: " .. varDetected.config.name .. "\n Old var value: " .. varDetected.oldValue .. "\n New var value: " .. varDetected.newValue)
end

--Event subscriptions for when Vars are transmitted by the game and when an NPC is added to the screen
Event.VarTransmit.Subscribe("varDetectEvent", detectVar)
Event.NPCEntityAdded.Subscribe("npcDetectEvent", detectNPC)