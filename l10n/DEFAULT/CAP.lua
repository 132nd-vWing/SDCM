--- Combat Air Patrol
-- ===================
--
-- /!\ IMPORTANT /!\ This script needs the MOOSE framework to load properly
--
---------------
-- Introduction
---------------
--
-- This script is a helper that creates dyanmic Combat Air Patrol during a mission.
--
-- At the start of the mission, no Combat Air Patrol will be activated; it is up to the participating pilots to start the different patrols.
-- A patrol can consist of on or many aircraft.
-- Those aircrafts will randomly fly in their patrol zone, and engage any friendly unit within a pe-redefined area.
-- The patrolling aicraft will be restricted to a specific zone of the map, and will not be allowed to fly or engage friendlies outside of that zone.
--
----------------
-- Initial setup 
----------------
--
-- NOTE: this setup assumes that the Combat Air Patrol & the friendlies are part of opposing coalitions; this script will not work
--       for a simulated blue-on-blue scenario.
--
-- 1. Create a trigger zone named "red_cap_patrol_zone"; the patrolling airplanes will randomly fly into during their patrol.
-- 2. Create a Trigger Zone names "red_cap_red_zone"; the patrolling airplanes will NOT be allowed to fly outside this zone,
--    and will abort their attack and return to their patrolling state upon exiting it.
-- 3. Create a Late Activation group named "red_cap_engage_zone"; use the waypoints of this group to define a polygon; any
--    "enemy" unit entering this area will be engaged by the CAP.
-- 4. Create the Combat Air Patrols:
--    4.1 Create a RED Late Activation group, with a name *starting* with "RED_CAP_"
--        Example: "RED_CAP_MiG29"
--        NOTE: it is advised to create groups consisting of only one aircraft.
--    4.2 Place it on an airfield
--    4.3 Set the initial waypoint ("SP") to "Start from runway"
--    4.4 Make sure that the group has a waypoints loadout relevant for their CAP mission
-- 5. (optional) Adjust the values
--
-- Repeat step 4 as many times as necessary; for example, you can have a group consisting of a MiG29, another group consisting of a Su27, and,
-- why not, yet another group consisting of a P51D.

-- Defines the name of the group that delimits the zone in which enemy aircrafts will patrol
--
-- Waypoints will be created randomly within this polygon
_RC_PATROL_ZONE = 'RUSSIA_EAST_CAP PATROL ZONE'

-- Defines the name of the group that delimits the zone in which friendly flights will be engaged by the CAP
--
-- Friendly flights flying outside that zone, however close to the CAP they are, will not be engaged
_RC_ENGAGE_POLYGON = 'RUSSIA_EAST_CAP ZONE'

-- Defines the name of the group that delimits the zone in which enemy planes have to stay
--
-- If an enemy plane leaves this zone, any engagement will be aborted, and the enemy plane will head back to its patrolling state
_RC_CAP_LIMIT_ZONE = 'RUSSIA_EAST_CAP ZONE'

-- Defines the minimum amount of fuel for patrolling aicraft.
-- 
-- When that amount of fuel is reached, a new aicraft will start, and the patrolling aicraft will be sent home after a set amount of time
-- (see "_RC_DELAY" below)
_RC_MIN_FUEL = 0.3

-- Define an amount of time (in seconds) to keep patrolling with low fuel on board.
-- 
-- The patrolling aicraft that is low on fuel will wait this amount of seconds for its reinforcement to arrive. While changing this value,
-- keep in mind that the aicraft will have to RTB with what fuel is left on board; setting it too high may force the aircraft to land on
-- an alternate airfield, or crash.
_RC_DELAY = 600

-- The aicrafts flying Combat Air Patrol missions will completely randomize their routes within their assigned zones.
--
-- You can define below a set of altitude and speed boundaries to fine tune their patrol.
-- 
-- ALTITUDE (in meters)
_RC_FLOOR = 9000
_RC_CEILING = 9000

-- ALTITUDE TYPE 
-- ("BARO" (MSL) or "RADIO" (AGL))
_RC_ALT_TYPE = "BARO"

-- SPEED
-- (ground speed in kilometers per hour)
_RC_MIN_SPEED = 600
_RC_MAX_SPEED = 900

-- RE-SPAWN DELAY
-- Time (in seconds) before a new airplane is spawned in case a patrolling group dies
_RC_RESPAWN_DELAY = 300



-----------------------------------------
-- DO NOT CHANGE ANYHTING BELOW THIS LINE
-----------------------------------------

env.info('RED CAP: loading: start')
if routines.majorVersion == nil then
  env.info('RED CAP: loading: error: MOOSE not found')
elseif routines.majorVersion < 3 then
  env.info('RED CAP: loading: error: requires MOOSE version 3 or more recent')  
else

  _RC = {
    red_zone = ZONE_POLYGON:New( _RC_CAP_LIMIT_ZONE..'_', GROUP:FindByName( _RC_CAP_LIMIT_ZONE ) ),
    patrol_zone = ZONE_POLYGON:New( _RC_PATROL_ZONE..'_', GROUP:FindByName( _RC_PATROL_ZONE ) ),
    engage_zone = ZONE_POLYGON:New( _RC_ENGAGE_POLYGON..'_', GROUP:FindByName( _RC_ENGAGE_POLYGON ) ),
    min_fuel = _RC_MIN_FUEL,
    orbit_delay = _RC_DELAY,
    event_handlers = {},
    spawners = {},
    counters = {},
    patrols = {},
    schedulers = {},
    menu = {
      root = MENU_COALITION:New( coalition.side.BLUE, 'Combat Air Patrol'),
    },
    groups = {},
  }
  
  _RC.DEBUG = function(text)
    env.info('RED CAP: '..text)
  end

  _RC.REGISTER_GROUP = function( group )

    local group_name = group:GetName()

    _RC.DEBUG('registering group: '..group_name)
  
    if _RC.patrols[group_name] == nil then
      _RC.patrols[group_name] = {}
    end

    _RC.spawners[group_name] = SPAWN
      :New(group_name)
      :OnSpawnGroup(
        function( group )
          local name = group:GetName()
          _RC.groups[name] = {}
        
          -- Create the patrol zone
          _RC.patrols[name] = AI_CAP_ZONE:New( _RC.patrol_zone, _RC_FLOOR, _RC_CEILING, _RC_MIN_SPEED, _RC_MAX_SPEED, _RC_ALT_TYPE )
          
          if _RC.counters[group_name] == nil then
            _RC.counters[group_name] = 1
          else
            _RC.counters[group_name] = _RC.counters[group_name] + 1
          end
          
          table.insert(_RC.patrols[group_name], name)
  
          -- Setup the patrol
          _RC.patrols[name]:SetControllable( group )
          _RC.patrols[name]:SetEngageZone( _RC.engage_zone )
          _RC.patrols[name]:ManageFuel(_RC.min_fuel, _RC.orbit_delay)
          _RC.patrols[name]:__Start( 10 )
          
          -- Detect the RTB state
          _RC.patrols[name].OnBeforeRTB = function(Controllable,From,Event,To)
            _RC.DEBUG(name..': RTB')
          end
          _RC.patrols[name].OnAfterRTB = function(Controllable,From,Event,To)
            -- Create a new patrolling plane
            _RC.spawners[group_name]:Spawn()
          end
        
          -- Create event handlers
          _RC.event_handlers[name] = group
          
          -- Intercept EngineShutdown event
          _RC.event_handlers[name]:HandleEvent( EVENTS.EngineShutdown )
          _RC.event_handlers[name].OnEventEngineShutdown = function( self, EventData)
            _RC.DEBUG(name..': killing engines')
            self:Destroy()                
          end
          
          -- Intercepts Dead event
          _RC.event_handlers[name]:HandleEvent( EVENTS.Dead )
          _RC.event_handlers[name].OnEventDead = function( self, EventData)
            _RC.DEBUG(name..': dead')
            local spawner = _RC.spawners[name]
            SCHEDULER:New(spawner, spawner.Spawn, {spawner}, _RC_RESPAWN_DELAY)
            -- _RC.spawners[name]:Spawn()           
          end
          
          -- Schedule a periodic check to force the CAP to stay in the pre-defined zone
          _RC.schedulers[name] = SCHEDULER:New(
            group, -- link the scheduler to the group so it stops when the group is destroyed
            function ( name )
              if _RC.patrols[name]:GetControllable():IsNotInZone(_RC.red_zone) then
                _RC.DEBUG(name..': out of red zone!')
                _RC.patrols[name]:Abort() -- Immediate abort
                _RC.patrols[name]:__Engage(60) -- Re-engage after 60 seconds
              end
            end,
            {name},
            5,
            10
          )
        end
      )
    
    -- Add a radio submenu for this CAP group
    _RC.menu[group_name] = {}
    _RC.menu[group_name].root = MENU_COALITION:New(coalition.side.BLUE, group_name:gsub('RED_CAP_', ''), _RC.menu.root)
    
    -- Add a command to start a new plane
    _RC.menu[group_name].spawn = MENU_COALITION_COMMAND:New(
      coalition.side.BLUE,
      'Add an aircraft',
      _RC.menu[group_name].root,
      function()
        _RC.spawners[group_name]:Spawn()
      end
    )
  
    -- Add a command to send all the planes home
    _RC.menu[group_name].stop = MENU_COALITION_COMMAND:New(
      coalition.side.BLUE,
      'Cancel this CAP',
      _RC.menu[group_name].root,
      function()
        for _, patrol_name in ipairs(_RC.patrols[group_name]) do
          _RC.event_handlers[patrol_name]:UnHandleEvent( EVENTS.Dead )
          _RC.patrols[patrol_name].OnAfterRTB = nil
          _RC.patrols[patrol_name]:RTB()
        end
      end
    )
  
    -- Add a command to print the CAP status
    _RC.menu[group_name].stop = MENU_COALITION_COMMAND:New(
      coalition.side.BLUE,
      'Current aircraft(s) count',
      _RC.menu[group_name].root,
      function()
        counter = 0
        for _, patrol_name in ipairs(_RC.patrols[group_name]) do
          local group = _RC.event_handlers[patrol_name]
          if group and group:IsALive() then
            if _RC.patrols[patrol_name].OnAfterRTB ~= nil then
              counter = conuter + 1
            end
          end
        end
        MESSAGE:New( 'CAP "'..group_name:gsub('RED_CAP_', '')..'" has '..counter..' active aircraft(s)', 7):ToBlue()
      end
    )
  
  
  end

  local groups = SET_GROUP:New()
  groups:FilterPrefixes('RED_CAP_')
  groups:FilterStart()
  groups:ForEach(_RC.REGISTER_GROUP)
  groups:FilterStop()
  env.info('RED CAP: loading: done')

end