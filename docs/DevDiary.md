# Developer Diary


## Day 0

I set up my repository for the game jam, copy my core libraries and the basic `main.lua` and `conf.lua` files, ant test that everything runs without issues.

I have been thinking about what type of game I want to do in this short period of time. With the theme in place, I wanted to come up with some ideas, and I started writing down what it came to my mind when thinking about `connection`:

- Physical connection
  - Connecting cables
  - Connecting energy
    - Radio waves
    - Internet / Computers
    - Electricity
  - Connect points
  - Connect cities
    - Transport
  - Connect worlds
  - Connect chains
- Spiritual connection
  - Connect with nature
  - Connect with people
  - Connect with someone
  - Connect ideas
    - Detective game

Out of these, the one that first I wanted to do was some kind of `Tentacle Wars` kind of game, where you have a mainframe computer and want to hack the enemy mainframe, and there are some computers in between you have to hack. The enemy does not stay still, and he can do the same thing, hacking other computers to destroy you.

This first idea was discarded because of the complexity of building the enemy AI, which I haven't done yet, and seems to complex to do at my current level.

Then came the next idea. You are a knight of some sort that needs to protect a princess that is casting a magic spell to destroy all the undeads of the kingdom. The princess needs time to cast the spell, so you need to go around killing the zombies. You kill them by simply clicking them. When you kill them, you earn points. However, you can chain kills by draging the mouse from enemy to enemy, obtaining more points the bigger the chain. The enemies do not focus you, they go towards the princess from random directions of the screen. The princess has some magic shield that can withstand some amount of damage made from the zombies. When all zombies are dead, you can use your points earned and buy upgrades for the knight (move speed, attack speed, attack damage) or the princess (increase max shield, recover shield).

I think this should be a good starting point, and looks easy to prototype during the first weekend.

I will try to come up with a rough plan of what the game should look like (user story), and the steps to achieve it. I will be using `Masterplan` to keep track of what I need to do, as it is easier to manage than `Jira`.

The user story is written under [User Story](./UserStory.md) and the plan is set. Now all is left is to wait until the game jam begins to start coding!


## Day 1 - Saturday 18/02/2023

Even though I coded some of the basic features into the game, how it currently looks makes me feel like the game will not be fun.Maybe I need to put some time into drawing and adding effects, but I believe that features should be given priority. Let's see how it goes.


## Day 2 - Sunday 19/02/2023

I did some more basic features today morning. I expected the knockback of both player and enemies to be more complex, but I easily solved it with a new state for both. There is a lot of code that is copy-paste, but I will not worry about it. I just need to keep pushing forward and keep adding features into the game. As long as it works and is kind of fun, I will be happy.

Next comes some state management tasks, like player won and lost screens, along with enemy waves and shopping. Not sure how I will handle the second, but the first should be relatively easy, as we could simply add a new effect which takes care of drawing an image (YOU LOST or YOU WON, something like that) into the screen with increasing alpha over time. When it finishes, we could add some buttons to play again or exit.


## Day 3 - Monday 20/02/2023

I did very little. I created an effect that becomes the player lost screen, and used my existing imgui code to show two buttons on screen. However, the imgui code expects to work on the main canvas, not on a sub-canvas, and therefore the mouse does not work properly. I also added point counting for killing enemies and started working on the enemy wave system.


## Day 4 - Tuesday 21/03/2023