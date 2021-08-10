if (COMMUNITY_UIDD_REFRESH_PATCH_VERSION or 0) < 2 then
	COMMUNITY_UIDD_REFRESH_PATCH_VERSION = 2
	if select(4, GetBuildInfo()) > 8000 then
		local function CleanDropdowns()
			if COMMUNITY_UIDD_REFRESH_PATCH_VERSION ~= 2 then
				return
			end
			local f, f2 = FriendsFrame, FriendsTabHeader
			local s = f:IsShown()
			f:Hide()
			f:Show()
			if not f2:IsShown() then
				f2:Show()
				f2:Hide()
			end
			if not s then
				f:Hide()
			end
		end
		hooksecurefunc("Communities_LoadUI", CleanDropdowns)
		hooksecurefunc("SetCVar", function(n)
			if n == "lastSelectedClubId" then
				CleanDropdowns()
			end
		end)
	end
end

if (UIDROPDOWNMENU_OPEN_PATCH_VERSION or 0) < 1 then
	UIDROPDOWNMENU_OPEN_PATCH_VERSION = 1
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function(frame)
		if UIDROPDOWNMENU_OPEN_PATCH_VERSION ~= 1 then
			return
		end
		if UIDROPDOWNMENU_OPEN_MENU and UIDROPDOWNMENU_OPEN_MENU ~= frame
		   and not issecurevariable(UIDROPDOWNMENU_OPEN_MENU, "displayMode") then
			UIDROPDOWNMENU_OPEN_MENU = nil
			local t, f, prefix, i = _G, issecurevariable, " \0", 1
			repeat
				i, t[prefix .. i] = i + 1
			until f("UIDROPDOWNMENU_OPEN_MENU")
		end
	end)
end

AMPVP_AchievementsAndTitlesList = {
	[1] = "Duelist",
	[2] = "Rival",
	[3] = "Challenger",
	[4] = "Gladiator",
	[5] = "Merciless Gladiator",
	[6] = "Vengeful Gladiator",
	[7] = "Brutal Gladiator",
	[8] = "Deadly Gladiator",
	[9] = "Furious Gladiator",
	[10] = "Relentless Gladiator",
	[11] = "Wrathful Gladiator",
	[12] = "Vicious Gladiator",
	[13] = "Ruthless Gladiator",
	[14] = "Cataclysmic Gladiator",
	[15] = "Malevolent Gladiator",
	[16] = "Tyrannical Gladiator",
	[17] = "Griveous Gladiator",
	[18] = "Prideful Gladiator",
	[19] = "Primal Gladiator",
	[20] = "Wild Gladiator",
	[21] = "Warmongering Gladiator",
	[22] = "Battlemaster",
	[23] = "Battlemaster",
	[24] = "Mongolian version of Battlemaster",
	[25] = "Khan",
	[26] = "100000 Honorable Kills",
	[27] = "250000 Honorable Kills",
	[28] = "Three's Company: 2700",
	[29] = "Three's Company: 2400",
	[30] = "Three's Company: 2200",
	[31] = "Three's Company: 2000",
	[32] = "Three's Company: 1750",
	[33] = "Three's Company: 1550",
	[34] = "Just the Two of Us: 2200",
	[35] = "Just the Two of Us: 2000",
	[36] = "Just the Two of Us: 1750",
	[37] = "Just the Two of Us: 1550",
	[38] = "Scout: 1100",
	[39] = "Private: 1100",
	[40] = "Grunt: 1200",
	[41] = "Corporal: 1200",
	[42] = "Sergeant: 1300",
	[43] = "Sergeant: 1300",
	[44] = "Senior Sergeant: 1400",
	[45] = "Master Sergeant: 1400",
	[46] = "First Sergeant: 1500",
	[47] = "Sergeant Major: 1500",
	[48] = "Stone Guard: 1600",
	[49] = "Knight: 1600",
	[50] = "Blood Guard: 1700",
	[51] = "Knight Luitenant: 1700",
	[52] = "Legionnaire: 1800",
	[53] = "Knight Captain: 1800",
	[54] = "Centurion: 1900",
	[55] = "Knight Champion: 1900",
	[56] = "Champion: 2000",
	[57] = "Lieutenant Commander: 2000",
	[58] = "Lieutenant General: 2100",
	[59] = "Commander: 2100",
	[60] = "General: 2200",
	[61] = "Marshal: 2200",
	[62] = "Warlord: 2300",
	[63] = "Field Marshal: 2300",
	[64] = "High Warlord: 2400",
	[65] = "Grand Marshal: 2400",
	[66] = "Hero of the Horde",
	[67] = "Hero of the Alliance",
	[68] = "The Arena Master",
	[69] = "Vindictive Gladiator",
	[70] = "Fearless Gladiator",
	[71] = "Cruel Gladiator",
	[72] = "Ferocious Gladiator",
	[73] = "Fierce Gladiator",
	[74] = "Dominant Gladiator",
	[75] = "Demonic Gladiator",
	[77] = "Vindictive Elite",
	[78] = "Fearless Elite",
	[79] = "Cruel Elite",
	[80] = "Ferocious Elite",
	[81] = "Fierce Elite",
	[82] = "Dominant Elite",
	[83] = "Demonic Elite",
	[84] = "Gladiator: Battle for Azeroth Season 1",
	[85] = "Duelist: Battle for Azeroth Season 1",
	[86] = "Rival: Battle for Azeroth Season 1",
	[87] = "Challenger: Battle for Azeroth Season 1",
	[88] = "Gladiator: Battle for Azeroth Season 2",
	[89] = "Duelist: Battle for Azeroth Season 2",
	[90] = "Rival: Battle for Azeroth Season 2",
	[91] = "Challenger: Battle for Azeroth Season 2",
	[92] = "Elite: Battle for Azeroth Season 1",
	[93] = "Elite: Battle for Azeroth Season 2",
	[94] = "Gladiator: Battle for Azeroth Season 3",
	[95] = "Elite: Battle for Azeroth Season 3",
	[96] = "Duelist: Battle for Azeroth Season 3",
	[97] = "Challenger: Battle for Azeroth Season 3",
	[98] = "Rival: Battle for Azeroth Season 3",
	[99] = "Dread Gladiator",
	[100] = "Sinister Gladiator",
	[101] = "Notorious Gladiator",
	[102] = "Gladiator: Battle for Azeroth Season 4",
	[103] = "Duelist: Battle for Azeroth Season 4",
	[104] = "Rival: Battle for Azeroth Season 4",
	[105] = "Challenger: Battle for Azeroth Season 4",
	[106] = "Corrupted Gladiator",
	[107] = "Combatant: Shadowlands Season 1",
	[108] = "Challenger: Shadowlands Season 1",
	[109] = "Rival: Shadowlands Season 1",
	[110] = "Duelist: Shadowlands Season 1",
	[111] = "Elite: Shadowlands Season 1",
	[112] = "Gladiator: Shadowlands Season 1",
	[113] = "Sinful Gladiator: Shadowlands Season 1",
	[114] = "Elite: Battle for Azeroth Season 4",
	[115] = "Combatant: Shadowlands Season 2",
	[116] = "Challenger: Shadowlands Season 2",
	[117] = "Rival: Shadowlands Season 2",
	[118] = "Duelist: Shadowlands Season 2",
	[119] = "Elite: Shadowlands Season 2",
	[120] = "Gladiator: Shadowlands Season 2",
	[121] = "Unchained Gladiator: Shadowlands Season 2",
}

function AMPVP_ConvertDateToStandardEU(datet)

	if datet == nil then return "No date available" end
	
	local tableMonths = {
		[1] = "January",
		[2] = "February",
		[3] = "March",
		[4] = "April",
		[5] = "May",
		[6] = "June",
		[7] = "July",
		[8] = "August",
		[9] = "September",
		[10] = "October",
		[11] = "November",
		[12] = "December",
	}
	
	local day, month, year = string.split("/", datet)
	
	if day and month and year then
		month = tableMonths[tonumber(month)]
		year = "20"..year
	end
	
	local tempDate = day .." ".. month .." ".. year
	return tempDate
	
end

if (UIDROPDOWNMENU_VALUE_PATCH_VERSION or 0) < 2 then
	UIDROPDOWNMENU_VALUE_PATCH_VERSION = 2
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		if UIDROPDOWNMENU_VALUE_PATCH_VERSION ~= 2 then
			return
		end
		for i=1, UIDROPDOWNMENU_MAXLEVELS do
			for j=1, UIDROPDOWNMENU_MAXBUTTONS do
				local b = _G["DropDownList" .. i .. "Button" .. j]
				if not (issecurevariable(b, "value") or b:IsShown()) then
					b.value = nil
					repeat
						j, b["fx" .. j] = j+1
					until issecurevariable(b, "value")
				end
			end
		end
	end)
end

if (UIDD_REFRESH_OVERREAD_PATCH_VERSION or 0) < 1 then
	UIDD_REFRESH_OVERREAD_PATCH_VERSION = 1
	local function drop(t, k)
		local c = 42
		t[k] = nil
		while not issecurevariable(t, k) do
			if t[c] == nil then
				t[c] = nil
			end
			c = c + 1
		end
	end
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		if UIDD_REFRESH_OVERREAD_PATCH_VERSION ~= 1 then
			return
		end
		for i=1,UIDROPDOWNMENU_MAXLEVELS do
			for j=1,UIDROPDOWNMENU_MAXBUTTONS do
				local b, _ = _G["DropDownList" .. i .. "Button" .. j]
				_ = issecurevariable(b, "checked")      or drop(b, "checked")
				_ = issecurevariable(b, "notCheckable") or drop(b, "notCheckable")
			end
		end
	end)
end

local backdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile =  "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 0, edgeSize = 15,
	insets = { left = 5, right = 5, top = 5, bottom = 5 },
}

local backdrop2 = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background-Corrupted",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}
function AMPVP_CreateTableFromString(inputStr, sep)

	local separator = sep

	if separator == nil then
		separator = "%s"
	end

	local tempTab = {}

	for str in string.gmatch(inputStr, "([^"..separator.."]+)") do

		table.insert(tempTab, str)

	end

	return tempTab

end

function AMPVP_IsTaintable()
    return (InCombatLockdown() or (UnitAffectingCombat("player") or UnitAffectingCombat("pet")))
end

function AMPVP_CreateFrame(frameName, frameParent, lrOffset, xOffset, yOffset, sizeX, sizeY, alphaBG, movable)

	local frame = CreateFrame("frame", frameName, frameParent, "SecureHandlerStateTemplate" and BackdropTemplateMixin and "BackdropTemplate")
	frame:SetPoint(lrOffset, frameParent, xOffset, yOffset)
	frame:SetSize(sizeX, sizeY)
	frame.t = frame:CreateTexture()
	frame.t:SetColorTexture(0, 0, 0, alphaBG or 1)
	frame.t:SetSize(sizeX - 5, sizeY - 5)
	frame.t:SetPoint("CENTER", frame, 0, 0)
	--frame.t:SetAllPoints(frame)
	frame:SetBackdrop(backdrop)
	if movable then
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame:SetUserPlaced(true)
		frame:SetScript("OnDragStart", frame.StartMoving)
		frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	end

end

function AMPVP_CreateFrame2(frameName, frameParent, lrOffset, xOffset, yOffset, sizeX, sizeY, alphaBG, movable)

	local frame = CreateFrame("frame", frameName, frameParent, "SecureHandlerStateTemplate" and BackdropTemplateMixin and "BackdropTemplate")
	frame:SetPoint(lrOffset, frameParent, xOffset, yOffset)
	frame:SetSize(sizeX, sizeY)
	--frame.t:SetAllPoints(frame)
	frame:SetBackdrop(backdrop2)
	if movable then
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame:SetUserPlaced(true)
		frame:SetScript("OnDragStart", frame.StartMoving)
		frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	end

end

function AMPVP_AddDoubleLine(frameText1, frameText2, line1, line2)

	if frameText1 ~= nil then
		frameText1:SetText(line1)
	end

	if frameText2 ~= nil then
		frameText2:SetText(line2)
	end

end

function AMPVP_CreateText(frameName, frameParent, lrOffset, xOffset, yOffset, text, fontName)

	if frameParent ~= nil then
		local frameText = frameParent:CreateFontString(frameName, "ARTWORK", fontName or "GameFontNormal")
		frameText:SetPoint(lrOffset, frameParent, xOffset, yOffset)
		frameText:SetText(text)
	end

end

function AMPVP_CreateText2(frameName, frameParent, lrOffset, xOffset, yOffset, text, fontName)

	if frameParent ~= nil then
		local frameText = frameParent:CreateFontString(frameName, "ARTWORK", fontName or "GameFontNormal")
		frameText:SetPoint(lrOffset, frameParent, xOffset, yOffset)
		frameText:SetText(text)
	end

end

function AMPVP_FormatValue(value)
    if value >= 1e6 then
        return tonumber(format("%.1f", value/1e6)).."m"
    elseif value >= 1e3 then
        return tonumber(format("%.1f", value/1e3)).."k"
    else
        return value
    end
end

function AMPVP_CreateButton(buttonName, frameParent, lrOffset, xOffset, yOffset, sizeX, sizeY, text)

	local button = CreateFrame("Button", "$parent"..buttonName, frameParent, "UIPanelButtonTemplate")
	button:SetSize(sizeX,sizeY)
	button:SetPoint(lrOffset, frameParent, xOffset, yOffset)
	local textLength = string.len(text)
	if textLength > 35 then
		button:SetText(text:sub(1, 35).."...")
	else
		button:SetText(text)
	end

end

function AMPVP_CreateCloseButton(frameParent)

	local closeButton = CreateFrame("Button", nil, frameParent, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", -5, -5)
	closeButton:SetHitRectInsets(5, 5, 5, 5)

end

function AMPVP_CreateCheckbox(boxName, frameParent, lrOffset, xOffset, yOffset, text)


	local checkbox = CreateFrame("CheckButton", "$parent"..boxName, frameParent, "UICheckButtonTemplate")
	checkbox:ClearAllPoints()
	checkbox:SetPoint(lrOffset, frameParent, xOffset, yOffset)
	_G[checkbox:GetName() .. "Text"]:SetText(text)

end

function AMPVP_CreateEditBox(boxName, frameParent, lrOffset, xOffset, yOffset, sizeX, sizeY, text)

	local editboxframe = frameParent:CreateFontString(boxName, "ARTWORK", "GameFontHighlightSmall")
	editboxframe:SetPoint(lrOffset, xOffset, yOffset)
	editboxframe:SetText(text)

	editboxframe.titleinputframe = CreateFrame("Frame", "$parentInputFrame", frameParent, "SecureHandlerStateTemplate" and BackdropTemplateMixin and "BackdropTemplate")
	editboxframe.titleinputframe:SetWidth(sizeX)
	editboxframe.titleinputframe:SetHeight(sizeY)
	editboxframe.titleinputframe:SetBackdrop(backdrop)
	editboxframe.titleinputframe:SetPoint("TOPLEFT", editboxframe, "BOTTOMLEFT", 40, 15)
	editboxframe.titleinputbox = CreateFrame("EditBox", "$parentTitleText", editboxframe.titleinputframe)
	editboxframe.titleinputbox:SetWidth(sizeX)
	editboxframe.titleinputbox:SetHeight(24)
	editboxframe.titleinputbox:SetMaxLetters(100)
	editboxframe.titleinputbox:SetNumeric(false)
	editboxframe.titleinputbox:SetAutoFocus(false)
	editboxframe.titleinputbox:SetFontObject("GameFontHighlightSmall")
	editboxframe.titleinputbox:SetPoint("TOPLEFT", 5, 1)
	--editboxframe.titleinputbox:SetScript("OnShow", editboxframe.titleinputbox.SetFocus)
	editboxframe.titleinputbox:SetScript("OnEscapePressed", editboxframe.titleinputbox.ClearFocus)
	editboxframe.titleinputbox:SetScript("OnEnterPressed", editboxframe.titleinputbox.ClearFocus)


end

function AMPVP_CreateText(frameName, frameParent, lrOffset, xOffset, yOffset, text)

	if frameParent ~= nil then
		local frameText = frameParent:CreateFontString(frameName, "ARTWORK", "GameFontNormal")
		frameText:SetPoint(lrOffset, frameParent, xOffset, yOffset)
		frameText:SetText(text)
	end

end

function AMPVP_CreateButtonText(txt, btnName, frameParent, region, posX, posY, font, textureWithPath, fontColor, sizeX, sizeY, isBlack)

	local btnName = CreateFrame("Button", "$parent"..btnName, frameParent)
	btnName:ClearAllPoints()
	btnName:SetNormalTexture(nil)
	if sizeX == nil then
		btnName:SetSize(120, 35)
	else
		btnName:SetSize(sizeX, sizeY)
	end
	btnName:SetPoint(region,posX,posY)
	btnName.text = btnName:CreateFontString("$parentText", "OVERLAY", font)
	--btnName.text:SetAllPoints(btnName)
	btnName.text:SetText(txt)

	if fontColor ~= nil then
		btnName.text:SetTextColor(unpack(fontColor))
	end

	if isBlack ~= nil then

		btnName.t = btnName:CreateTexture(nil, "BACKGROUND")
		btnName.t:SetSize(30, 27)
		btnName.t:SetColorTexture(0, 0, 0, 0.3)
		btnName.t:SetPoint("CENTER", btnName, 0, 0)

	end

	if textureWithPath ~= nil then
		btnName.icon = btnName:CreateTexture("$parentTexture", 'OVERLAY')
		btnName.icon:SetTexture(textureWithPath)
		btnName.icon:SetSize(15, 15)
		btnName.icon:SetPoint('LEFT')
	end

	if textureWithPath ~= nil then
		btnName.text:SetPoint('LEFT', btnName.icon, 'RIGHT', 5, 0)
	else
		btnName.text:SetPoint('CENTER', btnName, 0, 0)
	end

end


function AMPVP_Print(msg, clr)

	local defClr = "|cffffffff"

	if clr == "green" then
		defClr = "|cff66ff33"
	elseif clr == "red" then
		defClr = "|cffff0000"
	elseif clr == "blue" then
		defClr = "|cff0033cc"
	end

	print("[ArenaMaster.IO]: "..defClr..msg.."|r")

end

function AMPVP_ColorSub(thing, color, isPercentage)

	if not isPercentage then
		if color == "white" then
			thing = "|cffffffff"..thing.."|r";
		elseif color == "redwinrate" then
			thing = "|cffc43244"..thing.."|r";
		elseif color == "green" then
			thing = "|cff66ff33"..thing.."|r";
		elseif color == "greenwinrate" then
			thing = "|cff53ca41"..thing.."|r";
		end
	else
		if color == "white" then
			thing = "|cffffffff"..thing.."%".."|r";
		elseif color == "redwinrate" then
			thing = "|cffc43244"..thing.."%".."|r";
		elseif color == "greenwinrate" then
			thing = "|cff53ca41"..thing.."%".."|r";
		end
	end
	return thing;

end

function AMPVP_RatingColorManager(points)

	local finalPoints = ""

	if points >= 2700 then
		finalPoints = '|cffff8000'..points.."|r"
	elseif points >= 2400 then
		finalPoints = '|cffa335ee'..points.."|r"
	elseif points >= 2100 then
		finalPoints = '|cff0070dd'..points.."|r"
	elseif points >= 1750 then
		finalPoints = '|cff27ae60'..points.."|r"
	elseif points < 1750 then
		finalPoints = '|cffffffff'..points.."|r"
	end

	return finalPoints

end

function AMPVP_FixSlangRealms(realmName)

	local result = "";

	realmName = string.gsub(realmName, " ", "")

	for name, slug in pairs(AMPVP_REALMLIST) do

		name = string.gsub(name, " ", "")

		if name == realmName then
			result = slug
		end

	end

	if result == "" then

		result = realmName -- for cases like russian realms. not yet fixed черныйшрам - 's slug is not available;

	end

	return result

end


function AMPVP_LoginSettingsLoadSave()

	if AMPVP_SettingsVar == nil then
		AMPVP_SettingsVar = {
			addonInitialized = false,
		--main settings
			--Current Rating
			CURR_RATING_2s = true,
			CURR_RATING_3s = true,
			CURR_RATING_RBG = true,
			--Current Season Stats
			CURR_SEASON_2SW = true,
			CURR_SEASON_3SW = true,
			CURR_SEASON_RBGW = true,
			CURR_SEASON_TITLES = true,
			--Character Experience
			CHAR_EXP_2s = true,
			CHAR_EXP_3s = true,
			CHAR_EXP_RBG = true,
			--Highest Account Rating
			HIGHEST_ACC_2s = true,
			HIGHEST_ACC_3s = true,
			HIGHEST_ACC_RBG = true,
			--Character Stats
			STATS_ITEMLEVEL = true,
			STATS_VERSATILITY = true,
			STATS_COVENANT = true,
			STATS_RENOWN = true,
			STATS_HEALTH = true,
			--Achievements
			ACHI_SHOW = true,
			--Misc
			DISABLE_EMPTY_DATA = false,
			DISABLE_RAIDS_DUNGEONS = true,
			DISABLE_IN_COMBATENV = false,
			DISABLE_IN_PVPENV = false,

		--arenas&battlegrounds settings

			INST_CURR_RATING_2s = true,
			INST_CURR_RATING_3s = true,
			INST_CURR_RATING_RBG = true,
			--Current Season Stats
			INST_CURR_SEASON_2SW = true,
			INST_CURR_SEASON_3SW = true,
			INST_CURR_SEASON_RBGW = true,
			INST_CURR_SEASON_TITLES = true,
			--Character Experience
			INST_CHAR_EXP_2s = true,
			INST_CHAR_EXP_3s = true,
			INST_CHAR_EXP_RBG = true,
			--Highest Account Rating
			INST_HIGHEST_ACC_2s = true,
			INST_HIGHEST_ACC_3s = true,
			INST_HIGHEST_ACC_RBG = true,
			--Character Stats
			INST_STATS_ITEMLEVEL = true,
			INST_STATS_VERSATILITY = true,
			INST_STATS_COVENANT = true,
			INST_STATS_RENOWN = true,
			INST_STATS_HEALTH = true,
			--Achievements
			INST_ACHI_SHOW = true,
		}
	end
	
	if AMPVP_SettingsVar ~= nil and AMPVP_SettingsVar.DISABLE_IN_COMBATENV == nil then
		AMPVP_SettingsVar.DISABLE_IN_COMBATENV = false;
	end
	
	if AMPVP_SettingsVar ~= nil and AMPVP_SettingsVar.DISABLE_IN_PVPENV == nil then
		AMPVP_SettingsVar.DISABLE_IN_PVPENV = false;
	end
	
end

local frameInitSettings = CreateFrame("frame")
frameInitSettings:RegisterEvent("PLAYER_LOGIN")
frameInitSettings:SetScript("OnEvent", AMPVP_LoginSettingsLoadSave)

local function AMPVP_FailsafeReturn(root, query, returnTable)
	local ids, len = {}, 0
	for id in query:gmatch('[^.]+') do
		len = len + 1
		ids[len]= id
	end

	local node = root
	for i=1,len do
		if type(node) ~= 'table' then return nil end
		node = node[ids[i]]
	end
	return node
end

local function AMPVP_TableofStringsHasEntries(t,s)
  if t == nil then return false end
  local t = t
  for key in s:gmatch('[^.]+') do
    if t[ key ] == nil then
		return false
	end
    t = t[ key ]
  end
  return t
end


function AMPVP_IsBadReadValue(value)
	if value == nil then
		return true
	end

	if type(value) == "string" then
		if value == nil or value == "" then
			return true;
		end
	elseif type(value) == "number" then
		if value == nil or value == 0 then
			return true;
		end
	end

	return false;
end

function AMPVP_GetValue(tableX, entries, isArray)
	if tableX == nil or entries == nil then print(entries .. " are null.") return nil end

	local val = nil

	if isArray then
		local strF = "";
		local ok = nil;
		ok = AMPVP_TableofStringsHasEntries(tableX, entries);

		if ok ~= nil and type(ok) == 'table' then
			for k, v in pairs(ok) do
				if ok[k] ~= nil and v ~= "" then
					strF = strF .. v .. "\n"
				end
			end
		end
		if strF ~= "" then
			return strF
		else
			return nil
		end

	else
		val = AMPVP_FailsafeReturn(tableX, entries)
	end

	if val ~= nil then
		local isBad = AMPVP_IsBadReadValue(val)
		if not isBad then
			return val;
		end
	end

	return nil;
end

function AMPVP_GetSettingValue(setting)
	local db = AMPVP_SettingsVar

	if db == nil then return end

	if db[setting] ~= nil then
		return db[setting]
	end

	return false
end
