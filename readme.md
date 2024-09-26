# Meta Leveling

Welcome to the release candidate of Meta Leveling, a Noita mod that introduces RPG-inspired progression and rewards. Level up, gain meta rewards, and customize your experience!

### Installation

- Press the [Download](https://github.com/lamia-zamia/meta_leveling/archive/refs/heads/master.zip) button
- Extract the contents into your Noita `mods` folder.
- Rename the folder from `meta_leveling-master` to `meta_leveling`.

Alternatively, subscribe to the mod on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3323230586)

### Features

- Experience System: Earn experience by killing enemies, solving puzzles, or doing cool stuff throughout your run.
- Rewards System:
  - Collect RPG-like rewards with multiple tiers and rarities that unlock based on your progression.
  - Reward Variety: Rewards can include upgrades to the character, wands, resources, spells, or temporary buffs.
  - Tiered Progression: As you collect rewards, you unlock higher tiers of more powerful rewards.
- Meta Progression:
  - Gain meta points through activities like speedrunning, streaking, or accomplishing challenging feats.
  - Persistent Upgrades: Start future runs with permanent buffs such as additional health, increased experience multipliers, longer buff durations, and more.
- Scalable Difficulty: This mod fits well with others that increase the game's difficulty, add new enemies, or introduce additional challenges.

### Compatibility

Meta Leveling is compatible with any mod that doesn't replace base game files (as it shouldn't). It works seamlessly with mods that add new enemies, bosses, or generally increase the game's difficulty, creating a balanced and fun experience for enhanced gameplay.

### For Modders
Meta Leveling is designed with customization in mind. Modders can easily add their own rewards, meta progress systems, and stats to the game.
<details><summary>How to add rewards</summary>

- Append your rewards to the following file: 
[mods/meta_leveling/files/for_modders/rewards_append.lua](files/for_modders/rewards_append.lua)
- For more details on the reward structure, refer to: [mods/meta_leveling/files/scripts/classes/private/rewards.lua](files/scripts/classes/private/rewards.lua)
- Example rewards can be found [here](files/scripts/rewards)

</details><details>  <summary>How to add meta progress</summary>

- Append your meta progress to this file:
  [mods/meta_leveling/files/for_modders/progress_appends.lua](files/for_modders/progress_appends.lua)
- Learn more about the progress structure [here](files/scripts/classes/private/meta.lua)
- Example meta progress can be seen [here](files/scripts/progress/progress_default.lua)
</details>
<details>
  <summary>How to add stats entries</summary>

- Append your stats entries to this file:
  [mods/meta_leveling/files/for_modders/stats_append.lua](files/for_modders/stats_append.lua)
- Detailed stats structure can be found [here](files/scripts/classes/private/stats.lua)
- Example stats entries are available [here](files/scripts/stats/stats_list.lua)
</details>

### Credits
Special thanks to the following people for their invaluable contributions:
- Libraries & Coding Knowledge:
  
  Nathan, Horscht, Dexter, MK VIII QF 2-puntaa NAVAL-ASE
- Beta Testing & Feedback:

  Nathan, Sharpy796, Sp4m, Snek Gregory

- Spriting advice and thumbnail:

  Copi