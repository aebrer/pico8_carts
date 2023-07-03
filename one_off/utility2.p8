pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

-- this is a clock
-- it will be a large circle with r >> 128
-- only one hand that tracks the minutes+hours
-- the hand will be a line
-- numbers, and small dots on the 15min marks, and large dot on 30min
-- the camera poition ~centers on where the hand intersects the circle


camera(0,0)
_set_fps(60)

function _init()

end

-- globals
circ_r = 128
cam_x = 0
cam_y = 0
pi = 3.142




::_:: 
cls()
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
  print("\^w\^t"..i, x, y-4, 7)
end

-- draw the dots
-- every 15min
for i=0,719,15 do
  a = i/720
  x = cos(a-0.25)*circ_r
  y = sin(-a+0.25)*circ_r
  circfill(x,y, 1, 7)
end
-- every hour
for i=0,11 do
  a = i/12
  x = cos(a-0.25)*circ_r
  y = sin(-a+0.25)*circ_r
  circfill(x,y, 2, 7)
end


-- draw the hand
line(0,0, tx*circ_r*0.335, ty*circ_r*0.335, 8)
circ(tx*circ_r*0.4, ty*circ_r*0.4, 8, 8)
-- day of the month
day = stat(92)
print(day, tx*circ_r*0.4-2, ty*circ_r*0.4-2, 7)
line(tx*circ_r*0.465,ty*circ_r*0.465, tx*circ_r*2, ty*2*circ_r, 8)



-- set camera position
camera(tx*circ_r*0.8 -64, ty*circ_r*0.8 -64)

flip()

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
