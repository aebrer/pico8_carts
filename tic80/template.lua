-- title:    [working]
-- author:  aebrer
-- desc:    
-- website: aebrer.xyz
-- license: cc0
-- version: NULL
-- script:  lua

palette = {
    {0,0,0},
    {10,0,2},
    {20,0,5},
    {30,0,10},
    {50,0,15},
    {80,0,20},
    {128,0,38},
    {189,0,38},
    {227,26,28},
    {252,78,42},
    {253,141,60},
    {254,178,76},
    {254,217,118},
    {255,237,160},
    {255,255,204},
    {255,255,255}
   }
     
   cls()
   -- pico8 compatibility functions
   flr=math.floor
   abs=math.abs
   max=math.max
   min=math.min
     
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
     flr(math.random(241))
    )
    local px_y = (
     flr(math.random(137))
     )
    local pixel = {
     x=px_x,
     y=px_y
    }
    return(pixel)
   end
   
   -- setting params
   seed = math.random(0,999999)
   math.randomseed(seed)
   -- set colors
   function pal(ci,col)
    local mem_loc = 0x03FC0 + 3*ci
    cfr = math.random(0,2)
    cfg = math.random(0,2)
    cfb = math.random(0,2) 
    color_facs={cfr,cfg,cfb}
    color_b={math.random(-100,20),math.random(-30,50),math.random(-10,80)}
    for i=1,3 do
     -- poke(mem_loc+i-1, math.min(math.max(col[i]*color_facs[i]+color_b[i],0),255))
     poke(mem_loc+i-1, math.max(col[i]*color_facs[i]+color_b[i],0))
    end
   end
   function set_pal()
    for i=0,#palette-1 do
     pal(i,palette[i+1])
    end
   end
   set_pal()
     
   function TIC() 
    mx,my,left,middle,right,scrollx,scrolly=mouse()
    
   end
       