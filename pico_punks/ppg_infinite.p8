pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

--------------------------------
--        functions           --
--------------------------------
function rnd_sign()
 if rnd(1) >= 0.5 then
  return(-1)
 else
  return(1)
 end
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

function safe_inc(idx, lim)
 local new_idx = idx + 1
 if new_idx > lim then
  new_idx = 1 
 end
 return new_idx
end

function round(n)
 return (n%1<0.5) and flr(n) or ceil(n)
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
 local new_c = max(c-1,0)
 return new_c
end


wallet = stat(6)
if wallet == "unsynced" or wallet == "false" or wallet == "" then
 seed = abs(rnd(-1))

else
 seed = 1
 for i=1,#wallet do
  ch = ord(sub(wallet,i,i))
  seed += seed*31 + ch
 end 
end

srand(seed)
seed += rnd()

-- seed = 10922.6656
orig_seed = seed

function rnd_sign()
 return mid(1,(rnd()-.5)/0)*2-1
end


bgfg_pairs = {
 {11,-13},
 {0,7},
 {0,6},
 {6,5},
 {6,2},
 {-14,14},
 {0,-8},
 {0,8},
 {0,-6},
 {0,-13},
 {0,-4},
 {1,12},
 {1,13},
 {10,-8},
 {-7,-12},
 {-8,7},
 {8,1},
 {-8,1},
 {-8,6}
}

bg = 0 
fg = 1

skins = {
 2,-3,13,-11,-14,4,-12,-7,9,-11,
 7,0,6,8,-8,-2,-1,15,12,-4,1
}
skin1 = 2
skin2 = 3 

eyes = {
 1,12,-4,-9,-6,11,-13,-7,8,13,-8,
 14,7,5,-10,0,-3,3,-12,4,11,-16
}
eye_styles = {
 "\^i","\^b","","\^#","\^#","\^#","\^w","\^t"
}
eye1 = 4
eye2 = 5

hair_c = 6


mouths = {
 0,-3,2,8,-8,-2,-1,7,-6
}
mouth1 = 7 
mouth2 = 8

-- bonus features
eyepatch_prob = 0.03
bald_prob = 0.05
beard_prob = 0.15
::_::

srand(orig_seed)

bgfg = rnd(bgfg_pairs)

srand(seed)

red_check = sub(tostr(seed),-4,-1) == "9999"
red_check = red_check or sub(tostr(seed),-3,-1) == "9998"
red_check = red_check or sub(tostr(seed),-3,-1) == "9997"
red_check = red_check or sub(tostr(seed),-3,-1) == "9996"
red_check = red_check or sub(tostr(seed),-3,-1) == "9995"


pal(bg,bgfg[1],1)
if (red_check) pal(bg,8,1)
pal(fg,bgfg[2],1)

main_skin = rnd(skins)
while main_skin == bgfg[1] do 
 main_skin = rnd(skins)
end
pal(skin1,main_skin,1)
pal(skin2,rnd(skins),1)
blemish_prob = rnd(0.2)

main_eye = rnd(eyes)
while main_eye == main_skin do 
 main_eye = rnd(eyes)
end
pal(eye1,main_eye,1)
pal(eye2,rnd(eyes),1)
eye1_style = rnd(eye_styles)
if rnd() < 0.2 then
 eye2_style = rnd(eye_styles)
else
 eye2_style = eye1_style
end


main_hair = rnd(eyes)
while (main_hair == main_skin or
 main_hair == bgfg[1]) do 
 main_hair = rnd(eyes)
end
pal(hair_c,main_hair,1)

bald = rnd() < bald_prob

main_mouth = rnd(mouths)
while main_mouth == main_skin do 
 main_mouth = rnd(mouths)
end
pal(mouth1,main_mouth,1)
pal(mouth2,rnd(mouths),1)

rainbow_mode = rnd() > 0.99

bw = rnd() > 0.99
if (bw) pal({7,rnd({7,0}),0,7,0,0,7,0,7,0,7,0,7,0,7},1)
if (bw and bgfg[1] == 0) bgfg[1] = -14 pal(bg,bgfg[1],1)

if red_check then 
 pal({7,rnd({0}),0,7,0,0,7,0,7,0,7,0,7,0,7},1)
 if (bgfg[1] == 0) bgfg[1] = -14 pal(bg,bgfg[1],1)
end

cls()
wait = true


-- hair bg
if not bald then

 hair_type = rnd(8)\1+1
 -- hair_type = 2

 if hair_type == 1 then
  for i=0,300 do 
  x = 57 + rnd(30) * rnd_sign()
  y = 58 + rnd(25) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 2 then
  for i=0,120 do 
  x = 43 + rnd(10) * rnd_sign()
  y = 58 + rnd(25) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 3 then
  for i=0,100 do 
  x = 40 + rnd(10) * rnd_sign()
  y = 58 + rnd(5) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,170 do 
  x = 35 + rnd(2) * rnd_sign()
  y = 70 + rnd(40) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 4 then
  for i=0,190 do 
  x = 38 + rnd(13) * rnd_sign()
  y = 40 + rnd(13) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 5 then
  for i=0,250 do 
  x = 55 + rnd(18) * rnd_sign()
  y = 35 + rnd(1) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 6 then
  -- no bg hair
 elseif hair_type == 7 then
  -- wispy hair
  for i=0,50 do 
  x = 57 + rnd(30) * rnd_sign()
  y = 58 + rnd(25) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 8 then
  -- wispy hair
  for i=0,50 do 
  x = 54 + rnd(20) * rnd_sign()
  y = 35 + rnd(5) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 end 
end


-- head
for i=0,500 do 
 if (rnd() > blemish_prob) c=skin1 else c=skin2
 if(rainbow_mode) c=rnd(16)\1 
 x = 57 + rnd(18) * rnd_sign()
 y = 69 + rnd(25) * rnd_sign()
 ?"\^i"..chr(rnd(240)\1+16),x,y,c
end

-- neck
for i=0,200 do 
 if (rnd() > blemish_prob) c=skin1 else c=skin2
 if(rainbow_mode) c=rnd(16)\1 
 x = 44 + rnd(6) * rnd_sign()
 y = 112 + rnd(17) * rnd_sign()
 ?"\^i"..chr(rnd(240)\1+16),x,y,c
end

-- eye1
srand(seed)
for i=0,10 do 
 if (rnd() > 0.2) c=eye1 else c=eye2 
 if(rainbow_mode) c=rnd(16)\1
 x = 67 + rnd(3) * rnd_sign()
 y = 60 + rnd(5) * rnd_sign()
 ?eye1_style..chr(rnd(240)\1+16),x,y,c
end
-- eye2
srand(seed)
for i=0,10 do 
 if (rnd() > 0.2) c=eye1 else c=eye2 
 if(rainbow_mode) c=rnd(16)\1
 x = 48 + rnd(3) * rnd_sign()
 y = 60 + rnd(5) * rnd_sign()
 ?eye2_style..chr(rnd(240)\1+16),x,y,c
end

-- mouth
for i=0,10 do 
 if (rnd() > 0.2) c=mouth1 else c=mouth2 
 if(rainbow_mode) c=rnd(16)\1
 x = 60 + rnd(7) * rnd_sign()
 y = 85 + rnd(3) * rnd_sign()
 ?"\^i"..chr(rnd(240)\1+16),x,y,c
end

-- eyepatch
if rnd() < eyepatch_prob then
 for i=0,100 do 
  x = 48 + rnd(3) * rnd_sign()
  y = 60 + rnd(5) * rnd_sign()
  ?eye1_style..chr(rnd(240)\1+16),x,y,0
 end
 line(55,55,60,43,0)
 line(51,65,38,73,0)
end

if not bald then 
 hair_type = rnd(100)
 -- hair_type = 80

 -- hairstyle 1
 -- hair bg
 if hair_type < 20 then
  for i=0,300 do 
  x = 57 + rnd(20) * rnd_sign()
  y = 29 + rnd(15) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 40 then
  for i=0,150 do 
  x = 55 + rnd(18) * rnd_sign()
  y = 37 + rnd(2) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,50 do 
  x = 55 + rnd(29)
  y = 44 - rnd(3) - (x*0.1)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 50 then
  for i=0,150 do 
  x = 55 + rnd(20) * rnd_sign()
  y = 39 + rnd(2) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?eye1_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,100 do 
  x = 30 + rnd(4)
  y = 39 + rnd(70)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?eye2_style..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 55 then
  for i=0,150 do 
  x = 55 + rnd(20) * rnd_sign()
  y = 37 + rnd(2) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,100 do 
  x = 30 + rnd(4)
  y = 36 + rnd(70)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 60 then
  for i=0,10 do 
  y = 47 - rnd(30)
  x = 30 + rnd(3) + (y*0.2)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 75 then
  -- no fg hair
 elseif hair_type < 99.9 then


  hair_style = ""
  if (rnd() > 0.7) hair_style = "\^i"


  for i=0,30 do 
  y = 40 - rnd(10)
  x = 15 + rnd(1) + (y*0.55)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(15)
  x = 20 + rnd(1) + (y*0.5)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(20)
  x = 25 + rnd(1) + (y*0.45)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(25)
  x = 30 + rnd(1) + (y*0.4)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 35 + rnd(1) + (y*0.35)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 40 + rnd(1) + (y*0.3)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  
  for i=0,30 do 
  y = 42 - rnd(30)
  x = 45 + rnd(1) + (y*0.25)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 50 + rnd(1) + (y*0.20)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 55 + rnd(1) + (y*0.15)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 60 + rnd(1) + (y*0.1)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 65 + rnd(3) + (y*0.05)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 70 + rnd(3) + (y*0.00)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 75 + rnd(3) - (y*0.05)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 80 + rnd(3) - (y*0.1)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 85 + rnd(3) - (y*0.2)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  
  for i=0,30 do 
  y = 42 - rnd(30)
  x = 90 + rnd(2) - (y*0.3)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

 elseif hair_type <= 100 then
  -- head
  for i=0,500 do 
   x = 57 + rnd(18) * rnd_sign()
   y = 69 + rnd(25) * rnd_sign()
   if(rainbow_mode) hair_c=rnd(16)\1
   ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
  -- neck
  for i=0,200 do 
   x = 44 + rnd(6) * rnd_sign()
   y = 112 + rnd(17) * rnd_sign()
   if(rainbow_mode) hair_c=rnd(16)\1
   ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
 end 
end

-- beard
if rnd() < beard_prob then
 beard_type = rnd(5)\1+1
 -- beard_type = 4
 if beard_type == 1 then
  for i=0,150 do 
  x = 57 + rnd(25) * rnd_sign()
  y = 88 + rnd(10) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 2 then
  for i=0,15 do 
  x = 50 + rnd(25)
  y = 77 
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 3 then
  for i=0,10 do 
  x = 57 + rnd(8) * rnd_sign()
  y = 77 + rnd(1) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,10 do 
  x = 50 + rnd(1) * rnd_sign()
  y = 83 + rnd(7) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,10 do 
  x = 70 + rnd(1) * rnd_sign()
  y = 83 + rnd(7) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 4 then
  for i=0,30 do 
  y = 99 + rnd(5) * rnd_sign()
  x = 34 + rnd(3) * rnd_sign() + (0.33*y)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 5 then
  for i=0,150 do 
  x = 57 + rnd(20) * rnd_sign()
  y = 88 + rnd(10) * rnd_sign()
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,200 do 
  y = 100 + rnd(20) * rnd_sign()
  x = 40 + rnd(15) * rnd_sign() + (0.29*y)
  if(rainbow_mode) hair_c=rnd(16)\1
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 end

end

-- noise

local amt = rnd(5)
if amt >= 1 then
 for i=0,amt*amt do
  poke(
      0x6000+rnd(0x2000),
      peek(rnd(0x7fff)))
  poke(
      0x6000+rnd(0x2000),
      rnd(0xff))
 end
end

-- memory fuckery
screen_mem_start=●-웃
for i=0,rnd(16000)+500 do
 d=rnd(8191)
 poke(
  screen_mem_start+d+(rnd()*rnd_sign()), -- write to this position, if the button is pressed shift by -0.5
  @(screen_mem_start+d-64*(mid(1,(rnd()-.5)/0)*2-1)+(rnd()*rnd_sign()))  -- peek @ this position, last part is to get 1 or -1
 )  
end

-- glitch

local gr = rnd(2)
if gr >= 1 then 
 local on=(t()*4.0)%gr<0.1
 local gso=on and 0 or rnd(0x1fff)\1
 local gln=on and 0x1ffe or rnd(0x1fff-gso)\16
 for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
  poke(a,peek(a+2),peek(a-1)+(rnd(3)))
 end
end


-- title:
?seed,1,1,fg

?" press ❎ to save clean png",60,1,fg
?"     clean png              ",60,8,fg

if seed == orig_seed then
 if wallet == "unsynced" or wallet == "" or wallet == "false" then 
  ?"random",90,122,fg
 else
  print(
   sub(wallet,1,5).."..."..sub(wallet,-5,-1),
   76,122,fg)
 end
end

while wait do
 if (btnp(0) and wait) seed-=1 wait=false
 if (btnp(1) and wait) seed+=1 wait=false
 if (btnp(2) and wait) seed+=10 wait=false
 if (btnp(3) and wait) seed-=10 wait=false
 if (btnp(4) and wait) then
  seed=abs(rnd(-1)) wait=false
  orig_seed = seed 
  wallet = ""
 end
 if (btnp(5) and wait) then
  ?seed,1,1,bg 
  ?" press ❎ to save clean png",60,1,bg
  ?"     clean png              ",60,8,bg
  if seed == orig_seed then
   if wallet == "unsynced" or wallet == "" or wallet == "false" then 
  ?"random",90,122,bg
 else
  print(
   sub(wallet,1,5).."..."..sub(wallet,-5,-1),
   76,122,bg)
 end
  end

  extcmd('screen') wait=false
 end
end


flip()

goto _

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bjjbbjjjbjjjbjjjbjbbbbbbbjjjbjjjbjjjbjjjbbbbbbbbbbbbbbbbbbbbbbbbjjjbjjjbjjjbbjjbbjjbbbbbbjjjjjbbbbbbjjjbbjjbbbbbbjjbjjjbjbjbjjjb
bbjbbjbjbjbjbbbjbjbbbbbbbjbjbbbjbbbjbjbjbbbbbbbbbbbbbbbbbbbbbbbbjbjbjbjbjbbbjbbbjbbbbbbbjjbbbjjb9tbbbjbbjbjbbbbbjbbbjbjbjbjbjbbb
bbjbbjbjbjbjbbbjbjjjbbbbbjbjbbjjbjjjbjjjbbbbbbbbbbbbbbbbbbbbbbbbjjjbjjbbjjbbjjjbjjjbbbbbjjbjbjjbbb9tbjbbjbjbbbbbjjjbjjjbjbjbjjbb
bbjbbjbjbjbjbbbjbjbjbbbbbjbjbbbjbjbbbjbjbbbbbbbbbbbbbbbbbbbbbbbbjbbbjbjbjbbbbbjbbbjbbbbbjjbbbjjbbbbbbjbbjbjbbbbbbbjbjbjbjjjbjbbb
bjjjbjjjbjjjbbbjbjjjbbjbbjjjbjjjbjjjbjjjbbbbbbbbbbbbbbbbbbbbbbbbjbbbjbjbjjjbjjbbjjbbbbbbbjjjjjbbbbljbjbbjjbbbbbbjjbbjbjbbjbbjjjb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjjbjbbbjjjbjjjbjjbbbbbbjjjbjjbbbjjbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbbbjbbbjbbbjbjbjbjbbbbbjbjbjbjbjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbbbjbbbjjbbjjjbjbjbbbbbjjjbjbjbjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbbbjbbbjbbbjbjbjbjbbbbbjbbbjbjbjbjbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjjbjjjbjjjbjbjbjbjbbbbbjbbbjbjbjjjbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbk9
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbk9bb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb08bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb08bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbb3333bbbbbbbb3333bbbbbbbbbb333b333bbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbbb3bb33333333333333bb3333bb3333333333333b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbb3333bb333333333333333333333333bb3333333333333b3b3bbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbbbbbbb33333333333333333333333333333333333333333333333b3bbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3333333333333333333333333333333333333333333333333333b33b3bbbbbbbbbbbbbbbbbbbbbbbbbbb9lbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3333333333333333333333333333333333333333333333bb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3333333333333333333333333333333333333333333333bbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33333333333333333333333333333333333333333333333333b333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb333333333333333333333333333333333333333333333b333b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33333333333333333333333333333333333333333333333b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33333333333333333333333333333333333333333333b33b333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3333333333333333kk33333333333333333333bb3bbbb333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbk33333333333333333kk33kk333333333333kk3kb3bb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkbbkk33kk333333333333kkkkkk3333kkkkkk333k3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkklkkklkkkkkkl33kkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkllkkkkkkkkkkkkkkkkkkbkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkllkkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkllkkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkklkklkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkklkllkllkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkppkkkkkkllklkllllkkkkkkkkkppkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkppkkppkkplkllkkllklkppppkkppkkkkkkkkbbkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkpppppkplpllllklllklkpkppppkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbjbbbbbbbbbbbbbkbbbbbbbbb
bbbbjbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkpplkppkpppplllkp8lkpkppkpkpppkpppkkkkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkppppppppppppkkkllklkpppkpppppppkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkpp8pppppppppkkkkpplkppppppppppkpkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkk8pppppppppkpkkkkppppppppppppkkkkpkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8pkkkk8ppppppppppkkpkkkkkkppppppppppkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkppppppppppppkkkkbbppppppppppppkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkk8pkkkkkk8ppppppppppplkkkkkbbk8pppppppkpkpkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkk8pkkpppp8ppppppplkkkkkk8k8pppppppppppkpkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkk8pkk8ppp8pppppkpppkkkkk8bbk8ppppppppppkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkppppppppppkpppkkppbbkppppppppppppkkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkk88ppppppppppppppkkk88ppppppppppppkkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkk88ppppppppkkppkkkk8pkkppppppppppkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkpkppkkkkkkkkkkkkkkkkppppppppkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkppppkkkkkkkkkkkkkklplkkkkkkkkbkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkppkkkkkkkkkkkkkkkkklkkkkppkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkklkklkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkklkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkbbkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkklllkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkklkkklkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkk3k3kkkkkkkkkkkkkkkkkkkkkklklkkklkkkkbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkk3kkkkkkkkkkkkkkkkkk3kkk3kkklllkl3k3kbb3bbb3bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkk3k3kk333kkkkkkkkkkkkkkkkkkkkkkkk3k3b3kbbbbbbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33bb33kkkkk3k3k3k33333kkkkkkk3ttk3kkkk3lkk3k3kkk3bbb3bbb3b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33bb3b333kkkkkkkk33k333t333ttttttttttt3ltk3k3k3k3b3b3bbbbb3b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bk3kk33kkkk3k3k3t3t333t333333tt333k3k333kkk3b3b3bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33bb333b33k33333kkbb3kkttt333t333333t33t3k3k3kkkkk3bbb3bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33bb33klk3k333k3kt33t3t03333333303t3333k33k33bkk33bb3b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbk3k3k3333333ktt0t03333t3333303t333t3k33k3k3b3b3b3b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbk3k333k333333333t03333333333333333t3k33kkk3b33333b3bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33k33kk333kk0t3333t3t333330t3333333k3k3b3333333bbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbl3bbl333k3kk330t3333t33333333333333k3k3k3333bbbb333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbl3l3bbl333k333333333333333333333333kk3333kkkk3bbbbb3333b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bl3k3kk33k3kk333333333333333333333l3k333kk33kbb33333b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b33k3333k3k3k3333330333333333333k333333333k333kb3b3bb3bb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3k333k3k3k333333333t3333333t33333k3k33333k3k33b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbb33bk3333333k333k33333t333333333333333k33333333b3b33bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbpcbbbbbbbbbbbb3b3b33333333333333k3k33333k333333333333l3k333333333333b3bb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3b3bkk33333333333kk3k33k333k33333333333l33333333b3b3bb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bkk3333333kk333k3k333333k3k3k33333l333333k333b3333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbb3k33333k333kk333k33k3333333k333333333333bb3b33333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbb33k33k3k33k3333kk3k3k3333333333333333b3b33333b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bk33kk3kkk3k3k3k3333bbb33333b3b33333b3b3b3b3b3b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbb3b3b3kk3kk33k3kkk3l333b33b3b3bb3bb3b333bb3b33b33bb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkk3bkk33333k33333l33bbb3b3b3b3b3b33bbb3bbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkjbkbbbkk3k333kkl3l3l3l33bbb3b3bb3333333b3bbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkbbk3kk3k3333lkl33b3b3bbb3bbb3b33333bbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkk3k3kklkkkk3l3333bbbbbbbb33b33bbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkklkkkkk3klk33bbbbb333333b3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkbkkkkkkkkkkkkk3kllbbbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkllklbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkklllklbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbblkkkkkkkkkkkklkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbklkkkkkkkklkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkbbkkkkkkklklkkkkklkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkllkkkkkkklkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkklbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkbblkkkkkkkkkkkkbkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkbkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkbkkllllkkkkkkkkkbbbbbblbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkbkkkkkkkkkkbkklblbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkbkkklllkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkklkkklkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbkkkkkkkkklkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkklblbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkbbbblbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjjjbjjjbjjbbjjbbbjjbjjjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkkkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbjbjbjbjbjbjbjbjbjbjjjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkkkklkkkkbkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjjbbjjjbjbjbjbjbjbjbjbjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkklllkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbjbjbjbjbjbjbjbjbjbjbjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkkkkkkkklkllkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbjbjbjbjbjbjbjjjbjjbbjbjbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbkkkkkbbbbkkkklkkkkkkbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb

