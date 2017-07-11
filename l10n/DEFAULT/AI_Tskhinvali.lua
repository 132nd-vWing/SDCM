--- AR_Tskhinvali ---

-- Patrol Groups --

AR_Zone_Tskhinvali = ZONE_POLYGON:New("AR_Zone_Tskhinvali", GROUP:FindByName( "AR_Tskhinvali_Zone" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Tskhinvali_TablePatrol = { "AR_Tskhinvali_Template1", "AR_Tskhinvali_Template2", "AR_Tskhinvali_Template3","AR_Tskhinvali_Template4","AR_Tskhinvali_Template5" } -- table for the Patrol groups

AR_Tskhinvali_Patrol_1 = SPAWN:New("AR_Tskhinvali_Patrol_1"):InitRandomizeTemplate( AR_Tskhinvali_TablePatrol ):SpawnFromVec3(AR_Zone_Tskhinvali:GetRandomPointVec3()) -- spawner 1 for patrol 

AR_Tskhinvali_Patrol_2 = SPAWN:New("AR_Tskhinvali_Patrol_2"):InitRandomizeTemplate( AR_Tskhinvali_TablePatrol ):SpawnFromVec3(AR_Zone_Tskhinvali:GetRandomPointVec3()) -- spawner 2 for patrol

AR_Tskhinvali_Patrol_3 = SPAWN:New("AR_Tskhinvali_Patrol_3"):InitRandomizeTemplate( AR_Tskhinvali_TablePatrol ):SpawnFromVec3(AR_Zone_Tskhinvali:GetRandomPointVec3()) -- spawned 3 for patrol

SCHEDULER:New(nil,function()
AR_Tskhinvali_Patrol_1:RouteToVec3(AR_Zone_Tskhinvali:GetRandomPointVec3(),14)
end,{},60,300,0.5) -- patrol 1 

SCHEDULER:New(nil,function()
AR_Tskhinvali_Patrol_2:RouteToVec3(AR_Zone_Tskhinvali:GetRandomPointVec3(),12)
end,{},120,300,0.5) -- patrol 2

SCHEDULER:New(nil,function()
AR_Tskhinvali_Patrol_3:RouteToVec3(AR_Zone_Tskhinvali:GetRandomPointVec3(),9)
end,{},180,300,0.5) -- patrol 3

-- /Patrol Groups --


-- SAMs --
AR_Tskhinvali_TableSAM = { "AR_Tskhinvali_Zone_SA8", "AR_Tskhinvali_Zone_SA9", "AR_Tskhinvali_Zone_SA13","AR_Tskhinvali_Zone_SA19", "AR_Tskhinvali_Zone_SAMdummy1","AR_Tskhinvali_Zone_SAMdummy2" } -- table for the sam units, note the dummies will spawn unarmed transports instead of a sam

AR_Tskhinvali_TableSams_Zones = { ZONE_POLYGON:New("AR_Tskhinvali_Zone_SAM_SOUTHEAST", GROUP:FindByName( "AR_Tskhinvali_Zone_SAM_SOUTHEAST" )),
ZONE_POLYGON:New("AR_Tskhinvali_Zone_SAM_SOUTHWEST", GROUP:FindByName( "AR_Tskhinvali_Zone_SAM_SOUTHWEST" )),
ZONE_POLYGON:New("AR_Tskhinvali_Zone_SAM_NORTH", GROUP:FindByName( "AR_Tskhinvali_Zone_SAM_NORTH" )) } -- table for the 3 zones in which the SAMs can spawn

AR_Tskhinvali_SAM = SPAWN:New( "AR_Tskhinvali_SAM" ):InitRandomizeTemplate( AR_Tskhinvali_TableSAM ):InitRandomizeZones( AR_Tskhinvali_TableSams_Zones ):Spawn() -- spawner for sam
-- optional module: give SAM unit MGRS coordinates via F10-- 
-- AR_Tskhinvali_SAM_Unit = AR_Tskhinvali_SAM:GetUnit(1)
-- AR_Tskhinvali_SAM_Unit_Coordinates = AR_Tskhinvali_SAM_Unit:GetCoordinate()
-- AR_Tskhinvali_SAM_Unit_Location = AR_Tskhinvali_SAM_Unit_Coordinates:ToString(AR_Tskhinvali_SAM_Unit)
-- AR_Intel = MENU_COALITION:New(coalition.side.BLUE,"AR Tskhinvali Intel")
-- MENU_COALITION:New(coalition.side.BLUE,"SAM is located at coordinates "..AR_Tskhinvali_SAM_Unit_Location, AR_Intel)
-- end of optional moduel-- 

-- /SAMs --


-- High Value Target --
AR_Tskhinvali_TableHighValue = { "AR_Tskhinvali_HighValue1", "AR_Tskhinvali_HighValue2", "AR_Tskhinvali_HighValue3" } -- table for the High Value Targets

AR_Zone_Tskhinvali_HighValue = ZONE_POLYGON:New("AR_Zone_Tskhinvali_HighValue", GROUP:FindByName( "AR_Zone_Tskhinvali_HighValue" )) -- polygon zone to define the area in which the Patrols will be spawning and patrolling

AR_Tskhinvali_HighValue = SPAWN:New("AR_Tskhinvali_HighValue"):InitRandomizeTemplate( AR_Tskhinvali_TableHighValue ):SpawnFromVec3(AR_Zone_Tskhinvali_HighValue:GetRandomPointVec3()) -- spawner for high value target 

SCHEDULER:New(nil,function()
AR_Tskhinvali_HighValue:ClearTasks()
AR_Tskhinvali_HighValue:RouteToVec3(AR_Zone_Tskhinvali_HighValue:GetRandomPointVec3(),17)
end,{},30,600,0.2) -- high value 
-- /High Value Target --

-- Artillery Fire --
AR_Tskhinvali_Artillery_Target_Location = GROUP:FindByName("AR_Tskhinvali_Artillery_Target"):GetVec2() -- the Group in the ME will be the target location



AR_Tskhinvali_Artillery_fire = SCHEDULER:New( nil,
    function()
     AR_Tskhinvali_HighValue:SetTask({id = 'FireAtPoint', params = {x=AR_Tskhinvali_Artillery_Target_Location.x, y=AR_Tskhinvali_Artillery_Target_Location.y, radius=100, expendQty=3, expendQtyEnabled=true}}, 1)
    end,
  {}, 5, 300 )






