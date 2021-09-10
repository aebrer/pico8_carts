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
 for x=64,-64,-2 do
  for y=64,-64,-2 do
   if x%2 == 0 or y%2 == 0 then
    pset(x+1,y+1,2)
   else
    if t()*1000 % 2 then
     local c = pget(x,y)
     pset(x+1,y+1,burn(c))
    else
     pset(x+1,y+1,0)
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
 0, -13, 7, -13, 3, -5, -6, -9, 11, -6, 0
}

-- cls(colors[#colors])
pal(colors,1)

loop_l = 8
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

dither_rad = 1.0
dither_amt = 200
inner_rad = 20
line_width = 50
music(0)

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

 local p1 = rotate(oa,0,0,line_x1,line_y)
 local p2 = rotate(oa,0,0,line_x2,-line_y)
 local p3 = rotate(oa,0,0,p1[1],p1[2])
 local p4 = rotate(oa,0,0,p2[1],p2[2])
 
 ovalfill(p1[1]*0.8,p1[2]*0.8,p2[1]*0.8,p2[2]*0.8, 11)
 dither(0,0,dither_amt,dither_rad)
 rect(p1[1], p1[2], p2[1], p2[2], 8)
 rect(p2[1], p2[2], p3[1], p3[2], 8)
 rect(p2[1], p2[2], p4[1], p4[2], 8)
 rect(p4[1], p4[2], p1[1], p1[2], 8)
 dotter()



 pal(colors,1)
 flip()

 -- -- gif recording
 -- if loop_counter == 2 and not loop_started then
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
__sfx__
012000000705000000000000000007050000000000000000070500000000000000000705000000000000000007050000000000000000070500000000000000000705000000000000000007050000000000000000
c71000200c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c710
011000200c745187220c7220c7150c742187220c7250c7110c745187220c7220c7150c742187220c7250c7110c745187220c7220c7150c742187220c7250c7110c745187220c7220c7150c742187220c7250c711
631000200c54115522245221551515542005000c525115110c545115210c5211151400542005000c525115110c54110522245220e5150c542005000c525105110c5450e5210c5211051400542005000c5250e511
011000200c54115522245221551515542005000c525115110c545115210c5211151400542005000c525115110c54110522245220e5150c542005000c525105110c5450e5210c5211051400542005000c5250e511
011000200c74518722000000c7150c742000000c7250c7110c74518722000000c7150c742000000c7250c7110c74518722000000c7150c742000000c7250c7110c74518722000000c7150c742000000c7250c711
871000200c7400c7350c7200c7150c7400c7350c7250c7100c7450c7300c7200c7150c7410c7300c7210c7120c7450c7300c7200c7120c7420c7300c7200c7100c7400c7300c7200c7100c7400c7300c7200c710
2720002016052180421b0321d03222022180321f04222052160521305213052160521305213042130321302227052290521f052180521605216052180521b0521f05224052270522705224052240422403224022
2f2000202705224042220321d0321b0221d03218042180521f052130521d052160521b0521b042130321302213052290521f052180521605216052180521b0521f05224052270522705224052240422403224022
__music__
00 00424344
00 00014344
01 00020144
00 01020003
00 06040005
00 00050107
02 01050008
00 00070805

