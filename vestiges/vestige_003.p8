pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
colors = {0,7,-16,-14,-11,-3,2,8}
pc = #colors
pal(colors,1)
srand(42)
function rand_sign()
 local coin_toss = rnd(1)
 local factor = 0.0
 if coin_toss >= 0.5 then
  factor = -1
 else
  factor = 1
 end
 return(factor)
end

function add_line(a,b,i)
 newa = ofst(a,i,i)
 add(window_lines, {newa[1],b[1],newa[2],b[2], i})
end

function ofst(a, x, y)
 --offset a point
 local b={a[1]+x, a[2]+y}
 return(b)
end

--window stuff
window_lines = {}

far = {0,10}
near = {-128,100}


for i=-6,6,3 do 
 add_line(far,near,i)
end

::_::
 local f   = flr(t()*60)%6 == 0
 local hf  = f or flr(t()*60)%7 == 0
 local uhf = hf or flr(t()*60)%2 == 0
 local srf=flr(t()*60)%3600 == 0
 local r=t()/12
 local x,y=0,0
 if srf then
  srand(42)
 end

 -- print(tostr(#window_lines),0,0,7)

 --lines 
 for wl in all(window_lines) do
  local i = abs(wl[5])
  -- if rnd(1) > 0.5 then
   local flkr = f
   if i == 1 then
    flkr = hf
   elseif i >= 2 then
    flkr = uhf
   end
   if flkr then
    line(
     wl[1]+sin(r)*(10+(i+1)),--+ (flr(rnd(50))+1)*rand_sign(),
     wl[2]+sin(r)*cos(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     wl[3]+sin(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     wl[4]+sin(r)*cos(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     8
     )
   end
  -- end
 end

 --lines 
 for wl in all(window_lines) do
  local i = abs(wl[5])
  if rnd(1) > 0.9 then
   local flkr = f
   if i == 1 then
    flkr = hf
   elseif i >= 2 then
    flkr = uhf
   end
   if flkr then
    line(
     wl[1]+sin(r)*(25+(i+1))+ (flr(rnd(2))+1)*rand_sign(),
     wl[2]+sin(r)*cos(r)*(40+(i+1)) + (flr(rnd(3))+1)*rand_sign(),
     wl[3]+sin(r)*(40+(i+1)) + (flr(rnd(2))+1)*rand_sign(),
     wl[4]+sin(r)*cos(r)*(25+(i+1)) + (flr(rnd(2))+1)*rand_sign(),
     colors[#colors]
     )
   end
  end
 end


 --lines 
 for wl in all(window_lines) do
  local i = abs(wl[5])
  if rnd(1) > 0.9 then
   local flkr = f
   if i == 1 then
    flkr = hf
   elseif i >= 2 then
    flkr = uhf
   end
   if flkr then
    line(
     wl[2]+sin(r)*(25+(i+1))+ (flr(rnd(2))+1)*rand_sign(),
     wl[1]+sin(r)*cos(r)*(40+(i+1)) + (flr(rnd(3))+1)*rand_sign(),
     wl[4]+sin(r)*(40+(i+1)) + (flr(rnd(2))+1)*rand_sign(),
     wl[3]+sin(r)*cos(r)*(25+(i+1)) + (flr(rnd(2))+1)*rand_sign(),
     colors[#colors]
     )
   end
  end
 end

 --lines 
 for wl in all(window_lines) do
  local i = abs(wl[5])
  -- if rnd(1) > 0.5 then
   local flkr = f
   if i == 1 then
    flkr = hf
   elseif i >= 2 then
    flkr = uhf
   end
   if flkr then
    line(
     wl[2]+sin(r)*(10+(i+1)),--+ (flr(rnd(50))+1)*rand_sign(),
     wl[1]+sin(r)*cos(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     wl[4]+sin(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     wl[3]+sin(r)*cos(r)*(10+(i+1)),-- + (flr(rnd(50))+1)*rand_sign(),
     8
     )
   end
  -- end
 end













 x=rnd(128)-64
 y=rnd(128)-64
 local c=abs(pget(x,y)-1)
 if c == 2 then
  --rect(x-1,y-1,x+1,y+1,c)
  pset(x,y,c)
  --circ(x,y,2,c)
 else
  circfill(x,y,3,c)
 end
goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
