# Galactic Conquest

A strategy game where teams of friends fight for control of the galaxy.

## Gameplay

At its core, this is a slow-paced strategy game with multiple layers. At the top, your team's Admiral gives each Captain a budget and a goal. The budget is used by the Captain to recruit and outfit units. The goal is something like "take control of the Hoth system." The Captain gives his units orders in turn-based combat, until he either retreats or wins his objective. Each turn takes one day. At the end of each day, the orders the captain has set are executed in tandem with the enemy's orders and combat is simulated.

## Auth/accounts/pay model

The server uses email as the account system. No password, only temp code.
Games are by invite to email. It's free to play a game that you were invited to, and it's free to start 1 game (per email account). After that, you must pay.
Potential pay options:

- $5/mo = can have 1 game running at a time.
- $10/mo = can have 10 games running at a time.
- $25/mo = can have 100 games running at a time.

## starting a game

1. login
2. select game "size" (how many players per team, how many systems in the galaxy)
3. "invite to game" button
4. wait for users to accept
5. pick teams + admirals, "launch game"
6. admirals give captains orders+budget
7. captains fight it out in their systems or retreat
8. game ends when one team owns both "home" systems

# what it does differently

variable (slow) pace. Three dimensional space tactics. Formalized teamwork with an actual leader.

# technical requirements/challenges

most complex part is actually gonna be the frontend most likely. 3d rendering and ui etc. Can almost certainly be performant enough with just Three.js on frontend.

backend just has to receive orders+store them, and calculate turns on a schedule.

### in-sector

js canvas 3-D "grid" with star at center of the cube, xyz axis lines, red/blue dots for ships, icons for planets/star/moons/asteroids
multiple zoom levels, click to zoom, xyz-hotkey axis rotation, click-n-drag rotation
click ship to select, it then shows movement range and weapon ranges. select MOVE, LASER, MISSILE, etc from options and click again to select target within range. can manually edit co-ordinates of target via numeric fields.

### fog-of-war

objects are detectable via two methods: passive and active.

Passive detection is just optical scanning, using reflected light to detect objects. The amount of light reflected depends on the object's surface area. Thus two variables determine passive detection: optical sensitivity and target size. While in real life there would be a gradual decay with probabilities of detection, for the sake of the game, there's a formula that produces a hard cutoff range of detection given those two inputs. Larger ships have more sensitive optics, and can thus passively sense ships from further away while smaller ships have worse optics but are also harder to spot. There are "scout" loadout options on some ships allowing increased optics at the expense of weapons/shields etc.

Active detection is like submarine pinging. The ship sends out many powerful bursts of light along a cone which allows guaranteed detection of any object within the cone area. again, in real life technically if you were hiding behind a larger object the cone wouldn't detect you but it's a game and im not coding that logic at least at first. The drawback of active detection is that it takes a lot of ship's power so you can't use weapon systems while using it, and any ship you detect with it will also detect you since their passive optics will detect the active ping. Thus basic strategy is to use a small "throwaway" ship to active detect many enemy ships at once if possible. once a target has been detected actively, they remain visible as long as there is at least one ship using "active tracking" since that takes far less resources to track a ship than to find one. When a ship uses an active ping it automatically keeps active tracking until destroyed, but admirals can toggle that setting for any ship at at any time. all that is necessary for tracking is that at least one ship in the fleet keep active-tracking on.

### resources

possible resources:
- population
    - used to crew ships + conquer/hold planets
- money
    - used to buy resources
- fuel
    - used to move a ship in-system
- common metals
- rare-earth metals
- metalloid elements (carbon, silicon, etc)
- non-metal elements (gasses)

### celestial bodies

- Star
- Planet
    - earth-like:   high population,    high money production
    - ice:          med population,     med money production,   high fuel production
    - desert:       med pop,            med money,              high metalloids production
    - gas:          low pop,            low money,              high non-metals
    - lava:         low pop,            low money,              high metals (both kinds) production
- Moon
- Asteroid
- Space Elevator: each planet requires one of these. if this is destroyed, the population+resources become "inaccessible" until it is built again. Building it is very expensive

## Technological setting

- FTL via "jump" drives which take long time to charge
- linear acceleration drive
- communication via ansible

## Units

There are 4 main classes of spacecraft:
- Destroyers
  - size: 1000 meters long
  - volume: 40,000,000 m^3
  - variants: carrier, assault
  - crew: 10,000
  - capable of system jump
  - carries many fighters and troops, and hosts most powerful missile batteries and weapons arrays, along with the heaviest armor. Tends to soak damage though...
- Cruiser
  - size: 300 meters long
  - volume: 3,000,000 m^3
  - variants: assault, defense
  - crew: 1,000
  - capable of system jump
  - carries some fighters and troops, and specializes in either powerful offense or defense
- Corvette
  - size: 100 meters long
  - volume: 90,000 m^3
  - variants: assault, scout
  - crew: 100
  - capable of system jump
  - carries a fighter, and specializes in either missile payloads or sensor arrays
- Fighter
  - size: 10 meters
  - volume: 700 m^3
  - crew: 1-100
  - NOT capable of system-jump
  - variants: landing, bombing, ship-to-ship
  - landers put troops on the surface of a world or star base to conquer it. they are very vulnerable
  - bombers put drop their very damaging payloads on a target, and then have to resupply
  - fighters kill bombers and landers, and can assist in putting damage on some larger ships if they don't get taken out by the automated defenses.
- Satellite
  - size: 10 meters
  - volume: 500 m^3
  - crew: 0
  - nearly defenseless, useful for planetary bombardment, basically just a bunch of solar panels, targeting optics and a rail gun. is used to maintain planetary security. need a fleet of them to be in orbit for planetary 'capture', cannot reposition once deployed

### Weapons

atomic payload (nuclear bomb)
chemical payload (bomb)
kinetic payload (mass driver/bullet/railgun)
energy payload (laser)

delivery modality:
- dumb = just goes in straight line
- smart = guided missile, limited auto-targeting 
- trap = typical landmine, triggered by likelyhood-to-hit

## turn resolution

all captains create their list of orders for their fleet
at daily timestamp 0.0.0 the host urbit galaxy-wars agent will "simeltaneously" resolve all the orders

two kinds of fire: auto, and manual
  auto is for things that don't have ammo limits
    each ship has an orders setting for how they should focus their auto-fire: either spread or focus. if it's focus, they will focus all their damage on the enemy unit within range, who is highest on the priority list. Captains can re-organize the priority list at any time.
  manual is for things that have limited ammo
    for manual weapons, like nukes, the captain must set it to auto-focus or specific target. for specific target, the weapon will only fire if the target is within range

1. if the ship has deployment orders, it does those, preventing any manual weapons fire or movement
2. each ship detects if an enemy is within laser or rail-gun range, and deals auto-fire damage
3. each ship detects if a valid manual weapons target is in range and fires
4. damage is calculated where the more incoming fire per target, the more effective damage
5. if a ship is still capable of movement, it moves to its new location
6. deployed units are created

### data types

game: references the path you need to join for the game, and the host, but the game object lives on the space path. also lists score, players etc
player: says what team+role a ship is on, also contains acheivements?
orders: indicates what battlefield + budget the player has

# Screens

## Home / Game listing

lists the games hosted in the current space

## New Game

allows you to name the game, and set player count, and set sector count, and time-scale for turns (either daily, 1 minute, or 10 min)

## Game view

### 'waiting' Game view

Allows you to join the game, pick your team, vote for team admiral, game starts automatically when all player slots are filled.

### 'playing' Game view

This is the core of the game. There are a few sub-views here:

- Galaxy map - shows which captain is where, and which sectors are controlled by which team
    - is 2D representation of spiral galaxy
    - if you're an Admiral, this map is much more useful, since you can issue captain-assignments and allocate resources to captains here.
        - can toggle into "resource table" to see how much of what comes from each sector, as well as how much is allocated to each captain currently
        - can only issue orders to captains who are "available"; once a captain is "engaged" with the enemy, they have to retreat (or lose) to be able to be re-assigned.
        - click the captain, select "assign sector" and click the sector. Then fill in the resource allocation you are giving him (TODO pin down how this works). Then select either "capture system" if it is not your system, or "hold system" (plus a number of days up to 7) if it is your system and click "SEND ORDERS"
        - every N days, new resources are available, and can be sent to captains or held. Click on "available resources" and click "send" and click on a sector with a captain in it. Then fill in how much of what you're sending and press "DISPATCH"
            - sending in raw resources is not possible. Only actual ships can be sent, though the ships could be fitted with large amounts of fuel if desired.
        - can send multiple captains to same sector... if you want...
    - if you're a captain, all you can do is see which sector each captain is in
    - can click into a sector to see the layout of planets/troops etc
    - can surrender vote--require unanimous
- Sector map - shows the 3-D layout of celestial objects + ships in play. If it's the sector you are "in", then you can do your main orders-issuing here
    - Resource allocation (ship buying) - if you have just been assigned to a system, then your resource allocation will be available. When you have available resources to spend in system, you must first do so before you can do anything else. Resource arrival in system is instant, but random location.
    - by default all objects are drawn much bigger than they actually are. Can toggle "to scale" to see actual size of planets and such
    - click on units to select. selected units display their passive optics range as translucent sphere and their movement range as different color translucent sphere
    - selected units display weapons/ammo status on sidebar
    - current orders list is also in sidebar

### 'finished' Game view

Win condition: Homeworld of Homesector is captured according to standard rules for capturing a planet. (or enemy team surrender)
