# Patch Notes

## ✨ **21/09/2020**
### 🆕 News
+ Players Scoreboard : sorted by players scores
+ Kill Notification
+ Players names : bots have now a name (used for kill notification and scoreboard)
+ Ships hints icons : new icons which are choose from the ship type
+ New ships : 
    + **Tyker**, an orange bomber ship armed with 2 missiles and 1 blaster
    + **Larysm**, a green medium ship armed with 2 blasters (W.I.P.)
+ Slow motion : `G` key to toggle it (reduce time to 35%)

### 🔧 Fixes
+ All velocities reset on player spawn
+ Angle reset on player spawn : should fix spin on respawn
+ Kill counter has been fixed (claimed bool disallow kill counting)
+ Missile hit function now invoke Bullet hit function instead of just destroying : should allow kill count
+ Rework GameObjects reset (on `R` key) : should prevent some IDs issues (GO IDs were more and more greater on reload)
+ Screen dimensions are greater now : **1280x820px**
+ Respawn positions are now randomized (instead of 0,0)
+ Target reset on AI spawn

### 📃 Notes
+ Kills count is now done in `Ship.targetdead` instead of `Bullet.hit`, even if `Bullet.hit` calls `Ship.targetdead`
+ Map dimensions (actually stars background dimensions) are stocked in globals `MapW` and `MapH`

## ✨ **22/09/2020**
## 🆕 News
+ Players Head-UI :
    + Name
    + Health bar

## 🔧 Fixes
+ **Steylky**'s health down from **20** to **16**
+ **Keytehr**'s weapons cooldown have been up to `0.125s` instead of `0.1s`
+ **Larysm** :
    + Icon has been changed to `icons/arrow.png` instead of `icons/bomb.png`
    + Weapons cooldown have been reduced from `0.2s` to `0.15s`
+ Added `SCOREBOARD` title upside the scoreboard

## 👩‍💻 **05/11/2020**
## 🆕 News
+ **Particle Effect** system (circle of blinking colors), used as explosions effects
+ **Particle Effect** on bullet hit and destroy
+ Set of 3-6 (random) **particles** on Ships deaths
+ **Turrets**: act as ships but cannot move (not controlable)
    + **K3**: an orange turret which fires a missile each second
    + **DC-A**: a green turret armed with 2 blasters with a medium fire rate
+ Add **TODO.md** file for listing things to do
+ New **Font**: SMB2.ttf (Super Mario Bros 2-like font)
+ Add **No Target Mode** (cheats): press `N` key to not being targeted, but you can still take hits 

## 🔧 Fixes
+ **Missile Spread** intensity decreased (missiles are twice more accurate)
+ **Targets Indicator UI** is animated on target hit (scale up plus white color)
+ **Notifications** now support color and icon (used on kill and death notifications)

## 💼 **06/11/2020**

## 🆕 News
+ **Shake Effect** system: improve the camera system by adding a shake function
+ **Screen Shakes** on being hit, firing and player death
+ **Sounds**: 
    + new destroy sounds for turrets
    + implemented stereo sound placement (but don't know if it's works)
+ **Power-Ups**: new power-ups spawning in the map:
    + **Repair**: repair your ship:
        + If your ship has one or more broken weapon, it repairs the weapons and gives you +25%HP
        + Else gives you +50%HP
        + **AI**: Take the power-up when he is below 50%HP and has no target or one of his weapon is dead

## 🔧 **07/11/2020**

## 🆕 News
+ **Power-Ups** now appear on Target UI under a distance of 500 units, so you can localize them easier
+ **HUD** component which allows to add or remove target on screen 
+ **Wrench** icon: used by the Repair Power-Up on Target UI

## 🔧 Fixes
+ **Power-Ups** positioning is now fixed (can't be outside the map), actually all entities rely now on `random_map_position` function

## 🔧 **08/11/2020**

## 🆕 News
+ **Sounds**: add 3 sounds on Power-Up picking up
+ **Particles**: add particles on firing guns 

## 🔧 Fixes
+ Fix shake when you try to fire with weapons you don't have
+ Fix sound dynamic volume (based on distance with player and emitter)
+ Fix angle of targets on Target UI (more centered now)
+ Fix power-up drawing which didn't suit with his hitbox
+ Turrets don't respawn anymore