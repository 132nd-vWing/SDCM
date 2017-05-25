
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
autogft_TaskGroup.USING_ROAD_DISTANCE_THRESHOLD_M = 100
autogft_TaskGroup.ROUTE_OVERSHOOT_M = 50
autogft_observerIntel.enable("JTAC_SPARTAN")

  autogft_Setup:new()
    :useStaging()
    :addBaseZone("ZESTAFONI_BASE")
	:startUsingRoads()
    :addControlZone("ZESTAFONI_FWD_BASE")
    :copyGroupsLayout("ZESTAFONI_BTR_PLT1")
	:copyGroupsLayout("ZESTAFONI_BTR_PLT2")
	:copyGroupsLayout("ZESTAFONI_NORTH_BTR_PLT1")
	:copyGroupsLayout("ZESTAFONI_NORTH_BTR_PLT2")
	
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("ZESTAFONI_FWD_BASE")
    :addControlZone("KASHURI_OBJ4")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ2")
	:addControlZone("KASHURI_OBJ3")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ1")
	:startUsingRoads()
	:setSpeed(8)
	:addControlZone("KASHURI_OBJ2")
	:addControlZone("KASHURI_OBJ1")
    :scanUnits("ZESTAFONI_BTR_PLT1")
	
 autogft_Setup:new()
    :useStaging()
    :addBaseZone("ZESTAFONI_FWD_BASE")
    :addControlZone("KASHURI_OBJ4")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ2")
	:addControlZone("KASHURI_OBJ3")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ1")
	:startUsingRoads()
	:setSpeed(6)
	:addControlZone("KASHURI_OBJ2")
	:addControlZone("KASHURI_OBJ1")
    :scanUnits("ZESTAFONI_BTR_PLT2")
	
	--KASHURI NORTH
 autogft_Setup:new()
    :useStaging()
    :addBaseZone("ZESTAFONI_FWD_BASE")
	:startUsingRoads()
	:setSpeed(8)
    :addControlZone("KASHURI_NORTH_OBJ3")
	:addControlZone("KASHURI_NORTH_OBJ2")
	:addControlZone("KASHURI_NORTH_OBJ1")
    :scanUnits("ZESTAFONI_NORTH_BTR_PLT1")
	
 autogft_Setup:new()
    :useStaging()
    :addBaseZone("ZESTAFONI_FWD_BASE")
	:startUsingRoads()
	:setSpeed(6)
    :addControlZone("KASHURI_NORTH_OBJ3")
	:addControlZone("KASHURI_NORTH_OBJ2")
	:addControlZone("KASHURI_NORTH_OBJ1")
    :scanUnits("ZESTAFONI_NORTH_BTR_PLT2")

---
-- (RED TASK FORCE)


  
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_BASE")
	:startUsingRoads()
    :addControlZone("KASHURI_FWD_BASE")
    :copyGroupsLayout("KASHURI_BTR80_plt1")
	:copyGroupsLayout("KASHURI_BTR80_plt2")
	:copyGroupsLayout("KASHURI_BTR80_plt3")

  autogft_Setup:new()
    :addBaseZone("KASHURI_BASE")
    :startUsingRoads()
    :addControlZone("KASHURI_FWD_BASE2")
    :copyGroupsLayout("KASHURI_NORTH_BTR80_plt1")
	:copyGroupsLayout("KASHURI_NORTH_BTR80_plt2")

	-- KASHURI SOUTH
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_FWD_BASE")
	:startUsingRoads()
	:setSpeed(13)
    :addControlZone("KASHURI_OBJ1")
	:addControlZone("KASHURI_OBJ2")
	:stopUsingRoads()
	:setSpeed(8)
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ1")
	:addControlZone("KASHURI_OBJ3")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ2")
	:addControlZone("KASHURI_OBJ4")
    :scanUnits("KASHURI_BTR80_plt1")
	
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_FWD_BASE")
	:startUsingRoads()
	:setSpeed(10)
    :addControlZone("KASHURI_OBJ1")
	:addControlZone("KASHURI_OBJ2")
	:stopUsingRoads()
	:setSpeed(5)
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ1")
	:addControlZone("KASHURI_OBJ3")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ2")
	:addControlZone("KASHURI_OBJ4")
    :scanUnits("KASHURI_BTR80_plt2")
	
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_FWD_BASE")
	:startUsingRoads()
	:setSpeed(10)
    :addControlZone("KASHURI_OBJ1")
	:addControlZone("KASHURI_OBJ2")
	:stopUsingRoads()
	:setSpeed(5)
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ1")
	:addControlZone("KASHURI_OBJ3")
	:addIntermidiateZone("KASHURI_INTERMEDIATE_OBJ2")
	:addControlZone("KASHURI_OBJ4")
    :scanUnits("KASHURI_BTR80_plt3")
	
	--KASHURI NORTH
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_FWD_BASE2")
	:startUsingRoads()
	:setSpeed(8)
    :addControlZone("KASHURI_NORTH_OBJ1")
	:addControlZone("KASHURI_NORTH_OBJ2")
	:addControlZone("KASHURI_NORTH_OBJ3")
    :scanUnits("KASHURI_NORTH_BTR80_plt1")
	
  autogft_Setup:new()
    :useStaging()
    :addBaseZone("KASHURI_FWD_BASE2")
	:startUsingRoads()
	:setSpeed(6)
    :addControlZone("KASHURI_NORTH_OBJ1")
	:addControlZone("KASHURI_NORTH_OBJ2")
	:addControlZone("KASHURI_NORTH_OBJ3")
    :scanUnits("KASHURI_NORTH_BTR80_plt2")

  -- autogft_Setup:new()
    -- :useStaging()
    -- :addBaseZone("F_BASE2")
    -- :addControlZone("COMBAT")
    -- :scanUnits("GROUP2")
  
  

  