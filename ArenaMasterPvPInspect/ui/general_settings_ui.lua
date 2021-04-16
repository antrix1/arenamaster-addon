AMPVP_CreateFrame2("AMPVP_SettingsUI", UIParent, "CENTER", 0, 0, 420, 580, 0.6, true)
AMPVP_CreateText("TitleText", AMPVP_SettingsUI, "TOP", 0, -30, "[ArenaMaster] - General Settings Panel")
AMPVP_CreateCloseButton(AMPVP_SettingsUI)
--Current Rating
AMPVP_CreateText("catSubtitleTooltip", AMPVP_SettingsUI, "TOPLEFT", 15, -75, "Tooltip")
AMPVP_CreateText("catCurrentRating", AMPVP_SettingsUI, "TOPLEFT", 25, -100, "Current Rating:")
AMPVP_CreateCheckbox("CURR_RATING_2s", AMPVP_SettingsUI, "TOPLEFT", 25, -115, "Display 2v2 Rating")
AMPVP_CreateCheckbox("CURR_RATING_3s", AMPVP_SettingsUI, "TOPLEFT", 25, -140, "Display 3v3 Rating")
AMPVP_CreateCheckbox("CURR_RATING_RBG", AMPVP_SettingsUI, "TOPLEFT", 25, -165, "Display RBG Rating")
--Current Season Stats
AMPVP_CreateText("catCurrentSeasonStats", AMPVP_SettingsUI, "TOPLEFT", 25, -215, "Current Season Stats:")
AMPVP_CreateCheckbox("CURR_SEASON_2SW", AMPVP_SettingsUI, "TOPLEFT", 25, -230, "Display 2v2 Wins")
AMPVP_CreateCheckbox("CURR_SEASON_3SW", AMPVP_SettingsUI, "TOPLEFT", 25, -255, "Display 3v3 Wins")
AMPVP_CreateCheckbox("CURR_SEASON_RBGW", AMPVP_SettingsUI, "TOPLEFT", 25, -280, "Display RBG Wins")
AMPVP_CreateCheckbox("CURR_SEASON_TITLES", AMPVP_SettingsUI, "TOPLEFT", 25, -305, "Display Titles")
--Character Experience
AMPVP_CreateText("catCharacterExperience", AMPVP_SettingsUI, "TOPRIGHT", -50, -100, "Character Experience:")
AMPVP_CreateCheckbox("CHAR_EXP_2s", AMPVP_SettingsUI, "TOPRIGHT", -150, -115, "Display 2v2 Exp")
AMPVP_CreateCheckbox("CHAR_EXP_3s", AMPVP_SettingsUI, "TOPRIGHT", -150, -140, "Display 3v3 Exp")
AMPVP_CreateCheckbox("CHAR_EXP_RBG", AMPVP_SettingsUI, "TOPRIGHT", -150, -165, "Display RBG Exp")
--Highest Account Rating
AMPVP_CreateText("catHighestAccRating", AMPVP_SettingsUI, "TOPRIGHT", -30, -215, "Highest Account Rating:")
AMPVP_CreateCheckbox("HIGHEST_ACC_2s", AMPVP_SettingsUI, "TOPRIGHT", -150, -230, "Display 2v2 Rating")
AMPVP_CreateCheckbox("HIGHEST_ACC_3s", AMPVP_SettingsUI, "TOPRIGHT", -150, -255, "Display 3v3 Rating")
AMPVP_CreateCheckbox("HIGHEST_ACC_RBG", AMPVP_SettingsUI, "TOPRIGHT", -150, -280, "Display RBG Rating")
--Character Stats
AMPVP_CreateText("catCharacterStats", AMPVP_SettingsUI, "TOPLEFT", 25, -350, "Character Stats:")
AMPVP_CreateCheckbox("STATS_ITEMLEVEL", AMPVP_SettingsUI, "TOPLEFT", 25, -365, "Display Item Level")
AMPVP_CreateCheckbox("STATS_VERSATILITY", AMPVP_SettingsUI, "TOPLEFT", 25, -390, "Display Versatility")
AMPVP_CreateCheckbox("STATS_COVENANT", AMPVP_SettingsUI, "TOPLEFT", 25, -415, "Display Covenant")
AMPVP_CreateCheckbox("STATS_RENOWN", AMPVP_SettingsUI, "TOPLEFT", 25, -440, "Display Renown Level")
AMPVP_CreateCheckbox("STATS_HEALTH", AMPVP_SettingsUI, "TOPLEFT", 25, -465, "Display Health")
--Achievements
AMPVP_CreateText("catAchievements", AMPVP_SettingsUI, "TOPRIGHT", -90, -350, "Achievements:")
AMPVP_CreateCheckbox("ACHI_SHOW", AMPVP_SettingsUI, "TOPRIGHT", -150, -365, "Display Achievements")
--disable tooltip
AMPVP_CreateText("catNoDataAvailable", AMPVP_SettingsUI, "TOPRIGHT", -45, -410, "Remove tooltip when:")
AMPVP_CreateCheckbox("DISABLE_EMPTY_DATA", AMPVP_SettingsUI, "TOPRIGHT", -150, -425, "No data available")
AMPVP_CreateCheckbox("DISABLE_RAIDS_DUNGEONS", AMPVP_SettingsUI, "TOPRIGHT", -150, -450, "In dungeons/raids")
AMPVP_CreateCheckbox("DISABLE_IN_COMBATENV", AMPVP_SettingsUI, "TOPRIGHT", -150, -475, "In combat")
AMPVP_CreateCheckbox("DISABLE_IN_PVPENV", AMPVP_SettingsUI, "TOPRIGHT", -150, -500, "In arenas/battlegrounds")
AMPVP_CreateButton("TogglePVPSettingsUI", AMPVP_SettingsUI, "BOTTOM", 0, 20, 200, 20, "Arena/Battleground Settings")

local function AMPVP_UpdateSettingsUIBoxes()

	local db = AMPVP_SettingsVar

	if db == nil then
		return
	end

	for settingName, value in pairs(db) do
		local frame = _G["AMPVP_SettingsUI"..settingName]
		if frame ~= nil then
			frame:SetChecked(value)
			frame:SetScript("OnClick", function()
				AMPVP_SettingsVar[settingName] = frame:GetChecked()
			end)
		end
	end

	for settingName, value in pairs(db) do
		local frame = _G["AMPVP_SettingsUI_Instanced"..settingName]
		if frame ~= nil then
			frame:SetChecked(value)
			frame:SetScript("OnClick", function()
				AMPVP_SettingsVar[settingName] = frame:GetChecked()
			end)
		end
	end

	if db ~= nil and db.addonInitialized then
		AMPVP_SettingsUI:Hide()
	end

	if not db.addonInitialized then
		AMPVP_SettingsVar.addonInitialized = true
	end

	AMPVP_Print("|cff0033ccTo customize the tooltip and data you're interested in, type |r"..AMPVP_ColorSub("'/ampvp'", "green").."|cff0033cc in the chat window to open the settings panel.|r");

end

local frameInitSettings = CreateFrame("frame")
frameInitSettings:RegisterEvent("PLAYER_LOGIN")
frameInitSettings:SetScript("OnEvent", AMPVP_UpdateSettingsUIBoxes)
