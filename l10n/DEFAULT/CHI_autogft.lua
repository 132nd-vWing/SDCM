
---
-- Autonomous Ground Force Tasking script for Standard Dynamic Combat Mission for the 132nd Virtual Wing
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
autogft_Group.USING_ROAD_DISTANCE_THRESHOLD_M = 100
autogft_Group.ROUTE_OVERSHOOT_M = 50

autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_BLUE_BASE")
  :startUsingRoads()
  :setSpeed(25)
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :setSpeed(6)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROAD_EAST")
  :scanUnits("CHI:GEO_IFV_PLT1")
   
autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_BLUE_BASE")
  :startUsingRoads()
  :setSpeed(25)
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :setSpeed(6)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROAD_EAST")
  :scanUnits("CHI:GEO_IFV_PLT2")
  
autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_BLUE_BASE")
  :startUsingRoads()
  :setSpeed(25)
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :setSpeed(6)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROAD_EAST")
  :scanUnits("CHI:GEO_IFV_PLT3")  

---
-- (RED TASK FORCE)

autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_RED_BASE")
  :startUsingRoads()
  :setSpeed(30)
  :addControlZone("CHI_RUS_Road")
  :setSpeed(5)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :scanUnits("CHI:RUS_IFV_PLT1")
  
autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_RED_BASE")
  :setSpeed(35)
  :addControlZone("CHI_RUS_Road")
  :startUsingRoads()
  :setSpeed(6)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :scanUnits("CHI:RUS_IFV_PLT2")
  
autogft_Setup:new()
  :useStaging()
  :addBaseZone("CHI_RED_BASE")
  :setSpeed(40)
  :addControlZone("CHI_RUS_Road")
  :startUsingRoads()
  :setSpeed(6)
  :addControlZone("CHI_ROADJUNCTION")
  :addControlZone("CHI_FACTORY")
  :addControlZone("CHI_ROADJUNCTION_WEST")
  :scanUnits("CHI:RUS_IFV_PLT3")
  
  

  