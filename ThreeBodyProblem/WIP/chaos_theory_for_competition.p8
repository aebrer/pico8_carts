pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--init

-- to do: 
-- - a comet that comes by
-- - portals/wormholes
--     - and maybe they transfer gravity

function _init()
 cls()
 
 --camera
 --camera(-64,-64)
 
 happens_once_done = false

 --window stuff
 window_line_counter=1
 window_lines = {}
 -- n_hori_lines = 8
 -- n_vert_lines = 8
 
 -- -- need to declare some fixed
 -- -- points first, will make this
 -- -- a lot easier
 
 -- --outer box
 -- local a={8,8}
 -- local b={120,8}
 -- local c={8, 120}
 -- local d={120,120}

 -- --inner box
 -- local e={24,24}
 -- local f={104,24}
 -- local g={24,104}
 -- local h={104,104}
 
 -- --outer box
 -- add_line(a,b)
 -- add_line(b,d)
 -- add_line(d,c)
 -- add_line(c,a)
 
 -- --inner box
 -- add_line(e,f)
 -- add_line(f,h)
 -- add_line(h,g)
 -- add_line(g,e)
 
 -- --diagonals
 -- add_line(ofst(a, 16, 0), ofst(d, -16, 0))
 -- add_line(ofst(e, -20, 24), ofst(h, 20, -24))


 --alter
 alter_stmt_decay = 0
 alter_effect_decay = 0
 alter_stmt_needed=true
 alter_statement = ""
 alter_stmt_rate = 240
 alter_effect_rate = 60
 alter_pressed = false

 --title
 side = "d"
 alter_title = "gltch"
 alter_num = "024"..side
 title = "tbp_"..alter_num
 title = title.."_"
 title = title..alter_title
 title_needed = true
 title_decay = 600

 --seed
 seed = flr(rnd(-1)) + 1
 l_seeds = {-1675, -20927, 8610}
 p_seeds = {
  -23163, -8963, 25168, 15546,
  -6259, 21150,16012 
 }
 
 seed_legend = {}
 seed_legend["29731"] = "krankarta"
 seed_legend["-1186"] = "i_m_n_o_t"
 seed_legend["15477"] = "crashblossom1"
 seed_legend["9132"] = "botfrula"

 d_seeds = {}
 for seed, name in pairs(seed_legend) do
  add(d_seeds, tonum(seed))
 end

 if side == "l" then
  seed = rnd_choice(l_seeds)
 elseif side == "p" then
  seed = rnd_choice(p_seeds)
 elseif side == "d" then
  seed = rnd_choice(d_seeds)
 end
 srand(seed)

 use_dither = true
 glitch_every_x_sec = 13
 noise_amt = 1.0

 dither_mode = "mixed"
 dither_modes = {
  "mixed",
  "circles", 
  "circfill", 
  "rect"
 } 
 dither_prob = 0.85

 if side == "l" then
  dither_prob = 0.55
  local burn_dither_modes = { 
   "burn_spiral",
   "burn_rect",
   "burn"
  }
  for dm in all(dither_modes) do
   add(burn_dither_modes, dm)
  end
  dither_modes = burn_dither_modes
  dither_mode="burn_spiral"
 elseif side == "p" then
  glitch_every_x_sec = 8
  noise_amt = 1.05
  dither_prob = 0.5
  dither_mode = "rect"
 end

 n_dither_modes = #dither_modes
 alter_dither_i = 1

 --colors 
 cols = {}
 if side == "d" then
  --a-side palette
  local aside_bgs = {0,-16,-15}
  local aside_fgs = {-5,-8,8,11,3}
  local aside_bg = rnd_choice(aside_bgs)
  local aside_fg = rnd_choice(aside_fgs)
  cols["c_background"]   = aside_bg
  cols["c_luna_trail"]   = aside_fg
  cols["c_deimos_vein"]   = aside_fg
  cols["c_deimos_outer"]  = aside_fg
  cols["c_phobos_trail"] = aside_fg
  cols["c_luna_core_1"]  = aside_fg
  cols["c_luna_outer"]   = aside_fg
  cols["c_stars"]        = aside_fg
  cols["c_explosion_1"]  = aside_fg
  cols["c_phobos_vein"]  = aside_fg
  cols["c_phobos_core"]  = aside_fg
  cols["c_deimos_trail"]  = aside_fg
  cols["c_unused"]       = aside_fg
  cols["c_luna_accent"]  = aside_fg
  cols["c_text"]         = aside_fg
  cols["c_phobos_outer"] = aside_fg
 elseif side == "l" then
  -- --b-side palette

  burn_pal = {
   "0", "-16", "-14", 
   "-11", "-3", "13", 
   "6", "7"
  }

  local c_background = tonum(burn_pal[1])
  local c_vein = tonum(burn_pal[2])
  local c_accent = tonum(burn_pal[3])
  local c_unused = tonum(burn_pal[4])
  local c_trail = tonum(burn_pal[5])
  local c_core = tonum(burn_pal[6])
  local c_outer = tonum(burn_pal[7])
  local c_text = tonum(burn_pal[8])

  burn_pal_key = {}
  for i=1,#burn_pal do
   burn_pal_key[burn_pal[i]] = i
  end

  cols["c_background"]   = c_background
  cols["c_luna_trail"]   = c_trail
  cols["c_deimos_vein"]   = c_core
  cols["c_deimos_outer"]  = c_outer
  cols["c_phobos_trail"] = c_trail
  cols["c_luna_core_1"]  = c_core
  cols["c_luna_outer"]   = c_outer
  cols["c_stars"]        = c_text
  cols["c_explosion_1"]  = c_text
  cols["c_phobos_vein"]  = c_core
  cols["c_phobos_core"]  = c_core
  cols["c_deimos_trail"]  = c_trail
  cols["c_unused"]       = c_unused
  cols["c_luna_accent"]  = c_core
  cols["c_text"]         = c_text
  cols["c_phobos_outer"] = c_outer


 elseif side == "p" then
  local cside_bg = -16
  local cside_fg = -8
  local cside_hl = 8

  cols["c_background"]   = cside_bg
  cols["c_luna_trail"]   = cside_fg
  cols["c_deimos_vein"]   = cside_fg
  cols["c_deimos_outer"]  = cside_fg
  cols["c_phobos_trail"] = cside_fg
  cols["c_luna_core_1"]  = cside_fg
  cols["c_luna_outer"]   = cside_fg
  cols["c_stars"]        = cside_fg
  cols["c_explosion_1"]  = cside_fg
  cols["c_phobos_vein"]  = cside_fg
  cols["c_phobos_core"]  = cside_fg
  cols["c_deimos_trail"]  = cside_fg
  cols["c_unused"]       = cside_fg
  cols["c_luna_accent"]  = cside_fg
  cols["c_text"]         = cside_hl
  cols["c_phobos_outer"] = cside_fg
 
 end
 

 og_cols = {}
 og_cols["c_background"]   = 0
 og_cols["c_luna_trail"]   = 1
 og_cols["c_deimos_vein"]   = 2
 og_cols["c_deimos_outer"]  = 3
 og_cols["c_phobos_trail"] = 4
 og_cols["c_luna_core_1"]  = 5
 og_cols["c_luna_outer"]   = 6
 og_cols["c_stars"]        = 7
 og_cols["c_explosion_1"]  = 8
 og_cols["c_phobos_vein"]  = 9
 og_cols["c_phobos_core"]  = 10
 og_cols["c_deimos_trail"]  = 11
 og_cols["c_unused"]       = 12
 og_cols["c_luna_accent"]  = 13
 og_cols["c_text"]         = 14
 og_cols["c_phobos_outer"] = 15

 cmap_new_old = {}
 cmap_old_new = {}
 local counter = 0
 for name, col in pairs(og_cols) do
  cmap_new_old[tostring(cols[name])] = tostring(og_cols[name])
  cmap_old_new[tostring(og_cols[name])] = tostring(cols[name])
  counter+=1
 end

 if rand_sign() == 1 then
  gods_eye_view = true
 else
  gods_eye_view = false
  if side == "p" then
   gods_eye_view = true
  end
 end
 -- gods_eye_view = true
 mono_palette = 1
 cam_smooth_factor = 60
 cam_xy = {0,0}


 --physics
 collision_distance = 1.99
 rad_o_g = 1.5
 --speed and force limits
	min_speed = -100.0
	max_speed = 100.0
	min_force = 0.005
	max_force = 1000.0

 --reset timer
 reset_timer=8
 reset_needed=false

 --use for periiodic cls
 blank_timer_max=120
 blank_timer=blank_timer_max

 --trail parameters
 snapshot_rate=4
 snapshot_timer=snapshot_rate
 trail_length=40
 trails = {} --the dead trails


 if side == "l" then
  snapshot_rate=16000
  trail_length=1
 elseif side == "p" then
  snapshot_rate=2
  snapshot_timer=snapshot_rate
  trail_length=50
 end
	
	--keep planets in here
	planets = {}

 --for aligning the planets
 local x_sign = rand_sign()
 local y_sign = rand_sign()

 
 --define planets here
 phobos = {
  name="phobos",
    x=rnd(128) * 1.0,
    y=rnd(128) * 1.0,
    --x=-64,
    --y=30,
    old_x=0.0,
    old_y=0.0,
    m=15.0,
    vx=rnd(0.2) * x_sign,
    vy=rnd(1.0)+0.2 * y_sign,
    ix=0,
    iy=0,
    offscreen=false,
    history={},
    crashed=false,
    sprite_main=2,
    sprite_offscreen=18,
    sprite_trail=34,
    spr_range_x=1,
    spr_range_y=1
 }
 planets["phobos"] = phobos
	
 deimos = {
  name="deimos",
  x=rnd(128) * 1.0,
  y=rnd(128) * 1.0,
  old_x=0.0,
  old_y=0.0,
  m=15.0,
  vx=rnd(0.2) * x_sign,
  vy=rnd(0.1)+0.1 * y_sign,
  ix=0,
  iy=0,
  offscreen=false,
  history={},
  crashed=false,
  sprite_main=4,
  sprite_offscreen=20,
  sprite_trail=36,
  spr_range_x=1,
  spr_range_y=1
 }
 planets["deimos"] = deimos

 luna = {
  name="luna",
   x=rnd(64),
   y=rnd(64) * rand_sign(),
   old_x=0.0,
   old_y=0.0,
   m=15.0,
   vx=rnd(1.2) * x_sign,
   vy=rnd(0.2)+0.2 * y_sign,
   ix=0,
   iy=0,
   offscreen=false,
   history={},
   crashed=false,
   sprite_main=1,
   sprite_offscreen=17,
   sprite_trail=33,
   spr_range_x=1,
   spr_range_y=1
 }
 planets["luna"] = luna
	
	-- premake the double planets
	big_planets = {}
	phobosdeimos = {
	 name="phobosdeimos",
 	x=rnd(64) + 64,
  y=luna.y * rand_sign() + 30 * rand_sign(),
  old_x=0.0,
  old_y=0.0,
 	m=28.0,
  vx=rnd(0.2) * rand_sign(),
  vy=rnd(1.1)+0.1 * rand_sign(),
  ix=0,
	 iy=0,
	 offscreen=false,
	 history={},
	 crashed=false,
	 sprite_main=42,
	 sprite_offscreen=nil,
	 sprite_trail=39,
	 spr_range_x=2,
	 spr_range_y=2
	}
	
 -- planets["phobosdeimos"] = phobosdeimos
	big_planets["phobosdeimos"] = phobosdeimos
	
	phobosluna = {
	 name="phobosluna",
 	x=rnd(128) * 1.0,
  y=rnd(128) * 1.0,
  old_x=0.0,
  old_y=0.0,
 	m=28.0,
 	vx=0,
	 vy=0, 
  ix=0,
	 iy=0,
	 offscreen=false,
	 history={},
	 crashed=false,
	 sprite_main=40,
	 sprite_offscreen=nil,
	 sprite_trail=55,
	 spr_range_x=2,
	 spr_range_y=2
	}
	big_planets["phobosluna"] = phobosluna
 -- planets["phobosluna"] = phobosluna

	deimosluna = {
	 name="deimosluna",
 	x=rnd(128) * 1.0,
  y=rnd(128) * 1.0,
  old_x=0.0,
  old_y=0.0,
 	m=28.0,
 	vx=0,
	 vy=0, 
  ix=0,
	 iy=0,
	 offscreen=false,
	 history={},
	 crashed=false,
	 sprite_main=44,
	 sprite_offscreen=nil,
	 sprite_trail=23,
	 spr_range_x=2,
	 spr_range_y=2
	}
	big_planets["deimosluna"] = deimosluna
 -- planets["deimosluna"] = deimosluna
	
	double_planet_names = {
	 "deimosluna",
	 "phobosluna",
	 "phobosdeimos"
	}
	
	behemoth = {
	 name="behemoth",
 	x=0.0,
  y=0.0,
  old_x=0.0,
  old_y=0.0,
 	m=55.0,
 	vx=0,
	 vy=0,	 
  ix=0,
	 iy=0,
	 offscreen=false,
	 history={},
	 crashed=false,
	 sprite_main=81,
	 sprite_offscreen=nil,
	 sprite_trail=64,
	 spr_range_x=2,
	 spr_range_y=2
	}
 
	-- list of places to explode
	explosions = {}
	exp_spr_offset = 23
	exp_decay_rate = 5
	

 --average positions
 first_avg = t
 sx = 0.0
	sy = 0.0
	delta_sx = 0.0
	delta_sy = 0.0
	get_avg_change()	


 -- now some stars
 n_stars = 16
 star_spr_offset = 5
 star_spr_max = 11
 star_decay_rate = 15
 stars = {}
 for i=n_stars,1,-1 do
  add(stars, generate_star())
 end

end
-->8
--move

function move_planet(p)
	
	for name2, p2 in pairs(planets) do

 	local dist=0

 	if not(p2==p) and not p.crashed then
 		--calculate distance
 		dist=approx_dist(p2.old_x-p.old_x,p2.old_y-p.old_y)
 		-- calc crash here
 		if dist < collision_distance then
 		 p.crashed = true
 		 p2.crashed = true
 		 
 		 exp1 = {}
 		 exp1["x"] = p.x
 		 exp1["y"] = p.y
 		 exp1["t"] = 1
 		 exp1["decay_rate"] = exp_decay_rate
 		 add(explosions, exp1)
 		 
 		 exp2 = {}
 		 exp2["x"] = p.x
 		 exp2["y"] = p.y
 		 exp2["t"] = 1
 		 exp2["decay_rate"] = exp_decay_rate
 		 add(explosions, exp2)
 		 
 		 --get avg speed+pos of 
 		 --two crashed planets
 		 local avgx = (p.old_x + p2.old_x) / 2
 		 local avgy = (p.old_y + p2.old_y) / 2
 		 local avgvx = (p.vx + p2.vx) / 2
 		 local avgvy = (p.vy + p2.vy) / 2
 		 
 		 local newname1 = p.name..p2.name
 		 local newname2 = p2.name..p.name
 		 local names = {newname1, newname2}
    
    local behemoth_check = false
    for name in all(double_planet_names) do
     if p.name == name then
      behemoth_check = true
      break
     elseif p2.name == name then
      behemoth_check = true
     end
    end
    
    if behemoth_check then
     bp = behemoth
     bp.x = avgx
     bp.y = avgy
     bp.vx = avgvx
     bp.vy = avgvy
     planets[bp.name] = bp
    else
     for name in all(names) do
      if big_planets[name] then
       bp = big_planets[name]
       bp.x = avgx
       bp.y = avgy
       bp.vx = avgvx
       bp.vy = avgvy
       planets[bp.name] = bp
      end
     end
    end 		 
 		 
 		 --remove crashed planets
 		 planets[p.name] = nil
 		 planets[p2.name] = nil
 		 
 		 --utilize trails list
 		 --to keep trails
				add(trails, get_trail(p))
				add(trails, get_trail(p2))
 		 break
 		end

   -- planets are not crashed, keep moving

 		--get direction of force vec
 		xdist = (p2.old_x-p.old_x)/dist * -1
 		ydist = (p2.old_y-p.old_y)/dist * -1
 		
 		--compute force of g per p
 		force = ((p.m * p2.m * (6.67*10^-3)) / dist^rad_o_g)
  	force = min(force, max_force)
  	force = max(force, min_force)
 		
   -- --euler
   --get componants of force
 		p.vx = p.vx - force * xdist
 		p.vy = p.vy - force * ydist
  end

 end
 	
 --speed limits
 p.vx = max(min_speed, p.vx)
 p.vx = min(p.vx, max_speed)
 p.vy = max(min_speed, p.vy)
 p.vy = min(p.vy, max_speed)
 
 --actually move
 p.x += p.vx 
 p.y += p.vy

end


-->8
--draw

function _draw()
 
 --display
 if use_dither then
  dither(dither_mode)
 end

 camera(cam_xy[1]-64,cam_xy[2]-64)

 for i=#stars,1,-1 do
  draw_star(stars[i])
  --move stars
  stars[i].x += delta_sx
  stars[i].y += delta_sy
 end

 --if dreaming then
 --trail of crashed planets
 for trail in all(trails) do
  draw_trail(trail)
  deli(trail.history, 1)
 end
 --end

 --if dreaming then
  --trail of live planets
 for name, p in pairs(planets) do
  draw_trail(p)
 end
 --end


 --if dreaming then
  --lines	
 wl = window_lines
 for wl_i=#wl,1,-1 do
  line(
   wl[wl_i][1]+sx-64,
   wl[wl_i][2]+sy-64,
   wl[wl_i][3]+sx-64,
   wl[wl_i][4]+sy-64
   )
 end
 --end

 --planets	
 for name, p in pairs(planets) do
  draw_planet(p)
 end

 --explosions
 for i,exp in ipairs(explosions) do
  if exp.t > 7 then
   deli(explosions, i)
  else
   draw_explosion(exp)
  end
 end

 draw_noise(noise_amt)
 draw_glitch(glitch_every_x_sec)

 --title screen
 if title_needed then
  print(
   seed_legend[tostring(seed)],
   sx-63, sy-63,
   og_cols["c_background"]
  )
  print(
   seed_legend[tostring(seed)],
   sx-64, sy-64,
   og_cols["c_text"]
  )
  print(
   'seed: '..tostring(seed),
   sx-64, sy+58, 
   og_cols["c_background"]
  )
  print(
   'seed: '..tostring(seed),
   sx-63, sy+59,
   og_cols["c_text"]
  )
 end

 if alter_stmt_needed then
  print(
   'seed: '..tostring(seed),
   sx-64, sy+58,
   og_cols["c_background"]
  )
  print(
   'seed: '..tostring(seed),
   sx-63, sy+59,
   og_cols["c_text"]
  )
 end

--end draw()
end

function draw_planet(p)
	spr(
	 p.sprite_main,
	 p.x, p.y,
	 p.spr_range_x,
	 p.spr_range_y)
end

function draw_trail(p)
	-- now draw the trail
	for i=#p.history,1,-1 do
	 spr(p.sprite_trail,
	 p.history[i]["x"], 
	 p.history[i]["y"])
	end
end

function draw_explosion(e)
 spr(
  (e.t+exp_spr_offset),
  e.x,
  e.y
 )
 if e.decay_rate < 0 then
  e.t+=1
  e.decay_rate = exp_decay_rate
 else
  e.decay_rate -= 1
 end
end

function draw_star(s)
 spr(
  s.sprite,
  s.x,
  s.y
 )
 s.twinkle_rate -= 1
 if s.twinkle_rate < 0 then
  s.twinkle_rate = star_decay_rate
  s.sprite = (
   rnd(
    star_spr_max-star_spr_offset
    )+star_spr_offset
   )
 end
 
end
-->8
--update

function _update60()

 if not happens_once_done then
  alter_colors()
  happens_once_done = true
 end



 --relative motion fix
 if not gods_eye_view then
  for name, p in pairs(planets) do
   p.x -= sx+64
   p.y -= sy+64
  end
 end

 -- --are they too far?
 -- local x_too_far = false
 -- local y_too_far = false
 -- for name, p in pairs(planets) do
 --  if p.x > 15000 then
 --   x_too_far = true
 --  end
 --  if p.y > 15000 then
 --   y_too_far = true
 --  end
 -- end
 
 -- if x_too_far then
 --  for name, p in pairs(planets) do
 --   p.x = -p.x
 --  end
 -- end

 -- if y_too_far then
 --  for name, p in pairs(planets) do
 --   p.y = -p.y
 --  end
 -- end


 --title
 title_decay -= 1
 if title_decay < 0 then
  title_needed = false
 end

	--used for periodic cls
	--only needed if main cls
	--is commented out
	blank_timer-=1
	if blank_timer<0 then 
		blank_timer=blank_timer_max 
		-- alter_colors()
  --cls()
	end

 --trail timing
	local rec_snapshots=false
 snapshot_timer-=1
 if snapshot_timer<0 then
   snapshot_timer=snapshot_rate
   rec_snapshots=true
 end
	
	--avg position is needed in
	--order to move the planets
	--ie. do this first
	get_avg_change()	
	
 for name, p in pairs(planets) do
  p.old_x = p.x
  p.old_y = p.y
 end

	--actually move the planets
	for name, p in pairs(planets) do
	 move_planet(p)
	 --offscreen_check(p)
	 if rec_snapshots then
    record_snapshot(p)
  end
	end
	
	--alter logic
 if alter_stmt_decay < 0 then
	 local as = alter_stmt_rate
	 alter_stmt_decay = as
	 alter_stmt_needed=false
	end
 
 if alter_pressed then
  if alter_effect_decay<0 then
   local aer=alter_effect_rate
   alter_effect_decay=aer
   alter_pressed = false
   alter_dither()
  end
  alter_stmt_needed=true
	end
	
	alter_effect_decay-=1	 
	alter_stmt_decay-=1
	
	--controls
	if btn(0) then
	 reset_needed=true
	end 
	
	if btn(1) then
	 reset_needed=true
	end 
	
	if btn(2) then
  reset_needed=true
	end 
	
	if btn(3) then
  reset_needed=true
	end 
	
	if btn(4) then
	 --z/🅾️ button
	 alter_pressed = true
  alter_stmt_needed = true
 else
  alter_pressed = false
	end 
	
	if btn(5) then
  reset_needed=true
	end 
	
	if reset_needed then
	 if reset_timer < 0 then
	   run()
	 end
	 reset_timer -= 1
	end
	
end
	
-->8
--functions

function get_avg_change()
 
	local avg_x = {}
	local avg_y = {}
	if first_avg then
	 old_sx = 0.0
	 old_sy = 0.0
	else
	 old_sx = sx
	 old_sy = sy
	end
	sx=0.0
	sy=0.0
	for name, p in pairs(planets) do
		add(avg_x, p.x)
		add(avg_y, p.y)
		sx += p.x
		sy += p.y
	end
	sx = sx / #avg_x
	sy = sy / #avg_y
	
 if first_avg then 
	 delta_sx = 0.0
	 delta_sy = 0.0
	else
	 delta_sx = sx-old_sx
	 delta_sy = sy-old_sy
	end

 -- lets try making this 
 -- a moving average
 cam_xy[1] = sx - (
  delta_sx / cam_smooth_factor
 )
 cam_xy[2] = sy - (
  delta_sy / cam_smooth_factor
 )
	
	first_avg = false
	
end

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

function offscreen_check(p)
	if p.x < 0 then 
		p.ix = 0
		p.offscreen = true
	end
	if p.y < 0 then 
		p.iy = 0
		p.offscreen = true
	end
	if p.x > 127 then 
		p.ix = 126
		p.offscreen = true
	end
	if p.y > 127 then 
		p.iy = 126
		p.offscreen = true
	end
	if (0 <= p.x) and (p.x <= 127) then
		p.ix = p.x
	end
	if (0 <= p.y) and (p.y <= 127) then
		p.iy = p.y
	end
	if (0 <= p.x) and (p.x <= 127) and (0 <= p.y) and (p.y <= 127) then
		p.offscreen = false
	end
end

function pythag(a,b)
	return sqrt(a^2+b^2)
end

function approx_dist(dx,dy)
 local maskx,masky=dx>>31,dy>>31
 local a0,b0=(dx+maskx)^^maskx,(dy+masky)^^masky
 if a0>b0 then
  return a0*0.9609+b0*0.3984
 end
 return b0*0.9609+a0*0.3984
end

function record_snapshot(p)
 add(p.history, {x=p.x, y=p.y})
 if #p.history > trail_length then
  deli(p.history, 1)
 end
end

function generate_star()
 local star = {}
 star["sprite"]=(
  rnd(
   star_spr_max-star_spr_offset
  )+star_spr_offset
 )
 star["x"]=sx - (
  rnd(64) * rand_sign()
 ) - 5
	star["y"]=sy - (
  rnd(64) * rand_sign()
 )
	star["twinkle_rate"]=star_decay_rate
 return(star)
end

function get_trail(p)
 local trail = {}
 trail.history=p.history
 trail.sprite_trail=p.sprite_trail
 return(trail)
end

function rand_sign()
 local coin_toss = rnd(1)
 if coin_toss >= 0.5 then
  factor = -1
 else
  factor = 1
 end
 return(factor)
end

function add_line(a,b)
 local x1 = a[1]
 local x2 = b[1]
 local y1 = a[2]
 local y2 = b[2]
 add(
   window_lines, {x1,y1,x2,y2}
 )
end

function ofst(a, x, y)
 --offset a point
 local b={a[1]+x, a[2]+y}
 return(b)
end


function draw_noise(amt)
    for i=0,amt*amt*amt do
        poke(
            0x6000+rnd(0x2000),
            peek(rnd(0x7fff)))
        poke(
            0x6000+rnd(0x2000),
            rnd(0xff))
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

function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

function vfx_smoothing()
 local pixel = rnd_pixel()
 c=abs(pget(pixel.x,pixel.y)-1) 
end

function rnd_pixel()
 local px_x = (rnd(128) - 64) + (rand_sign() * sx)
 local px_y = (rnd(128) - 64) + (rand_sign() * sy)
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function dither(dm)
 if dm == "mixed" then
  dither(rnd_choice(dither_modes))
 elseif dm == "cls" then
  cls()
 elseif dm == "circles" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rand_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rand_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      circ(pxl.x,pxl.y,16,bg_color)
     end
    end
   end
  end
 elseif dm == "circfill" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rand_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rand_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      circfill(pxl.x,pxl.y,4,bg_color)
     end
    end
   end
  end
 elseif dm == "rect" then
  for i=1,6 do 
   local fudge_x = (flr(rnd(4)) + 1) * rand_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rand_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
     if rnd(1) > dither_prob then
      rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,bg_color)
     end
    end
   end
  end
 elseif dm == "burn_spiral" then
  for i=500,1,-1 do
   local pxl = rnd_pixel()
   c=pget(pxl.x,pxl.y)
   circ(pxl.x,pxl.y,2,burn_loop(c))
  end
 elseif dm == "burn" then
  for i=1,4 do 
   local fudge_x = (flr(rnd(4)) + 1) * rand_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rand_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
      c=pget(pxl.x,pxl.y)
      circ(pxl.x,pxl.y,1,burn_loop(c))
    end
   end
  end
 elseif dm == "burn_rect" then
  for i=1,4 do 
   local fudge_x = (flr(rnd(4)) + 1) * rand_sign()
   local fudge_y = (flr(rnd(4)) + 1) * rand_sign()
   --skip some nunber (12) pixels
   for x=128+fudge_x,0,-12 do
    for y=128+fudge_y,0,-12 do
     local pxl = rnd_pixel()
      c=pget(pxl.x,pxl.y)
      rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn_loop(c))
    end
   end
  end
 end
end

function burn(c)
 --given og color
 --get new color
 --printh(c)
 local real_c = cmap_old_new[tostring(c)]
 --given new color
 --get gradient pos
 --printh(real_c)
 --printh(burn_pal_key[real_c])
 local grad_i = burn_pal_key[real_c]
 --printh(grad_i)
 --given gradient, get new color to use
 local new_real_c = burn_pal[max(grad_i-1, 1)] 
 --now convert back to
 --color needed for pset
 local new_c = tonum(cmap_new_old[new_real_c])
 return(new_c)
end

function burn_loop(c)
 --given og color
 --get new color
 --printh(c)
 local real_c = cmap_old_new[tostring(c)]
 --given new color
 --get gradient pos
 --printh(real_c)
 --printh(burn_pal_key[real_c])
 local grad_i = burn_pal_key[real_c]
 --printh(grad_i)
 --given gradient, get new color to use
 if grad_i == 1 then
  grad_i = #burn_pal_key
  local new_real_c = burn_pal[grad_i]
  local new_c = tonum(cmap_new_old[new_real_c])
  return(new_c)
 end
 local new_real_c = burn_pal[grad_i-1] 
 --now convert back to
 --color needed for pset
 local new_c = tonum(cmap_new_old[new_real_c])
 return(new_c)
end


-->8
--alter

--018
function inc_min_force()
 min_force = min_force * 1.01
 text = "min_force increased to "
 alter_statement = text..tostring(min_force)
end

--019
function inc_rad_o_g(r)
 local new_rad = nil
 if alter_effect_decay<0 then
  if r == 6 then
   new_rad = 1
  else
   new_rad = r+1
  end
 else
  new_rad = r
 end
 text="rad^█_of_grav● = "
 alter_statement = text..new_rad
 return new_rad
end

--020
function alter_stars()
 add(stars, generate_star())
 text="number of stars = "
 alter_statement = text..tostring(#stars)
end

--021
dreaming = true
function alter_dream()
 dreaming = not dreaming
 if dreaming then
  alter_statement = "dream"
 else
  alter_statement = "awake"
 end
end

--022
function alter_colors()
 --define custom palette
 for name, col in pairs(cols) do
  pal(og_cols[name], cols[name], 1)
 end
end

--000
function alter_cls()
 alter_clear = not alter_clear
end

--023
function alter_frame()
 gods_eye_view = not gods_eye_view
 for name, p in pairs(planets) do
  p.history = {}
 end
 trails = {}
end

--024
function alter_dither()
 local old_dither_mode = dither_mode
 
 while dither_mode == old_dither_mode do
  dither_mode = dither_modes[alter_dither_i]
  alter_dither_i += 1
  if alter_dither_i > n_dither_modes then
   alter_dither_i = 1
  end
 end 
 text="dither: "
 alter_statement = text..dither_mode
end


__gfx__
000000000666d600000ffff088888888033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666d6660fff99ff80088008332223330000000000000000000000000000000000000000000700000000000000000000000000000000000000000000
00700700665555560ffff99f80088008332322230000000000700700000000000007000000707000000700000000700000000000000000000000000000000000
000770006556d656ff9aaa9f88888888332333330000000000077000000700000077700000070000077770000077770000000000000000000000000000000000
000770006655d556ffaaaaff88888888323333230000700000077000000070000007000000707000007777000007700000000000000000000000000000000000
0070070066d555600faa99f080088008333223230000000000700700000000000000000000000000000700000000700000000000000000000000000000000000
0000000006d65d600ff99ff080088008332323330000000000000000000000000000000000000000000700000000000000000000000000000000000000000000
000000000666666000ffff0088888888033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066000000aa00000000000000330000000000000000000000000000000000000000000000090000000908888a0908888a0900888a0900088a00000000
0000000066000000aa00000000000000330000000000000000000000000000000000000000a00a0000a99a9088a99a9a88a99a9a88a09a900000900000000000
000000000000000000000000000000000000000000000000000000000000000000000000000a0000099909000999080a0990080a090008000900080000000000
00000000000000000000000000000000000000000000000000000000000000000007700000a77a0000a79a9000a79a8000000080000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000770000a077a0009097a00a8097a80a8000080a80000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000a0000000a90990a8a90980a8a00080a80000000000000000000000
00000000000000000000000000000000000000000000000000000000000000530000000000000a0009000a09a8998898a8998898a80080980800000800000000
0000000000000000000000000000000000000000000000000000000000000026000000000000000000090000a8a8988aa8a8988aa800908a0000000a00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000055695000000000000032000000000000000000000000000000000000000
00000000000110000004400000000000000bb000000000000000000000000000000059a99650000000000032a330000000000066600000000000000000000000
00000000000110000004400000000000000bb000000000000000000000000000000666d69ffff00000000fff393330000003333366d600000000000000000000
000000000000000000000000000000000000000000000000000000000000000006666699ff99ff00000fff99922333000033225566d666000000000000000000
000000000000000000000000000000000000000000000000000000000000009305565955f5699f00000fff292aa2230000332522555555000000000000000000
000000000000000000000000000000000000000000000000000000000000002a065599aa66aa9f0000ff9332a333330000332d6653d256000000000000000000
0000000000000000000000000000000000000000000000000000000000000000066655d5aaaaff0000ffa2233a33230000323d63323556000000000000000000
00000000000000000000000000000000000000000000000000000000000000000066d59a6599f000000faa99322323000023322dd52560000000000000000000
00000000000000000000000000000000000000000000000000000000000000000006d95df95ff000000ff93f9323330000333325d25d60000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000666669fff00000000ffff23333000000323d5626660000000000000000000
00000000000000000000000000000000000000000000000000000000000000000006056966000000000000a99930000000000033300000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000066000000000000033a230000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000006a0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000950000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00059000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066600320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003333366d2a3300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003225566df39333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000003532522555992233300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000003632d6653d92aa22300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000003523d633232a3333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000363322dd5233a332300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000026666699ff92aa22300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000065565955f52a3333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000565599aa6633a332300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000656655d5aa932232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006066d59a65f93233300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006d95df9f23333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000666669f999300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000060569663a2300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888777777888eeeeee888eeeeee888eeeeee888eeeeee888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888778887788ee88eee88ee888ee88ee888ee88ee8e8ee88888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888777878778eeee8eee8eeeee8ee8eeeee8ee8eee8e8ee88888e88888888888888888888888888888ff888ff888282282888222888888228882888888288888
888777878778eeee8eee8eee888ee8eeee88ee8eee888ee8888eee8888888888888888888888888888ff888ff888222222888888222888228882888822288888
888777878778eeee8eee8eee8eeee8eeeee8ee8eeeee8ee88888e88888888888888888888888888888ff888ff888822228888228222888882282888222288888
888777888778eee888ee8eee888ee8eee888ee8eeeee8ee888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661611166616611616111116661666166616661666111116661666161611111c111ccc1ccc1111111111111111111111111111111111111111111111111111
16161611161616161616111111611161166616111616111116661616161617771c111c1c1c1c1111111111111111111111111111111111111111111111111111
16611611166616161661111111611161161616611661111116161666116111111ccc1c1c1c1c1111111111111111111111111111111111111111111111111111
16161611161616161616111111611161161616111616111116161616161617771c1c1c1c1c1c1111111111111111111111111111111111111111111111111111
16661666161616161616166611611666161616661616166616161616161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661611166616611616111116661666166616661666111116661611166616611616111116661666166616661666111116661666161611111111111111111111
16161611161616161616111111611161166616111616177716161611161616161616111111611161166616111616111116661616161611111111111111111111
16611611166616161661111111611161161616611661111116611611166616161661111111611161161616611661111116161666116111111111111111111111
16161611161616161616111111611161161616111616177716161611161616161616111111611161161616111616111116161616161611111111111111111111
16661666161616161616166611611666161616661616111116661666161616161616166611611666161616661616166616161616161611111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111888881111111111111111111111111111111111111111111111111111111111111111111
11661661166616661166161611661666111116661666166616661111888881111111111111111111111111111111111111111111111111111111111111111111
16111616161616161611161616161161111116161616116116111777888881117111111111111111111111111111111111111111111111111111111111111111
16661616166616661666166616161161111116611666116116611111888881117711111111111111111111111111111111111111111111111111111111111111
11161616161616111116161616161161111116161616116116111777888881117771111111111111111111111111111111111111111111111111111111111111
16611616161616111661161616611161166616161616116116661111888881117777111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111
11661661166616661166161611661666111116661666166616661666111111661171166616661166161611661666111116661666166616661111111111111111
16111616161616161611161616161161111111611161166616111616177716111616161616161611161616161161111116161616116116111111111111111111
16661616166616661666166616161161111111611161161616611661111116661616166616661666166616161161111116611666116116611111111111111111
11161616161616111116161616161161111111611161161616111616177711161616161616111116161616161161111116161616116116111111111111111111
16611616161616111661161616611161166611611666161616661616111116611616161616111661161616611161166616161616116116661111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661666166616661611111116111666166111661666161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111111111111111
11611616161611611611111116111611161616111161161617771c111c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
11611661166611611611111116111661161616111161166611111ccc1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
1161161616161161161111111611161116161616116116161777111c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
11611616161616661666166616661666161616661161161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111666166116661666117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616661161117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1b1111bb1171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111b111711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111bbb1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b11111b1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bb11171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822282228888888888888888888888888888888888888888888888888222822282888882822282288222822288866688
82888828828282888888828888828828828882828888888888888888888888888888888888888888888888888282828282888828828288288282888288888888
82888828828282288888822282228828822282228888888888888888888888888888888888888888888888888222822282228828822288288222822288822288
82888828828282888888888282888828888288828888888888888888888888888888888888888888888888888282828282828828828288288882828888888888
82228222828282228888822282228288822288828888888888888888888888888888888888888888888888888222822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000060000600096500b6500f65013650196501d65022650276502b6502f6503265033650346503465034650346503465032650316502e65029650226501f6501865014650126500d650096500865000600
001000000565008650000000b6500e650136501a65021650266502c650316503465037650396503a6503b650000003b6503b65038650336502d6502965023650206501c65015650106500c650086500265002650
00010000000000000005650086500c6500f65012650166501b65020650246502c65030650316500000033650346503465034650316502c650246501e650146500f6500c650086500265000000000000000000000
010800000005102051040510505107051090510b0510c0510e05110051110511305117051180511a0511c0511d0511f05121051210511f0511d0511c0511a0511805117051150511305111051100510e0510c051
__music__
00 41424344
00 01030244

