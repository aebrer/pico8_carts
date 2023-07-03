pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

-- this is a clock
-- it will be a large circle with r >> 128
-- only one hand that tracks the minutes+hours
-- the hand will be a line
-- numbers, and small dots on the 15min marks, and large dot on 30min
-- the camera poition ~centers on where the hand intersects the circle
-- inspiration: 

camera(0,0)
_set_fps(60)
pal({[0]=0,-8,8,9,10,11,12,-4,0,-8,8,9,10,11,12,-4}, 1)
-- globals
circ_r = 128
cam_x = 0
cam_y = 0
pi = 3.142

r=rnd
s=r(-1)
srand(s)
cls()
unstable=true
::_:: 


if(stat(95)==0)s=s+1cls()

if(r()>0.9)srand(s)

for i=0,999 do
  x=r(512)-256
  y=r(512)-256
  c=r(15)
  pset(x,y,c)
end
for i=0,999 do
  x=r(512)
  y=r(512)
  c=pget(x,y)-1
  pset(x,y,c)
end

-- hour, 0-23
hour = stat(93)
hour %= 12
-- minute, 0-59
minute = stat(94)
time = hour * 60 + minute
-- time to angle
ta = time / 720
tx = cos(ta-0.25)
ty = sin(-ta+0.25)

-- draw the circle
--circ(0,0, circ_r, 7)

-- draw the numbers
for i=1,12 do
  a = i/12
  x = cos(a-0.25)*circ_r*0.9
  y = sin(-a+0.25)*circ_r*0.9
  print("\^w\^t"..i, x, y-4, 3)
end

-- draw the dots
-- every 15min
for i=0,719,15 do
  a = i/720
  x = cos(a-0.25)*circ_r
  y = sin(-a+0.25)*circ_r
  circfill(x,y, 1, 3)
end
-- every hour
for i=0,11 do
  a = i/12
  x = cos(a-0.25)*circ_r
  y = sin(-a+0.25)*circ_r
  circfill(x,y, 2, 3)
end


-- draw the hand
line(0,0, tx*circ_r*0.335, ty*circ_r*0.335, 10)
circ(tx*circ_r*0.4, ty*circ_r*0.4, 8, 10)
-- day of the month
day = stat(92)
print(day, tx*circ_r*0.4-2, ty*circ_r*0.4-2, 3)
line(tx*circ_r*0.465,ty*circ_r*0.465, tx*circ_r*2, ty*2*circ_r, 10)



-- set camera position
camera(tx*circ_r*0.8 -64, ty*circ_r*0.8 -64)

flip()
if(unstable)cls()
unstable=false

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
