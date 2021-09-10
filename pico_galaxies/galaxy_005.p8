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
     rectfill(
      pxl.x-1,pxl.y-1,
      pxl.x+1,pxl.y+1,
      burn(c)
     )
     -- circfill(pxl.x,pxl.y,rnd(2),burn(c))
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
     -- pset(pxl.x,pxl.y,burn(c))
     line(pxl.x+1,pxl.y-1,pxl.x-1,pxl.y+1,burn(c))
     line(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))

   end
  end
 end

end

function ofst(a, x, y)
 --offset a point
 local b={a[1]+x, a[2]+y}
 return(b)
end

function vec_sub(p2,p1)
 local x = p2[1]-p1[1]
 local y = p2[2]-p1[2]
 return {x,y}
end

function norm_vec(v)
 local len = sqrt(v[1]^2 + v[2]^2)
 local normx = v[1] / len
 local normy = v[2] / len
 return {normx, normy}
end

-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
colors = {
 "0", "-15", "0", 0,
 "12", "-4", "12", "7",
 "-15"
}
pal(colors,1)
loop_l = 10

sq_rad = 40
sa = {-sq_rad,-sq_rad}
sb = {sq_rad,-sq_rad}
sc = {sq_rad,sq_rad}
sd = {-sq_rad,sq_rad}

loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

-- the actual drawing loop
::_::

 -- cls()


 local oa = sin(t()/10) * cos(t()/10)
 oa = oa  / 100 + 0.005
 oa = oa/2
 
 if oa == 0.0 and not oa_zero then
  loop_counter+=1
  oa_zero = true
  srand(seed)
 end

 if oa != 0.0 then
  oa_zero = false
 end
 
 
 -- gif recording
 if loop_counter == 2 and not loop_started then
  extcmd("rec") -- start recording
  loop_started = true
 end
 if loop_counter == 6 and not loop_ended then
  extcmd("video") -- save video
  loop_ended = true
 end

 --rotate all four points
 sa = rotate(oa,0,0,sa[1],sa[2])
 sb = rotate(oa,0,0,sb[1],sb[2])
 sc = rotate(oa,0,0,sc[1],sc[2])
 sd = rotate(oa,0,0,sd[1],sd[2])

 -- length of sides
 local l = vec_sub(sc,sa)
 local unit = norm_vec(l)
 local x_end = unit[1]*sq_rad*oa*200
 local y_end = unit[2]*sq_rad*oa*200
 local grid_size=5
 local max_grid=30
 while grid_size < max_grid do 
  local xadd = grid_size*unit[1]
  local yadd = grid_size*unit[2]
  pset(x_end,y_end,9) 
  pset(x_end+xadd,y_end+yadd,9)
  pset(x_end-xadd,y_end-yadd,9)

  pset(-x_end,y_end,9) 
  pset(-x_end+xadd,y_end+yadd,9)
  pset(-x_end-xadd,y_end-yadd,9)

  pset(x_end,-y_end,9) 
  pset(x_end+xadd,-y_end+yadd,9)
  pset(x_end-xadd,-y_end-yadd,9)

  pset(-x_end,-y_end,9) 
  pset(-x_end+xadd,-y_end+yadd,9)
  pset(-x_end-xadd,-y_end-yadd,9)

  grid_size+=grid_size
 end

 -- outer box
 line(sa[1], sa[2], sb[1], sb[2], 2) 
 line(sb[1], sb[2], sc[1], sc[2], 2) 
 line(sc[1], sc[2], sd[1], sd[2], 6) 
 line(sd[1], sd[2], sa[1], sa[2], 6)
 
 -- ?t(),8
 -- ?oa,8
 -- ?loop_counter,8
 dither(1)
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
