AMPVP_CreateFrame2("AMPVP_SettingsUI_Instanced", UIParent, "CENTER", 0, 0, 420, 550, 0.6, true)
AMPVP_CreateText("TitleText", AMPVP_SettingsUI_Instanced, "TOP", 0, -30, "[ArenaMaster] - Arena/BG Settings Panel")
AMPVP_CreateCloseButton(AMPVP_SettingsUI_Instanced)
AMPVP_SettingsUI_Instanced:Hide()
--checkboxes
--Current Rating
AMPVP_CreateText("catSubtitleTooltip", AMPVP_SettingsUI_Instanced, "TOPLEFT", 15, -75, "Tooltip")
AMPVP_CreateText("catCurrentRating", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -100, "Current Rating:")
AMPVP_CreateCheckbox("INST_CURR_RATING_2s", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -115, "Display 2v2 Rating")
AMPVP_CreateCheckbox("INST_CURR_RATING_3s", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -140, "Display 3v3 Rating")
AMPVP_CreateCheckbox("INST_CURR_RATING_RBG", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -165, "Display RBG Rating")
--Current Season Stats
AMPVP_CreateText("catCurrentSeasonStats", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -215, "Current Season Stats:")
AMPVP_CreateCheckbox("INST_CURR_SEASON_2SW", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -230, "Display 2v2 Wins")
AMPVP_CreateCheckbox("INST_CURR_SEASON_3SW", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -255, "Display 3v3 Wins")
AMPVP_CreateCheckbox("INST_CURR_SEASON_RBGW", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -280, "Display RBG Wins")
AMPVP_CreateCheckbox("INST_CURR_SEASON_TITLES", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -305, "Display Titles")
--Character Experience
AMPVP_CreateText("catCharacterExperience", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -50, -100, "Character Experience:")
AMPVP_CreateCheckbox("INST_CHAR_EXP_2s", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -115, "Display 2v2 Exp")
AMPVP_CreateCheckbox("INST_CHAR_EXP_3s", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -140, "Display 3v3 Exp")
AMPVP_CreateCheckbox("INST_CHAR_EXP_RBG", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -165, "Display RBG Exp")
--Highest Account Rating
AMPVP_CreateText("catHighestAccRating", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -30, -215, "Highest Account Rating:")
AMPVP_CreateCheckbox("INST_HIGHEST_ACC_2s", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -230, "Display 2v2 Rating")
AMPVP_CreateCheckbox("INST_HIGHEST_ACC_3s", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -255, "Display 3v3 Rating")
AMPVP_CreateCheckbox("INST_HIGHEST_ACC_RBG", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -280, "Display RBG Rating")
--Character Stats
AMPVP_CreateText("catCharacterStats", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -350, "Character Stats:")
AMPVP_CreateCheckbox("INST_STATS_ITEMLEVEL", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -365, "Display Item Level")
AMPVP_CreateCheckbox("INST_STATS_VERSATILITY", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -390, "Display Versatility")
AMPVP_CreateCheckbox("INST_STATS_HEALTH", AMPVP_SettingsUI_Instanced, "TOPLEFT", 25, -415, "Display Health")
--Achievements
AMPVP_CreateText("catAchievements", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -90, -350, "Achievements:")
AMPVP_CreateCheckbox("INST_ACHI_SHOW", AMPVP_SettingsUI_Instanced, "TOPRIGHT", -150, -365, "Display Achievements")
AMPVP_CreateButton("ToggleGeneralSettingsUI", AMPVP_SettingsUI_Instanced, "BOTTOM", 0, 20, 150, 20, "General Settings")
