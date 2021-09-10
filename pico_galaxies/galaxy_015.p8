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
  flr(rnd(128))
 ) - 64
 local px_y = (
  flr(rnd(128))
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

function burn(c)
 local new_c = max(abs(c-1),1)
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

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  circ(x,y,1,burn(c))

  pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  local pt = rotate(oa,0,0,x,y)
  -- circfill(pt[1],pt[2],3,burn(c))
  pset(pt[1],pt[2],burn(c))


 end
end


function dotter()
 for x=63,-63,-3 do
  for y=63,-63,-3 do
   if x%3 == 0 or y%3 == 0 then
    pset(x+1,y+1,2)
   else
    if t()*1000 % 2 then
     local c = pget(x,y)
     pset(x,y,burn(c))
    else
     pset(x,y,0)
    end
   end
  end
 end
end


-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false

colors = {
 0, -15, 7, 1, -3, -4, -14, 14, 12, 2, 0
}

-- cls(colors[#colors])
pal(colors,1)

loop_l = 8
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

dither_rad = 1.0
dither_amt = 100
inner_rad = 20
line_width = 50


-- the actual drawing loop
::_::

 _set_fps(60)
 -- cls()

 --outer angle for overall rotation
 oa = (t())%(loop_l/2)/(loop_l/2)
 normal_a = (t())%(loop_l)/(loop_l)
 oa-=0.5
 oa = abs(oa)

 if normal_a <= 0.01 and not oa_zero then
  oa_zero = true
 end

 if normal_a > 0.01 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end  

 -- if oa <= 0.001 then
 --  srand(seed)
 -- end
 
 local line_direc = rnd_sign()
 local line_y = inner_rad
 local line_x1 = 0-line_width
 local line_x2 = line_width

 local p1 = rotate(normal_a,0,0,line_x1,line_y)
 local p2 = rotate(normal_a,0,0,line_x2,-line_y)
 local p3 = rotate(normal_a,0,0,p1[1],p1[2])
 local p4 = rotate(normal_a,0,0,p2[1],p2[2])
 
 
 dither(0,0,dither_amt,dither_rad)
 ovalfill(p1[1]*0.8,p1[2]*0.8,p2[1]*0.8,p2[2]*0.8, 11)
 line(p1[1], p1[2], p2[1], p2[2], 8)
 line(p3[1], p3[2], 8)
 line(p4[1], p4[2], 8)
 line(p1[1], p1[2], 8)
 dotter()



 pal(colors,1)
 flip()

 -- -- gif recording
 -- if loop_counter == 3 and not loop_started then
 --  extcmd("rec") -- start recording
 --  loop_started = true
 -- end
 -- if loop_counter == 4 and not loop_ended then
 --  extcmd("video") -- save video
 --  loop_ended = true
 -- end

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
