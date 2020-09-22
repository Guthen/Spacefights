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

## ✨ **22/09/20**
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