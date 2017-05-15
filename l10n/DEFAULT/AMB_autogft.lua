
---
-- Autonomous Ground Force Tasking basic example script
-- https://github.com/birgersp/dcs-autogft
--
-- Lines beginning with "--" are comments and does not affect the code
-- Put the standalone script and this script in "do script file" actions in a mission start trigger
-- Remember to re-load this script to your mission after you have edited it, it is not necessary to re-load the standalone
-- Comments above code blocks explain what the code is doing



--- 
-- (BLUE TASK FORCE)
-- Adding base zone(s)
-- Adding control zone(s)
autogft_Group.USING_ROAD_DISTANCE_THRESHOLD_M = 1

--autogft_Setup:new()
  --:useStaging()
  --:addBaseZone("AMB_BLUE")
  --:startUsingRoads()
 -- :setSpeed(5)
  --:addControlZone("AMB_Junction_south")
 -- :addControlZone("AMB_junction_north")
  --:scanUnits("AMROLAURI: GEO_T55_plt1")
  
 -- autogft_Setup:new()
 -- :startUsingRoads()
 -- :setSpeed(5)
  --:addControlZone("AMB_Junction_south")
 -- :addControlZone("AMB_junction_north")
 -- :scanUnits("AMB:GEO_T72_plt1")
 autogft_Setup:new()
  :useStaging()
  :addBaseZone("AMB_BLUE")
  :startUsingRoads()
  :setSpeed(5)
  :addControlZone("AMB_Junction_south")
  :addControlZone("AMB_junction_north")
  :addUnits(3, "T-55")


--- 
-- (RED TASK FORCE)

autogft_Setup:new()
  :startUsingRoads()
  :setSpeed(5)
  :addControlZone("AMB_junction_north")
  :addControlZone("AMB_Junction_south")
  :scanUnits("AMB:RUS_BMP_plt1")

  