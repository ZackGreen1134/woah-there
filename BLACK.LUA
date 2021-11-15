--[[
    not our src code!!!! idk what goes in here tbh
]]


local anti_aim = require "gamesense/antiaim_funcs"
local images = require 'gamesense/images'
local csgo_weapons = require 'gamesense/csgo_weapons'
local bullet = images.get_panorama_image("icons/ui/bullet.svg")
local client_color_log, client_delay_call, client_exec, client_eye_position, client_latency, client_screen_size, client_set_clan_tag, client_set_event_callback, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_dormant, entity_is_enemy, globals_curtime, math_abs, math_floor, math_max, math_min, math_random, math_sin, math_sqrt, renderer_text, ui_get, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_reference, ui_set_visible, pairs, ui_set = client.color_log, client.delay_call, client.exec, client.eye_position, client.latency, client.screen_size, client.set_clan_tag, client.set_event_callback, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_dormant, entity.is_enemy, globals.curtime, math.abs, math.floor, math.max, math.min, math.random, math.sin, math.sqrt, renderer.text, ui.get, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.reference, ui.set_visible, pairs, ui.set
    
local type         = type;
local setmetatable = setmetatable;
local tostring     = tostring;

local math_pi   = math.pi;
local math_min  = math.min;
local math_max  = math.max;
local math_deg  = math.deg;
local math_rad  = math.rad;
local math_sqrt = math.sqrt;
local math_sin  = math.sin;
local math_cos  = math.cos;
local math_atan = math.atan;
local math_acos = math.acos;
local math_fmod = math.fmod;

-- set up vector3 metatable
local _V3_MT   = {};
_V3_MT.__index = _V3_MT;

--
-- create Vector3 object
--
function Vector3( x, y, z )
    -- check args
    if( type( x ) ~= "number" ) then
        x = 0.0;
    end

    if( type( y ) ~= "number" ) then
        y = 0.0;
    end

    if( type( z ) ~= "number" ) then
        z = 0.0;
    end

    x = x or 0.0;
    y = y or 0.0;
    z = z or 0.0;

    return setmetatable(
        {
            x = x,
            y = y,
            z = z
        },
        _V3_MT
    );
end

--
-- metatable operators
--
function _V3_MT.__eq( a, b ) -- equal to another vector
    return a.x == b.x and a.y == b.y and a.z == b.z;
end

function _V3_MT.__unm( a ) -- unary minus
    return Vector3(
        -a.x,
        -a.y,
        -a.z
    );
end

function _V3_MT.__add( a, b ) -- add another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x + b.x,
            a.y + b.y,
            a.z + b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x + b,
            a.y + b,
            a.z + b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a + b.x,
            a + b.y,
            a + b.z
        );
    end
end

function _V3_MT.__sub( a, b ) -- subtract another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x - b.x,
            a.y - b.y,
            a.z - b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x - b,
            a.y - b,
            a.z - b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a - b.x,
            a - b.y,
            a - b.z
        );
    end
end

function _V3_MT.__mul( a, b ) -- multiply by another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x * b.x,
            a.y * b.y,
            a.z * b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x * b,
            a.y * b,
            a.z * b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a * b.x,
            a * b.y,
            a * b.z
        );
    end
end

function _V3_MT.__div( a, b ) -- divide by another vector or number
    local a_type = type( a );
    local b_type = type( b );

    if( a_type == "table" and b_type == "table" ) then
        return Vector3(
            a.x / b.x,
            a.y / b.y,
            a.z / b.z
        );
    elseif( a_type == "table" and b_type == "number" ) then
        return Vector3(
            a.x / b,
            a.y / b,
            a.z / b
        );
    elseif( a_type == "number" and b_type == "table" ) then
        return Vector3(
            a / b.x,
            a / b.y,
            a / b.z
        );
    end
end

function _V3_MT.__tostring( a ) -- used for 'tostring( vector3_object )'
    return "( " .. a.x .. ", " .. a.y .. ", " .. a.z .. " )";
end

--
-- metatable misc funcs
--
function _V3_MT:clear() -- zero all vector vars
    self.x = 0.0;
    self.y = 0.0;
    self.z = 0.0;
end

function _V3_MT:unpack() -- returns axes as 3 seperate arguments
    return self.x, self.y, self.z;
end

function _V3_MT:length_2d_sqr() -- squared 2D length
    return ( self.x * self.x ) + ( self.y * self.y );
end

function _V3_MT:length_sqr() -- squared 3D length
    return ( self.x * self.x ) + ( self.y * self.y ) + ( self.z * self.z );
end

function _V3_MT:length_2d() -- 2D length
    return math_sqrt( self:length_2d_sqr() );
end

function _V3_MT:length() -- 3D length
    return math_sqrt( self:length_sqr() );
end

function _V3_MT:dot( other ) -- dot product
    return ( self.x * other.x ) + ( self.y * other.y ) + ( self.z * other.z );
end

function _V3_MT:cross( other ) -- cross product
    return Vector3(
        ( self.y * other.z ) - ( self.z * other.y ),
        ( self.z * other.x ) - ( self.x * other.z ),
        ( self.x * other.y ) - ( self.y * other.x )
    );
end

function _V3_MT:dist_to( other ) -- 3D length to another vector
    return ( other - self ):length();
end

function _V3_MT:is_zero( tolerance ) -- is the vector zero (within tolerance value, can pass no arg if desired)?
    tolerance = tolerance or 0.001;

    if( self.x < tolerance and self.x > -tolerance and
        self.y < tolerance and self.y > -tolerance and
        self.z < tolerance and self.z > -tolerance ) then
        return true;
    end

    return false;
end

function _V3_MT:normalize() -- normalizes this vector and returns the length
    local l = self:length();
    if( l <= 0.0 ) then
        return 0.0;
    end

    self.x = self.x / l;
    self.y = self.y / l;
    self.z = self.z / l;

    return l;
end

function _V3_MT:normalize_no_len() -- normalizes this vector (no length returned)
    local l = self:length();
    if( l <= 0.0 ) then
        return;
    end

    self.x = self.x / l;
    self.y = self.y / l;
    self.z = self.z / l;
end

function _V3_MT:normalized() -- returns a normalized unit vector
    local l = self:length();
    if( l <= 0.0 ) then
        return Vector3();
    end

    return Vector3(
        self.x / l,
        self.y / l,
        self.z / l
    );
end

--
-- other math funcs
--
function clamp( cur_val, min_val, max_val ) -- clamp number within 'min_val' and 'max_val'
    if( cur_val < min_val ) then
        return min_val;

    elseif( cur_val > max_val ) then
        return max_val;
    end

    return cur_val;
end

function normalize_angle( angle ) -- ensures angle axis is within [-180, 180]
    local out;
    local str;

    -- bad number
    str = tostring( angle );
    if( str == "nan" or str == "inf" ) then
        return 0.0;
    end

    -- nothing to do, angle is in bounds
    if( angle >= -180.0 and angle <= 180.0 ) then
        return angle;
    end

    -- bring into range
    out = math_fmod( math_fmod( angle + 360.0, 360.0 ), 360.0 );
    if( out > 180.0 ) then
        out = out - 360.0;
    end

    return out;
end

function vector_to_angle( forward ) -- vector -> euler angle
    local l;
    local pitch;
    local yaw;

    l = forward:length();
    if( l > 0.0 ) then
        pitch = math_deg( math_atan( -forward.z, l ) );
        yaw   = math_deg( math_atan( forward.y, forward.x ) );
    else
        if( forward.x > 0.0 ) then
            pitch = 270.0;
        else
            pitch = 90.0;
        end

        yaw = 0.0;
    end

    return Vector3( pitch, yaw, 0.0 );
end

function angle_forward( angle ) -- angle -> direction vector (forward)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );

    return Vector3(
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    );
end

function angle_right( angle ) -- angle -> direction vector (right)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );
    local sin_roll  = math_sin( math_rad( angle.z ) );
    local cos_roll  = math_cos( math_rad( angle.z ) );

    return Vector3(
        -1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
        -1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
        -1.0 * sin_roll * cos_pitch
    );
end

function angle_up( angle ) -- angle -> direction vector (up)
    local sin_pitch = math_sin( math_rad( angle.x ) );
    local cos_pitch = math_cos( math_rad( angle.x ) );
    local sin_yaw   = math_sin( math_rad( angle.y ) );
    local cos_yaw   = math_cos( math_rad( angle.y ) );
    local sin_roll  = math_sin( math_rad( angle.z ) );
    local cos_roll  = math_cos( math_rad( angle.z ) );

    return Vector3(
        cos_roll * sin_pitch * cos_yaw + -sin_roll * -sin_yaw,
        cos_roll * sin_pitch * sin_yaw + -sin_roll * cos_yaw,
        cos_roll * cos_pitch
    );
end

function get_FOV( view_angles, start_pos, end_pos ) -- get fov to a vector (needs client view angles, start position (or client eye position for example) and the end position)
    local type_str;
    local fwd;
    local delta;
    local fov;

    fwd   = angle_forward( view_angles );
    delta = ( end_pos - start_pos ):normalized();
    fov   = math_acos( fwd:dot( delta ) / delta:length() );

    return math_max( 0.0, math_deg( fov ) );
end

local ref = {
    antiaim = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    bodyyaw = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
    fakeyawlimit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    freestandingbodyyaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    doubletap  = {ui_reference("Rage","Other","Double tap")},
    dtmode = ui_reference("Rage", "Other", "Double tap mode"),
    force = ui_reference("Rage", "Aimbot", "Force safe point"),
    baim = ui_reference("Rage", "Other", "Force body aim"),
    onshot = {ui_reference("AA", "Other", "On shot anti-aim")},
    dtlimit = ui_reference("Rage","Other","Double tap fake lag limit"),
    dt_hitchance = ui_reference("Rage","Other","Double tap hit chance"),
    fakeducking = ui_reference("RAGE", "Other", "Duck peek assist"),
    fakelag = ui_reference("AA", "Fake lag", "Enabled"),
    fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    quickpeek = {ui_reference( "Rage", "Other", "Quick peek assist")},
    slowwalk = {ui_reference("AA", "Other", "slow motion")},
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    sv_maxusrcmdprocessticks = ui_reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
    hitchance = ui_reference("Rage", "Aimbot", "Minimum hit chance")
}
local screen_width, screen_height = client.screen_size()

local aa = {
    label = ui_new_label("AA", "Anti-aimbot angles", "--------------------------------------------------"),
    label2 = ui_new_label("AA", "Anti-aimbot angles", "+        Build: Developer (11.15.2021)"),
    label3 = ui_new_label("AA", "Anti-aimbot angles", "--------------------------------------------------"),
    antiaim = ui_new_multiselect("AA", "Anti-aimbot angles", "glorius.lua settings", {"legit aa on use", "ideal tick", "adaptive doubletap", "double tap teleport", "crosshair indicators", "manual aa indicators", "glorious clantag", "debug anti-aim"}),
    distance_check = ui.new_slider("AA", "Anti-aimbot angles", "avoid overlap distance", 10, 50, 30, true, "ft"),
    indicators = ui_new_combobox("AA", "Anti-aimbot angles", "indicator options", {"-", "acatel", "highlander", "solaris", "prediction", "ideal yaw", "discombobulation", "genesis dt indicators"}),
    edgeyaw = ui_new_hotkey("AA", "Anti-aimbot angles", "edge yaw"),
    dt_key = ui_new_hotkey("AA", "Anti-aimbot angles", "double tap teleport"),  
    label = ui.new_label("AA", "Anti-aimbot angles", 'primary color'),
    primary_color = ui.new_color_picker("AA", "Anti-aimbot angles", ' ', 255, 80, 80, 255),
    label2 = ui.new_label("AA", "Anti-aimbot angles", 'secondary color'),
    secondary_color = ui.new_color_picker("AA", "Anti-aimbot angles", '  ', 255, 255, 255, 255),
    label3 = ui.new_label("AA", "Anti-aimbot angles", 'name color'),
    name_color = ui.new_color_picker("AA", "Anti-aimbot angles", '   ', 255, 255, 255, 255),
    mindmg = ui.new_hotkey("AA", "Anti-aimbot angles", "min dmg key"),
    slider_position_x = ui.new_slider("AA", "Anti-aimbot angles", '\nx position', 0, screen_width, 15, true, 'px'),
    slider_position_y = ui.new_slider("AA", "Anti-aimbot angles", '\ny position', 0, screen_height, screen_height / 2.3, true, 'px')
}

local solaris = {
    label = ui.new_label("AA", "Anti-aimbot angles", 'indicator color'),
    color = ui.new_color_picker("AA", "Anti-aimbot angles", 'solaris color', 130, 170, 225, 255),
}
local skip = false
local flip = false
local ab = 0
local cached = false
local cached_fl = false
local angles = {-95, 95}
local alpha = 0

client.exec("play UI/mm_success_lets_roll.wav")
client_color_log(255, 255, 255, " ")
client_color_log(255, 255, 255, "[Yui Corporations] Glorius Anti-Aim Lua Loaded Successfully!")
client_color_log(255, 255, 255, "[Yui Corporations] IP Has Been Logged Succesfully!")
client_color_log(255, 255, 255, "[Yui Corporations] HWID And PC Username Has Been Logged Succesfully!")
client_color_log(255, 255, 255, "[Yui Corporations] GPU Vendor, Device ID, And Driver Has Been Logged Succesfully!")


local function contains(item, val)
    table = ui.get(item)
        for i=1,#table do
            if table[i] == val then
                return true
            end
        end
        return false
    end


local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui_set_visible(table[i], state)
    end
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
        return math_floor(num * mult + 0.5) / mult
    end
        
local function or_table(bool_tbl, item, state)
    for k, v in pairs(bool_tbl) do
        if bool_tbl[k] then
            ui_set(item, state)
            break
        end
    end
end

function renderer.outline_rectangle(x, y, w, h, r, g, b, a)
    renderer.rectangle(x, y, w, 1, r, g, b, a)
    renderer.rectangle(x + w - 1, y, 1, h, r ,g, b, a)
    renderer.rectangle(x, y + h - 1, w, 1, r, g, b, a)
    renderer.rectangle(x, y, 1, h, r, g, b, a)
end

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

    return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end
    
local function calculate_stage(len, speed)
    return math_floor((globals_curtime() * speed / 10) % len + 1)
end
    
local function dist_from_3dline(shooter, e)
    local x, y, z = entity_hitbox_position(shooter, 0)
    local x1, y1, z1 = client_eye_position()
    
    local p = {x1,y1,z1}
    
    local a = {x,y,z}
    local b = {e.x,e.y,e.z}
    
    local ab = {b[1] - a[1], b[2] - a[2], b[3] - a[3]}
    local len = math_sqrt(ab[1]^2 + ab[2]^2 + ab[3]^2)
    local d  = {ab[1] / len, ab[2] / len, ab[3] / len}
    local ap = {p[1] - a[1], p[2] - a[2], p[3] - a[3]}
    local d2 = d[1]*ap[1] + d[2]*ap[2] + d[3]*ap[3]
    
    bp = {a[1] + d2 * d[1], a[2] + d2 * d[2], a[3] + d2 * d[3]}
    
    return (bp[1]-x1) + (bp[2]-y1) + (bp[3]-z1)
    end
    
    
 local function vec2_distance(f_x, f_y, t_x, t_y)
    local delta_x, delta_y = f_x - t_x, f_y - t_y
    return math.sqrt(delta_x*delta_x + delta_y*delta_y)
end

local function get_all_player_positions(screen_width, screen_height, enemies_only)
    local player_indexes = {}
    local player_positions = {}

    local players = entity.get_players(enemies_only) -- true = enemies only
    if #players == 0 then
        return
    end

    for i=1, #players do
        local player = players[i]

        local px, py, pz = entity.get_prop(player, 'm_vecOrigin')
        local vz = entity.get_prop(player, 'm_vecViewOffset[2]')

        if pz ~= nil and vz ~= nil then
            pz = pz + (vz*0.5)

            local sx, sy = client.world_to_screen(px, py, pz)
            if sx ~= nil and sy ~= nil then
                if sx >= 0 and sx <= screen_width and sy >= 0 and sy <= screen_height then
                    player_indexes[#player_indexes+1] = player
                    player_positions[#player_positions+1] = {sx, sy}
                end
            end
        end
    end
    return player_indexes, player_positions
end

local targetplayer = nil
local function check_fov()

    local local_player, local_origin = entity.get_local_player(), Vector3(entity.get_prop(local_player, 'm_vecAbsOrigin'))

    if local_player == nil then
        return
    end

    targetplayer = nil
    local players = entity.get_players(true)
    local pitch, yaw, roll = client.camera_angles()
    local cam_angle = Vector3(0, yaw, 0)
    local fov = 180

    for i=1, #players do
        local index = players[i]
        if entity.is_enemy(index) and entity.is_alive(index) and not entity.is_dormant(index) then
            local enemy_origin = Vector3(entity.get_prop(index, 'm_vecOrigin'))
            local cfov = get_FOV(cam_angle, local_origin, enemy_origin)
            if cfov < fov then
                fov = cfov
                targetplayer = index
            end
        end
    end

    return targetplayer
end

local function getDistance()
    local target_index = check_fov()
    local lp_index = entity.get_local_player()
    local lp_origin = Vector3(entity.get_prop(lp_index,'m_VecOrigin'))
    local target_origin = Vector3(entity.get_prop(target_index,'m_VecOrigin'))
    local dist = lp_origin:dist_to(target_origin)
    if (dist ~= nil) then
        -- Source SDK: #define METERS_PER_INCH (0.0254f)
        local meters = dist * 0.0254
        -- Convert to feet
        local feet = meters * 3.281
        return feet;
    end
end

client_set_event_callback("bullet_impact", function(c)
    if entity_is_alive(entity_get_local_player()) and not skip then
        local ent = client_userid_to_entindex(c.userid)
        if not entity_is_dormant(ent) and entity_is_enemy(ent) then
            local ent_pos = { entity_get_prop(ent, "m_vecOrigin") }
            local loc_pos = { entity_get_prop(ent, "m_vecOrigin") }

            local delta = dist_from_3dline(ent, c)
                if math_abs(delta) < 30  then
                    ab = ab + 1
                    flip = true
                end
            end
        end
        
        if flip then
            if ui_get(ref.antiaim) then
                ui_set(ref.bodyyaw[1], "Static")
                ui_set(ref.bodyyaw[2], angles[(ab%2)+1])
                ui_set(ref.fakeyawlimit, 60)
            end
        flip = false
    end
    skip = false
end)

client_set_event_callback("setup_command", function(cmd)

local x, y = entity_get_prop( entity_get_local_player(), "m_vecVelocity")
local speed = x ~= nil and math_floor(math_sqrt( x * x + y * y + 0.5 )) or 0
local in_air = entity_get_prop(entity_get_local_player(), "m_fFlags") == 256
local crouching_in_air = entity_get_prop(entity_get_local_player(), "m_fFlags") == 262
local crouching = entity_get_prop(entity_get_local_player(), "m_fFlags") == 263
local distance = math.floor(getDistance())

if ui_get(ref.antiaim) then
    if not cached then
        cached_jitter = ui_get(ref.jitter[1])
        cached_jitter_slider = ui_get(ref.jitter[2])
        cached_bodyyaw = ui_get(ref.bodyyaw[1])
        cached_slider = ui_get(ref.bodyyaw[2])
        cached_fake = ui_get(ref.fakeyawlimit)
        cached = true
    end
    if entity.is_alive(entity.get_local_player()) then
        if distance ~= nil and (distance <= ui_get(aa.distance_check) * 1.5) then
            if cmd.chokedcommands ~= 0 then
                return
            end       
            if anti_aim.get_overlap() > 0.615 then
                ui.set(ref.bodyyaw[1], 'Static')
                ui.set(ref.bodyyaw[2], anti_aim.get_desync(1) > 0 and -180 or 180)
            end
        end  
    end 
    if crouching then
        ui_set(ref.bodyyaw[1], "Jitter")
        ui_set(ref.bodyyaw[2], 0)
        ui_set(ref.fakeyawlimit, 30)
    elseif crouching_in_air or in_air then
        ui_set(ref.bodyyaw[1], "Jitter")
        ui_set(ref.bodyyaw[2], 0)
        ui_set(ref.fakeyawlimit, 60)
    elseif ui_get(ref.slowwalk[2]) and speed > 1 then
        ui_set(ref.jitter[1], "Offset")
        ui_set(ref.jitter[2], "7")
        ui_set(ref.bodyyaw[1], "Jitter")
        ui_set(ref.bodyyaw[2], 0)
        ui_set(ref.fakeyawlimit, 60)
    end
    if not crouching_in_air and not ui_get(ref.slowwalk[2]) and not in_air and not crouching and cached and distance > (ui_get(aa.distance_check) * 1.5) then
        ui_set(ref.jitter[1], cached_jitter)
        ui_set(ref.jitter[2], cached_jitter_slider)
        ui_set(ref.bodyyaw[1], cached_bodyyaw)
        ui_set(ref.bodyyaw[2], cached_slider)
        ui_set(ref.fakeyawlimit, cached_fake)
        cached = false
    end
end

    if contains(aa.antiaim, "legit aa on use") then
        if entity_get_player_weapon() ~= nil and entity_get_classname(weapon) == "CC4" then
            if cmd.in_attack == 1 then
                cmd.in_attack = 0 
                cmd.in_use = 1
            end
        else
            if cmd.chokedcommands == 0 then
                cmd.in_use = 0
            end
        end
    end

    if contains(aa.antiaim, "double tap teleport") then
        ui_set(ref.doubletap[1], true)
        if ui_get(aa.dt_key) then
            ui_set(ref.doubletap[1], false)
        end
    end    

    
    if contains(aa.antiaim, "ideal tick") and ui_get(ref.quickpeek[2]) then
        ui_set(ref.freestanding[1], "Default")
        ui_set(ref.freestanding[2], "Always on")
    else
        ui_set(ref.freestanding[1], " ")
        ui_set(ref.freestanding[2], "On hotkey")
    end

local latency = math_floor(client_latency()*1000+0.5)
if contains(aa.antiaim, "adaptive doubletap") then
    if (latency < 35) then
        if speed < 80 then
            ui_set(ref.sv_maxusrcmdprocessticks, 18)
            ui_set(ref.fakelag_limit, 15)
        elseif (latency < 35) and speed > 200 then
            ui_set(ref.sv_maxusrcmdprocessticks, 16)
            ui_set(ref.fakelag_limit, 14)
        end
        elseif (latency > 36) then
            if speed < 80 then
                ui_set(ref.sv_maxusrcmdprocessticks, 17)
                ui_set(ref.fakelag_limit, 15)
            elseif (latency > 36) and speed > 200 then
                ui_set(ref.sv_maxusrcmdprocessticks, 16)
                ui_set(ref.fakelag_limit, 14)
            end
        end
    end

    if contains(aa.antiaim, "ideal tick") then
        if ui_get(ref.quickpeek[2])then
            ui_set(ref.fakelag_limit, 1)
        elseif contains(aa.antiaim, "ideal tick") and not contains(aa.antiaim, "adaptive doubletap") and not ui_get(ref.quickpeek[2]) then
            ui_set(ref.fakelag_limit, 14)
        end 
    end

    ui_set(ref.edgeyaw, ui_get(aa.edgeyaw) and true or false)
end)

    
local function indicators()
    local x, y = client_screen_size()
    local x1, y1 = entity.get_prop( entity.get_local_player(), 'm_vecVelocity')
    local speed = x ~= nil and math.floor(math.sqrt( x1 * x1 + y1 * y1 + 0.5 )) or 0
    local in_air = entity_get_prop(entity_get_local_player(), "m_fFlags") == 256
    local crouching_in_air = entity.get_prop(entity.get_local_player(), "m_fFlags") == 262
    local crouching = entity.get_prop(entity.get_local_player(), "m_fFlags") == 263
    -- reminder to brain:
    -- if not dormant show fake
    -- if dormant and fake show dormant
    local alpha = math_sin(math_abs((math.pi * -1) + (globals_curtime() * 1.5) % (math.pi * 2))) * 255
    local body_yaw = math_max(-60, math_min(60, round((entity_get_prop(entity_get_local_player(), "m_flPoseParameter", 11) or 0)*120-60+0.5, 1)))
    local angle = ui_get(ref.bodyyaw[2])

    local clr = {ui_get(aa.primary_color)}
    local clr2 = {ui_get(aa.secondary_color)}
    local clr3 = {ui_get(aa.name_color)}
    local clr4 = {ui_get(solaris.color)}

    local me = entity.get_local_player()

    local screen_size = { client.screen_size() }
    local camera_angles = { client.camera_angles() }

    local sx, sy = screen_size[1] / 2, screen_size[2] / 2

    local by = anti_aim.normalize_angle(camera_angles[2] - anti_aim.get_body_yaw(1) - 120)
	local fy = anti_aim.normalize_angle(camera_angles[2] - anti_aim.get_body_yaw(2) - 120)

    local chokedcommands = globals.chokedcommands()
    local body_yaw_solaris = 0
    local fake_lag_limit = ui.get(ref.fakelag_limit)
    local players = entity.get_players(true)

    local local_player = entity.get_local_player()
    local weapon_ent = entity.get_player_weapon(local_player)
    local weapon = csgo_weapons(weapon_ent)
    local weapon_icon = images.get_weapon_icon(weapon)

    if chokedcommands then
        chokedcommands = chokedcommands / fake_lag_limit
    end

    local local_player = entity.get_local_player()
    local bodyyaw = entity.get_prop(local_player, 'm_flPoseParameter', 11)
        if bodyyaw then
            bodyyaw = math.abs(map(bodyyaw, 0, 1, -60, 60))
            bodyyaw = math.max(0, math.min(57, bodyyaw))
            body_yaw_solaris = bodyyaw / 57
        end
    

    if entity_is_alive(entity_get_local_player()) then      
        if ui_get(aa.indicators) == "acatel" then
            renderer_text(x/2, y/2 + 20, 255, 255, 255, 255, "-", nil,"GLORIOUS")
            renderer_text(x/2, y/2 + 20, 255, 150, 140, alpha, "-", nil,"                                     BETA")
            renderer_text(x/2, y/2 + 28, 140, 170, 220, 255, "-", nil,"FAKE YAW:")

        if body_yaw > 0 then
            renderer_text(x/2, y/2 + 28, 255, 255, 255, 255, "-", nil,"                                     L")
        else
            renderer_text(x/2, y/2 + 28, 255, 255, 255, 255, "-", nil,"                                     R")
        end

        if ui_get(ref.doubletap[2]) or ui_get(ref.onshot[2]) then
            cached_value = y/ 2 + 44
            cached_ab = y/ 2 + 52
        else
            cached_value = y/ 2 + 36
            cached_ab = y/ 2 + 44 
        end

        if ui_get(ref.doubletap[2]) then
            if anti_aim.get_double_tap() then
                renderer_text(x/2, y/2 + 36, 170, 235, 140, 255, "-", nil,"DT")
            elseif not anti_aim.get_double_tap() or ui_get(ref.fakeducking) then
                renderer_text(x/2, y/2 + 36, 255, 100, 100, 255, "-", nil,"DT")
            end
        end 

        if not ui_get(ref.doubletap[2]) and ui_get(ref.onshot[2]) then
            renderer_text(x/2, y/2 + 36, 170, 235, 140, 255, "-", nil,"OS")
        end
        if ui_get(ref.doubletap[2]) and ui_get(ref.onshot[2]) then
            renderer_text(x/2 + 10, y/2 + 36, 170, 235, 140, 255, "-", nil,"OS")
        end
        if ui_get(ref.baim) then
            renderer_text(x/2, cached_value, 255, 255, 255, 255, "-", nil,"BAIM")
        else
            renderer_text(x/2, cached_value, 255, 255, 255, 165, "-", nil,"BAIM")
        end
        if ui_get(ref.freestanding[2]) then
            renderer_text(x/2 + 32, cached_value, 255, 255, 255, 255, "-", nil,"FS")
        else
            renderer_text(x/2 + 32, cached_value, 255, 255, 255, 185, "-", nil,"FS")
        end 
        if ui_get(ref.force) then
            renderer_text(x/2 + 20, cached_value, 255, 255, 255, 255, "-", nil, "SP")
        else
            renderer_text(x/2 + 20, cached_value, 255, 255, 255, 185, "-", nil, "SP")
        end
    end

    if ui_get(aa.indicators) == "highlander" then
        if ui_get(ref.onshot[2]) then
            renderer_text(x/2, y/2 + 46, 255, 255, 255, 255, "-c", nil,"ONSHOT")
        else
            renderer_text(x/2, y/2 + 46, 170, 170, 170, 255, "-c", nil,"ONSHOT")
        end
    if ui_get(ref.doubletap[2]) and anti_aim.get_double_tap() and not ui_get(ref.quickpeek[2]) then 
            renderer_text(x/2, y/2 + 54, 255, 255, 255, 255, "-c", nil,"DT")
        elseif not anti_aim.get_double_tap() or ui_get(ref.fakeducking) or not ui_get(ref.doubletap[2])then
            renderer_text(x/2, y/2 + 54, 170, 170, 170, 255, "-c", nil,"DT")
        end
        if ui_get(ref.doubletap[2]) and anti_aim.get_double_tap() and ui_get(ref.quickpeek[2]) then
            renderer_text(x/2, y/2 + 54, 255, 255, 255, 255, "-c", nil,"DT - IDEAL TICK")
        end
        if in_air then
            renderer_text(x/2, y/2 + 62, 170, 170, 170, 255, "-c", nil,"IN AIR")
        end
        if speed > 2 and not in_air then
            renderer_text(x/2, y/2 + 62, 170, 170, 170, 255, "-c", nil,"MOVING")
        end
        if speed < 2 and not in_air then
            renderer_text(x/2, y/2 + 62, 170, 170, 170, 255, "-c", nil,"STANDING")
        end
        if ui_get(aa.mindmg) then
            renderer_text(x/2, y/2 + 38, 149, 143, 196, 255, "-c", nil,"MIN DAMAGE") 
        else
            renderer_text(x/2, y/2 + 38, 170, 170, 170, 255, "-c", nil,"MIN DAMAGE")
        end
        renderer_text(x/2, y/2 + 30, 143, 159, 184, 255, "-c", nil,"GLORIOUS")
    end


    if ui_get(aa.indicators) == "discombobulation" then
        renderer_text(x/2 - 3, y/2 + 25, clr3[1], clr3[2], clr3[3], clr3[4], "-c", nil, "GLORIUS")
            --deync line
        renderer.gradient(x/2 - 1, y/2 + 40,-body_yaw * 1.5, 3, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer.gradient(x/2 - 1, y/2 + 40, body_yaw * 1.5, 3, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer_text(x/2 - 2, y/2 + 41, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil, "DESYNC")
            --fake lag line
        renderer.gradient(x/2 + 16, y/2 + 48, chokedcommands * 64, 3, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer.gradient(x/2 - 18, y/2 + 48, -chokedcommands * 64, 3, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer_text(x/2 - 3, y/2 + 49, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil, "FAKE LAG")

        if ui_get(ref.doubletap[2]) and anti_aim.get_double_tap() then
            renderer_text(x/2 - 23, y/2 + 33, clr[1], clr[2], clr[3], clr[4], "-c", nil, "DT")
        elseif ui_get(ref.fakeducking) or not ui_get(ref.doubletap[2]) or not anti_aim.get_double_tap() then
            renderer_text(x/2 - 23, y/2 + 33, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil," DT")
        end
        if ui_get(ref.onshot[1]) and ui_get(ref.onshot[2]) then
            renderer_text(x/2 - 9, y/2 + 33, clr[1], clr[2], clr[3], clr[4], "-c", nil,"OS")
        else
            renderer_text(x/2 - 9, y/2 + 33, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil,"OS")
        end
        if ui_get(ref.force) then
            renderer_text(x/2 + 5, y/2 + 33, clr[1], clr[2], clr[3], clr[4], "-c", nil, "SP")
        else
            renderer_text(x/2 + 5, y/2 + 33, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil, "SP")
        end
        if ui_get(ref.fakeducking) then
            renderer_text(x/2 + 18, y/2 + 33, clr[1], clr[2], clr[3], clr[4], "-c", nil, "FD")
        else
            renderer_text(x/2 + 18, y/2 + 33, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil, "FD")
        end
    end

    if ui_get(aa.indicators) == "solaris" then
        renderer_text(x/2 - 15, y/2 + 19, 255, 255, 255, 255, "-c", nil, "GLORIUS")
        renderer_text(x/2 + 15, y/2 + 19, clr4[1], clr4[2], clr4[3], clr4[4], "-c", nil, "[BETA]")
        renderer.rectangle(x/2 - 30, y/2 + 25, 61, 4, 0, 0, 0, 75)
        renderer.rectangle(x/2 - 30, y/2 + 25, 60 * body_yaw_solaris, 3, clr4[1], clr4[2], clr4[3], clr4[4], true)
    if ui_get(ref.bodyyaw[1]) == "Jitter" then
        renderer_text(x/2 - 1, y/2 + 34, 255, 255, 255, 255, "-c", nil, "JITTER AA")
    end
    if ui_get(ref.bodyyaw[1]) == "Static" and angle == -95 or angle == 95 then
        renderer_text(x/2 - 1, y/2 + 34, 255, 255, 255, 255, "-c", nil, "ANTI-BRUTE")
    end
    if anti_aim.get_overlap() > 0.615 and angle == -180 or anti_aim.get_overlap() > 0.615 and angle == 180 then
        renderer_text(x/2 - 1, y/2 + 34, 255, 255, 255, 255, "-c", nil, "AVOID OVERLAP")
    end
	renderer.circle_outline(sx - 2, sy + 10, 255, 255, 255, 255, 60, by, 0.07, 5)
	renderer.circle_outline(sx - 2, sy + 10, clr4[1], clr4[2], clr4[3], clr4[4], 60, fy, 0.07, 5)
end

    if ui_get(aa.indicators) == "genesis dt indicators" then
        renderer.rectangle(ui_get(aa.slider_position_x)/2 - 170, ui_get(aa.slider_position_y)/2 + 19, 280, 14, 0, 0, 0, 125)
        renderer.gradient(ui_get(aa.slider_position_x)/2 - 30, ui_get(aa.slider_position_y)/2 + 17, -chokedcommands * 160, 1, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer.gradient(ui_get(aa.slider_position_x)/2 - 30, ui_get(aa.slider_position_y)/2 + 17, chokedcommands * 160, 1, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer.gradient(ui_get(aa.slider_position_x)/2 - 170, ui_get(aa.slider_position_y)/2 + 32, chokedcommands * 180, 1, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer.gradient(ui_get(aa.slider_position_x)/2 + 110, ui_get(aa.slider_position_y)/2 + 32, -chokedcommands * 180, 1, clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0, 0, 0, 0, 0,  true)
        renderer_text(ui_get(aa.slider_position_x)/2 - 30, ui_get(aa.slider_position_y)/2 + 25, 255, 255, 255, 255, "c", nil, "Glorius [debug] | ", ui_get(ref.hitchance), " | ", "tickbase: ", ui_get(ref.sv_maxusrcmdprocessticks), "/2", "(", ui_get(ref.dt_hitchance), "%", ")",  " | ", "safe: false")
        weapon_icon:draw(ui_get(aa.slider_position_x)/2 - 170, ui_get(aa.slider_position_y)/2 + 35, 40, 15,255, 255, 255, 255)
    if anti_aim.get_double_tap() then
        bullet:draw(ui_get(aa.slider_position_x)/2 - 130, ui_get(aa.slider_position_y)/2 + 37, 17, 12, 255, 255, 255, 255)
        bullet:draw(ui_get(aa.slider_position_x)/2 -120, ui_get(aa.slider_position_y)/2 + 37, 17, 12, 255, 255, 255, 255) 
    end   
end

    if ui_get(aa.indicators) == "prediction" then
        if body_yaw > 0 then 
            renderer_text(x/2 - 6 , y/2 + 18, clr[1], clr[2], clr[3], clr[4], "cb", nil, "glor")
            renderer_text(x/2 + 13, y/2 + 18, clr2[1], clr2[2], clr2[3], clr2[4], "cb", nil, "ius°")
        else
            renderer_text(x/2 - 6, y/2 + 18, clr2[1], clr2[2], clr2[3], clr2[4], "cb", nil, "glor")
            renderer_text(x/2 + 13, y/2 + 18, clr[1], clr[2], clr[3], clr[4], "cb", nil, "ius°")
        end
        if speed < 2  and ui_get(ref.bodyyaw[1]) == "Static" then
            renderer_text(x/2 , y/2 + 28, clr[1], clr[2], clr[3], clr[4], "-c", nil, "ANTI-BRUTE")
        end
        if ui_get(ref.bodyyaw[1]) == "Jitter" and ui_get(ref.slowwalk[2]) and not in_air then
            renderer_text(x/2 , y/2 + 28, clr[1], clr[2], clr[3], clr[4], "-c", nil, "DANGEROUS")
        end
        if speed > 2 and not in_air and not ui_get(ref.slowwalk[2]) then
            renderer_text(x/2 , y/2 + 28, clr[1], clr[2], clr[3], clr[4], "-c", nil, "MOVING")
        end
        if in_air or crouching_in_air then
            renderer_text(x/2 , y/2 + 28, clr[1], clr[2], clr[3], clr[4], "-c", nil, "AEROBIC")
        end
        if crouching and speed == 1 then
            renderer_text(x/2 , y/2 + 28, clr[1], clr[2], clr[3], clr[4], "-c", nil, "CROUCHED")
        end
        if ui_get(ref.doubletap[2]) and anti_aim.get_double_tap() then
            renderer_text(x/2, y/2 + 36, clr[1], clr[2], clr[3], clr[4], "-c", nil, "DT")
        elseif ui_get(ref.fakeducking) or not ui_get(ref.doubletap[2]) or not anti_aim.get_double_tap() then
            renderer_text(x/2, y/2 + 36, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil," DT")
        end
        if ui_get(ref.onshot[1]) and ui_get(ref.onshot[2]) then
            renderer_text(x/2, y/2 + 44, clr[1], clr[2], clr[3], clr[4], "-c", nil,"OS-AA")
        else
            renderer_text(x/2, y/2 + 44, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil,"OS-AA")
        end
        if ui_get(ref.force) then
            renderer_text(x/2, y/2 + 52, clr[1], clr[2], clr[3], clr[4], "-c", nil,"SAFE")
        else
            renderer_text(x/2, y/2 + 52, clr2[1], clr2[2], clr2[3], clr2[4], "-c", nil,"SAFE")
        end
    end


    if ui_get(aa.indicators) == "ideal yaw" then
        renderer_text(x/2, y/2 + 40, 215, 114, 44, 255, " ", nil,"IDEAL YAW")
        if ui_get(ref.bodyyaw[1]) == "Jitter" then
            renderer_text(x/2, y/2 + 50, 209, 139, 230, 255, " ", nil,"DYNAMIC")
        elseif ui_get(ref.bodyyaw[1]) == "Static" then
            renderer_text(x/2, y/2 + 50, 245, 10, 5, 255, " ", nil,"DEFAULT")
        end

        if ui_get(ref.doubletap[2]) and anti_aim.get_double_tap() then
            renderer_text(x/2, y/2 + 60, 10, 245, 5, 255, " ", nil, "DT")
        elseif ui_get(ref.fakeducking) or not ui_get(ref.doubletap[2]) or not anti_aim.get_double_tap() then
            renderer_text(x/2, y/2 + 60, 245, 10, 5, 255, " ", nil,"DT")
        end

        if ui_get(ref.onshot[1]) and ui_get(ref.onshot[2]) then
            renderer_text(x/2 + 15, y/2 + 60, 10, 245, 5, 255, " ", nil,"AA")
        end
    end


    if contains(aa.antiaim, "manual aa indicators") then
        renderer_text(x/2 - 71, y/2 - 1, 255, 255, 255, 120, "c+", nil,"◀")
        renderer_text(x/2 + 64, y/2 - 1, 255, 255, 255, 120, "c+", nil,"▶")
        if body_yaw > 0 then
            renderer_text(x/2 + 52, y/2, clr[1], clr[2], clr[3], clr[4], "c+", nil,"|")
            renderer_text(x/2 - 59, y/2, 255, 255, 255, 120, "c+", nil,"|")
        else
            renderer_text(x/2 - 59, y/2, clr[1], clr[2], clr[3], clr[4], "c+", nil,"|")
            renderer_text(x/2 + 52, y/2, 255, 255, 255, 120, "c+", nil,"|")
            end
        end
    end
end
-- add keybinds to solaris 

    
local tags = {
     " ",
     " ",
     "G",
     "Gl",
     "Glo",
     "Glor", 
     "Glori",
     "Glorio",
     "Gloriou", 
     "Glorious",
     "Glorious.",
     "Glorious.l",
     "Glorious.lu",
     "Glorious.lua",
     "Glorious.lua ",
     "Glorious.lua ",
     "Glorious.lua ",
     "Glorious.lua",
     "Glorious.lu",
     "Glorious.l",
     "Glorious.",
     "Glorious",
     "Gloriou",
     "Glorio",
     "Glori",
     "Glor",
     "Glo",
     "Gl",
     "G",
     " ",
     " ",
}

local function clantag_changer()
    if contains(aa.antiaim, "glorious clantag") then
        local tag = tags[calculate_stage(#tags, 30)]

        if clantag_old ~= tag then
            client_set_clan_tag(" ".. tag)
            clantag_old = tag
            clantag_override = true
        end
    else
        if clantag_override then
            client_delay_call(0.1, function() client_set_clan_tag(" ") end)
            clantag_override = false
        end
    end
end
    
local references = {ref.pitch, ref.yawbase, ref.yaw[1], ref.yaw[2], ref.bodyyaw[1], ref.bodyyaw[2], ref.fakeyawlimit, ref.jitter[1], ref.jitter[2], ref.freestandingbodyyaw, ref.freestanding[1], ref.freestanding[2], ref.edgeyaw}

local function hide_shit()
    SetTableVisibility(references, false)
    SetTableVisibility(references, contains(aa.antiaim, "debug anti-aim"))
    SetTableVisibility({solaris.label, solaris.color}, ui.get(aa.indicators) == "solaris")
    SetTableVisibility({aa.label, aa.label2, aa.label3, aa.primary_color, aa.secondary_color, aa.name_color}, ui.get(aa.indicators) == "discombobulation" or ui.get(aa.indicators) == "prediction")

    if ui_get(aa.indicators) == "prediction" then
        ui_set_visible(aa.label3, false)
        ui_set_visible(aa.name_color, false)
    end

    ui_set_visible(aa.edgeyaw, contains(aa.antiaim, "edge yaw"))
    ui_set_visible(aa.mindmg, ui_get(aa.indicators) == "highlander")
    ui_set_visible(aa.dt_key, contains(aa.antiaim, "double tap teleport"))
    ui_set_visible(aa.indicators, contains(aa.antiaim, "crosshair indicators"))

    if not contains(aa.antiaim, "crosshair indicators") then
        ui_set(aa.indicators, "-")
    end
end
    
local function on_shutdown()
    SetTableVisibility(references, true)
    client_set_clan_tag(" ")
end

client_set_event_callback("shutdown", on_shutdown)
client_set_event_callback("paint_ui", hide_shit)
client_set_event_callback("paint", clantag_changer)
client_set_event_callback("paint", indicators)
