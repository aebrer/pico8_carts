pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)


function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

function rnd_pixel()
 local px_x = (flr(rnd(128)) + 1) - 64
 local px_y = (flr(rnd(128)) + 1) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function dither(dm)
   if dm == "mixed" then
    while dm == "mixed" do
     dm = rnd_choice(dither_modes)
    end
    dither(dm)
   elseif dm == "cls" then
    cls()
   elseif dm == "circles" then
    for i=1,3 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
       if rnd(1) > dither_prob then
        circ(pxl.x,pxl.y,16,0)
       end
      end
     end
    end
   elseif dm == "circfill" then
    for i=1,3 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
       if rnd(1) > dither_prob then
        circfill(pxl.x,pxl.y,4,0)
       end
      end
     end
    end
   elseif dm == "rect" then
    for i=1,3 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
       if rnd(1) > dither_prob then
        rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,0)
       end
      end
     end
    end
   elseif dm == "burn_spiral" then
    for i=13,1,-1 do
     local pxl = rnd_pixel()
     c=pget(pxl.x,pxl.y)
     circ(pxl.x,pxl.y,2,burn(c))
    end
   elseif dm == "burn" then
    for i=1,2 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
        c=pget(pxl.x,pxl.y)
        circ(pxl.x,pxl.y,1,burn(c))
      end
     end
    end
   elseif dm == "burn_rect" then
    for i=1,2 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
        c=pget(pxl.x,pxl.y)
        rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
      end
     end
    end
   end
end

function burn(c)
 local new_c = min(abs(c-1),4)
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

function undither(loops,s)
 
 for i=-loops,1 do
  local x=rnd(128)-64
  local y=rnd(128)-64
  local c=min(abs(pget(x,y)-1),6)
  circfill(x*s,y*s,3,c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),6)
  circ(x*s,y*s,8+rnd(3),c)
  circ(x*s,y*s,13+rnd(5),c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),6)
  pset(x*s,y*s,c)
  -- circfill(x,y,2,c)
 end
end
function pupil(loops,s)
 
 for i=-loops,1 do
  local x=rnd(128)-64
  local y=rnd(128)-64
  circfill(x*s,y*s,3,0)
  x=rnd(128)-64
  y=rnd(128)-64
  pset(x*s,y*s,0)
 end
end
function sclera_dither(loops)
 for i=loops,1,-1 do
   local pxl = rnd_pixel()
   c=pget(pxl.x*0.5,pxl.y*0.5)
   circfill(pxl.x*0.5,pxl.y*0.5,2,burn(c))
 end
end

reset_timer = 8
reset_needed = false

-- seed = flr(rnd(888)) + 1
seed = 42
srand(seed)
seed_reset_needed = false


dither_modes = {
 "mixed",
 "burn_spiral",
 -- "burn_rect",
 "burn",
 -- "circles", 
 -- "circfill", 
 -- "rect"
} 
dither_prob = 0.35
dither_mode="burn"
n_dither_modes = #dither_modes

pal1 = {
 "0", "-15", "0", "-4",
 "12", "6", "7", "1",
 "12"
}
pal2 = { 
 "0", "-14", "-0", 
 "-11", "-12", "-3",
 "2", "-8",
 "8"
}
pal3 = { 
 "0", "-13", "0", "3",  
 "-5", "-6", "-9", "7",
 "11"
}
pal4 = {
 "0", "7", "8", 
 7, "-8", 
 "8",
 "7", "7",
 "-8"
}

pal5 = {
 "0", "-11", "0", 
 "-11", "5", "5",
 "6","7", "7"
}

colors = {pal4}
pal_to_use = 1
pal_tracker = 0
pal_change_needed = false

-- pal(colors[pal_to_use],0)
pal(colors[pal_to_use],1)


::_::
 local loop_len = 10
 local loop = flr(t())%loop_len == 0
 local srf = flr(t())%loop_len/2 == 0
 local r = t()/(loop_len*2) + 1
 local x,y=0,0

 -- if srf and seed_reset_needed then
 --  srand(seed)
 --  seed_reset_needed = false
 -- elseif not srf and not seed_reset_needed then
 --  seed_reset_needed = true
 -- end


 if srf and seed_reset_needed then
  srand(seed)
 end

 for i=0,10 do
  x=sin(r+i)*(20+(i*rnd(3)+1))
  y=(cos(r+i)*sin(r+i))*(20+(i*rnd(3)+1))
  
  circ(x*flr(rnd(3)+1),y,100,9)
  -- circ(-x*flr(rnd(3)+1),y,100,9)
  -- circ(x*flr(rnd(3)+1),-y,100,9)
  circ(-x*flr(rnd(3)+1),-y,100,9)

  circ(x/flr(rnd(3)+1),y*i,100,9)
  -- circ(-x/flr(rnd(3)+1),y*i,100,9)
  -- circ(x/flr(rnd(3)+1),-y*i,100,9)
  circ(-x/flr(rnd(3)+1),-y*i,100,9)

 end
 
 dither(dither_mode)
 sclera_dither(100)
 undither(10,0.05)
 pupil(50,0.01)

 pal(colors[pal_to_use],1)


goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
