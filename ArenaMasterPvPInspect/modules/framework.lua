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

	local button = CreateFrame("Button", buttonName, frameParent, "UIPanelButtonTemplate")
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


	local checkbox = CreateFrame("CheckButton", boxName, frameParent, "UICheckButtonTemplate")
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

function AMPVP_RatingColorManager(points)

	local finalPoints = ""

	--print(points)

	if points >= 2700 then
		finalPoints = '|cffff8000'..points.."|r"
	elseif points >= 2400 then
		finalPoints = '|cffa335ee'..points.."|r"
	elseif points >= 2100 then
		finalPoints = '|cff0070dd'..points.."|r"
	elseif points >= 1800 then
		finalPoints = '|cff27ae60'..points.."|r"
	elseif points >= 1600 then
		finalPoints = '|cfffff000'..points.."|r"
	else
		finalPoints = '|cff9d9d9d'..points.."|r"
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
