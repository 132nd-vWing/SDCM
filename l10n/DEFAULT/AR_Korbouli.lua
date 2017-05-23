BASE:TraceAll(true)
BASE:TraceOnOff(true)  
  


AR_Zone = ZONE_POLYGON:New("AR_Zone", GROUP:FindByName( "AR_Korbouli_Zone" ))

AR_Karbouli_TableSams_Zones = { ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_SOUTH", GROUP:FindByName( "AR_Korbouli_Zone_SAM_SOUTH" )),
ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_EAST", GROUP:FindByName( "AR_Korbouli_Zone_SAM_EAST" )),
ZONE_POLYGON:New("AR_Korbouli_Zone_SAM_NORTH", GROUP:FindByName( "AR_Korbouli_Zone_SAM_NORTH" )) }

AR_Korbouli_TableSAM = { "AR_Korbouli_Zone_SA8", "AR_Korbouli_Zone_SA9", "AR_Korbouli_Zone_SA13","AR_Korbouli_Zone_SA19" }


AR_Korbouli_TablePatrol = { "AR_Korbouli_Template1", "AR_Korbouli_Template2", "AR_Korbouli_Template3","AR_Korbouli_Template4","AR_Korbouli_Template5" }

AR_Korbouli_Patrol_1 = SPAWN:New("AR_Korbouli_Patrol_1"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3())
AR_Korbouli_Patrol_2 = SPAWN:New("AR_Korbouli_Patrol_2"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3())
AR_Korbouli_Patrol_3 = SPAWN:New("AR_Korbouli_Patrol_3"):InitRandomizeTemplate( AR_Korbouli_TablePatrol ):SpawnFromVec3(AR_Zone:GetRandomPointVec3())

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_1:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},5,180,0.5)

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_2:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},12,180,0.5)

SCHEDULER:New(nil,function()
AR_Korbouli_Patrol_3:RouteToVec3(AR_Zone:GetRandomPointVec3(),25)
end,{},18,180,0.5)


AR_Korbouli_SAM = SPAWN:New( "AR_Korbouli_SAM" ):InitRandomizeTemplate( AR_Korbouli_TableSAM ):InitRandomizeZones( AR_Karbouli_TableSams_Zones ):Spawn()

AR_Korbouli_SAM_Unit = AR_Korbouli_SAM:GetUnit(1)
AR_Korbouli_SAM_Unit_Coordinates = AR_Korbouli_SAM_Unit:GetCoordinate()
AR_Korbouli_SAM_Unit_Location = AR_Korbouli_SAM_Unit_Coordinates:ToString(AR_Korbouli_SAM_Unit)

AR_Intel = MENU_COALITION:New(coalition.side.BLUE,"AR Korbouli Intel")
MENU_COALITION:New(coalition.side.BLUE,"SAM is located at coordinates "..AR_Korbouli_SAM_Unit_Location, AR_Intel)


