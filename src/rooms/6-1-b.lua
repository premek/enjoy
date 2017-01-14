return {
  objects = {
    {name="basement", x=0, y=0, noquads=true},
    {name="neighbour", x=25, y=6},
    {name="me", x=1, y=20, controlled=true}
  },
  events = {
    {x=10, knot='first_meeting1'},
    {x=55, knot='first_meeting2'},
  },
  right = function(story, rooms) return story.state.visitCountAtPathString('enjoy') == 0 and rooms['99-2-b'] or rooms["6-2-b"] end,
}
