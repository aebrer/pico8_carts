pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- init

-- todo

-- - "ignore it" path leads to a door
--   door is locked until all secrets found
--   when all secrets found, 
--   door opens (literally write the page)
--   otherwise adds "it's locked." text
--
-- - perhaps alternate page in mirror world
--   a fountain that lowers doom... at a cost
--   you get one less palette color each time
--   replaced by rnd({0,7})
--   until the whole screen is unusable
--
-- - achievements page that lists all secrets found

--!!
debug_mode=false
--!!

lib={} -- library of all pages: title,page
inventory={} -- player inventory
inv_chs={}
cursed=false
curr_page=nil -- current page
bkmk=false -- bookmark a page
debug={}  -- list of things to print for debug
pressed=nil -- if a button was pressed
pc=0  -- timer for button press
butt_pos={}
butt_pos[⬆️]={60,104}
butt_pos[⬇️]={60,116}
butt_pos[⬅️]={54,110}
butt_pos[➡️]={66,110}
butt_key={[0]="⬅️","➡️","⬆️","⬇️"}
dt=0 -- doom timer
dtm=1024
obutt_ani=0
side=0
seed_reset_needed=true
cam_vfx={}
logos={}
history={}
his_curr=10
mirror_world=false
vfx_names={}
anti_doom=0


fullscreen=false
info=false
secrets_pg=false
secrets={}

menuitem(1,"+/- fullscreen",function()secrets_pg=false bkmk=false info=false fullscreen=(not fullscreen) end)
menuitem(2,"+/- debug info",function()secrets_pg=false bkmk=false fullscreen=false info=(not info) end)
menuitem(3,"+/- achievements",function()info=false bkmk=false fullscreen=false secrets_pg=(not secrets_pg) end)


-- logos
v9_static = {}
v9_static.name="v9_static"
function v9_static.init(self)
 self.fillp=rnd({▥,█,▤})
 self.p={1,3}
 self.g=rnd(5)-3
 self.a=-1
 self.b=self.a*2
 self.z=2
 self.w=self.z+rnd(self.p)
 self.c=rnd(14)\1+2
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
end
function v9_static.draw(self,x1,y1,w,h)
 fillp(self.fillp)
	for x=self.g+x1,self.g+x1+w,self.z do for y=self.g+y1,self.g+y1+h,self.w do
 circ(x,y,rnd(2),x*y%self.c)end end
end
add(logos,v9_static)

dg_logo = {}
dg_logo.name = "ttc_s01t04"
function dg_logo.init(self)
 self.fillp=({▥,█,▤})
 if curr_page.cls then 
  curr_page.cls=false
  self.seed_rate=0.99
 else 
  curr_page.cls=false
  self.seed_rate=0.4
 end
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
end

function dg_logo.draw(self,x1,y1,w,h)
 if(rnd()>self.seed_rate)srand(curr_page.seed)
 fillp(self.fillp)
 poke(0x5f54,0x60)
 palt(0,false)
 if(rnd()>.1)sspr(x1,y1,w,h,x1+2,y1+2,w-4,h-4)
 for i=0,10 do 
  circ(rnd(128),rnd(128),rnd(64)+64,rnd(8))
  sspr(0,rnd(128),128,rnd(5),rnd(128),0,rnd(5),128)
  sspr(rnd(128),0,rnd(5),128,0,rnd(128),128,rnd(5))
 end
 poke(0x5f54,0x00)
 palt(0,true)
end
add(logos,dg_logo)

ideocart_logo = {}
ideocart_logo.name="trace_ideocart"
function ideocart_logo.init(self)
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
 self.fillp=rnd({∧,░,…,█,█,█,▥,▒,♪,▤})
 self.xi=rnd({12,16,32,32,64})
 self.yi=rnd({12,16,32,32,64})
 while (self.xi<=16 and self.yi<=16) do
  if rnd()>.5 then
   self.xi=rnd({12,16,32,32,64})
  else 
   self.yi=rnd({12,16,32,32,64})
  end
 end
end 
function ideocart_logo.draw(self,x1,y1,w,h)
 fillp(self.fillp)
 poke(0x5f54,0x60)
 for x=x1,x1+w,self.xi do
  for y=y1,y1+h,self.yi do
   circ(x,y,rnd(10)+1,rnd(6))
  end
 end
 for x=x1,x1+w,4do
  for y=y1,y1+h,4do
   if rnd()>.5 then
    sspr(x+rnd(4)-rnd(4),y+rnd(4)-rnd(4),8,8,y+rnd(4)-rnd(4),x+rnd(4)-rnd(4),
    rnd(4)+7,rnd(4)+7)
   else 
    sspr(x+rnd(4)-rnd(4),y+rnd(4)-rnd(4),8,8,x+rnd(4)-rnd(4),y+rnd(4)-rnd(4),
    rnd(4)+7,rnd(4)+7)
   end
  end
 end
 poke(0x5f54,0x00)
 srand(curr_page.seed)
end
add(logos,ideocart_logo)



function _init() 

 -- title screen
 pal(15,7,1)
 local sc=0

 while sc<=6 do
  cls()
  if(t()\1%2==0)spr(32,0,120) -- cursor
  if(sc==0)print("./trace_gallery/038_17.9dgp.p8",4,120-sc*6,7)
  if(sc>=1)print("./trace_gallery/038_17.9dgp.p8",4,120-sc*6,7)
  if(sc>=2)print("loading...",4,120-(sc-1)*6,7)
  if(sc>=3)print("please submit userid:",4,120-(sc-2)*6,7)
  if(sc>=3)print("127402",4,120-(sc-3)*6,7)
  if(sc>=4)print("127402",4,120-(sc-3)*6,7)
  if(sc>=5)print("welcome: hierophant",4,120-(sc-4)*6,7)
  if(sc>=6)print("<network error>",4,120-(sc-5)*6,7)


  -- check any buttons
  local pressed=false
  for i=0,5do
   pressed=pressed or btnp(i)
  end
  if(pressed)sc+=1

  glitch()

  flip()
 end


	music_start(true)
 cls()
 -- set current page to landing page
	curr_page=lib[title]
 inventory["open mind"]=true
 if(debug_mode)curr_page=lib[p_debug]music_stop()
 
end


-- update
function _update60()


 if(curr_page.cls)cls()
 -- do the init for all pages
 if not curr_page.i then 
  curr_page.dc=dc()
 	if curr_page.dc then
   if mirror_world then 
    pal(15,-14,1)
   else 
  	 pal(15,-8,1)
   end
   music_state("dead god")
   if dc() then
    curr_page.logo=rnd(logos)
    if dc() then
     cls()
     glitch()
     curr_page.choices[rnd({⬆️,⬇️,➡️,⬅️})]=ch_breach
    end
 	 end
  else
   if mirror_world then 
    pal(15,0,1)
   else 
  		pal(15,7,1)
   end
   curr_page:music_reset()
		end
 	srand(curr_page.seed)
 	curr_page.logo:init()
 	curr_page.i=true
 end
 if lib[title].seed%17==0 then
  cursed=true
 else
  cursed=false
 end

 if(inventory["cursed"])srand(curr_page.seed)

 -- do callbacks for curr_page
 if(curr_page.cb)curr_page:cb()
 
 if bkmk then  
 -- set bookmark

  if btnp(❎) then 
   -- in history
   -- if exit history
   sfx(40, 3) -- goto bookmark sound
   bkmk=false
   
  end

  if btnp(⬆️) then 
   sfx(39, 3) -- remove bookmark sound
   his_curr=min(his_curr+1,10)
  end
  if btnp(⬇️) then 
   sfx(39, 3) -- remove bookmark sound
   his_curr=max(his_curr-1,1)
  end

  if btnp(🅾️) then
   sfx(40, 3) -- goto bookmark sound
   goto_page(history[his_curr])
   bkmk=false
  end 
 
 elseif info then
  for b=0,5do
   if btnp(b)then
    info=false
   end
  end

 elseif secrets_pg then
  for b=0,5do
   if btnp(b)then
    secrets_pg=false
   end
  end

 else
  -- check inputs for choices
  for b=0,3do
 	 if btnp(b)then
 	  pressed=b
 	  
    if side%2==0then -- choices

     if curr_page.choices[b] then
  				-- callback for this choice 
      if(curr_page.choices[b].cb)curr_page.choices[b]:cb()
  		  if curr_page.choices[b].page then
  		  	sfx(16, 3) -- select option sound
       local target=curr_page.choices[b].page
       goto_page(target)
  		  end
  	  end

    else  -- inventory
     if inv_chs[b] then
      inv_chs[b]:cb()
      if inv_chs[b].page then
       sfx(16, 3) -- select option sound
       local target=inv_chs[b].page
       goto_page(target)
      end
     end
    end
   end
  end
  
  if btnp(🅾️) then
   sfx(41+obutt_ani%8,3)
   obutt_ani+=1
   if(obutt_ani%8==0)side+=1cls()
   doom_plus()
  end
  
  if btnp(❎) then
   -- not in history
   -- goto history
   sfx(38, 3) -- place bookmark sound
   palt(0,false)
   spr(2,120,0)  -- change bkmk logo
   palt(0,true)
   sspr(18,7,11,15,110,-1,11,15)
   bkmk=true
  end
 end
end

function goto_page(p)
 if p then
  curr_page:on_leave()
  if(curr_page.leave_cb)curr_page:leave_cb()
  -- goto new page
  curr_page=p
  curr_page.i=false
 end
end

function doom_plus()
 dt+=1
end

function dc()
 return rnd(dt/rnd(dtm))>1
end

function dc_pal()
 if(curr_page.dc)for i=1,14do pal(i,rnd({8,-16,-15,-14,-11,2,-8,-8}),1)end
end

-- classes

function new_page(title,text)
	local page = {}
	page.title = title
	page.seed = get_seed(page.title)
	page.text_i = 0
	page.texts = {[0]=text}	
	page.text = page.texts[page.text_i]
	page.logo = v9_static
 page.cls=true
	page.cb = nil
 page.leave_cb = nil
 page.dc=false
 page.on_leave = function(pg)
  page.i=false
  obutt_ani=0
  side=0
  doom_plus()
  add(history,pg)
  if(#history>10)deli(history,1)
 end
	page.choices = {}
 page.music=""
 page.music_reset = function(pg)
  music_state(pg.music)
 end
	
	-- method assignments
	page.dis_title = dis_title
	page.dis_text = dis_text
	page.dis_logo = dis_logo
	page.dis_choices = dis_choices
	
	-- finish
	lib[title]=page
	return page
end

function new_choice(title,page,cb)
 local choice = {}
 choice.title=title
 choice.page=page
 choice.cb=cb
 return(choice)
end

-- utils
function get_seed(w)
 s=1
 for i=1,#w do
	ch=ord(sub(w,i,i))s+=s*31+ch
	end
--	if(#w==0)s=r(-1) 
	return(s)
end

function hcenter(s,c)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  return c-#s*2
end

-- draw
function _draw()
 
 if bkmk then
  -- cls()

  local wx,wy,ww,wh=14,8,114,65
  clip(wx,wy,ww,wh)
  fillp()
  rectfill(wx,wy,wx+ww-1,wy+wh-1,0)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,15) --border
  rect(wx,wy,wx+ww-1,wy+wh-1,15) --border

  for i=10,1,-1 do
   if history[i] then 
    print(history[i].title,wx+15,wy+(wh-2-(i*6)),15)
   else
    print("---",wx+15,wy+(wh-2-(i*6)),15)
   end
  end
 
  -- cursor print
  print("⬆️",wx+3,wy+(wh-2-((his_curr+1)*6)),15)
  print("🅾️",wx+3,wy+(wh-2-(his_curr*6)),15)
  print("⬇️",wx+3,wy+(wh-2-((his_curr-1)*6)),15)
  spr(32,wx+11,wy+(wh-2-(his_curr*6)))

  clip()

 elseif info then 
 
  cls()
  local skips={}
  
  print("------logo art------------------------",15)
  for key,val in pairs(curr_page.logo) do
   if key!="draw"and key!="init"and key!="p"and key!="a"and key!="b"and key!="z" then 
    ?key..": "..tostr(val)
   end
  end
  ?"-----current vfx----------------------"
  ?vfx_names[curr_page.vfx]
  ?"----current photos----------------------"
  for vfx in all(cam_vfx) do
   ?vfx_names[vfx] 
  end
  ?"----misc settings----------------------"
  ?"seed: "..curr_page.seed
  ?"clear screen: "..tostr(curr_page.cls)
  ?"mirror status: "..@(24364)
  ?"you see it: "..tostr(cursed)
  ?"cursed: "..tostr(inventory["cursed"])
  ?"dead god: "..tostr(curr_page.dc)
  ?"doom: "..dt
  ?"anti_doom: "..anti_doom
  
 elseif secrets_pg then
  
  cls()
  ?"not yet implemented",(t()*10)%16

 else

  if(cursed)tear(curr_page)
	 if(curr_page.i)curr_page:dis_logo()
	 if(curr_page.vfx)curr_page:vfx()
	 if not fullscreen then
   spr(1,120,0) -- bookmark
	  sspr(18,7,11,15,110,-1,11,15)
	 end
	 if(cursed)glitch()
	 for cvfx in all(cam_vfx) do
	  cvfx(curr_page)
	 end
	
  if not fullscreen then
 	 curr_page:dis_title()
 	 curr_page:dis_text()
	  curr_page:dis_choices()
	 end
	 
	 -- debug
	 for i=1,#debug do
	  ?"\^#"..tostr(debug[i]),0,0+8*i,15
	 end
	 
	end

 for i=1,anti_doom do
  pset(rnd(128),rnd(128),rnd({0,15}))
 end


end

function dis_title(page)
	?"\^#"..page.title,0,0,15
 -- ?"🐱: "..dt,0,123,15
end

function dis_logo(page)
 if fullscreen then
  page.logo:draw(0,0,128,128)
 else
  clip(0,8,128,32)
  page.logo:draw(0,8,128,32)
 end
 clip()
end

function dis_text(page)
 if(page.text)?"\^#"..page.text,0,48,15
end

function butt_press()
 ?butt_key[pressed],butt_pos[pressed][1],butt_pos[pressed][2],0
 pc+=1
 if(pc>6)pc=0pressed=nil
end

function dis_choices(page)
 local c⬆️=page.choices[⬆️]
 local c⬇️=page.choices[⬇️]
 local c⬅️=page.choices[⬅️]
 local c➡️=page.choices[➡️]
	
 -- print o button
 sspr(24+obutt_ani%8*8,0,8,8,60,109,7,7)

 if side%2==0 then  -- display the options
  if c⬆️ then
   ?butt_key[⬆️],butt_pos[⬆️][1],butt_pos[⬆️][2],15
   ?"\^#"..c⬆️.title,hcenter(c⬆️.title,64),98,15
  end
  if c⬇️ then
   ?butt_key[⬇️],butt_pos[⬇️][1],butt_pos[⬇️][2],15
   ?"\^#"..c⬇️.title,hcenter(c⬇️.title,64),122,15
  end
  if c⬅️ then
   ?butt_key[⬅️],butt_pos[⬅️][1],butt_pos[⬅️][2],15
   ?"\^#"..c⬅️.title,hcenter(c⬅️.title,28),110,15
  end
  if c➡️ then
   ?butt_key[➡️],butt_pos[➡️][1],butt_pos[➡️][2],15
   ?"\^#"..c➡️.title,hcenter(c➡️.title,100),110,15
  end


  -- if there are no options, what do?
  if (not (c⬆️ or c⬇️ or c⬅️ or c➡️)) then
   chk_poc_msg="-press- ❎/x to trace your steps"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),98,15
   chk_poc_msg="=hold= 🅾️/c/z for inventory"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),122,15
  end

  if page.choices[pressed] then
   butt_press()
  end

 else -- display the inventory

  rect(0,96,126,126,15)
  rect(1,97,127,127,15)

  if inventory["open mind"] then
   inv_chs[⬇️]=ch_look_around
   ?butt_key[⬇️],butt_pos[⬇️][1],butt_pos[⬇️][2],15
   ?"\^#"..inv_chs[⬇️].title,hcenter(inv_chs[⬇️].title,64),122,15
  end

  if inventory["blank card"] then
   inv_chs[➡️]=ch_read_card
   ?butt_key[➡️],butt_pos[➡️][1],butt_pos[➡️][2],15
   ?"\^#"..inv_chs[➡️].title,hcenter(inv_chs[➡️].title,100),110,15
  end

  if inventory["guided tour"] then
   inv_chs[⬆️]=ch_gt
   ?butt_key[⬆️],butt_pos[⬆️][1],butt_pos[⬆️][2],15
   ?"\^#"..inv_chs[⬆️].title,hcenter(inv_chs[⬆️].title,64),98,15
  end

  if inventory["instant camera"] then
   inv_chs[⬅️]=ch_photo
   ?butt_key[⬅️],butt_pos[⬅️][1],butt_pos[⬅️][2],15
   ?"\^#"..inv_chs[⬅️].title,hcenter(inv_chs[⬅️].title,28),110,15
  end

  if inv_chs[pressed] then
   butt_press()
  end
 end
end

function glitch()
 local on=(t()*4.0)%13<0.1
 local gso=on and 0 or rnd(0x1fff)\1
 local gln=on and 0x1ffe or rnd(0x1fff-gso)\16
 for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
 poke(a,peek(a+2),peek(a-1)+(rnd(3)))
 end
end
vfx_names[glitch]="glitch"

function dither_noise(page)
 page.cls=false
 for i=0,400do
  pset(rnd(128),rnd(128),0)
 end
end
vfx_names[dither_noise]="dither_noise"

function tear(page)
 local x1=rnd(20)+70
 local w=rnd(15)+5
 clip(x1,0,w,128)
 page.logo:draw(x1,0,w,128)
 clip()
end
vfx_names[tear]="tear"

function zoom()
 poke(0x5f54,0x60)
 sspr(0,8,128,32,1,9,126,30)
 poke(0x5f54,0x00)
end
vfx_names[zoom]="zoom"

function more_art(page)
 clip(0,37,128,60)
 if(not page.i)page.logo:init()
 page.logo:draw(0,37,128,64)
 clip()
end
vfx_names[more_art]="more_art"

function newsy(page)
 for i=1,14do pal(i,rnd({7,6,7,6,5,0}),1)end
 dither_noise(page)
end
vfx_names[newsy]="newsy"

function dg_newsy(page)
 for i=1,14do pal(i,rnd({-8,8,-8,-8,2,-14,0}),1)end
 dither_noise(page)
end
vfx_names[dg_newsy]="dg_newsy"

function fount_fx()
 pal(rnd(13)+1,rnd({0,7}),1)
end
vfx_names[fount_fx]="fount_fx"

-- pages

function add_text(p_name, text)
add(lib[p_name].texts,text)
end


-- debug page
p_debug="debug page"
lib[p_debug]=new_page(
p_debug, 
"you're not even supposed\nto be here!!!\n\n    - albert einstein"
)
lib[p_debug].logo=ideocart_logo
lib[p_debug].seed=42069
add_text(p_debug,"yeah this is a test")
add_text(p_debug,"yeah this is *also* a test")
lib[p_debug].cb=function()
inventory["blank card"]=true
inventory["open mind"]=true
inventory["guided tour"]=true
inventory["instant camera"]=true
end

-- breach page
p_breach="containment_breach"
lib[p_breach]=new_page(
p_breach,
""
)
lib[p_breach].vfx=tear
lib[p_breach].logo=dg_logo
lib[p_breach].cb=function()
 inventory["cursed"]=true
 lib[p_breach].seed=rnd(-1)
end
lib[p_breach].music="dead god"
add_text(p_breach,"it's coming for you now.")
add_text(p_breach, "remember: 127402")

-- landing page
title="the trace gallery"
lib[title]=new_page(
title, 
"you find yourself looking at the\nstrange digital cosmology of \nthe trace, once again.\n\nyou swore you would give up.\n"
)
lib[title].seed=1
-- lib[title].logo=dg_logo
add_text(title,
"a game by aebrer\n\nwith music/sfx by carson kompon"
)

-- second page
tsp="the second page"
lib[tsp]=new_page(
tsp, 
"in this piece the artist\nintended to create an atmosphere\nof ominous intent.\n\nthis is your last chance to stop.\n\nexpect flashing lights."
)
--lib[tsp].vfx=dither_noise
lib[tsp].vfx=glitch
add_text(tsp,
"it suggets that one needs\nto pay attention to the text.\nyou can't always tell\nwhat is true and what\nis merely screaming."
)


-- the open concept
toc="the open concept"
lib[toc]=new_page(
toc,
"the foyer stretches\nfar deeper than you realize\nand invites you in\n"
)
add_text(toc, "yeah it's a haiku.")

-- another dead end
ade="another dead end"
lib[ade]=new_page(
ade,
"you didn't think it would\nbe that easy, did you?\n"
)
lib[ade].vfx=dither_noise
add_text(ade,
"most people don't even find\ntheir way to this page.\ncongratulations!"
)


-- engineering regret
engreg="engineering regret"
lib[engreg]=new_page(
engreg,
"the artist is present\nin this work.\n\ncan't you feel it?\n"
)
add_text(engreg,
"someone had to have made\nthis thing... it can't just\nexist on its own... right?"
)


-- read_card
read_card="reading the future"
lib[read_card]=new_page(
read_card,
"now you have to make a choice...\nwhat's 0n the card?"
)
lib[read_card].cb=function()
 if rnd()>0.995 then
  seed_rnd()
  lib[read_card].choices[⬅️]=ch_a_threat
  lib[read_card].choices[⬆️]=ch_just_art
  lib[read_card].choices[➡️]=ch_news_report
  if cursed then 
   lib[read_card].choices[⬇️]=ch_dont_read
  end
 end
end
lib[read_card].vfx=glitch
add_text(read_card,
"you know, there's a way to\nreset this card.\n\nthere's always more to explore."
)



-- cursed card
p_curse="what were you thinking"
lib[p_curse]=new_page(
p_curse,
"i specifically said not to read\nthis card. did no one tell you\nhow this works? are you alone?\n\nit doesn't matter.\no.k. done! enjoy your curse."
)
add_text(p_curse,
"this isn't the only way to get\ncursed, but it is a safer way."
)


-- threat card
p_threat="i know what you want"
lib[p_threat]=new_page(
p_threat,
"you think i don't know why\nyou came here? i know.\n\nyou won't find it, no matter\nhow hard you look.\n"
)
add_text(p_threat,
"don't listen to him, we're\nnot all that bitter in here."
)

-- news card
p_news1="7 missing, 3 dead"
lib[p_news1]=new_page(
p_news1,
"mysteries abound today at the\ntrace gallery. after a success-\nful grand opening the second day\nquickly led to tragedy. those\nwho were present report seeing\na bright flash of red light.\n\nthe desert..."
)
lib[p_news1].vfx=newsy
add_text(p_news1,
"story continues on page 8"
)

p_news2="the desert"
lib[p_news2]=new_page(
p_news2,
"the desert opened its maw and\ntook what belonged to it.\nwe all dissolve eventually.\nthere will be no survivors.\nonly when you..."
)
lib[p_news2].vfx=dg_newsy
add_text(p_news2,
"it was like a sun\nfilling me with hypnotic\nwarmth and burning love."
)

p_news3="only when you"
lib[p_news3]=new_page(
p_news3,
"only when you look at the\nevidence, it's even more strange\n\nthere is no registered owner\nfor the trace gallery.\nwhere did it come from?\nwe contacted..."
)
lib[p_news3].vfx=newsy
add_text(p_news3,
"don't forget to like and\nsubscribe!"
)

p_news4="we contacted"
lib[p_news4]=new_page(
p_news4,
"we contacted something out here.\nor something contacted us.\nwe never should have opened\nthat door. the light that poured\nout changed everything. it fills\nyou up. i think i need help.\ni don't feel right.\nhow did i get here?"
)
lib[p_news4].vfx=dg_newsy
add_text(p_news4,
"we can't let it out...\nif that thing gets to the\nmainland, it's over for humanity."
)

p_stop_news="what the hell"
lib[p_stop_news]=new_page(
p_stop_news,
"there's something written on the\nback of the page. it says:\n'drift away until you see it'\n\nyou wonder what that means.\n\nit's in your handwriting."
)
lib[p_stop_news].vfx=dither_noise
add_text(p_stop_news,
"don't go too far!"
)

-- art card
p_art="...it matches the walls"
lib[p_art]=new_page(
p_art,nil)
lib[p_art].cb=function()if(rnd()>0.3)srand(curr_page.seed)end
lib[p_art].vfx=more_art
lib[p_art].logo=dg_logo


-- good for you
p_g4u="good for you"
lib[p_g4u]=new_page(
p_g4u,
"maybe that was a test.\ndo you ever think that?\nbut there's no one watching.\n\nyou're alone here."
)
lib[p_g4u].cb=function()
if lib[p_g4u].seed\1%17==0 then
 lib[p_g4u].choices[⬆️]=ch_statue
end
if mirror_world then 
 lib[p_g4u].choices[➡️]=ch_fount
else 
 lib[p_g4u].choices[➡️]=ch_door
end
end
lib[p_g4u].music="peaceful"
add_text(p_g4u,
"come back any time :)"
)

-- the door
p_door="mysterious door"
lib[p_door]=new_page(
p_door,
"i like you, but i can't let you\n in there...\n\nnot yet at least."
)
add_text(p_door,
"literally, you need to find all\nthe secrets first."
)
add_text(p_door,
"they say there's something\ndifferent here if you\ncan read backwards."
)

ch_door=new_choice(
"a door",
lib[p_door]
)

ch_fount=new_choice(
"a fountain",
lib[p_fount]
)



-- statue garden
statue_pages={}

function get_statue()
 local statue_seed = rnd(-1)
 local p_statue = "statue: "..statue_seed
 lib[p_statue]=new_page(
 p_statue,
 "looks like some kind of statue\ngarden. they've even painted\nthe walls to look like grass.\n\njust kidding."
 )
 lib[p_statue].logo=ideocart_logo
 lib[p_statue].i=false
 lib[p_statue].seed=statue_seed
 add_text(p_statue,
 "it's a bit of a maze."
 )
 add_text(p_statue,
 "you can track the seeds.\n\nprobably."
 )
 add_text(p_statue,
 "you're going to need to\nenvision a network with\nclose to no rules.\n\n...but be careful."
 )
  add_text(p_statue,
 "there's something in here."
 )
 lib[p_statue].cb = function()
  curr_page.title = "statue: "..curr_page.seed
 end

 return p_statue
end

-- statue pages (and odds):
n_statues=13
for i=1,n_statues do 
 statue_pages[i]=get_statue()
end
-- note... sometimes no special pages possible?

-- statue choices:
-- todo: refactor for all pages and choices

function get_statue_choice()
 local ch = new_choice(
   "next statue",
   lib[rnd(statue_pages)]
  )
 return ch
end

-- which page will be the first
ch_statue = get_statue_choice()
ch_statue.title = "statue garden?"


-- do extra pages in statue garden
p_mirror="a mirror"
lib[p_mirror] = new_page(
p_mirror,
"⬇️░█⬇️●🅾️⬇️\n⬅️☉ˇ░★"
)
add_text(p_mirror,
"real lore hidden as\nreal coded msg."
)
lib[p_mirror].cb=function()
poke(24364,5)
lib[p_mirror].logo=ideocart_logo
end
lib[p_mirror].leave_cb=function()
poke(24364,0)
end
lib[p_mirror].choices[⬅️]=new_choice(
"go back",
lib[rnd(statue_pages)]
)
lib[p_mirror].choices[➡️]=new_choice(
"go in",
lib[title],
function()
lib[p_mirror].leave_cb=function()
 mirror_world = not mirror_world
 if mirror_world then
  poke(24364,129)
  pal(0,7,1)
 else 
  poke(24364,0)
  pal(0,0,1)
 end
end
end
)
add(statue_pages,p_mirror)

-- do extra pages in statue garden
p_exit="emergency exit"
lib[p_exit] = new_page(
p_exit,
"whoa! an emergency exit?\nmaybe it's a way out.\n\nbe nice to touch grass again."
)
add_text(p_exit,
"remember we own you in here."
)
lib[p_exit].choices[⬅️]=new_choice(
"go back",
lib[rnd(statue_pages)]
)
lib[p_exit].vfx=glitch

p_hallway="a long hallway"
lib[p_hallway]=new_page(
p_hallway,
"you're in a long winding\nhallway. the wallpaper is\npeeling. it smells faintly of\nmildew."
)
add_text(p_hallway,"all these twists and turns\nare messing with your\nsense of direction.")
lib[p_hallway].ch_counter=0
lib[p_hallway].choices[➡️]=new_choice(
"keep going",
lib[p_hallway],
function()
 lib[p_hallway].ch_counter+=1
	seed_plus()
	if(rnd()>.8and lib[p_hallway].ch_counter>3)lib[p_hallway].choices[➡️]=new_choice("uh oh",lib[title])
end
)
lib[p_hallway].vfx=tear

lib[p_exit].choices[➡️]=new_choice(
"go out",
lib[p_hallway]
)
add(statue_pages,p_exit)


-- fill choices for default statues
for i=1,n_statues do 
 for ch_i=0,3 do 
  lib[statue_pages[i]].choices[ch_i]=get_statue_choice()
 end
end





-- fuck me?
fuck_me="fuck me?"
lib[fuck_me]=new_page(
fuck_me,
"fuck me? fuck me?!\nfuck you!\n\nyou're stuck here just like me.\nwe all dissolve here.\nyou're not special.\n"
)
lib[fuck_me].vfx=zoom
lib[fuck_me].music="angry"
add_text(fuck_me,
"listen here you little shit:\n\nwe. are. all. doomed.\nthe sooner you realize that\nthe better off we'll be."
)

--------------------------------
-- choices
--------------------------------

ch_breach=new_choice(
 "containment_breach",
 lib[p_breach],
 function()
  d=rnd()
  if(lib[p_breach].text)lib[p_breach].text=lib[p_breach].text.."\ncontainment_breach "..d
  if(d>.88)containment_breach()
  doom_plus()
 end
)
lib[p_breach].choices[rnd({⬆️,⬇️,➡️,⬅️})]=ch_breach



ch_debug=new_choice(
"debug choice",
lib[p_debug]
)
lib[p_debug].choices[⬅️]=ch_debug
lib[p_debug].choices[➡️]=ch_debug
lib[p_debug].choices[⬆️]=ch_breach
lib[p_debug].choices[⬇️]=ch_debug


lib[title].choices[⬅️]=new_choice(
"go inside",
lib[tsp]
)

function seed_plus()
 sfx(17, 3) --scutter sound
 curr_page.i=false
 curr_page.seed+=1
 doom_plus() 
end

function seed_rnd()
 sfx(17, 3) --scutter sound
 curr_page.i=false
 curr_page.seed=rnd(-1)
 doom_plus()
end
lib[title].choices[➡️]=new_choice(
"drift away",
nil,
seed_plus
)

lib[tsp].choices[⬅️]=new_choice(
"go back",
lib[title]
)

lib[tsp].choices[➡️]=new_choice(
"go on",
lib[toc],
no_trace
)

ch_read_card=new_choice(
 "read card",
 lib[read_card],
 function()
  if cursed then 
   lib[read_card].choices[⬇️]=ch_dont_read
  end
 end
)

ch_dont_read=new_choice(
 "don't read",
 lib[p_curse],
 function()
  inventory["cursed"]=true
  lib[read_card].choices[⬅️]=ch_a_threat
  lib[read_card].choices[⬆️]=ch_just_art
  lib[read_card].choices[➡️]=ch_news_report
  if cursed then 
   lib[read_card].choices[⬇️]=ch_dont_read
  end
 end
)

ch_look_around=new_choice(
"look around",
nil,
function() 
 local chk=rnd()
 if chk>0.8 then
  if not inventory["blank card"] then 
   reset_text()
   if(curr_page.text)curr_page.text = curr_page.text.."\n🅾️ you find a small blank card\nand pocket it. ➡️"
   inventory["blank card"]=true
  end
 end

 if chk<0.01 then
  local ch=get_statue_choice()
  ch.title="statue garden?"
  curr_page.choices[rnd({⬆️,⬇️,⬅️,➡️})]=ch
 end
 
 if chk<.66 and chk>=.6 then
  if not inventory["guided tour"] then
  	inventory["guided tour"]=true
  	reset_text()
  	if(curr_page.text)curr_page.text=curr_page.text.."\n🅾️ you suddenly realize you've\nbeen hearing a voice...\nsome kind of tour? ⬆️"
 	end
 end
 
 if chk<.44 and chk>=.4 then
  if not inventory["instant camera"] then
   inventory["instant camera"]=true
   reset_text()
   if(curr_page.text)curr_page.text=curr_page.text.."\n🅾️ you just noticed an\ninstant film camera laying\non the ground! ⬅️"
  end
 end

 seed_rnd()
end
)
lib[toc].choices[⬇️]=ch_look_around
lib[toc].choices[⬅️]=new_choice(
"go back",
lib[ade]
)
lib[toc].choices[➡️]=new_choice(
"deep breaths",
lib[engreg]
)

function reset_text()
 curr_page.text=curr_page.texts[curr_page.text_i]
end

ch_gt=new_choice(
"guided tour",
nil,
function()
 sfx(49, 3) --page turn sound
 cls()
 doom_plus()
 curr_page.text_i=(curr_page.text_i+1)%(#curr_page.texts+2)
 reset_text()
end
)

ch_photo=new_choice(
"take photo",
nil,
function()
 sfx(29, 3) --camera shutter sound
 doom_plus()
 extcmd("video")
 add(cam_vfx,curr_page.vfx)
 if(#cam_vfx>3)deli(cam_vfx,1)
end
)


ch_a_threat=new_choice(
"a threat",
lib[p_threat],
function()
 if not inventory["cursed"] then
  for i in all({➡️,⬆️,⬇️}) do
  	lib[read_card].choices[i]=nil
  end
 end
end
)
lib[read_card].choices[⬅️]=ch_a_threat


ch_just_art=new_choice(
"just art",
lib[p_art],
function()
 if not inventory["cursed"] then
  for i in all({➡️,⬅️,⬇️}) do
  	lib[read_card].choices[i]=nil
  end
 end
end
)
lib[read_card].choices[⬆️]=ch_just_art


ch_news_report=new_choice(
"news report",
lib[p_news1],
function()
 if not inventory["cursed"] then
  for i in all({⬆️,⬅️,⬇️}) do
   lib[read_card].choices[i]=nil
  end
 end
end
)
lib[read_card].choices[➡️]=ch_news_report


lib[p_news1].choices[➡️]=new_choice(
"keep reading",
lib[p_news2]
)

lib[p_news2].choices[➡️]=new_choice(
"keep reading",
lib[p_news3]
)
lib[p_news3].choices[➡️]=new_choice(
"keep reading",
lib[p_news4]
)

ch_stop_reading=new_choice(
"stop reading",
lib[p_stop_news]
)
lib[p_news1].choices[⬅️]=ch_stop_reading
lib[p_news2].choices[⬅️]=ch_stop_reading
lib[p_news3].choices[⬅️]=ch_stop_reading
lib[p_news4].choices[⬅️]=ch_stop_reading


lib[p_art].choices[⬇️]=ch_look_around
lib[p_art].choices[⬇️].text="look inside"

lib[p_threat].choices[⬆️]=new_choice(
"fuck you",
lib[fuck_me]
)

lib[p_threat].choices[⬅️]=new_choice(
"ignore it",
lib[p_g4u]
)

lib[p_g4u].choices[⬇️]=ch_look_around

-- music

function music_start(_reset)
	_reset = _reset or false
	if(_reset) music_reset()
	music(0)
end

function music_stop()
	lastmusicpat = stat(54)
	music(-1)
end

function music_resume()
	if lastmusicpat then
		music(lastmusicpat)
	else
		music_start()
	end
end

function music_reset()
	reload(0x3200, 0x3200, 0x10ff)
end

function music_state(_state)
	music_reset()
	if _state == "angry" then
		--angry
		swap_sfx(8,18)
		swap_sfx(9,19)
		swap_sfx(11,20)
		swap_sfx(13,21)
	elseif _state == "dead god" then
		--demon/dead god
		swap_sfx(8,22)
		swap_sfx(9,23)
		swap_sfx(11,24)
		swap_sfx(13,25)
		
		swap_sfx(12,26)
		swap_sfx(14,27)
		swap_sfx(15,28)
	elseif _state == "peaceful" then
		--peaceful/happy
		swap_sfx(10,34)
		swap_sfx(8,30)
		swap_sfx(9,31)
		swap_sfx(11,32)
		swap_sfx(13,33)
		
		swap_sfx(12,35)
		swap_sfx(14,36)
		swap_sfx(15,37)
	end
end

sfxaddr = 0x3200

-- the following is inspired by
-- https://www.lexaloffle.com/bbs/?tid=31326
-- credits to kittenm4ster
function swap_sfx(_a, _b)
	local _addr1 = 68 * _a
	local _addr2 = 68 * _b
	local _tmp = 0x4300
	local _len = 68
	
	memcpy(_tmp,sfxaddr+_addr1,_len)
	memcpy(sfxaddr+_addr1,sfxaddr+_addr2,_len)
	memcpy(sfxaddr+_addr2,_tmp,_len)
end

-- containment breach

function containment_breach()

 -- original source
 -- https://teia.art/objkt/127402
 -- modified here (but not optimized)

 music(61)
 music_state("dead god")
 fillp(█)
 palt(0,false)
 pal()
 cls()
 camera(-64,-64)
 seed=rnd(-1)
 srand(seed)
 
 dither_modes = {
  "mixed",
  "burn_rect",
  "burn",
  "rect"
 } 
 dither_prob = 0.35
 dither_mode="burn"
 n_dither_modes = #dither_modes

 colors = {0,7,0,7,-3,2,-8,8}

 pal(colors,0)

 function draw_noise(amt)
  for i=0,amt*amt*amt do
   poke(0x6000+rnd(0x2000), peek(rnd(0x7fff)))
   poke(0x6000+rnd(0x2000),rnd(0xff))
  end
 end

 function draw_glitch(gr)
  local on=(t()*4.0)%gr<0.1
  gso=on and 0 or rnd(0x1fff)\1
  gln=on and 0x1ffe or rnd(0x1fff-gso)\16
  for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
   poke(a,peek(a+2),peek(a-1)+(rnd(3)))
  end
 end

 function vfx_smoothing()
  local pixel = rnd_pixel()
  c=abs(pget(pixel.x,pixel.y)-1) 
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
    dm = rnd(dither_modes)
   end
   dither(dm)
  elseif dm == "rect" then
   for i=1,6 do 
    local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
    local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
    --skip some nunber (12) pixels
    for x=128+fudge_x,0,-12 do
     for y=128+fudge_y,0,-12 do
      local pxl = rnd_pixel()
      if rnd(1) > dither_prob then
       rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,colors[0])
      end
     end
    end
   end
  elseif dm == "burn" then
   for i=1,4 do 
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
   for i=1,4 do 
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
  return abs(c-1)
 end

function rnd_sign()
 if(rnd(1)>.5)return(-1)
 return(1)
end

 function undither(loops,s)
  
  for i=-loops,1 do
   local x=rnd(128)-64
   local y=rnd(128)-64
   local c=min(abs(pget(x,y)-1),4)
   circfill(x*s,y*s,3,c)
   x=rnd(128)-64
   y=rnd(128)-64
   c=min(abs(pget(x,y)-1),colors[4])
   circ(x*s,y*s,8+rnd(3),c)
   circ(x*s,y*s,13+rnd(5),c)
   x=rnd(128)-64
   y=rnd(128)-64
   c=min(abs(pget(x,y)-1),colors[4])
   pset(x*s,y*s,c)
   -- circfill(x,y,2,c)
  end
 end

 seed_reset_needed = false

 function _update60()
  local loop_len =10
  local loop = flr(t())%loop_len == 0
  local srf = flr(t())%(loop_len/2) == 0
  local r = t()/loop_len
  local x,y=0,0

  if srf and seed_reset_needed then
   srand(seed)
   seed_reset_needed = false
  elseif not srf and not seed_reset_needed then
   seed_reset_needed = true
  end

  for i=0,20 do
   x=sin(r+i)*(20+(i*rnd(3)+1))
   y=(cos(r+i)*sin(r+i))*(20+(i*rnd(3)+1))
   
   pset(x*flr(rnd(3)+1),y,8)
   pset(-x*flr(rnd(3)+1),y,8)
   pset(x*flr(rnd(3)+1),-y,8)
   pset(-x*flr(rnd(3)+1),-y,8)

   pset(x/flr(rnd(3)+1),y*i,8)
   pset(-x/flr(rnd(3)+1),y*i,8)
   pset(x/flr(rnd(3)+1),-y*i,8)
   pset(-x/flr(rnd(3)+1),-y*i,8)

  end
  
  draw_noise(0.5)
  dither(dither_mode)
  undither(10,0.3)
  for i=-15,1 do
    x=5*sin(r)*cos(r)+max(5,rnd(14)+5)
    y=-5*sin(r)-min(-14,rnd(14)-14-5)
   oval(
    -x,-y,x,y,
    colors[0]
   )
  end

  for i=-2,1 do
   x=(5+rnd(30))*sin(r)*cos(r)+max(5,rnd(14)+5)
   y=(-5-rnd(30))*sin(r)-min(-14,rnd(14)-14-5)
   oval(
    -x,-y,x,y,
    colors[0]
   )
  end
  pal(colors,1)
 end

 function _draw()end

end
__gfx__
0000000000fffff000fffff000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000000000000000000000000000000000
0000000000fffff000f000f00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00000000000000000000000000000000000000000
0070070000fffff000f000f0ff0000ffff0ff0ffff00ffffff00ffffff00fffffff0ffffffffffffff0000ff0000000000000000000000000000000000000000
0007700000fffff000f000f0ff0ff0ffff0ff0ffff0fffffff0fffffff0ffffffffffffffff00fffff0000ff0000000000000000000000000000000000000000
0007700000fffff000f0f0f0ff0ff0ffff0ff0ffff0ff0ffff0ffffffffffffffffffffffff00fffff0000ff0000000000000000000000000000000000000000
0070070000ff0ff000ff0ff0ff0000ffff0000ffff0000ffff00ffffffffffffffffffffffffffffff0000ff0000000000000000000000000000000000000000
0000000000f000f000f000f00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00000000000000000000000000000000000000000
00000000000000000000000000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000000000000000000000000000000000
fff0000000000000000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f0fff00f000f00f0f00000f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff0f0f0f0f0f00f00f0f0f0f0ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f000f000f0000f00f0f00f00fffff000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f000f0000ff0f00f00f0f0f0f0ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000f00000f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77707070777000007770777077700770777000000770777070007000777077707070000000000000000000000000000000000000000000077777000000777770
07007070700000000700707070707000700000007000707070007000700070707070000000000000000000000000000000000000000000700000707000777770
07007770770000000700770077707000770000007000777070007000770077007770000000000000000000000000000000000000000000707070707700777770
07007070700000000700707070707000700000007070707070007000700070700070000000000000000000000000000000000000000000700700777770777770
07007070777000000700707070700770777000007770707077707770777070707770000000000000000000000000000000000000000000707070707700777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000707000770770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777000000700070
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000008000p000500020002000v0500000000000005000000020p0v050000000000000000020p0v00000008020p0v05000200000p000500020800000v0500020
500020002000v00000008000p0000000208020p0v0000020800000000000208020p0v0500000000050002000000000000000802000v00000000020p000000000
0000008000p000500020002000v0500000000000005000000020p0v050000000000000000020p0v00000008020p0v05000200000p000500020800000v0500020
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000020000080p0000000v00080p0000000v0000000500020000000p00020000080p0502020000000p000200000008000502000v00000p000000000
20v00080p0502000v000000050202000000000502020000080p0002000v0008000500020000000000000v0008000500020v00000p000002000008000502020v0
0000000000000020000080p0000000v00080p0000000v0000000500020000000p00020000080p0502020000000p000200000008000502000v00000p000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000500000200000005080v020p000005000v000p000200080v020p00020508000000000v020p00020008000000000200000002000002050800020p000000000
00200080v000p000200000000000002000800020000000500000000000000000v020508000000000005000v020p000005080v000p000000000v0000000205080
0000500000200000005080v020p000005000v000p000200080v020p00020508000000000v020p00020008000000000200000002000002050800020p000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000800000000000v080502000p0000000000000p000v080000000000000p02000800020000000v080500000p020v080500000p0000000000000p020000050
p020v000502000p02000000000000020v08050200000200000502000p020v00000v000500000p0200000002000000000000020000020v0805020000000v08000
000000800000000000v080502000p0000000000000p000v080000000000000p02000800020000000v080500000p020v080500000p0000000000000p020000050
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000008000v0202050p000000000205000000000002050000000000020200000800000002000008000v0200000p0000000200050p08000v0002050p08000v000
0050p0000000000000008000v0200000p08000v0200000p08000v020000050p00000v0200050p0000000002050008000v0002000000000002000000000000020
2000008000v0202050p000000000205000000000002050000000000020200000800000002000008000v0200000p0000000200050p08000v0002050p08000v000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
v0p0200020005000p0208020000000p000800000500000200000000000500000200020000000000080000050v0000000200000v0002080200000000020000000
00000080000000v0000000000050v0002000200000v0p000802080200000v0p00080000050v0p0200020000000p0208000005000p00000000050v0p000802000
v0p0200020005000p0208020000000p000800000500000200000000000500000200020000000000080000050v0000000200000v0002080200000000020000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700770707000007770777077007700000070700770707077700770777070007770000070000770077070707770770007700000777077700000777070707770
70707070707000007000070070707070000070707070707070707000700070007000000070007070707070700700707070000000707007000000070070707000
77707070707000007700070070707070000077707070707077007770770070007700000070007070707077000700707070000000777007000000070077707700
00707070707000007000070070707070000000707070707070700070700070007000000070007070707070700700707070700000707007000000070070707000
77707700077000007000777070707770000077707700077070707700777077707000000077707700770070707770707077700000707007000000070070707770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707770777077707700077077700000770077700770777077707770700000000770077007707770077070000770077070700000077077700000000000000000
70000700707070707070700070000000707007007000070007007070700000007000707070007770707070007070700070700000707070000000000000000000
77700700770077707070700077000000707007007000070007007770700000007000707077707070707070007070700077700000707077000000000000000000
00700700707070707070707070000000707007007070070007007070700000007000707000707070707070007070707000700000707070000000000000000000
77000700707070707070777077700000777077707770777007007070777000000770770077007070770077707700777077700000770070000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707070777000007770777077700770777000000000077077000770777000007770077077707770770000000000000000000000000000000000000000000000
07007070700000000700707070707000700000000000707070707000700000007070700070700700707000000000000000000000000000000000000000000000
07007770770000000700770077707000770000000000707070707000770000007770700077700700707000000000000000000000000000000000000000000000
07007070700000000700707070707000700007000000707070707000700000007070707070700700707000000000000000000000000000000000000000000000
07007070777000000700707070700770777070000000770070700770777000007070777070707770707007000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700770707000000770707007707770777000007070077070700000707007707070700077000000077077707070777000007070777000000000000000000000
70707070707000007000707070707070700000007070707070700000707070707070700070700000700007007070700000007070707000000000000000000000
77707070707000007770707070707700770000007770707070700000707070707070700070700000700007007070770000007070777000000000000000000000
00707070707000000070777070707070700000000070707070700000777070707070700070700000707007007770700000007070700000000000000000000000
77707700077000007700777077007070777000007770770007700000777077000770777077700000777077700700777000000770700007000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000
00000000000770077000007770770007707770770077700000000007777707777707777700000000770077707770777077700000777070707770707000000000
00000000007000707000000700707070000700707070000000000077700777000777007770000000707070700700700007000000707070707070707000000000
00000000007000707000000700707077700700707077000000000077000777070777000770000000707077000700770007000000777070707770777000000000
00000000007070707000000700707000700700707070000000000077700777000777007770000000707070700700700007000000707077707070007000000000
00000000007770770000007770707077007770777077700000000007777707777707777700000000777070707770700007000000707077707070777000000000
00000000000000000000000000000000000000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
010100200015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150
7d0100200015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150
010100200055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
093000200015400150001500015000140001300012000110001540015000150001500014000130001200011000154001500015000150001400013000120001100015400150001500015000140001300012000110
093000200015400150001500015000140001300012000110001540015000150001500014000130001200011005154051500515005150051400513005120051100415404150041500415004140041300412004110
011800200c033000330c615006150c6330061500000006150c000000130c615006150c633006150c615006150c033000330c615006150c6330061500000006150c000000130c615006150c633006150c61500615
091800201885418850188501885018850188501885018850188401884018830188301882018820188101881015854158501585015850158501585015850158501584015840158301583015820158201581015810
d5180000135120000200000000020c51200000000000000210512000020c512000021351200002000000000210512000020c51200002155120000210512000000000000002155120000210512000020c51200002
091800201185411850118501185011850118501185011850118401184011830118301182011820118101181013854138501385013850138501385013850138501384013840138301383013820138201381013810
911800000c51200002000000000211512000020000000002155120000211512000020c5120000200000000020e51200002175120000213512000020e51200002000000000213512000020e512000021751200002
91180010135120000200000000020c5120000200000000021051200002000000000213512000020000000002185121f5121c5121f512185121f5121c5121f512155021c502185021c502155021c502185021c502
000400002c4302c410033000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
010800001b6451b645146250060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
713000201885418850188501885018840188301882018810188541885018850188501884018830188201881018854188501885018850188401883018820188101885418850188501885018840188301882018810
71300020188541885018850188501884018830188201881018854188501885018850188401883018820188101d8541d8501d8501d8501d8401d8301d8201d8101c8541c8501c8501c8501c8401c8301c8201c810
711800201885418850188501885018850188501885018850188401884018830188301882018820188101881015854158501585015850158501585015850158501584015840158301583015820158201581015810
711800201185411850118501185011850118501185011850118401184011830118301182011820118101181013854138501385013850138501385013850138501384013840138301383013820138201381013810
d13000200c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c910
d13000200c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c91011954119501195011950119401193011920119101095410950109501095010940109301092010910
d11800200c9540c9500c9500c9500c9500c9500c9500c9500c9400c9400c9300c9300c9200c9200c9100c91009954099500995009950099500995009950099500994009940099300993009920099200991009910
d11800200595405950059500595005950059500595005950059400594005930059300592005920059100591007954079500795007950079500795007950079500794007940079300793007920079200791007910
91180000131120c1020c1000c1020c1120c1000c10000102101120c1020c1120c102131120c1020c1000c102101120c1020c1120c102151120c102101120c1000c1000c102151120c102101120c1020c1120c102
911800000c1120c1020c1000c102111120c1020c1000c102151120c102111120c1020c1120c1020c1000c1020e1120c102171120c102131120c1020e1120c1020c1000c102131120c1020e1120c102171120c102
91180010131120c1020c1000c1020c1120c1020c1000c102101120c1020c1000c102131120c1020c10000102181121f1121c1121f112181121f1121c1121f112151021c102181021c102151021c102181021c102
00080000336571b61700607336571d6172460724607246071d6071d60718607186071860718607186071860700607006070060700607006070060700607006070060700607006070060700607006070060700607
093000200055400550005500055000540005300052000510005540055000550005500054000530005200051000554005500055000550005400053000520005100055400550005500055000540005300052000510
093000200055400550005500055000540005300052000510005540055000550005500054000530005200051005554055500555005550055400553005520055100455404550045500455004540045300452004510
0918002018a5418a5018a5018a5018a5018a5018a5018a5018a4018a4018a3018a3018a2018a2018a1018a1015a5415a5015a5015a5015a5015a5015a5015a5015a4015a4015a3015a3015a2015a2015a1015a10
0918002011a5411a5011a5011a5011a5011a5011a5011a5011a4011a4011a3011a3011a2011a2011a1011a1013a5413a5013a5013a5013a5013a5013a5013a5013a4013a4013a3013a3013a2013a2013a1013a10
011800200c03300000000000c0330c6330000000000006150c000000000c615000000c633000000c615000000c03300000000000c0330c6330000000000006150c000000000c615000000c633000000c61500000
911800001f415184151f415184051f4151840518415184051c4151840518415184051f4151840518405184051c41521415184151840521415184051c41518405184051840521415184051c415184051841518405
91180000184151840518405184051d41518405184051840521415184051d41518405184151840518405184051a4151840523415184051f415184051a415184051840518405234151f4151a415184052341518405
911800101f415184051f41518405184151840518415184051c415184051c415184051f415184051f41500405184151f4151c4151f415184151f4151c4151f415154051c405184051c405154051c405184051c405
010800001b1231b635006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000000000000
010800001b6340f123006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600000000000000000
010800001b6340f1231b1231b13400600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600000000000000000
910800000c11300124001140060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
910800000c12300134001240060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
910800000c13300144001340060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
490800000c14300154001440060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
010800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
090800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
0d0800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
150800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
00040000276112d6310060132641116510d631006011a6210d6110a6310c611006010060100601006010060100601006010060100601006010060100601006010060100601006010060100601006010060100601
__music__
01 08424344
01 090a4b44
00 090a4b44
01 0b0a0c44
00 0d0a0e44
00 0b0a0c44
00 0d0a0e44
00 080a0f44
02 090a4b44
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 08464344
00 094a4344
02 094a4344

