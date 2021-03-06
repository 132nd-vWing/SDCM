-- autogft\class.lua


---
-- @module Class

---
-- A template for creating autogft objects.
-- @type Class
autogft_Class = {}

---
-- Creates a new class.
-- @param #Class self
-- @return #Class
function autogft_Class:create()
  return setmetatable({}, {__index = autogft_Class})
end

---
-- Creates a subclass of this class.
-- @param #Class self
-- @return #Class
function autogft_Class:extend()
  local class = autogft_Class:create()
  setmetatable(class, {__index = self})
  return class
end

---
-- Instantiates this class.
-- Do not override this function (see @{#Class.new}).
-- @param #Class self
-- @param #table superObject (Optional) Parent object which the new instance will inherit attributes from
-- @return #table
function autogft_Class:createInstance(superObject)
  local instance = setmetatable({}, {__index = self})

  -- Automatically invoke super-constructor if no superobject is provided
  if not superObject then
    local metatable = getmetatable(self)
    if metatable and metatable ~= autogft_Class then
      superObject = metatable.__index:new()
    end
  end

  if superObject then
    for key, value in pairs(superObject) do
      instance[key] = value
    end
  end

  return instance
end

---
-- Instanties this class.
-- Override this function to create a custom constructor.
-- @param #Class self
-- @return #table
function autogft_Class:new()
  return self:createInstance(nil)
end

---
-- Returns wether this object is a type or subtype of a class.
-- @param #Class self
-- @return #boolean
function autogft_Class:instanceOf(class)

  local result = false
  local superClass
  local metatable = getmetatable(self)

  while metatable and not result do
    superClass = metatable.__index
    if superClass == class then
      result = true
    end
    metatable = getmetatable(superClass)
  end

  return result
end

---
-- Throws an error with the message that an abstract function was invoked.
-- The name of the function invoking this function will be included in the message.
-- @param #Class self
function autogft_Class:throwAbstractFunctionError()
  local functionName = debug.getinfo(2, "n").name
  error("Abstract function \"" .. functionName .. "\" invoked.")
end

---
-- Compares each field of this object the each field of another, and returns whether the fields are identical.
-- @param #Class self
-- @return #boolean
function autogft_Class:equals(object)
  for key, value in pairs(object) do
    if self[key] ~= value then
      return false
    end
  end
  return true
end



-- autogft\unitspec.lua

---
-- @module UnitSpecification

---
-- @type UnitSpec
-- @extends class#Class
-- @field #number count
-- @field #string type
autogft_UnitSpec = autogft_Class:create()

---
-- @param #UnitSpec self
-- @param #number count
-- @param #string type
-- @return #UnitSpec
function autogft_UnitSpec:new(count, type)
  self = self:createInstance()
  self.count = count
  self.type = type
  return self
end



-- autogft\vector2.lua

---
-- @module Vector2

---
-- @type Vector2
-- @extends class#Class
autogft_Vector2 = autogft_Class:create()

---
-- @param #Vector2 self
-- @return #Vector2
function autogft_Vector2:new(x, y)
  self = self:createInstance()
  self.x = x
  self.y = y
  return self
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #number
function autogft_Vector2:getCrossProduct(vector)
  return self.x * vector.y - self.y * vector.x
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #Vector2
function autogft_Vector2:getDotProduct(vector)
  return self.x * vector.x + self.y * vector.y
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #Vector2
function autogft_Vector2:getAngleTo(vector)
  local cosine = self:getDotProduct(vector) / (self:getMagnitude() * vector:getMagnitude())
  local angle = math.acos(cosine)
  if self:getCrossProduct(vector) < 0 then
    angle = math.pi * 2 - angle
  end
  return angle
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #Vector2
function autogft_Vector2:add(vector)
  self.x = self.x + vector.x
  self.y = self.y + vector.y
  return self
end

---
-- @param #Vector2 self
-- @param #number factor
-- @return #Vector2
function autogft_Vector2:scale(factor)
  self.x = self.x * factor
  self.y = self.y * factor
  return self
end

---
-- @param #Vector2 self
-- @return #number
function autogft_Vector2:getMagnitude()
  return math.sqrt(self.x^2 + self.y^2)
end

---
-- @param #Vector2 self
-- @return #Vector2
function autogft_Vector2:normalize()
  return self:scale(1 / self:getMagnitude())
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #Vector2
function autogft_Vector2:plus(vector)
  return autogft_Vector2:new(self.x, self.y):add(vector)
end

---
-- @param #Vector2 self
-- @param #number factor
-- @return #Vector2
function autogft_Vector2:times(factor)
  return autogft_Vector2:new(self.x, self.y):scale(factor)
end

---
-- @param #Vector2 self
-- @return #Vector2
function autogft_Vector2:getCopy()
  return autogft_Vector2:new(self.x, self.y)
end

---
-- @param #Vector2 self
-- @param #Vector2 vector
-- @return #Vector2
function autogft_Vector2:minus(vector)
  return autogft_Vector2:new(self.x, self.y):add(vector:times(-1))
end

---
-- @type Vector2.Axis
-- @field #Vector2 X
-- @field #Vector2 Y
autogft_Vector2.Axis = {
  X = autogft_Vector2:new(1, 0),
  Y = autogft_Vector2:new(0, 1)
}



-- autogft\vector3.lua

---
-- @module Vector3

---
-- @type Vector3
-- @extends class#Class
-- @extends DCSVec3#Vec3
autogft_Vector3 = autogft_Class:create()

---
-- @param #Vector3 self
-- @return #Vector3
function autogft_Vector3:new(x, y, z)
  self = self:createInstance()
  self.x = x
  self.y = y
  self.z = z
  return self
end

---
-- @param #Vector3 self
-- @return #Vector3
function autogft_Vector3:getCopy()
  return autogft_Vector3:new(self.x, self.y, self.z)
end

---
-- @param #Vector3 self
-- @param #Vector3 vector
-- @return #Vector3
function autogft_Vector3:add(vector)
  self.x = self.x + vector.x
  self.y = self.y + vector.y
  self.z = self.z + vector.z
  return self
end

---
-- @param #Vector3 self
-- @param #number factor
-- @return #Vector3
function autogft_Vector3:scale(factor)
  self.x = self.x * factor
  self.y = self.y * factor
  self.z = self.z * factor
  return self
end

---
-- @param #Vector3 self
-- @return #Vector3
function autogft_Vector3:normalize()
  self:scale(1 / self:getMagnitude())
  return self
end

---
-- @param #Vector3 self
-- @param #Vector3 vector
-- @return #number
function autogft_Vector3:getDotProduct(vector)
  return self.x * vector.x + self.y * vector.y + self.z * vector.z
end

---
-- @param #Vector3 self
-- @param #Vector3 vector
-- @return #Vector3
function autogft_Vector3:getCrossProduct(vector)
  local x = self.y * vector.z - self.z * vector.y
  local y = self.z * vector.x - self.x * vector.z
  local z = self.x * vector.y - self.y * vector.x
  return autogft_Vector3:new(x, y, z)
end

---
-- @param #Vector3 self
-- @return #number
function autogft_Vector3:getMagnitude()
  return math.sqrt(self.x^2 + self.y^2 + self.z^2)
end

---
-- @param #Vector3 self
-- @param #Vector3 vector
-- @param #Vector3 plane (Optional)
-- @return #number
function autogft_Vector3:getAngleTo(vector, plane)
  local cosine = self:getDotProduct(vector) / (self:getMagnitude() * vector:getMagnitude())
  local angle = math.acos(cosine)
  if plane then
    local cross = self:getCrossProduct(vector)
    if plane:getDotProduct(cross) < 0 then
      angle = -angle
    end
  end
  return angle
end

---
-- @type Vector3.Axis
-- @field #Vector3 X
-- @field #Vector3 Y
-- @field #Vector3 Z
autogft_Vector3.Axis = {
  X = autogft_Vector3:new(1, 0, 0),
  Y = autogft_Vector3:new(0, 1, 0),
  Z = autogft_Vector3:new(0, 0, 1)
}



-- autogft\group.lua

---
-- @module Group

---
-- @type Group
-- @extends class#Class
-- @field #list<unitspec#UnitSpec> unitSpecs
-- @field tasksequence#TaskSequence taskSequence
-- @field DCSGroup#Group dcsGroup
-- @field DCSUnit#Unit groupLead
-- @field #number destinationIndex
-- @field #boolean progressing
-- @field #number routeOvershootM
-- @field #number maxDistanceM
-- @field #number usingRoadDistanceThresholdM
autogft_Group = autogft_Class:create()

autogft_Group.USING_ROAD_DISTANCE_THRESHOLD_M = 3000

---
-- @param #Group self
-- @param tasksequence#TaskSequence taskSequence
-- @return #Group
function autogft_Group:new(taskSequence)
  self = self:createInstance()
  self.unitSpecs = {}
  self.taskSequence = taskSequence
  self.destinationIndex = 1
  self.progressing = true
  self.routeOvershootM = 500
  self.maxDistanceM = 10000
  self.usingRoadDistanceThresholdM = autogft_Group.USING_ROAD_DISTANCE_THRESHOLD_M
  self:setDCSGroup(nil)
  return self
end

---
-- @param #Group self
function autogft_Group:updateGroupLead()
  self.groupLead = nil
  if self.dcsGroup then
    local unitIndex = 1
    local units = self.dcsGroup:getUnits()
    while unitIndex <= #units and not self.groupLead do
      if units[unitIndex]:isExist() then self.groupLead = units[unitIndex] end
      unitIndex = unitIndex + 1
    end
    if not self.dcsGroup then
      self.dcsGroup = nil
    end
  end
end

---
-- @param #Group self
-- @return #Group
function autogft_Group:exists()
  self:updateGroupLead()
  if self.groupLead then
    return true
  end
  return false
end

---
-- @param #Group self
-- @param DCSUnit#Unit unit
-- @return #boolean
function autogft_Group:containsUnit(unit)
  if self.dcsGroup then
    local units = self.dcsGroup:getUnits()
    for unitIndex = 1, #units do
      if units[unitIndex]:getID() == unit:getID() then return true end
    end
  end
  return false
end

---
-- @param #Group self
-- @param unitspec#UnitSpec unitSpec
function autogft_Group:addUnitSpec(unitSpec)
  self.unitSpecs[#self.unitSpecs + 1] = unitSpec
  return self
end

---
-- @param #Group self
-- @return #Group
function autogft_Group:advance()

  self:updateGroupLead()
  if self.groupLead then

    local previousDestination = self.destinationIndex
    local currentTaskIndex = self.taskSequence.currentTaskIndex
    if previousDestination <= currentTaskIndex then
      self.progressing = true
    elseif previousDestination > currentTaskIndex then
      self.progressing = false
    end

    -- Determine next destination, nil means undetermined
    local destinationIndex = previousDestination
    local nextDestination = nil
    while not nextDestination do

      -- If destination is current task
      if destinationIndex == currentTaskIndex then
        nextDestination = destinationIndex
      else
        -- Else if destination index is out of bounds
        if destinationIndex > #self.taskSequence.tasks then
          nextDestination = #self.taskSequence.tasks
        elseif destinationIndex < 1 then
          nextDestination = 1
        end
      end

      if not nextDestination then
        -- If task is zone task, check if reached
        local task = self.taskSequence.tasks[destinationIndex]
        if task:instanceOf(autogft_ZoneTask) then
          local zone = task.zone --DCSZone#Zone
          -- If not reached, set as destination
          if not autogft.unitIsWithinZone(self.groupLead, zone) then
            nextDestination = destinationIndex
          end
        end
      end

      if not nextDestination then
        -- Increment / decrement destination
        if self.progressing then
          destinationIndex = destinationIndex + 1
        else
          destinationIndex = destinationIndex - 1
        end
      end
    end

    self.destinationIndex = nextDestination
    if previousDestination ~= self.destinationIndex then
      self:forceAdvance()
    else
      local prevPos = self.groupLead:getPosition().p
      local prevPosX = prevPos.x
      local prevPosZ = prevPos.z
      local function checkPosAdvance()
        if self.groupLead then
          local currentPos = self.groupLead:getPosition().p
          if currentPos.x == prevPosX and currentPos.z == prevPosZ then
            self:forceAdvance()
          end
        end
      end
      autogft.scheduleFunction(checkPosAdvance, 2)
    end
  end
end

---
-- @param #Group self
-- @return #Group
function autogft_Group:forceAdvance()

  if #self.taskSequence.tasks == 0 then
    do return end
  end

  local destinationTask = self.taskSequence.tasks[self.destinationIndex]
  local destination = destinationTask:getLocation()
  local groupLeadPosDCS = self.groupLead:getPosition().p
  local groupPos = autogft_Vector2:new(groupLeadPosDCS.x, groupLeadPosDCS.z)
  local groupToDestination = destination:minus(groupPos)
  local groupToDestinationMag = groupToDestination:getMagnitude()
  local shortened = false

  -- If the task force has a "max distance" specified
  if self.maxDistanceM > 0 then
    local units = self.dcsGroup:getUnits()

    -- If distance to destination is greater than max distance
    if groupToDestinationMag > self.maxDistanceM then
      local destinationX = groupPos.x + groupToDestination.x / groupToDestinationMag * self.maxDistanceM
      local destinationY = groupPos.y + groupToDestination.y / groupToDestinationMag * self.maxDistanceM
      destination = autogft_Vector2:new(destinationX, destinationY)
      shortened = true
    end
  end

  -- (Whether to use roads or not, depends on the next task)
  local nextTask = destinationTask
  if not self.progressing and self.destinationIndex > 1 then
    nextTask = self.taskSequence.tasks[self.destinationIndex - 1]
  end
  local useRoads = nextTask.useRoads

  local waypoints = {}
  local function addWaypoint(x, y, useRoad)
    local wp = autogft_Waypoint:new(x, y)
    wp.speed = nextTask.speed
    if useRoad then
      wp.action = autogft_Waypoint.Action.ON_ROAD
    end
    waypoints[#waypoints + 1] = wp
  end

  addWaypoint(groupPos.x, groupPos.y)

  -- Only use roads if group is at a certain distance away from destination
  if useRoads and groupToDestinationMag > self.usingRoadDistanceThresholdM then
    addWaypoint(groupPos.x + 1, groupPos.y + 1, true)
    addWaypoint(destination.x, destination.y, true)
  end

  if not shortened then
    local overshoot = destination:plus(groupPos:times(-1)):normalize():scale(self.routeOvershootM):add(destination)
    addWaypoint(overshoot.x, overshoot.y)
  end

  if not shortened or not useRoads then
    addWaypoint(destination.x + 1, destination.y + 1, useRoads)
  end

  self:setRoute(waypoints)

  return self
end

---
-- @param #Group self
-- @param DCSGroup#Group newGroup
-- @return #Group
function autogft_Group:setDCSGroup(newGroup)
  self.dcsGroup = newGroup
  self.destinationIndex = 1
  return self
end

---
-- @param #Group self
-- @param #list<waypoint#Waypoint> waypoints
function autogft_Group:setRoute(waypoints)
  if self:exists() then
    local dcsTask = {
      id = "Mission",
      params = {
        route = {
          points = waypoints
        }
      }
    }
    self.dcsGroup:getController():setTask(dcsTask)
  end
end



-- autogft\groupcommand.lua

---
-- @module GroupCommand

---
-- @type GroupCommand
-- @extends class#Class
-- @field #string commandName
-- @field #string groupName
-- @field #number groupId
-- @field #function func
-- @field #number timerId
-- @field #boolean enabled
autogft_GroupCommand = autogft_Class:create()

---
-- @param #GroupCommand self
-- @param #string commandName
-- @param #string groupName
-- @param #function func
-- @return #GroupCommand
function autogft_GroupCommand:new(commandName, groupName, func)
  self = self:createInstance()
  self.commandName = commandName
  self.groupName = groupName
  self.groupId = Group.getByName(groupName):getID()
  self.func = func
  return self
end

---
-- @param #GroupCommand self
function autogft_GroupCommand:enable()
  self.enabled = true

  local flagName = "groupCommandFlag"..self.groupId
  trigger.action.setUserFlag(flagName, 0)
  trigger.action.addOtherCommandForGroup(self.groupId, self.commandName, flagName, 1)

  local function checkTrigger()
    if self.enabled == true then
      if (trigger.misc.getUserFlag(flagName) == 1) then
        trigger.action.setUserFlag(flagName, 0)
        self.func()
      end
      autogft.scheduleFunction(checkTrigger, 1)
    else
    end
  end
  checkTrigger()
end

---
-- @param #GroupCommand self
function autogft_GroupCommand:disable()
  -- Remove group command from mission
  trigger.action.removeOtherCommandForGroup(self.groupId, self.commandName)
  self.enabled = false
end


-- autogft\iocev.lua

---
-- @module IOCEV

autogft_iocev = {}

autogft_iocev.CARDINAL_DIRECTIONS = {"N", "N/NE", "NE", "NE/E", "E", "E/SE", "SE", "SE/S", "S", "S/SW", "SW", "SW/W", "W", "W/NW", "NW", "NW/N"}
autogft_iocev.COMMAND_TEXT = "Request location of enemy vehicles"
autogft_iocev.NO_VEHICLES_MSG = "No enemy vehicles in range"
autogft_iocev.MAX_CLUSTER_DISTANCE = 1000
autogft_iocev.MESSAGE_TIME = 30
autogft_iocev.COMMAND_ENABLING_DELAY = 10

---
-- @param #number rad Direction in radians
-- @return #string A string representing a cardinal direction
function autogft_iocev.radToCardinalDir(rad)

  local dirNormalized = rad / math.pi / 2
  local i = 1
  if dirNormalized < (#autogft_iocev.CARDINAL_DIRECTIONS-1) / #autogft_iocev.CARDINAL_DIRECTIONS then
    while dirNormalized > i / #autogft_iocev.CARDINAL_DIRECTIONS / 2 do
      i = i + 2
    end
  end
  local index = math.floor(i / 2) + 1
  return autogft_iocev.CARDINAL_DIRECTIONS[index]
end

---
-- Prints out a message to a group, describing nearest enemy vehicles
-- @param DCSGroup#Group group
function autogft_iocev.informOfClosestEnemyVehicles(group)

  local groupHasMultiplePlayers = false

  local units = group:getUnits() --#list<DCSUnit#Unit>
  local unit = nil --DCSUnit#Unit
  local unitIndex = 1
  while not groupHasMultiplePlayers and unitIndex <= #units do
    if units[unitIndex] and units[unitIndex]:isExist() then
      if units[unitIndex]:getPlayerName() then
        if unit then
          groupHasMultiplePlayers = true
        else
          unit = units[unitIndex]
        end
      end
    end

    unitIndex = unitIndex + 1
  end

  if not unit then
    do return end
  end

  local closestEnemy = autogft_iocev.getClosestEnemyGroundUnit(unit)

  if not closestEnemy then
    trigger.action.outTextForGroup(group:getID(), autogft_iocev.NO_VEHICLES_MSG, autogft_iocev.MESSAGE_TIME)
  else

    local enemyCluster = autogft_iocev.getFriendlyGroundUnitsWithin(closestEnemy, autogft_iocev.MAX_CLUSTER_DISTANCE)
    enemyCluster.units[#enemyCluster.units + 1] = closestEnemy

    local groupUnitPosDCS = unit:getPosition().p
    local groupUnitPos = autogft_Vector2:new(groupUnitPosDCS.x, groupUnitPosDCS.z)
    local groupToMid = autogft_Vector2.minus(enemyCluster.midPoint, groupUnitPos)

    local dirRad = autogft_Vector2.Axis.X:getAngleTo(groupToMid) + autogft.getHeadingNorthCorrection(groupUnitPosDCS)
    --    local cardinalDir = autogft_iocev.radToCardinalDir(dirRad)
    local dirHeading = math.floor(dirRad / math.pi * 180 + 0.5)
    local distanceM = enemyCluster.midPoint:getCopy():scale(-1):add(groupUnitPos):getMagnitude()
    local distanceKM = distanceM / 1000
    local distanceNM = distanceKM / 1.852

    local unitTypes = {}
    for i = 1, #enemyCluster.units do
      local unit = enemyCluster.units[i]
      local typeName = unit:getTypeName()
      if unitTypes[typeName] == nil then
        unitTypes[typeName] = 0
      end
      unitTypes[typeName] = unitTypes[typeName] + 1
    end

    local text = ""
    for key, val in pairs(unitTypes) do
      if (text ~= "") then
        text = text..", "
      end
      text = text..val.." "..key
    end

    local distanceNMRounded = math.floor(distanceNM + 0.5)
    text = text .. " located " .. distanceNMRounded .. "nm at " .. dirHeading

    if groupHasMultiplePlayers then
      text = text .. " from \"" .. unit:getPlayerName() .. "\""
    end

    trigger.action.outTextForGroup(group:getID(), text, 30)
  end

end

function autogft_iocev.enable()

  local enabledGroupCommands = {}

  ---
  -- @param #number groupId
  local function groupHasCommandEnabled(groupId)
    for i = 1, #enabledGroupCommands do
      if enabledGroupCommands[i].groupId == groupId then
        return true
      end
    end
    return false
  end

  ---
  -- @param DCSGroup#Group group
  local function groupHasPlayer(group)
    local units = group:getUnits()
    for i = 1, #units do
      if units[i]:getPlayerName() ~= nil then return true end
    end
    return false
  end

  ---
  -- @param DCSGroup#Group group
  local function enableForGroup(group)
    local function triggerCommand()
      local unit = group:getUnit(1)
      autogft_iocev.informOfClosestEnemyVehicles(group)
    end
    local groupCommand = autogft_GroupCommand:new(autogft_iocev.COMMAND_TEXT, group:getName(), triggerCommand)
    groupCommand:enable()
    enabledGroupCommands[group:getName()] = groupCommand
  end

  function enableForPlayers(players)
    for i = 1, #players do
      local player = players[i]
      local group = player:getGroup() --DCSGroup#Group
      local groupName = group:getName()
      if not enabledGroupCommands[groupName] then
        enableForGroup(group)
      end
    end
  end

  local function reEnablingLoop()

    enableForPlayers(coalition.getPlayers(coalition.side.BLUE))
    enableForPlayers(coalition.getPlayers(coalition.side.RED))

    autogft.scheduleFunction(reEnablingLoop, autogft_iocev.COMMAND_ENABLING_DELAY)
  end

  reEnablingLoop()

end

---
-- Locates friendly units within some range of each other.
-- This function might be computationally expensive.
-- @param DCSUnit#Unit unit
-- @param #number radius
-- @return unitcluster#UnitCluster
function autogft_iocev.getFriendlyGroundUnitsWithin(unit, radius)

  local unitsWithinRange = {} --#list<DCSUnit#Unit>
  local unitsWithinRangeNames = {}

  local minPos = unit:getPosition().p
  local maxPos = unit:getPosition().p

  -- Build table of all friendly ground units
  local friendlyGroundUnits = {} --#list<DCSUnit#Unit>
  autogft_iocev.forEachCoalitionUnit(unit:getCoalition(), function(friendlyUnit) friendlyGroundUnits[#friendlyGroundUnits + 1] = friendlyUnit end, Group.Category.GROUND)

  local radius2 = radius^2

  ---
  -- @param DCSUnit#Unit unit
  local function addUnit(unit)
    local pos = unit:getPosition().p
    if pos.x < minPos.x then minPos.x = pos.x end
    if pos.z < minPos.z then minPos.z = pos.z end
    if pos.x > maxPos.x then maxPos.x = pos.x end
    if pos.z > maxPos.z then maxPos.z = pos.z end
    unitsWithinRange[#unitsWithinRange + 1] = unit
    unitsWithinRangeNames[unit:getName()] = true
  end

  ---
  -- @param DCSUnit#Unit unit
  local function vehiclesWithinRecurse(targetUnit)

    local targetUnitPos = targetUnit:getPosition().p

    for i = 1, #friendlyGroundUnits do
      local friendlyGroundUnit = friendlyGroundUnits[i] --DCSUnit#Unit
      local friendlyGroundUnitID = friendlyGroundUnit:getID()
      if friendlyGroundUnitID ~= unit:getID() and friendlyGroundUnitID ~= targetUnit:getID() then

        local unitPos = friendlyGroundUnit:getPosition().p
        local dX = unitPos.x - targetUnitPos.x
        local dY = unitPos.y - targetUnitPos.y
        local dZ = unitPos.z - targetUnitPos.z
        local distance2 = dX*dX + dY*dY + dZ*dZ

        if distance2 <= radius2 and not unitsWithinRangeNames[friendlyGroundUnit:getName()] then
          addUnit(friendlyGroundUnit)
          vehiclesWithinRecurse(friendlyGroundUnit)
        end
      end
    end
  end

  vehiclesWithinRecurse(unit)

  local dx = maxPos.x - minPos.x
  local dz = maxPos.z - minPos.z

  local midPoint = autogft_Vector2:new(minPos.x + dx / 2, minPos.z + dz / 2)

  local result = autogft_UnitCluster:new(unitsWithinRange, midPoint)
  return result
end

---
-- @param DCSUnit#Unit unit
-- @return DCSUnit#Unit
function autogft_iocev.getClosestEnemyGroundUnit(unit)

  local unitPosition = unit:getPosition().p

  local enemyCoalitionID
  if unit:getCoalition() == coalition.side.BLUE then
    enemyCoalitionID = coalition.side.RED
  else
    enemyCoalitionID = coalition.side.BLUE
  end

  local closestEnemy
  local closestEnemyDistance2

  -- For each enemy group
  autogft_iocev.forEachCoalitionUnit(enemyCoalitionID,
    function(enemyUnit)
      -- Determine distance (squared) between unit and enemy
      local ePos = enemyUnit:getPosition().p
      local dX = ePos.x - unitPosition.x
      local dY = ePos.y - unitPosition.y
      local dZ = ePos.z - unitPosition.z
      local distance2 = dX*dX + dY*dY + dZ*dZ

      if (not closestEnemy) or distance2 < closestEnemyDistance2 then
        closestEnemy = enemyUnit
        closestEnemyDistance2 = distance2
      end
    end, Group.Category.GROUND)

  return closestEnemy
end

---
-- @param #number coalitionID
-- @param #function func
-- @param #number category
function autogft_iocev.forEachCoalitionUnit(coalitionID, func, category)

  local groups = coalition.getGroups(coalitionID, category)
  for groupIndex = 1, #groups do
    local group = groups[groupIndex] --DCSGroup#Group
    if group:isExist() then

      local groupUnits = group:getUnits()
      for groupUnitIndex = 1, #groupUnits do
        local unit = groupUnits[groupUnitIndex]
        if unit:isExist() then
          func(unit)
        end
      end
    end
  end
end



-- autogft\map.lua

---
-- @module Map

---
-- @type Map
-- @extends class#Class
-- @field #map<#number, #table> keys
-- @field #map<#number, #table> values
-- @field #number length
autogft_Map = autogft_Class:create()

---
-- @param #Map self
-- @return #Map
function autogft_Map:new()
  self = self:createInstance()
  self.keys = {}
  self.values = {}
  self.length = 0
  return self
end

---
-- @param #Map self
-- @param #table key
-- @param #table value
function autogft_Map:put(key, value)
  local id = autogft.getTableID(key)
  if not self.keys[id] then
    self.keys[id] = key
    self.length = self.length + 1
  end
  self.values[id] = value
end

---
-- @param #Map self
-- @param #table key
-- @return #table
function autogft_Map:get(key)
  local id = autogft.getTableID(key)
  return self.values[id]
end



-- autogft\reinforcer.lua

---
-- @module Reinforcer

---
-- @type ReinforcerUnit
-- @extends class#Class
-- @field #string type
-- @field #string name
-- @field #number x
-- @field #number y
-- @field #number heading
autogft_ReinforcerUnit = autogft_Class:create()

---
-- @param #ReinforcerUnit self
-- @param #string type
-- @param #string name
-- @param #number x
-- @param #number y
-- @param #number heading
-- @return #ReinforcerUnit
function autogft_ReinforcerUnit:new(type, name, x, y, heading)
  self = self:createInstance()
  self.type = type
  self.name = name
  self.x = x
  self.y = y
  self.heading = heading
  return self
end

---
-- @type Reinforcer
-- @extends class#Class
-- @field #list<DCSZone#Zone> baseZones
-- @field #number countryID
-- @field #string unitSkill
autogft_Reinforcer = autogft_Class:create()

---
-- @param #Reinforcer self
-- @return #Reinforcer
function autogft_Reinforcer:new()
  self = self:createInstance()
  self.baseZones = {}
  self.countryID = nil
  self.unitSkill = "High"
  return self
end

---
-- @param #Reinforcer self
-- @param #string name
function autogft_Reinforcer:addBaseZone(name)
  local zone = trigger.misc.getZone(name)
  assert(zone, "Zone \"" .. name .. "\" does not exist in this mission.")
  self.baseZones[#self.baseZones + 1] = zone
end

---
-- @param #Reinforcer self
-- @param #number id
function autogft_Reinforcer:setCountryID(id)
  self.countryID = id
end

---
-- @param #Reinforcer self
-- @param group#Group group
-- @param #list<#ReinforcerUnit> units
function autogft_Reinforcer:addGroupUnits(group, units)

  local dcsGroupUnits = {}
  for i = 1, #units do
    local unit = units[i] --#ReinforcerUnit
    dcsGroupUnits[i] = {
      ["type"] = unit.type,
      ["transportable"] =
      {
        ["randomTransportable"] = false,
      },
      ["x"] = unit.x,
      ["y"] = unit.y,
      ["heading"] = unit.heading,
      ["name"] = unit.name,
      ["skill"] = self.unitSkill,
      ["playerCanDrive"] = true
    }
  end

  local dcsGroupData = {
    ["route"] = {},
    ["units"] = dcsGroupUnits,
    ["name"] = autogft.getUniqueGroupName()
  }

  local dcsGroup = coalition.addGroup(self.countryID, Group.Category.GROUND, dcsGroupData)
  group:setDCSGroup(dcsGroup)
end

---
-- @param #Reinforcer self
function autogft_Reinforcer:assertHasBaseZones()
  assert(#self.baseZones > 0, "No base zones specified. Use \"addBaseZone\" to add a base zone.")
end

---
-- @param #Reinforcer self
function autogft_Reinforcer:reinforce()
  self:throwAbstractFunctionError()
end

---
-- @type SpecificUnitReinforcer
-- @field map#Map groupsUnitSpecs
-- @extends #Reinforcer
autogft_SpecificUnitReinforcer = autogft_Reinforcer:extend()

---
-- @param #SpecificUnitReinforcer self
-- @return #SpecificUnitReinforcer
function autogft_SpecificUnitReinforcer:new()
  self = self:createInstance()
  self.groupsUnitSpecs = autogft_Map:new()
  return self
end

---
-- @param #SpecificUnitReinforcer self
function autogft_SpecificUnitReinforcer:assertHasGroupsUnitSpecs()
  assert(self.groupsUnitSpecs.length, "No group unit specifications. Use \"setGroupUnitSpecs\" to set group unit specifications.")
end

---
-- @param #SpecificUnitReinforcer self
-- @param #list<DCSUnit#Unit> availableUnits
function autogft_SpecificUnitReinforcer:reinforceFromUnits(availableUnits)
  local takenUnitIndices = {}
  for groupID, _ in pairs(self.groupsUnitSpecs.keys) do
    local group = self.groupsUnitSpecs.keys[groupID] --group#Group

    if not group:exists() then
      local newUnits = {}
      local unitSpecs = self.groupsUnitSpecs:get(group)
      for unitSpecIndex = 1, #unitSpecs do
        local unitSpec = unitSpecs[unitSpecIndex] --unitspec#UnitSpec

        local addedGroupUnitsCount = 0

        local availableUnitIndex = 1
        while addedGroupUnitsCount < unitSpec.count and availableUnitIndex <= #availableUnits do
          local unit = availableUnits[availableUnitIndex]
          if unit:isExist()
            and not takenUnitIndices[availableUnitIndex]
            and unit:getTypeName() == unitSpec.type then
            local x = unit:getPosition().p.x
            local y = unit:getPosition().p.z
            local heading = autogft.getUnitHeading(unit)

            newUnits[#newUnits + 1] = autogft_ReinforcerUnit:new(unitSpec.type, unit:getName(), x, y, heading)
            takenUnitIndices[availableUnitIndex] = true
            addedGroupUnitsCount = addedGroupUnitsCount + 1
          end
          availableUnitIndex = availableUnitIndex + 1
        end

        if #takenUnitIndices >= #availableUnits then
          break
        end
      end

      self:addGroupUnits(group, newUnits)
      group:advance()
    end
  end
end

---
-- @type RespawningReinforcer
-- @extends #SpecificUnitReinforcer
-- @field #number uniqueUnitNameCount
autogft_RespawningReinforcer = autogft_SpecificUnitReinforcer:extend()

---
-- @param #RespawningReinforcer self
-- @return #RespawningReinforcer
function autogft_RespawningReinforcer:new()
  self = self:createInstance()
  self.uniqueUnitNameCount = 0
  return self
end

---
-- @param #RespawningReinforcer self
-- @return #string
function autogft_RespawningReinforcer:getUniqueUnitName()
  local name
  -- Find a unique unit name
  while (not name) or Unit.getByName(name) do
    self.uniqueUnitNameCount = self.uniqueUnitNameCount + 1
    name = "autogft unit #" .. self.uniqueUnitNameCount
  end
  return name
end

---
-- @param #RespawningReinforcer self
function autogft_RespawningReinforcer:reinforce()

  self:assertHasBaseZones()
  self:assertHasGroupsUnitSpecs()

  local spawnZone = self.baseZones[math.random(#self.baseZones)]
  local spawnedUnitCount = 0

  for groupID, _ in pairs(self.groupsUnitSpecs.keys) do
    local group = self.groupsUnitSpecs.keys[groupID] --group#Group

    if not group:exists() then
      local newUnits = {}
      local unitSpecs = self.groupsUnitSpecs:get(group)
      for unitSpecIndex = 1, #unitSpecs do
        local unitSpec = unitSpecs[unitSpecIndex] --unitspec#UnitSpec
        for unitI = 1, unitSpec.count do
          local x = spawnZone.point.x + 15 * spawnedUnitCount
          local y = spawnZone.point.z - 15 * spawnedUnitCount
          newUnits[#newUnits + 1] = autogft_ReinforcerUnit:new(unitSpec.type, self:getUniqueUnitName(), x, y, 0)
          spawnedUnitCount = spawnedUnitCount + 1
        end
      end

      self:addGroupUnits(group, newUnits)
      group:advance()

    end
  end
end

---
-- @type SelectingReinforcer
-- @extends #SpecificUnitReinforcer
-- @field #number coalitionID
autogft_SelectingReinforcer = autogft_SpecificUnitReinforcer:extend()

---
-- @param #SelectingReinforcer self
-- @return #SelectingReinforcer
function autogft_SelectingReinforcer:new()
  self = autogft_SelectingReinforcer:createInstance()
  self.coalitionID = nil
  return self
end

---
-- @param #SelectingReinforcer self
-- @param #number id
function autogft_SelectingReinforcer:setCountryID(id)
  autogft_Reinforcer.setCountryID(self, id)
  self.coalitionID = coalition.getCountryCoalition(self.countryID)
end

---
-- @param #SelectingReinforcer self
function autogft_SelectingReinforcer:reinforce()

  self:assertHasBaseZones()
  self:assertHasGroupsUnitSpecs()

  local availableUnits = autogft.getUnitsInZones(self.coalitionID, self.baseZones)
  if #availableUnits > 0 then
    self:reinforceFromUnits(availableUnits)
  end
end

---
-- @type RandomUnitSpec
-- @extends unitspec#UnitSpec
-- @field #number minimum
-- @field #number diff
autogft_RandomUnitSpec = autogft_UnitSpec:extend()

---
-- @param #RandomUnitSpec self
-- @param #number
function autogft_RandomUnitSpec:new(count, type, minimum)
  if minimum == nil then minimum = 0 end
  self = self:createInstance(autogft_UnitSpec:new(count, type))
  self.minimum = minimum
  self.diff = count - minimum
  return self
end

---
-- @type RandomReinforcer
-- @extends #SpecificUnitReinforcer
-- @field #RespawningReinforcer respawningReinforcer
autogft_RandomReinforcer = autogft_SpecificUnitReinforcer:extend()

---
-- @param #RandomReinforcer self
-- @return #RandomReinforcer
function autogft_RandomReinforcer:new()
  self = self:createInstance()
  self.respawningReinforcer = autogft_RespawningReinforcer:new()
  self.respawningReinforcer.baseZones = self.baseZones
  return self
end

---
-- @param #RandomReinforcer self
function autogft_RandomReinforcer:reinforce()
  for _, group in pairs(self.groupsUnitSpecs.keys) do
    local randomUnitSpecs = self.groupsUnitSpecs:get(group) --#list<#RandomUnitSpec>
    local unitSpecs = {}
    for i = 1, #randomUnitSpecs do
      local randomUnitSpec = randomUnitSpecs[i]
      local random = math.floor(math.random(randomUnitSpec.diff + 0.9999))
      local count = randomUnitSpec.minimum + random
      unitSpecs[#unitSpecs + 1] = autogft_UnitSpec:new(count, randomUnitSpec.type)
    end
    self.respawningReinforcer.groupsUnitSpecs:put(group, unitSpecs)
  end
  self.respawningReinforcer:reinforce()
end

---
-- @param #RandomReinforcer self
-- @param group#Group group
-- @param #list<#RandomUnitSpec> randomUnitSpecs
function autogft_RandomReinforcer:setGroupUnitSpecs(group, randomUnitSpecs)
  self.groupsUnitSpecs:put(group, randomUnitSpecs)
end

---
-- @param #RandomReinforcer self
-- @param #number id
function autogft_RandomReinforcer:setCountryID(id)
  autogft_Reinforcer.setCountryID(self, id)
  self.respawningReinforcer:setCountryID(id)
end



-- autogft\setup.lua

---
-- AI units which can be set to automatically capture target zones, advance through captured zones and be reinforced when taking casualties.
-- @module Setup

---
-- @type Setup
-- @extends class#Class
-- @field taskforce#TaskForce taskForce
-- @field #number coalition
-- @field #number speed
-- @field #number maxDistanceKM
-- @field #boolean useRoads
-- @field #string skill
-- @field #number reinforcementTimerId
-- @field #number stopReinforcementTimerId
-- @field #number advancementTimerId
-- @field group#Group lastAddedGroup
-- @field map#Map baseLinks
autogft_Setup = autogft_Class:create()

---
-- Creates a new setup instance.
-- @param #Setup self
-- @return #Setup This instance (self)
function autogft_Setup:new()

  self = self:createInstance()
  self.taskForce = autogft_TaskForce:new()
  self.coalition = nil
  self.speed = 9999
  self.maxDistanceKM = 10
  self.useRoads = false
  self.reinforcementTimerId = nil
  self.advancementTimerId = nil
  self.lastAddedGroup = nil
  self.baseLinks = autogft_Map:new()

  local function autoInitialize()
    self:autoInitialize()
  end
  autogft.scheduleFunction(autoInitialize, 2)

  return self
end

---
-- Specifies the task force to stop using roads when advancing through the next tasks that are added.
-- @param #Setup self
-- @return #Setup
function autogft_Setup:stopUsingRoads()
  self.useRoads = false
  return self
end

---
-- Specifies the task force to use roads when advancing through the next tasks that are added.
-- @param #Setup self
-- @return #Setup
function autogft_Setup:startUsingRoads()
  self.useRoads = true
  return self
end

---
-- Sets the maximum time reinforcements will keep coming.
-- @param #Setup self
-- @param #number time Time [seconds] until reinforcements will stop coming
-- @return #Setup
function autogft_Setup:setReinforceTimerMax(time)

  if self.stopReinforcementTimerId then
    timer.removeFunction(self.stopReinforcementTimerId)
  end

  local function killTimer()
    self:stopReinforcing()
  end
  self.stopReinforcementTimerId = autogft.scheduleFunction(killTimer, time)

  return self
end

---
-- Automatically initializes the task force by starting timers (if not started) and adding groups and units (if not added).
-- Default reinforcement timer intervals is 600 seconds. Default advancement timer intervals is 300 seconds.
-- @param #Setup self
-- @return #Setup
function autogft_Setup:autoInitialize()

  if #self.taskForce.reinforcer.baseZones > 0 then
    if not self.coalition then
      local unitsInBases = autogft.getUnitsInZones(coalition.side.RED, self.taskForce.reinforcer.baseZones)
      if #unitsInBases == 0 then
        unitsInBases = autogft.getUnitsInZones(coalition.side.BLUE, self.taskForce.reinforcer.baseZones)
      end
      assert(#unitsInBases > 0, "Could not determine task force coalition, please set country.")
      self:setCountry(unitsInBases[1]:getCountry())
    end

    if self.taskForce.reinforcer:instanceOf(autogft_SpecificUnitReinforcer) then
      if self.taskForce.reinforcer.groupsUnitSpecs.length <= 0 then
        self:autoAddUnitLayoutFromBases()
      end
    end

    if not self.reinforcementTimerId then
      self:setReinforceTimer(600)
    end
  end

  if not self.advancementTimerId then
    self:setAdvancementTimer(300)
  end

  return self
end

---
-- Automatically adds groups and units.
-- Determines which groups and units that should be added to the task force by looking at a list of units and copying the layout.
-- @param #Setup self
-- @return #Setup
function autogft_Setup:autoAddUnitLayout(units)

  if not self.country then
    self:setCountry(units[1]:getCountry())
  end

  -- Create a table of groups {group = {type = count}}
  local groupUnits = {}

  -- Iterate through own base units
  for _, unit in pairs(units) do
    local dcsGroupId = unit:getGroup():getID()

    -- Check if table has this group
    if not groupUnits[dcsGroupId] then
      groupUnits[dcsGroupId] = {}
    end

    -- Check if group has this type
    local typeName = unit:getTypeName()
    if not groupUnits[dcsGroupId][typeName] then
      groupUnits[dcsGroupId][typeName] = 0
    end

    -- Count the number of units in this group of that type
    groupUnits[dcsGroupId][typeName] = groupUnits[dcsGroupId][typeName] + 1
  end

  -- Iterate through the table of groups, add groups and units
  for _, group in pairs(groupUnits) do
    self:addGroup()
    for type, count in pairs(group) do
      self:addUnits(count, type)
    end
  end

  return self
end

---
-- Looks through base zones for units and attempts to add the same layout to the task force (by invoking ${Setup.autoAddUnitLayout})
-- @param #Setup self
-- @return #Setup
function autogft_Setup:autoAddUnitLayoutFromBases()

  -- Determine coalition based on units in base zones
  local ownUnitsInBases = autogft.getUnitsInZones(self.coalition, self.taskForce.reinforcer.baseZones)

  if #ownUnitsInBases > 0 then
    self:autoAddUnitLayout(ownUnitsInBases)
    local reinforcer = self.taskForce.reinforcer --reinforcer#SpecificUnitReinforcer
    local tempReinforcer = autogft_SelectingReinforcer:new()
    tempReinforcer.groupsUnitSpecs = reinforcer.groupsUnitSpecs
    tempReinforcer:setCountryID(reinforcer.countryID)
    tempReinforcer:reinforceFromUnits(ownUnitsInBases)
  end

  return self
end

---
-- Stops the advancement timer
-- @param #Setup self
-- @return #Setup
function autogft_Setup:stopAdvancementTimer()
  if self.advancementTimerId then
    timer.removeFunction(self.advancementTimerId)
    self.advancementTimerId = nil
  end
  return self
end

---
-- Adds an intermidiate zone task.
-- Task force units advancing through the task list will move through this task zone to get to the next one.
-- @param #Setup self
-- @param #string zoneName
-- @return #Setup
function autogft_Setup:addIntermidiateZone(zoneName)
  return self:addTask(autogft_CaptureTask:new(zoneName, self.coalition))
end

---
-- Adds a task to the task force
-- @param #Setup self
-- @param task#Task task
-- @return #Setup
function autogft_Setup:addTask(task)
  task.useRoads = self.useRoads
  task.speed = self.speed
  self.taskForce.taskSequence:addTask(task)
  return self
end

---
-- Adds another group specification to the task force.
-- After a group is added, use @{#Setup.addUnits} to add units.
-- See "unit-types" for a complete list of available unit types.
-- @param #Setup self
-- @return #Setup This instance (self)
function autogft_Setup:addGroup()

  self.taskForce.groups[#self.taskForce.groups + 1] = autogft_Group:new(self.taskForce.taskSequence)
  self.lastAddedGroup = self.taskForce.groups[#self.taskForce.groups]
  if self.taskForce.reinforcer:instanceOf(autogft_SpecificUnitReinforcer) then
    self.taskForce.reinforcer.groupsUnitSpecs:put(self.lastAddedGroup, {})
  end
  return self
end

---
-- Starts a timer which updates the current target zone, and issues the task force units to engage it on given time intervals.
-- Invokes @{#Setup.moveToTarget}.
-- @param #Setup self
-- @param #number timeInterval Seconds between each target update
-- @return #Setup This instance (self)
function autogft_Setup:setAdvancementTimer(timeInterval)
  self:stopAdvancementTimer()
  local function updateAndAdvance()
    self.taskForce:updateTarget()
    self.taskForce:advance()
    self.advancementTimerId = autogft.scheduleFunction(updateAndAdvance, timeInterval)
  end
  self.advancementTimerId = autogft.scheduleFunction(updateAndAdvance, timeInterval)
  return self
end

---
-- Starts a timer which reinforces the task force on time intervals.
-- Every time interval, linked base zones are checked (see @{Setup.checkBaseLinks}).
-- If all base zones are disabled (due to linked groups being destroyed), the task force is not reinforced.
-- @param #Setup self
-- @param #number timeInterval Time [seconds] between each reinforcement
-- @return #Setup This instance (self)
function autogft_Setup:setReinforceTimer(timeInterval)
  self:stopReinforcing()

  assert(#self.taskForce.reinforcer.baseZones > 0, "Cannot set reinforcing timer for this task force, no base zones are declared.")

  local function reinforce()
    self:checkBaseLinks()
    if #self.taskForce.reinforcer.baseZones > 0 then
      self.taskForce:reinforce()
      self.reinforcementTimerId = autogft.scheduleFunction(reinforce, timeInterval)
    end
  end
  autogft.scheduleFunction(reinforce, 5)

  return self
end

---
-- Checks if a particular unit is present in this task force.
-- @param #Setup self
-- @param DCSUnit#Unit unit Unit in question
-- @return #boolean True if this task force contains the unit, false otherwise.
function autogft_Setup:containsUnit(unit)
  for _, group in pairs(self.taskForce.reinforcer.groupsUnitSpecs.keys) do
    if group:containsUnit(unit) then return true end
  end
  return false
end

---
-- Sets the country ID of this task force.
-- @param #Setup self
-- @param #number country Country ID
-- @return #Setup This instance (self)
function autogft_Setup:setCountry(country)
  self.coalition = coalition.getCountryCoalition(country)
  -- Update capturing tasks coalition
  for i = 1, #self.taskForce.taskSequence.tasks do
    local task = self.taskForce.taskSequence.tasks[i]
    if task:instanceOf(autogft_CaptureTask) then
      task.coalition = self.coalition
    end
  end
  -- Update reinforcer
  self.taskForce.reinforcer:setCountryID(country)
  return self
end

---
-- Adds a base zone to the task force, which will be used for reinforcing.
-- @param #Setup self
-- @param #string zoneName Name of base zone
-- @return #Setup This instance (self)
function autogft_Setup:addBaseZone(zoneName)
  self.taskForce.reinforcer:addBaseZone(zoneName)
  return self
end

---
-- Adds a control zone task.
-- The task force units will move to and attack this zone as long as there are enemy units present.
-- If enemy units re-appear, the task force will retake it.
-- Task force units advancing through the task list will move through this task zone to get to the next one.
-- @param #Setup self
-- @param #string zoneName Name of target zone
-- @return #Setup This instance (self)
function autogft_Setup:addControlZone(zoneName)
  return self:addTask(autogft_ControlTask:new(zoneName, self.coalition))
end

---
-- Sets the skill of the task force reinforcement units.
-- Skill alternatives are the same as in the mission editor: Any from "Average" to "Random".
-- @param #Setup self
-- @param #string skill New skill
-- @return #Setup This instance (self)
function autogft_Setup:setSkill(skill)
  self.skill = skill
  return self
end

---
-- Sets the maximum distance of unit routes (see @{#Setup.maxDistanceKM}).
-- If set, this number constrains how far groups of the task force will move between each move command (advancement).
-- When units are moving towards a target, units will stop at this distance and wait for the next movement command.
-- This prevents lag when computing routes over long distances.
-- @param #Setup self
-- @param #number maxDistanceKM Maximum distance (kilometres)
-- @return #Setup This instance (self)
function autogft_Setup:setMaxRouteDistance(maxDistanceKM)
  self.maxDistanceKM = maxDistanceKM
  return self
end

---
-- Sets the desired speed of the task force units when advancing (see @{#Setup.speed}).
-- @param #Setup self
-- @param #boolean speed New speed (in knots)
-- @return #Setup This instance (self)
function autogft_Setup:setSpeed(speed)
  self.speed = speed
  if #self.taskForce.taskSequence.tasks > 0 then self.taskForce.taskSequence.tasks[#self.taskForce.taskSequence.tasks].speed = self.speed end
  return self
end

---
-- Scans the map once for any pre-existing units to control in this task force.
-- Groups with name starting with the scan prefix will be considered.
-- A task force will only take control of units according to the task force unit specification (added units).
-- @param #Setup self
-- @return #Setup
function autogft_Setup:scanUnits(groupNamePrefix)

  local coalitionGroups = {
    coalition.getGroups(coalition.side.BLUE),
    coalition.getGroups(coalition.side.RED)
  }

  local availableUnits = {}

  local coalition = 1
  while coalition <= #coalitionGroups and #availableUnits == 0 do
    for _, group in pairs(coalitionGroups[coalition]) do
      if group:getName():find(groupNamePrefix) == 1 then
        local units = group:getUnits()
        for unitIndex = 1, #units do
          availableUnits[#availableUnits + 1] = units[unitIndex]
        end
      end
    end
    coalition = coalition + 1
  end

  if #availableUnits > 0 then
    if not self.country then
      self:setCountry(availableUnits[1]:getCountry())
    end
    self:autoAddUnitLayout(availableUnits)
    self.taskForce.reinforcer:reinforceFromUnits(availableUnits)
  end

  return self
end

---
-- Stops the reinforcing/respawning timers (see @{Setup.setReinforceTimer}).
-- @param #Setup self
-- @return #Setup
function autogft_Setup:stopReinforcing()

  if self.reinforcementTimerId then
    timer.removeFunction(self.reinforcementTimerId)
    self.reinforcementTimerId = nil
  end

  if self.stopReinforcementTimerId then
    timer.removeFunction(self.stopReinforcementTimerId)
    self.stopReinforcementTimerId = nil
  end

  return self
end

---
-- Adds unit specifications to the most recently added group (see @{#Setup.addGroup}) of the task force.
-- @param #Setup self
-- @return #Setup
function autogft_Setup:addUnits(count, type)
  assert(self.taskForce.reinforcer:instanceOf(autogft_SpecificUnitReinforcer), "Cannot add units with this function to this type of reinforcer.")
  if not self.lastAddedGroup then self:addGroup() end
  local unitSpecs = self.taskForce.reinforcer.groupsUnitSpecs:get(self.lastAddedGroup)
  unitSpecs[#unitSpecs + 1] = autogft_UnitSpec:new(count, type)
  return self
end

---
-- Sets the task force to only use pre-existing units when reinforcing. Always invoke this before units are added (not after).
-- @param #Setup self
-- @return #Setup
function autogft_Setup:useStaging()
  self:setReinforcer(autogft_SelectingReinforcer:new())
  return self
end

---
-- Links a base zone to a group. Linked bases will be disabled for this task force if the group is destroyed (see @{Setup.checkBaseLinks}.
-- @param #Setup self
-- @param #string zoneName
-- @param #string groupName
-- @return #Setup
function autogft_Setup:linkBase(zoneName, groupName)
  assert(trigger.misc.getZone(zoneName), "Cannot link base. Zone \"" .. zoneName .. "\" does not exist in this mission.")
  self.baseLinks:put(zoneName, groupName)
  return self
end

---
-- Checks all base zones with links to see if the specified unit still exists in the mission.
-- If the group linked with the base zone does not exist (is destroyed), the base zone is disabled for this task force.
-- @param #Setup self
function autogft_Setup:checkBaseLinks()

  for _, zoneName in pairs(self.baseLinks.keys) do
    local groupName = self.baseLinks:get(zoneName)
    local group = Group.getByName(groupName)
    -- If linked group is missing or destroyed
    if not autogft.groupExists(group) then
      local linkedBaseZone = trigger.misc.getZone(zoneName)
      -- Find zone in question
      local baseZone = nil
      local baseZoneI = 1
      while not baseZone and baseZoneI <= #self.taskForce.reinforcer.baseZones do
        local zone = self.taskForce.reinforcer.baseZones[baseZoneI]
        if autogft.compareZones(linkedBaseZone, zone) then
          baseZone = zone
        end
        baseZoneI = baseZoneI + 1
      end
      baseZoneI = baseZoneI - 1

      -- Remove zone from reinforcer
      if baseZone then
        self.taskForce.reinforcer.baseZones[baseZoneI] = nil
      end
    end
  end
end

---
-- Sets the task force to use a randomized unit spawner when reinforcing.
-- The random units must be specified with ${Setup.addRandomUnitAlternative}).
-- @param #Setup self
-- @return #Setup
function autogft_Setup:useRandomUnits()
  self:setReinforcer(autogft_RandomReinforcer:new())
  return self
end

---
-- Adds a random unit alternative, given a maximum count, type and minimum count.
-- When the task force is reinforced, a random number (between minimum and maximum) of units will be spawned for the task force group.
-- @param #Setup self
-- @param #number max
-- @param #string type
-- @param #number minimum
-- @return #Setup
function autogft_Setup:addRandomUnitAlternative(max, type, minimum)
  if not self.taskForce.reinforcer:instanceOf(autogft_RandomReinforcer) then
    self:useRandomUnits()
  end
  local reinforcer = self.taskForce.reinforcer --reinforcer#RandomReinforcer
  if not self.lastAddedGroup then self:addGroup() end
  local unitSpecs = self.taskForce.reinforcer.groupsUnitSpecs:get(self.lastAddedGroup)
  unitSpecs[#unitSpecs + 1] = autogft_RandomUnitSpec:new(max, type, minimum)
  return self
end

---
-- Performs checks to determine if the task force can change reinforcer.
-- @param #Setup self
function autogft_Setup:assertCanChangeReinforcer()
  local baseMessage = "Cannot change task force reinforcing policy: "
  assert(#self.taskForce.reinforcer.baseZones == 0, baseMessage .. "Base zones already added.")
  if self.taskForce.reinforcer:instanceOf(autogft_SpecificUnitReinforcer) then
    assert(self.taskForce.reinforcer.groupsUnitSpecs.length == 0, baseMessage .. "Groups/units already added.")
  end
end

---
-- Sets the reinforcer of the task force.
-- @param #Setup self
-- @param reinforcer#Reinforcer reinforcer
function autogft_Setup:setReinforcer(reinforcer)
  self:assertCanChangeReinforcer()
  reinforcer.unitSkill = self.skill
  reinforcer.countryID = self.taskForce.reinforcer.countryID
  self.taskForce.reinforcer = reinforcer
end



-- autogft\task.lua

---
-- @module Task

---
-- @type Task
-- @extends class#Class
-- @field #boolean accomplished
-- @field #boolean useRoads
-- @field #number speed
autogft_Task = autogft_Class:create()

---
-- @param #Task self
-- @return #Task
function autogft_Task:new()
  self = self:createInstance()
  self.accomplished = false
  self.useRoads = false
  self.speed = 100
  return self
end

---
-- @param #Task self
-- @return #boolean
function autogft_Task:isAccomplished()
  return self.accomplished
end

---
-- @param #Task self
-- @return vector2#Vector2
function autogft_Task:getLocation()
  self:throwAbstractFunctionError()
end

---
-- @type ZoneTask
-- @extends #Task
-- @field DCSZone#Zone zone
autogft_ZoneTask = autogft_Task:extend()

---
-- @param #ZoneTask self
-- @return #ZoneTask
function autogft_ZoneTask:new(zoneName)
  self = self:createInstance()
  self.zone = trigger.misc.getZone(zoneName)
  assert(self.zone, "Zone \"" .. zoneName .. "\" does not exist in this mission.")
  return self
end

---
-- @param #ZoneTask self
-- @return vector2#Vector2
function autogft_ZoneTask:getLocation()
  local radius = self.zone.radius
  local zonePos = autogft_Vector2:new(self.zone.point.x, self.zone.point.z)
  local randomAngle = math.random(math.pi * 2)
  local randomPos = autogft_Vector2:new(math.cos(randomAngle), math.sin(randomAngle)):scale(radius * 0.75)
  return zonePos:plus(randomPos)
end

---
-- @type CaptureTask
-- @extends #ZoneTask
-- @field #number coalition
autogft_CaptureTask = autogft_ZoneTask:extend()

---
-- @param #CaptureTask self
-- @param #string zoneName
-- @param #number coalition
-- @return #CaptureTask
function autogft_CaptureTask:new(zoneName, coalition)
  self = self:createInstance(autogft_ZoneTask:new(zoneName))
  self.coalition = coalition
  return self
end

---
-- @param #CaptureTask self
-- @param #number coalitionID
-- @return #boolean
function autogft_CaptureTask:hasUnitPresent(coalitionID)
  local radiusSquared = self.zone.radius^2
  local result = false
  local groups = coalition.getGroups(coalitionID)
  local groupIndex = 1
  while not result and groupIndex <= #groups do
    local units = groups[groupIndex]:getUnits()
    local unitIndex = 1
    while not result and unitIndex <= #units do
      local unit = units[unitIndex]
      local pos = unit:getPosition().p
      local dx = self.zone.point.x - pos.x
      local dy = self.zone.point.z - pos.z
      if (dx*dx + dy*dy) <= radiusSquared then
        result = true
      end
      unitIndex = unitIndex + 1
    end
    groupIndex = groupIndex + 1
  end
  return result
end

---
-- @param #CaptureTask self
-- @return #boolean
function autogft_CaptureTask:hasFriendlyPresent()
  return self:hasUnitPresent(self.coalition)
end

---
-- @param #CaptureTask self
-- @return #boolean
function autogft_CaptureTask:hasEnemyPresent()
  local enemyCoalition
  if self.coalition == coalition.side.BLUE then
    enemyCoalition = coalition.side.RED
  else
    enemyCoalition = coalition.side.BLUE
  end
  return self:hasUnitPresent(enemyCoalition)
end

---
-- @param #CaptureTask self
-- @return #boolean
function autogft_CaptureTask:isAccomplished()
  if not autogft_Task.isAccomplished(self) then
    if self:hasFriendlyPresent() and not self:hasEnemyPresent() then
      self.accomplished = true
    end
  end
  return autogft_Task.isAccomplished(self)
end

---
-- @type ControlTask
-- @extends #CaptureTask
autogft_ControlTask = autogft_CaptureTask:extend()

---
-- @param #ControlTask self
-- @return #boolean
function autogft_ControlTask:isAccomplished()
  if self:hasEnemyPresent() then
    self.accomplished = false
  elseif not self.accomplished then
    self.accomplished = self:hasFriendlyPresent()
  end
  return autogft_Task.isAccomplished(self)
end



-- autogft\taskforce.lua

---
-- @module TaskForce

---
-- @type TaskForce
-- @extends class#Class
-- @field tasksequence#TaskSequence taskSequence
-- @field reinforcer#Reinforcer reinforcer
-- @field #list<group#Group> groups
autogft_TaskForce = autogft_Class:create()

---
-- @param #TaskForce self
-- @return #TaskForce
function autogft_TaskForce:new()
  self = self:createInstance()
  self.taskSequence = autogft_TaskSequence:new()
  self.reinforcer = autogft_RespawningReinforcer:new()
  self.groups = {}
  return self
end

---
-- @param #TaskForce self
function autogft_TaskForce:updateTarget()
  self.taskSequence:updateCurrentTask()
end

---
-- @param #TaskForce self
function autogft_TaskForce:advance()
  for i = 1, #self.groups do
    local group = self.groups[i]
    if group:exists() then group:advance() end
  end
end

---
-- @param #TaskForce self
-- @return #TaskForce
function autogft_TaskForce:reinforce()
  if self.taskSequence.currentTaskIndex == 0 then
    self:updateTarget()
  end
  self.reinforcer:reinforce()
end



-- autogft\tasksequence.lua

---
-- @module TaskSequence

---
-- @type TaskSequence
-- @extends class#Class
-- @field #list<task#Task> tasks
-- @field #number currentTaskIndex
autogft_TaskSequence = autogft_Class:create()

---
-- @param #TaskSequence self
-- @return #TaskSequence
function autogft_TaskSequence:new()
  self = self:createInstance()
  self.tasks = {}
  self.currentTaskIndex = 0
  return self
end

---
-- @param #TaskSequence self
-- @param task#Task task
function autogft_TaskSequence:addTask(task)
  self.tasks[#self.tasks + 1] = task
end

---
-- @param #TaskSequence self
function autogft_TaskSequence:updateCurrentTask()
  local newTaskIndex
  local taskIndex = 1
  while not newTaskIndex and taskIndex <= #self.tasks do
    if not self.tasks[taskIndex]:isAccomplished() then
      newTaskIndex = taskIndex
    end
    taskIndex = taskIndex + 1
  end
  if not newTaskIndex then
    newTaskIndex = #self.tasks
  end
  self.currentTaskIndex = newTaskIndex
end

---
-- @param #TaskSequence self
function autogft_TaskSequence:getCurrentTask()
  return self.tasks[self.currentTaskIndex]
end



-- autogft\unitcluster.lua

---
-- @module UnitCluster

---
-- @type UnitCluster
-- @extends class#Class
-- @field #list<DCSUnit#Unit> units
-- @field vector2#Vector2 midPoint
autogft_UnitCluster = autogft_Class:create()

---
-- @param #UnitCluster self
-- @param #list<DCSUnit#Unit> units
-- @param vector2#Vector2 midPoint
-- @return #UnitCluster
function autogft_UnitCluster:new(units, midPoint)
  self = self:createInstance()
  self.units = units
  self.midPoint = midPoint
  return self
end



-- autogft\util.lua

---
-- @module Util

---
-- @type autogft
autogft = {}

-- Utility function definitions

---
-- @param DCSVec3#Vec3 position
-- @return #number
function autogft.getHeadingNorthCorrection(position)
  local latitude, longitude = coord.LOtoLL(position)
  local nortPosition = coord.LLtoLO(latitude + 1, longitude)
  return math.atan2(nortPosition.z - position.z, nortPosition.x - position.x)
end

---
-- @param DCSUnit#Unit unit
-- @return #number
function autogft.getUnitHeading(unit)
  local unitPosition = unit:getPosition()
  local unitPos = autogft_Vector3.getCopy(unitPosition.p)
  local heading = math.atan2(unitPosition.x.z, unitPosition.x.x) + autogft.getHeadingNorthCorrection(unitPos)
  if heading < 0 then
    heading = heading + 2 * math.pi
  end
  return heading
end

---
-- @param DCSUnit#Unit unit
-- @param DCSZone#Zone zone
-- @return #boolean
function autogft.unitIsWithinZone(unit, zone)
  local pos = unit:getPosition().p
  local dx = zone.point.x - pos.x
  local dy = zone.point.z - pos.z
  local radiusSquared = zone.radius * zone.radius
  if (dx*dx + dy*dy) <= radiusSquared then
    return true
  end
  return false
end

---
-- @param #list<DCSUnit#Unit> units
-- @param #string type
-- @return #number
function autogft.countUnitsOfType(units, type)
  local count = 0
  local unit
  for i = 1, #units do
    if units[i]:getTypeName() == type then
      count = count + 1
    end
  end
  return count
end

---
-- @param #vec3
-- @param #vec3
-- @return #number
function autogft.getDistanceBetween(a, b)
  local dx = a.x - b.x
  local dy = a.y - b.y
  local dz = a.z - b.z
  return math.sqrt(dx * dx + dy * dy + dz * dz)
end

---
-- @param #number coalitionId
-- @param #list<DCSZone#Zone> zones
-- @return #list<DCSUnit#Unit>
function autogft.getUnitsInZones(coalitionId, zones)
  local result = {}
  local groups = coalition.getGroups(coalitionId)
  for _, zone in pairs(zones) do
    local radiusSquared = zone.radius * zone.radius
    for _, group in pairs(groups) do
      local units = group:getUnits()
      for unitIndex = 1, #units do
        local unit = units[unitIndex]
        local pos = unit:getPosition().p
        local dx = zone.point.x - pos.x
        local dy = zone.point.z - pos.z
        if (dx*dx + dy*dy) <= radiusSquared then
          result[#result + 1] = units[unitIndex]
        end
      end
    end
  end
  return result
end

---
-- @param #number coalitionId
-- @param #list<#string> zoneNames
-- @return #list<DCSUnit#Unit>
function autogft.getUnitsInZonesByNames(coalitionId, zoneNames)
  local zones = {}
  for zoneNameIndex = 1, #zoneNames do
    local zone = trigger.misc.getZone(zoneNames[zoneNameIndex])
    zones[#zones + 1] = zone
  end
  return autogft.getUnitsInZones(coalitionId, zones)
end

---
-- @param #function func
-- @param #number time Seconds
-- @return #number Function id
function autogft.scheduleFunction(func, time)
  local function triggerFunction()
    local success, message = pcall(func)
    if not success then
      env.error("Error in scheduled function: "..message, true)
    end
  end
  return timer.scheduleFunction(triggerFunction, {}, timer.getTime() + time)
end

---
-- @param #string prefix (Optional)
-- @return #string
function autogft.getUniqueGroupName(prefix)
  local groupName
  local index = 0
  while (not groupName) or Group.getByName(groupName) do
    index = index + 1
    groupName = "autogft group #" .. index
    if prefix then groupName = prefix .. "-" .. groupName end
  end
  return groupName
end

---
-- @param DCSZone#Zone zone1
-- @param DCSZone#Zone zone2
function autogft.compareZones(zone1, zone2)
  return autogft_Vector3.equals(zone1.point, zone2.point)
end

---
-- @param DCSGroup#Group group
-- @return #boolean
function autogft.groupExists(group)
  local units = group:getUnits()
  for i = 1, #units do
    local unit = units[i] --DCSUnit#Unit
    if unit and unit:isExist() then
      return true
    end
  end
  return false
end

---
-- Deep copy a table
-- Code from https://gist.github.com/MihailJP/3931841
function autogft.deepCopy(t)
  if type(t) ~= "table" then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      target[k] = autogft.deepCopy(v)
    else
      target[k] = v
    end
  end
  setmetatable(target, meta)
  return target
end

---
-- Returns a string representation of an object
function autogft.toString(obj)

  local stringifiedTableIDs = {}

  local indent = "    "
  local function toStringRecursively(obj, level)

    if (obj == nil) then
      return "(nil)"
    end

    local str = ""
    if (type(obj) == "table") then
      local tableID = tostring(obj):sub(8)

      str = str .. "(" .. tableID .. ")"
      if not stringifiedTableIDs[tableID] then
        stringifiedTableIDs[tableID] = true
        if (level ~= 0) then
          str = str .. "{"
        end
        local isFirst = true
        for key, value in pairs(obj) do
          if (isFirst == false) then
            str = str .. ","
          end
          str = str .. "\n"
          for i = 1, level do
            str = str .. indent
          end

          if (type(key) == "number") then
            str = str .. "[\"" .. key .. "\"]"
          elseif (type(key) == "table") then
            str = str .. tostring(key)
          else
            str = str .. "\"" .. key .. "\""
          end
          str = str .. " = "

          if (type(value) == "function") then
            str = str .. "(function)"
          else
            str = str .. toStringRecursively(value, level + 1)
          end
          isFirst = false
        end

        if (level ~= 0) then
          str = str .. "\n"
          for i = 1, level - 1 do
            str = str .. indent
          end
          str = str .. "}"
        end
      end
    else
      str = obj
      if (type(obj) == "string") then
        str = "\"" .. str .. "\""
      elseif type(obj) == "boolean" then
        if obj == true then
          str = "true"
        else
          str = "false"
        end
      end
    end

    return str
  end

  return toStringRecursively(obj, 1)
end

---
-- @param #list list
-- @param # item
function autogft.contains(list, item)
  for i = 1, #list do
    if list[i] == item then return true end
  end
  return false
end

function autogft.log(variable)
  if not env then
    env = {
      info = function(msg)
        print(msg)
      end
    }
  end

  -- Try to determine variable name
  local variableName
  local i = 1
  local var2Name, var2Val = debug.getlocal(2,1)
  while var2Name ~= nil and not variableName do
    if var2Val == variable then
      variableName = var2Name
    end
    i = i + 1
    var2Name, var2Val = debug.getlocal(2,i)
  end

  if not variableName then
    variableName = "(undefined)"
  end

  env.info(variableName .. ": " .. autogft.toString(variable))
end

function autogft.logFunction()
  local trace = "(END)"
  local i = 2
  local functionName = debug.getinfo(i, "n").name
  while functionName do
    trace = functionName .. " -> " .. trace
    i = i + 1
    functionName = debug.getinfo(i, "n").name
  end
  autogft.log("Function trace: " .. trace)
end

function autogft.getTableID(table)
  return tostring(table):sub(8)
end



-- autogft\waypoint.lua

---
-- @module Waypoint

---
-- @type Waypoint
-- @extends vector2#Vector2
-- @field #number speed
-- @field #string action
-- @field #string type
autogft_Waypoint = autogft_Vector2:extend()

---
-- @param #Waypoint self
-- @param #number x
-- @param #number y
-- @param #Waypoint.Action action (Optional)
-- @return #Waypoint
function autogft_Waypoint:new(x, y, action)
  local roundedX = math.floor(x + 0.5)
  local roundedY = math.floor(y + 0.5)
  self = self:createInstance(autogft_Vector2:new(roundedX, roundedY))
  self.speed = 100
  if action then
    self.action = action
  else
    self.action = autogft_Waypoint.Action.CONE
  end
  self.type = autogft_Waypoint.Type.TURNING_POINT
  return self
end

---
-- @type Waypoint.Action
-- @field #string CONE
-- @field #string OFF_ROAD
-- @field #string ON_ROAD
autogft_Waypoint.Action = {
  CONE = "Cone",
  OFF_ROAD = "Off Road",
  ON_ROAD = "On Road"
}

---
-- @type Waypoint.Type
-- @field #string TURNING_POINT
autogft_Waypoint.Type = {
  TURNING_POINT = "Turning Point"
}



-- unit-types\unit-types.lua

unitType = {}

unitType.navy = {}

unitType.navy.blue = {
  VINSON = "VINSON",
  PERRY = "PERRY",
  TICONDEROG = "TICONDEROG"
}

unitType.navy.red = {
  ALBATROS = "ALBATROS",
  KUZNECOW = "KUZNECOW",
  MOLNIYA = "MOLNIYA",
  MOSCOW = "MOSCOW",
  NEUSTRASH = "NEUSTRASH",
  PIOTR = "PIOTR",
  REZKY = "REZKY"
}

unitType.navy.civil = {
  ELNYA = "ELNYA",
  Drycargo_ship2 = "Dry-cargo ship-2",
  Drycargo_ship1 = "Dry-cargo ship-1",
  ZWEZDNY = "ZWEZDNY"
}

unitType.navy.submarine = {
  KILO = "KILO",
  SOM = "SOM"
}

unitType.navy.speedboat = {
  speedboat = "speedboat"
}

unitType.vehicle = {}

unitType.vehicle.howitzer = {
  _2B11_mortar = "2B11 mortar",
  SAU_Gvozdika = "SAU Gvozdika",
  SAU_Msta = "SAU Msta",
  SAU_Akatsia = "SAU Akatsia",
  SAU_2C9 = "SAU 2-C9",
  M109 = "M-109"
}

unitType.vehicle.ifv = {
  AAV7 = "AAV7",
  BMD1 = "BMD-1",
  BMP1 = "BMP-1",
  BMP2 = "BMP-2",
  BMP3 = "BMP-3",
  Boman = "Boman",
  BRDM2 = "BRDM-2",
  BTR80 = "BTR-80",
  BTR_D = "BTR_D",
  Bunker = "Bunker",
  Cobra = "Cobra",
  LAV25 = "LAV-25",
  M1043_HMMWV_Armament = "M1043 HMMWV Armament",
  M1045_HMMWV_TOW = "M1045 HMMWV TOW",
  M1126_Stryker_ICV = "M1126 Stryker ICV",
  M113 = "M-113",
  M1134_Stryker_ATGM = "M1134 Stryker ATGM",
  M2_Bradley = "M-2 Bradley",
  Marder = "Marder",
  MCV80 = "MCV-80",
  MTLB = "MTLB",
  Paratrooper_RPG16 = "Paratrooper RPG-16",
  Paratrooper_AKS74 = "Paratrooper AKS-74",
  Sandbox = "Sandbox",
  Soldier_AK = "Soldier AK",
  Infantry_AK = "Infantry AK",
  Soldier_M249 = "Soldier M249",
  Soldier_M4 = "Soldier M4",
  Soldier_M4_GRG = "Soldier M4 GRG",
  Soldier_RPG = "Soldier RPG",
  TPZ = "TPZ"
}

unitType.vehicle.mlrs = {
  GradURAL = "Grad-URAL",
  Uragan_BM27 = "Uragan_BM-27",
  Smerch = "Smerch",
  MLRS = "MLRS"
}

unitType.vehicle.sam = {
  _2S6_Tunguska = "2S6 Tunguska",
  Kub_2P25_ln = "Kub 2P25 ln",
  _5p73_s125_ln = "5p73 s-125 ln",
  S300PS_5P85C_ln = "S-300PS 5P85C ln",
  S300PS_5P85D_ln = "S-300PS 5P85D ln",
  SA11_Buk_LN_9A310M1 = "SA-11 Buk LN 9A310M1",
  Osa_9A33_ln = "Osa 9A33 ln",
  Tor_9A331 = "Tor 9A331",
  Strela10M3 = "Strela-10M3",
  Strela1_9P31 = "Strela-1 9P31",
  SA11_Buk_CC_9S470M1 = "SA-11 Buk CC 9S470M1",
  SA8_Osa_LD_9T217 = "SA-8 Osa LD 9T217",
  Patriot_AMG = "Patriot AMG",
  Patriot_ECS = "Patriot ECS",
  Gepard = "Gepard",
  Hawk_pcp = "Hawk pcp",
  SA18_Igla_manpad = "SA-18 Igla manpad",
  SA18_Igla_comm = "SA-18 Igla comm",
  Igla_manpad_INS = "Igla manpad INS",
  SA18_IglaS_manpad = "SA-18 Igla-S manpad",
  SA18_IglaS_comm = "SA-18 Igla-S comm",
  Vulcan = "Vulcan",
  Hawk_ln = "Hawk ln",
  M48_Chaparral = "M48 Chaparral",
  M6_Linebacker = "M6 Linebacker",
  Patriot_ln = "Patriot ln",
  M1097_Avenger = "M1097 Avenger",
  Patriot_EPP = "Patriot EPP",
  Patriot_cp = "Patriot cp",
  Roland_ADS = "Roland ADS",
  S300PS_54K6_cp = "S-300PS 54K6 cp",
  Stinger_manpad_GRG = "Stinger manpad GRG",
  Stinger_manpad_dsr = "Stinger manpad dsr",
  Stinger_comm_dsr = "Stinger comm dsr",
  Stinger_manpad = "Stinger manpad",
  Stinger_comm = "Stinger comm",
  ZSU234_Shilka = "ZSU-23-4 Shilka",
  ZU23_Emplacement_Closed = "ZU-23 Emplacement Closed",
  ZU23_Emplacement = "ZU-23 Emplacement",
  ZU23_Closed_Insurgent = "ZU-23 Closed Insurgent",
  Ural375_ZU23_Insurgent = "Ural-375 ZU-23 Insurgent",
  ZU23_Insurgent = "ZU-23 Insurgent",
  Ural375_ZU23 = "Ural-375 ZU-23"
}

unitType.vehicle.radar = {
  _1L13_EWR = "1L13 EWR",
  Kub_1S91_str = "Kub 1S91 str",
  S300PS_40B6M_tr = "S-300PS 40B6M tr",
  S300PS_40B6MD_sr = "S-300PS 40B6MD sr",
  _55G6_EWR = "55G6 EWR",
  S300PS_64H6E_sr = "S-300PS 64H6E sr",
  SA11_Buk_SR_9S18M1 = "SA-11 Buk SR 9S18M1",
  Dog_Ear_radar = "Dog Ear radar",
  Hawk_tr = "Hawk tr",
  Hawk_sr = "Hawk sr",
  Patriot_str = "Patriot str",
  Hawk_cwar = "Hawk cwar",
  p19_s125_sr = "p-19 s-125 sr",
  Roland_Radar = "Roland Radar",
  snr_s125_tr = "snr s-125 tr"
}

unitType.vehicle.structure = {
  house1arm = "house1arm",
  house2arm = "house2arm",
  outpost_road = "outpost_road",
  outpost = "outpost",
  houseA_arm = "houseA_arm"
}

unitType.vehicle.tank = {
  Challenger2 = "Challenger2",
  Leclerc = "Leclerc",
  Leopard1A3 = "Leopard1A3",
  Leopard2 = "Leopard-2",
  M60 = "M-60",
  M1128_Stryker_MGS = "M1128 Stryker MGS",
  M1_Abrams = "M-1 Abrams",
  T55 = "T-55",
  T72B = "T-72B",
  T80UD = "T-80UD",
  T90 = "T-90"
}

unitType.vehicle.unarmed = {
  Ural4320_APA5D = "Ural-4320 APA-5D",
  ATMZ5 = "ATMZ-5",
  ATZ10 = "ATZ-10",
  GAZ3307 = "GAZ-3307",
  GAZ3308 = "GAZ-3308",
  GAZ66 = "GAZ-66",
  M978_HEMTT_Tanker = "M978 HEMTT Tanker",
  HEMTT_TFFT = "HEMTT TFFT",
  IKARUS_Bus = "IKARUS Bus",
  KAMAZ_Truck = "KAMAZ Truck",
  LAZ_Bus = "LAZ Bus",
  Hummer = "Hummer",
  M_818 = "M 818",
  MAZ6303 = "MAZ-6303",
  Predator_GCS = "Predator GCS",
  Predator_TrojanSpirit = "Predator TrojanSpirit",
  Suidae = "Suidae",
  Tigr_233036 = "Tigr_233036",
  Trolley_bus = "Trolley bus",
  UAZ469 = "UAZ-469",
  Ural_ATsP6 = "Ural ATsP-6",
  Ural375_PBU = "Ural-375 PBU",
  Ural375 = "Ural-375",
  Ural432031 = "Ural-4320-31",
  Ural4320T = "Ural-4320T",
  VAZ_Car = "VAZ Car",
  ZiL131_APA80 = "ZiL-131 APA-80",
  SKP11 = "SKP-11",
  ZIL131_KUNG = "ZIL-131 KUNG",
  ZIL4331 = "ZIL-4331"
}
