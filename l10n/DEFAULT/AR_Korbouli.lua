BASE:TraceAll(true)
BASE:TraceOnOff(true)  
  
AR_Zone = ZONE:New("AR_KORBOULI")

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
