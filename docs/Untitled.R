#######################################################################################
# SALINITY OUTLIER DISCUSSION!!!!!!
#######################################################################################


















#######################################################################################
# OXYGEN CONCENTRATION OUTLIER DISCUSSION!!!!!!
#######################################################################################

# There are 4 rows in BKG where oxygen_concentration = 0.000 (obviously incorrect measurements) that were caused by the sensor being out of the water (glider_depth < 0.08 m for all 4 rows). 

# *One of these BKG oxy=0.000 measurements occurred on 2025-03-17 at 19:45:38 UTC.
# 2025-03-17 16:12:12 UTC: oxy = 192.151 µmol/L (glider_depth = 2.550596 m)
# (3 hours 33 minutes 26 seconds)
# *OUTLIER* 2025-03-17 19:45:38 UTC: oxy = 0.000 µmol/L (glider_depth = 0.00437378 m)
# (51 seconds)
# 2025-03-17 19:46:29 UTC: oxy = 192.496 µmol/L (glider_depth = NA)

# During the window BEFORE the BKG outlier (~3.5 hrs), **19 detections occurred in HBK**. All 19 rows in HBK inside this interval are mathematically forced to be interpolated toward 0 (obviously the closer the timestamp gets to 19:45:38 UTC, the more the interpolated oxy value is pulled towards 0).

# | #  | Timestamp (UTC)     | Latitude  | Longitude  | Glider_depth_m | Oxygen (µmol/L) |
# | -- | ------------------- | --------- | ---------- | -------------- | --------------- |
# | 1  | 2025-03-17 17:00:25 | 17.336611 | −64.250970 | 231.809340     | **148.747372**  |
# | 2  | 2025-03-17 17:00:44 | 17.336649 | −64.250993 | 228.683266     | **148.462284**  |
# | 3  | 2025-03-17 17:02:14 | 17.336825 | −64.251102 | 213.195241     | **147.111867**  |
# | 4  | 2025-03-17 17:39:41 | 17.341240 | −64.253821 | 160.557368     | **113.396448**  |
# | 5  | 2025-03-17 17:40:38 | 17.341352 | −64.253890 | 172.417537     | **112.541183**  |
# | 6  | 2025-03-17 17:41:00 | 17.341395 | −64.253917 | 176.805963     | **112.211081**  |
# | 7  | 2025-03-17 17:44:08 | 17.341764 | −64.254144 | 214.602798     | **109.390210**  |
# | 8  | 2025-03-17 17:51:43 | 17.342658 | −64.254695 | 297.296232     | **102.563100**  |
# | 9  | 2025-03-17 17:55:09 | 17.343063 | −64.254944 | 283.503885     | **99.472145**   |
# | 10 | 2025-03-17 17:56:21 | 17.343204 | −64.255031 | 271.623114     | **98.391811**   |
# | 11 | 2025-03-17 17:57:06 | 17.343293 | −64.255085 | 264.261333     | **97.716602**   |
# | 12 | 2025-03-17 17:57:27 | 17.343334 | −64.255111 | 260.739672     | **97.401505**   |
# | 13 | 2025-03-17 18:09:28 | 17.344750 | −64.255983 | 144.249995     | **86.583162**   |
# | 14 | 2025-03-17 18:54:21 | 17.350041 | −64.259242 | 301.189954     | **46.175675**   |
# | 15 | 2025-03-17 18:54:27 | 17.350053 | −64.259249 | 301.662274     | **46.085647**   |
# | 16 | 2025-03-17 18:54:36 | 17.350070 | −64.259260 | 302.377612     | **45.950605**   |
# | 17 | 2025-03-17 18:59:56 | 17.350699 | −64.259647 | 257.681961     | **41.149121**   |
# | 18 | 2025-03-17 19:00:26 | 17.350758 | −64.259684 | 252.619896     | **40.698982**   |
# | 19 | 2025-03-17 19:04:14 | 17.351206 | −64.259959 | 213.163658     | **37.277925**   |



#######################################################################################
#######################################################################################
#######################################################################################


#######################################################################################
# RECALCULATE INERPOLATED SALINITY AND D.O. VALUES REMOVING OUTLIERS IN ERDDAP (BKG) DATA
#######################################################################################
library(tidyverse)
library(lubridate)

# Import background mission data
bkg <- read_csv("data/erddap_UVI2_Around_STX_20250306.csv")

# Import humpback detection data with GIS calculations
hbk <- read_csv("data/FIX_GISCALC_HUWH_AroundSTX2025.csv")

# Format date-time values -------------------------------------------------------------

# Convert time format to as.POSIXct in new 'datetime_UTC' column and sort chronologically
acoustic <- acoustic %>%
  mutate(datetime_UTC = as.POSIXct(Start_date_time, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")) %>%
  arrange(datetime_UTC)

glider <- glider %>%
  mutate(datetime_UTC = as.POSIXct(datetime, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")) %>%
  arrange(datetime_UTC)