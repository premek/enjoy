return {
  objects = { -- we need to use the array to keep the draw order
    {name="basement", x=0, y=0, noquads=true},
    --{name="neighbour", x=0, y=5},
    {name="me", x=5, y=20, controlled=true}
  },
  events = {
    {x=5, knot='basement_intro'},
    {x=30, knot='trash_cans'},
    {x=80, knot='letter_boxes'},

    --{x=50, knot='first_meeting'},
    --{x=150, knot='second_meeting'}
  },
  left = "0-0-start",
  right = "0-2-b",
}
