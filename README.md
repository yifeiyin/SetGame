#  Set (A Real-time Card Game)

## Game Rules

Read [Wikipedia](https://en.wikipedia.org/wiki/Set_(game)).
Tap the timer on the bottom left to show "hints".

## Notes

This is my first ever "usable" app written! By "usable" I mean something I dare to share with my friends, 
even someone who does not do programming. The one with full UI and stuff. Althrough the game is not 
very fun to play, but it is not the worth in the world either, and it is exactly the natural of the game. Yeah, 
I will try to impliment something more fun next time.

In this implementation, rules of MVC are followed at all times. There are barely nested functions. Variables 
and functions are grouped to make things more clear. The code should be, at least, somewhat readable.

Total time consumed: 14.0 hours. Over five days: 2018 May 8 - 12

Based on Stanford CS193p 2017 fall Assignment II as included in Supporting files.

## Improvements to Make

The following points are just ideas. I am not likely to do since I won't learn much new from them.

* Add a model for PauseMenuViewController
* Adjust font size to comfort different device sizes
* Add a scoring system
* Add a start menu and game instructions
* Add the ability to save game


## Garbage: Program planning area garbage
The following content are notes made during planning time.
```
### Game Rules
Four features: 
number (1,2,3)
symbol (diamond, squiggle, oval)
shading (solid, striped, or open)
color (red, green, or purple)
TOTAL 81 CARDS

A set is:
***three different things and one common things**
*or* "two of ___ and one of ___ is not"


### UI Rules

have space for >= 24 cards

start with 12 cards
select at most 3 cards
when another other than these three is selected, deselect all, select the new one

cycle through:
⏱ 1:23          time consumed
4 on table       numbers of sets on table

32 cards remaining   numbers of cards remaining
Got 4 sets           numbers of sets have got

```

