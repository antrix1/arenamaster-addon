local region = GetCurrentRegion()
AMPVP_DebugMode = false
local patreonTooltipSpacing = 14

local entryKeys = {
	dbSeparator = ".",
	currentRatingShort = "cr",
	currentSeasonShort = "cs",
	titlesShot = "t",
	c2v2Short = "2",
	c3v3Short = "3",
	RBGShort = "r",
	characterExpShort = "ex",
	winrateShort = "wr",
	gamesPlayedShort = "p",
	accountRaingShort = "a",
	statsShort = "s",
	lastUpdateShort = "ua",
	achievementsShort = "a",
	itemLevelShort = "il",
	versatilityShort = "ve",
	healthShort = "hp",
	patreon = "p",
}

local tableCovenants = {
	[1] = "Necrolord",
	[2] = "Night Fae",
	[3] = "Venthyr",
	[4] = "Kyrian",
	[0] = "None",
}

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
		AMPVP_REGIONDATA_HORDE = AMPVP_REGIONDATA_US_HORDE
		AMPVP_REGIONDATA_ALLIANCE = AMPVP_REGIONDATA_US_ALLIANCE
		AMPVP_Print("Current region: US", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 2 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_KR")
	if loaded then
		AMPVP_REGIONDATA_HORDE = AMPVP_REGIONDATA_KR_HORDE
		AMPVP_REGIONDATA_ALLIANCE = AMPVP_REGIONDATA_KR_ALLIANCE
		AMPVP_Print("Current region: KR", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 3 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_EU")
	if loaded then
		AMPVP_REGIONDATA_HORDE = AMPVP_REGIONDATA_EU_HORDE
		AMPVP_REGIONDATA_ALLIANCE = AMPVP_REGIONDATA_EU_ALLIANCE
		AMPVP_Print("Current region: EU", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 4 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_TW")
	if loaded then
		AMPVP_REGIONDATA_HORDE = AMPVP_REGIONDATA_TW_HORDE
		AMPVP_REGIONDATA_ALLIANCE = AMPVP_REGIONDATA_TW_ALLIANCE
		AMPVP_Print("Current region: TW", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
elseif region == 5 then
	local loaded, rsn = LoadAddOn("ArenaMaster_DB_CH")
	if loaded then
		AMPVP_REGIONDATA_HORDE = AMPVP_REGIONDATA_CH_HORDE
		AMPVP_REGIONDATA_ALLIANCE = AMPVP_REGIONDATA_CH_ALLIANCE
		AMPVP_Print("Current region: CH", "green")
	else
		AMPVP_Print("Regional data does not exist. Make sure you have the latest version of the AddOn running.", "red")
	end
else
	AMPVP_Print("The data in your region is unavailable.", "red")
	AMPVP_REGIONDATA_ALLIANCE = {}
	AMPVP_REGIONDATA_HORDE = {}
end

function AMPVP_AddTooltipDetails(userName, addSpacePlus, frameOwner, ownerAnchor, xOffset, yOffset)
	GameTooltip.ampvpHooked = true
	local regionDB1 = AMPVP_REGIONDATA_HORDE
	local regionDB2 = AMPVP_REGIONDATA_ALLIANCE
	local regionDB = regionDB1
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
	
	if not regionDB[userName] then
		regionDB = regionDB2
	end
	
	--[[if regionDB[userName] == nil then
		regionDB[userName] = {["ex"]={["2"]=0,["3"]=1996,["r"]=2500},["cr"]={["2"]=0,["3"]=0,["r"]=0},["cs"]={["t"]={111},["2"]={["p"]=0,["wr"]=0},["3"]={["p"]=0,["wr"]=0},["r"]={["p"]=0,["wr"]=0}},["a"]={35,30,66,1},["s"]={["il"]=206,["co"]=2,["re"]=26,["hp"]=32,840,["ve"]=17.45},["ua"]="11/4/21"}
	end]]--

	if regionDB[userName] ~= nil then
		--current rating
		local cr2s = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.c2v2Short)
		local cr3s = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.c3v3Short)
		local crrbg = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.RBGShort)

		--current season
		local cseason_2srating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c2v2Short..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_2swinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c2v2Short..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_3srating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c3v3Short..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_3swinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c3v3Short..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_rbgsrating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.RBGShort..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_rbgswinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.RBGShort..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_titles = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.titlesShot, true)

		--character exp
		local exp2s = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.c2v2Short)
		local exp3s = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.c3v3Short)
		local exprbg = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.RBGShort)

		--account achievements
		local acc_achievements = AMPVP_GetValue(regionDB[userName], entryKeys.achievementsShort, true)

		--highest account rating
		local acc2s = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.c2v2Short)
		local acc3s = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.c3v3Short)
		local accrbg = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.RBGShort)

		--character stats
		local itemLevel = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.itemLevelShort)
		local versatility = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.versatilityShort)
		local health = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.healthShort)
		local lastUpdated = AMPVP_ConvertDateToStandardEU(AMPVP_GetValue(regionDB[userName], entryKeys.lastUpdateShort))

		GameTooltip:AddLine(" ")
		local spacesTitle = " "
		for i=1, patreonTooltipSpacing - 5 do
			spacesTitle = spacesTitle .. " "
		end
		GameTooltip:AddLine(spacesTitle.."|cffc72429ArenaMaster.IO PvP Info: |r")
		
		local patreonSupporter = AMPVP_GetValue(regionDB[userName], entryKeys.patreon)
		
		if patreonSupporter then
			local spaces = " "
			for i=1, patreonTooltipSpacing do
				spaces = spaces .. " "
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cfff0ce56" .. spaces .. "Patreon Supporter|r")
			GameTooltip:AddLine(spaces.."**************")
		end
		
		--init vars to avoid multiplcation of lines & avoid padding multiple times when entire sections are disabled
		local currentRatingInit = false
		local currentSeasonInit = false
		local characterExpInit = false
		local achievementsInit = false
		local highestAccRatingInit = false
		local characterStatsInit = false
		local lastUpdatedInit = false
		-- current rating
		if not currentRatingInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (cr2s and (AMPVP_GetSettingValue("CURR_RATING_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_2s") and inInstance)) or
				cr3s and (AMPVP_GetSettingValue("CURR_RATING_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_3s") and inInstance)) or
				crrbg and (AMPVP_GetSettingValue("CURR_RATING_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_RBG") and inInstance))) then
				if not titleDisplayed then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Current Rating:")
					titleDisplayed = true
				end
			end

			if cr2s and not tsdisplayed and (AMPVP_GetSettingValue("CURR_RATING_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_2s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2","white"),AMPVP_RatingColorManager(cr2s))
				tsdisplayed = true
				currentRatingInit = true
			end
			if cr3s and not thsdisplayed and (AMPVP_GetSettingValue("CURR_RATING_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_3s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("3v3", "white"),AMPVP_RatingColorManager(cr3s))
				thsdisplayed = true
				currentRatingInit = true
			end
			if crrbg and not rbgdisplayed and (AMPVP_GetSettingValue("CURR_RATING_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_RBG") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("RBG", "white"),AMPVP_RatingColorManager(crrbg))
				rbgdisplayed = true
				currentRatingInit = true
			end
		end
		--character exp
		if not characterExpInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (exp2s and (AMPVP_GetSettingValue("CHAR_EXP_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_2s") and inInstance)) or
				exp3s and (AMPVP_GetSettingValue("CHAR_EXP_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_3s") and inInstance)) or
				exprbg and (AMPVP_GetSettingValue("CHAR_EXP_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_RBG") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Character Experience:")
					titleDisplayed = true
				end
			end

			if exp2s and not tsdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_2s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2","white"),AMPVP_RatingColorManager(exp2s))
				tsdisplayed = true
				characterExpInit = true
			end
			if exp3s and not thsdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_3s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("3v3", "white"),AMPVP_RatingColorManager(exp3s))
				thsdisplayed = true
				characterExpInit = true
			end
			if exprbg and not rbgdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_RBG") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("RBG", "white"),AMPVP_RatingColorManager(exprbg))
				rbgdisplayed = true
				characterExpInit = true
			end

		end

		--highest account rating
		if not highestAccRatingInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (acc2s and (AMPVP_GetSettingValue("HIGHEST_ACC_2s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_2s") and inInstance)) or
				acc3s and (AMPVP_GetSettingValue("HIGHEST_ACC_3s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_3s") and inInstance)) or
				accrbg and (AMPVP_GetSettingValue("HIGHEST_ACC_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_RBG") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Highest Account Rating")
					titleDisplayed = true
				end
			end

			if acc2s and not tsdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_2s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_2s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2","white"),AMPVP_RatingColorManager(acc2s))
				tsdisplayed = true
				highestAccRatingInit = true
			end
			if acc3s and not thsdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_3s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_3s") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("3v3", "white"),AMPVP_RatingColorManager(acc3s))
				thsdisplayed = true
				highestAccRatingInit = true
			end
			if accrbg and not rbgdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_RBG") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("RBG", "white"),AMPVP_RatingColorManager(accrbg))
				rbgdisplayed = true
				highestAccRatingInit = true
			end
		end
		--current season
		if not currentSeasonInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false
			if (cseason_2srating and (AMPVP_GetSettingValue("CURR_SEASON_2SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_2SW") and inInstance)) or
				cseason_3srating and (AMPVP_GetSettingValue("CURR_SEASON_3SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_3SW") and inInstance)) or
				cseason_rbgsrating and (AMPVP_GetSettingValue("CURR_SEASON_RBGW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_RBGW") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Current Season:")
					titleDisplayed = true
				end
			end
			if cseason_2srating and not tsdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_2SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_2SW") and inInstance)) then
				if cseason_2swinp ~= nil then
					if cseason_2swinp < 50 then
						cseason_2swinp = AMPVP_ColorSub(cseason_2swinp, "redwinrate", true)
					else
						cseason_2swinp = AMPVP_ColorSub(cseason_2swinp, "greenwinrate", true)
					end
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2", "white"), cseason_2srating..AMPVP_ColorSub(" games played (", "white")..cseason_2swinp..AMPVP_ColorSub(" won)", "white"))
				else
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2", "white"), cseason_2srating..AMPVP_ColorSub(" games played", "white"))
				end
				tsdisplayed = true
				currentSeasonInit = true
			end
			if cseason_3srating and not thsdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_3SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_3SW") and inInstance)) then
				if cseason_3swinp ~= nil then
					if cseason_3swinp < 50 then
						cseason_3swinp = AMPVP_ColorSub(cseason_3swinp, "redwinrate", true)
					else
						cseason_3swinp = AMPVP_ColorSub(cseason_3swinp, "greenwinrate", true)
					end
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("3v3", "white"), cseason_3srating..AMPVP_ColorSub(" games played (", "white")..cseason_3swinp..AMPVP_ColorSub(" won)", "white"))
				else
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("3v3", "white"), cseason_3srating..AMPVP_ColorSub(" games played", "white"))
				end
				thsdisplayed = true
				currentSeasonInit = true
			end
			if cseason_rbgsrating and not rbgdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_RBGW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_RBGW") and inInstance)) then
				if cseason_rbgswinp ~= nil then
					if cseason_rbgswinp < 50 then
						cseason_rbgswinp = AMPVP_ColorSub(cseason_rbgswinp, "redwinrate", true)
					else
						cseason_rbgswinp = AMPVP_ColorSub(cseason_rbgswinp, "greenwinrate", true)
					end
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("RBG", "white"), cseason_rbgsrating..AMPVP_ColorSub(" games played (","white")..cseason_rbgswinp..AMPVP_ColorSub(" won)", "white"))
				else
					GameTooltip:AddDoubleLine(AMPVP_ColorSub("RBG", "white"), cseason_rbgsrating..AMPVP_ColorSub(" games played","white"))
				end
				rbgdisplayed = true
				currentSeasonInit = true
			end
		end
		--season titles
		if cseason_titles and not shouldDisable then
			local displayed = false
			if not displayed and (AMPVP_GetSettingValue("CURR_SEASON_TITLES") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_TITLES") and inInstance)) then

				local multipleTitles = false
				local titlesLine = {}
				for s in cseason_titles:gmatch("[^\r\n]+") do
					table.insert(titlesLine, AMPVP_AchievementsAndTitlesList[tonumber(s)])
				end

				if #titlesLine > 1 then
					multipleTitles = true
				elseif #titlesLine == 0 then
					multipleTitles = nil
				elseif #titlesLine == 1 then
					multipleTitles = false
				end

				if multipleTitles ~= nil and multipleTitles == false then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Current Season Title:");
					GameTooltip:AddLine(AMPVP_ConvertRankAchievement(titlesLine[1]))
				elseif multipleTitles ~= nil and multipleTitles then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Current Expansion Titles:")
					for k, v in pairs(titlesLine) do
						GameTooltip:AddLine("-"..AMPVP_ConvertRankAchievement(v))
					end

				end
				displayed = true
			end
		end
		--account achievements
		if acc_achievements and not shouldDisable and not achievementsInit then
			local displayed = false
			if not displayed and (AMPVP_GetSettingValue("ACHI_SHOW") and not inInstance or (AMPVP_GetSettingValue("INST_ACHI_SHOW") and inInstance)) then

				local multipleAchievs = false
				local achievementsLines = {}
				for s in acc_achievements:gmatch("[^\r\n]+") do
					table.insert(achievementsLines, AMPVP_AchievementsAndTitlesList[tonumber(s)])
				end

				if #achievementsLines > 2 then
					multipleAchievs = true
				end

				if not multipleAchievs then
					if currentRatingInit or currentSeasonInit or characterExpInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Achievement: "..AMPVP_ConvertRankAchievement(achievementsLines[1]));
					achievementsInit = true
				else
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Achievements:")
					for k, v in pairs(achievementsLines) do
						GameTooltip:AddLine("-"..AMPVP_ConvertRankAchievement(v))
					end
					achievementsInit = true
				end
				displayed = true
			end
		end

		if not characterStatsInit and not shouldDisable then

			local titleDisplayed = false
			local healthDisplayed = false
			local versaDisplayed = false
			local itemLevelDisplayed = false

			if (itemLevel and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) or
				health and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) or
				versatility and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit or achievementsInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Character Stats:")
					titleDisplayed = true
				end
			end

			if health and not healthDisplayed and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("Health","white"), health.."k")
				healthDisplayed = true
				characterStatsInit = true
			end
			if itemLevel and not itemLevelDisplayed and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("Item Level", "white"), itemLevel)
				itemLevelDisplayed = true
				characterStatsInit = true
			end
			if versatility and not versaDisplayed and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("Versatility", "white"), versatility)
				versaDisplayed = true
				characterStatsInit = true
			end
		end

		if not lastUpdatedInit and lastUpdated and not shouldDisable then

			local titleDisplayed = false

			if not titleDisplayed then
				if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit or achievementsInit or characterStatsInit then
					GameTooltip:AddLine(" ")
				end
				GameTooltip:AddDoubleLine("Last Updated:", AMPVP_ColorSub(lastUpdated, "white"))
				lastUpdatedInit = true
			end

		end

		GameTooltip:Show()

	else
		if not AMPVP_GetSettingValue("DISABLE_EMPTY_DATA") then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("ArenaMaster.IO - No data available."..AMPVP_ColorSub("\nVisit this character's ArenaMaster Profile \nand their info will be available on the next addon update.", "white"))
			if addSpacePlus then
				GameTooltip:AddLine(" ")
			end
		end
		GameTooltip:Show()
	end
end


function AMPVP_AddTooltipFrameText(userName)

	local regionDB1 = AMPVP_REGIONDATA_HORDE
	local regionDB2 = AMPVP_REGIONDATA_ALLIANCE
	local regionDB = regionDB1

	userName = string.gsub(userName, " ", "")

	local tempUserName, tempRealm = string.split("-", userName)

	local inInstance, instanceType = IsInInstance()
	local shouldDisable = inInstance and AMPVP_GetSettingValue("DISABLE_RAIDS_DUNGEONS") and (instanceType == "raid" or instanceType == "party")

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
	
	if not regionDB[userName] then
		regionDB = regionDB2
	end
	
	wipe(AMPVP_friendsTTlines)
	AMPVP_friendsTTlines["nrLines"] = 0
	local nrLines = AMPVP_friendsTTlines["nrLines"]

	if regionDB[userName] ~= nil then
		nrLines = 0

		nrLines = nrLines + 1
		local spacesTitle = " "
		for i=1, patreonTooltipSpacing - 7 do
			spacesTitle = spacesTitle .. " "
		end
		AMPVP_friendsTTlines[nrLines] = spacesTitle.."|cffc72429ArenaMaster.IO PvP Info: |r"
		
		local patreonSupporter = AMPVP_GetValue(regionDB[userName], entryKeys.patreon)
		
		if patreonSupporter then
			local spaces = " "
			for i=1, patreonTooltipSpacing - 5 do
				spaces = spaces .. " "
			end
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = " "
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = spaces .. "|cfff0ce56Patreon Supporter|r"
			nrLines = nrLines + 1
			AMPVP_friendsTTlines[nrLines] = spaces .. "**************"
		end
		
		--current rating
		local cr2s = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.c2v2Short)
		local cr3s = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.c3v3Short)
		local crrbg = AMPVP_GetValue(regionDB[userName], entryKeys.currentRatingShort..entryKeys.dbSeparator..entryKeys.RBGShort)

		--current season
		local cseason_2srating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c2v2Short..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_2swinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c2v2Short..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_3srating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c3v3Short..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_3swinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.c3v3Short..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_rbgsrating = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.RBGShort..entryKeys.dbSeparator..entryKeys.gamesPlayedShort)
		local cseason_rbgswinp = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.RBGShort..entryKeys.dbSeparator..entryKeys.winrateShort)

		local cseason_titles = AMPVP_GetValue(regionDB[userName], entryKeys.currentSeasonShort..entryKeys.dbSeparator..entryKeys.titlesShot, true)

		--character exp
		local exp2s = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.c2v2Short)
		local exp3s = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.c3v3Short)
		local exprbg = AMPVP_GetValue(regionDB[userName], entryKeys.characterExpShort..entryKeys.dbSeparator..entryKeys.RBGShort)

		--account achievements
		local acc_achievements = AMPVP_GetValue(regionDB[userName], entryKeys.achievementsShort, true)

		--highest account rating
		local acc2s = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.c2v2Short)
		local acc3s = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.c3v3Short)
		local accrbg = AMPVP_GetValue(regionDB[userName], entryKeys.accountRaingShort..entryKeys.RBGShort)

		--character stats
		local itemLevel = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.itemLevelShort)
		local versatility = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.versatilityShort)
		local health = AMPVP_GetValue(regionDB[userName], entryKeys.statsShort..entryKeys.dbSeparator..entryKeys.healthShort)
		local lastUpdated = AMPVP_ConvertDateToStandardEU(AMPVP_GetValue(regionDB[userName], entryKeys.lastUpdateShort))

		--init vars to avoid multiplcation of lines & avoid padding multiple times when entire sections are disabled
		local currentRatingInit = false
		local currentSeasonInit = false
		local characterExpInit = false
		local achievementsInit = false
		local highestAccRatingInit = false
		local characterStatsInit = false
		local lastUpdatedInit = false
		-- current rating
		if not currentRatingInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (cr2s and (AMPVP_GetSettingValue("CURR_RATING_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_2s") and inInstance)) or
				cr3s and (AMPVP_GetSettingValue("CURR_RATING_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_3s") and inInstance)) or
				crrbg and (AMPVP_GetSettingValue("CURR_RATING_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_RBG") and inInstance))) then
				if not titleDisplayed then

					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = ("Current Rating:")
					titleDisplayed = true
				end
			end

			if cr2s and not tsdisplayed and (AMPVP_GetSettingValue("CURR_RATING_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_2s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("2v2","white").."-"..AMPVP_RatingColorManager(cr2s)
				--GameTooltip:AddDoubleLine(AMPVP_ColorSub("2v2","white"),AMPVP_RatingColorManager(cr2s))
				tsdisplayed = true
				currentRatingInit = true
			end
			if cr3s and not thsdisplayed and (AMPVP_GetSettingValue("CURR_RATING_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_3s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("3v3","white").."-"..AMPVP_RatingColorManager(cr3s)
				thsdisplayed = true
				currentRatingInit = true
			end
			if crrbg and not rbgdisplayed and (AMPVP_GetSettingValue("CURR_RATING_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_RATING_RBG") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("RBG","white").."-"..AMPVP_RatingColorManager(crrbg)
				rbgdisplayed = true
				currentRatingInit = true
			end
		end
		--character exp
		if not characterExpInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (exp2s and (AMPVP_GetSettingValue("CHAR_EXP_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_2s") and inInstance)) or
				exp3s and (AMPVP_GetSettingValue("CHAR_EXP_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_3s") and inInstance)) or
				exprbg and (AMPVP_GetSettingValue("CHAR_EXP_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_RBG") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Character Experience:"
					titleDisplayed = true
				end
			end

			if exp2s and not tsdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_2s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_2s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("2v2","white").."-"..AMPVP_RatingColorManager(exp2s)
				tsdisplayed = true
				characterExpInit = true
			end
			if exp3s and not thsdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_3s") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_3s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("3v3","white").."-"..AMPVP_RatingColorManager(exp3s)
				thsdisplayed = true
				characterExpInit = true
			end
			if exprbg and not rbgdisplayed and (AMPVP_GetSettingValue("CHAR_EXP_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_CHAR_EXP_RBG") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("RBG","white").."-"..AMPVP_RatingColorManager(exprbg)
				rbgdisplayed = true
				characterExpInit = true
			end

		end

		--highest account rating
		if not highestAccRatingInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false

			if (acc2s and (AMPVP_GetSettingValue("HIGHEST_ACC_2s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_2s") and inInstance)) or
				acc3s and (AMPVP_GetSettingValue("HIGHEST_ACC_3s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_3s") and inInstance)) or
				accrbg and (AMPVP_GetSettingValue("HIGHEST_ACC_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_RBG") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Highest Account Rating"
					titleDisplayed = true
				end
			end

			if acc2s and not tsdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_2s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_2s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("2v2","white").."-"..AMPVP_RatingColorManager(acc2s)
				tsdisplayed = true
				highestAccRatingInit = true
			end
			if acc3s and not thsdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_3s") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_3s") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("3v3","white").."-"..AMPVP_RatingColorManager(acc3s)
				thsdisplayed = true
				highestAccRatingInit = true
			end
			if accrbg and not rbgdisplayed and (AMPVP_GetSettingValue("HIGHEST_ACC_RBG") and not inInstance or (AMPVP_GetSettingValue("INST_HIGHEST_ACC_RBG") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("RBG","white").."-"..AMPVP_RatingColorManager(accrbg)
				rbgdisplayed = true
				highestAccRatingInit = true
			end
		end
		--current season
		if not currentSeasonInit and not shouldDisable then

			local titleDisplayed = false
			local tsdisplayed = false
			local thsdisplayed = false
			local rbgdisplayed = false
			if (cseason_2srating and (AMPVP_GetSettingValue("CURR_SEASON_2SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_2SW") and inInstance)) or
				cseason_3srating and (AMPVP_GetSettingValue("CURR_SEASON_3SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_3SW") and inInstance)) or
				cseason_rbgsrating and (AMPVP_GetSettingValue("CURR_SEASON_RBGW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_RBGW") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or characterExpInit or highestAccRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines]=""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Current Season:"
					titleDisplayed = true
				end
			end
			if cseason_2srating and not tsdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_2SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_2SW") and inInstance)) then
				if cseason_2swinp ~= nil then
					if cseason_2swinp < 50 then
						cseason_2swinp = AMPVP_ColorSub(cseason_2swinp, "redwinrate", true)
					else
						cseason_2swinp = AMPVP_ColorSub(cseason_2swinp, "greenwinrate", true)
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("2v2", "white").."-"..cseason_2srating..AMPVP_ColorSub(" games played (", "white")..cseason_2swinp..AMPVP_ColorSub(" won)", "white"))
				else
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("2v2", "white").."-"..cseason_2srating..AMPVP_ColorSub(" games played", "white"))
				end
				tsdisplayed = true
				currentSeasonInit = true
			end
			if cseason_3srating and not thsdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_3SW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_3SW") and inInstance)) then
				if cseason_3swinp ~= nil then
					if cseason_3swinp < 50 then
						cseason_3swinp = AMPVP_ColorSub(cseason_3swinp, "redwinrate", true)
					else
						cseason_3swinp = AMPVP_ColorSub(cseason_3swinp, "greenwinrate", true)
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("3v3", "white").."-"..cseason_3srating..AMPVP_ColorSub(" games played (", "white")..cseason_3swinp..AMPVP_ColorSub(" won)", "white"))
				else
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("3v3", "white").."-"..cseason_3srating..AMPVP_ColorSub(" games played", "white"))
				end
				thsdisplayed = true
				currentSeasonInit = true
			end
			if cseason_rbgsrating and not rbgdisplayed and (AMPVP_GetSettingValue("CURR_SEASON_RBGW") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_RBGW") and inInstance)) then
				if cseason_rbgswinp ~= nil then
					if cseason_rbgswinp < 50 then
						cseason_rbgswinp = AMPVP_ColorSub(cseason_rbgswinp, "redwinrate", true)
					else
						cseason_rbgswinp = AMPVP_ColorSub(cseason_rbgswinp, "greenwinrate", true)
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("RBG", "white").."-"..cseason_rbgsrating..AMPVP_ColorSub(" games played (", "white")..cseason_rbgswinp..AMPVP_ColorSub(" won)", "white"))
				else
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = (AMPVP_ColorSub("RBG", "white").."-"..cseason_rbgsrating..AMPVP_ColorSub(" games played", "white"))
				end
				rbgdisplayed = true
				currentSeasonInit = true
			end
		end
		--season titles
		if cseason_titles and not shouldDisable then
			local displayed = false
			if not displayed and (AMPVP_GetSettingValue("CURR_SEASON_TITLES") and not inInstance or (AMPVP_GetSettingValue("INST_CURR_SEASON_TITLES") and inInstance)) then

				local multipleTitles = false
				local titlesLine = {}
				for s in cseason_titles:gmatch("[^\r\n]+") do
					table.insert(titlesLine, AMPVP_AchievementsAndTitlesList[tonumber(s)])
				end

				if #titlesLine > 1 then
					multipleTitles = true
				end

				if not multipleTitles then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Current Season Title:";
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = AMPVP_ConvertRankAchievement(titlesLine[1])
					displayed = true
				else
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Current Expansion Titles:"
					for k, v in pairs(titlesLine) do
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = "*"..AMPVP_ConvertRankAchievement(v)
					end
					displayed = true
				end

			end
		end
		--account achievements
		if acc_achievements and not shouldDisable and not achievementsInit then
			local displayed = false
			if not displayed and (AMPVP_GetSettingValue("ACHI_SHOW") and not inInstance or (AMPVP_GetSettingValue("INST_ACHI_SHOW") and inInstance)) then

				local multipleAchievements = false
				local achievsLines = {}
				for s in acc_achievements:gmatch("[^\r\n]+") do
					table.insert(achievsLines, AMPVP_AchievementsAndTitlesList[tonumber(s)])
				end

				if #achievsLines > 1 then
					multipleAchievements = true
				end

				if not multipleAchievements then
					if currentRatingInit or currentSeasonInit or characterExpInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Achievement: "..AMPVP_ConvertRankAchievement(achievsLines[1])
					achievementsInit = true
					displayed = true
				else
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] =" "
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Achievements:"
					for k, v in pairs(achievsLines) do
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = "*"..AMPVP_ConvertRankAchievement(v)
					end
					achievementsInit = true
					displayed = true
				end
			end
		end

		if not characterStatsInit and not shouldDisable then

			local titleDisplayed = false
			local healthDisplayed = false
			local versaDisplayed = false
			local itemLevelDisplayed = false

			if (itemLevel and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) or
				health and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) or
				versatility and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance))) then
				if not titleDisplayed then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit or achievementsInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Character Stats:"
					titleDisplayed = true
				end
			end

			if health and not healthDisplayed and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("Health","white").."-"..health.."k"
				healthDisplayed = true
				characterStatsInit = true
			end
			if itemLevel and not itemLevelDisplayed and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("Item Level", "white").."-"..itemLevel
				itemLevelDisplayed = true
				characterStatsInit = true
			end
			if versatility and not versaDisplayed and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("Versatility", "white").."-"..versatility
				versaDisplayed = true
				characterStatsInit = true
			end
		end

		if not lastUpdatedInit and lastUpdated and not shouldDisable then

			local titleDisplayed = false

			if not titleDisplayed then
				if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit or achievementsInit or characterStatsInit then
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = ""
				end
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = "Last Updated:".."-"..AMPVP_ColorSub(lastUpdated, "white")
				lastUpdatedInit = true
			end

		end

		AMPVP_friendsTTlines["nrLines"] = nrLines
		AMPVP_FriendsListTooltip.isAmPVPFromBnet = true

	else
		if AMPVP_GetSettingValue("DISABLE_EMPTY_DATA") then
			AMPVP_FriendsListTooltip.isAmPVPFromBnet = nil
			return
		end

		AMPVP_FriendsListTooltip.isAmPVPFromBnet = true
		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = "ArenaMaster.IO - No data available."
		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = " "
		AMPVP_friendsTTlines["nrLines"] = nrLines
	end
end
