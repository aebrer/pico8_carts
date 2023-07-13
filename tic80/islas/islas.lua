-- title:  noise (islas)
-- author: aebrer - Andrew Brereton; https://aebrer.xyz
-- desc:   just some delightful noise
-- script: lua

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

function random_choice(t)
 return t[math.random(1,#t)]
end

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

-- burn
function burn(ci)
 --if math.random()>0.00 then
  ci = math.max(ci-1,0)
 --else
 -- ci = ci-1
 --end
 return ci
end


-- agents
function make_agent(x,y)
 local agent = {}
 agent.x = x or math.floor(math.random(240)) 
 agent.y = y or math.floor(math.random(136))
 agent.dx = 0
 agent.dy = 0
 return agent
end

function move_agent(agent)
 agent.x = (agent.x + agent.dx) % 240
 agent.y = (agent.y + agent.dy) % 136
 
 local turn_rate = 0.95
 if left then turn_rate=0.1 end
 local mouse_hug_rate = 0.01

 if math.random()>turn_rate then
  leftw = 0 
  rightw = 0

  upw = 0
  downw = 0
  -- now make a hard bias against the other agents
  for i=1,#agents do

   local mx=agents[i].x
   local my=agents[i].y
   
   local mtest = false
   if mx-agent.x > 120 then 
    mtest = math.abs(mx-agent.x+1-240) > math.abs(mx-agent.x-1-240)
   elseif mx-agent.x < -120 then
    mtest = math.abs(mx-agent.x+1+240) > math.abs(mx-agent.x-1+240)
   else
    mtest = math.abs(mx-agent.x+1) > math.abs(mx-agent.x-1)
   end
   if mtest then
    rightw = rightw + 1
   else
    leftw = leftw + 1
   end

   mtest = false
   if my-agent.y > 68 then 
    mtest = math.abs(my-agent.y+1-138) > math.abs(my-agent.y-1-138)
   elseif my-agent.y < -68 then
    mtest = math.abs(my-agent.y+1+138) > math.abs(my-agent.y-1+138)
   else
    mtest = math.abs(my-agent.y+1) > math.abs(my-agent.y-1)
   end
   if mtest then
    upw = upw + 1
   else
    downw = downw + 1
   end
   
  end

  local lr = math.random(-leftw,rightw)
  if lr > 2 then
   agent.dx = -1
  elseif lr < -2 then
   agent.dx = 1
  else
   agent.dx = 0
  end

  local ud = math.random(-downw,upw)
  if ud > 2 then
   agent.dy = -1
  elseif ud < -2 then
   agent.dy = 1
  else 
   agent.dy = 0
  end

  if left and math.random()>mouse_hug_rate then
   local mtest = false
   if mx-agent.x > 120 then 
    mtest = math.abs(mx-agent.x+agent.dx-240) < math.abs(mx-agent.x-agent.dx-240)
   elseif mx-agent.x < -120 then
    mtest = math.abs(mx-agent.x+agent.dx+240) < math.abs(mx-agent.x-agent.dx+240)
   else
    mtest = math.abs(mx-agent.x+agent.dx) < math.abs(mx-agent.x-agent.dx)
   end
   if mtest then
    agent.dx=-agent.dx
   end
   local mtest = false
   if my-agent.y > 68 then 
    mtest = math.abs(my-agent.y+agent.dy-136) < math.abs(my-agent.y-agent.dy-136)
   elseif my-agent.y < -68 then
    mtest = math.abs(my-agent.y+agent.dy+136) < math.abs(my-agent.y-agent.dy+136)
   else
    mtest = math.abs(my-agent.y+agent.dy) < math.abs(my-agent.y-agent.dy)
   end
   if mtest then
    agent.dy=-agent.dy
   end
  end

  -- now we need a "attract" condition to randomly cycle on
  -- basically similar to when the mouse is pressed, but draw them to
  -- a random point on the horizontal center of the screen
  if attract then 
   local mtest = false
   if mx-agent.x > 120 then 
    mtest = math.abs(mx-agent.x+agent.dx-240) < math.abs(mx-agent.x-agent.dx-240)
   elseif mx-agent.x < -120 then
    mtest = math.abs(mx-agent.x+agent.dx+240) < math.abs(mx-agent.x-agent.dx+240)
   else
    mtest = math.abs(mx-agent.x+agent.dx) < math.abs(mx-agent.x-agent.dx)
   end
   if mtest then
    agent.dx=-agent.dx
   end
   local mtest = false
   if my-agent.y > 68 then 
    mtest = math.abs(my-agent.y+agent.dy-136) < math.abs(my-agent.y-agent.dy-136)
   elseif my-agent.y < -68 then
    mtest = math.abs(my-agent.y+agent.dy+136) < math.abs(my-agent.y-agent.dy+136)
   else
    mtest = math.abs(my-agent.y+agent.dy) < math.abs(my-agent.y-agent.dy)
   end
   if mtest then
    agent.dy=-agent.dy
   end
  end


 end

 -- finally, need to make sure it doesn't stand still
 if agent.dx == 0 and agent.dy == 0 then
  if math.random() > 0.5 then
   if math.random() > 0.5 then
    agent.dx = 1
   else
    agent.dx = -1
   end
  else
   if math.random() > 0.5 then
    agent.dy = 1
   else
    agent.dy = -1
   end
  end
 end
end


function draw_agent(agent)
 pix(agent.x,agent.y,15)
end

agents = {}
mx = math.floor(math.random(240))
my = math.floor(136/2)

for i=1,100 do
 agents[i] = make_agent()
end

seed = math.random(0,10000)
math.randomseed(seed)
print(seed)
cls()
frame = 0
attract = false

function cycle_attract()
 attract = not attract
 mx = math.floor(math.random(240))  -- entropy injection into mouse position
end


-- palette prevent flashing
pal_changed = false


function TIC()
 mx,my,left,middle,right,scrollx,scrolly=mouse()
 
 -- if mx is offscreen, set it to be within the screen
  if mx < 0 then mx = math.floor(math.random(240)) end
  if mx > 240 then mx = math.floor(math.random(240)) end
  -- if my is offscreen, set it to be within the screen
  if my < 0 then my = math.floor(136/2) end
  if my > 136 then my = math.floor(136/2) end

 if right and not pal_changed then
  set_pal()
  pal_changed = true
 end

 if frame%240==0 then
  seed = seed + 1
 	math.randomseed(seed)
  if math.random()>0.5 then
   cycle_attract()
  end
  pal_changed = false
 end
 
 for i=1,#agents do
  move_agent(agents[i])
  draw_agent(agents[i])
 end
 
 -- dither
-- for i=0,10000 do
--  local x = math.random(0,240)
--  local y = math.random(0,136)
--  pix(x+math.random(-1,1),y+math.random(-1,1),burn(pix(x,y)))
-- end
 for i=0,350 do
  local x = math.random(0,240)
  local y = math.random(0,136)
  local c = pix(x,y)
  if c==0 then c=1 end
  pix(x,y,burn(c))
  -- now draw the adjacent pixels with a bias towards the original color
  for xfac=-1,1 do
   for yfac=-1,1 do
    if xfac~=0 or yfac~=0 and c~=1 then
      pix((x+xfac)%240,(y+yfac)%136,random_choice({c,burn(c)}))
    end
   end
  end
 end
	frame = frame + 1

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

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

