local region = GetCurrentRegion()
AMPVP_DebugMode = false

local russianRealmsEng = {
	["Азурегос"] = "Azuregos",
	["Голдринн"] = "Goldrinn",
	["Гордунни"] = "Gordunni",
	["Гром"] = "Grom",
	["Дракономор"] = "Fordragon",
	["Корольлич"] = "Lich King",
	["ПиратскаяБухта"] = "Booty Bay",
	["Разувий"] = "Razuvious",
	["ЧерныйШрам"] = "Blackscar",
	["Ясеневыйлес"] = "Ashenvale",
	["Борейскаятундра"] = "Borean Tundra",
	["Ревущийфьорд"] = "Howling Fjord",
	["СвежевательДуш"] = "Soulflayer",
	["Седогрив"] = "Greymane",
	["СтражСмерти"] = "Deathguard",
	["Термоштепсель"] = "Thermaplugg",
	["ВечнаяПесня"] = "Eversong",
	["Галакронд"] = "Galakrond",
	["ТкачСмерти"] = "Deathweaver",
}

local function tableHasEntries(tableN)
	
	local hasEntries = false
	
	if tableN ~= nil then
		for k, v in pairs(tableN) do
			if k ~= nil then
				hasEntries = true
			end
		end
	else
		return false
	end
	
	return hasEntries
	
end

if region == 1 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_US")
	if loaded then
		AMPVP_REGIONDATA = AMPVP_REGIONDATA_US
		AMPVP_Print("Current region: US", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 2 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_KR")
	if loaded then
		AMPVP_REGIONDATA = AMPVP_REGIONDATA_KR
		AMPVP_Print("Current region: KR", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 3 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_EU")
	if loaded then
		AMPVP_REGIONDATA = AMPVP_REGIONDATA_EU
		AMPVP_Print("Current region: EU", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 4 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_TW")
	if loaded then
		AMPVP_REGIONDATA = AMPVP_REGIONDATA_TW
		AMPVP_Print("Current region: TW", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 5 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_CH")
	if loaded then
		AMPVP_REGIONDATA = AMPVP_REGIONDATA_CH
		AMPVP_Print("Current region: CH", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
else
	AMPVP_Print("The data in your region is unavailable.", "red")
	AMPVP_REGIONDATA = {}
end

function AMPVP_AddTooltipDetails(userName, addSpacePlus, frameOwner, ownerAnchor)
	
	local regionDB = AMPVP_REGIONDATA
	local origOwner = GameTooltip:GetOwner()
	
	if frameOwner ~= nil then
		GameTooltip:SetOwner(frameOwner, ownerAnchor)
	end
	
	userName = string.gsub(userName, " ", "")

	local tempUserName, tempRealm = string.split("-", userName)

	for realmname, v in pairs(AMPVP_REALMLIST) do
		if string.gsub(realmname, " ", "") == tempRealm then
			userName = tempUserName.."-"..realmname
		end
	end
	
	for realmName, d in pairs(russianRealmsEng) do
		if string.gsub(realmName, " ", "") == tempRealm then
			userName = tempUserName.."-"..d
		end
	end

	if regionDB[userName] ~= nil and GameTooltip.ampvpHooked == nil then
		
		local twosaccexp = regionDB[userName]["a2s"]
		local threesaccexp = regionDB[userName]["a3s"]
		local twoscharexp = regionDB[userName]["e2s"]
		local threescharexp = regionDB[userName]["e3s"]
		local rbgexpacc = regionDB[userName]["aRBG"]
		local rbgexpchar = regionDB[userName]["eRBG"]
		local lastUpdated = regionDB[userName]["lu"]
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffc72429ArenaMaster Info: |r")
		
		if twosaccexp ~= nil and twosaccexp ~= 0 then
			GameTooltip:AddDoubleLine("2v2 Best:", AMPVP_RatingColorManager(twosaccexp))
		end
		
		if threesaccexp ~= nil and threesaccexp ~= 0 then
			GameTooltip:AddDoubleLine("3v3 Best:", AMPVP_RatingColorManager(threesaccexp))
		end
		
		if twoscharexp ~= nil and twoscharexp ~= 0 and AMPVP_CheckBracketDiff(userName, twoscharexp, twosaccexp) then
			GameTooltip:AddDoubleLine("2v2 Exp:", AMPVP_RatingColorManager(twoscharexp))
		end
		
		if threescharexp ~= nil and threescharexp ~= 0 and AMPVP_CheckBracketDiff(userName, threescharexp, threesaccexp) then
			GameTooltip:AddDoubleLine("3v3 Exp:", AMPVP_RatingColorManager(threescharexp))
		end

		if rbgexpacc ~= nil and rbgexpacc ~= 0 then
			GameTooltip:AddDoubleLine("RBG Best:", AMPVP_RatingColorManager(rbgexpacc))
		end
		
		if rbgexpchar ~= nil and rbgexpchar ~= 0 and AMPVP_CheckBracketDiff(userName, rbgexpchar, rbgexpacc) then
			GameTooltip:AddDoubleLine("RBG Exp:", AMPVP_RatingColorManager(rbgexpchar))
		end
		
		if lastUpdated ~= nil then
			GameTooltip:AddDoubleLine("Last Updated:", lastUpdated)
		end
		
		if addSpacePlus then
			GameTooltip:AddLine(" ")
		end
		
		if GameTooltip.ampvpHooked == nil then
			GameTooltip.ampvpHooked = true
		end
		GameTooltip:Show()

	else
		if GameTooltip.ampvpHooked == nil then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("ArenaMaster - No data available")
			if addSpacePlus then
				GameTooltip:AddLine(" ")
			end
		end
		if GameTooltip.ampvpHooked == nil then
			GameTooltip.ampvpHooked = true
		end
		GameTooltip:Show()
	end
end


function AMPVP_AddTooltipFrameText(userName)
	
	local regionDB = AMPVP_REGIONDATA
	
	userName = string.gsub(userName, " ", "")

	local tempUserName, tempRealm = string.split("-", userName)
	

	for realmname, v in pairs(AMPVP_REALMLIST) do
		if string.gsub(realmname, " ", "") == tempRealm then
			userName = tempUserName.."-"..realmname
		end
	end
	
	for realmName, d in pairs(russianRealmsEng) do
		if string.gsub(realmName, " ", "") == tempRealm then
			userName = tempUserName.."-"..d
		end
	end

	AMPVP_friendsTTlines["nrLines"] = 0
	local nrLines = AMPVP_friendsTTlines["nrLines"]
	
	if regionDB[userName] ~= nil then
		
		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = "|cffc72429ArenaMaster Info: |r"
		
		local twosaccexp = regionDB[userName]["a2s"]
		local threesaccexp = regionDB[userName]["a3s"]
		local twoscharexp = regionDB[userName]["e2s"]
		local threescharexp = regionDB[userName]["e3s"]
		local rbgexpacc = regionDB[userName]["aRBG"]
		local rbgexpchar = regionDB[userName]["eRBG"]
		local lastUpdated = regionDB[userName]["lu"]

		if twosaccexp ~= nil and twosaccexp ~= 0 then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "2v2 Best:-"..AMPVP_RatingColorManager(twosaccexp)
		end
		
		if threesaccexp ~= nil and threesaccexp ~= 0 then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "3v3 Best:-"..AMPVP_RatingColorManager(threesaccexp)
		end
		
		if twoscharexp ~= nil and twoscharexp ~= 0 and AMPVP_CheckBracketDiff(userName, twoscharexp, twosaccexp) then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "2v2 Exp:-"..AMPVP_RatingColorManager(twoscharexp)
		end
		
		if threescharexp ~= nil and threescharexp ~= 0 and AMPVP_CheckBracketDiff(userName, threescharexp, threesaccexp) then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "3v3 Exp:-" .. AMPVP_RatingColorManager(threescharexp)
		end

		if rbgexpacc ~= nil and rbgexpacc ~= 0 then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "RBG Best:-"..AMPVP_RatingColorManager(rbgexpacc)
		end
		
		if rbgexpchar ~= nil and rbgexpchar ~= 0 and AMPVP_CheckBracketDiff(userName, rbgexpchar, rbgexpacc) then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "RBG Exp:-"..AMPVP_RatingColorManager(rbgexpchar)
		end
		
		if lastUpdated ~= nil then
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = "Last Updated-"..lastUpdated
		end

		AMPVP_friendsTTlines["nrLines"] = nrLines

	else
		nrLines = nrLines + 1
		
		AMPVP_friendsTTlines[nrLines] = "ArenaMaster - No data available"
		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = " "
		AMPVP_friendsTTlines["nrLines"] = nrLines
	end
end

function AMPVP_AddTooltipBnet(userName, showName, addSpacePlus, frameOwner, ownerAnchor)
	
	local regionDB = AMPVP_REGIONDATA

	if frameOwner ~= nil then
		GameTooltip:SetOwner(frameOwner, ownerAnchor)
	end
	
	if showName then
		GameTooltip:AddLine(userName)
	end
	local name, realm = string.split("-", userName)
	
	AMPVP_PrintDebug("BnetTootip for user: " ..userName.. ", Slug:" ..AMPVP_FixSlangRealms(realm) .. " for realm:" .. realm)
	
	if regionDB[userName] ~= nil then
		
		local twosaccexp = regionDB[userName]["a2s"]
		local threesaccexp = regionDB[userName]["a3s"]
		local twoscharexp = regionDB[userName]["e2s"]
		local threescharexp = regionDB[userName]["e3s"]
		local rbgexpacc = regionDB[userName]["aRBG"]
		local rbgexpchar = regionDB[userName]["eRBG"]
		local lastUpdated = regionDB[userName]["lu"]
		
		AMPVP_PrintDebug("Data for this user has returned succesfully")
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("ArenaMaster Info:")
		if twosaccexp ~= nil and twosaccexp ~= 0 then
			GameTooltip:AddDoubleLine("2v2 Best:", AMPVP_RatingColorManager(twosaccexp))
		end
		
		if threesaccexp ~= nil and threesaccexp ~= 0 then
			GameTooltip:AddDoubleLine("3v3 Best:", AMPVP_RatingColorManager(threesaccexp))
		end
		
		if twoscharexp ~= nil and twoscharexp ~= 0 and AMPVP_CheckBracketDiff(userName, twoscharexp, twosaccexp) then
			GameTooltip:AddDoubleLine("2v2 Exp:", AMPVP_RatingColorManager(twoscharexp))
		end
		
		if threescharexp ~= nil and threescharexp ~= 0 and AMPVP_CheckBracketDiff(userName, threescharexp, threesaccexp) then
			GameTooltip:AddDoubleLine("3v3 Exp:", AMPVP_RatingColorManager(threescharexp))
		end

		if rbgexpacc ~= nil and rbgexpacc ~= 0 then
			GameTooltip:AddDoubleLine("RBG Best:", AMPVP_RatingColorManager(rbgexpacc))
		end
		
		if rbgexpchar ~= nil and rbgexpchar ~= 0 and AMPVP_CheckBracketDiff(userName, rbgexpchar, rbgexpacc) then
			GameTooltip:AddDoubleLine("RBG Exp:", AMPVP_RatingColorManager(rbgexpchar))
		end
		
		if lastUpdated ~= nil then
			GameTooltip:AddDoubleLine("Last Updated:", lastUpdated)
		end
		
		if addSpacePlus then
			GameTooltip:AddLine(" ")
		end
		
		GameTooltip:Show()
	else
		AMPVP_PrintDebug("This user has no available data...")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("ArenaMaster - No data available")
		GameTooltip:Show()

	end
end

function AMPVP_CheckBracketDiff(user, points1, points2)

	local shouldShow = false
	local regionDB = AMPVP_REGIONDATA
	
	local brackets = {
		2700,
		2400,
		2100,
		1800,
		1600,
	}

	if points2 == nil then
		points2 = 0
	end
	
	if points1 == nil then
		points1 = 0
	end
	
	local bracket1 = nil
	local bracket2 = nil
	
	for k, v in pairs(brackets) do

		if points1 >= v and points1 > 0 and bracket1 == nil then
			bracket1 = k
		end
		
		if points2 >= v and bracket2 == nil then
			bracket2 = k
		end
	
	end

	if bracket1 ~= nil and bracket2 ~= nil and bracket1 ~= bracket2 then
		return true
	end
	
	if bracket1 ~= nil and bracket2 == nil or bracket1 == nil and bracket2 ~= nil then
		return true
	end

end