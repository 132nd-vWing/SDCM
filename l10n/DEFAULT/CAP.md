# Combat Air Patrol (CAP)

## Documentation for pilots

The "Combat Air Patrol" fuctionality aims to provied training against live & fighting enemy aircraft.

The enemy aircrafts will be defending a pre-briefed zone, and any friendly aircraft entering that area will be engaged by the enemy.

As a safety measure, enemy aircrafts will be restricted by the mission designer/event host to a specific area, and will not be allowed to chase friendly unit outside of that area.

The Combat Air Patrol mission will stay active untill cancelled; if an aicrafts runs out of fuel a replacement aicraft will come relief it.

If a patrolling aicraft dies, a replacement unit will start after a set delay (default: 5 minutes) and resume the Combat Air Patrol.

### Enabling/disabling CAP

All functions are available in the F10 radio menu, under the "Combat Air Patrol" sub-menu.

#### First option: "Add an aircraft"

The first option adds an aicraft to the Combat Air Patrol. Any given Combat Air Patrol can have any number of active aircraft at any given time.

Different types of aicrafts and Combat Air Patrol can be mixed together.

This option can be "daisy-chained" at the start of an event, to trigger a set amount of CAP aicrafts to start patrolling.

For example, one could quickly call "Add an aircraft" 4 times in a row, and 4 aircrafts will be "queued" for take-off (they will not be created immediately).

#### Second option: "Cancel this CAP"

This option sends all patrolling aircrafts back to base, and effectively cancels this CAP. No other aicraft will spawn.

This can be used to reset the CAP if, for example, a CAP was too strong, or if there are less friendlies available.

If there are 4 MiG29S currently patrolling, and it turns out this is too strong an opposing force, one can call "Cancel this CAP", sending
those four MiG29S home, and call "Add an aircraft" 2 times, to replace them with a 2-ships CAP instead.

#### Third option: "Current aircraft(s) count"

This option simply prints the amount of currently active aicrafts in the CAP.

Please note that this can be very different than the amount of planes currently patrolling ! There can be 4 "active" aircrafts, with 2 currently in the air, 
while another one is starting up on the runway, and the last one waiting to be respawned after having been shot.


## Documentation for mission designers

The documentation for event hosts who would like to edit the Combat Air Patrol functionality can be found in the "CAP.lua" script itself.