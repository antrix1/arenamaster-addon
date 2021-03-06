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
	local inInstance, instanceType = IsInInstance()
	local inCombatDisable = InCombatLockdown() and AMPVP_GetSettingValue("DISABLE_IN_COMBATENV")
	local inPVPEnvironmentDisable = AMPVP_GetSettingValue("DISABLE_IN_PVPENV") and inInstance and (instanceType == "arena" or instanceType == "pvp")
	local shouldDisable = inInstance and AMPVP_GetSettingValue("DISABLE_RAIDS_DUNGEONS") and (instanceType == "raid" or instanceType == "party")
	
	if inPVPEnvironmentDisable then return end
	if inCombatDisable then return end
	if shouldDisable then return end

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
		--current rating
		local cr2s = AMPVP_GetValue(regionDB[userName], "cr.2v2")
		local cr3s = AMPVP_GetValue(regionDB[userName], "cr.3v3")
		local crrbg = AMPVP_GetValue(regionDB[userName], "cr.rbg")

		--current season
		local cseason_2srating = AMPVP_GetValue(regionDB[userName], "current_season.2v2.played")
		local cseason_2swinp = AMPVP_GetValue(regionDB[userName], "current_season.2v2.win_rate")

		local cseason_3srating = AMPVP_GetValue(regionDB[userName], "current_season.3v3.played")
		local cseason_3swinp = AMPVP_GetValue(regionDB[userName], "current_season.3v3.win_rate")

		local cseason_rbgsrating = AMPVP_GetValue(regionDB[userName], "current_season.rbg.played")
		local cseason_rbgswinp = AMPVP_GetValue(regionDB[userName], "current_season.rbg.win_rate")

		local cseason_titles = AMPVP_GetValue(regionDB[userName], "current_season.titles", true)

		--character exp
		local exp2s = AMPVP_GetValue(regionDB[userName], "exp.2v2")
		local exp3s = AMPVP_GetValue(regionDB[userName], "exp.3v3")
		local exprbg = AMPVP_GetValue(regionDB[userName], "exp.rbg")

		--account achievements
		local acc_achievements = AMPVP_GetValue(regionDB[userName], "achievements", true)

		--highest account rating
		local acc2s = AMPVP_GetValue(regionDB[userName], "acc2s")
		local acc3s = AMPVP_GetValue(regionDB[userName], "acc3s")
		local accrbg = AMPVP_GetValue(regionDB[userName], "accRBG")

		--character stats
		local itemLevel = AMPVP_GetValue(regionDB[userName], "stats.ilvl")
		local versatility = AMPVP_GetValue(regionDB[userName], "stats.versa")
		local health = AMPVP_GetValue(regionDB[userName], "stats.hp")
		local renownLevel = AMPVP_GetValue(regionDB[userName], "stats.renown")
		local covenant = AMPVP_GetValue(regionDB[userName], "stats.covenant")
		local lastUpdated = AMPVP_GetValue(regionDB[userName], "updated_at")

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffc72429ArenaMaster.IO PvP Info: |r")

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
					table.insert(titlesLine, s)
				end

				if #titlesLine > 2 then
					multipleTitles = true
				end

				if not multipleTitles then
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Current Season Title:");
					GameTooltip:AddLine(AMPVP_ColorSub(titlesLine[1], "white"))
				else
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Current Expansion Titles:")
					for k, v in pairs(titlesLine) do
						GameTooltip:AddLine("-"..AMPVP_ColorSub(v, "white"))
					end

				end
				displayed = true
			end
		end
		--account achievements
		if acc_achievements and not shouldDisable and not achievementsInit then
			local displayed = false
			if not displayed and (AMPVP_GetSettingValue("ACHI_SHOW") and not inInstance or (AMPVP_GetSettingValue("INST_ACHI_SHOW") and inInstance)) then

				local multipleTitles = false
				local titlesLine = {}
				for s in acc_achievements:gmatch("[^\r\n]+") do
					table.insert(titlesLine, s)
				end

				if #titlesLine > 2 then
					multipleTitles = true
				end

				if not multipleTitles then
					if currentRatingInit or currentSeasonInit or characterExpInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Achievement: "..AMPVP_ColorSub(titlesLine[1], "white"));
					achievementsInit = true
				else
					if currentRatingInit or currentSeasonInit or characterExpInit or highestAccRatingInit then
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine("Achievements:")
					for k, v in pairs(titlesLine) do
						GameTooltip:AddLine("-"..AMPVP_ColorSub(v, "white"))
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
			local covenantDisplayed = false
			local renownDisplayed = false

			if (itemLevel and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) or
				health and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) or
				covenant and(AMPVP_GetSettingValue("STATS_COVENANT") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_COVENANT") and inInstance)) or
				versatility and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance)) or
				renown and (AMPVP_GetSettingValue("STATS_RENOWN") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_RENOWN") and inInstance))) then
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

			if covenant and not covenantDisplayed and (AMPVP_GetSettingValue("STATS_COVENANT") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_COVENANT") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("Covenant", "white"), covenant)
				covenantDisplayed = true
				characterStatsInit = true
			end

			if renownLevel and not renownDisplayed and (AMPVP_GetSettingValue("STATS_RENOWN") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_RENOWN") and inInstance)) then
				GameTooltip:AddDoubleLine(AMPVP_ColorSub("Renown", "white"), renownLevel)
				renownDisplayed = true
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

		if GameTooltip.ampvpHooked == nil then
			GameTooltip.ampvpHooked = true
		end
		GameTooltip:Show()

	else
		if GameTooltip.ampvpHooked == nil and not AMPVP_GetSettingValue("DISABLE_EMPTY_DATA") then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("ArenaMaster.IO - No data available."..AMPVP_ColorSub("\nVisit this character's ArenaMaster Profile \nand their info will be available on the next addon update.", "white"))
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
	wipe(AMPVP_friendsTTlines)
	AMPVP_friendsTTlines["nrLines"] = 0
	local nrLines = AMPVP_friendsTTlines["nrLines"]

	if regionDB[userName] ~= nil then
		nrLines = 0

		nrLines = nrLines + 1
		AMPVP_friendsTTlines[nrLines] = "|cffc72429ArenaMaster.IO PvP Info: |r"

		local cr2s = AMPVP_GetValue(regionDB[userName], "cr.2v2")
		local cr3s = AMPVP_GetValue(regionDB[userName], "cr.3v3")
		local crrbg = AMPVP_GetValue(regionDB[userName], "cr.rbg")

		--current season
		local cseason_2srating = AMPVP_GetValue(regionDB[userName], "current_season.2v2.played")
		local cseason_2swinp = AMPVP_GetValue(regionDB[userName], "current_season.2v2.win_rate")

		local cseason_3srating = AMPVP_GetValue(regionDB[userName], "current_season.3v3.played")
		local cseason_3swinp = AMPVP_GetValue(regionDB[userName], "current_season.3v3.win_rate")

		local cseason_rbgsrating = AMPVP_GetValue(regionDB[userName], "current_season.rbg.played")
		local cseason_rbgswinp = AMPVP_GetValue(regionDB[userName], "current_season.rbg.win_rate")

		local cseason_titles = AMPVP_GetValue(regionDB[userName], "current_season.titles", true)

		--character exp
		local exp2s = AMPVP_GetValue(regionDB[userName], "exp.2v2")
		local exp3s = AMPVP_GetValue(regionDB[userName], "exp.3v3")
		local exprbg = AMPVP_GetValue(regionDB[userName], "exp.rbg")

		--account achievements
		local acc_achievements = AMPVP_GetValue(regionDB[userName], "achievements", true)

		--highest account rating
		local acc2s = AMPVP_GetValue(regionDB[userName], "acc2s")
		local acc3s = AMPVP_GetValue(regionDB[userName], "acc3s")
		local accrbg = AMPVP_GetValue(regionDB[userName], "accRBG")

		--character stats
		local itemLevel = AMPVP_GetValue(regionDB[userName], "stats.ilvl")
		local versatility = AMPVP_GetValue(regionDB[userName], "stats.versa")
		local health = AMPVP_GetValue(regionDB[userName], "stats.hp")
		local renownLevel = AMPVP_GetValue(regionDB[userName], "stats.renown")
		local covenant = AMPVP_GetValue(regionDB[userName], "stats.covenant")
		local lastUpdated = AMPVP_GetValue(regionDB[userName], "updated_at")

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
					table.insert(titlesLine, s)
				end

				if #titlesLine > 2 then
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
					AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub(titlesLine[1], "white")
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
						AMPVP_friendsTTlines[nrLines] = "*"..AMPVP_ColorSub(v, "white")
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
					table.insert(achievsLines, s)
				end

				if #achievsLines > 2 then
					multipleAchievements = true
				end

				if not multipleAchievements then
					if currentRatingInit or currentSeasonInit or characterExpInit then
						nrLines = nrLines + 1
						AMPVP_friendsTTlines[nrLines] = ""
					end
					nrLines = nrLines + 1
					AMPVP_friendsTTlines[nrLines] = "Achievement: "..AMPVP_ColorSub(achievsLines[1], "white")
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
						AMPVP_friendsTTlines[nrLines] = "*"..AMPVP_ColorSub(v, "white")
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
			local covenantDisplayed = false
			local renownDisplayed = false

			if (itemLevel and (AMPVP_GetSettingValue("STATS_ITEMLEVEL") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_ITEMLEVEL") and inInstance)) or
				health and (AMPVP_GetSettingValue("STATS_HEALTH") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_HEALTH") and inInstance)) or
				covenant and(AMPVP_GetSettingValue("STATS_COVENANT") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_COVENANT") and inInstance)) or
				versatility and (AMPVP_GetSettingValue("STATS_VERSATILITY") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_VERSATILITY") and inInstance)) or
				renown and (AMPVP_GetSettingValue("STATS_RENOWN") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_RENOWN") and inInstance))) then
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

			if covenant and not covenantDisplayed and (AMPVP_GetSettingValue("STATS_COVENANT") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_COVENANT") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("Covenant", "white").."-"..covenant
				covenantDisplayed = true
				characterStatsInit = true
			end

			if renownLevel and not renownDisplayed and (AMPVP_GetSettingValue("STATS_RENOWN") and not inInstance or (AMPVP_GetSettingValue("INST_STATS_RENOWN") and inInstance)) then
				nrLines = nrLines + 1
				AMPVP_friendsTTlines[nrLines] = AMPVP_ColorSub("Renown", "white").."-"..renownLevel
				renownDisplayed = true
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
