--- AR_Oni ---

-- Patrol Groups --

AR_Zone_Oni = ZONE_POLYGON:New("AR_Zone_Oni", GROUP:FindByName( "AR_Oni_Zone" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Oni_TablePatrol = { "AR_Oni_Template1", "AR_Oni_Template2", "AR_Oni_Template3","AR_Oni_Template4","AR_Oni_Template5" } -- table for the Patrol groups

AR_Oni_Patrol_1 = SPAWN:New("AR_Oni_Patrol_1"):InitRandomizeTemplate( AR_Oni_TablePatrol ):SpawnFromVec3(AR_Zone_Oni:GetRandomPointVec3()) -- spawner 1 for patrol 

AR_Oni_Patrol_2 = SPAWN:New("AR_Oni_Patrol_2"):InitRandomizeTemplate( AR_Oni_TablePatrol ):SpawnFromVec3(AR_Zone_Oni:GetRandomPointVec3()) -- spawner 2 for patrol

AR_Oni_Patrol_3 = SPAWN:New("AR_Oni_Patrol_3"):InitRandomizeTemplate( AR_Oni_TablePatrol ):SpawnFromVec3(AR_Zone_Oni:GetRandomPointVec3()) -- spawned 3 for patrol

SCHEDULER:New(nil,function()
AR_Oni_Patrol_1:RouteToVec3(AR_Zone_Oni:GetRandomPointVec3(),14)
end,{},60,300,0.5) -- patrol 1 

SCHEDULER:New(nil,function()
AR_Oni_Patrol_2:RouteToVec3(AR_Zone_Oni:GetRandomPointVec3(),12)
end,{},120,300,0.5) -- patrol 2

SCHEDULER:New(nil,function()
AR_Oni_Patrol_3:RouteToVec3(AR_Zone_Oni:GetRandomPointVec3(),9)
end,{},180,300,0.5) -- patrol 3

-- /Patrol Groups --


-- SAMs --
AR_Oni_TableSAM = { "AR_Oni_Zone_SA8", "AR_Oni_Zone_SA9", "AR_Oni_Zone_SA13","AR_Oni_Zone_SA19", "AR_Oni_Zone_SAMdummy1","AR_Oni_Zone_SAMdummy2" } -- table for the sam units, note the dummies will spawn unarmed transports instead of a sam

AR_Oni_TableSams_Zones = { ZONE_POLYGON:New("AR_Oni_Zone_SAM_SOUTH", GROUP:FindByName( "AR_Oni_Zone_SAM_SOUTH" )),
ZONE_POLYGON:New("AR_Oni_Zone_SAM_EAST", GROUP:FindByName( "AR_Oni_Zone_SAM_EAST" )) } -- table for the 3 zones in which the SAMs can spawn

AR_Oni_SAM = SPAWN:New( "AR_Oni_SAM" ):InitRandomizeTemplate( AR_Oni_TableSAM ):InitRandomizeZones( AR_Oni_TableSams_Zones ):Spawn() -- spawner for sam
-- optional module: give SAM unit MGRS coordinates via F10-- 
-- AR_Oni_SAM_Unit = AR_Oni_SAM:GetUnit(1)
-- AR_Oni_SAM_Unit_Coordinates = AR_Oni_SAM_Unit:GetCoordinate()
-- AR_Oni_SAM_Unit_Location = AR_Oni_SAM_Unit_Coordinates:ToString(AR_Oni_SAM_Unit)
-- AR_Intel = MENU_COALITION:New(coalition.side.BLUE,"AR Oni Intel")
-- MENU_COALITION:New(coalition.side.BLUE,"SAM is located at coordinates "..AR_Oni_SAM_Unit_Location, AR_Intel)
-- end of optional moduel-- 

-- /SAMs --


-- High Value Target --
AR_Oni_TableHighValue = { "AR_Oni_HighValue1", "AR_Oni_HighValue2", "AR_Oni_HighValue3" } -- table for the High Value Targets

AR_Zone_Oni_HighValue = ZONE_POLYGON:New("AR_Zone_Oni_HighValue", GROUP:FindByName( "AR_Zone_Oni_HighValue" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Oni_HighValue = SPAWN:New("AR_Oni_HighValue"):InitRandomizeTemplate( AR_Oni_TableHighValue ):SpawnFromVec3(AR_Zone_Oni_HighValue:GetRandomPointVec3()) -- spawner for high value target 

SCHEDULER:New(nil,function()
AR_Oni_HighValue:ClearTasks()
AR_Oni_HighValue:RouteToVec3(AR_Zone_Oni_HighValue:GetRandomPointVec3(),17)
end,{},30,600,0.2) -- high value 
-- /High Value Target --

---- Artillery Fire --
--AR_Oni_Artillery_Target_Location = GROUP:FindByName("AR_Oni_Artillery_Target"):GetVec2() -- the Group in the ME will be the target location
--
--
--
--AR_Oni_Artillery_fire = SCHEDULER:New( nil,
--    function()
--     AR_Oni_HighValue:SetTask({id = 'FireAtPoint', params = {x=AR_Oni_Artillery_Target_Location.x, y=AR_Oni_Artillery_Target_Location.y, radius=100, expendQty=3, expendQtyEnabled=true}}, 1)
--    end,
--  {}, 5, 300 )






