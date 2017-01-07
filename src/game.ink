->END // this END shouldnt be needed

=== intro
Hello.                          Press space to continue.
This is me.
* Hi -> my_house
* Hello -> my_house
* [Select a number of your choice] -> my_house

=== my_house
OK, this is the house where I live.
My apartment is behind the door on the left.
Every morning I go through this hallway out of the house on my way to my work.
That's what I will do now, right?

* [Go to the office] -> walk
* [Go back to sleep]
  No no, I need to go to work.
  ->walk

===walk
Use arrow keys to walk, ok?
->END

=== door1
Mr. Neighbourman lives here right next to me.
I have never seen him.
->END

=== door2
Mr. Nobody lives in this apartment.
I have seen him only once.
But he is inside all the time cooking something good smelling.
->END



=== basement_intro
This is the ground floor of our house.
Nothing interesting here.
->END
=== trash_cans
Trash can. ->END
=== letter_boxes
Letter boxes. ->END


=== basement_return
Ok, back from the office. I will just get back to my apartment.


=== day1

(Monday May 9th, 2016)

It was a day like any other.
I left my apartment in the morning and went to the office.

-> END


=== first_meeting ===
This must be the guy living in the apartment next to yours.
"Morning", he said.
* [...]He looks weird
  I left without talking to him.
* "Morning"[], I replied.
  "Enjoy your day," he said to me,
  "And enjoy your life!" he shouted at me as I was leaving

=== second_meeting ===
Can I ask you a question?
* [Try to avoid talking to him]"Sorry I'm in a hurry"
* [Yes]Sure
  Do you know what is going on here?
* * Like in this house?
* * No
    You know, I'm in in a movie.
    And it doesn't look good for me.
    Can you help me?
* * * Of course
* * * How?
      Mom, dad, brother, I'm so sorry.
      You know, I'd like to be with my family.
      With my mom, my dad and brother.
      Right now.
