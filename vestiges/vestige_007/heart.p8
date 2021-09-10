pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)

function tostring(any)
    if type(any)=="function" then 
        return "function" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k).."->"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end


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

function get_vec(x1,y1,x2,y2)
 local vec = {(x2-x1),(y2-y1)}
 return(vec)
end

function get_cross_prod(a,b,c,d)
 local cp = (b.x - a.x) * (d.y - c.y) - (d.x - c.x) * (b.y - a.y)
 return(cp)
end

function triangle_check(a,b,c,p)
 local check1 = get_cross_prod(a,p,a,b)
 local check2 = get_cross_prod(b,p,b,c)
 local check3 = get_cross_prod(c,p,c,a)

 -- printh(tostring(check1)..tostring(check2)..tostring(check3), "@clip")


 local inside_triangle = false
 if check1 > 0 and check2 > 0 and check3 > 0 then
  inside_triangle = true
 elseif check1 < 0 and check2 < 0 and check3 < 0 then
  inside_triangle = true
 end
 -- printh(inside_triangle, "@clip")
 return(inside_triangle)
end

function rnd_pixel_triangle(a,b,c)
 local x = 300
 local y = 300
 local p = {x=x,y=y}
 
 while not triangle_check(a,b,c,p) do
  x = flr(((rnd(128) + 1) - 64) * 0.5)
  y = flr(((rnd(128) + 1) - 64) * 0.5)
  p={x=x,y=y}
 end
 return(p)
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
     circ(pxl.x,pxl.y,rnd(5),burn(c))
    end
   elseif dm == "burn_line" then
    for i=3,1,-1 do
     local pxl = rnd_pixel()
     c=pget(pxl.x,pxl.y)
     line(0,0,pxl.x,pxl.y,burn(c))
    end
   elseif dm == "burn" then
    for i=1,20 do 
     local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
     local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
     --skip some nunber (12) pixels
     for x=128+fudge_x,0,-12 do
      for y=128+fudge_y,0,-12 do
       local pxl = rnd_pixel()
        c=pget(pxl.x,pxl.y)
        pset(pxl.x,pxl.y,burn(c))
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
  local c=min(abs(pget(x,y)-1),5)
  circfill(x*s,y*s,3,c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),5)
  circfill(x*s,y*s,8+rnd(3),c)
  circfill(x*s,y*s,13+rnd(5),c)
  x=rnd(128)-64
  y=rnd(128)-64
  c=min(abs(pget(x,y)-1),5)
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


function triangle_dither(loops)
 for i=loops,1,-1 do
   local pxl = rnd_pixel_triangle(ta,tb,tc)
   c=pget(pxl.x,pxl.y)
   circfill(pxl.x,pxl.y,2,burn(c))
 end
end

function rotate(x, y, radius, degrees)
  new_x = x + (radius * cos(degrees))
  new_y = y + (radius * sin(degrees))
  return({x,y})  
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
 "burn_line"
 -- "circles", 
 -- "circfill", 
 -- "rect"
} 
dither_prob = 0.35
dither_mode="burn_rect"
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
 "0", "-8", "8", 
 -3, "-8", 
 "8",
 "7", "2",
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

loop_len = 10
triangle_start = 290
tri_starts = {triangle_start}
for i=triangle_start,triangle_start-360,-1 do
 add(tri_starts,i)
end

frame = 0

::_::
 local loop = flr(t())%loop_len == 0
 local srf = flr(t()*10)%loop_len/5 == 0
 local r = t()*0.5+1
 local x,y=0,0


 if srf then
  srand(seed)
 end

 local radius = 10.0
 for i=1,61 do
  y=sin(r+i) * radius * (i/4) 
  x=cos(r+i) * radius * (i/4)
  for i=1,7 do
   point = rotate(x,y,radius,(i/360))
   x=point[1]
   y=point[2]
   line(x,-x,y,-y,9)
   line(-x,-x,y,y,9)
   line(-x*i,-x,y*i,y,9)
   line(x,-x*i,y,-y*i,9)
  end
 end
 linecols = {7,9,9}
 
 line(-25,0,-10,20,rnd_choice(linecols))
 line(-25,50,20,0,rnd_choice(linecols))
 line(-25,-25,20,0,rnd_choice(linecols))
 line(-25,50,-25,0,rnd_choice(linecols))
 line(-25,50,20,0,rnd_choice(linecols))
 -- line(-25,50,20,-25,rnd_choice(linecols))
 line(-25,-25,20,0,rnd_choice(linecols))
 line(-50,-25,20,0,rnd_choice(linecols))
 line(-50,-25,20,-50,rnd_choice(linecols))
 line(-50,50,20,50,rnd_choice(linecols))
 line(-50,-50,20,50,rnd_choice(linecols))
 line(-50,50,-20,50,rnd_choice(linecols))
 line(50,-50,-20,-50,rnd_choice(linecols))
 line(50,-50,-20,50,rnd_choice(linecols))
 line(128,-50,-20,50,rnd_choice(linecols))
 line(50,-128,-20,50,rnd_choice(linecols))
 line(50,-50,-20,128,rnd_choice(linecols))
 line(128,-50,-128,50,rnd_choice(linecols))
 line(128,-128,-128,50,rnd_choice(linecols))
 line(50,-50,-20,-50,rnd_choice(linecols))


 triangle_points = {}
 tri_rad = 29
 for i=triangle_start,triangle_start-360,-120 do
  local tpx = cos(i/360.0) * tri_rad
  local tpy = sin(i/360.0) * tri_rad
  add(triangle_points, {x=flr(tpx),y=flr(tpy)})
 end
 ta=triangle_points[1]
 tb=triangle_points[2]
 tc=triangle_points[3]
 
 triangle_start = tri_starts[(frame%#tri_starts)+1]
 -- pupil(10,0.1)
 dither(dither_mode) 
 triangle_dither(50)

 pal(colors[pal_to_use],1)
 frame+=1
 flip()

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
