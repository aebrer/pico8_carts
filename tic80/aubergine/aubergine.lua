-- title:   aubligation
-- author:  aebrer
-- desc:    art to keep hackers away
-- site:    aebrer.xyz
-- license: cc0
-- version: NULL
-- script:  lua

cls()
-- pico8 compatibility functions
flr=math.floor
pget=pix
abs=math.abs
max=math.max
min=math.min
-- rect(x, y, width, height, color)
-- convert to rectfill(x1,y1,x2,y2,color)
function rectfill(x1,y1,x2,y2,c)
 rect(x1,y1,x2-x1,y2-y1,c)
end
circfill=circ
pset=pix

-- functions
function random_choice(t)
 return t[math.random(1,#t)]
end

-- rnd function
-- with no args return ramdom number 0-1
-- with one arg return random number 0-arg
function rnd(n)
 if n == nil then
  return math.random()
 else
  return math.random(n)
 end
end

function rnd_pixel()
 local px_x = (
  flr(math.random(240)) + 1
 )
 local px_y = (
  flr(math.random(240)) + 1
  )
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

 local xr = x*math.cos(a) - y*math.sin(a)
 local yr = y*math.cos(a) + x*math.sin(a)

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
 return random_choice({-1,1})
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
  for x=240+fudge_x,0,-12 do
   for y=136+fudge_y,0,-12 do
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
  for x=240+fudge_x,0,-12 do
   for y=136+fudge_y,0,-12 do
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

function drw_sqr(x,y,sl,a,c)
 local sa = {-sl+x,-sl+y}
 local sb = {sl+x,-sl+y}
 local sc = {sl+x,sl+y}
 local sd = {-sl+x,sl+y}
 --rotate all four points
 sa = rotate(a,x,y,sa[1],sa[2])
 sb = rotate(a,x,y,sb[1],sb[2])
 sc = rotate(a,x,y,sc[1],sc[2])
 sd = rotate(a,x,y,sd[1],sd[2])

 line(sa[1], sa[2], sb[1], sb[2], c) 
 line(sb[1], sb[2], sc[1], sc[2], c) 
 line(sc[1], sc[2], sd[1], sd[2], c) 
 line(sd[1], sd[2], sa[1], sa[2], c)
end

-- setting params
seed = math.random(0,999999)
math.randomseed(seed)
seed_rst_needed = false

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

function TIC()



 -- cls()
 -- todo: make multiple sets of squares on a grid
 local radius = 3.0
 local shrink = 0.3
 local square_rad = 15
 --outer angle for overall rotation
 local oa = time()*.001%(loop_l/2)/(loop_l/2)
 for ia=0.2,0.0,-0.1 do
  local pt=rotate(oa,0,0,radius,0)
  -- print(ia)
  local npt = rotate(ia,0,0,pt[1],pt[2])

  local xfac = 10+(240/2)
  local yfac = 8+(136/2)
  -- eggplant body
  drw_sqr(npt[1]-25+xfac,npt[2]-20+yfac,math.random(6),-oa*2,9)
  drw_sqr(-npt[1]-25+xfac,-npt[2]-20+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-24+xfac,npt[2]-18+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-24+xfac,-npt[2]-18+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-23+xfac,npt[2]-15+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-23+xfac,-npt[2]-15+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-21+xfac,npt[2]-12+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-21+xfac,-npt[2]-12+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-18+xfac,npt[2]-8+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-18+xfac,-npt[2]-8+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-15+xfac,npt[2]-4+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-15+xfac,-npt[2]-4+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]-18+xfac,npt[2]-4+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-18+xfac,-npt[2]-4+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-13+xfac,npt[2]+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-13+xfac,-npt[2]+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]-10+xfac,npt[2]+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-10+xfac,-npt[2]+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-8+xfac,npt[2]+3+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-8+xfac,-npt[2]+3+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]-4+xfac,npt[2]+3+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-4+xfac,-npt[2]+3+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]+xfac,npt[2]+3+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+xfac,-npt[2]+3+yfac,rnd(6),-oa*2,9)

  drw_sqr(npt[1]-3+xfac,npt[2]+7+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]-3+xfac,-npt[2]+7+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]+xfac,npt[2]+7+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+xfac,-npt[2]+7+yfac,rnd(6),-oa*2,9)
  drw_sqr(npt[1]+4+xfac,npt[2]+7+yfac,rnd(6),-oa*2,9)
  drw_sqr(-npt[1]+4+xfac,-npt[2]+7+yfac,rnd(6),-oa*2,9)

  -- leaf stem
  drw_sqr(npt[1]-28+xfac,npt[2]-25+yfac,rnd(3),-oa*2,5)
  drw_sqr(-npt[1]-28+xfac,-npt[2]-25+yfac,rnd(3),-oa*2,5)
  drw_sqr(npt[1]-23+xfac,npt[2]-25+yfac,rnd(3),-oa*2,5)
  drw_sqr(-npt[1]-23+xfac,-npt[2]-25+yfac,rnd(3),-oa*2,5)
  drw_sqr(npt[1]-31+xfac,npt[2]-22+yfac,rnd(3),-oa*2,5)
  drw_sqr(-npt[1]-31+xfac,-npt[2]-22+yfac,rnd(3),-oa*2,5)
  line(rnd(5)-38+xfac,rnd(5)-38+yfac,rnd(5)-28+xfac,rnd(5)-25+yfac,5)


  -- flip()
  radius=radius-shrink
  if radius <= 1 then
   break
  end
 end

 if oa == 0.01 and not oa_zero then
  loop_counter=loop_counter+1
  oa_zero = true
  srand(seed)
 end

 if not oa == 0.0 then
  oa_zero = false
 end  

 -- gif recording
 if loop_counter == 2 and not loop_started then
  --extcmd("rec") -- start recording
  loop_started = true
 end
 if loop_counter == 4 and not loop_ended then
  --extcmd("video") -- save video
  loop_ended = true
 end
 
 -- ?t(),8
 -- ?oa,8
 -- ?loop_counter,8
 dither(4)

end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

