-- Attach plugin to the game window
game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

-- Initialize local constants
local BOX_ID = id.Interface.CHAT_V2_LEFT -- 1184 is the most common chat box type
local NAME_ID = 4 --speaker's name is component 4 in the chatbox 
local TEXT_ID = 10 -- text spoken is component 10
local TED_DIALOGUE_1 = "<p=1>Oh, hey there, buds!" --Ted's first line after appearing in the "Necromancy!" quest.
local TED_DIALOGUE_2 = "<p=2>Hey there, bud! Can I help you with anything?" --Ted's first line when a player speaks to him near the ritual circle in Um.
local TED_DIALOGUE_3 = "<p=1>Don't worry. Ya doin' great, bud!" --Ted's farewell line when the player says goodbye to him in Um.
local TED_DIALOGUE_REPLACE = {"whats poppin gamers","whats poppin gamer","like and subscribe"} --Replacement lines for the different matching dialogues.
local framesLeft = 0 --Variable to store number of frames to pauise functions for.

--Only log in entire plugin, to confirm the plugin has launched in the console when loaded.
log("Gamer Ted Plugin Activated.")

--Function to retrieve labels from active dialogue boxes.
local function boxLabel(staticID)
    --Protected function call (pcall) for retrieving a UI component from a given staticID value.
    local ok, label = pcall(function()
        --If the chat box doesn't exist, return nil.
        if ui.Interfaces:GetInterface(BOX_ID) == nil then return nil end

        --Get the specific component in the chat box using the staticID.
        local component = ui.Interfaces:GetComponent(BOX_ID, staticID)

        --If the component exists and is visible to the player, return it.
        if component ~= nil and component.visibleGlobal == true then return component end
        
        --Default case return nil
        return nil
    end)
    return ok and label or nil
end

--Function for replacing lines in the dialogue box.
local function replaceLine()
    --Get the chat box title and chat box contents using boxLabel().
    local name, text = boxLabel(NAME_ID), boxLabel(TEXT_ID)

    --If the title isn't "Ted" or the content doesn't exist, return.
    if text == nil or name.content ~= "Ted" then return end

    --If the dialogue isn't any of the three we're looking for, just return.
    if text.content ~= TED_DIALOGUE_1 and text.content ~= TED_DIALOGUE_2 and text.content ~= TED_DIALOGUE_3 then return end

    --Too many if/then statements to change the given dialogue based on context.
    --(I wanted to do a switch statement but Lua doesn't do those. Any recomendations are appreciated :) )
    if text.content == TED_DIALOGUE_1 then text.content = TED_DIALOGUE_REPLACE[1] end
    if text.content == TED_DIALOGUE_2 then text.content = TED_DIALOGUE_REPLACE[2] end
    if text.content == TED_DIALOGUE_3 then text.content = TED_DIALOGUE_REPLACE[3] end
end

--Runs each frame after a chat update until the box has text, then replaces the line
local function waitForFilledBox()
    --Each frame, remove one from framesLeft
    framesLeft = framesLeft - 1

    --Set text to the label component of BOX_TEXT_ID 
    local text = boxLabel(BOX_TEXT_ID)

    --If text is created and contains something, or we've run out of frames to wait for, then attempt to replace the dialogue line.
    if (text ~= nil and text.content ~= "") or framesLeft <= 0 then
        Event.Draw.Unsubscribe("replaceTedLine")
        replaceLine()
    end
end


--Debug function for returning transmitted VarPlayers and their values
local function detectVar(varDetected)
    --Save the configName of detected VarPlayer
    local var = varDetected.var.configName

    --Check if the var is related to the Chat Box UI, and that an NPC named "Ted" is currently loaded.
    if string.find(var,"CHAT_V3") and #NPCList.ByName("Ted") ~= 0 then
        --Set frames to wait to 3
        framesLeft = 3
        --Subscribe the waitForFilledBox function to the Draw event.
        Event.Draw.Subscribe("replaceTedLine", waitForFilledBox)
    end
end

--Event subscription for when Vars are transmitted by the game
Event.VarTransmit.Subscribe("varDetectEvent", detectVar)