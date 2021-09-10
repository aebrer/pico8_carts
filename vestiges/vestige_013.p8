pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions
function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

function rnd_pixel()
 local px_x = (
  flr(rnd(128)) + 1
 ) - 64
 local px_y = (
  flr(rnd(128)) + 1
 ) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end


-- rotation function
-- og credit to @dec_hl on twitter
-- c := center for rotation
-- p := point to rotate
-- a := angle
function rotate(a,cx,cy,px,py)
 local x = px - cx
 local y = py - cy

 local xr = x*cos(a) - y*sin(a)
 local yr = y*cos(a) + x*sin(a)

 return {xr+cx, yr+cy}
end


function isoutside(r,x,y)
 local dist = x*x + y*y
 if dist <= r*r then
  return true
 else
  return false
 end
end


function burn(c)
 local new_c = max(abs(c-1),0)
 return new_c
end

function rnd_sign()
 local coin_toss = rnd(1)
 local factor = 0.0
 if coin_toss >= 0.5 then
  factor = -1
 else
  factor = 1
 end
 return(factor)
end

function dither(loops)

 for i=loops,1,-1 do 
  local fudge_x = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  local fudge_y = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  --skip some nunber (12) pixels
  for x=128+fudge_x,0,-12 do
   for y=128+fudge_y,0,-12 do
    local pxl = rnd_pixel()
     c=pget(pxl.x,pxl.y)
     if c == 8 then
      pset(pxl.x,pxl.y,burn(c))
     else
      rectfill(
       pxl.x-1,pxl.y-1,
       pxl.x+1,pxl.y+1,
       burn(c)
      )
      circfill(pxl.x,pxl.y,rnd(2),burn(c))
     end
   end
  end
 end

 for i=loops,1,-1 do 
  local fudge_x = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  local fudge_y = (
   (
    flr(rnd(4)) + 1
   ) * rnd_sign()
  )
  --skip some nunber (12) pixels
  for x=128+fudge_x,0,-12 do
   for y=128+fudge_y,0,-12 do
    local pxl = rnd_pixel()
    c=pget(pxl.x,pxl.y)
    if c == 8 then
     pset(pxl.x,pxl.y,burn(c))
    else
     -- pset(pxl.x,pxl.y,burn(c))
     line(pxl.x+1,pxl.y-1,pxl.x-1,pxl.y+1,burn(c))
     line(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
    end
   end
  end
 end

end

function drw_hex(x,y,rad,a,c)

 local points = {}
 for i=360,0,-60 do
  local tpx = cos(i/360.0) * rad
  local tpy = sin(i/360.0) * rad
  add(points, {flr(tpx),flr(tpy)})
 end
 local ta=points[1]
 local tb=points[2]
 local tc=points[3]
 local td=points[4]
 local te=points[5]
 local tf=points[6]
 ta[1] += x
 ta[2] += y
 tb[1] += x
 tb[2] += y 
 tc[1] += x
 tc[2] += y
 td[1] += x
 td[2] += y
 te[1] += x
 te[2] += y
 tf[1] += x
 tf[2] += y

 --rotate all four points
 ta = rotate(a,x,y,ta[1],ta[2])
 tb = rotate(a,x,y,tb[1],tb[2])
 tc = rotate(a,x,y,tc[1],tc[2])
 td = rotate(a,x,y,td[1],td[2])
 te = rotate(a,x,y,te[1],te[2])
 tf = rotate(a,x,y,tf[1],tf[2])

 line(ta[1], ta[2], tb[1], tb[2], c) 
 line(tb[1], tb[2], tc[1], tc[2], c) 
 line(tc[1], tc[2], td[1], td[2], c) 
 line(td[1], td[2], te[1], te[2], c) 
 line(te[1], te[2], tf[1], tf[2], c) 
 line(tf[1], tf[2], ta[1], ta[2], c) 
 
end

-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 0, -16, 0, 0,
 0, 0, 7, 5,
 6
}
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false


-- the actual drawing loop
::_::

 -- cls()

 --outer angle for overall rotation
 local oa = t()%(loop_l/2)/(loop_l/2)
 
 drw_hex(0,0,25,-oa,9)
 drw_hex(0,0,55,oa,9)

 if oa <= 0.1 and not oa_zero then
  loop_counter+=1
  oa_zero = true
  srand(seed)
 end

 if oa > 0.1 then
  oa_zero = false
 end  

 line(rnd(64)*rnd_sign(),rnd(64)*rnd_sign(),0,0,rnd_choice(colors))

 --  -- gif recording
 -- if loop_counter == 2 and not loop_started then
 --  extcmd("rec") -- start recording
 --  loop_started = true
 -- end
 -- if loop_counter == 4 and not loop_ended then
 --  extcmd("video") -- save video
 --  loop_ended = true
 -- end

 dither(4)
 ?"band_freq",28,-64,7
 ?t()+rnd(100),40,-58,7
 ?oa+rnd(10),40,-52,7
 ?loop_counter*rnd(),40,-46,7
 
 ?"syncronicity_state",-63,58,7
 ?loop_counter*oa+0.1219,40,58,7 
 
 ?"power",-63,-64,7
 ?3.492+rnd(0.05),-63,-58,7 

 pal(colors,1)
 flip()

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
