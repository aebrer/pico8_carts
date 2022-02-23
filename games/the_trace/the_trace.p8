pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- init

-- todo

-- - put some mirror ideocartography somewhere

-- - new logo like burning gate

-- - "ignore it" path as good path to remove doom
--   dt*=0.9 for each right answer
--   use voght kompff test from blade runner

--!!
debug_mode=true
--!!

lib={} -- library of all pages: title,page
inventory={} -- player inventory
inv_chs={}
cursed=false
curr_page=nil -- current page
prev_page=nil -- previous page
bkmk=nil -- bookmark a page
debug={}  -- list of things to print for debug
pressed=nil -- if a button was pressed
pc=0  -- timer for button press
butt_pos={}
butt_pos[⬆️]={60,104}
butt_pos[⬇️]={60,116}
butt_pos[⬅️]={54,110}
butt_pos[➡️]={66,110}
dt=0 -- doom timer
dtm=1024
obutt_ani=0
side=0
seed_reset_needed=true
cam_vfx={}
logos={}

-- logos
v9_static = {}
function v9_static.init(self)
 fillp(rnd({▥,█,▤}))
 curr_page.cls=true
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
	for x=self.g+x1,self.g+x1+w,self.z do for y=self.g+y1,self.g+y1+h,self.w do
 circ(x,y,rnd(2),x*y%self.c)end end
end
add(logos,v9_static)

dg_logo = {}
function dg_logo.init(self)
 fillp(rnd({▥,█,▤}))
 curr_page.cls=false
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
end

function dg_logo.draw(self,x1,y1,w,h)
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
 fillp(█)
 poke(0x5f54,0x00)
 srand(curr_page.seed)
end
add(logos,ideocart_logo)



function _init() 
	music_start(true)
 cls()
 -- set current page to landing page
	curr_page=lib[title]
 if(debug_mode)curr_page=lib[p_debug]music_stop()
 bkmk=curr_page
end
-->8
-- update
function _update60()
-- srand(rnd(-1))
 if(curr_page.cls)cls()
 -- do the init for all pages
 if not curr_page.i then 
  curr_page.dc=dc()
 	if curr_page.dc then
  	pal(15,-8,1)
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
 		pal(15,7,1)
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
 if(bkmk and bkmk.cb)bkmk:cb()
  
 -- check inputs for choices
 for b in all({⬆️,⬇️,⬅️,➡️}) do
	 if btnp(b) then
	  pressed=b
	  
   if side%2==0 then -- choices

    if curr_page.choices[b] then
 				-- callback for this choice 
     if(curr_page.choices[b].cb)curr_page.choices[b]:cb()
     -- callback for any choice
     if(curr_page.leave_cb)curr_page:leave_cb()
 		  if curr_page.choices[b].page then
 		  	sfx(16, 3) -- select option sound
      local target=curr_page.choices[b].page
      curr_page:on_leave()
 		  	prev_page=curr_page
 		  	curr_page=target
 		  	curr_page.i=false

 		  end
 	  end

   else  -- inventory
    if inv_chs[b] then
     inv_chs[b]:cb()
     if(curr_page.leave_cb)curr_page:leave_cb()
     if inv_chs[b].page then
      sfx(16, 3) -- select option sound
      local target=inv_chs[b].page
      curr_page:on_leave()
      prev_page=curr_page
      curr_page=target
      curr_page.i=false
     end
    end
    if (not (inv_chs[⬆️] or inv_chs[⬇️] or inv_chs[⬅️] or inv_chs[➡️])) then
     goto_prev_page()
    end
   end
  end
 end
 
 -- set bookmark
 if (bkmk and btnp(❎)) then 
  if curr_page==bkmk then 
   sfx(39, 3) -- remove bookmark sound
   bkmk=nil
  else
   sfx(40, 3) -- goto bookmark sound
   if(curr_page.leave_cb)curr_page:leave_cb()
   curr_page:on_leave()
   prev_page=curr_page
   curr_page=bkmk
   curr_page.i=false
  end
  
 elseif btnp(❎) then
  sfx(38, 3) -- place bookmark sound
  bkmk=curr_page
 end

 if btnp(🅾️) then
  sfx(41+obutt_ani%8,3)
  obutt_ani+=1
  if(obutt_ani%8==0)side+=1cls()
  doom_plus()
 end
end

function goto_prev_page()
 if prev_page then
  curr_page:on_leave()
  old_page=curr_page
  curr_page=prev_page
  curr_page.i=false
  prev_page=old_page
  if(curr_page.leave_cb)curr_page:leave_cb()
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

-->8
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
-->8
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

butt_key={[0]="⬅️","➡️","⬆️","⬇️"}
-->8
-- draw
function _draw()
 
 if(curr_page.i)curr_page:dis_logo() 
 if(curr_page.vfx)curr_page:vfx()
 if(bkmk and bkmk.vfx)bkmk:vfx() 
 if(bkmk)spr(2,120,0)
 if(curr_page==bkmk)spr(1,120,0)
 if(cursed)glitch()tear(lib[title])

 for cvfx in all(cam_vfx) do
  cvfx(curr_page)
 end

 curr_page:dis_title()
 curr_page:dis_text()
 curr_page:dis_choices()
 
 -- debug
 for i=1,#debug do
  ?"\^#"..tostr(debug[i]),0,0+8*i,15
 end
end

function dis_title(page)
	?"\^#"..page.title,0,0,15
 -- ?"🐱: "..dt,0,123,15
end

function dis_logo(page)
 clip(0,8,128,32)
 page.logo:draw(0,8,128,32)
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
   chk_poc_msg="press ❎/x to use bookmark"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),98,15
   chk_poc_msg="hold 🅾️/c/z to check pockets"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),122,15
  end

  if page.choices[pressed] then
   butt_press()
  end

 else -- display the inventory

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

  if (not (inv_chs[⬆️] or inv_chs[⬇️] or inv_chs[⬅️] or inv_chs[➡️])) then
   chk_poc_msg="choose nothing to forget"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),122,15
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

function dither_noise(page)
 page.cls=false
 for i=0,400do
  pset(rnd(128),rnd(128),0)
 end
end

function tear(page)
 local x1=rnd(20)+70
 local w=rnd(15)+5
 clip(x1,0,w,128)
 page.logo:draw(x1,0,w,128)
 clip()
end

function zoom()
 poke(0x5f54,0x60)
 sspr(0,8,128,32,1,9,126,30)
 poke(0x5f54,0x00)
end

function more_art(page)
 clip(0,37,128,64)
 page.logo:draw(0,37,128,64)
 clip()
end

function newsy(page)
 for i=1,14do pal(i,rnd({7,6,7,6,5,0}),1)end
 dither_noise(page)
end

function dg_newsy(page)
 for i=1,14do pal(i,rnd({-8,8,-8,-8,2,-14,0}),1)end
 dither_noise(page)
end

-->8
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


-- landing page
title="the trace gallery"
lib[title]=new_page(
title, 
"you find yourself looking at the\nstrange digital cosmology of \nthe trace, once again.\n\nyou swore you would give up.\n"
)
lib[title].seed=1
lib[title].vfx=function()sspr(18,7,11,15,110,-1,11,15)end
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
-- lib[toc].vfx=tear

-- another dead end
ade="another dead end"
lib[ade]=new_page(
ade,
"you didn't think it would\nbe that easy, did you?\n"
)
lib[ade].vfx=dither_noise

-- engineering regret
engreg="engineering regret"
lib[engreg]=new_page(
engreg,
"the artist is present\nin this work.\n\ncan't you feel it?\n"
)
lib[engreg].vfx=tear

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

-- cursed card
p_curse="what were you thinking"
lib[p_curse]=new_page(
p_curse,
"i specifically said not to read\nthis card. did no one tell you\nhow this works? are you alone?\n\nit doesn't matter.\no.k. done! enjoy your curse."
)

-- threat card
p_threat="i know what you want"
lib[p_threat]=new_page(
p_threat,
"you think i don't know why\nyou came here? i know.\n\nyou won't find it, no matter\nhow hard you look.\n"
)


---------------------------------------
-- warning card
p_warn="hey, listen"
lib[p_warn]=new_page(
p_warn,
"you shouldn't be here.\nthis isn't a place for humans.\n\ndo you know what you're\nlooking for?\n"
)
---------------------------------------

-- warning card
p_news1="7 missing, 3 dead"
lib[p_news1]=new_page(
p_news1,
"mysteries abound today at the\ntrace gallery. after a success-\nful grand opening the second day\nquickly led to tragedy. those\nwho were present report seeing\na bright flash of red light.\n\nthe desert..."
)
lib[p_news1].vfx=newsy

p_news2="the desert"
lib[p_news2]=new_page(
p_news2,
"the desert opened its maw and\ntook what belonged to it.\nwe all dissolve eventually.\nthere will be no survivors.\nonly when you..."
)
lib[p_news2].vfx=dg_newsy

p_news3="only when you"
lib[p_news3]=new_page(
p_news3,
"only when you look at the\nevidence, it's even more strange\n\nthere is no registered owner\nfor the trace gallery.\nwhere did it come from?\nwe contacted..."
)
lib[p_news3].vfx=newsy

p_news4="we contacted"
lib[p_news4]=new_page(
p_news4,
"we contacted something out here.\nor something contacted us.\nwe never should have opened\nthat door. the light that poured\nout changed everything. it fills\nyou up. i think i need help.\ni don't feel right.\nhow did i get here?"
)
lib[p_news4].vfx=dg_newsy

p_stop_news="what the hell"
lib[p_stop_news]=new_page(
p_stop_news,
"there's something written on the\nback of the page. it says:\n'drift away until you see it'\n\nyou wonder what that means.\n\nit's in your handwriting."
)
lib[p_stop_news].vfx=dither_noise

-- art card
p_art="...it matches the walls"
lib[p_art]=new_page(
p_art
)
lib[p_art].vfx=more_art
-- lib[p_art].logo=dg_logo

-- good for you
p_g4u="good for you"
lib[p_g4u]=new_page(
p_g4u,
"maybe that was a test.\ndo you ever think that?\nbut there's no one watching.\n\nyou're alone here."
)
lib[p_g4u].music="peaceful"

-- fuck me?
fuck_me="fuck me?"
lib[fuck_me]=new_page(
fuck_me,
"fuck me? fuck me?!\nfuck you!\n\nyou're stuck here just like me.\nwe all dissolve here.\nyou're not special.\n"
)
lib[fuck_me].vfx=zoom
lib[fuck_me].music="angry"

-- choices

function no_trace()
 prev_page=nil
 -- bkmk=nil
end

ch_breach=new_choice(
 "containment_breach",
 lib[p_breach],
 function()
  d=rnd()
  bkmk=nil
  prev_page=nil
  lib[p_breach].text=lib[p_breach].text.."\ncontainment_breach "..d
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
    end
   )

ch_look_around=new_choice(
"look around",
nil,
function() 
 local chk=rnd()
 if chk>0.8 then
  if not inventory["blank card"] then 
   curr_page.text = curr_page.text.."\n🅾️ you find a small blank card\nand pocket it. ➡️"
   inventory["blank card"]=true
  end
 end
 if chk<.03 then
  if not inventory["open mind"] then
  	inventory["open mind"]=true
  	if(curr_page.text)curr_page.text=curr_page.text.."\n🅾️ you're willing to look\nanywhere. but why?⬇️"
 	end
 end
 
 if chk<.66 and chk>=.6 then
  if not inventory["guided tour"] then
  	inventory["guided tour"]=true
  	if(curr_page.text)curr_page.text=curr_page.text.."\n🅾️ you suddenly realize you've\nbeen hearing a voice...\nsome kind of tour? ⬆️"
 	end
 end
 
 if chk<.44 and chk>=.4 then
  if not inventory["instant camera"] then
   inventory["instant camera"]=true
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

ch_gt=new_choice(
"guided tour",
nil,
function()
 sfx(49, 3) --page turn sound
 doom_plus()
 curr_page.text_i=(curr_page.text_i+1)%(#curr_page.texts+2)
 curr_page.text=curr_page.texts[curr_page.text_i]
end
)

ch_photo=new_choice(
"take photo",
nil,
function()
 sfx(29, 3) --camera shutter sound
 doom_plus()
 -- todo, delete when too many vfx
 add(cam_vfx,curr_page.vfx)
 if(#cam_vfx>3)deli(cam_vfx,1)
end
)


ch_a_threat=new_choice(
"a threat",
lib[p_threat],
function()
 for i in all({➡️,⬆️,⬇️}) do
 	lib[read_card].choices[i]=nil
 end
end
)
lib[read_card].choices[⬅️]=ch_a_threat


ch_just_art=new_choice(
"just art",
lib[p_art],
function()
 for i in all({➡️,⬅️,⬇️}) do
 	lib[read_card].choices[i]=nil
 end
end
)
lib[read_card].choices[⬆️]=ch_just_art


ch_news_report=new_choice(
"news report",
lib[p_news1],
function()
 for i in all({⬆️,⬅️,⬇️}) do
  lib[read_card].choices[i]=nil
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


-->8
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





-->8
-- containment breach

function containment_breach()
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
__label__
d7000000000000000000000000000000080888888888888888888888888888888888888888888888888888888888888888898888800000000000000000000000
00000000000000000000000000000000000088888888888888888888888888888888888888888888888888888888888888889888000008800000000000000000
00000000000000000000000000000000000888888888888888888888888888888888888888888888808888888888888888888888800088880000000000000000
00000000000000000000000000000000000888888888888888888888888888888888888888888888800088888888888880888888888888888000000000000000
00000000000000000000000000000000000088888888888888888888888888888888888888888888800000888888888800008888888888880000000000000000
00000000000000000000000000000000000888888888888888888888888888888888888888888888888000088888880000000888888888800000000000000000
00000000000000000000000000000000000888888888888888888888888888888888888888888888888000088888888000708888888888800000000000000000
00000000000000000000000000000000008888888888888888888888888888888888888888888888888000888888880000008888888888000000000800000000
00000000000000000000000000000000088888888888888888888888888888888888888888888888888000008888800000000888888888000000008880000000
00000000000000000000000000000008888888888888888888888888888888888888888888008888088880088888800000008888888888800000008800000000
00000000000000000000000000000088888888888888888888888888888888888888888888800800008800008888800000000888888888000000008000000000
00000000000000000000000000000008888888888888888888888888888888888888888808800000088000000088000000000000888888000000000000000000
00000000000000000000000000000000888808888888888888888888888888888888888888800000888800000000000000000000088080000000000000000000
00000000000000000000008880800808888000888888888888008888888888888888888888800088888880000000000000000000000000000000000000000000
00000000000000000000088888880888888800088880888888888888888888888888888888880888888888080000000000000000000000000000000000000000
00000000000000000000088888800088888000008800088888888888888888888888888888880888800888888000000000000000000000000000000000000000
00000000000000800000088888800880888800888880888888888888888888888888888888800008000000880000000000000000000000000000000000000000
00000000000008880000008888888880088088888800088888888888888888888888888888800000000000000000000000000000000000000000000000000000
000000000000888800000888888888800000008888800888888888888888888888888888888800080000000000000000000000000800000000000000000000f0
00000000000888800008888888888800000000888888888888800888888888088888880008888088800000000000000000000000888000000800000000000000
00000000000088888808888888888800000000088888008888800888888800008870880000888888000000080000000000000008880000008888000088800000
00000088800888888888888888888800000000088888000808880088888800008708880000088880000000008000000000000088888000088888800888000000
00000088888888888888888888888800000000008880000000888800888800000878888080888888000008088800000000000888880000888880000080000000
00000088888088888888888888888880000800080800000000888000088880000888888888888800000088888800000000008888880000888000000000000000
00000088800008888888888888888888888888888000800000080000888880008888888888888000080888888800000080888888888000088800800000000000
00000008000008888888888888888888888888880008880000088008888888088888888888888000008888888880000888888888888000888888888000000000
00000000000088888888888888888888888888880000800000008000808888888888888888888000000088888800008888888888888888888888888800000008
8000000000008888888888888888888888888a800000000000000000008888888888800888888800000008888800088888888880808008888888888800000088
000000000000088888888888888888888888aba00000800000008800008888888888800080888000000008888888888888888800000000088888888880880000
00000000000088888888889888888888888cbab00088000000088800000888888888800808888888880080088888888888888880000000008088888888888888
00000000008888888888888888888888888b0b000080000000008000000888880000000000888000008800008000888888880800000000000008888888888888
00000000088888888888888888888888880000000000000000000800088888008800088880088808000088080000088888800000000000080000088888888888
0000000088888888888888888888888c088000000000000000008008800000888888888888800888888000888000008888880080000000880000880800888880
00000000888888888888888888888800008000000000000000008000880008888888888888888008088800088000008888888888800000888000888088888088
00000008088888888888888888888880000000000000000000080000008800888888888800080080000088000000088888888888880000080000000888880000
80080800888888888888888888888880000000000000080008800008008008888888888888808808800008880000088088888888800000880800000888000000
88008888888888888888888888888888000000000088888088888880880888888888888088888888880000080088000008888888880008880000000800088080
88088888888888888888888888888888800000088800000008888808088080880888088888888888800008008888000008088888888000800000000000088800
88888888888888888888888880880088800000088000800880008008800080080888880888888888000888008888808000008888880008000000000000008000
88888888888888888888888800000000080000880088888888800080008808000800000888808808000088000888800000008888888000000000000000088000
88888888888888888888800000800000080080000808808888000000000008800000888000080080008088000880880000000888888000800000000000888800
888888888888888888888800000000ab000888808000088880000088888000008880000080888888000888800888880800000888888808880000888008888888
88888888888888888888888088800000000888000000080880000088o88880880088888ooo000088880008880080808080008888888888808888888888888888
8888888888888888888888808808800008088800000008080000000088888ooo888808ooooo00008888800888088008008088888888888888888888888888888
88888888888888888888888888888000888008000000800088800700008oooo8oo000ooooooo0000880088888080000088088888888888888888888888888880
88888888888888888888000888888000000000000000008888808000o80oo88oooo88ooooooo0000088800888888008888888888888888888888888888888880
8888888888888888888880088888880000000000800000000000880oo8oo8ooooo888ooooooo0000800880808888888088008888888888888888888888888888
888888888888888888888808888888800008000000000800000088000008oooooooo88ooooo00000088808880888808008000888888888888888888888888808
88888888888888888888888888888800000800800000880000000008888800000000888ooo000008888080888088088000000008888888888888888888888000
888888888888888888888888888088080888800000008800000000078o0000000000000088880000088880888088888880008008888888888888888888888000
8888888888888888888888888880080008888080000080000000087o000000000000800000088888888880880808088088888008888888888888888888888800
88888888888888888888888888800000088080088008088000000800000000808800000000888888088880808808888088880000888888888888888888888880
88888888888888888888888888888080000888088000088800000000000000000000000008000800088888888808888888888000888888888888888888888888
888888888888888888888888888888008088880000800000000000008000000000000008000000080oo088888880888888888808888888888888888888888880
8888888888888088888888888888800008008000808080800000000000000888080800000000000000o088888808888808888888888888888888888888888888
88888888888888888888888888880000080080000008000000000000000000000000000000000000000088888800888800888888888888888888888888888888
88888888888888888888888888880088888800808000000000000000000000000000000000000000000008888880888088888888888888888888888888888800
8888888880888888888888888888808888000000800000000000000o0oo00880088808808000000000008000888088808e888888888888888888888888888800
888888080088888888888888888880888888800000000000000000oo0oo008800800080080000000000o00000888888888888888888888888888888000888800
888888000088888888888888888888888088000000000000000000o08o0008888800080000000000000088800000888888888888888888888888880000088800
888880008008888888888888888888880000800008000000000000o0o8000888880088oo08000000000088800000008888800888880088888888880000088800
88888088888888888888888888888888000000000000000000000000080080888088o8o800800000000808008800080088800088888888888888888000888888
88888888888888888888888888888880000080008800000000000000000000000000000000000000000008088800088808880088888008888888888008888888
8888888888888888888888888o888880000000000000000000000000888000880088888008800000000000808800080808888888880808888888888008888880
88888888888888888888888888888880800000000000000000000080000800880000888808800000000000888000008808888888888888888888888088888000
8888888888bb88888888888888888880000080000800000000000000000000000000000000000000000008888000008808a88888888888888888888888880000
888888888888888888888888888888880008000000o0o000000008808888808880080888080000000000008800088800880d8888888888888888888888888000
888888888888888888888888888888888000000000oo000000000000o88o88808888080808000000000008880080008080088888888888888888888888888880
888888088888888888888888888888888800000008ooo000000000800008888888880800080000000008880800008880008d8888888888888888888888880f00
88800000888888888888888888888888800088800000oo0000000000088888888888880080000000008800000080888008888888888888888888888888888800
88880000888888888888888888888888880088080000000000000000088880880888888080000000000000008880888800888888888888888888888888888880
88888000888888888888888888888888800080808000080800000000000000000000000000000000088000808888888808088888888888888888888888888880
8888880888888888888888888888888080000800008o000800000000000000000000000000000000000088088888088880088888888888888888888888888800
8888888888888888888888888888888008008880808888800008000000000888707o000000000000008008088888088080008888888888888888888888888880
88888888888888888888888888888880888080008088888888000000000000000000000800000088880880808880808008088888888888888888888888888800
8888888888888888888888888888088808080008800888808800000000000000000000000o000088088000888880800008000888888888888888888888888888
8888888888888888888888888880000080088008808888888880800000000ooo88o0000000808888800088808888088888000888888888888888888888888888
88888888888888888888888888800008880800080888888088888000000o00000000000088088888888888000880888808800888888888888888888888888888
88888888888888888888888888880808800880880888888880088808880000000000008o88000088080800808880888880808888888888888888888888888888
8888888888888888888888888088880088088088008888880080800000oo000000008o8880000088008880888880888000888888888888888888888888888880
88888888888888888888888880008800080880880880088800008000000ooooo08ooo88088080088008008880088880008808888888888888888888888888000
8888888888888888888888888800888000080088088088880000800000o0ooo0o80oo08880800088880088800080880088808808888888888888888888888008
88888888888888888888888888000880880080080880088880008800000o0oo0o8o0008888800808008880000088888088800888888888888888888888888000
8888888888888888888888888000088888800008088808888000080008080oo08870888888888888880000080888888088808888888888888888888888888000
88888888888888888888888880000088088000008088008888800880008088088808888888888888008080888888888888808888888888888888888888888000
88888889888888888888888888000000000000008088088088880088080008088088088080808080000888888008888088888888888888888888888888888000
8888888a988888888888888888000000808880000008888888000888800008080000888880808888008888808000080008088888888888888888888888888800
88888888888888888888888888000808808880000000888808880888888008800088888888088888880088888000080080888888888888888888888888888800
88888888888888888888888888000000880800000000080888808800088888888888088088808888800088088000000888888888888888888888888888888880
88888888888888888888888888808000888000000088880888888088888888888888800000808808888800008000008888888880888888888888888888888880
88888888888888888888888880000008888800080000888008088000000088080888800088080088880000000000080000888800088888888888888888888800
88888888888888888888888880000088888000000800088880808800000888808888880888800000800000000008880000888808008888888888888888888880
88888888888888888888888880000008888800000000000088880088088880088888888888800088800000000080880000088000088888888888888888888880
88888888888888888888888888800088888800000008008000888888888888808888888888808800800000008888800088000000008888888888888888888800
88888888088888888888888888880888888000080000000000808888888888888880888880000800000000008088000008800008008888888888888888888808
88808880000008888888888888888888880000000000000080088888888800008808800008888800800800008800000008880008888888888888888888888888
88000888000008888888888888888888888000000000000000000008008888888888880008888000000000880800000088888088808888888888080888888880
88800088880088888888888888888888888800008008000000000000800000888888880008800808888888008880080888888888000888888880000088888808
0800008888888888888a800888888888888800088888800080000088880000000888800888880000000088088800888888888888000008888880000088888800
88000088888888888888000088808888888880088888000000000088880000000000008888888880800888888808888888888880000008888888080888888800
88800888888888008888000008000888888888888888808000000888800000000000888888888888888888888888888888888880000008888888888888800000
88888888888880000080000000000808888888888888880000888888888080000888888888888888888888888888888888888800000000088080008800000000
88888880880880000000000000000000888888888888808008888888888888808888888888888888888088888888888888888000000000000000000000000000
88888800000080088000000000000000088888888888000808888888888888888880088888888888880888888888888888080000000000008000000000000000
08888800000800008800000000000000088888888888000000888888888888888880008888888888800008088888888880000000000000000000000000000000
00888800008800000000000000888800888888888880800008888888888888888800088888888888800000000888888888000000000000000000000000000000
00088000008000000000000008888888888888888888000008888888888888888880808888888888800000000088888888800000000000000000000000000000
00000000088800800000000000008888888888888888800808880888888888888888888888888888800000000888888888000000000000000000000000000000
00000000000888880000000000008888888888888888880088880088888888888888888888888888800000088888888880000000000000000000000000000000
00000000000088800000000000008888888888888888888088888888888888888888888888888888000000008888888880000000000000000000000000000000
00000000000000000000000000008888888888888888888888888888888888888888888888888888800000888888888888000000000000000000000000000000
00000000000000000000000000008888888888888888888888800888888888888888888888888888888088888888880888800000000000000000000000000000
00000000000000000000000000088888888888888888888888000088888888888888888888888888888888888888800088880880000000000000000000000000
00000000000000000000000000088888888888888888888888880088888888888888888888888888888888888888800008888880000000000000000000000000
00000000000000000000000000088888888888888888888888888888888888888888888888888888888888888888000000880888000000000000000000000000
00000000000000000000000088008888888888888888888888888888888888888888888888888888888888888888808000088000000000000000000000000000
00000000000000000000000088800888888888888888888888888888888888888888888888888888888888888888080000888000000000000000008800000000
00000000000000000000000888808888888888888888888888888888888888888888888888888888888888888880008000080000000000000000088880000000
00000000000000000000000888000888888888888888888888888888888888888888888888888888888888888888008800000000000000000000008880000000
00000000000000000000000080000088888888888888888888888888888888888888888888888888888888088888888880000000000000000000000888000000
00000000000000000000000880000000888888888888888888888888888888888888888888888888880888808888888800000000000000000000000880000000
00000000000000000000008080000000888888888888080888888888888888888888888888888888880088888888888800000000000000000000000000000000
00000000000000000000000000000000088888888880000008888888888800088888888800888888800888888888888800000000000000000000000000000000
00000000000000000000000000000000880088888888000000888888808000088888888888888888880088888888888888000000000000000000000000000000
00000000000000000000000000000000800000888080000000088888800000088888888888888888800008088888888880000000000000000000000000000000
00000000000000000000000000000000000000080000000000888880000000000088888888888880000000000808888800000000000000000000000000000000
00000000000000000000000080000000000000000000000000888800000000000000080008888800000000000088888000000000000000000000000000000000
00000000000000000000000088000000000000000000000000088000000000000000000000888800000000000088800000000000000000000000000000000000

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

