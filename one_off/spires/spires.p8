pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

-- todo:
-- 1. all columns filled in, so bias the selection of columns to favor unseen ones
-- 2. randomize the number of columns upon generation

_set_fps(60)
cls()
pal({[0]=0,-8,8,9,10,11,12,-4,0,-8,8,9,10,11,12,-4}, 1)


-- sugar
r = rnd
s = r(-1)  -- overflow bug to get random number
srand(s)

-- a store of randomness for the whole program that will be
-- independent of the seed resetting / entropy locking

rands = {}
for i=0,1024 do
 add(rands, r())
end

frc = 1

function fr()
 my_rand = rands[frc]
 frc += 1
 if(frc>#rands)frc=1
 return my_rand
end

function frint(min, max)
 return (min + fr()*(max-min))\1
end


-- global variables
line_tops = {}  -- stores the x position of the top of the line
line_bots = {}  -- stores the x position of the bottom of the line
line_top_lims = {}  -- store the max and min x position of the top of the line
line_bot_lims = {}  -- store the max and min x position of the bottom of the line

-- track the sliding rectangles
rects = {}
-- example of a rect 
-- {i, y11,y12, y21,y22, color, slide_rate}

-- first we need a function that will interpolate between two points
-- this function will be used to get the x values for the rectangles
-- based on the y value, and the imputed x values of the vertical lines
function interpolate(x1, y1, x2, y2, y)
 -- y = mx + b
 -- m = (y2-y1)/(x2-x1)
 -- b = y1 - m*x1
 -- x = (y-b)/m
 m = (y2-y1)/(x2-x1)
 b = y1 - m*x1
 return (y-b)/m
end

-- need a new function to draw a rectangle given four corners
function custom_rect(x11,y11,x12,y12,x21,y21,x22,y22, color)

 -- left side: x11,x22
 -- right side: x12,x21
 -- check that the left side and right side are within the limits
 col_width = 128/#line_tops + 2  -- fudge factor
 if (abs(x11-x22) > col_width) return
 if (abs(x12-x21) > col_width) return

 line(x11,y11,x12,y12, color)
 line(x12,y12,x22,y22, color)
 line(x22,y22,x21,y21, color)
 line(x21,y21,x11,y11, color)
end

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
 
 -- entropy locking
 if(r()>0.75) srand(s)

 -- dithering
 for i=0,800 do 
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
   s+=1

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


 function draw_it_all()
  -- params for a new rectangle
  --i = r(#line_tops+2)\1
  i = frint(1, #line_tops)
  y11 = 0
  y12 = r(10) + 2
  y21 = r(2)-2
  y22 = r(10) + 2
  color = fc%16
  slide_rate = r(1)+0.5
  add(rects, {i, y11,y12, y21,y22, color, slide_rate})
  -- add(rects, {3, 0, r(10)+1, r(2)-2+1, r(12)-2+1, 8, 1})
 end
 
 if #rects > 0 then
  -- draw the rectangles
  for i=1,#rects do
   -- get the x values for the top and bottom of the rectangle
   -- example of a rect 
   -- {i, y11,y12, y21,y22, color, slide_rate}
   if line_bots[rects[i][1]] and line_bots[rects[i][1]+1] then
    x11 = interpolate(line_tops[rects[i][1]], 0, line_bots[rects[i][1]], 127, rects[i][2])
    x12 = interpolate(line_tops[rects[i][1]], 0, line_bots[rects[i][1]], 127, rects[i][3])
    x21 = interpolate(line_tops[min(rects[i][1]+1, #line_tops)], 0, line_bots[min(rects[i][1]+1, #line_tops)], 127, rects[i][4])
    x22 = interpolate(line_tops[min(rects[i][1]+1, #line_tops)], 0, line_bots[min(rects[i][1]+1, #line_tops)], 127, rects[i][5])
   end
   -- draw the rectangle

   if x11 then
    custom_rect(
     x11,rects[i][2],
     x12,rects[i][3],
     x21,rects[i][4], 
     x22,rects[i][5],
     fc%16
     --rects[i][6]
    )
   end
   -- move the rectangle down
   rects[i][2] += rects[i][7]
   rects[i][3] += rects[i][7]
   rects[i][4] += rects[i][7]
   rects[i][5] += rects[i][7]
  end
end


 -- new loop for drawing the rectangles
 if(r()>0.6) then
  draw_it_all()
 elseif(r()>0.8) then
  draw_it_all()
 end

 -- prevent memory leak related slowdown
 if #rects > 200 then
  deli(rects, 1)
  
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
