pico-8 cartridge // http://www.pico-8.com
version 33
__lua__


wallet = stat(6)
wallet = "unsynced"
if wallet == "unsynced" then
 seed = -20801
else
 seed = 1
 for i=1,#wallet do
  ch = ord(sub(wallet,i,i))
  seed += seed*31 + ch
 end 
end

orig_seed = seed


function rnd_sign()
 return mid(1,(rnd()-.5)/0)*2-1
end
-- seed = rnd(-1)\1
-- seed = -20801

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
}

bg = 0 
fg = 1

skins = {
 2,-3,13,-11,-14,4,-12,-7,9,-11,7,0,6,8,-8,-2,-1,15,12,-4,1
}
skin1 = 2
skin2 = 3 

eyes = {
 1,12,-4,-9,-6,11,-13,-7,8,13,-8,14,7,5,-10,0,-3,3,-12,4,11,-16
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


srand(seed)

bgfg = rnd(bgfg_pairs)
pal(bg,bgfg[1],1)
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
while main_hair == main_skin or main_hair == bgfg[1] do 
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
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 2 then
  for i=0,120 do 
  x = 43 + rnd(10) * rnd_sign()
  y = 58 + rnd(25) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 3 then
  for i=0,100 do 
  x = 40 + rnd(10) * rnd_sign()
  y = 58 + rnd(5) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,170 do 
  x = 35 + rnd(2) * rnd_sign()
  y = 70 + rnd(40) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 4 then
  for i=0,190 do 
  x = 38 + rnd(13) * rnd_sign()
  y = 40 + rnd(13) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 5 then
  for i=0,250 do 
  x = 55 + rnd(18) * rnd_sign()
  y = 35 + rnd(1) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 6 then
  -- no bg hair
 elseif hair_type == 7 then
  -- wispy hair
  for i=0,50 do 
  x = 57 + rnd(30) * rnd_sign()
  y = 58 + rnd(25) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type == 8 then
  -- wispy hair
  for i=0,50 do 
  x = 54 + rnd(20) * rnd_sign()
  y = 35 + rnd(5) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 end 
end


-- head
for i=0,500 do 
 if (rnd() > blemish_prob) c=skin1 else c=skin2 
 x = 57 + rnd(18) * rnd_sign()
 y = 69 + rnd(25) * rnd_sign()
 ?"\^i"..chr(rnd(240)\1+16),x,y,c
end

-- neck
for i=0,200 do 
 if (rnd() > blemish_prob) c=skin1 else c=skin2 
 x = 44 + rnd(6) * rnd_sign()
 y = 112 + rnd(17) * rnd_sign()
 ?"\^i"..chr(rnd(240)\1+16),x,y,c
end

-- eye1
srand(seed)
for i=0,10 do 
 if (rnd() > 0.2) c=eye1 else c=eye2 
 x = 67 + rnd(3) * rnd_sign()
 y = 60 + rnd(5) * rnd_sign()
 ?eye1_style..chr(rnd(240)\1+16),x,y,c
end
-- eye2
srand(seed)
for i=0,10 do 
 if (rnd() > 0.2) c=eye1 else c=eye2 
 x = 48 + rnd(3) * rnd_sign()
 y = 60 + rnd(5) * rnd_sign()
 ?eye2_style..chr(rnd(240)\1+16),x,y,c
end

-- mouth
for i=0,10 do 
 if (rnd() > 0.2) c=mouth1 else c=mouth2 
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
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 40 then
  for i=0,150 do 
  x = 55 + rnd(18) * rnd_sign()
  y = 37 + rnd(2) * rnd_sign()
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,50 do 
  x = 55 + rnd(29)
  y = 44 - rnd(3) - (x*0.1)
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 50 then
  for i=0,150 do 
  x = 55 + rnd(20) * rnd_sign()
  y = 39 + rnd(2) * rnd_sign()
  ?eye1_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,100 do 
  x = 30 + rnd(4)
  y = 39 + rnd(70)
  ?eye2_style..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 55 then
  for i=0,150 do 
  x = 55 + rnd(20) * rnd_sign()
  y = 37 + rnd(2) * rnd_sign()
  ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,100 do 
  x = 30 + rnd(4)
  y = 36 + rnd(70)
  ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif hair_type < 60 then
  for i=0,10 do 
  y = 47 - rnd(30)
  x = 30 + rnd(3) + (y*0.2)
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
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(15)
  x = 20 + rnd(1) + (y*0.5)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(20)
  x = 25 + rnd(1) + (y*0.45)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 40 - rnd(25)
  x = 30 + rnd(1) + (y*0.4)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 35 + rnd(1) + (y*0.35)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 40 + rnd(1) + (y*0.3)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  
  for i=0,30 do 
  y = 42 - rnd(30)
  x = 45 + rnd(1) + (y*0.25)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 50 + rnd(1) + (y*0.20)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 55 + rnd(1) + (y*0.15)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 60 + rnd(1) + (y*0.1)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 65 + rnd(3) + (y*0.05)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 70 + rnd(3) + (y*0.00)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 75 + rnd(3) - (y*0.05)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 80 + rnd(3) - (y*0.1)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

  for i=0,30 do 
  y = 42 - rnd(30)
  x = 85 + rnd(3) - (y*0.2)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end
  
  for i=0,30 do 
  y = 42 - rnd(30)
  x = 90 + rnd(2) - (y*0.3)
  ?hair_style..chr(rnd(240)\1+16),x,y,hair_c
  end

 elseif hair_type <= 100 then
  -- head
  for i=0,500 do 
   x = 57 + rnd(18) * rnd_sign()
   y = 69 + rnd(25) * rnd_sign()
   ?"\^i"..chr(rnd(240)\1+16),x,y,hair_c
  end
  -- neck
  for i=0,200 do 
   x = 44 + rnd(6) * rnd_sign()
   y = 112 + rnd(17) * rnd_sign()
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
  ?"\^p"..chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 2 then
  for i=0,10 do 
  x = 57 + rnd(5) * rnd_sign()
  y = 77 + rnd(1) * rnd_sign()
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 3 then
  for i=0,10 do 
  x = 57 + rnd(8) * rnd_sign()
  y = 77 + rnd(1) * rnd_sign()
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,10 do 
  x = 50 + rnd(1) * rnd_sign()
  y = 83 + rnd(7) * rnd_sign()
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,10 do 
  x = 70 + rnd(1) * rnd_sign()
  y = 83 + rnd(7) * rnd_sign()
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 4 then
  for i=0,30 do 
  y = 99 + rnd(5) * rnd_sign()
  x = 34 + rnd(3) * rnd_sign() + (0.33*y)
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 elseif beard_type == 5 then
  for i=0,150 do 
  x = 57 + rnd(20) * rnd_sign()
  y = 88 + rnd(10) * rnd_sign()
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
  for i=0,200 do 
  y = 100 + rnd(20) * rnd_sign()
  x = 40 + rnd(15) * rnd_sign() + (0.29*y)
  ?chr(rnd(240)\1+16),x,y,hair_c
  end
 end

end

-- title:
?"pico_punk no. "..seed,1,1,fg

if seed == orig_seed then
 if wallet == "unsynced" then 
  ?"unsynced",90,122,fg
 else
  ?sub(wallet,1,5).."..."..sub(wallet,-5,-1),76,122,fg
 end
end

while wait do
 if (btnp(0) and wait) seed-=1 wait=false
 if (btnp(1) and wait) seed+=1 wait=false
 if (btnp(2) and wait) seed+=10 wait=false
 if (btnp(3) and wait) seed-=10 wait=false
 if (btnp(4) and wait) seed=rnd(-1)\1 wait=false
 if (btnp(5) and wait) extcmd('screen') wait=false

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
