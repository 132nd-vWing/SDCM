--- AR_Korbouli ---

-- Patrol Groups --

AR_Zone = ZONE_POLYGON:New("AR_Zone", GROUP:FindByName( "AR_Korbouli_Zone" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Korbouli_TablePatrol = { "AR_Korbouli_Template1", "AR_Korbouli_Template2", "AR_Korbouli_Template3","AR_Korbouli_Template4","AR_Korbouli_Template5" } -- table for the Patrol groups

AR_Korbouli_Patrol_1 = SPAWN:New("AR_Korbouli_Patrol_1"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3()) -- spawner 1 for patrol 

AR_Korbouli_Patrol_2 = SPAWN:New("AR_Korbouli_Patrol_2"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3()) -- spawner 2 for patrol

AR_Korbouli_Patrol_3 = SPAWN:New("AR_Korbouli_Patrol_3"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3()) -- spawned 3 for patrol

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_1:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},60,300,0.5) -- patrol 1 

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_2:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},120,300,0.5) -- patrol 2

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_3:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},180,300,0.5) -- patrol 3

-- /Patrol Groups --


-- SAMs --
AR_Korbouli_TableSAM = { "AR_Korbouli_Zone_SA8", "AR_Korbouli_Zone_SA9", "AR_Korbouli_Zone_SA13","AR_Korbouli_Zone_SA19", "AR_Korbouli_Zone_SAMdummy1","AR_Korbouli_Zone_SAMdummy2" } -- table for the sam units, note the dummies will spawn unarmed transports instead of a sam

AR_Karbouli_TableSams_Zones = { ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_SOUTH", GROUP:FindByName( "AR_Korbouli_Zone_SAM_SOUTH" )),
ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_EAST", GROUP:FindByName( "AR_Korbouli_Zone_SAM_EAST" )),
ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_NORTH", GROUP:FindByName( "AR_Korbouli_Zone_SAM_NORTH" )) } -- table for the 3 zones in which the SAMs can spawn

AR_Korbouli_SAM = SPAWN:New( "AR_Korbouli_SAM" ):InitRandomizeTemplate( AR_Korbouli_TableSAM ):InitRandomizeZones( AR_Karbouli_TableSams_Zones ):Spawn() -- spawner for sam
-- optional module: give SAM unit MGRS coordinates via F10-- 
-- AR_Korbouli_SAM_Unit = AR_Korbouli_SAM:GetUnit(1)
-- AR_Korbouli_SAM_Unit_Coordinates = AR_Korbouli_SAM_Unit:GetCoordinate()
-- AR_Korbouli_SAM_Unit_Location = AR_Korbouli_SAM_Unit_Coordinates:ToString(AR_Korbouli_SAM_Unit)
-- AR_Intel = MENU_COALITION:New(coalition.side.BLUE,"AR Korbouli Intel")
-- MENU_COALITION:New(coalition.side.BLUE,"SAM is located at coordinates "..AR_Korbouli_SAM_Unit_Location, AR_Intel)
-- end of optional moduel-- 

-- /SAMs --


-- High Value Target --
AR_Korbouli_TableHighValue = { "AR_Korbouli_HighValue1", "AR_Korbouli_HighValue2", "AR_Korbouli_HighValue3" } -- table for the High Value Targets

AR_Zone_HighValue = ZONE_POLYGON:New("AR_Zone_HighValue", GROUP:FindByName( "AR_Zone_HighValue" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Korbouli_HighValue = SPAWN:New("AR_Korbouli_HighValue"):InitRandomizeTemplate( AR_Korbouli_TableHighValue ):SpawnFromVec3(AR_Zone_HighValue:GetRandomPointVec3()) -- spawner for high value target 

SCHEDULER:New(nil,function()
AR_Korbouli_HighValue:RouteToVec3(AR_Zone_HighValue:GetRandomPointVec3(),25)
end,{},30,600,0.2) -- high value 
-- /High Value Target --



