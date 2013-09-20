Objective: Create an auto playing 5x5 card bejeweled game.

Game Screen:
- There is 5x5 card on which the game is played. 
- Gems that are revealed on cards are of 4 types; A, B, C & D (wild card).
- Merged gems are of 3 types; A, B & C.
- There will be 2 buttons: one 'Start' and another 'Stop'.

Game Rules:
- Once 3 or more similar gems are adjacent to each other, a match is automatically made.
- Gem D can be combined with other similar gems of any type to make a match.
- A match can only be made horizontally or vertically.
- Diagonal match cannot be made.
- Gems are removed from the cells, once a match is made.
- The number of gems removed from cells range from 3-5.
- Collapsing only occurs after a match is made.
- The gap created are the match is filled with gems from the above cells.
- The upper empty cells are filled with randomly generated new gems.

Game Play:
- Clicking 'Start' button will trigger the autoplaying of the game.
- Every new step (match/swap/collapse action) should have 0.5 seconds delay between them.
- Clicking 'Stop' button will stop the game.
- There is no time limit for autoplaying.
- Game can also stop when no more matches is possible on the card.
- Upon stop the user can replace any gem on the card with wild gem D by clicking on it.
- This replacement is restricted to 3 per game stop.
- Pressing 'Start' should continue the autoplay again.
- Also, when no match is possible user can replace the gems and continue again by clicking on 'Start'.
- So, in a way there is no desirable end to the game.
- As long as there are possible matches the game should continue.
