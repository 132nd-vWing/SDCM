TRMT = {}

do -- DEBUG

  TRMT.DEBUG = function(text)
    env.info('  TRMT:DEBUG: '..text)
  end
  
  TRMT.INFO = function(text)
    env.info('   TRMT:INFO: '..text)
  end
  
  TRMT.WARN = function(text)
    env.info('TRMT:WARNING: '..text)
  end
  
  TRMT.ERROR = function(text)
    env.info('  TRMT:ERROR: '..text)
  end
  
  TRMT.SERIAL = function(arg)
    env.info(' TRMT:SERIAL:'..routines.utils.oneLineSerialize(arg) )
  end
end -- DEBUG



do -- SAR
  TRMT.SAR = {
    MENU = MENU_COALITION:New( coalition.side.BLUE, 'Search and Rescue' ),
    HELO_GROUP_NAME = 'SARhelo1',
    DUMMY_HELO_GROUP_NAME = 'SARhelo1dummy',
    TEMPLATE_GROUP_NAME = 'SARtemplate',
    CRASH_PLANE = SPAWN:New('crashplane'),
    MANPAD = nil,
    ZONES = {},
    TEMPLATE = nil,
    CTLD_TEMPLATE = nil,
    VEC2 = nil,
    VEC3 = nil,
    ZONE = nil,
    HELO = nil,
    RESCUE_ZONE = nil,
    SCHED_EXTRACT1 = nil,
    SCHED_EXTRACT2 = nil,
    HOSTILES = {
      INNER1 = nil,
      INNER2 = nil,
      GROUPS = {
        {group_name='SARenemy1', outer=13000, inner=9000, x_offset=150, y_offset=170, scheduler=nil, template=nil, transport=nil},
        {group_name='SARenemy2', outer=12000, inner=7000, x_offset=140, y_offset=140, scheduler=nil, template=nil, transport='SARInfantry'},
        {group_name='SARenemy3', outer=19000, inner=9000, x_offset=200, y_offset=200, scheduler=nil, template=nil, transport=nil},
        {group_name='SARenemy4', outer=17000, inner=7000, x_offset=180, y_offset=180, scheduler=nil, template=nil, transport=nil},
        {group_name='SARenemy5', outer=16000, inner=6000, x_offset=140, y_offset=190, scheduler=nil, template=nil, transport=nil},
      },
    },
  }
  
  TRMT.SAR.SPAWN_SMOKE = function()
    TRMT.DEBUG('SAR: spawning smoke')
    trigger.action.smoke(TRMT.SAR.VEC3,SMOKECOLOR.Green)
    MESSAGE:New( 'Green smoke on the deck at downed pilot location', 7):ToBlue()
  end
  
  TRMT.SAR.SPAWN_HELO = function()
    TRMT.DEBUG('SAR: RESCUE HELO: start')
    MESSAGE:New( 'Search and Rescue Helicopter starting up, we are inbound the crashsite', 7):ToBlue()
    
    TRMT.DEBUG('SAR: RESCUE HELO: destroying dummy')
    GROUP:FindByName(TRMT.SAR.DUMMY_HELO_GROUP_NAME):Destroy()
    
    TRMT.DEBUG('SAR: RESCUE HELO: spawning real helo')
    TRMT.SAR.HELO = SPAWN:New(TRMT.SAR.HELO_GROUP_NAME):Spawn()
    TRMT.DEBUG('SAR: RESCUE HELO: setting task')
    TRMT.SAR.HELO:SetTask({id = 'Land', params = {point = TRMT.SAR.VEC2,true,40}}, 1)
    TRMT.DEBUG('SAR: RESCUE HELO: creating rescue zone')
    TRMT.SAR.RESCUE_ZONE = ZONE_RADIUS:New('SARrescue',TRMT.SAR.VEC2,25)
    
    TRMT.DEBUG('SAR: RESCUE HELO: scheduling arrival')
    TRMT.SAR.SCHED_EXTRACT1 = SCHEDULER:New( nil,
      function()
        if TRMT.SAR.HELO:IsCompletelyInZone( TRMT.SAR.RESCUE_ZONE ) then
          TRMT.DEBUG('SAR: RESCUE HELO: rescue helo has arrive at pilot location')
          MESSAGE:New( 'Rescue Helicopter reached landing site, we prepare for extraction, give us cover!', 10):ToBlue()
          TRMT.SAR.SCHED_EXTRACT2:Start()
          TRMT.SAR.SCHED_EXTRACT1:Stop()
        end 
      end,
    {}, 0, 10 )
    
    TRMT.DEBUG('SAR: RESCUE HELO: scheduling departure')
    TRMT.SAR.SCHED_EXTRACT2 = SCHEDULER:New( nil,
      function()
        TRMT.DEBUG('SAR: RESCUE HELO: leaving rescue zone')
        TRMT.SAR.MANPAD:destroy()
        MESSAGE:New( 'Pilot is on Board, enroute back to FARP', 17):ToBlue()
        TRMT.SAR.HELO:SetTask({id = 'Land', params = {point = GROUP:FindByName('SAR AI Helo landing target'):GetVec2(),false,5}}, 1)
        TRMT.SAR.SCHED_EXTRACT2:Stop() 
      end,
    {}, 60, 20 )
    TRMT.SAR.SCHED_EXTRACT2:Stop()
  end
  
  TRMT.SAR.SPAWN_HOSTILES = function()
    TRMT.DEBUG('SAR: HOSTILES: start')
    TRMT.SAR.HOSTILES.INNER1  = ZONE_RADIUS:New('innercircle',  TRMT.SAR.VEC2, 1000)
    TRMT.SAR.HOSTILES.INNER2 = ZONE_RADIUS:New('innercircle2', TRMT.SAR.VEC2, 600)
    
    TRMT.DEBUG('SAR: HOSTILES: spawning groups')
    for i = 1, #TRMT.SAR.HOSTILES.GROUPS do
    
      TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': spawning')
      local group = TRMT.SAR.HOSTILES.GROUPS[i]
      TRMT.SAR.HOSTILES.GROUPS[i].template = SPAWN
        :New(group.group_name)
        :InitRandomizeUnits( true, group.outer, group.inner )
        :SpawnFromVec3(TRMT.SAR.VEC3)
        :RouteToVec3(TRMT.SAR.VEC3, 15)
        
      if group.transport == nil then
        TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': making regular scheduler')
        TRMT.SAR.HOSTILES.GROUPS[i].scheduler = SCHEDULER:New( nil,
          function()
            if TRMT.SAR.HOSTILES.GROUPS[i].template:IsCompletelyInZone( TRMT.SAR.HOSTILES.INNER1 ) then
              TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': group is near pilot location, firing')
              TRMT.SAR.HOSTILES.GROUPS[i].template:SetTask(
                {
                  id = 'FireAtPoint',
                  params = {
                    x=TRMT.SAR.VEC2.x + group.x_offset,
                    y=TRMT.SAR.VEC2.y + group.y_offset,
                    radius=100,
                    expendQty=100,
                    expendQtyEnabled=false
                  }
                }, 1)
              TRMT.SAR.HOSTILES.GROUPS[i].scheduler:Stop()
            end 
          end,
        {}, 0, 15 )
      else
        TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': making transporter scheduler')
        TRMT.SAR.HOSTILES.GROUPS[i].scheduler = SCHEDULER:New( nil,
          function()  
            if TRMT.SAR.HOSTILES.GROUPS[i].template:IsCompletelyInZone( TRMT.SAR.HOSTILES.INNER2 ) then
              TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': group is near the pilot')
              
              TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': stopping transporter')
              TRMT.SAR.HOSTILES.GROUPS[i].template:RouteToVec3(TRMT.SAR.HOSTILES.GROUPS[i].template:GetVec3(), 1)
              
              TRMT.DEBUG('SAR: HOSTILES: GROUP'..i..': spawning infantry')
              local infantry = SPAWN:New(group.transport):SpawnFromVec3(TRMT.SAR.HOSTILES.GROUPS[i].template:GetVec3())
              infantry:SetTask(
                {
                  id = 'FireAtPoint',
                  params = {
                    x=TRMT.SAR.VEC2.x + group.x_offset,
                    y=TRMT.SAR.VEC2.y + group.y_offset,
                    radius=100,
                    expendQty=100,
                    expendQtyEnabled=false,
                  }
                }, 1)
              TRMT.SAR.HOSTILES.GROUPS[i].scheduler:Stop()
            end 
          end,
        {}, 0, 15 )   
      end
    end
  end
  
  TRMT.SAR.START = function()
    TRMT.INFO('SAR: starting')
    
    TRMT.DEBUG('SAR: spawning template')
    TRMT.SAR.TEMPLATE = SPAWN:New( TRMT.SAR.TEMPLATE_GROUP_NAME ):InitRandomizeZones( TRMT.SAR.ZONES ):Spawn()
    TRMT.SAR.VEC2 = TRMT.SAR.TEMPLATE:GetVec2()
    TRMT.SAR.VEC3 = TRMT.SAR.TEMPLATE:GetVec3()
    
    TRMT.DEBUG('SAR: spawning crash plane')
    TRMT.SAR.CRASH_PLANE:SpawnFromVec3( TRMT.SAR.VEC3 )
    
    TRMT.DEBUG('SAR: spawning pilot')
    local group_details = ctld.generateTroopTypes(2, {aa=1}, 2)
    TRMT.SAR.MANPAD = ctld.spawnDroppedGroup(TRMT.SAR.VEC3, group_details, false, 0);
    table.insert(ctld.droppedTroopsBLUE, TRMT.SAR.MANPAD:getName())
    TRMT.SAR.CTLD_TEMPLATE = GROUP:Register(group_details)
    
    TRMT.DEBUG('SAR: creating beacon')
    ctld.beaconCount = ctld.beaconCount + 1
    ctld.createRadioBeacon(TRMT.SAR.VEC3, 2, 2, 'CSAR CRASHSITE '..ctld.beaconCount - 1, 120)
    MESSAGE:New('Simulated plane crash . Radio Beacon active at the crashsite (use CTLD Beacons to home in)', 7):ToBlue()
    TRMT.SAR.ZONE = ZONE_RADIUS:New('SARzone', TRMT.SAR.VEC2, 200)
    
    TRMT.INFO('SAR: started')
  end
  
  TRMT.SAR.INITIALIZE = function()
  
    TRMT.INFO('SAR: INIT: START')
  
    TRMT.DEBUG('SAR: INIT: making SAR zones')
    for i = 1, 3 do
      table.insert( TRMT.SAR.ZONES, ZONE:New( 'SAR'..i ))
    end
    
    MENU_COALITION_COMMAND:New( coalition.side.BLUE, 'Activate Crashsite', TRMT.SAR.MENU, TRMT.SAR.START )
    MENU_COALITION_COMMAND:New( coalition.side.BLUE, 'Dispatch Rescue Helicopter', TRMT.SAR.MENU, TRMT.SAR.SPAWN_HELO )
    MENU_COALITION_COMMAND:New( coalition.side.BLUE, 'Request Smoke on the Crashsite', TRMT.SAR.MENU, TRMT.SAR.SPAWN_SMOKE )
    MENU_COALITION_COMMAND:New( coalition.side.BLUE, 'Activate Hostile Forces', TRMT.SAR.MENU, TRMT.SAR.SPAWN_HOSTILES )
  
    TRMT.INFO('SAR: INIT: DONE')  
    
  end
end -- SAR

do

  --- The list below exists so it is easy enough to switch modules on & off
  local modules_to_load = {
    TRMT.SAR,
 }

  for _, module in ipairs( modules_to_load ) do
    module.INITIALIZE()
  end
end