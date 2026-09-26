-- WoW: Forever settings panel adjustments and slash-command diagnostics.
-- Loaded after ui/ui.lua on every flavor; does nothing unless AMPVP_IS_FOREVER.

if not AMPVP_IS_FOREVER then return end

-- Retail-only sections hidden on Forever (no arena / RBG / per-spec brackets,
-- no versatility, no rated titles or achievements in the Forever export).
local RETAIL_ONLY_CHECKBOXES = {
	"CURR_RATING_2s", "CURR_RATING_3s", "CURR_RATING_RBG",
	"CURR_SEASON_2SW", "CURR_SEASON_3SW", "CURR_SEASON_RBGW", "CURR_SEASON_TITLES",
	"CHAR_EXP_2s", "CHAR_EXP_3s", "CHAR_EXP_RBG",
	"HIGHEST_ACC_2s", "HIGHEST_ACC_3s", "HIGHEST_ACC_RBG",
	"STATS_VERSATILITY", "SOLO_SHUFFLE", "BLITZ", "ACHI_SHOW",
}

local RETAIL_ONLY_LABELS = {
	["Current Rating:"] = true,
	["Current Season Stats:"] = true,
	["Character Experience:"] = true,
	["Highest Account Rating:"] = true,
	["Per-Spec Brackets:"] = true,
	["Achievements:"] = true,
}

local function AMPVP_ForeverTrimPanel(panel, prefix, keyPrefix)
	for _, key in ipairs(RETAIL_ONLY_CHECKBOXES) do
		local box = _G[prefix .. keyPrefix .. key]
		if box then box:Hide() end
	end

	for _, region in ipairs({ panel:GetRegions() }) do
		if region.GetObjectType and region:GetObjectType() == "FontString" and RETAIL_ONLY_LABELS[region:GetText()] then
			region:Hide()
		end
	end
end

AMPVP_ForeverTrimPanel(AMPVP_SettingsUI, "AMPVP_SettingsUI", "")
AMPVP_ForeverTrimPanel(AMPVP_SettingsUI_Instanced, "AMPVP_SettingsUI_Instanced", "INST_")

-- Forever section, in the space the Current Rating block used to occupy.
AMPVP_CreateText("catForever", AMPVP_SettingsUI, "TOPLEFT", 25, -100, "WoW: Forever")
AMPVP_CreateCheckbox("FOREVER_LEVEL_CLASS", AMPVP_SettingsUI, "TOPLEFT", 25, -115, "Display Level and Class")
AMPVP_CreateCheckbox("FOREVER_HONOR_RANK", AMPVP_SettingsUI, "TOPLEFT", 25, -140, "Display Honor Rank")
AMPVP_CreateCheckbox("FOREVER_HONOR_KILLS", AMPVP_SettingsUI, "TOPLEFT", 25, -165, "Display Honorable Kills")
AMPVP_CreateCheckbox("FOREVER_INSPECT", AMPVP_SettingsUI, "TOPLEFT", 25, -190, "Inspect hovered players for honor")

AMPVP_CreateText("catForeverInst", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -100, "WoW: Forever")
AMPVP_CreateCheckbox("INST_FOREVER_LEVEL_CLASS", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -115, "Display Level and Class")
AMPVP_CreateCheckbox("INST_FOREVER_HONOR_RANK", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -140, "Display Honor Rank")
AMPVP_CreateCheckbox("INST_FOREVER_HONOR_KILLS", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -165, "Display Honorable Kills")

-- Defaults must exist before the general panel binds its checkboxes at
-- PLAYER_LOGIN; bind ours here as well so the result does not depend on the
-- order the login handlers run in.
local function AMPVP_ForeverBindSettings()
	AMPVP_ForeverSetupSettings()

	for _, prefix in ipairs({ "AMPVP_SettingsUI", "AMPVP_SettingsUI_Instanced" }) do
		for _, key in ipairs({ "FOREVER_LEVEL_CLASS", "FOREVER_HONOR_RANK", "FOREVER_HONOR_KILLS", "FOREVER_INSPECT",
			"INST_FOREVER_LEVEL_CLASS", "INST_FOREVER_HONOR_RANK", "INST_FOREVER_HONOR_KILLS" }) do
			local frame = _G[prefix .. key]
			if frame ~= nil then
				frame:SetChecked(AMPVP_SettingsVar[key])
				frame:SetScript("OnClick", function()
					AMPVP_SettingsVar[key] = frame:GetChecked()
				end)
			end
		end
	end
end

local foreverInit = CreateFrame("frame")
foreverInit:RegisterEvent("PLAYER_LOGIN")
foreverInit:SetScript("OnEvent", AMPVP_ForeverBindSettings)

-- `/ampvp key` prints the beta diagnostics; everything else falls through to
-- the retail handler.
local retailSlashHandler = SlashCmdList["AMPVP"]
SlashCmdList["AMPVP"] = function(msg)
	local cmp = string.lower(msg or "")
	if cmp == "key" or cmp == "forever" then
		AMPVP_ForeverDebugDump()
		return
	end
	retailSlashHandler(msg)
end
