pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

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

-- enable use of second onscreen palette
poke(▒|▤,웃/●)

poke(14-😐,1)_set_fps(60)r=rnd
g=r(5)-3a=r(5)-3b=max(a/3,0.11)
z=r({1,2,3,5})w=r({2,3,4})c=(r(14)+2)\1
while (g+a)%b==g do a=r(5)end

--palette 1
palette={}
for i=0,15do add(palette,r(33)-17)end
-- make sure there is more than one color in use:
all_same=true
prev_palette=palette[1]
for i=2,c do 
 if (palette[i] != prev_palette) all_same=false
end
if (all_same) palette[1]+=1
for i=0,15do pal(i,palette[i+1],1) end

--palette 2
palette={}
for i=0,15do add(palette,r(33)-17)end
-- make sure there is more than one color in use:
all_same=true
prev_palette=palette[1]
for i=2,c do 
 if (palette[i] != prev_palette) all_same=false
end
if (all_same) palette[1]+=1
for i=0,15do pal(i,palette[i+1],2) end
use_second_pal = r()>0.8
vertical_split = r()>0.5


p1=16
width=32
length=96

loop_l=16
oa_zero=false
loop_counter=0

cls()::_::

-- looping
oa = (t())%(loop_l/2)/(loop_l/2)
if oa <= 0.01 and not oa_zero then
 oa_zero = true
end
if oa > 0.01 and oa_zero then
 oa_zero = false
 loop_counter+=1
 srand(seed)
end  


if(stat(34)==1)g=(g+a)%b
for x=g,128,z do 
for y=g,128,w do
circfill(x,y,r(1),x*y%c)
end end


for i=0,800 do
x=p1+r(length-2)+1
y=p1+r(width)
pcl=pget(x-r(2)-1,y)
pc=pget(x,y)
pset(x,y,pcl)
pset(x+r(2)+1,y,pc)

x=128-p1-width+r(width)
y=p1+r(length-2)
pcl=pget(x,y-r(2)-1)
pc=pget(x,y)
pset(x,y,pcl)
pset(x,y+r(2)+1,pc)


x=p1+r(length-2)+2
y=128-p1-width+r(width)
pcl=pget(x+r(2)+1,y)
pc=pget(x,y)
pset(x,y,pcl)
pset(x-r(2)-1,y,pc)


x=p1+r(width)
y=p1+r(length-2)+2
pcl=pget(x,y+r(2)+1)
pc=pget(x,y)
pset(x,y,pcl)
pset(x,y-r(2)-1,pc)
end

if(use_second_pal)memset(0x5f78,0xfff,8)
if(vertical_split)poke(0x5f2c,133) 

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
