-- luacheck config for the ArenaMaster PvP Inspect addon.
-- Run:  luacheck .   (regionalData/*_HORDE.lua / *_ALLIANCE.lua are multi-MB data dumps and are excluded)
std = "lua51"
max_line_length = false
codes = true
self = false

exclude_files = {
	"ArenaMasterPvPInspect/regionalData/*_HORDE.lua",
	"ArenaMasterPvPInspect/regionalData/*_ALLIANCE.lua",
	"ArenaMasterPvPInspect/regionalData/FOREVER-*.lua",
	".claude/**",
	".release/**",
}

-- Pre-existing style in this codebase: unused args / loop vars, shadowing,
-- redefined helpers, trailing whitespace, and `local x = x`. Not worth churning
-- every line for; the checks that matter here are undefined globals and
-- syntax/semantic errors.
ignore = {
	"212", -- unused argument
	"213", -- unused loop variable
	"211", -- unused local
	"231", -- local never accessed
	"311", -- value assigned to local unused
	"411", "412", "421", "422", "431", "432", -- shadowing / redefinition
	"611", "612", "613", "614", -- whitespace
	"631", -- line too long
}

-- Globals this addon defines (read + write) across files.
globals = {
	"AMPVP_DebugMode",
	"AMPVP_SettingsVar",
	"AMPVP_REGIONDATA_HORDE", "AMPVP_REGIONDATA_ALLIANCE",
	"AMPVP_REGIONDATA_US_HORDE", "AMPVP_REGIONDATA_US_ALLIANCE",
	"AMPVP_REGIONDATA_EU_HORDE", "AMPVP_REGIONDATA_EU_ALLIANCE",
	"AMPVP_REGIONDATA_KR_HORDE", "AMPVP_REGIONDATA_KR_ALLIANCE",
	"AMPVP_REGIONDATA_TW_HORDE", "AMPVP_REGIONDATA_TW_ALLIANCE",
	"AMPVP_REGIONDATA_CH_HORDE", "AMPVP_REGIONDATA_CH_ALLIANCE",
	"AMPVP_REGIONDATA_FOREVER_US_HORDE", "AMPVP_REGIONDATA_FOREVER_US_ALLIANCE",
	"AMPVP_REGIONDATA_FOREVER_EU_HORDE", "AMPVP_REGIONDATA_FOREVER_EU_ALLIANCE",
	"AMPVP_REGIONDATA_FOREVER_KR_HORDE", "AMPVP_REGIONDATA_FOREVER_KR_ALLIANCE",
	"AMPVP_REGIONDATA_FOREVER_TW_HORDE", "AMPVP_REGIONDATA_FOREVER_TW_ALLIANCE",
	"AMPVP_REGIONDATA_FOREVER_CH_HORDE", "AMPVP_REGIONDATA_FOREVER_CH_ALLIANCE",
	"AMPVP_AchievementsAndTitlesList", "AMPVP_SPECLIST", "AMPVP_REALMLIST",
	"AMPVP_friendsTTlines",
	"AMPVP_IS_FOREVER", "AMPVP_FOREVER_RULESET", "AMPVP_FOREVER_PROFILE_URL",
	"SLASH_AMPVP1", "SlashCmdList",
	-- functions declared as globals by the addon
	"AMPVP_AddDoubleLine",
	"AMPVP_AddTooltipDetails",
	"AMPVP_AddTooltipFrameText",
	"AMPVP_ColorSub",
	"AMPVP_ConvertDateToStandardEU",
	"AMPVP_ConvertRankAchievement",
	"AMPVP_ConvertStringToTable",
	"AMPVP_CreateButton",
	"AMPVP_CreateButtonText",
	"AMPVP_CreateCheckbox",
	"AMPVP_CreateCloseButton",
	"AMPVP_CreateEditBox",
	"AMPVP_CreateFrame",
	"AMPVP_CreateFrame2",
	"AMPVP_CreateTableFromString",
	"AMPVP_CreateText",
	"AMPVP_CreateText2",
	"AMPVP_FixSlangRealms",
	"AMPVP_FormatValue",
	"AMPVP_GetSettingValue",
	"AMPVP_GetValue",
	"AMPVP_IsBadReadValue",
	"AMPVP_IsTaintable",
	"AMPVP_LoginSettingsLoadSave",
	"AMPVP_Print",
	"AMPVP_PrintDebug",
	"AMPVP_RatingColorManager",
	"AMPVP_Forever_AddTooltipDetails",
	"AMPVP_Forever_AddTooltipFrameText",
	"AMPVP_ForeverKey",
	"AMPVP_ForeverRuleset",
	"AMPVP_ForeverProfileURL",
	"AMPVP_ForeverUnitName",
	"AMPVP_ForeverRegionCode",
	"AMPVP_ForeverRankInfo",
	"AMPVP_ForeverLiveInfo",
	"AMPVP_ForeverDebugDump",
	"AMPVP_ForeverSetupSettings",
	-- named frames / font strings created via CreateFrame(name) / CreateFontString(name)
	"AMPVP_SettingsUI", "AMPVP_SettingsUI_Instanced",
	"AMPVP_SettingsUITogglePVPSettingsUI", "AMPVP_SettingsUI_InstancedToggleGeneralSettingsUI",
	"AMPVP_CopyCharNameFrame2", "AMPVP_CopyCharNameFrame2InputFrameTitleText",
	"AMPVP_FriendsListTooltip", "AMPVP_FriendsListTooltipLine1", "AMPVP_LogoFrame",
	"catSubtitleTooltip", "catCurrentRating", "catCurrentSeasonStats", "catCharacterExperience", "catHighestAccRating",
	"catCharacterStats", "catSpecBrackets", "catAchievements", "catNoDataAvailable", "TitleText", "TextTitle", "cpyName",
}

-- WoW API surface used by this addon (read-only).
read_globals = {
	-- Lua/WoW string & table extensions
	"string.split", "strsplit", "wipe", "tinsert", "format", "unpack",
	-- frames / UI
	"CreateFrame", "UIParent", "FriendsFrame", "PVEFrame", "InspectFrame",
	GameTooltip = { other_fields = true, read_only = false },
	FriendsTooltip = { other_fields = true, read_only = false },
	"UISpecialFrames", "BackdropTemplateMixin", "RAID_CLASS_COLORS",
	"TooltipDataProcessor", "Enum", "Menu", "hooksecurefunc",
	"GetMouseFocus", "GetMouseFoci", "LFGListSearchEntry_OnEnter", "LFGListApplicantMember_OnEnter",
	-- addon / build
	"C_AddOns", "LoadAddOn", "IsAddOnLoaded", "GetBuildInfo", "WOW_PROJECT_ID",
	"WOW_PROJECT_MAINLINE", "WOW_PROJECT_CLASSIC", "WOW_PROJECT_CAMELOT", "WOW_PROJECT_FOREVER",
	"LE_EXPANSION_LEVEL_CURRENT", "LE_EXPANSION_CLASSIC", "GetTime", "LOCALIZED_CLASS_NAMES_MALE",
	-- units / realm / region
	"GetCurrentRegion", "GetRealmName", "GetNormalizedRealmName", "UnitName", "UnitNameUnmodified",
	"UnitFullName", "UnitIsPlayer", "UnitGUID", "UnitAffectingCombat", "UnitLevel", "UnitClass",
	"UnitFactionGroup", "UnitPVPRank", "UnitIsUnit", "UnitExists", "GetUnitName", "UnitHonorLevel", "UnitHonor",
	"IsInInstance", "InCombatLockdown", "issecretvalue", "C_Timer", "C_ClassColor",
	-- Classic honor system / inspect
	"GetPVPRankInfo", "GetPVPRankProgress", "GetPVPLifetimeStats", "GetPVPThisWeekStats",
	"GetPVPLastWeekStats", "GetPVPYesterdayStats", "GetPVPSessionStats",
	"NotifyInspect", "CanInspect", "ClearInspectPlayer", "CheckInteractDistance",
	"RequestInspectHonorData", "HasInspectHonorData", "GetInspectHonorData",
	"C_PvP",
	-- LFG / BNet
	"C_LFGList", "C_BattleNet", "BNGetFriendInfo",
}

-- The realm list is a merged EU+US table, so the same realm name legitimately
-- appears twice (W314 duplicate key).
files["ArenaMasterPvPInspect/regionalData/realmlist.lua"] = { ignore = { "314" } }
