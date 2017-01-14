return {
  objects = {
    {name="hallway-open", x=0, y=0, noquads=true},
    {name="palm", x=50, y=10},
    {name="neighbour2", x=35, y=8, noquads=true},
    {name="me", x=10, y=17, controlled=true},
    {name="palm", x=80, y=25},

  },
  events = {
    {x=80, knot='second_meeting'},
  },
  intro = "day7",
  right = function(story) return story.state.visitCountAtPathString('enjoy') == 0 and '99-1-b' or "7-1-b" end,

}
