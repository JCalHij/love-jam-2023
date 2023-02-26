# Lessons Learned

## Game Jam

The game jam was fun. It was great that I had around a week to create the game. I spent approximately between 2 to 4 hours a day working on it, so the whole game took around 20 hours to make. It felt enough. If the game jam had been shorter I might have dropped out. If I want to participate in another game jam in the future, I will check first that I have at least one week to create the game.

I was too shy to post anything on the jam's discord server, but I saw really cool stuff done by other participants. I cannot wait to see their creations and learn from them.


## Coding

Coding in `Lua`, as always, felt pretty good. However, I feel the limitations of type hinting, to which I really rely on. Even though I will still code in `Lua` and with `Love2D`, I think I need to find something where I feel really comfortable coding. `Python` might be a good option (`pygame`), as well as `C++` (`SDL`). I might need to think more about it.

I also felt confident because I had a simple core framework I could rely on. In the future, building reusable code might be the best path to simplify my life when coding other games.

Regarding the code architecture, I feel it was well organized. It felt correct to have some things be triggered directly by game entities (like `take_damage`) and have other things be triggered by events (`PlayerWonEvent`). However, I think there is a need for a `GameObject` base class for everything that belongs to a room. Something that has as interface `update(dt)`, `render()`, `destroy()`, and as attributes position, alive, ...


## Planning

As far as I have seen, `Masterplan` seems like a good choice in the future to keep planning small games and tasks. I like that you can simply commit your plan state to your VCS and keep track of changes. All in all, good tool.

I think I also did a good job at the beginning when writing down the tasks to be done. They were clear and the order was almost correct. I only needed to make a couple changes to them.


## Content

Drawing was fun, and I had specially a good time when drawing the magic shield hit effect. Everything was done under `Aseprite`.

I had zero knowledge about sound creation. I checked out a tutorial of `FamiStudio` and did a simple song. I find it a nice tool, simple, but also limiting in the amount of sounds it can make (as it targets the NES). However, going full `LMMS` or something different might be too much for me.

Sound effects were fun as well. I just started making random noises in front of the microphone and picked up some of them. However, they do not really align with `FamiStudio`'s sound, so I might need to come up with something else. Maybe use `sfxia` or a similar tool to create cool sound effects?

Game balancing was hard. I had to come up with random numbers for HP, attack speed and move speed for all units, as well as the cost of the knight's upgrades, their deltas and how much points did the player make on each kill. The game felt good to me after an hour or so of fiddling around, so I left it like that.


## Building

It was a real pain to setup the whole build for windows. Even though I did it at the end and almost manually, it felt like a real chore. I need to come up with a "simple" way of generating builds, for example with a python script or something. That way I could simply provide a list of files to include in the build, and then the rest would just run smoothly.

