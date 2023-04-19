pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

_set_fps(60)
cls()

-- sugar
r = rnd
s = r(-1)  -- overflow bug to get random number
srand(s)


-- global variables
line_tops = {}  -- stores the x position of the top of the line
line_bots = {}  -- stores the x position of the bottom of the line
line_top_lims = {}  -- store the max and min x position of the top of the line
line_bot_lims = {}  -- store the max and min x position of the bottom of the line

-- initialize line_tops and line_bots
for i=0,127,12 do
 if (i==0) then
  add(line_tops, i+r(2))
  add(line_bots, i+r(2))
 elseif (i==120) then
  add(line_tops, i+r(2)-2)
  add(line_bots, i+r(2)-2)
 else
  add(line_tops, i+r(4)-2)
  add(line_bots, i+r(4)-2)
 end
end

-- populate line_top_lims and line_bot_lims
for top in all(line_tops) do
 add(line_top_lims, {top-2, top+2})
end
for bot in all(line_bots) do
 add(line_bot_lims, {bot-2, bot+2})
end

fc = 0

::_:: -- draw loop start

 -- dithering
 for i=0,1000 do 
  x = r(128)
  y = r(128)
  pset(x, y, 0)
 end

 -- draw the lines
 for i=1,#line_tops do
  -- draw a line from line_tops[i] to line_bots[i]
  -- y should go from 0 to 127
  -- x should go from line_tops[i] to line_bots[i]
  line(line_tops[i], 0, line_bots[i], 127, 7)

  -- we want to have the line wiggle a bit, but very slowly
  -- so we'll add a random number to the line_tops and line_bots
  -- but we want to make sure that the line doesn't go off the screen
  -- also the lines should remain within the lims defined above

  -- only wiggle once every ? frames
  if (fc%120 == 0) then
   top_fac = r(4)-2
   bot_fac = r(4)-2
   
   -- check if the line is within the limits
   while not (
    line_tops[i]+top_fac >= line_top_lims[i][1] and 
    line_tops[i]+top_fac <= line_top_lims[i][2] and
    line_tops[i]+top_fac >= 0 and
    line_tops[i]+top_fac <= 127
   ) do
    top_fac = r(4)-2
   end
   line_tops[i] += top_fac

   while not (
    line_bots[i]+bot_fac >= line_bot_lims[i][1] and
    line_bots[i]+bot_fac <= line_bot_lims[i][2] and
    line_bots[i]+bot_fac >= 0 and
    line_bots[i]+bot_fac <= 127
   ) do
    bot_fac = r(4)-2
   end
   line_bots[i] += bot_fac
   i+=1
  end
 end



 flip()
 fc+=1
goto _ -- draw loop end




__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
