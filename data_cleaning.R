# install.packages('naniar')
library(tidyverse) # metapackage of all tidyverse packages
library(naniar)
library(dplyr)
airquality %>%
  group_by(Month) %>%
  miss_var_summary()
library(ggplot2)
#library(glmnet)
home_data <- read.csv('train.csv')
head(home_data)
# check missing values
anyNA(home_data)
miss_var_summary(home_data)
View(miss_var_summary(home_data))

# transform missing value for ordinal categorical variables
levels(home_data$FireplaceQu)
home_data$FireplaceQu = factor(home_data$FireplaceQu, levels=c(levels(home_data$FireplaceQu), "No"))
home_data$FireplaceQu[is.na(home_data$FireplaceQu)] = "No"

home_data$GarageType = factor(home_data$GarageType, levels=c(levels(home_data$GarageType), "No"))
home_data$GarageType[is.na(home_data$GarageType)] = "No"

home_data$GarageFinish = factor(home_data$GarageFinish, levels=c(levels(home_data$GarageFinish), "No"))
home_data$GarageFinish[is.na(home_data$GarageFinish)] = "No"

home_data$GarageQual = factor(home_data$GarageQual, levels=c(levels(home_data$GarageQual), "No"))
home_data$GarageQual[is.na(home_data$GarageQual)] = "No"

home_data$GarageCond = factor(home_data$GarageCond, levels=c(levels(home_data$GarageCond), "No"))
home_data$GarageCond[is.na(home_data$GarageCond)] = "No"

home_data$BsmtExposure[is.na(home_data$BsmtExposure)] = "No"

home_data$BsmtFinType1 = factor(home_data$BsmtFinType1, levels=c(levels(home_data$BsmtFinType1), "No"))
home_data$BsmtFinType1[is.na(home_data$BsmtFinType1)] = "No"

home_data$BsmtFinType2 = factor(home_data$BsmtFinType2, levels=c(levels(home_data$BsmtFinType2), "No"))
home_data$BsmtFinType2[is.na(home_data$BsmtFinType2)] = "No"

home_data$BsmtQual = factor(home_data$BsmtQual, levels=c(levels(home_data$BsmtQual), "No"))
home_data$BsmtQual[is.na(home_data$BsmtQual)] = "No"

home_data$BsmtCond = factor(home_data$BsmtCond, levels=c(levels(home_data$BsmtCond), "No"))
home_data$BsmtCond[is.na(home_data$BsmtCond)] = "No"

home_data$MasVnrType = factor(home_data$MasVnrType, levels=c(levels(home_data$MasVnrType), "No"))
home_data$MasVnrType[is.na(home_data$MasVnrType)] = "No"

home_data$Electrical = factor(home_data$Electrical, levels=c(levels(home_data$Electrical), "UNKNOWN"))
home_data$Electrical[is.na(home_data$Electrical)] = "UNKNOWN"

# dealing with NAs in numerical variables
home_data$MasVnrArea[is.na(home_data$MasVnrArea)] <-  0

home_data$LotFrontage[is.na(home_data$LotFrontage)] <-  0

home_data$BsmtFinSF1[is.na(home_data$BsmtFinSF1)] <- 0

home_data$BsmtFinSF2[is.na(home_data$BsmtFinSF2)] <- 0

home_data$BsmtUnfSF[is.na(home_data$BsmtUnfSF)] <- 0

home_data$TotalBsmtSF[is.na(home_data$TotalBsmtSF)] <- 0

home_data$BsmtFullBath[is.na(home_data$BsmtFullBath)] <- 0

home_data$BsmtHalfBath[is.na(home_data$BsmtHalfBath)] <- 0

home_data$GarageCars[is.na(home_data$GarageCars)] <- 0

home_data$GarageArea[is.na(home_data$GarageArea)] <- 0

# handling missing data in categorical variables 
home_data$KitchenQual[is.na(home_data$KitchenQual)] <- tail(names(sort(table(home_data$KitchenQual))), 1)

home_data$MSZoning[is.na(home_data$MSZoning)] <- tail(names(sort(table(home_data$MSZoning))), 1)

home_data$SaleType[is.na(home_data$SaleType)] <- tail(names(sort(table(home_data$SaleType))), 1)

home_data$Exterior1st[is.na(home_data$Exterior1st)] <- tail(names(sort(table(home_data$Exterior1st))), 1)

home_data$Exterior2nd[is.na(home_data$Exterior2nd)] <- tail(names(sort(table(home_data$Exterior2nd))), 1)

home_data$Functional[is.na(home_data$Functional)] <- tail(names(sort(table(home_data$Functional))), 1)

home_data$GarageYrBlt[is.na(home_data$GarageYrBlt)] <- home_data$YearBuilt[is.na(home_data$GarageYrBlt)]

home_data$Utilities <- NULL

home_data$Id <- NULL

# dealing with outliers
home_data$GrLivArea[home_data$GrLivArea>3500] <- as.numeric(mean(home_data$GrLivArea))

home_data$LotArea[home_data$LotArea>40000] <- as.numeric(mean(home_data$LotArea))

home_data$X1stFlrSF[home_data$X1stFlrSF>3000] <- as.numeric(mean(home_data$X1stFlrSF))

home_data$TotalBsmtSF[home_data$TotalBsmtSF>3000] <- as.numeric(mean(home_data$TotalBsmtSF))

# feature engineering 
# Total Area
home_data['TotalArea'] <- home_data$LotFrontage + home_data$LotArea + home_data$MasVnrArea + home_data$BsmtFinSF1 + home_data$BsmtFinSF2 + home_data$BsmtUnfSF +
  home_data$TotalBsmtSF + home_data$X1stFlrSF + home_data$X2ndFlrSF + home_data$GrLivArea + home_data$GarageArea + home_data$WoodDeckSF +  
  home_data$OpenPorchSF + home_data$EnclosedPorch + home_data$X3SsnPorch + home_data$ScreenPorch + home_data$LowQualFinSF + home_data$PoolArea

home_data['IsRemodeled'] <- ifelse(home_data$YearRemodAdd == home_data$YearBuilt, 0, 1)

home_data['IsRemodeledRecently'] <- ifelse(home_data$YearRemodAdd == home_data$YrSold, 0, 1)

home_data['NewHouse'] <-ifelse(home_data$YearBuilt == home_data$YrSold, 1, 0)

home_data['HouseAge'] <- as.numeric(2021 - home_data$YearBuilt)

home_data['LastSold'] <- as.numeric(2021 - home_data$YrSold)

home_data['TimeRemodeledSold'] <- as.numeric(home_data$YrSold - home_data$YearRemodAdd)

home_data['HouseInsideSF'] <- as.numeric(home_data$X1stFlrSF + home_data$X2ndFlrSF)

home_data$MSSubClass <- as.factor(home_data$MSSubClass)
home_data$MoSold <- as.factor(home_data$MoSold)
home_data$YrSold <- as.factor(home_data$YrSold)

levels(home_data$ExterQual) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$ExterQual<- recode(home_data$ExterQual,"None"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$ExterCond) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$ExterCond<- recode(home_data$ExterCond,"None"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$BsmtQual) # Ex	Excellent (100+ inches)	Gd	Good (90-99 inches) TA	Typical (80-89 inches) Fa	Fair (70-79 inches) Po	Poor (<70 inches  NA	No Basement
home_data$BsmtQual<- recode(home_data$BsmtQual,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$BsmtCond) # Ex	Excellent Gd Good TA	Typical - slight dampness allowed Fa Fair - dampness or some cracking or settling Po	Poor - Severe cracking, settling, or wetness NA	No Basement
home_data$BsmtCond<- recode(home_data$BsmtCond,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$BsmtExposure) # Gd	Good Exposure Av	Average Exposure (split levels or foyers typically score average or above)	Mn	Mimimum Exposure No	No Exposure NA	No Basement
home_data$BsmtExposure<- recode(home_data$BsmtExposure,"No"=0,"No"=1,"Mn"=2,"Av"=3,"Gd"=6)

levels(home_data$BsmtFinType1) # GLQ	Good Living Quarters ALQ	Average Living Quarters BLQ	Below Average Living Quarters	Rec	Average Rec Room LwQ	Low Quality Unf	Unfinshed NA	No Basement
home_data$BsmtFinType1<- recode(home_data$BsmtFinType1,"No"=0,"Unf"=1,"LwQ"=2,"Rec"=3,"BLQ"=4,"ALQ"=5,"GLQ"=6)

levels(home_data$BsmtFinType2) # GLQ	Good Living Quarters ALQ	Average Living Quarters BLQ	Below Average Living Quarters	Rec	Average Rec Room LwQ	Low Quality Unf	Unfinshed NA	No Basement
home_data$BsmtFinType2<- recode(home_data$BsmtFinType2,"No"=0,"Unf"=1,"LwQ"=2,"Rec"=3,"BLQ"=4,"ALQ"=5,"GLQ"=6)

levels(home_data$HeatingQC) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$HeatingQC<- recode(home_data$HeatingQC,"None"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=5)

levels(home_data$KitchenQual) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$KitchenQual<- recode(home_data$KitchenQual,"None"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$Functional) # Typ	Typical Functionality Min1	Minor Deductions 1 Min2	Minor Deductions 2 Mod	Moderate Deductions Maj1	Major Deductions 1 Maj2	Major Deductions 2 Sev	Severely Damaged Sal	Salvage only
home_data$Functional<- recode(home_data$Functional,"None"=0,"Sev"=1,"Maj2"=2,"Maj1"=3,"Mod"=4,"Min2"=5,"Min1"=6,"Typ"=7)

levels(home_data$FireplaceQu) # Ex	Excellent - Exceptional Masonry Fireplace Gd	Good - Masonry Fireplace in main level TA	Average - Prefabricated Fireplace in main living area or Masonry Fireplace in basement Fa	Fair - Prefabricated Fireplace in basement Po	Poor - Ben Franklin Stove NA	No Fireplace
home_data$FireplaceQu<- recode(home_data$FireplaceQu,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$GarageFinish) # Fin	Finished RFn	Rough Finished Unf	Unfinished NA	No Garage
home_data$GarageFinish<- recode(home_data$GarageFinish,"No"=0,"Unf"=1,"RFn"=2,"Fin"=3)

levels(home_data$GarageQual) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$GarageQual<- recode(home_data$GarageQual,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$GarageCond) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$GarageCond<- recode(home_data$GarageCond,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$PoolQC) # Ex	Excellent Gd	Good TA	Average/Typical Fa	Fair Po	Poor
home_data$PoolQC<- recode(home_data$PoolQC,"No"=0,"Po"=1,"Fa"=2,"TA"=3,"Gd"=4,"Ex"=6)

levels(home_data$Fence) # GdPrv	Good Privacy MnPrv	Minimum Privacy GdWo	Good Wood MnWw	Minimum Wood/Wire NA	No Fence
home_data$Fence<- recode(home_data$Fence,"No"=0,"MnWw"=1,"GdWo"=2,"MnPrv"=3,"GdPrv"=6)

home_data['FenceCondB'] <- ifelse(home_data$Fence < 1, 1, 0)
home_data['GarageFinishCondB'] <- ifelse(home_data$GarageFinish < 2, 1, 0)
home_data['FunctionalB'] <- ifelse(home_data$Functional < 4, 1, 0)
home_data['BsmtFinishB1'] <- ifelse(home_data$BsmtFinType1 < 3, 1, 0)
home_data['BsmtFinishB2'] <- ifelse(home_data$BsmtFinType2 < 3, 1, 0)
home_data['ExterQualB'] <- ifelse(home_data$ExterQual < 3, 1, 0)
home_data['ExterCondlB'] <- ifelse(home_data$ExterCond < 3, 1, 0)
home_data['BsmtQualB'] <- ifelse(home_data$BsmtQual < 3, 1, 0)
home_data['BsmtCondB'] <- ifelse(home_data$BsmtCond < 3, 1, 0)
home_data['BsmtExposureB'] <- ifelse(home_data$BsmtExposure < 3, 1, 0)
home_data['HeatingQCB'] <- ifelse(home_data$HeatingQC < 3, 1, 0)
home_data['KitchenQualB'] <- ifelse(home_data$KitchenQual < 3, 1, 0)
home_data['FireplaceQuB'] <- ifelse(home_data$FireplaceQu < 3, 1, 0)
home_data['GarageQualB'] <- ifelse(home_data$GarageQual < 3, 1, 0)
home_data['GarageCondB'] <- ifelse(home_data$GarageCond < 3, 1, 0)
home_data['PoolQCBad'] <- ifelse(home_data$PoolQC < 3, 1, 0)
home_data['FenceCondG'] <- ifelse(home_data$Fence >= 1, 1, 0)
home_data['GarageFinishCondG'] <- ifelse(home_data$GarageFinish >= 2, 1, 0)
home_data['FunctionalG'] <- ifelse(home_data$Functional >= 4, 1, 0)
home_data['BsmtFinishG1'] <- ifelse(home_data$BsmtFinType1 >= 3, 1, 0)
home_data['BsmtFinishG2'] <- ifelse(home_data$BsmtFinType2 >= 3, 1, 0)
home_data['ExterQualG'] <- ifelse(home_data$ExterQual >= 3, 1, 0)
home_data['ExterCondlG'] <- ifelse(home_data$ExterCond >= 3, 1, 0)
home_data['BsmtQualG'] <- ifelse(home_data$BsmtQual >= 3, 1, 0)
home_data['BsmtCondG'] <- ifelse(home_data$BsmtCond >= 3, 1, 0)
home_data['BsmtExposureG'] <- ifelse(home_data$BsmtExposure >= 3, 1, 0)
home_data['HeatingQCG'] <- ifelse(home_data$HeatingQC >= 3, 1, 0)
home_data['KitchenQualG'] <- ifelse(home_data$KitchenQual >= 3, 1, 0)
home_data['FireplaceQuG'] <- ifelse(home_data$FireplaceQu >= 3, 1, 0)
home_data['GarageQualG'] <- ifelse(home_data$GarageQual >= 3, 1, 0)
home_data['GarageCondG'] <- ifelse(home_data$GarageCond >= 3, 1, 0)
home_data['IsPoolQCG'] <- ifelse(home_data$PoolQC >= 3, 1, 0)
plot(home_data$LotShape)
home_data$RegShape <- ifelse(home_data$LotShape == 'Reg', 1, 0)

plot(home_data$LandContour)
home_data['LandContourLvl'] <- ifelse(home_data$LandContour == 'Lvl', 1, 0)

plot(home_data$LandSlope)
home_data['LandSlopeGtl'] <-  ifelse(home_data$LandSlope == 'Gtl', 1, 0)

plot(home_data$PavedDrive)
home_data['PavedDrive'] <-  ifelse(home_data$PavedDrive == 'Y', 1, 0)

plot(home_data$Electrical)
home_data['ElectricalBreaker'] <- ifelse(home_data$Electrical == 'SBrkr', 1, 0)

# transform the salesprice to log format
home_data$SalePrice <- log(home_data$SalePrice)

write.csv(home_data, "./home_data.csv", row.names = TRUE)


