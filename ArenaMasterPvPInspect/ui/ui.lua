-- IsAddOnLoaded moved to C_AddOns in 11.0.2 and the bare global was removed.
local function AMPVP_IsAddOnLoaded(name)
	local fn = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
	return fn and fn(name)
end

-- GetMouseFocus() was superseded by GetMouseFoci(), which returns a list ordered
-- innermost-first, in 11.0.
local function AMPVP_GetMouseFocus()
	if GetMouseFoci then
		local foci = GetMouseFoci()
		return foci and foci[1]
	end

	return GetMouseFocus and GetMouseFocus()
end

-----------REGION DROPDOWN + CPYPROFILE START-----------
local regionsTable = {
	[1] = "us",
	[2] = "kr",
	[3] = "eu",
	[4] = "tw",
	[5] = "ch"
}

local friendsTooltipShown = false

AMPVP_SettingsUI_InstancedToggleGeneralSettingsUI:SetScript("OnClick", function()
	AMPVP_SettingsUI_Instanced:Hide()
	AMPVP_SettingsUI:Show()
end)
AMPVP_SettingsUITogglePVPSettingsUI:SetScript("OnClick", function()
	AMPVP_SettingsUI:Hide()
	AMPVP_SettingsUI_Instanced:Show()
end)

-- Show the copy-the-URL popup for one character.
local function AMPVP_ShowProfileLink(unitName, unitServer)
	if not unitName or unitName == "" then return end

	if not unitServer or unitServer == "" then
		unitServer = GetNormalizedRealmName() or GetRealmName()
	end

	if not unitServer or unitServer == "" then return end

	unitServer = AMPVP_FixSlangRealms(unitServer)

	local currRegion = GetCurrentRegion()
	local regionSlug = regionsTable[currRegion]
	if not regionSlug then
		AMPVP_Print("Your region is not supported for profile links.", "red")
		return
	end

	AMPVP_CopyCharNameFrame2InputFrameTitleText:SetText(
		"https://arenamaster.io/"..regionSlug.."/"..string.lower(unitServer).."/"..string.lower(unitName).."?ref=addon")
	AMPVP_CopyCharNameFrame2InputFrameTitleText:HighlightText()
	AMPVP_CopyCharNameFrame2:Show()
	AMPVP_CopyCharNameFrame2InputFrameTitleText:SetFocus()
end

-- Resolve "who is this menu about" from the contextData the menu system hands us.
-- Unit-frame menus carry `unit` (and `server` is nil for same-realm players);
-- chat / friends-list menus carry name+server directly.
local function AMPVP_MenuTarget(contextData)
	if not contextData then return nil end

	local name, server = contextData.name, contextData.server

	if not name and contextData.unit then
		if not UnitIsPlayer(contextData.unit) then return nil end
		name, server = UnitNameUnmodified(contextData.unit)
	end

	if not name or name == "" then return nil end

	-- 12.0 marks some unit identity as a "secret value" inside instances. Those
	-- cannot be compared or concatenated, so bail rather than raise.
	if issecretvalue and (issecretvalue(name) or (server ~= nil and issecretvalue(server))) then
		return nil
	end

	if not server or server == "" then
		server = GetNormalizedRealmName() or GetRealmName()
	end

	return name, server
end

-- The UIDropDownMenu system this addon used to hook was replaced in 11.0 and
-- UnitPopup_ShowMenu was removed outright, so the old integration silently stopped
-- adding anything. Menu.ModifyMenu is the supported replacement.
local AMPVP_MENU_TAGS = {
	"MENU_UNIT_PLAYER",
	"MENU_UNIT_SELF",
	"MENU_UNIT_PARTY",
	"MENU_UNIT_RAID_PLAYER",
	"MENU_UNIT_TARGET",
	"MENU_UNIT_FOCUS",
	"MENU_UNIT_ENEMY_PLAYER",
	"MENU_UNIT_ARENAENEMY",
	"MENU_UNIT_FRIEND",
	"MENU_UNIT_FRIEND_OFFLINE",
	"MENU_UNIT_BN_FRIEND",
	"MENU_UNIT_BN_FRIEND_OFFLINE",
}

local function AMPVP_AddProfileMenuEntry(ownerRegion, rootDescription, contextData)
	local name, server = AMPVP_MenuTarget(contextData)
	if not name then return end

	rootDescription:CreateDivider()
	rootDescription:CreateButton("|cffc72429ArenaMaster Profile|r", function()
		AMPVP_ShowProfileLink(name, server)
	end)
end

if Menu and Menu.ModifyMenu then
	for _, tag in ipairs(AMPVP_MENU_TAGS) do
		Menu.ModifyMenu(tag, AMPVP_AddProfileMenuEntry)
	end
else
	AMPVP_Print("This client is too old for the ArenaMaster profile menu entry.", "red")
end

AMPVP_CreateFrame("AMPVP_CopyCharNameFrame2", UIParent, "CENTER", 0, 0, 450, 100, 0.5, true)
tinsert(UISpecialFrames, AMPVP_CopyCharNameFrame2:GetName())
AMPVP_CreateFrame2("AMPVP_FriendsListTooltip", FriendsFrame, "BOTTOM", 0, -100, 250, 200, 0.7, false)
----------------Logo frame Start------------------
AMPVP_CreateFrame("AMPVP_LogoFrame", AMPVP_CopyCharNameFrame2, "TOP", 0, 61, 60, 60, 0, false)
AMPVP_LogoFrame:SetFrameStrata("BACKGROUND")
AMPVP_LogoFrame.t:SetTexture("Interface\\AddOns\\ArenaMasterPVPInspect\\textures\\arenamaster-logo")
AMPVP_LogoFrame.t:SetPoint("CENTER", AMPVP_LogoFrame, 1, 0)

----------------Logo frame End--------------------
AMPVP_CopyCharNameFrame2:Hide()
AMPVP_CreateCloseButton(AMPVP_CopyCharNameFrame2)
AMPVP_CreateText("TextTitle", AMPVP_CopyCharNameFrame2, "CENTER", -0, 15, "Copy and paste in your browser")
AMPVP_CreateEditBox("cpyName", AMPVP_CopyCharNameFrame2, "LEFT", -20, -15, 400, 20, "")
AMPVP_CopyCharNameFrame2InputFrameTitleText:SetText("")
AMPVP_CopyCharNameFrame2InputFrameTitleText:HighlightText()
AMPVP_CopyCharNameFrame2InputFrameTitleText:SetFocus()

AMPVP_CopyCharNameFrame2.titleTexture = AMPVP_CopyCharNameFrame2:CreateTexture(nil, "ARTWORK")
AMPVP_CopyCharNameFrame2.titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
AMPVP_CopyCharNameFrame2.titleTexture:SetWidth(460)
AMPVP_CopyCharNameFrame2.titleTexture:SetHeight(64)
AMPVP_CopyCharNameFrame2.titleTexture:SetPoint("TOP", 0, 12)
AMPVP_CopyCharNameFrame2.title = AMPVP_CopyCharNameFrame2:CreateFontString(nil, "ARTWORK", "GameFontNormal")
AMPVP_CopyCharNameFrame2.title:SetPoint("TOP", 0, -3)
AMPVP_CopyCharNameFrame2.title:SetText("ArenaMaster.IO - PVP Inspect")

-----------REGION DROPDOWN + CPYPROFILE END-----------


-----------REGION TOOLTIPSDATA START-----------
hooksecurefunc("LFGListSearchEntry_OnEnter", function(entry)

	GameTooltip.ampvpLastID = nil
	if entry.resultID ~= nil then

		if GameTooltip.ampvpLastID ~= entry.resultID then

			local searchResultData = C_LFGList.GetSearchResultInfo(entry.resultID)

			local lName = searchResultData.leaderName

			if lName == nil then return end

			local aname, realm = string.split("-", lName)

			if realm == nil or realm == "" then
				realm = GetRealmName()
			end

			local name = aname.."-"..realm

			if name ~= nil then

				GameTooltip.ampvpHooked = nil
				AMPVP_AddTooltipDetails(name, false)
				GameTooltip.ampvpLastID = entry.resultID

			end

		end

	end

end)


local function tempHookGametooltip(self, ...)

	local unitIncompleteName, unit = self:GetUnit()

	if unit == nil then return end

	-- Since Dragonflight the Unit tooltip post-call fires on every refresh of the
	-- same tooltip without the previously added lines being cleared. Without this
	-- guard the ArenaMaster.IO info block is re-appended on each refresh, so the
	-- tooltip duplicates its contents and grows without bound until the unit
	-- changes (which clears it). Only add our block once per unit. See issue #22.
	-- Gate the dedup short-circuit on a real GUID: UnitGUID can be nil for some
	-- tooltip states, and a nil ampvpLastGUID would otherwise match it and wrongly
	-- skip adding details for a new tooltip context (issue #22 review).
	-- Since 12.0 unit identity can be a "secret value" inside instances, which
	-- cannot be compared or used as a table key. Skip the dedup guard rather than
	-- raise; the tooltip still renders, it just re-adds on refresh.
	local ampvpGUID = UnitGUID(unit)
	if issecretvalue and ampvpGUID and issecretvalue(ampvpGUID) then
		ampvpGUID = nil
	end

	if ampvpGUID and GameTooltip.ampvpHooked and GameTooltip.ampvpLastGUID == ampvpGUID then
		return
	end

	local name, realm = UnitName(unit), select(2,UnitName(unit))
	local compName = nil

	if name == nil then return end

	if realm == nil then
		realm = GetRealmName()
		compName = name.."-"..realm
	else
		compName = name.."-"..realm
	end

	if UnitIsPlayer(unit) then
		if compName ~= nil then
			GameTooltip.ampvpLastGUID = ampvpGUID
			AMPVP_AddTooltipDetails(compName)
		end
	end

end
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, tempHookGametooltip)

hooksecurefunc(GameTooltip, "Hide", function(self)

	if GameTooltip.ampvpHooked then
		GameTooltip.ampvpHooked = nil
	end

	-- Clear the per-member guard so the next hover re-populates the tooltip.
	GameTooltip.ampvpLastName = nil
	-- Also clear the unit-tooltip GUID tracker so a fresh hover re-adds our info
	-- block on the Unit post-call path. See issue #22.
	GameTooltip.ampvpLastGUID = nil

	if friendsTooltipShown then
		friendsTooltipShown = false
	end

end)


GameTooltip:HookScript("OnUpdate", function(self)

	local entry = AMPVP_GetMouseFocus()

	if entry == nil then
		return
	end

	if entry.memberInfo ~= nil then
		local name = nil;
		for k, v in pairs(entry.memberInfo) do
			if k == "name" then
				name = v
			end
		end

		if name == nil then return end -- fix for communities where people transferred and appear blank within them.

		local aname, arealm = string.split("-", name)

		if arealm == nil then
			arealm = GetRealmName()
		end

		local finalName = aname.."-"..arealm;

		-- OnUpdate fires every frame; only add our details once per member,
		-- otherwise AMPVP_AddTooltipDetails appends the same block again each
		-- frame and the tooltip grows into an endless duplicate list.
		if finalName ~= nil and finalName ~= "" and GameTooltip.ampvpLastName ~= finalName then
			AMPVP_AddTooltipDetails(finalName, false)
			GameTooltip.ampvpLastName = finalName
		end

	end

	if entry.resultID ~= nil then

		if GameTooltip.ampvpLastID ~= entry.resultID then

			local searchResultData = C_LFGList.GetSearchResultInfo(entry.resultID)

			local lName = searchResultData.leaderName

			if lName == nil then return end

			local aname, realm = string.split("-", lName)

			if realm == nil or realm == "" then
				realm = GetRealmName()
			end

			local name = aname.."-"..realm

			if name ~= nil then
				GameTooltip.ampvpHooked = nil
				AMPVP_AddTooltipDetails(name, false)
				GameTooltip.ampvpLastID = entry.resultID
			end

		end

	end


end)

-- LFG applicant tooltip. Previously driven off GameTooltip's OnShow + a mouse-focus
-- probe, which fires before Blizzard has populated the tooltip and carries no
-- context. LFGListApplicantMember_OnEnter is the real, still-present entry point
-- and hands us the member button directly.
--
-- GetApplicantMemberInfo returns 17 values on current retail; only the first is
-- needed here, so take it positionally rather than unpacking a signature that has
-- grown twice since this addon last shipped (specID in 10.2, isLeaver in 11.2).
local function AMPVP_ApplicantTooltip(memberFrame)
	if not memberFrame then return end

	local parent = memberFrame:GetParent()
	local applicantID = parent and parent.applicantID
	local memberIdx = memberFrame.memberIdx

	if not applicantID or not memberIdx then return end

	local sname = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
	if not sname or sname == "" then return end

	local aname, realm = string.split("-", sname)

	if realm == nil or realm == "" then
		realm = GetNormalizedRealmName() or GetRealmName()
	end

	if not aname or not realm then return end

	local name = aname.."-"..realm

	if AMPVP_IsAddOnLoaded("RaiderIO") then
		-- RaiderIO rebuilds the tooltip a frame later; append after it.
		C_Timer.After(0, function() AMPVP_AddTooltipDetails(name, false) end)
	else
		AMPVP_AddTooltipDetails(name, false, PVEFrame, "ANCHOR_RIGHT", 100, 0)
	end
end

if type(LFGListApplicantMember_OnEnter) == "function" then
	hooksecurefunc("LFGListApplicantMember_OnEnter", AMPVP_ApplicantTooltip)
end

local function friedsListFunc2(self)

	local bnetIndex = nil

	friendsTooltipShown = false

	for k, v in pairs(self.button) do
		if k == "id" then
			bnetIndex = v
		end
	end

	-- No BNet friend index on this tooltip button (e.g. a regular WoW friend
	-- or an empty entry), so there is nothing for us to inspect.
	if type(bnetIndex) ~= "number" then return end

	-- Read the game account straight off the account info. Offline BNet
	-- friends have no active game account, so we stop here for them. This also
	-- avoids calling C_BattleNet.GetFriendGameAccountInfo, which some addons
	-- (e.g. ElvUI/MerathilisUI) wrap in a way that errors when the friend is
	-- offline. See issue #19.
	local accountInfo = C_BattleNet.GetFriendAccountInfo(bnetIndex)
	local accData = accountInfo and accountInfo.gameAccountInfo

	if accData == nil or not accData.isOnline then return end

	local realm, name = accData.realmName, accData.characterName

	if name == "" and realm == "" or name == nil or realm == nil then
		return
	end

	local compName = name.."-"..realm

	local dbg = "BNET Name:" .. compName .. " " .. name .. " " .. realm .. " " .. bnetIndex

	AMPVP_PrintDebug(dbg)

	AMPVP_AddTooltipFrameText(compName)
	AMPVP_PrintDebug("Spawning own anchor")

end

hooksecurefunc(FriendsTooltip, "Show", friedsListFunc2)

FriendsTooltip:HookScript("OnHide", function(self, ...)
	GameTooltip:Hide()
	AMPVP_FriendsListTooltip.isAmPVPFromBnet = nil
	AMPVP_FriendsListTooltip:Hide()
end)

SLASH_AMPVP1 = "/ampvp"
SlashCmdList["AMPVP"] = function(msg)

	local cmp = string.lower(msg)

	if cmp == "debug" or cmp == "dbg" then
		if AMPVP_DebugMode then
			AMPVP_DebugMode = false
			AMPVP_Print("Debug mode: Disabled")
		else
			AMPVP_DebugMode = true
			AMPVP_Print("Debug mode: Enabled")
		end
	end

	if cmp == "" then

		if AMPVP_SettingsUI:IsVisible() then
			AMPVP_SettingsUI:Hide()
		else
			AMPVP_SettingsUI:Show()
		end

	end

end

function AMPVP_PrintDebug(msg)

	if AMPVP_DebugMode then
		print("|cffc72429AMPVPDEBUG:|r "..tostring(msg))
	end

end
-----------FriendsTooltip Frame Start--------
local function maintainTooltipFrame()
	for i=1, 40 do
		local line = _G["AMPVP_FriendsListTooltipLine"..i]
		local lineRight = _G["AMPVP_FriendsListTooltipLine"..i.."Right"]

		if lineRight ~= nil and line ~= nil then
			line:SetText("")
			lineRight:SetText("")
		end
	end
end

AMPVP_friendsTTlines = {
	["nrLines"] = 0,
}

AMPVP_FriendsListTooltip:SetScript("OnUpdate", function(self)

	if FriendsTooltip:IsVisible() then

		maintainTooltipFrame()

		local a, b, c, x, y = FriendsTooltip:GetPoint()
		AMPVP_FriendsListTooltip:ClearAllPoints()
		if AMPVP_IsAddOnLoaded("RaiderIO") and GameTooltip:IsVisible() then
			AMPVP_FriendsListTooltip:SetPoint("TOPLEFT", GameTooltip ,"TOPLEFT", GameTooltip:GetWidth() + 5 , y )
		else
			AMPVP_FriendsListTooltip:SetPoint("TOPLEFT", FriendsTooltip ,"TOPLEFT", FriendsTooltip:GetWidth() + 5, y )
		end

		local ySpacer = 15
		for i=1, AMPVP_friendsTTlines["nrLines"] do

			local textLeft, textRight

			if AMPVP_friendsTTlines[i] ~= nil then
				textLeft, textRight = string.split("-", AMPVP_friendsTTlines[i])
			end

			local line = _G["AMPVP_FriendsListTooltipLine"..i]
			local lineRight = _G["AMPVP_FriendsListTooltipLine"..i.."Right"]

			if line == nil and lineRight == nil then

				local prevLineY = _G["AMPVP_FriendsListTooltipLine"..i-1]
				local prevLineRightY = _G["AMPVP_FriendsListTooltipLine".. i-1 .."Right"]

				if prevLineY == nil then
					-- here you can set the padding and such: it goes like: frameName, frameParent, lrOffset, xOffset, yOffset, text, fontName
					AMPVP_CreateText("AMPVP_FriendsListTooltipLine"..i, AMPVP_FriendsListTooltip, "TOPLEFT", 12, -9, "nimic yet")
				else
					AMPVP_CreateText("AMPVP_FriendsListTooltipLine"..i, AMPVP_FriendsListTooltip, "TOPLEFT", 12, select(5, prevLineY:GetPoint(1)) - ySpacer, "nimic yet")
				end

				if prevLineRightY == nil then
					AMPVP_CreateText("AMPVP_FriendsListTooltipLine"..i.."Right", AMPVP_FriendsListTooltip, "TOPRIGHT", -12, -9, "nimic yet")
				else
					AMPVP_CreateText("AMPVP_FriendsListTooltipLine"..i.."Right", AMPVP_FriendsListTooltip, "TOPRIGHT", -12, select(5, prevLineRightY:GetPoint(1)) - ySpacer, "nimic yet")
				end

				AMPVP_AddDoubleLine(line, lineRight, "", "")
			else
				AMPVP_AddDoubleLine(line, lineRight, textLeft, textRight)
			end

		end

		if AMPVP_friendsTTlines["nrLines"] > 1 then
			local linesCount = 0
			local bottomPaddingAdj = 15
			for k, v in pairs(AMPVP_friendsTTlines) do
				if k ~= nil and type(v) == "string" then
					linesCount = linesCount + 1
				end
			end
			if linesCount > 19 then
				bottomPaddingAdj = 10
			end
			AMPVP_FriendsListTooltip:SetSize(270, (AMPVP_friendsTTlines["nrLines"] * (AMPVP_FriendsListTooltipLine1:GetHeight() * 1.3) + bottomPaddingAdj))
		else
			AMPVP_FriendsListTooltip:SetSize(270, 35)
		end

	end

end)


local updateVisualTT = CreateFrame("frame")
updateVisualTT:SetScript("OnUpdate", function()
	if AMPVP_FriendsListTooltip.isAmPVPFromBnet then
		AMPVP_FriendsListTooltip:Show()
	else
		AMPVP_FriendsListTooltip:Hide()
	end
end)
-----------FriendsTooltip Frame End--------
