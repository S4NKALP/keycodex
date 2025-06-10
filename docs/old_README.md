---

these are the commands i am using recently:

moving is easy u just use hlkj

`$`: will always take you to the end of the line

`0`: will take you always to the start of the line

`^`: using caret will take you to the first not empty space or character in ur line

`f`: to jump to the character you want to reach towards in the line

`F`: (capital f) here u will be jumping backwords to the character u need.

`t`: is to go towards the letter u want to jump but the cursor is just before it

`T`: (you can think of it as till) works the same but backwards

`w, b`: to navigate between the words and symbols

`W, B`: to navigate between capital words

`e`: to navigate through end of the words

`ge`: to navigate through end of the words but backwords

`gE`: to skip and navigate between words in all caps.

`{}`: is to jump between paragraphs or between empty space blocks

`G`: is to jump to end of the line.

`gg`: is to go to the beginning of the file

`17G`: will take u to the line of 17, also :17 will do the same

`%`: if u are on the opening or closing parenthesis or bracket it will jump to the according closing bracket or parenthesis

`[(`: to jump to the opening parenthesis if you are in the middle of them

`ctrl + f`: will take u down to a full screen

`ctrl + b`: will take u up to a full screen

`ctrl + u`:, d will take u up and down resectively half a screen

`zt, zb, zz`: to move respecivally to top, bottom and half screen with moving the cursor

`ctrl + y`: and e is to scroll up and down without moving the cursor

`/`: to execute a search, and enter to go and hop into it

`:nohl`: is a command to undo a selection

`n and N`: to move through your searches

`(star\*)`: to execute a search on an exact word

`ctrl + i`:, o will jump u between jumplists

`d$ or D`: to delete from current cursor to end of the line

`dG`: to delete until the end of the file

`de`: to delete till the end of the word

`dd`: to delete all line

`u`: to undo for sure

`ce, c`: short for change is to delete and move to insert mode after deleting

`r,`: to replace a simple character

`yf(character)`: you will copy until character and then p or P to paste

`yy`: to copy the whole line

`Y or y$`: is same to copy until end of the line

`~`: to change case of a character

`gU`: to change to uppercase

`gu`: to change for lowercase

`diw, d`: for delete, i for inside and w for word, this will do the magic to delete the word entirely when the cursor is inside

`ciw`: is to change a word while the cursor is inside

`yip`: to copy the paragraph you are inside

`dip`: to delete the pragraph you are in

`di(`: to delete inside the parenthesis

`da(`: to delete outside the parenthesis which means including them

`:%s/word/newword/g`: change word to newword

`:%s/word/newword/gc`: to not prompt u for being sure or not

check this guy's cheatsheet for more:

`https://www.josean.com/posts/vim-essentials-cheatsheet`

---

### advanced stuff

`qa`: to start recording a couple of movements

`q`: to quit recording and make sure you are in visual mode

`@a`: to apply what you recorded on a

`vap`: to select outside a whole paragraph

`:%`: to start an operation on whole file

`:%norm!`: to start an operation on norm mode

`:'<,'>norm!`: @a is to start the operation of @a on the paragraph selected

`ctrl + w` and how u can use s for split and closing with o

`Marks` to add the m + a and m + b and then switch to marks with ' + a or ' + b

`ctrl + f` and `ctrl + u` is to move cursor to last character of file or first line as well.

`ctrl + n` and `ctrl + p` are for navigation

`ctrl + d` and `ctrl + u` will jump certain number of phrases and make navigation easier for u

`ctrl + a` to increment number and `ctrl + x` to decrement it

`ctrl + shift + v` to paste to terminal from clipboard

`ys-command` to surround certain word with whatever u write next for example ""

`ds"` to delete surrounding double quote or if u replace " with `t` u will delete surrounding tag

`cs"` to change surrounding character with whatever u want, in this case with quotes

`"ay + command` will give u possibility to yank whatever u gave to register a
