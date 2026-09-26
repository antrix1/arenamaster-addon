-- WoW: Forever (Classic+, codename "Camelot", client 1.60.x, ## Interface: 16001).
--
-- Forever runs the modern addon API on top of Classic-era game systems: no arena,
-- no rated battlegrounds (until the 2027 PvP refresh), a 14-rank honor system, no
-- realms (a Normal / PvP / RP ruleset instead) and two-part character names
-- ("Firstname Lastname"). The retail tooltip is therefore meaningless there.
--
-- Everything Forever-specific lives in this file and in ui/forever_ui.lua, and
-- every runtime branch elsewhere is guarded by AMPVP_IS_FOREVER. On a retail
-- client this file only sets the flag to false and defines helpers nobody calls,
-- so retail behaviour is unchanged.
--
-- Data contract with the website exporter (AddonExport on the main repo):
--   file    regionalData/FOREVER-<REGION>_<FACTION>.lua   (listed only in the *_Camelot DB TOCs)
--   table   AMPVP_REGIONDATA_FOREVER_<REGION>_<FACTION>
--   key     "<Firstname Lastname>-<ruleset>"   e.g. ["Thrall Durotan-pvp"]
--           name exactly as the client returns it (case preserved, single spaces --
--           the same convention as retail's "Name-Realm"; Lua's string.lower is
--           ASCII-only so lowercasing would break accented names), ruleset one of
--           "normal" | "pvp" | "rp" (see AMPVP_ForeverRuleset).
--   entry   { lv=60, cl="WARRIOR", hr=10, hk=1234, p=true, ua="d/m/yy" }
--           lv level, cl class file name, hr honor rank 1..14, hk lifetime honorable
--           kills, p Patreon supporter, ua last updated. Every field optional; 0 and
--           "" read as absent (AMPVP_IsBadReadValue), like the retail schema.

local function AMPVP_DetectForever()
	-- There is no WOW_PROJECT_CAMELOT / WOW_PROJECT_FOREVER constant (the wiki's
	-- WOW_PROJECT_ID page lists seven values and identifies Forever as the
	-- mainline project running the Classic expansion level:
	-- https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID). Accept a dedicated constant
	-- should one appear, then that pairing, then the interface number as the
	-- last resort -- it is unambiguous: Classic Era is 115xx, TBC 205xx, Forever
	-- 16xxx.
	local projectId = WOW_PROJECT_ID
	local foreverId = WOW_PROJECT_CAMELOT or WOW_PROJECT_FOREVER
	if projectId ~= nil and foreverId ~= nil and projectId == foreverId then
		return true
	end

	if projectId ~= nil and projectId == WOW_PROJECT_MAINLINE
		and LE_EXPANSION_LEVEL_CURRENT ~= nil and LE_EXPANSION_CLASSIC ~= nil
		and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC then
		return true
	end

	local interfaceVersion = tonumber((select(4, GetBuildInfo())))
	return interfaceVersion ~= nil and interfaceVersion >= 16000 and interfaceVersion < 20000
end

AMPVP_IS_FOREVER = AMPVP_DetectForever()

-- Profile URL on arenamaster.io for a Forever character. The website route does
-- not exist yet; this is the proposed shape (region, ruleset, "firstname-lastname").
AMPVP_FOREVER_PROFILE_URL = "https://arenamaster.io/forever/%s/%s/%s?ref=addon"

local FOREVER_REGION_CODES = {
	[1] = "US",
	[2] = "KR",
	[3] = "EU",
	[4] = "TW",
	[5] = "CH",
}

-- Honor rank colours, tiered like the retail rating colours.
local FOREVER_RANK_COLORS = {
	[1] = "|cffffffff", [2] = "|cffffffff", [3] = "|cffffffff", [4] = "|cffffffff",
	[5] = "|cff27ae60", [6] = "|cff27ae60", [7] = "|cff27ae60", [8] = "|cff27ae60",
	[9] = "|cff0070dd", [10] = "|cff0070dd",
	[11] = "|cffa335ee", [12] = "|cffa335ee", [13] = "|cffa335ee",
	[14] = "|cffff8000",
}

-- Fallback rank names if GetPVPRankInfo is unavailable on this client.
local FOREVER_RANK_NAMES = {
	Alliance = {
		"Private", "Corporal", "Sergeant", "Master Sergeant", "Sergeant Major",
		"Knight", "Knight-Lieutenant", "Knight-Captain", "Knight-Champion",
		"Lieutenant Commander", "Commander", "Marshal", "Field Marshal", "Grand Marshal",
	},
	Horde = {
		"Scout", "Grunt", "Sergeant", "Senior Sergeant", "First Sergeant",
		"Stone Guard", "Blood Guard", "Legionnaire", "Centurion",
		"Champion", "Lieutenant General", "General", "Warlord", "High Warlord",
	},
}

-- Settings keys added by the Forever flavor (both panels; INST_ prefix for
-- arenas/battlegrounds). FOREVER_INSPECT is open-world only.
local FOREVER_SETTING_DEFAULTS = {
	FOREVER_LEVEL_CLASS = true,
	FOREVER_HONOR_RANK = true,
	FOREVER_HONOR_KILLS = true,
	FOREVER_INSPECT = true,
	INST_FOREVER_LEVEL_CLASS = true,
	INST_FOREVER_HONOR_RANK = true,
	INST_FOREVER_HONOR_KILLS = true,
}

-- 12.0 marks some unit values inside instances as "secret values" that cannot be
-- compared, concatenated or used as table keys. Treat them as absent.
local function AMPVP_Unsecret(value)
	if value ~= nil and issecretvalue and issecretvalue(value) then
		return nil
	end
	return value
end

local function AMPVP_HasFunction(name)
	return type(_G[name]) == "function"
end

local function AMPVP_FormatThousands(number)
	local s = tostring(number)
	local formatted = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	return (formatted:gsub("^,", ""))
end

function AMPVP_ForeverRegionCode(region)
	return FOREVER_REGION_CODES[region]
end

-- The ruleset a name belongs to. Forever has no realms; what GetRealmName()
-- returns there is not documented (the ruleset name? a fixed label? ""?), so
-- derive the ruleset from whatever the client hands us and default to "normal".
-- Verify with `/ampvp key` on the beta client.
function AMPVP_ForeverRuleset(realmHint)
	local src = AMPVP_Unsecret(realmHint)

	if src == nil or src == "" then
		src = (GetNormalizedRealmName and GetNormalizedRealmName()) or GetRealmName() or ""
	end

	src = string.lower(tostring(src))
	src = (src:gsub("[%s%-_]", ""))

	if src:find("pvp", 1, true) then
		return "pvp"
	end

	if src == "rp" or src:find("roleplay", 1, true) or src:find("^rp") or src:find("rp$") then
		return "rp"
	end

	return "normal"
end

-- True if `part` is a realm / ruleset label rather than a name part.
local function AMPVP_ForeverIsRealmLike(part)
	if part == nil or part == "" then return true end
	if part == GetRealmName() then return true end
	if GetNormalizedRealmName and part == GetNormalizedRealmName() then return true end
	local lowered = string.lower(part)
	return lowered:find("pvp", 1, true) ~= nil or lowered == "rp" or lowered == "normal"
		or lowered:find("roleplay", 1, true) ~= nil or lowered:find("hardcore", 1, true) ~= nil
end

-- Splits "Something-Rest" into the full name and the ruleset hint. Beta reports
-- suggest UnitName() on Forever returns the first name with the surname in the
-- realm slot (https://github.com/Offroads/WoWForeverRace/issues/33), so the
-- retail hooks will hand us "Firstname-Lastname" as well as "Name-<realm>". If
-- the part after the dash is not a realm-like label, it is the surname.
local function AMPVP_ForeverSplitName(name, realmHint)
	local base, hint = name, nil
	local rest = nil
	local dash = string.find(base, "-", 1, true)
	if dash then
		rest = string.sub(base, dash + 1)
		base = string.sub(base, 1, dash - 1)
	end

	-- Both the part after the dash and the separate realm argument can be a
	-- ruleset label or the surname; the surname is appended once.
	local function absorb(part)
		if part == nil or part == "" then return end
		if AMPVP_ForeverIsRealmLike(part) then
			hint = hint or part
		elseif not (" " .. base .. " "):find(" " .. part .. " ", 1, true) then
			base = base .. " " .. part
		end
	end
	absorb(rest)
	absorb(realmHint)

	base = base:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
	return base, hint
end

-- Lookup key for the Forever data tables. Accepts either a bare name
-- ("Thrall Durotan") or the "Name-Realm" concatenation the retail hooks build.
function AMPVP_ForeverKey(name, realmHint)
	name = AMPVP_Unsecret(name)
	if type(name) ~= "string" or name == "" then return nil end

	local base, hint = AMPVP_ForeverSplitName(name, AMPVP_Unsecret(realmHint))
	if base == "" then return nil end

	return base .. "-" .. AMPVP_ForeverRuleset(hint)
end

-- Best-effort full name for a unit. Whether UnitName returns both name parts on
-- Forever is one of the beta-client questions; GetUnitName(unit, true) is
-- reported to return the full "Firstname Lastname", so try it first and fall
-- back to UnitName with the surname-in-realm-slot heuristic above.
function AMPVP_ForeverUnitName(unit)
	if AMPVP_HasFunction("GetUnitName") then
		local full = AMPVP_Unsecret(GetUnitName(unit, true))
		if type(full) == "string" and full ~= "" then
			local base = AMPVP_ForeverSplitName(full)
			if base ~= "" then return base end
		end
	end

	local name, realm = UnitName(unit)
	name, realm = AMPVP_Unsecret(name), AMPVP_Unsecret(realm)
	if type(name) ~= "string" or name == "" then return nil end

	local base = AMPVP_ForeverSplitName(name, realm)
	if base == "" then return nil end
	return base
end

function AMPVP_ForeverProfileURL(name, realmHint, regionSlug)
	name = AMPVP_Unsecret(name)
	if type(name) ~= "string" or name == "" or not regionSlug then return nil end

	local base, hint = AMPVP_ForeverSplitName(name, AMPVP_Unsecret(realmHint))
	local slug = (string.lower(base):gsub("%s+", "-"))
	if slug == "" then return nil end

	return string.format(AMPVP_FOREVER_PROFILE_URL, regionSlug, AMPVP_ForeverRuleset(hint), slug)
end

-- Honor rank of a unit: rankNumber (1..14), rankName. Classic's UnitPVPRank
-- returns 0 for unranked and 5..18 for ranks 1..14
-- (https://warcraft.wiki.gg/wiki/API_UnitPVPRank); GetPVPRankInfo(rankID [,
-- faction]) maps that id to a name and the 1..14 number, faction 0 = Horde,
-- 1 = Alliance (https://warcraft.wiki.gg/wiki/API_GetPVPRankInfo).
function AMPVP_ForeverRankInfo(unit)
	if not AMPVP_HasFunction("UnitPVPRank") then return nil end

	local rankId = AMPVP_Unsecret(UnitPVPRank(unit))
	if type(rankId) ~= "number" or rankId <= 0 then return nil end

	local rankName, rankNumber
	if AMPVP_HasFunction("GetPVPRankInfo") then
		local factionIndex = (AMPVP_Unsecret(UnitFactionGroup(unit)) == "Horde") and 0 or 1
		rankName, rankNumber = GetPVPRankInfo(rankId, factionIndex)
	end

	if type(rankNumber) ~= "number" or rankNumber <= 0 then
		rankNumber = rankId - 4
	end

	if rankNumber < 1 or rankNumber > 14 then return nil end

	if type(rankName) ~= "string" or rankName == "" then
		local faction = AMPVP_Unsecret(UnitFactionGroup(unit)) or "Alliance"
		local names = FOREVER_RANK_NAMES[faction] or FOREVER_RANK_NAMES.Alliance
		rankName = names[rankNumber]
	end

	return rankNumber, rankName
end

local function AMPVP_ForeverRankText(rankNumber, rankName)
	local color = FOREVER_RANK_COLORS[rankNumber] or "|cffffffff"
	local badge = string.format("|TInterface\\PvPRankBadges\\PvPRank%02d:14:14:0:0|t ", rankNumber)
	return badge .. color .. "Rank " .. rankNumber .. " " .. (rankName or "") .. "|r"
end

local function AMPVP_ForeverClassText(className, classFile)
	if not className then return nil end
	local color = classFile and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFile]
	if color and color.colorStr then
		return "|c" .. color.colorStr .. className .. "|r"
	end
	return AMPVP_ColorSub(className, "white")
end

------------------------------------------------------------------------
-- Inspect-driven honor data (honorable kills, this week's honor)
--
-- Lifetime / weekly stats are only readable for the player directly
-- (GetPVPLifetimeStats / GetPVPThisWeekStats). For other players Classic exposes
-- today / yesterday / lifetime through the inspect honor flow:
-- NotifyInspect(unit) -> RequestInspectHonorData() -> INSPECT_HONOR_UPDATE ->
-- GetInspectHonorData() (https://warcraft.wiki.gg/wiki/API_GetInspectHonorData).
-- Whether Forever kept those functions is a beta question; every call is guarded,
-- and the whole path is off if the client lacks any of them.
------------------------------------------------------------------------

local honorCache = {}          -- guid => { hk=, weekHK=, weekHonor=, todayHK=, todayHonor=, t= }
local honorPending = nil       -- { guid=, unit=, t= }
local HONOR_CACHE_TTL = 120    -- seconds
local HONOR_REQUEST_COOLDOWN = 2

local function AMPVP_ForeverInspectAvailable()
	return AMPVP_HasFunction("NotifyInspect")
		and AMPVP_HasFunction("RequestInspectHonorData")
		and AMPVP_HasFunction("GetInspectHonorData")
end

local function AMPVP_ForeverPlayerHonor()
	local data = { fromLive = true }

	if AMPVP_HasFunction("GetPVPLifetimeStats") then
		-- lifetimeHonorableKills, lifetimeMaxPVPRank
		data.hk = AMPVP_Unsecret((GetPVPLifetimeStats()))
	end

	if AMPVP_HasFunction("GetPVPThisWeekStats") then
		local weekHK, weekHonor = GetPVPThisWeekStats()
		data.weekHK = AMPVP_Unsecret(weekHK)
		data.weekHonor = AMPVP_Unsecret(weekHonor)
	end

	return data
end

local function AMPVP_ForeverCanRequestInspect(unit)
	if not AMPVP_ForeverInspectAvailable() then return false end
	if InCombatLockdown() then return false end
	if InspectFrame and InspectFrame:IsShown() then return false end
	if AMPVP_HasFunction("CanInspect") and not CanInspect(unit) then return false end
	if AMPVP_HasFunction("CheckInteractDistance") and not CheckInteractDistance(unit, 1) then return false end
	if honorPending and (GetTime() - honorPending.t) < HONOR_REQUEST_COOLDOWN then return false end
	return true
end

-- Returns cached honor data for the unit, requesting it if needed.
local function AMPVP_ForeverUnitHonor(unit, guid)
	if UnitIsUnit(unit, "player") then
		return AMPVP_ForeverPlayerHonor()
	end

	if not guid then return nil end

	local cached = honorCache[guid]
	if cached and (GetTime() - cached.t) < HONOR_CACHE_TTL then
		return cached
	end

	if AMPVP_GetSettingValue("FOREVER_INSPECT") and AMPVP_ForeverCanRequestInspect(unit) then
		honorPending = { guid = guid, unit = unit, t = GetTime() }
		NotifyInspect(unit)
		RequestInspectHonorData()
	end

	return nil
end

local function AMPVP_ForeverAppendHonorLines(data, addLine, skipLifetime)
	if not data then return false end

	local added = false

	if data.hk and data.hk > 0 and not skipLifetime then
		addLine(AMPVP_ColorSub("Honorable Kills", "white"), AMPVP_ColorSub(AMPVP_FormatThousands(data.hk), "white"))
		added = true
	end

	if data.weekHK and data.weekHK > 0 then
		local right = AMPVP_FormatThousands(data.weekHK) .. " HKs"
		if data.weekHonor and data.weekHonor > 0 then
			right = right .. ", " .. AMPVP_FormatThousands(data.weekHonor) .. " Honor"
		end
		addLine(AMPVP_ColorSub("This Week", "white"), AMPVP_ColorSub(right, "white"))
		added = true
	elseif data.todayHK and data.todayHK > 0 then
		local right = AMPVP_FormatThousands(data.todayHK) .. " HKs"
		if data.todayHonor and data.todayHonor > 0 then
			right = right .. ", " .. AMPVP_FormatThousands(data.todayHonor) .. " Honor"
		end
		addLine(AMPVP_ColorSub("Today", "white"), AMPVP_ColorSub(right, "white"))
		added = true
	end

	return added
end

local function AMPVP_ForeverOnHonorUpdate()
	if not honorPending then return end

	local pending = honorPending
	honorPending = nil

	local todayHK, todayHonor, _, _, lifetimeHK = GetInspectHonorData()
	local data = {
		hk = AMPVP_Unsecret(lifetimeHK),
		todayHK = AMPVP_Unsecret(todayHK),
		todayHonor = AMPVP_Unsecret(todayHonor),
		fromLive = true,
		t = GetTime(),
	}
	honorCache[pending.guid] = data

	-- Leave the inspect target alone if the player opened the inspect window.
	if AMPVP_HasFunction("ClearInspectPlayer") and not (InspectFrame and InspectFrame:IsShown()) then
		ClearInspectPlayer()
	end

	-- If the tooltip still shows this unit and already carries our block, append
	-- the freshly arrived lines once instead of rebuilding the whole tooltip
	-- (skipping the lifetime line if the bundled data already provided it).
	local state = GameTooltip.ampvpForeverHonorState
	local _, unit = GameTooltip:GetUnit()
	if unit and state and state.guid == pending.guid and not state.liveShown
		and GameTooltip:IsShown() and GameTooltip.ampvpHooked
		and AMPVP_Unsecret(UnitGUID(unit)) == pending.guid
		and AMPVP_GetSettingValue(IsInInstance() and "INST_FOREVER_HONOR_KILLS" or "FOREVER_HONOR_KILLS") then
		local added = AMPVP_ForeverAppendHonorLines(data, function(left, right)
			GameTooltip:AddDoubleLine(left, right)
		end, state.hkShown)
		if added then
			state.liveShown = true
			GameTooltip:Show()
		end
	end
end

if AMPVP_IS_FOREVER and AMPVP_ForeverInspectAvailable() then
	local honorFrame = CreateFrame("frame")
	-- RegisterEvent raises on an unknown event name; the event may not exist on
	-- this client even if the functions do.
	local ok = pcall(honorFrame.RegisterEvent, honorFrame, "INSPECT_HONOR_UPDATE")
	if ok then
		honorFrame:SetScript("OnEvent", AMPVP_ForeverOnHonorUpdate)
	end
end

------------------------------------------------------------------------
-- Live (unit API) info: level, class, honor rank
------------------------------------------------------------------------

function AMPVP_ForeverLiveInfo(unit)
	if not unit or not UnitExists(unit) or not UnitIsPlayer(unit) then return nil end

	local info = {}

	local level = AMPVP_Unsecret(UnitLevel(unit))
	if type(level) == "number" and level > 0 then
		info.level = level
	end

	local className, classFile = UnitClass(unit)
	info.className = AMPVP_Unsecret(className)
	info.classFile = AMPVP_Unsecret(classFile)

	info.rankNumber, info.rankName = AMPVP_ForeverRankInfo(unit)
	info.guid = AMPVP_Unsecret(UnitGUID(unit))
	info.faction = AMPVP_Unsecret(UnitFactionGroup(unit))

	return info
end

------------------------------------------------------------------------
-- Tooltip rendering
------------------------------------------------------------------------

local patreonTooltipSpacing = 14

local function AMPVP_ForeverSetting(key, inInstance)
	if inInstance then
		return AMPVP_GetSettingValue("INST_" .. key)
	end
	return AMPVP_GetSettingValue(key)
end

-- Resolve the DB entry for a name, preferring the faction we know about.
-- Returns the entry and the faction whose table it came from.
local function AMPVP_ForeverLookup(userName, faction)
	local key = AMPVP_ForeverKey(userName)
	if not key then return nil end

	local horde = AMPVP_REGIONDATA_HORDE or {}
	local alliance = AMPVP_REGIONDATA_ALLIANCE or {}

	if faction == "Alliance" then
		if alliance[key] then return alliance[key], "Alliance" end
		if horde[key] then return horde[key], "Horde" end
	else
		if horde[key] then return horde[key], "Horde" end
		if alliance[key] then return alliance[key], "Alliance" end
	end

	return nil
end

-- Builds the Forever info block. `addLine(text)` and `addDoubleLine(left, right)`
-- abstract over GameTooltip vs. the Battle.net friends frame.
local function AMPVP_ForeverBuildBlock(userName, unit, addLine, addDoubleLine)
	local inInstance = IsInInstance()
	local live = unit and AMPVP_ForeverLiveInfo(unit) or nil
	local entry, entryFaction = AMPVP_ForeverLookup(userName, live and live.faction)
	local faction = (live and live.faction) or entryFaction or "Alliance"

	local showLevel = AMPVP_ForeverSetting("FOREVER_LEVEL_CLASS", inInstance)
	local showRank = AMPVP_ForeverSetting("FOREVER_HONOR_RANK", inInstance)
	local showKills = AMPVP_ForeverSetting("FOREVER_HONOR_KILLS", inInstance)

	local level = (live and live.level) or (entry and AMPVP_GetValue(entry, "lv"))
	local className, classFile = live and live.className, live and live.classFile
	if not className and entry then
		classFile = AMPVP_GetValue(entry, "cl")
		if classFile and LOCALIZED_CLASS_NAMES_MALE then
			className = LOCALIZED_CLASS_NAMES_MALE[classFile]
		end
		className = className or classFile
	end

	local rankNumber, rankName = live and live.rankNumber, live and live.rankName
	if not rankNumber and entry then
		rankNumber = AMPVP_GetValue(entry, "hr")
		if rankNumber then
			local names = FOREVER_RANK_NAMES[faction] or FOREVER_RANK_NAMES.Alliance
			rankName = names[rankNumber]
		end
	end

	local honor = nil
	if showKills then
		if unit and live then
			honor = AMPVP_ForeverUnitHonor(unit, live.guid)
		end
		if (not honor or not honor.hk) and entry then
			local hk = AMPVP_GetValue(entry, "hk")
			if hk then
				honor = honor or {}
				honor.hk = honor.hk or hk
			end
		end
	end

	local hasLevelLine = showLevel and (level or className)
	local hasRankLine = showRank and rankNumber
	local hasHonorLine = showKills and honor and ((honor.hk and honor.hk > 0) or (honor.weekHK and honor.weekHK > 0) or (honor.todayHK and honor.todayHK > 0))

	if not entry and not hasLevelLine and not hasRankLine and not hasHonorLine then
		return false
	end

	local spacesTitle = " "
	for _ = 1, patreonTooltipSpacing - 5 do
		spacesTitle = spacesTitle .. " "
	end
	addLine(spacesTitle .. "|cffc72429ArenaMaster.IO PvP Info: |r")

	if entry and AMPVP_GetValue(entry, "p") then
		local spaces = " "
		for _ = 1, patreonTooltipSpacing do
			spaces = spaces .. " "
		end
		addLine(" ")
		addLine("|cfff0ce56" .. spaces .. "Patreon Supporter|r")
		addLine(spaces .. "**************")
	end

	if hasLevelLine then
		local right = ""
		if level then right = tostring(level) end
		local classText = AMPVP_ForeverClassText(className, classFile)
		if classText then
			right = (right ~= "" and (right .. " ") or "") .. classText
		end
		addDoubleLine(AMPVP_ColorSub("Level", "white"), right)
	end

	if hasRankLine then
		addDoubleLine(AMPVP_ColorSub("Honor Rank", "white"), AMPVP_ForeverRankText(rankNumber, rankName))
	end

	if hasHonorLine then
		AMPVP_ForeverAppendHonorLines(honor, addDoubleLine)
	end

	-- Remember what the GameTooltip shows for this unit so a late
	-- INSPECT_HONOR_UPDATE can append just the missing lines.
	if unit and live and live.guid then
		GameTooltip.ampvpForeverHonorState = {
			guid = live.guid,
			hkShown = (hasHonorLine and honor.hk and honor.hk > 0) and true or false,
			liveShown = (hasHonorLine and honor.fromLive) and true or false,
		}
	end

	local lastUpdated = entry and AMPVP_GetValue(entry, "ua")
	if lastUpdated then
		addLine(" ")
		addDoubleLine("Last Updated:", AMPVP_ColorSub(AMPVP_ConvertDateToStandardEU(lastUpdated), "white"))
	end

	return true
end

-- GameTooltip variant. Same signature as AMPVP_AddTooltipDetails, which
-- delegates here when AMPVP_IS_FOREVER.
function AMPVP_Forever_AddTooltipDetails(userName, addSpacePlus, frameOwner, ownerAnchor, xOffset, yOffset)
	GameTooltip.ampvpHooked = true

	local origOwner = GameTooltip:GetOwner()
	local inInstance, instanceType = IsInInstance()
	local inCombatDisable = InCombatLockdown() and AMPVP_GetSettingValue("DISABLE_IN_COMBATENV")
	local inPVPEnvironmentDisable = AMPVP_GetSettingValue("DISABLE_IN_PVPENV") and inInstance and (instanceType == "arena" or instanceType == "pvp")
	local shouldDisable = inInstance and AMPVP_GetSettingValue("DISABLE_RAIDS_DUNGEONS") and (instanceType == "raid" or instanceType == "party")

	if inPVPEnvironmentDisable then return end
	if inCombatDisable then return end
	if shouldDisable then return end

	if frameOwner ~= nil then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetOwner(origOwner, ownerAnchor, xOffset, yOffset)
	end

	-- Unit-frame hovers carry the unit on the tooltip; LFG / community hovers do
	-- not, and then only the bundled data is available.
	local _, unit = GameTooltip:GetUnit()
	if unit and not (UnitExists(unit) and UnitIsPlayer(unit)) then
		unit = nil
	end

	GameTooltip:AddLine(" ")

	local rendered = AMPVP_ForeverBuildBlock(userName, unit,
		function(text) GameTooltip:AddLine(text) end,
		function(left, right) GameTooltip:AddDoubleLine(left, right) end)

	if not rendered then
		if not AMPVP_GetSettingValue("DISABLE_EMPTY_DATA") then
			GameTooltip:AddLine("ArenaMaster.IO - No data available." .. AMPVP_ColorSub("\nVisit this character's ArenaMaster Profile \nand their info will be available on the next addon update.", "white"))
			if addSpacePlus then
				GameTooltip:AddLine(" ")
			end
		end
	end

	GameTooltip:Show()
end

-- Battle.net friends-list variant: fills AMPVP_friendsTTlines ("left-right" per
-- line) the way AMPVP_AddTooltipFrameText does on retail.
function AMPVP_Forever_AddTooltipFrameText(userName)
	local inInstance, instanceType = IsInInstance()
	local shouldDisable = inInstance and AMPVP_GetSettingValue("DISABLE_RAIDS_DUNGEONS") and (instanceType == "raid" or instanceType == "party")

	wipe(AMPVP_friendsTTlines)
	AMPVP_friendsTTlines["nrLines"] = 0

	if shouldDisable then
		AMPVP_FriendsListTooltip.isAmPVPFromBnet = nil
		return
	end

	local nrLines = 0
	local function addLine(text)
		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = text
	end
	local function addDoubleLine(left, right)
		-- The friends frame splits each line on "-" to build its two columns, so
		-- dashes inside the value ("Knight-Lieutenant") become en dashes.
		addLine(tostring(left) .. "-" .. (tostring(right):gsub("%-", "\226\128\147")))
	end

	local rendered = AMPVP_ForeverBuildBlock(userName, nil, addLine, addDoubleLine)

	if not rendered then
		if AMPVP_GetSettingValue("DISABLE_EMPTY_DATA") then
			AMPVP_FriendsListTooltip.isAmPVPFromBnet = nil
			return
		end
		addLine("ArenaMaster.IO - No data available.")
		addLine(" ")
	end

	AMPVP_friendsTTlines["nrLines"] = nrLines
	AMPVP_FriendsListTooltip.isAmPVPFromBnet = true
end

------------------------------------------------------------------------
-- Settings defaults + beta diagnostics
------------------------------------------------------------------------

function AMPVP_ForeverSetupSettings()
	if AMPVP_SettingsVar == nil then
		AMPVP_LoginSettingsLoadSave()
	end

	for key, default in pairs(FOREVER_SETTING_DEFAULTS) do
		if AMPVP_SettingsVar[key] == nil then
			AMPVP_SettingsVar[key] = default
		end
	end
end

-- `/ampvp key` -- prints everything the beta client needs to confirm: build,
-- project id, realm/ruleset values, the computed lookup key for the current
-- target (or mouseover, or yourself) and which honor APIs exist.
function AMPVP_ForeverDebugDump()
	local version, build, date, interfaceVersion = GetBuildInfo()
	AMPVP_Print(string.format("Forever diagnostics -- client %s (%s, %s), interface %s, WOW_PROJECT_ID=%s, LE_EXPANSION_LEVEL_CURRENT=%s (classic=%s), AMPVP_IS_FOREVER=%s",
		tostring(version), tostring(build), tostring(date), tostring(interfaceVersion), tostring(WOW_PROJECT_ID),
		tostring(LE_EXPANSION_LEVEL_CURRENT), tostring(LE_EXPANSION_CLASSIC), tostring(AMPVP_IS_FOREVER)))
	AMPVP_Print(string.format("GetRealmName=%q GetNormalizedRealmName=%q ruleset=%s region=%s",
		tostring(GetRealmName()), tostring(GetNormalizedRealmName and GetNormalizedRealmName()), AMPVP_ForeverRuleset(), tostring(AMPVP_ForeverRegionCode(GetCurrentRegion()))))

	local unit = (UnitExists("target") and UnitIsPlayer("target") and "target")
		or (UnitExists("mouseover") and UnitIsPlayer("mouseover") and "mouseover")
		or "player"
	local name, realm = UnitName(unit)
	local fullName, fullRealm
	if AMPVP_HasFunction("UnitFullName") then fullName, fullRealm = UnitFullName(unit) end
	AMPVP_Print(string.format("unit=%s UnitName=%q/%q UnitFullName=%q/%q GetUnitName(true)=%q UnitNameUnmodified=%q -> name=%q key=%q",
		unit, tostring(name), tostring(realm), tostring(fullName), tostring(fullRealm),
		tostring(AMPVP_HasFunction("GetUnitName") and GetUnitName(unit, true)),
		tostring(AMPVP_HasFunction("UnitNameUnmodified") and (UnitNameUnmodified(unit))),
		tostring(AMPVP_ForeverUnitName(unit)), tostring(AMPVP_ForeverKey(AMPVP_ForeverUnitName(unit)))))

	local rankNumber, rankName = AMPVP_ForeverRankInfo(unit)
	AMPVP_Print(string.format("UnitPVPRank=%s -> rank %s %s; UnitHonorLevel=%s; level %s class %s",
		tostring(AMPVP_HasFunction("UnitPVPRank") and UnitPVPRank(unit)), tostring(rankNumber), tostring(rankName),
		tostring(AMPVP_HasFunction("UnitHonorLevel") and UnitHonorLevel(unit)),
		tostring(UnitLevel(unit)), tostring((select(2, UnitClass(unit))))))

	local apis = {
		"UnitPVPRank", "GetPVPRankInfo", "GetPVPRankProgress", "GetPVPLifetimeStats", "GetPVPThisWeekStats",
		"NotifyInspect", "CanInspect", "RequestInspectHonorData", "HasInspectHonorData", "GetInspectHonorData", "ClearInspectPlayer",
		"GetPersonalRatedInfo", "UnitFullName", "UnitNameUnmodified", "GetUnitName", "UnitHonorLevel", "UnitHonor",
	}
	local present, missing = {}, {}
	for _, fn in ipairs(apis) do
		if AMPVP_HasFunction(fn) then present[#present + 1] = fn else missing[#missing + 1] = fn end
	end
	present[#present + 1] = "C_PvP.GetPersonalRatedInfo=" .. tostring(C_PvP and type(C_PvP.GetPersonalRatedInfo) == "function")
	AMPVP_Print("APIs present: " .. table.concat(present, ", "), "green")
	AMPVP_Print("APIs missing: " .. table.concat(missing, ", "), "red")

	local horde, alliance = AMPVP_REGIONDATA_HORDE, AMPVP_REGIONDATA_ALLIANCE
	local function count(t) local n = 0 for _ in pairs(t or {}) do n = n + 1 end return n end
	AMPVP_Print(string.format("Bundled Forever entries: Horde %d, Alliance %d", count(horde), count(alliance)))
end
