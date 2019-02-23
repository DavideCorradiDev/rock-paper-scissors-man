GENERAL INFORMATION

Game created for the Ludum Dare 35 Compo (theme: "Shapeshift") during 48 hours.
Tools used:

- Programming: Lua and Love2D.

- Graphics: Gimp
.
- Sounds: BFXR.

- Music: Bosca Ceoil.




EXECUTABLES

.love file: https://www.dropbox.com/s/5rqc0sma25a31fj/rpsman.love?dl=0

windows .exe: https://www.dropbox.com/s/ufcf3wz06u0tk1n/rpsman-win.zip?dl=0

On Windows, you can run the .exe file even without having Love2D installed.
If you have the Love2D launcher installed, you can run the game with the .love file.
On Linux, you can call the Love2D launcher from the source code root:
```
cd /path/to/repo/root
love .
```

For information on how to install Love2D, refer to the Love2D website.




THE STORY SO FAR...

The cruel RED ALIENS have stolen all dumplings from planet Earth... But there is hope!!!

ROCK-PAPER-SCISSORS MAN, the most fearless super hero ever known, is pursuing the nefarious aliens to bring all the precious dumplings back to Earth!!!

With his amazing SHAPESHIFTING power, he is capable of changing his body to overcome even the deadliest of enemies.




CONTROLS

The game supports both keyboard and gamepad control.

Keyboard:

-  W,A,S,D: move.

- I: shapeshift to human form.

- J: shapeshift to rock form.

- K: shapeshift to paper form.

- L: shapeshift to scissors form.

- Arrows: navigate menus.

- Enter: select menu entries.

- Esc: pause game.


Gamepad:

- Left stick: move.

- Y: shapeshift to human form.

- X: shapeshift to rock form.

- A: shapeshift to paper form.

- L: shapeshift to scissors form.

- Left stick: navigate menus.

- A: select menu entries.

- Start: pause game.




HOW TO PLAY

Aliens come in four forms: rock, paper, scissors, and bombs.
When you collide with a rock, paper or scissors enemy, three scenarios may happen:

- If rock-paper-scissors man has the shape that beats the shape of the alien, the alien is destroyed.

- If the alien has the shape that beats the shape of rock-paper-scissors man, the poor super hero is destroyed.

- If both have the same shape, both suffer a tragic destiny.
Bombs are special in that both the bomb and rock-paper-scissors man will be destroyed in case of a collision.

Some enemies are equipped with guns and will fire at you. Bullets behave as bombs, in that they will always kill you no matter your shape.
When you destroy an enemy you get points, when an enemy destroys you, you lose a life. When lives run out the game is over!

Scattered through space you will find dumplings and powerups. You can grab them only if you are in HUMAN form, since, well, you need arms to grab stuff! There are three types of power ups:

- Dumplings: they give you points, normally more than killing enemies.

- Invincibility: if you grab this, you will be invulnerable and destroy anything you touch for a short period of time. You will still need to be human to grab powerups!

- Shield: the shield will save you from death once!

- Life: get a life!


There are 2 levels in the game, I wished I could have put more but I found out that designing interesting level took quite some time, so I didn't manage to do more in the 48 hours time limit.
