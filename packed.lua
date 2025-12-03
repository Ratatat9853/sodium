-- Auto-generated bundle
local __bundle = {}
local __loaded = {}

function require(path)
    if __loaded[path] then
        return __loaded[path]
    end

    local chunk = __bundle[path]
    if not chunk then
        error("Module not found: " .. path)
    end

    local fn, err = load(chunk, path)
    if not fn then
        error("Failed to load module: " .. path .. " (" .. tostring(err) .. ")")
    end
    local result = fn()
    __loaded[path] = result or true
    return __loaded[path]
end

__bundle["require/aa/player_condition"] = [[
local libs = require("require/help/libs")
local aa_funcs = libs.get("antiaim_funcs")
local entity = libs.get("entity") or entity
local bit = libs.get("bit") or bit
local var_0_166 = require('require/abc/menu_setup')
local air_tick_state = { last_air = false, last_tick = (0), last_cond = nil }

local function var_0_42(cond)
    
    if cond == 'global' then return true end
    if not var_0_166 or not var_0_166.ui then return true end
    local enable_key = 'enable_' .. cond
    local item = var_0_166.ui[enable_key]
    if not item then
        
        return true
    end
    local ok, val = pcall(ui.get, item)
    return ok and val == true
end


local function var_0_92()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then
        return nil
    end
    
    
    if client.key_state(0x45) then
        if var_0_42('legit') then return "legit" end
    end

    local get_double_tap = false
    if aa_funcs and aa_funcs.get_double_tap then
        get_double_tap = aa_funcs.get_double_tap()
    else
        get_double_tap = true
    end

    
    
    if get_double_tap == false then
        if var_0_42('fakelag') then return "fakelag" end
    end

    
    if misc_gs_hotkey_slowmotion and ui.get(misc_gs_hotkey_slowmotion) == true then
        if var_0_42('walk') then return "walk" end
    end
    
    
    if client.key_state(0x10) then
        local vel_x, vel_y = entity.get_prop(lp, 'm_vecVelocity')
        local velocity = math.sqrt((vel_x or (0))^(1+1) + (vel_y or (0))^(1+1))
        if velocity >= (10*2) and velocity <= (70*2) then
            if var_0_42('walk') then return "walk" end
        end
    end



    local vel_x, vel_y = entity.get_prop(lp, 'm_vecVelocity')
    local velocity = math.sqrt((vel_x or (0))^(1+1) + (vel_y or (0))^(1+1))
    local ducking = entity.get_prop(lp, 'm_flDuckAmount') > (0.5)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags') or (0), (1)) == (1)
    local tick = globals.tickcount()

    
    if not on_ground then
        if ducking then
            air_tick_state.last_air = true
            air_tick_state.last_tick = tick
            air_tick_state.last_cond = "jump+"
            if var_0_42('jump+') then return "jump+" end 
        else
            air_tick_state.last_air = true
            air_tick_state.last_tick = tick
            air_tick_state.last_cond = "jump"
            if var_0_42('jump') then return "jump" end
        end
    else
        
        if air_tick_state.last_air and (tick - air_tick_state.last_tick <= (1+1)) then
            if air_tick_state.last_cond and var_0_42(air_tick_state.last_cond) then
                return air_tick_state.last_cond
            end
        end
        air_tick_state.last_air = false
        air_tick_state.last_cond = nil
    end

    if ducking then
        if velocity >= (1+1) then
            if var_0_42('duck+') then return "duck+" end 
        else
            if var_0_42('duck') then return "duck" end 
        end
    else
        if velocity >= (1+1) then
            if var_0_42('move') then return "move" end 
        else
            if var_0_42('stand') then return "stand" end 
        end
    end

    
    return "global"
end

return {
    get = var_0_92
}]]
__bundle["require/abc/build_menu"] = [[local conditions = {
    "global",
    "stand",
    "move",
    "duck",
    "duck+",
    "jump",
    "jump+",
    "walk",
    "fakelag",
    "legit",
}

local var_0_166 = require("require/abc/menu_setup")
local COLORS = require("require/help/color")

local function var_0_25(modules)
    
    
    local CFG_LIST_KEY = 'inDGnidgdisgndsin'

    local function var_0_195()
        local t = database.read(CFG_LIST_KEY)
        return type(t) == 'table' and t or {}
    end

    local function var_0_283(t)
        database.write(CFG_LIST_KEY, t)
    end

    local function var_0_83(t, name)
        for i = (1), #t do if t[i] == name then return i end end
        return nil
    end

    
    
    
    local function var_0_244()
        if not (modules and modules.var_0_166 and modules.var_0_166.ui and modules.var_0_166.ui.paint_logger) then
            return false
        end
        local ok, val = pcall(ui.get, modules.var_0_166.ui.paint_logger)
        if not ok or not val then return false end
        if type(val) == 'table' then
            for _, v in ipairs(val) do
                if tostring(v) == 'config' then return true end
            end
            return false
        else
            return tostring(val) == 'config'
        end
    end

    local function var_0_200(preserve_name)
        local names = var_0_195()
        if #names == (0) then names = {'(empty)'} end
            
            if var_0_166.ui.cfg_listbox then
                pcall(ui.set_visible, var_0_166.ui.cfg_listbox, false)
            end
            
            var_0_166.ui.cfg_listbox = var_0_166.register_ui(
                ui.new_listbox('AA', 'Anti-aimbot angles', 'Configs', names),
                { requires_login = true, key = 'cfg_listbox', tab = 'CFG', visible = true, config_type = 'listbox' }
            )
        if preserve_name then
            local idx = var_0_83(names, preserve_name)
            if idx then ui.set(var_0_166.ui.cfg_listbox, idx-(1)) end
        end
    end
 
    
    
    
    var_0_166.ui.cache_credentials = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'Cache credentials'),
        { requires_login = false, key = 'cache_credentials', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.login_username = var_0_166.register_ui(
        ui.new_textbox('AA', 'Anti-aimbot angles', 'Username', 'username'),
        { requires_login = false, key = 'login_username', tab = 'AA', visible = true, config_type = 'textbox' }
    )
    var_0_166.ui.login_password = var_0_166.register_ui(
        ui.new_textbox('AA', 'Anti-aimbot angles', 'Password', 'password'),
        { requires_login = false, key = 'login_password', tab = 'AA', visible = true, config_type = 'textbox' }
    )
    var_0_166.ui.login_howto_header = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '───────[ ' .. COLORS.get("white", "ui") .. 'How to ' .. COLORS.get("green", "ui") .. 'log in' .. COLORS.get("grey", "ui") .. ' ]───────'),
        { requires_login = false, key = 'login_howto_header', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.login_console_register = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '1. In console -> "register ' .. COLORS.get("green", "ui") .. 'user' .. COLORS.get("grey", "ui") .. ' ' .. COLORS.get("red", "ui") .. 'pass' .. COLORS.get("grey", "ui") .. ' ' .. COLORS.get("blue", "ui") .. 'code' .. COLORS.get("grey", "ui") .. '"'),
        { requires_login = false, key = 'login_console_register', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.login_menu_credentials = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '2. Write password & username in the menu.'),
        { requires_login = false, key = 'login_menu_credentials', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.login_press_login = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '3. Press log in and enjoy ' .. COLORS.get("green", "ui") .. 'premium features' .. COLORS.get("grey", "ui") .. '.'),
        { requires_login = false, key = 'login_press_login', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.login_spacer1 = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', ' '),
        { requires_login = false, key = 'login_spacer1', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.reset_header = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '───────[ ' .. COLORS.get("white", "ui") .. 'How to ' .. COLORS.get("yellow", "ui") .. 'reset pass' .. COLORS.get("grey", "ui") .. ' ]───────'),
        { requires_login = false, key = 'reset_header', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.reset_step1 = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '1. Write username -> press reset.'),
        { requires_login = false, key = 'reset_step1', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.reset_step2 = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '2. Login with your oldest password.'),
        { requires_login = false, key = 'reset_step2', tab = 'AA', visible = true, config_type = 'label' }
    )

    var_0_166.ui.login_spacer2 = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', ' '),
        { requires_login = false, key = 'login_spacer2', tab = 'AA', visible = true, config_type = 'label' }
    )

    var_0_166.ui.support_header = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '───────[ ' .. COLORS.get("red", "ui") .. 'Support & Other' .. COLORS.get("grey", "ui") .. ' ]───────'),
        { requires_login = false, key = 'support_header', tab = 'AA', visible = true, config_type = 'label' }
    )
        var_0_166.ui.support_discord = var_0_166.register_ui(
        ui.new_label('AA', 'Fake lag', COLORS.get("grey", "ui") .. '1. Join the ' .. COLORS.get("discord", "ui") .. 'discord ' .. COLORS.get("grey", "ui") .. 'for support.'),
        { requires_login = false, key = 'support_discord', tab = 'AA', visible = true, config_type = 'label' }
    )



    var_0_166.ui.login_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', COLORS.get("green", "ui") .. 'Login', function()
            local username = modules.safe.var_0_222(var_0_166.ui.login_username)
            local password = modules.safe.var_0_222(var_0_166.ui.login_password)
            local cache = modules.safe.var_0_222(var_0_166.ui.cache_credentials)
            if username ~= '' and password ~= '' then
                local success = modules.login.login(username, password)
                if success then
                    modules.var_0_192("Welcome back, " .. modules.str.capitalize(username) .. ". You logged in successfully.", (2+1), (25*3), (29*5), (11*5), (85*3))
                    if cache then
                        database.write('cached_credentials', { username = username, password = password })
                    else
                        database.write('cached_credentials', nil)
                    end
                    local r,g,b = COLORS.get("green", "log")
                    client.color_log(r,g,b, 'Login successful!')
                else
                    local r,g,b = COLORS.get("red", "log")
                    client.color_log(r,g,b, 'Login failed!')
                end
            end
                if modules.menu_visibility and modules.menu_visibility.update then
                    modules.menu_visibility.update(modules)
                end
        end),
        { requires_login = false, key = 'login_button', tab = 'AA', visible = true, config_type = 'button' }
    )
    var_0_166.ui.logout_button = var_0_166.register_ui(
        ui.new_button('AA', 'Other', COLORS.get("red", "ui") .. 'Logout', function()
            modules.login.logout()
            local r,g,b = COLORS.get("red", "log")
            client.color_log(r,g,b, 'Logged out!')
            
                if modules.menu_visibility and modules.menu_visibility.update then
                    modules.menu_visibility.update(modules)
                end
        end),
        { requires_login = true, key = 'logout_button', tab = 'CFG', visible = true, config_type = 'button' }
    )
    var_0_166.ui.reset_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', COLORS.get("yellow", "ui") .. 'Reset', function()
            local username = modules.safe.var_0_222(var_0_166.ui.login_username)
            modules.login.reset_password(username)
            local r,g,b = COLORS.get("yellow", "log")
            client.color_log(r,g,b, 'Password reset.')
            modules.var_0_192("Password reset for user: " .. username, (4+1), (85*3), (85*3), (0), (85*3))
                if modules.menu_visibility and modules.menu_visibility.update then
                    modules.menu_visibility.update(modules)
                end
        end),
        { requires_login = true, key = 'reset_button', tab = 'AA', visible = true, config_type = 'button' }
    )


    
    
    
    var_0_166.ui.condition = var_0_166.register_ui(
        ui.new_combobox('AA', 'Anti-aimbot angles', 'condition', unpack(conditions)),
        { requires_login = true, key = 'condition', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.misc_resolver = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'resolver'),
        { requires_login = true, key = 'misc_resolver', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.misc_ragebot = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'ragebot'),
        { requires_login = true, key = 'misc_ragebot', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    
    
    

    


    
    
    
    var_0_166.ui.misc_dormantaimbot = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'dormant aimbot'),
        { requires_login = true, key = 'misc_dormantaimbot', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.misc_exploit_fakelag = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'limit exploit fakelag'),
        { requires_login = true, key = 'misc_exploit_fakelag', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.misc_walkbot = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'walkbot'),
        { requires_login = true, key = 'misc_walkbot', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.misc_buybot = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Other', 'buybot', true),
        { requires_login = true, key = 'misc_buybot', tab = 'MISC', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.misc_buybot_primary = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Other', 'primary', 'awp', 'auto', 'ssg'),
        { requires_login = true, key = 'misc_buybot_primary', tab = 'MISC', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.misc_buybot_secondary = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Other', 'secondary', 'heavy', 'dualies', 'five-seven / tec-9', 'p250'),
        { requires_login = true, key = 'misc_buybot_secondary', tab = 'MISC', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.misc_buybot_misc = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Other', 'misc', 'taser', 'kevlar', 'helmet', 'defuse kit'),
        { requires_login = true, key = 'misc_buybot_misc', tab = 'MISC', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.misc_buybot_grenades = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Other', 'grenades', 'molotov', 'smoke', 'high explosive'),
        { requires_login = true, key = 'misc_buybot_grenades', tab = 'MISC', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.aa_gskey_freestandh = var_0_166.register_ui(
        ui.new_label('AA', 'Other', 'hotkey -> freestand'),
        { requires_login = false, key = 'aa_gskey_freestandh', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.aa_gskey_freestand = var_0_166.register_ui(
        ui.new_hotkey('AA', 'Other', 'freestand', true),
        { requires_login = true, key = 'aa_gskey_freestand', tab = 'AA', visible = true, config_type = 'hotkey' }
    )
    var_0_166.ui.aa_gskey_slowmotionh = var_0_166.register_ui(
        ui.new_label('AA', 'Other', 'hotkey -> slowmotion'),
        { requires_login = false, key = 'aa_gskey_slowmotionh', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.aa_gskey_slowmotion = var_0_166.register_ui(
        ui.new_hotkey('AA', 'Other', 'slowmotion', true),
        { requires_login = true, key = 'aa_gskey_slowmotion', tab = 'AA', visible = true, config_type = 'hotkey' }
    )
    var_0_166.ui.aa_gskey_edgeyawh = var_0_166.register_ui(
        ui.new_label('AA', 'Other', 'hotkey -> edge yaw'),
        { requires_login = false, key = 'aa_gskey_edgeyawh', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.aa_gskey_edgeyaw = var_0_166.register_ui(
        ui.new_hotkey('AA', 'Other', 'edge yaw', true),
        { requires_login = true, key = 'aa_gskey_edgeyaw', tab = 'AA', visible = true, config_type = 'hotkey' }
    )
    var_0_166.ui.aa_gskey_onshoth = var_0_166.register_ui(
        ui.new_label('AA', 'Other', 'hotkey -> on-shot aa'),
        { requires_login = false, key = 'aa_gskey_onshoth', tab = 'AA', visible = true, config_type = 'label' }
    )
    var_0_166.ui.aa_gskey_onshot = var_0_166.register_ui(
        ui.new_hotkey('AA', 'Other', 'on-shot aa', true),
        { requires_login = true, key = 'aa_gskey_onshot', tab = 'AA', visible = true, config_type = 'hotkey' }
    )
    
    
    for _, cond in ipairs(conditions) do
        local enable_key = 'enable_' .. cond
        var_0_166.ui[enable_key] = var_0_166.register_ui(
            ui.new_checkbox('AA', 'Anti-aimbot angles', 'enable ' .. cond),
            { requires_login = true, key = enable_key, tab = 'AA', visible = true, config_type = 'checkbox' }
        )
        var_0_166.ui['pitch_' .. cond] = var_0_166.register_ui(
            ui.new_combobox('AA', 'Anti-aimbot angles', ' pitch', 'off', 'up', 'down', 'minimal', 'ideal'),
            { requires_login = true, key = 'pitch_' .. cond, tab = 'AA', visible = true, config_type = 'combobox' }
        )
        var_0_166.ui['yaw_base_' .. cond] = var_0_166.register_ui(
            ui.new_combobox('AA', 'Anti-aimbot angles', ' yaw base', 'target', 'view'),
            { requires_login = true, key = 'yaw_base_' .. cond, tab = 'AA', visible = true, config_type = 'combobox' }
        )
        var_0_166.ui['yaw_' .. cond] = var_0_166.register_ui(
            ui.new_combobox('AA', 'Anti-aimbot angles', ' yaw', 'off', 'spin', '180', '3way', 'ideal'),
            { requires_login = true, key = 'yaw_' .. cond, tab = 'AA', visible = true, config_type = 'combobox' }
        )
        var_0_166.ui['body_yaw_base_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' body yaw - base', (-(45*2)), (45*2), (0), true, ''),
            { requires_login = true, key = 'body_yaw_base_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['body_yaw_left_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' body yaw - left', (-(45*2)), (45*2), (0), true, '°', (1), {
                [(0)] = 'back', [(-(45*2))] = 'left', [(45*2)] = 'right'
            }),
            { requires_login = true, key = 'body_yaw_left_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['body_yaw_right_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' body yaw - right', (-(45*2)), (45*2), (0), true, '°', (1), {
                [(0)] = 'back', [(-(45*2))] = 'left', [(45*2)] = 'right'
            }),
            { requires_login = true, key = 'body_yaw_right_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['randomize_yaw_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' randomize yaw', (0), (15*2), (0), true, '%', (1), {
                [(0)] = 'disabled'
            }),
            { requires_login = true, key = 'randomize_yaw_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['yaw_jitter_' .. cond] = var_0_166.register_ui(
            ui.new_combobox('AA', 'Anti-aimbot angles', ' yaw jitter', 'off', 'center', 'skitter'),
            { requires_login = true, key = 'yaw_jitter_' .. cond, tab = 'AA', visible = true, config_type = 'combobox' }
        )
        var_0_166.ui['yaw_jitter_base_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' yaw jitter - base', (0), (60*2), (0), true, '°', (1), {
                [(0)] = 'disabled'
            }),
            { requires_login = true, key = 'yaw_jitter_base_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['body_yaw_mode_' .. cond] = var_0_166.register_ui(
            ui.new_combobox('AA', 'Anti-aimbot angles', ' body yaw mode', 'off', 'static', 'opposite', 'jitter'),
            { requires_login = true, key = 'body_yaw_mode_' .. cond, tab = 'AA', visible = true, config_type = 'combobox' }
        )
        var_0_166.ui['static_body_yaw_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' static body yaw', (-(29*2)), (29*2), (0), true, '°'),
            { requires_login = true, key = 'static_body_yaw_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['body_yaw_value_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' body yaw value', (1), (2+1), (1+1), true, '', (1+1), {
                [(1)] = 'left', [(1+1)] = 'back', [(2+1)] = 'right'
            }),
            { requires_login = true, key = 'body_yaw_value_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['delay_' .. cond] = var_0_166.register_ui(
            ui.new_slider('AA', 'Anti-aimbot angles', ' delay', (0), (16+1), (1), true, 't', (1), {
                [(0)] = 'jitter'
            }),
            { requires_login = true, key = 'delay_' .. cond, tab = 'AA', visible = true, config_type = 'slider' }
        )
        var_0_166.ui['fifty_fifty_' .. cond] = var_0_166.register_ui(
            ui.new_checkbox('AA', 'Anti-aimbot angles', ' 50/50'),
            { requires_login = true, key = 'fifty_fifty_' .. cond, tab = 'AA', visible = true, config_type = 'checkbox' }
        )
        var_0_166.ui['only_flip_on_0_choke_' .. cond] = var_0_166.register_ui(
            ui.new_checkbox('AA', 'Anti-aimbot angles', ' only flip on 0 choke'),
            { requires_login = true, key = 'only_flip_on_0_choke_' .. cond, tab = 'AA', visible = true, config_type = 'checkbox' }
        )
    end


    
    
    
    var_0_166.ui.fakelag_mode = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'mode', 'defensive', 'stealer', 'fakelag', 'settings'),
        { requires_login = true, key = 'fakelag_mode', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_defensive = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Fake Lag', 'defensive'),
        { requires_login = true, key = 'fakelag_defensive', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.fakelag_force = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Fake Lag', 'force'),
        { requires_login = true, key = 'fakelag_force', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.fakelag_fakedef = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Fake Lag', 'fake defensive'),
        { requires_login = true, key = 'fakelag_fakedef', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.fakelag_force_on = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'force on', 'peek', 'reload', 'shot', 'damaged'),
        { requires_login = true, key = 'fakelag_force_on', tab = 'AA', visible = true, config_type = 'multiselect' }
    )

    
    
    
    var_0_166.ui.cfg_load_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Load', function()
            local name = ui.get(var_0_166.ui.cfg_input_box)
            if not name or name == '' then
                local idx = ui.get(var_0_166.ui.cfg_listbox)
                local names = var_0_195()
                name = names[(idx or (0))+(1)]
            end
            if name and name ~= '' and name ~= '(empty)' then
                local config_system = require("require/abc/config_system")
                config_system.load(name)
                client.color_log((60*2), (90*2), (85*3), '[Config] Loaded config: ' .. name)
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('Loaded config: ' .. name, (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            else
                client.error_log('[Config] No config name entered for load.')
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('No config name entered for load.', (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            end
        end),
        { requires_login = true, key = 'cfg_load_button', tab = 'CFG', visible = true, config_type = 'button' }
    )
    var_0_166.ui.cfg_save_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Save', function()
            local name = ui.get(var_0_166.ui.cfg_input_box)
            if name and name ~= '' then
                local config_system = require("require/abc/config_system")
                config_system.save(name)
                
                local names = var_0_195()
                if not var_0_83(names, name) then
                    names[#names+(1)] = name
                    var_0_283(names)
                end
                var_0_200(name)
                client.color_log((60*2), (90*2), (85*3), '[Config] Saved config: ' .. name)
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('Saved config: ' .. name, (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            else
                client.error_log('[Config] No config name entered for save.')
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('No config name entered for save.', (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            end
        end),
        { requires_login = true, key = 'cfg_save_button', tab = 'CFG', visible = true, config_type = 'button' }
    )
    var_0_166.ui.cfg_delete_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Delete', function()
            local name = ui.get(var_0_166.ui.cfg_input_box)
            if not name or name == '' then
                local idx = ui.get(var_0_166.ui.cfg_listbox)
                local names = var_0_195()
                name = names[(idx or (0))+(1)]
            end
            if name and name ~= '' and name ~= '(empty)' then
                local config_system = require("require/abc/config_system")
                config_system.delete(name)
                
                local names = var_0_195()
                local idx = var_0_83(names, name)
                if idx then
                    table.remove(names, idx)
                    var_0_283(names)
                end
                var_0_200()
                client.color_log((85*3), (40*2), (40*2), '[Config] Deleted config: ' .. name)
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('Deleted config: ' .. name, (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            else
                client.error_log('[Config] No config name entered for delete.')
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('No config name entered for delete.', (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            end
        end),
        { requires_login = true, key = 'cfg_delete_button', tab = 'CFG', visible = true, config_type = 'button' }
    )
    var_0_166.ui.cfg_refresh_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Refresh', function()
            var_0_200()
            client.color_log((60*2), (90*2), (85*3), '[Config] Refreshed config list.')
            if modules and modules.var_0_192 and var_0_244() then
                modules.var_0_192('Refreshed config list.', (2*2), (85*3), (85*3), (85*3), (85*3))
            end
        end),
        { requires_login = true, key = 'cfg_refresh_button', tab = 'CFG', visible = true, config_type = 'button' }
    )
    
    local config_system = require("require/abc/config_system")
    local _ok_clipboard, _clipboard = pcall(require, 'gamesense/clipboard')
    local clipboard = _clipboard
    if not _ok_clipboard or not clipboard then
        
        clipboard = {
            set = function(_) end,
            get = function() return '' end,
        }
    end


    var_0_166.ui.cfg_export_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Export (beta)', function()
            local export_str = config_system.build()
            clipboard.set(export_str)
            client.log('[Config] Exported config string:')
            client.log(export_str)
            client.color_log((60*2), (90*2), (85*3), '[Config] Exported config string to clipboard and console.')
            if modules and modules.var_0_192 and var_0_244() then
                modules.var_0_192('Exported config string to clipboard.', (2*2), (85*3), (85*3), (85*3), (85*3))
            end
        end),
        { requires_login = true, key = 'cfg_export_button', tab = 'CFG', visible = true, config_type = 'button' }
    )

    var_0_166.ui.cfg_import_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Import (beta)', function()
            local import_str = clipboard.get()
            if import_str and import_str ~= '' then
                config_system.var_0_11(import_str)
                client.color_log((60*2), (90*2), (85*3), '[Config] Imported config string from clipboard.')
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('Imported config string from clipboard.', (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            else
                client.error_log('[Config] No config string found in clipboard.')
                if modules and modules.var_0_192 and var_0_244() then
                    modules.var_0_192('No config string found in clipboard for import.', (2*2), (85*3), (85*3), (85*3), (85*3))
                end
            end
        end),
        { requires_login = true, key = 'cfg_import_button', tab = 'CFG', visible = true, config_type = 'button' }
    )

    var_0_166.ui.visuals_export_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Export visuals (beta)', function()

        end),
        { requires_login = true, key = 'visuals_export_button', tab = 'CFG', visible = true, config_type = 'button' }
    )

    var_0_166.ui.visuals_import_button = var_0_166.register_ui(
        ui.new_button('AA', 'Anti-aimbot angles', 'Import visuals (beta)', function()

        end),
        { requires_login = true, key = 'visuals_import_button', tab = 'CFG', visible = true, config_type = 'button' }
    )


    var_0_166.ui.cfg_input_box = var_0_166.register_ui(
        ui.new_textbox('AA', 'Anti-aimbot angles', 'Config name'),
        { requires_login = true, key = 'cfg_input_box', tab = 'CFG', visible = true, config_type = 'textbox' }
    )
    var_0_166.ui.cfg_listbox = var_0_166.register_ui(
        ui.new_listbox('AA', 'Anti-aimbot angles', 'Configs', {}),
        { requires_login = true, key = 'cfg_listbox', tab = 'CFG', visible = true, config_type = 'listbox' }
    )
    
    
    var_0_200()
    var_0_166.ui.fakelag_stealer = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Fake Lag', 'stealer'),
        { requires_login = true, key = 'fakelag_stealer', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.fakelag_stealer_type = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'type', 'mimic', 'import'),
        { requires_login = true, key = 'fakelag_stealer_type', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_stealer_target = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'target', 'threat', 'closest', 'random', 'best kdas'),
        { requires_login = true, key = 'fakelag_stealer_target', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_stealer_list = var_0_166.register_ui(
        ui.new_listbox('AA', 'Fake Lag', 'target list', {'-'}),
        { requires_login = true, key = 'fakelag_stealer_list', tab = 'AA', visible = true, config_type = 'listbox' }
    )
    var_0_166.ui.fakelag_stealer_refresh = var_0_166.register_ui(
        ui.new_button('AA', 'Fake Lag', 'refresh', function() end),
        { requires_login = true, key = 'fakelag_stealer_refresh', tab = 'AA', visible = true, config_type = 'button' }
    )
    var_0_166.ui.fakelag_stealer_steal = var_0_166.register_ui(
        ui.new_button('AA', 'Fake Lag', 'steal', function() end),
        { requires_login = true, key = 'fakelag_stealer_steal', tab = 'AA', visible = true, config_type = 'button' }
    )
    var_0_166.ui.fakelag_fakelag = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Fake Lag', 'fakelag'),
        { requires_login = true, key = 'fakelag_fakelag', tab = 'AA', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.fakelag_fakelag_type = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'type', 'gamesense', 'sodium'),
        { requires_login = true, key = 'fakelag_fakelag_type', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_fakelag_amount = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'amount', 'dynamic', 'maximum', 'fluctuate'),
        { requires_login = true, key = 'fakelag_fakelag_amount', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_fakelag_variance = var_0_166.register_ui(
        ui.new_slider('AA', 'Fake Lag', 'variance', (0), (50*2), (0), true, ''),
        { requires_login = true, key = 'fakelag_fakelag_variance', tab = 'AA', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.fakelag_fakelag_limit = var_0_166.register_ui(
        ui.new_slider('AA', 'Fake Lag', 'limit', (1), (5*3), (1), true, ''),
        { requires_login = true, key = 'fakelag_fakelag_limit', tab = 'AA', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.fakelag_fakelag_type2 = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'type', 'jitter', 'max'),
        { requires_login = true, key = 'fakelag_fakelag_type2', tab = 'AA', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.fakelag_settings_freestanding = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'freestanding options', 'static', 'zero pitch', 'defensive', 'side flip', 'pitch flip'),
        { requires_login = true, key = 'fakelag_settings_freestanding', tab = 'AA', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.fakelag_settings_enhance_onshot = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'enhance on-shot aa', 'defensive', 'roll', 'jitter'),
        { requires_login = true, key = 'fakelag_settings_enhance_onshot', tab = 'AA', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.fakelag_settings_antibrute = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'antibrute options', 'defensive', 'flip', 'roll', 'jitter'),
        { requires_login = true, key = 'fakelag_settings_antibrute', tab = 'AA', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.fakelag_settings_roll = var_0_166.register_ui(
        ui.new_slider('AA', 'Fake Lag', 'roll', (0), (15*3), (0), true, ''),
        { requires_login = true, key = 'fakelag_settings_roll', tab = 'AA', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.fakelag_settings_side = var_0_166.register_ui(
        ui.new_slider('AA', 'Fake Lag', 'side', (1), (2+1), (1), true, '', (1), {
            [(1)] = 'left', [(1+1)] = 'swap', [(2+1)] = 'right'
        }),
        { requires_login = true, key = 'fakelag_settings_side', tab = 'AA', visible = true, config_type = 'slider' }
    )



    
    
    
    var_0_166.ui.paint_advertisement = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', '\ab4b4ffffadvertisement', true),
        { requires_login = true, key = 'paint_advertisement', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_watermark = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'watermark (gamesense)'),
        { requires_login = true, key = 'paint_watermark', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_entidx = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'entidx'),
        { requires_login = true, key = 'paint_entidx', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_target_info = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'target info'),
        { requires_login = true, key = 'paint_target_info', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_scope = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'scope'),
        { requires_login = true, key = 'paint_scope', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_scope_initialpos = var_0_166.register_ui(
        ui.new_slider('AA', 'Other', '\nInitial Position', (0), (250*2), (95*2), true, '', (1)),
        { requires_login = true, key = 'paint_scope_initialpos', tab = 'PAINT', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.paint_scope_offset = var_0_166.register_ui(
        ui.new_slider('AA', 'Other', '\nOffset', (0), (250*2), (5*3), true, '', (1)),
        { requires_login = true, key = 'paint_scope_offset', tab = 'PAINT', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.paint_filter_console = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'filter console'),
        { requires_login = true, key = 'paint_filter_console', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_minimum_damage = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'minimum damage'),
        { requires_login = true, key = 'paint_minimum_damage', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_show_damage_penetration = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'show damage penetration'),
        { requires_login = true, key = 'paint_show_damage_penetration', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_hitmiss_indicator = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'hit/miss indicator'),
        { requires_login = true, key = 'paint_hitmiss_indicator', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_self_skeleton = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'self skeleton'),
        { requires_login = true, key = 'paint_self_skeleton', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_bullet_tracer = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'bullet tracer'),
        { requires_login = true, key = 'paint_bullet_tracer', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_lagcomp_box = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'lagcomp box'),
        { requires_login = true, key = 'paint_lagcomp_box', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_lagcomp_box_color = var_0_166.register_ui(
        ui.new_color_picker('AA', 'Anti-aimbot angles', 'lagcomp box color', (46+1), (39*3), (17*13), (85*3)),
        { requires_login = true, key = 'paint_lagcomp_box_color', tab = 'PAINT', visible = true, config_type = 'color' }
    )
    var_0_166.ui.paint_presmoke = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'presmoke warning'),
        { requires_login = true, key = 'paint_presmoke', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_bombwarning = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'c4 warning'),
        { requires_login = true, key = 'paint_bombwarning', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_insults = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'insults'),
        { requires_login = true, key = 'paint_insults', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )
    var_0_166.ui.paint_rainbow_esp = var_0_166.register_ui(
        ui.new_checkbox('AA', 'Anti-aimbot angles', 'rainbow esp'),
        { requires_login = true, key = 'paint_rainbow_esp', tab = 'PAINT', visible = true, config_type = 'checkbox' }
    )

    var_0_166.ui.paint_clantag = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'clantag', 'off', 'gamesense', 'sodium'),
        { requires_login = true, key = 'paint_clantag', tab = 'PAINT', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.paint_aimbot_logs = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'aimbot logs', 'off', 'gamesense', 'gamesense beta', 'sodium'),
        { requires_login = true, key = 'paint_aimbot_logs', tab = 'PAINT', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.paint_indicators = var_0_166.register_ui(
        ui.new_combobox('AA', 'Fake Lag', 'indicators', 'off', 'small', 'bold'),
        { requires_login = true, key = 'paint_indicators', tab = 'PAINT', visible = true, config_type = 'combobox' }
    )
    var_0_166.ui.paint_logger = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'logger', 'aimbot', 'config', 'anti-aim', 'buybot', 'other'),
        { requires_login = true, key = 'paint_logger', tab = 'PAINT', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.paint_hitmarker = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'hitmarker', 'world +', 'skeleton', 'damage'),
        { requires_login = true, key = 'paint_hitmarker', tab = 'PAINT', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.paint_warnings = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'warnings', 'lethal', 'cant fire', 'low bullets'),
        { requires_login = true, key = 'paint_warnings', tab = 'PAINT', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.paint_performance_mode = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'performance mode', 'blood', 'ragdolls', 'particles', 'lens flare', 'animations', 'feature updates'),
        { requires_login = true, key = 'paint_performance_mode', tab = 'PAINT', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.paint_animations = var_0_166.register_ui(
        ui.new_multiselect('AA', 'Fake Lag', 'animations', 'Kingaru', 'Body lean', 'Gamesense Legs', 'Moonwalk', 'Allah', 'Static legs', 'No pitch on land', 'Reversed legs', 'T-pose', 'Blind', 'Pitch up'),
        { requires_login = true, key = 'paint_animations', tab = 'PAINT', visible = true, config_type = 'multiselect' }
    )
    var_0_166.ui.paint_aspect_ratio = var_0_166.register_ui(
        ui.new_slider('AA', 'Other', 'aspect ratio', (0), (150*2), (0), true, '', (0.01), {
            [(0)] = 'default', [(25*5)] = '5:4', [(19*7)] = '4:3', [(75*2)] = '3:2', [(80*2)] = '16:10', [(59*3)] = '16:9'
        }),
        { requires_login = true, key = 'paint_aspect_ratio', tab = 'PAINT', visible = true, config_type = 'slider' }
    )
    var_0_166.ui.paint_third_person_distance = var_0_166.register_ui(
        ui.new_slider('AA', 'Other', 'third person distance', (15*2), (83*2), (75*2), true, '', (1), {
            [(75*2)] = 'default'
        }),
        { requires_login = true, key = 'paint_third_person_distance', tab = 'PAINT', visible = true, config_type = 'slider' }
    )
    
    
    
    

    local type_map = {
        checkbox = 'c',
        slider = 's',
        combobox = 'o',
        multiselect = 'm',
        
    }
    for key, item in pairs(var_0_166.ui) do
        for _, entry in ipairs(var_0_166.registered_items or {}) do
            if entry.key == key and entry.config_type and type_map[entry.config_type] then
                config_system.var_0_201(key, item, type_map[entry.config_type])
            end
        end
    end
    

end

return var_0_25]]
__bundle["require/abc/callbacks"] = [[




local callbacks = {}

local next_id = (1)
local regs = {}          
local by_event = {}      
local dispatchers = {}   

local function var_0_224()
	local ok, login = pcall(require, "require/abc/login_system")
	if not ok or not login then return false end
	return login.logged_in == true
end

local function var_0_207(opts)
	if not opts then return true end
	if opts.menu_only and not (ui and ui.is_menu_open and ui.is_menu_open()) then return false end
	if opts.alive_only then
		local lp = (entity and entity.get_local_player) and entity.get_local_player()
		if not lp or not entity.is_alive(lp) then return false end
	end
	if opts.require_login then
		if not var_0_224() then return false end
	end
	return true
end

local function var_0_161(event)
	return function(ev)
		local handlers = by_event[event]
		if not handlers then return end
		for i=(1),#handlers do
			local id = handlers[i]
			local reg = regs[id]
			if reg and reg.var_0_282 then
				local ok, err = pcall(reg.var_0_282, ev)
				if not ok then
					pcall(client.error_log, string.format("callback[%d] error: %s", id, tostring(err)))
				end
			end
		end
	end
end

function callbacks.var_0_201(event, fn, a, b, c)
	if type(event) ~= 'string' then error('event must be a string') end
	if type(fn) ~= 'function' then error('callback must be a function') end

	local opts = nil
	if type(a) == 'table' then opts = a
	else
		opts = { menu_only = (a == true), alive_only = (b == true), require_login = (c == true) }
	end

	local id = next_id; next_id = next_id + (1)
	local var_0_282 = function(ev)
		if var_0_207(opts) then
			return fn(ev)
		end
	end

	regs[id] = { event = event, var_0_282 = var_0_282, user_fn = fn, opts = opts }
	by_event[event] = by_event[event] or {}
	by_event[event][#by_event[event] + (1)] = id

	
	if not dispatchers[event] then
		local disp = var_0_161(event)
		dispatchers[event] = disp
		pcall(client.set_event_callback, event, disp)
	end

	return id
end

function callbacks.callback(event, a, b, c, d)
	if type(a) == 'function' then
		return callbacks.var_0_201(event, a, b)
	end
	if type(d) == 'function' then
		local fn = d
		local opts = { menu_only = (a == true), alive_only = (b == true), require_login = (c == true) }
		return callbacks.var_0_201(event, fn, opts)
	end
	error('invalid callback signature')
end

function callbacks.unregister(id)
	local reg = regs[id]
	if not reg then return false end
	local event = reg.event
	regs[id] = nil
	local var_0_155 = by_event[event]
	if var_0_155 then
		for i=#var_0_155,(1),(-(1)) do if var_0_155[i] == id then table.remove(var_0_155, i) end end
		if #var_0_155 == (0) then
			by_event[event] = nil
			local disp = dispatchers[event]
			if disp then pcall(client.unset_event_callback, event, disp) end
			dispatchers[event] = nil
		end
	end
	return true
end

function callbacks.clear_all()
	for event, disp in pairs(dispatchers) do
		pcall(client.unset_event_callback, event, disp)
	end
	regs = {}
	by_event = {}
	dispatchers = {}
end

function callbacks._list()
	return { regs = regs, by_event = by_event }
end

pcall(function()
	if lua and lua.defer then
		lua.defer(callbacks.clear_all)
	else
		pcall(client.set_event_callback, 'shutdown', callbacks.clear_all)
	end
end)

return callbacks
]]
__bundle["require/abc/config_system"] = [[



local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function var_0_19(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=(4*2),(1),(-(1)) do r=r..(b%(1+1)^i-b%(1+1)^(i-(1))>(0) and '1' or '0') end
        return r
    end)..'0000'):gsub('%d%d%d%d%d%d', function(x)
        if (#x < (3*2)) then return '' end
        return b:sub(tonumber(x,(1+1))+(1),tonumber(x,(1+1))+(1))
    end)..({ '', '==', '=' })[#data%(2+1)+(1)])
end

local function var_0_18(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)(-(1)))
        for i=(3*2),(1),(-(1)) do r=r..(f%(1+1)^i-f%(1+1)^(i-(1))>(0) and '1' or '0') end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        if (#x ~= (4*2)) then return '' end
        local c=(0)
        for i=(1),(4*2) do c=c+(x:sub(i,i)=='1' and (1+1)^((4*2)-i) or (0)) end
        return string.char(c)
    end))
end





local database = database

local REGISTRY = {}
local KEY_MAP = {}


local function var_0_201(key, ref, type_char)
    if not key or key == '' or not ref or KEY_MAP[key] then return end
    REGISTRY[#REGISTRY+(1)] = { key = key, ref = ref, type = type_char }
    KEY_MAP[key] = REGISTRY[#REGISTRY]
end


local function var_0_24()
    local lines = { 'v=1' }
    for i = (1), #REGISTRY do
        local item = REGISTRY[i]
        local t = item.type
        local v = ui.get(item.ref)
        
        if t == 'c' then
            lines[#lines+(1)] = item.key .. '|t=c|v=' .. (v and 'true' or 'false')
        elseif t == 's' then
            lines[#lines+(1)] = item.key .. '|t=s|v=' .. tostring(v or (0))
        elseif t == 'o' then
            lines[#lines+(1)] = item.key .. '|t=o|v=' .. tostring(v or '')
        elseif t == 'm' then
            if type(v) == 'table' then
                lines[#lines+(1)] = item.key .. '|t=m|v=' .. table.concat(v, '\t')
            end
        end
        
    end
    return var_0_19(table.concat(lines, '\n'))
end


local function var_0_13(enc)
    if not enc or enc == '' then return end
    local ok, raw = pcall(var_0_18, enc)
    if not ok or not raw or raw == '' then return end
    for line in raw:gmatch('([^\n]+)') do
        if line ~= 'v=1' then
            local key, tseg, vseg = line:match('^(.-)|t=(.)|v=(.*)$')
            if key and tseg and vseg then
                local item = KEY_MAP[key]
                if item and item.type == tseg then
                    
                    if tseg == 'c' then
                        ui.set(item.ref, vseg == 'true')
                    elseif tseg == 's' then
                        local num = tonumber(vseg)
                        if num ~= nil then
                            ui.set(item.ref, num)
                        end
                    elseif tseg == 'o' then
                        
                        
                        
                        
                        
                        
                        pcall(ui.set, item.ref, vseg)
                    elseif tseg == 'm' then
                        local values = {}
                        for token in vseg:gmatch('[^\t]+') do values[#values+(1)] = token end
                        ui.set(item.ref, values)
                    end
                    
                end
            end
        end
    end
end


local function var_0_231(name)
    if not name or name == '' then return end
    local enc = var_0_24()
    database.write('cfg:' .. name, enc)
end


local function var_0_159(name)
    if not name or name == '' then return end
    local enc = database.read('cfg:' .. name)
    if enc then var_0_13(enc) end
end


local function var_0_51(name)
    if not name or name == '' then return end
    database.write('cfg:' .. name, nil)
end


local config_system = {
    var_0_201 = var_0_201,
    build = var_0_24,
    var_0_11 = var_0_13,
    save = var_0_231,
    load = var_0_159,
    delete = var_0_51,
}

return config_system]]
__bundle["require/abc/garbage_collector"] = [[







local gc = {}


local params = {
	pause = (100*2),      
	stepmul = (100*2),    
	mode = "collect"  
}


function gc.tune(opts)
	if type(opts) == "table" then
		if opts.pause then
			collectgarbage("setpause", opts.pause)
			params.pause = opts.pause
		end
		if opts.stepmul then
			collectgarbage("setstepmul", opts.stepmul)
			params.stepmul = opts.stepmul
		end
		if opts.mode then
			params.mode = opts.mode
		end
	end
end

function gc.collect(mode)
	collectgarbage(mode or params.mode)
end

function gc.step(step_size)
	return collectgarbage("step", step_size or (0))
end

function gc.stop()
	collectgarbage("stop")
end

function gc.restart()
	collectgarbage("restart")
end

function gc.memory()
	return collectgarbage("count")
end

function gc.status()
	return {
		memory = gc.memory(),
		pause = params.pause,
		stepmul = params.stepmul,
		mode = params.mode
	}
end


if lua and lua.defer then
	lua.defer(function()
		gc.collect()
	end)
end

return gc]]
__bundle["require/abc/login_system"] = [[local login_system = {}


local function var_0_242(str)
	if client.hash_sha256 then
		return client.hash_sha256(str)
	end
	
	return tostring(str):reverse()
end


local ACCOUNTS_DB_KEY = "acc_" .. "OIDFGNSOIGNSFGIOSNGOISNGIOS"

local function var_0_90()
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local salt = ""
	for i = (1), (8*2) do
		local idx = math.random((1), #charset)
		salt = salt .. charset:sub(idx, idx)
	end
	return salt
end

function login_system.hash_password(password, salt)
	return var_0_242(salt .. password)
end

function login_system.verify_password(password, hash, salt)
	return login_system.hash_password(password, salt) == hash
end

function login_system.get_hwid()
	
	return tostring(client.userid_to_entindex(client.userid_to_entindex((1))))
end

function login_system.store_credentials(username, password)
	local salt = var_0_90()
	local hash = login_system.hash_password(password, salt)
	database.write("login_credentials", { username = username, hash = hash, salt = salt })
end

function login_system.load_credentials()
	return database.read("login_credentials")
end


function login_system.login(username, password)
	
	local accounts = database.read(ACCOUNTS_DB_KEY) or {}
	local acc = accounts[username]
	if acc and acc.var_0_71 ~= false then
		if login_system.verify_password(password, acc.hash, acc.salt) then
			login_system.logged_in = true
			return true
		end
	end
	
	local creds = login_system.load_credentials()
	if creds and creds.username == username then
		if login_system.verify_password(password, creds.hash, creds.salt) then
			login_system.logged_in = true
			return true
		end
	end
	login_system.logged_in = false
	return false
end

function login_system.logout()
	login_system.logged_in = false
end

function login_system.reset_password(username_or_hwid)
	
	database.write("login_credentials", nil)
end



function login_system.is_valid_invite(invite_code)
	if not invite_code or invite_code == "" then
		return false, nil
	end
	local invites = database.read(ACCOUNTS_DB_KEY .. ":invites") or {}
	local entry = invites[invite_code]
	if not entry then
		return false, nil
	end
	if entry.used then
		return false, entry
	end
	return true, entry
end

function login_system.add_account(username, password)
	local salt = var_0_90()
	local hash = login_system.hash_password(password, salt)
	local accounts = database.read(ACCOUNTS_DB_KEY) or {}
	accounts[username] = { hash = hash, salt = salt, role = "user", var_0_71 = true, orig_password = password }
	database.write(ACCOUNTS_DB_KEY, accounts)
end

function login_system.register_with_invite(invite_code, username, password)
	if not invite_code or invite_code == '' then return false, 'no invite provided' end
	local invites = database.read(ACCOUNTS_DB_KEY .. ":invites") or {}
	local entry = invites[invite_code]
	if not entry then return false, 'invalid invite' end
	if entry.used then return false, 'invite already used' end

	login_system.add_account(username, password)

	entry.used = true
	entry.used_by = username
	entry.redeemed_at = client.unix_time()
	invites[invite_code] = entry
	database.write(ACCOUNTS_DB_KEY .. ":invites", invites)

	return true
end

function login_system.invalidate_invite(invite_code)
	local invites = database.read(ACCOUNTS_DB_KEY .. ":invites") or {}
	if invites[invite_code] then
		invites[invite_code] = nil
		database.write(ACCOUNTS_DB_KEY .. ":invites", invites)
		return true
	end
	return false
end

return login_system
]]
__bundle["require/abc/menu_header"] = [[local active_icon, icon_png_width, icon_png_height = (1), (199*2), (7*7)
local TAB_NAMES = { "AA", "PAINT", "MISC", "CFG" }
local var_0_45 = TAB_NAMES[active_icon]
local icon_texture_ids = {}
local icon_files = {
    "C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/lua/GS1.png",
    "C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/lua/GS2.png",
    "C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/lua/GS3.png",
    "C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/lua/GS4.png"
}
local last_tab_sections

local function var_0_160()
    if not renderer.load_png or not readfile then return end
    for i, path in ipairs(icon_files) do
        if not icon_texture_ids[i] then
            local png_data = readfile(path)
            if png_data then
                icon_texture_ids[i] = renderer.load_png(png_data, icon_png_width, icon_png_height)
            end
        end
    end
end


local function var_0_67()
    local is_open = ui.is_menu_open()
    local x, y = ui.menu_position()
    local w, h = ui.menu_size()
    if is_open and x and y and w and h then
        local bar_height = (45*2)
        local pad_outer = (2*2)
        local pad_grey = (2+1)
        local pad_dark = (1+1)
        local pad_accent = (1)
        local pad_fill = (0)
        local bar_x = x+pad_outer
        local bar_y = y-(6+1)-bar_height
        local bar_w = w-(1+1)*pad_outer

        renderer.rectangle(bar_x-pad_outer*1.5, bar_y-8, bar_w+2*pad_outer*1.5-1, bar_height+16, 12, 12, 12, 255)
        renderer.rectangle(bar_x-pad_grey*1.5, bar_y-7, bar_w+2*pad_grey*1.5, bar_height+14, 60, 60, 60, 255)
        renderer.rectangle(bar_x-pad_dark*1.5, bar_y-6, bar_w+2*pad_dark*1.5, bar_height+12, 40, 40, 40, 255)
        renderer.rectangle(bar_x-pad_accent, bar_y-3, bar_w+2*pad_accent, bar_height+6, 60, 60, 60, 255)
        renderer.rectangle(bar_x-pad_fill, bar_y-2, bar_w+2*pad_fill, bar_height+4, 12, 12, 12, 255)

        local tex_id = nil
        if renderer.load_rgba then
            local ok, texture = pcall(renderer.load_rgba,
                string.char(
                    (8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
                    (10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),
                    (8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
                    (10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3)
                ), (2*2), (2*2))
            if ok and texture then tex_id = texture end
        end
        if tex_id and renderer.texture then
            renderer.texture(tex_id, bar_x-pad_fill, bar_y-2, bar_w+2*pad_fill, bar_height+4, 255,255,255,255, 'r')
        end

        if renderer.gradient then
            renderer.gradient(bar_x-pad_fill, bar_y-2, (bar_w+2*pad_fill)/2+1, 1, 59,175,222,255, 202,70,205,255, true)
            renderer.gradient(bar_x-pad_fill+(bar_w+2*pad_fill)/2+1, bar_y-2, (bar_w+2*pad_fill)/2-1, 1, 202,70,205,255, 204,227,53,255, true)
        end

        local line_height = (1+1)
        local line_y = bar_y-(4*2)

        local corner_radius = (4+1)
        local corner_alpha = (30*2)
        renderer.circle(bar_x-pad_outer+corner_radius, line_y+line_height/2, corner_radius, 59,175,222, corner_alpha, 16)
        renderer.circle(bar_x+bar_w-pad_outer-pad_fill-corner_radius, line_y+line_height/2, corner_radius, 204,227,53, corner_alpha, 16)

        local icon_count = (2*2)
        local icon_y = bar_y+bar_height/(1+1)
        local mouse_x, mouse_y = ui.mouse_position()
        local var_0_258 = {}
        local tab_h = bar_height
            local icon_spacing = (58+1)
            local total_icons_width = icon_count * icon_png_width + (icon_count - (1)) * icon_spacing
            local margin = math.max((0), bar_w * (0.5))
            local icons_start_x = bar_x + margin + (bar_w - (1+1) * margin - total_icons_width) / (1+1)
            if total_icons_width > bar_w then
                icon_spacing = math.max((0), (bar_w - icon_count * icon_png_width) / (icon_count - (1)))
                total_icons_width = icon_count * icon_png_width + (icon_count - (1)) * icon_spacing
                icons_start_x = bar_x + (bar_w - total_icons_width) / (1+1)
            end
        var_0_160()
        local tab_w = bar_w / icon_count
        for i=(1),icon_count do
            local tab_x = bar_x + (i-(1)) * tab_w
            local tab_y = bar_y
            var_0_258[i] = {x=tab_x, y=tab_y, w=tab_w, h=tab_h}
            if active_icon == i then
                
                renderer.rectangle(tab_x, tab_y, tab_w, tab_h+1, 32,32,32, 85)
                
            end
            local center_x = tab_x + tab_w/(1+1) - icon_png_width/(1+1)
            local center_y = tab_y + tab_h/(1+1) - icon_png_height/(1+1)
            if icon_texture_ids[i] then
                renderer.texture(icon_texture_ids[i], center_x, center_y, icon_png_width, icon_png_height, 255,255,255,255, "f")
            else
                renderer.text(center_x + icon_png_width/2, center_y + icon_png_height/2, 255,255,255,255, '+c', (0), tostring(i))
            end
        end

        local mouse_down = client.key_state((1))
        if is_open and mouse_x and mouse_y and ui.is_menu_open() then
            if mouse_down and not prev_mouse_down then
                for i=(1),icon_count do
                    local tab = var_0_258[i]
                    if mouse_x >= tab.x and mouse_x <= tab.x+tab.w and mouse_y >= tab.y and mouse_y <= tab.y+tab.h then
                        active_icon = i
                        var_0_45 = TAB_NAMES[active_icon]
                    end
                end
            end
            prev_mouse_down = mouse_down
        else
            prev_mouse_down = false
        end
    end
end

local function var_0_141()
    if not ui.is_menu_open() then return false end
    local mouse_x, mouse_y = ui.mouse_position()
    local menu_x, menu_y = ui.menu_position()
    local menu_w, menu_h = ui.menu_size()
    local bar_height, pad_outer = (45*2), (2*2)
    local bar_x, bar_y, bar_w = menu_x + pad_outer, menu_y - (6+1) - bar_height, menu_w - (1+1) * pad_outer
    return not (
        mouse_x >= menu_x and mouse_x <= menu_x + menu_w and mouse_y >= menu_y and mouse_y <= menu_y + menu_h
        or mouse_x >= bar_x and mouse_x <= bar_x + bar_w and mouse_y >= bar_y and mouse_y <= bar_y + bar_height
    )
end

return {
    var_0_45 = function() return var_0_45 end,
    var_0_46 = function() return active_icon end,
    tab_names = TAB_NAMES,
    var_0_258 = function() return last_tab_sections end,
    menu_position = function() return ui.menu_position() end,
    menu_size = function() return ui.menu_size() end,
    is_menu_open = function() return ui.is_menu_open() end,
    mouse_position = function() return ui.mouse_position() end,
    var_0_141 = var_0_141,
    var_0_67 = var_0_67
}]]
__bundle["require/abc/menu_setup"] = [[local sodium = {
    ui = {},
    registered_items = {},
}

function sodium.register_ui(item, opts)
    
    
    
    if opts and opts.key then
        for i = #sodium.registered_items, (1), (-(1)) do
            local entry = sodium.registered_items[i]
            if entry and entry.key == opts.key then
                
                pcall(function()
                    if entry.item then ui.set_visible(entry.item, false) end
                end)
                table.remove(sodium.registered_items, i)
            end
        end
    end

    table.insert(sodium.registered_items, {
        item = item,
        key = opts.key,
        requires_login = opts.requires_login,
        tab = opts.tab,
        visible = opts.visible ~= false,
        config_type = opts.config_type,
        show_condition = opts.show_condition,
    })
    return item
end

function sodium.var_0_276(is_logged_in)
    for _, entry in ipairs(sodium.registered_items) do
        local show = entry.visible
        if entry.requires_login and not is_logged_in then
            show = false
        end
        if entry.show_condition then
            show = entry.show_condition()
        end
        if entry.item then
            ui.set_visible(entry.item, show)
        end
    end
end

function sodium.var_0_231()
    local config = {}
    for _, entry in ipairs(sodium.registered_items) do
        if entry.key and entry.item then
            config[entry.key] = ui.get(entry.item)
        end
    end
    return config
end

function sodium.var_0_159(cfg)
    for _, entry in ipairs(sodium.registered_items) do
        if entry.key and entry.item and cfg[entry.key] ~= nil then
            ui.set(entry.item, cfg[entry.key])
        end
    end
end

local DEFAULT_GS_ITEMS = {
    { 'AA', 'Anti-aimbot angles', 'Enabled' },
    { 'AA', 'Anti-aimbot angles', 'Pitch' },
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Yaw jitter' },
    { 'AA', 'Anti-aimbot angles', 'Body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Edge yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding' },
    { 'AA', 'Anti-aimbot angles', 'Roll' },
    { 'AA', 'Fake lag', 'Enabled' },
    { 'AA', 'Fake lag', 'Amount' },
    { 'AA', 'Fake lag', 'Variance' },
    { 'AA', 'Fake lag', 'Limit' },
    { 'AA', 'Other', 'Slow motion' },
    { 'AA', 'Other', 'Leg movement' },
    { 'AA', 'Other', 'On shot anti-aim' },
    { 'AA', 'Other', 'Fake peek' },
}

local DEFAULT_RAGE = {

    { 'Rage', 'other', 'accuracy boost' },
    { 'Rage', 'other', 'anti-aim correction' },
    { 'rage', 'other', 'automatic fire' },
    { 'Rage', 'other', 'automatic penetration' },
    { 'Rage', 'other', 'silent aim' },
    { 'Rage', 'other', 'remove recoil' },
    { 'Rage', 'other', 'reduce aimstep' },
    { 'Rage', 'other', 'maximum fov' },
    { 'Rage', 'other', 'log misses due to spread' },
    { 'Rage', 'other', 'low fps mitigations ' },
    { 'rage', 'other', 'delay shot' },
    { 'Rage', 'other', 'quick peek assist' },
    { 'Rage', 'other', 'quick peek assist mode' },
    { 'Rage', 'other', 'quick peek assist distance' },
    { 'Rage', 'other', 'reduce aim step' },
    { 'Rage', 'other', 'maximum fov' },
    { 'Rage', 'other', 'low fps mitigations' },
    { 'Rage', 'other', 'duck peek assist' },


}

function sodium.toggle_gamesense_menu(show)
    sodium.state = sodium.state or {}
    sodium.hidden_refs = sodium.hidden_refs or {}
    for _, entry in ipairs(DEFAULT_GS_ITEMS) do
        local ok, ref1, ref2, ref3, ref4 = pcall(ui.reference, entry[(1)], entry[(1+1)], entry[(2+1)], entry[(2*2)])
        if ok then
            if entry[(1)] == 'AA' and entry[(1+1)] == 'Anti-aimbot angles' and entry[(2+1)] == 'Enabled' then
                sodium.state.gs_enabled_ref = ref1
                if ref1 ~= nil and show then
                    if sodium.state.gs_enabled_previous ~= nil then
                        ui.set(ref1, sodium.state.gs_enabled_previous)
                    end
                elseif ref1 ~= nil and not show then
                    sodium.state.gs_enabled_previous = ui.get(ref1)
                    ui.set(ref1, true)
                end
            end
            local refs = { ref1, ref2, ref3, ref4 }
            local stored = {}
            for _, ref in ipairs(refs) do
                if ref ~= nil then
                    ui.set_visible(ref, show)
                    stored[#stored + (1)] = ref
                end
            end
            if not show and #stored > (0) then
                table.insert(sodium.hidden_refs, stored)
            end
        end
    end
    sodium.state.gs_hidden = not show
end

function sodium.toggle_rage_menu(show)
    sodium.state = sodium.state or {}
    sodium.hidden_rage_refs = sodium.hidden_rage_refs or {}
    sodium.hidden_rage_refs = {} 

    for _, entry in ipairs(DEFAULT_RAGE) do
        local ok, ref1, ref2, ref3, ref4 = pcall(ui.reference, entry[(1)], entry[(1+1)], entry[(2+1)])
        if ok then
            local refs = { ref1, ref2, ref3, ref4 }
            local stored = {}
            for _, ref in ipairs(refs) do
                if ref ~= nil then
                    pcall(function() ui.set_visible(ref, show) end)
                    stored[#stored + (1)] = ref
                end
            end
            if not show and #stored > (0) then
                table.insert(sodium.hidden_rage_refs, stored)
            end
        end
    end
    sodium.state.rage_hidden = not show
end

return sodium]]
__bundle["require/abc/menu_visibility"] = [[
local conditions = {
	"global",
	"stand",
	"move",
	"duck",
	"duck+",
	"jump",
	"jump+",
	"walk",
	"fakelag",
	"legit",
}


local login_system = require("require/abc/login_system")



local function var_0_276(modules)
	
	if modules.var_0_166 and modules.var_0_166.var_0_200 then
		modules.var_0_166.var_0_200()
	end

	
	if modules and not modules.login then
		modules.login = login_system
	end
	modules.var_0_166.toggle_gamesense_menu(false)
	modules.var_0_166.toggle_rage_menu(true)
	modules.var_0_166.var_0_276(modules.login and modules.login.logged_in)
	local logged_in = (modules.login and modules.login.logged_in) or false

	local show = not logged_in
	local tab_name = (modules.menu_header and modules.menu_header.var_0_45 and modules.menu_header.var_0_45()) or modules.menu.var_0_45()
	 	
	ui.set_visible(modules.var_0_166.ui.login_howto_header, show)
	ui.set_visible(modules.var_0_166.ui.login_console_register, show)
	ui.set_visible(modules.var_0_166.ui.login_menu_credentials, show)
	ui.set_visible(modules.var_0_166.ui.login_press_login, show)
	ui.set_visible(modules.var_0_166.ui.login_spacer1, show)
	ui.set_visible(modules.var_0_166.ui.reset_header, show)
	ui.set_visible(modules.var_0_166.ui.reset_step1, show)
	ui.set_visible(modules.var_0_166.ui.reset_step2, show)
	ui.set_visible(modules.var_0_166.ui.login_spacer2, show)
	ui.set_visible(modules.var_0_166.ui.support_header, show)
	ui.set_visible(modules.var_0_166.ui.support_discord, show)
	ui.set_visible(modules.var_0_166.ui.login_username, show)
	ui.set_visible(modules.var_0_166.ui.login_password, show)
	ui.set_visible(modules.var_0_166.ui.cache_credentials, show)
	ui.set_visible(modules.var_0_166.ui.login_button, show)
	ui.set_visible(modules.var_0_166.ui.reset_button, show)
	ui.set_visible(modules.var_0_166.ui.logout_button, logged_in and tab_name == "CFG")

	if modules.var_0_166.ui.condition then
		local selected_condition = ui.get(modules.var_0_166.ui.condition)
		for _, cond in ipairs(conditions) do
			local cond_visible = logged_in and tab_name == "AA" and selected_condition == cond
			local enable_key = 'enable_' .. cond
			if modules.var_0_166.ui[enable_key] then
				ui.set_visible(modules.var_0_166.ui[enable_key], cond_visible)
				local var_0_71 = modules.safe.var_0_222(modules.var_0_166.ui[enable_key])

				local yaw = modules.var_0_166.ui['yaw_' .. cond] and ui.get(modules.var_0_166.ui['yaw_' .. cond]) or nil
				local yaw_jitter = modules.var_0_166.ui['yaw_jitter_' .. cond] and ui.get(modules.var_0_166.ui['yaw_jitter_' .. cond]) or nil
				local body_yaw_mode = modules.var_0_166.ui['body_yaw_mode_' .. cond] and ui.get(modules.var_0_166.ui['body_yaw_mode_' .. cond]) or nil
				local delay = modules.var_0_166.ui['delay_' .. cond] and ui.get(modules.var_0_166.ui['delay_' .. cond]) or nil
				ui.set_visible(modules.var_0_166.ui['pitch_' .. cond], cond_visible and var_0_71)
				ui.set_visible(modules.var_0_166.ui['yaw_base_' .. cond], cond_visible and var_0_71)
				ui.set_visible(modules.var_0_166.ui['yaw_' .. cond], cond_visible and var_0_71)
				local show_body_yaw_base = cond_visible and var_0_71 and (yaw ~= 'off' and yaw ~= 'ideal' and yaw ~= '3way')
				ui.set_visible(modules.var_0_166.ui['body_yaw_base_' .. cond], show_body_yaw_base)
				local show_body_yaw_lr = cond_visible and var_0_71 and (yaw == '180' or yaw == '3way')
				ui.set_visible(modules.var_0_166.ui['body_yaw_left_' .. cond], show_body_yaw_lr)
				ui.set_visible(modules.var_0_166.ui['body_yaw_right_' .. cond], show_body_yaw_lr)
				local show_randomize_yaw = cond_visible and var_0_71 and (yaw ~= 'off' and yaw ~= 'ideal')
				ui.set_visible(modules.var_0_166.ui['randomize_yaw_' .. cond], show_randomize_yaw)
				local show_yaw_jitter_base = cond_visible and var_0_71 and (yaw_jitter ~= 'off')
				ui.set_visible(modules.var_0_166.ui['yaw_jitter_base_' .. cond], show_yaw_jitter_base)
				local show_static_body_yaw = cond_visible and var_0_71 and (body_yaw_mode == 'static')
				ui.set_visible(modules.var_0_166.ui['static_body_yaw_' .. cond], show_static_body_yaw)
				local show_body_yaw_value = cond_visible and var_0_71 and (body_yaw_mode == 'jitter' and delay and delay <= (0))
				ui.set_visible(modules.var_0_166.ui['body_yaw_value_' .. cond], show_body_yaw_value)
				local show_delay = cond_visible and var_0_71 and (body_yaw_mode == 'jitter')
				ui.set_visible(modules.var_0_166.ui['delay_' .. cond], show_delay)
				ui.set_visible(modules.var_0_166.ui['yaw_jitter_' .. cond], cond_visible and var_0_71)
				ui.set_visible(modules.var_0_166.ui['body_yaw_mode_' .. cond], cond_visible and var_0_71)
				ui.set_visible(modules.var_0_166.ui['fifty_fifty_' .. cond], cond_visible and var_0_71)
				ui.set_visible(modules.var_0_166.ui['only_flip_on_0_choke_' .. cond], cond_visible and var_0_71)
			end
		end
		ui.set_visible(modules.var_0_166.ui.condition, logged_in and tab_name == "AA")

		

		ui.set_visible(modules.var_0_166.ui.fakelag_mode, logged_in and tab_name == "AA")
		if modules.var_0_166.ui.fakelag_mode then
			local mode = ui.get(modules.var_0_166.ui.fakelag_mode)
			local show_fakelag_tab = logged_in and tab_name == "AA"
			local show_defensive = show_fakelag_tab and mode == "defensive"
			local defensive_enabled = modules.safe.var_0_222(modules.var_0_166.ui.fakelag_defensive) == true
			ui.set_visible(modules.var_0_166.ui.fakelag_defensive, show_defensive)
			ui.set_visible(modules.var_0_166.ui.fakelag_force, show_defensive and defensive_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_force_on, show_defensive and defensive_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakedef, show_defensive and defensive_enabled)

			local show_stealer = show_fakelag_tab and mode == "stealer"
			local stealer_enabled = modules.safe.var_0_222(modules.var_0_166.ui.fakelag_stealer) == true
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer, show_stealer)
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer_type, show_stealer and stealer_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer_target, show_stealer and stealer_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer_list, show_stealer and stealer_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer_refresh, show_stealer and stealer_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_stealer_steal, show_stealer and stealer_enabled)

			local show_fakelag = show_fakelag_tab and mode == "fakelag"
			local fakelag_enabled = modules.safe.var_0_222(modules.var_0_166.ui.fakelag_fakelag) == true
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag, show_fakelag)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag_type, show_fakelag and fakelag_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag_amount, show_fakelag and fakelag_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag_variance, show_fakelag and fakelag_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag_limit, show_fakelag and fakelag_enabled)
			ui.set_visible(modules.var_0_166.ui.fakelag_fakelag_type2, show_fakelag and fakelag_enabled)

			local show_settings = show_fakelag_tab and mode == "settings"
			ui.set_visible(modules.var_0_166.ui.fakelag_settings_freestanding, show_settings)
			ui.set_visible(modules.var_0_166.ui.fakelag_settings_enhance_onshot, show_settings)
			ui.set_visible(modules.var_0_166.ui.fakelag_settings_antibrute, show_settings)
			ui.set_visible(modules.var_0_166.ui.fakelag_settings_roll, show_settings)
			ui.set_visible(modules.var_0_166.ui.fakelag_settings_side, show_settings)



		end

	end

	local aa_items = {
		'aa_gskey_freestand',
		'aa_gskey_freestandh',
		'aa_gskey_slowmotion',
		'aa_gskey_slowmotionh',
		'aa_gskey_edgeyaw',
		'aa_gskey_edgeyawh',
		'aa_gskey_onshot',
		'aa_gskey_onshoth',
	}
	for _, key in ipairs(aa_items) do
		if modules.var_0_166.ui[key] then
			ui.set_visible(modules.var_0_166.ui[key], tab_name == "AA")
		end
	end

	local misc_items = {
		'misc_resolver',
		'misc_ragebot',
		'misc_dormantaimbot',
		'misc_buybot',
		'misc_buybot_primary',
		'misc_buybot_secondary',
		'misc_buybot_misc',
		'misc_buybot_grenades',
		'misc_exploit_fakelag',
		'misc_walkbot',
	}
	for _, key in ipairs(misc_items) do
		if modules.var_0_166.ui[key] then
			ui.set_visible(modules.var_0_166.ui[key], tab_name == "MISC")
		end
	end



	local paint_items = {
		'paint_target_info',
		'paint_entidx',
		'paint_watermark',
		'paint_scope',
		'paint_scope_initialpos',
		'paint_scope_offset',
		'paint_filter_console',
		'paint_minimum_damage',
		'paint_show_damage_penetration',
		'paint_hitmiss_indicator',
		'paint_self_skeleton',
		'paint_bullet_tracer',
		'paint_lagcomp_box',
		'paint_lagcomp_box_color',
		'paint_presmoke',
		'paint_bombwarning',
		'paint_insults',
		'paint_rainbow_esp',
		'paint_advertisement',
		'paint_clantag',
		'paint_aimbot_logs',
		'paint_indicators',
		'paint_logger',
		'paint_hitmarker',
		'paint_warnings',
		'paint_animations',
		'paint_performance_mode',
		'paint_aspect_ratio',
		'paint_third_person_distance',
	}
	for _, key in ipairs(paint_items) do
		if modules.var_0_166.ui[key] then
			ui.set_visible(modules.var_0_166.ui[key], tab_name == "PAINT")
		end
	end

		
		local cfg_items = {
			'cfg_load_button',
			'cfg_save_button',
			'cfg_delete_button',
			'cfg_refresh_button',
			'cfg_export_button',
			'cfg_import_button',
			'visuals_export_button',
			'visuals_import_button',
			'cfg_input_box',
			'cfg_listbox',
		}
		for _, key in ipairs(cfg_items) do
			if modules.var_0_166.ui[key] then
				ui.set_visible(modules.var_0_166.ui[key], logged_in and tab_name == "CFG")
			end
		end

	

end

local function var_0_241(modules)
	local cb_items = {
		modules.var_0_166.ui.condition,
		modules.var_0_166.ui.fakelag_mode,
		
		
		
		
		
		
	}
	for _, item in ipairs(cb_items) do
		if item then
			ui.set_callback(item, function()
				var_0_276(modules)
			end)
		end
	end

	
	for _, cond in ipairs(conditions) do
		local keys = {
			'enable_' .. cond,
			'yaw_' .. cond,
			'yaw_jitter_' .. cond,
			'body_yaw_mode_' .. cond,
			'delay_' .. cond,
			'fifty_fifty_' .. cond,
			'only_flip_on_0_choke_' .. cond,
		}
		for _, key in ipairs(keys) do
			local item = modules.var_0_166.ui[key]
			if item then
				ui.set_callback(item, function()
					var_0_276(modules)
				end)
			end
		end
	end

	
	local fl_keys = {
		'fakelag_defensive', 'fakelag_stealer', 'fakelag_fakelag',
		'fakelag_settings_freestanding', 'fakelag_settings_enhance_onshot',
		'fakelag_settings_antibrute', 'fakelag_settings_roll',
		'fakelag_settings_side',
	}
	for _, key in ipairs(fl_keys) do
		local item = modules.var_0_166.ui[key]
		if item then
			ui.set_callback(item, function()
				var_0_276(modules)
			end)
		end
	end



	
	if modules.login and type(modules.login.add_state_callback) == 'function' then
		modules.login.add_state_callback(function()
			var_0_276(modules)
		end)
	end
end

return {
	update = var_0_276,
	var_0_241 = var_0_241
}
]]
__bundle["require/abc/push_logger"] = [[local renderer = renderer
local globals = globals
local entity = entity
local table_insert = table.insert
local table_remove = table.remove
local math_floor = math.floor
local math_sqrt = math.sqrt
local string_char = string.char

local queue = {}
local max_logs = (4+1)

local function var_0_192(text, duration, r, g, b, a)
	if #queue >= max_logs then
		table_remove(queue, (1))
	end
	table_insert(queue, {
		text = tostring(text),
		duration = duration or (4+1),
		color = { r or (85*3), g or (85*3), b or (85*3), a or (85*3) },
		timestamp = globals and globals.curtime and globals.curtime() or os.clock(),
	})
end

local dot_texture_id = nil
local function var_0_105()
	if dot_texture_id then return dot_texture_id end
	if renderer.load_rgba then
		local ok, texture = pcall(renderer.load_rgba,
			string.char(
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3)
			), (2*2), (2*2))
		if ok and texture then dot_texture_id = texture end
	end
	return dot_texture_id
end

local function var_0_205(x, y, w, h, a, text)
	local bg_x = x - (2+1)
	local bg_y = y - (20*2)
	local bg_w = w + (4+1)
	local bg_h = h + (1)
	renderer.rectangle(x - 10, y - 48, w + 20, h + 16, 0, 0, 0, 200)
	renderer.rectangle(x - 9, y - 47, w + 18, h + 14, 60, 60, 60, 255)
	renderer.rectangle(x - 8, y - 46, w + 16, h + 12, 40, 40, 40, 255)
	renderer.rectangle(x - 5, y - 43, w + 10, h + 6, 60, 60, 60, 255)
	renderer.rectangle(x - 4, y - 42, w + 8, h + 4, 12, 12, 12, 255)
	renderer.rectangle(x - 4, y - 42, w + 8, h + 4, 32, 32, 32, 255)
	local tex_id = var_0_105()
	if tex_id and renderer.texture then
		renderer.texture(tex_id, bg_x, bg_y, bg_w, bg_h, 255,255,255,a, 'r')
	else
		renderer.rectangle(bg_x, bg_y, bg_w, bg_h, 0, 0, 0, 0)
	end

    renderer.gradient(x - 4, y - 42, w / 2 + 1, 1, 59, 175, 222, 255, 202, 70, 205, 255, true)
	renderer.gradient(x - 4 + w / 2, y - 42, w / 2 + 8.5, 1, 202, 70, 205, 255, 204, 227, 53, 255, true)
	renderer.text(x, y - 40, 255, 255, 255, 255, '', nil, text)
end

local function measure_text(str)
	local ok, w, h = pcall(renderer.measure_text, '', str)
	if ok and type(w) == 'number' then return w, h or (0) end
	ok, w, h = pcall(renderer.measure_text, str)
	if ok and type(w) == 'number' then return w, h or (0) end
	return (0), (0)
end

local function var_0_35(val, min, max)
	if val < min then return min end
	if val > max then return max end
	return val
end

local function var_0_40(screen_h)
	local safe_top = (40*2)
	local safe_bottom = screen_h - (40*2)
	local line_half = (20*2)
	local anchor_y = screen_h / (1+1) - (150*2)
	local baseline_default = screen_h - anchor_y - (5*2)
	baseline_default = var_0_35(baseline_default, safe_top + line_half, safe_bottom - line_half)
	local line_top = baseline_default - line_half
	local line_bottom = baseline_default + line_half
	return line_top, line_bottom, baseline_default
end

local function var_0_211(screen_h)
	local line_top, line_bottom, baseline_default = var_0_40(screen_h)
	local range = line_bottom - line_top
	if range <= (0) then
		return baseline_default, line_top, line_bottom
	end
	return line_top + range * (0.5), line_top, line_bottom
end


local function var_0_204()
	if not renderer or not renderer.text then return end
	local var_0_173 = globals and globals.curtime and globals.curtime() or os.clock()
	local screen_w, screen_h = client and client.screen_size and client.screen_size() or (400*2), (300*2)
	local function var_0_35(val, min, max)
		if val < min then return min end
		if val > max then return max end
		return val
	end
	local function var_0_40(screen_h)
		local safe_top = (40*2)
		local safe_bottom = screen_h - (40*2)
		local line_half = (20*2)
		local anchor_y = screen_h / (1+1) - (150*2)
		local baseline_default = screen_h - anchor_y - (5*2)
		baseline_default = var_0_35(baseline_default, safe_top + line_half, safe_bottom - line_half)
		local line_top = baseline_default - line_half
		local line_bottom = baseline_default + line_half
		return line_top, line_bottom, baseline_default
	end
	local function var_0_211(screen_h)
		local line_top, line_bottom, baseline_default = var_0_40(screen_h)
		local range = line_bottom - line_top
		if range <= (0) then
			return baseline_default, line_top, line_bottom
		end
		return line_top + range * (0.5), line_top, line_bottom
	end
	local baseline = screen_h * (0.5) + (screen_h * (0.5) * (1.8))
	local offset = (0)
	for i = #queue, (1), (-(1)) do
		local log = queue[i]
		local time_left = (log.timestamp + log.duration) - var_0_173
		if time_left <= (0) then
			table_remove(queue, i)
		else
			local text_w, text_h = measure_text(log.text)
			local padding = (1+1)
			local glow = (1+1)
			local x = screen_w / (1+1) - text_w / (1+1)
			local y = baseline + offset
			local fade_speed = (4+1)
			local alpha = math_floor((log.color[(2*2)] or (85*3)) * math.min((1), (time_left / log.duration) * fade_speed))
			var_0_205(x, y, text_w, (12+1), alpha, log.text)
			offset = offset + (text_h + padding * (1+1) + math_sqrt(glow / (5*2)) * (7*5))
		end
	end
end

	client.set_event_callback('paint', var_0_204)
if client and client.set_event_callback then
	client.set_event_callback('paint', var_0_204)
end

return var_0_192]]
__bundle["require/abc/register"] = [[

local login_system = require("require.abc.login_system")


local ACCOUNTS_DB_KEY = "acc_" .. "OIDFGNSOIGNSFGIOSNGOISNGIOS"

local function var_0_253(s)
    local parts = {}
    for part in s:gmatch("%S+") do
        table.insert(parts, part)
    end
    return parts
end

client.set_event_callback("console_input", function(text)
    local parts = var_0_253(text or "")
    if #parts == (0) then return end

    local cmd = parts[(1)]:lower()
    if cmd ~= "register" then
        
        client.log("entered: '", text, "'")
        return
    end

    if #parts < (2*2) then
        client.log("Usage: register <username> <password> <invite>")
        return
    end

    local username = parts[(1+1)]
    local password = parts[(2+1)]
    local invite = parts[(2*2)]

    
    local valid, entry = login_system.is_valid_invite(invite)
    if not valid then
        client.log("Register failed: invalid or used invite")
        return
    end

    
    local accounts = database.read(ACCOUNTS_DB_KEY) or {}
    if accounts[username] then
        client.log("Register failed: username already exists - ", username)
        return
    end

    
    local ok, err = login_system.register_with_invite(invite, username, password)
    if ok then
        client.log("Registered user:", username)
    else
        client.log("Register failed:", err or "unknown error")
    end
end)]]
__bundle["require/abc/startup"] = [[

local M = {}
function M.notify_lua_launch()
	if not http or not client then return end
	local url = "https://canary.discord.com/api/webhooks/1439468902504726549/mZvDv2Tng4ALTVEWth76tbq7eB7MkqINCv43hh6Yc9nDvV6DutqcF7PMYo1XVwp47o7u"
	local hour, min, sec, ms = system_time()
	local unix = unix_time()
	local timestamp = string.format("%02d:%02d:%02d.%03d (unix: %d)", hour, min, sec, ms, unix)
	local payload = '{"content":"Lua launched: ' .. timestamp .. '"}'
	http.post(url, payload, "application/json", function(success, response)
		if success then
			client.log("Webhook notified: Lua launch")
		else
			client.log("Webhook failed: " .. tostring(response))
		end
	end)
end

return M
]]
__bundle["require/features/aa/aa_collect"] = [[
local entity_lib = entity
local var_0_166 = require('require/abc/menu_setup')
local player_condition = require('require/aa/player_condition')

local AA_COLLECT = {}
AA_COLLECT.last_side = 'left'

local function var_0_103()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then return nil end
    local key = 'delay_' .. cond
    if not (var_0_166 and var_0_166.ui) then return nil end
    local ui_item = var_0_166.ui[key]
    if not ui_item then return nil end
    local ok2, val = pcall(ui.get, ui_item)
    if not ok2 then return nil end
    local n = tonumber(val)
    if n then return n end
    return val
end

local function var_0_108()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then return nil end
    local key = 'fifty_fifty_' .. cond
    if not (var_0_166 and var_0_166.ui) then return nil end
    local ui_item = var_0_166.ui[key]
    if not ui_item then return nil end
    local ok2, val = pcall(ui.get, ui_item)
    if not ok2 then return nil end
    local n = tonumber(val)
    if n then return n end
    return val
end

local function var_0_96()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then return nil end
    local key = 'body_yaw_mode_' .. cond
    if not (var_0_166 and var_0_166.ui) then return nil end
    local ui_item = var_0_166.ui[key]
    if not ui_item then return nil end
    local ok2, val = pcall(ui.get, ui_item)
    if not ok2 then return nil end
    local n = tonumber(val)
    if n then return n end
    return val
end

local function var_0_213(me)
    if not (entity_lib and entity_lib.get_prop and me) then return AA_COLLECT.last_side end
    local pose = entity_lib.get_prop(me, 'm_flPoseParameter', (10+1))
    if pose == nil then
        return AA_COLLECT.last_side
    end
    local side = (pose > (0.5)) and 'right' or 'left'
    AA_COLLECT.last_side = side
    return side
end

local function var_0_163()
    local delay = var_0_103() + (1)
    local n = tonumber(delay) or (1)
    if n < (1) then n = (1) end
    if n > (16+1) then n = (16+1) end

    local tick = globals.tickcount()
    if not tick then return AA_COLLECT.last_side end

    local phase = math.floor(tick / n) % (1+1)
    local side = (phase == (0)) and 'left' or 'right'
    AA_COLLECT.last_side = side
    return side
end




local function var_0_212()

    local fifty_fifty = var_0_108()

    if fifty_fifty then
        local r = math.random((0), (1))
        local side = (r == (0)) and 'left' or 'right'
        AA_COLLECT.last_side = side
        return side
    end

    local delay = var_0_103()
    local n = tonumber(delay)

    if var_0_96() ~= 'jitter' then
        return var_0_213(entity_lib.get_local_player())
    end

    if not n or n == (0) then
        local me = entity_lib.get_local_player()
        if not me or me == (0) then return AA_COLLECT.last_side end
        return var_0_213(me)
    else
        return var_0_163()
    end
end





AA_COLLECT.var_0_213 = var_0_213
AA_COLLECT.var_0_212 = var_0_212
AA_COLLECT.var_0_103 = var_0_103

return AA_COLLECT]]
__bundle["require/features/aa/antiaim"] = [[local builder = require('require/features/aa/builder')
local defensive = require('require/features/aa/defensive')

client.set_event_callback('setup_command', function(cmd)


	if builder and builder.activate then
		builder.activate(cmd)
	end


    if defensive and defensive.activate then
        defensive.activate(cmd)
    end

end)]]
__bundle["require/features/aa/builder"] = [[local var_0_166 = require('require/abc/menu_setup')
local player_condition = require('require/aa/player_condition')
local aa_collect = require('require/features/aa/aa_collect')
local math_helper = require('require/help/math')

local function var_0_89(cond)
	if not cond then return nil end

	local keys = {
		pitch = 'pitch_',
		yaw_base = 'yaw_base_',
		yaw = 'yaw_',
		body_yaw_base = 'body_yaw_base_',
		body_yaw_left = 'body_yaw_left_',
		body_yaw_right = 'body_yaw_right_',
		randomize_yaw = 'randomize_yaw_',
		yaw_jitter = 'yaw_jitter_',
		yaw_jitter_base = 'yaw_jitter_base_',
		body_yaw_mode = 'body_yaw_mode_',
		static_body_yaw = 'static_body_yaw_',
		body_yaw_value = 'body_yaw_value_',
		delay = 'delay_',
		fifty_fifty = 'fifty_fifty_',
		only_flip_on_0_choke = 'only_flip_on_0_choke_',
	}

	local out = { condition = cond }
	for name, prefix in pairs(keys) do
		local key = prefix .. cond
		local ui_item = var_0_166.ui and var_0_166.ui[key]
		if ui_item then
			local ok, val = pcall(ui.get, ui_item)
			if ok then out[name] = val else out[name] = nil end
		else
			out[name] = nil
		end
	end

	return out
end




local function var_0_114()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local tbl = var_0_89(cond)
  return tbl and tbl.pitch or nil
end




local function var_0_125()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local tbl = var_0_89(cond)
	local raw = tbl and tbl.yaw_base or nil
	if raw == nil then return nil end
	local s = tostring(raw):lower()
	if s == 'target' then
		return 'at targets'
	elseif s == 'view' then
		return 'local view'
	else
		return raw
	end
end




local function var_0_126()
	local ok, cond = pcall(player_condition.get)
	if not ok or not cond then
		return nil
	end
	local tbl = var_0_89(cond)
	return tbl and tbl.yaw or nil
end




local function var_0_128()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then
        return nil
    end
    local tbl = var_0_89(cond)
    return tbl and tbl.yaw_jitter or nil
end




local function var_0_127()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local tbl = var_0_89(cond)
  return tbl and tbl.yaw_jitter_base or nil
end




local function var_0_116()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then return nil end
  local tbl = var_0_89(cond)
  if not tbl then return nil end
  local v = tbl.randomize_yaw
  if v == nil then return nil end
  local n = tonumber(v)
  if not n then return nil end
  if n < (0) then n = (0) end
  if n > (15*2) then n = (15*2) end
  return math.floor(n)
end




local function var_0_96()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then
        return nil
    end
  local tbl = var_0_89(cond)
  local mode = tbl and tbl.body_yaw_mode or nil
  if not mode then return nil end
  local mode_l = tostring(mode):lower()
  if mode_l == 'jitter' then
    local delay = aa_collect.var_0_103 and aa_collect.var_0_103() or nil
    local n = tonumber(delay) or (0)
    if n > (0) then
      return 'static'
    else
      return 'jitter'
    end
  end
  return mode
end




local function var_0_98()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local tbl = var_0_89(cond)
  if not tbl then return nil end


  local mode = tbl.body_yaw_mode
  if mode ~= nil then mode = tostring(mode):lower() end

  if mode == 'jitter' then
    local delay = aa_collect.var_0_103 and aa_collect.var_0_103() or nil
    local nd = tonumber(delay) or (0)
    if nd > (0) then
      local side = aa_collect.var_0_212 and aa_collect.var_0_212() or nil
      if side == 'right' then
        return (-(29*2))
      else
        return (29*2)
      end
    end

    local raw = tbl.body_yaw_value
    local n = tonumber(raw) or nil
    if n == (1) then
      return (-(90*2))
    elseif n == (1+1) then
      return (0)
    elseif n == (2+1) then
      return (90*2)
    end
    return nil
  elseif mode == 'static' then
    if tbl.static_body_yaw ~= nil then
      local num = tonumber(tbl.static_body_yaw)
      if num then return num end
    end
    local raw = tbl.body_yaw_value
    local n = tonumber(raw) or nil
    if n == (1) then
      return (-(90*2))
    elseif n == (1+1) then
      return (0)
    elseif n == (2+1) then
      return (90*2)
    end
    return nil
  else
    return (0)
  end
end




local function var_0_94()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local tbl = var_0_89(cond)
  return tbl and tbl.body_yaw_base or nil
end




local function var_0_95()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then
        return nil
    end
    local tbl = var_0_89(cond)
    return tbl and tbl.body_yaw_left or nil
end




local function var_0_97()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then
        return nil
    end
    local tbl = var_0_89(cond)
    return tbl and tbl.body_yaw_right or nil
end




local function var_0_113()
    local ok, cond = pcall(player_condition.get)
    if not ok or not cond then
        return nil
    end
    local tbl = var_0_89(cond)
    if not tbl then return nil end
    local v = tbl.only_flip_on_0_choke
    if v == nil then return nil end
    return not not v
end




local function var_0_103()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then
    return nil
  end
  local key = 'delay_' .. cond
  if not (var_0_166 and var_0_166.ui) then return nil end
  local ui_item = var_0_166.ui[key]
  if not ui_item then return nil end
  local ok2, val = pcall(ui.get, ui_item)
  if ok2 then return val end
  return nil
end




local function var_0_108()
  local ok, cond = pcall(player_condition.get)
  if not ok or not cond then return nil end
  local tbl = var_0_89(cond)
  if not tbl then return nil end
  local v = tbl.fifty_fifty
  if v == nil then return nil end
  return not not v
end




local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Enabled' },
    { 'AA', 'Anti-aimbot angles', 'Pitch' },
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Yaw jitter' },
    { 'AA', 'Anti-aimbot angles', 'Body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Edge yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding' },
    { 'AA', 'Anti-aimbot angles', 'Roll' },
    { 'AA', 'Fake lag', 'Enabled' },
    { 'AA', 'Fake lag', 'Amount' },
    { 'AA', 'Fake lag', 'Variance' },
    { 'AA', 'Fake lag', 'Limit' },
    { 'AA', 'Other', 'Slow motion' },
    { 'AA', 'Other', 'Leg movement' },
    { 'AA', 'Other', 'On shot anti-aim' },
    { 'AA', 'Other', 'Fake peek' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end






local function var_0_149(cmd)

  if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
    if cmd.in_attack == (1) then
        cmd.in_attack = (0) 
        cmd.in_use = (1)
    end
  else
    if cmd.chokedcommands == (0) then
        cmd.in_use = (0)
    end
  end

end





local function var_0_10(cmd)

    local choke = cmd.chokedcommands

    if var_0_113() then
        if choke > (0) then
            return
        end
    end

    local side = aa_collect.var_0_212()

    
    
    
    ui.set(gs_item_refs[(1+1)][(1)], tostring(var_0_114()))

    
    
    
    ui.set(gs_item_refs[(2+1)][(1)], tostring(var_0_125()))

    
    
    
    local yaw_mode = var_0_126()
    if yaw_mode == "3way" then
      yaw_mode = '180'
    elseif yaw_mode == "ideal" then
      yaw_mode = '180'
    end
    ui.set(gs_item_refs[(2*2)][(1)], yaw_mode)

    
    
    
    ui.set(gs_item_refs[(4+1)][(1)], tostring(var_0_128()))

    
    
    
    ui.set(gs_item_refs[(4+1)][(1+1)], tostring(var_0_127()))

    
    
    
    ui.set(gs_item_refs[(3*2)][(1)], tostring(var_0_96()))

    
    
    
    ui.set(gs_item_refs[(3*2)][(1+1)], tostring(var_0_98()))

    
    
    
    local base = tonumber(var_0_94()) or (0)
    local offset = (0)
    if ui.get(gs_item_refs[(2*2)][(1)]) == '180' then
      if side == 'right' then
        offset = tonumber(var_0_95()) or (0)
      elseif side == 'left' then
        offset = tonumber(var_0_97()) or (0)
      end
    end
    local body_yaw_add_num = base + offset
    local rand_pct = tonumber(var_0_116()) or (0)
    if rand_pct > (0) then
      local variation = math.abs(body_yaw_add_num) * (rand_pct / (50*2))
      local rand_scale = (math.random((-(500*2)), (500*2)) / (500*2))
      local rnd_offset = rand_scale * variation
      body_yaw_add_num = body_yaw_add_num + rnd_offset
    end

    ui.set(gs_item_refs[(2*2)][(1+1)], math_helper.var_0_221(body_yaw_add_num))

    
    
    
    var_0_149(cmd)

end


return {
  gather = var_0_89,
  
  activate = var_0_10,
  
  print_current = var_0_10,
}]]
__bundle["require/features/aa/defensive"] = [[local DEF = {}
DEF.active = nil
DEF.activate = nil
local time_helper = require('require/help/time')
local var_0_166 = require('require/abc/menu_setup')
local presets = require('require/features/aa/defensive_presets')
local player_condition = require('require/aa/player_condition')




local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Enabled' },
    { 'AA', 'Anti-aimbot angles', 'Pitch' },
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Yaw jitter' },
    { 'AA', 'Anti-aimbot angles', 'Body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Edge yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding' },
    { 'RAGE', 'Aimbot', 'Double tap' },
    { 'RAGE', 'Other', 'Duck peek assist' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end


local _preset_state = {
    cond = nil,
    idx = nil,
    preset = nil,
    selected_tick = (0),
}
local _was_enabled = false
local _last_reset_tick = (0)





local _dt_state = {
    last = false,
    pending_until = nil,
}
local function var_0_64()
    local ok, v = pcall(ui.get, gs_item_refs[(5*2)][(1+1)])
    local cur = ok and not not v or false
    local tick = time_helper.tickcount() or (globals and globals.tickcount and globals.tickcount()) or (0)
    if cur and not _dt_state.last then
        _dt_state.pending_until = tick + (16*2)
    end
    if not cur then
        _dt_state.pending_until = nil
    end
    _dt_state.last = cur
    if _dt_state.pending_until then
        return tick >= _dt_state.pending_until
    end
    return cur
end

local function var_0_69()
    local refs = gs_item_refs[(10+1)]
    if not refs or not refs[(1)] then
        return false
    end
    local ok, v = pcall(ui.get, refs[(1)])
    return ok and not not v or false
end

local function var_0_138()
  local lp = entity.get_local_player()
  if not lp or not entity.is_alive(lp) then
    return false
  end
  local weapon = entity.get_player_weapon(lp)
  if not weapon then
    return false
  end
  local classname = entity.get_classname(weapon)
  return classname == "CKnife"
end




local function var_0_50()
    if not var_0_166 or type(var_0_166) ~= 'table' or not var_0_166.ui then
        return false
    end
    local ref = var_0_166.ui.fakelag_defensive
    if not ref then
        return false
    end
    local ok, v = pcall(ui.get, ref)
    return ok and not not v or false
end

local function var_0_48()
    if not var_0_166 or type(var_0_166) ~= 'table' or not var_0_166.ui then
        return false
    end
    local ref = var_0_166.ui.fakelag_force
    if not ref then
        return false
    end
    local ok, v = pcall(ui.get, ref)
    return ok and not not v or false
end




local function var_0_239(cmd)

    cmd.force_defensive = true

end



local function var_0_209(cmd)

    


    local tick = (globals and globals.tickcount and globals.tickcount()) or time_helper.tickcount() or (0)
    _last_reset_tick = tick
end




local function var_0_49(window)

    window = window or (10*2)
    local local_player = entity.get_local_player()
    if not local_player then return false end
    local simtime = entity.get_prop(local_player, "m_flSimulationTime")
    local tickrate = (1) / globals.tickinterval()
    if not simtime or tickrate == (0) then return false end
    local simtick = math.floor(simtime * tickrate + (0.5))
    local current_tick = globals.tickcount()
    return current_tick >= simtick and current_tick <= simtick + window

end


client.set_event_callback('net_update_start', function()

    

end)







local function active(cmd)
    
    
    
    local var_0_71 = false
    local def_on = var_0_50()
    local def_dt = var_0_64()
    local def_fd = var_0_69()
    local def_knife = var_0_138()
    local def_grace = var_0_49()
    var_0_71 = def_on and def_dt and not def_fd and not def_knife 
    DEF.active = var_0_71


    local tick = (globals and globals.tickcount and globals.tickcount()) or time_helper.tickcount() or (0)
    local is_reset_tick = false
    if tick and (_last_reset_tick == nil or tick - _last_reset_tick >= (32*2)) then
        is_reset_tick = true
        var_0_209(cmd)
    end



    
    
    
    local cchoke = cmd.chokedcommands
    if cchoke == (0) then return end

    
    
    
    if var_0_71 then
        local cond = player_condition.get() or 'global'
        if (not _was_enabled) or (_preset_state.cond ~= cond) or (not _preset_state.preset) then
            local idx, p = presets.get_random_for_condition(cond)
            if idx and p then
                _preset_state.cond = cond
                _preset_state.idx = idx
                _preset_state.preset = p
                _preset_state.selected_tick = globals.tickcount()
            else
                _preset_state.cond = cond
                _preset_state.idx = nil
                _preset_state.preset = nil
                _preset_state.selected_tick = (0)
            end
        end

        if not is_reset_tick then
            if _preset_state.preset and type(_preset_state.preset.var_0_11) == 'function' then
                _preset_state.preset.var_0_11(_preset_state, cmd)
            end
        end
    else
        if _was_enabled then
            _preset_state.cond = nil
            _preset_state.idx = nil
            _preset_state.preset = nil
            _preset_state.selected_tick = (0)
        end
    end

    _was_enabled = var_0_71

end


DEF.activate = active
DEF.var_0_208 = var_0_209

return DEF]]
__bundle["require/features/aa/defensive_presets"] = [[local player_condition = require('require/aa/player_condition')
local time_helper = require('require/help/time')



local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Enabled' },
    { 'AA', 'Anti-aimbot angles', 'Pitch' },
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Yaw jitter' },
    { 'AA', 'Anti-aimbot angles', 'Body yaw' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end


local M = {}

local function var_0_35(v, a, b) if v < a then return a end if v > b then return b end return v end

local function var_0_225(gs_index, ref_index, value)
    local refs = gs_item_refs[gs_index]
    if not refs or not refs[ref_index] then return false end
    pcall(ui.set, refs[ref_index], value)
    return true
end



local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")



local function var_0_277(cmd)

    local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
    if not menu_ok or not var_0_166 or not var_0_166.ui then return end
    local ok_get, misc_fakedef = pcall(ui.get, var_0_166.ui.fakelag_fakedef)

    

    if misc_fakedef then 
        cmd.force_defensive = false
    else
        cmd.force_defensive = true
    end
end

local presets_by_condition = {



    stand = {

        [(1)] = {

            name = "spin",
            var_0_11 = function(state, cmd)


                local tick = globals.tickcount()
                if not tick then return state._last_side end
                local spin_speed = (state and state.speed) or math.random((-(17*5)), (17*5)) 
                local raw = (tick * spin_speed) % (180*2)
                local angle = raw - (90*2)
                state._side = angle
                local phase = math.floor(tick / (1+1)) % (1+1)
                local pitch = (phase == (0)) and (-(88+1)) or (88+1)
                state._pitch = pitch

                
                stop = tick % (10*2) < (4+1) and true or false
                if stop then
                    var_0_225((2*2), (1+1), (4*2))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (88+1))
                    var_0_225((4+1), (1), 'off')
                    var_0_225((3*2), (1), 'off')
                    cmd.force_defensive = false
                else
                    var_0_277(cmd)
                    var_0_225((2*2), (1), '180')
                    var_0_225((2*2), (1+1), state._side)
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), state._pitch)
                end

            end

        }
    },

    move = {

        [(1)] = {

            name = "spin",
            var_0_11 = function(state, cmd)


                local tick = globals.tickcount()
                if not tick then return state._last_side end
                local spin_speed = (state and state.speed) or math.random((-(17*5)), (17*5)) 
                local raw = (tick * spin_speed) % (180*2)
                local angle = raw - (90*2)
                state._side = angle
                local phase = math.floor(tick / (1+1)) % (1+1)
                local pitch = (phase == (0)) and (-(88+1)) or (88+1)
                state._pitch = pitch

                
                stop = tick % (10*2) < (18+1) and true or false
                if stop then
                    cmd.force_defensive = false
                else
                    var_0_277(cmd)
                    var_0_225((2*2), (1), '180')
                    var_0_225((2*2), (1+1), (90*2))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (-(88+1)))
                end

            end

        }
    },

    duck = {
        
        [(1)] = {

            name = "spin",
            var_0_11 = function(state, cmd)



                local tick = globals.tickcount()
                if not tick then return state._last_side end

                if tick % (128*2) < (64*2) then
                    spin_speed = math.random((7*5), (11*5))
                else
                    spin_speed = math.random((-(11*5)), (-(7*5)))
                end

                local raw = (tick * spin_speed) % (180*2)
                local angle = raw - (90*2)

                state._side = angle



                if tick % (64*2) < (1+1) then
                    state._pitch = math.random((-(88+1)), (0))
                end

                
                stop = tick % (16*2) < (3*3) and true or false
                if stop then
                    var_0_225((2*2), (1+1), (4*2))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (88+1))
                    var_0_225((4+1), (1), 'off')
                    var_0_225((3*2), (1), 'off')
                    cmd.force_defensive = false
                else
                    var_0_277(cmd)
                    var_0_225((2*2), (1), '180')
                    var_0_225((2*2), (1+1), state._side)
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), state._pitch)
                end

            end

        }
    },

    ['jump'] = {


        [(1)] = {

            name = "one-circle then pause",
            var_0_11 = function(state, cmd)


                local tick = globals.tickcount()
                state._pitch = math.random((-(88+1)), (88+1))

                stop = tick % (16*2) < (2*2) and true or false
                if stop then
                    var_0_225((2*2), (1+1), (4*2))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (88+1))
                    var_0_225((4+1), (1), 'off')
                    var_0_225((3*2), (1), 'off')
                    cmd.force_defensive = false
                else
                    var_0_225((2*2), (1), '180')
                    var_0_225((2*2), (1+1), math.random((-(90*2)), (90*2)))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), state._pitch)
                    var_0_277(cmd)
                end
            end

        },




    },

    ['jump+'] = {
        [(0)] = {
            name = "jitter -90/90",
            var_0_11 = function(state, cmd)


                local tick = globals.tickcount()
                if not tick then return state._last_side end

                local phase = math.floor(tick / (1+1)) % (1+1)
                local side = (phase == (0)) and (-(45*2)) or (45*2)
                state._side = side

                stop = tick % (16*2) < (2*2) and true or false


                if stop then
                    var_0_225((2*2), (1+1), (4*2))
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (88+1))
                    var_0_225((4+1), (1), 'off')
                    var_0_225((3*2), (1), 'off')
                    cmd.force_defensive = false
                else
                    var_0_225((2*2), (1+1), state._side)
                    var_0_225((1+1), (1), 'Custom')
                    var_0_225((1+1), (1+1), (-(7*5)))
                    var_0_225((4+1), (1), 'off')
                    var_0_225((3*2), (1), 'off')
                    var_0_277(cmd)
                end

            end
        },


    },

        
    global = {
        [(0)] = {
            name = "back",
            var_0_11 = function(state, cmd)

            end
        }
    }


}





local function var_0_147(t)
    local ks = {}
    for k, _ in pairs(t) do
        if type(k) == 'number' then table.insert(ks, k) end
    end
    table.sort(ks)
    return ks
end

function M.get_presets_for_condition(cond)
    cond = cond or player_condition.get() or 'global'
    return presets_by_condition[cond] or presets_by_condition['global'] or {}
end

function M.get_preset_by_index(cond, idx)
    local var_0_155 = M.get_presets_for_condition(cond)
    return var_0_155[idx]
end

function M.get_random_for_condition(cond)
    local var_0_155 = M.get_presets_for_condition(cond)
    local ks = var_0_147(var_0_155)
    if #ks == (0) then return nil, nil end
    local pick = ks[math.random((1), #ks)]
    return pick, var_0_155[pick]
end

function M.get_random_for_current_condition()
    return M.get_random_for_condition(player_condition.get())
end

function M.get_next_for_condition(cond, current_idx)
    local var_0_155 = M.get_presets_for_condition(cond)
    local ks = var_0_147(var_0_155)
    if #ks == (0) then return nil, nil end
    
    local pos = (1)
    for i, k in ipairs(ks) do
        if k == current_idx then pos = i; break end
    end
    local nextpos = (pos % #ks) + (1)
    local nextk = ks[nextpos]
    return nextk, var_0_155[nextk]
end


function M.available_conditions()
    local out = {}
    for k, _ in pairs(presets_by_condition) do table.insert(out, k) end
    table.sort(out)
    return out
end

M._presets = presets_by_condition

return M
]]
__bundle["require/features/misc/analyze"] = [[local function var_0_172(angle)
	while angle > (90*2) do angle = angle - (180*2) end
	while angle < (-(90*2)) do angle = angle + (180*2) end
	return angle
end

local player_labels = _G.player_labels or {}
_G.player_labels = player_labels

local var_0_110 = function(ent)
	return (_G.player_history and _G.player_history[ent]) or nil
end

local ok_dispatch, resolver_dispatcher = pcall(require, "require/features/misc/resolver_dispatcher")

local function var_0_6(ent)
	
	local hist = var_0_110(ent)
	if not hist or #hist < (1+1) then
		player_labels[ent] = nil
		return
	end

	
	
	local ok_now, var_0_173 = pcall(function() return (globals and globals.curtime and globals.curtime()) or nil end)
	if hist[(1)] and hist[(1)].last_shot_time and ok_now and var_0_173 then
		local shot_age = var_0_173 - hist[(1)].last_shot_time
		if shot_age >= (0) and shot_age <= (0.25) then
			player_labels[ent] = "ON SHOT"
			return
		end
	end

	
	local deltas = {}
	for i = (1), #hist - (1) do
		local a = hist[i] and hist[i].yaw
		local b = hist[i+(1)] and hist[i+(1)].yaw
		if a ~= nil and b ~= nil then
			deltas[#deltas + (1)] = var_0_172(a - b)
		end
	end

	if #deltas == (0) then
		player_labels[ent] = nil
		return
	end

	
	local sum, sumabs = (0), (0)
	local maxv, minv = -1e9, 1e9
	for _, v in ipairs(deltas) do
		sum = sum + v
		sumabs = sumabs + math.abs(v)
		if v > maxv then maxv = v end
		if v < minv then minv = v end
	end
	local mean = sum / #deltas
	local meanabs = sumabs / #deltas

	local var = (0)
	for _, v in ipairs(deltas) do
		var = var + (v - mean) ^ (1+1)
	end
	local std = math.sqrt(var / #deltas)

	local sign_changes = (0)
	for i = (1+1), #deltas do
		if (deltas[i] > (0) and deltas[i-(1)] < (0)) or (deltas[i] < (0) and deltas[i-(1)] > (0)) then
			sign_changes = sign_changes + (1)
		end
	end

	
	local last_delta = deltas[(1)]
	local total_range = maxv - minv

	
	local sorted = {}
	for i, v in ipairs(deltas) do sorted[i] = v end
	table.sort(sorted)
	local median = sorted[math.ceil(#sorted / (1+1))]

	
	local features = {
		deltas = deltas,
		mean = mean,
		meanabs = meanabs,
		std = std,
		sign_changes = sign_changes,
		max_delta = maxv,
		min_delta = minv,
		total_range = total_range,
		median = median,
		last_delta = last_delta,
		samples = #deltas,
		last_yaw = hist[(1)] and hist[(1)].yaw,
		oldest_yaw = hist[#hist] and hist[#hist].yaw,
		hist = hist
	}

	
	do
		local speed_sum, speed_cnt = (0), (0)
		local feet_yaw, goal_feet_yaw, move_anim
		for i=(1),math.min(#hist, (10*2)) do
			local s = hist[i]
			if s then
				if s.moveSpeedAnim then speed_sum = speed_sum + (s.moveSpeedAnim or (0)); speed_cnt = speed_cnt + (1) end
				if s.speed2d then speed_sum = speed_sum + (s.speed2d or (0)); speed_cnt = speed_cnt + (1) end
				if not feet_yaw and s.feetYaw then feet_yaw = s.feetYaw end
				if not goal_feet_yaw and s.goalFeetYaw then goal_feet_yaw = s.goalFeetYaw end
				if not move_anim and s.moveSpeedAnim then move_anim = s.moveSpeedAnim end
			end
		end
		local avg_speed = (speed_cnt > (0)) and (speed_sum / speed_cnt) or (0)
		features.movement = avg_speed >= (1.2)
		features.avg_speed = avg_speed
		features.feet_yaw = feet_yaw
		features.goal_feet_yaw = goal_feet_yaw
		features.move_anim = move_anim
	end

	local label = nil
	if var_0_60 and var_0_60(features, ent) then label = "STATIC" end
	if var_0_59 and var_0_59(features, ent) then label = "SPIN" end
	if var_0_55 and var_0_55(features, ent) then label = "JITTER-" end
	if var_0_54 and var_0_54(features, ent) then label = "JITTER" end
	if var_0_56 and var_0_56(features, ent) then label = "JITTER+" end
	if var_0_61 and var_0_61(features, ent) then label = "SWAY" end
	if var_0_58 and var_0_58(features, ent) then label = "SKITTER" end
	if var_0_52 and var_0_52(features, ent) then label = "DEFENSIVE" end
	if var_0_57 and var_0_57(features, ent) then label = "RANDOM" end
	if var_0_53 and var_0_53(features, ent) then label = "DELAYED" end

	if not label then label = "?" end
	pcall(function()
		local name = nil
		pcall(function() name = entity.get_player_name(ent) end)
		local last_shot = "nil"
		if hist and hist[(1)] and hist[(1)].last_shot_time then
			last_shot = string.format("%.3f", hist[(1)].last_shot_time)
		end
		local feet = features.feet_yaw and string.format("%.2f", features.feet_yaw) or "nil"
		local goal_feet = features.goal_feet_yaw and string.format("%.2f", features.goal_feet_yaw) or "nil"

	end)

	player_labels[ent] = label

	
	if ok_dispatch and resolver_dispatcher and type(resolver_dispatcher.process_entity) == "function" then
		pcall(function() resolver_dispatcher.process_entity(ent, label, features) end)
	end
end



function var_0_60(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local deltas = features.deltas or {}
	local small_mean_thr = (1.0)
	local small_std_thr = (1.5)
	local motion_thr = (2.5)

	if meanabs <= small_mean_thr and std <= small_std_thr then
		return true
	end

	local large_count = (0)
	local first_large_idx = nil
	for i, d in ipairs(deltas) do
		if math.abs(d) >= motion_thr then
			large_count = large_count + (1)
			if not first_large_idx then
				first_large_idx = i
			end
		end
	end

	if large_count == (0) then
		return true
	end

	if large_count == (1) and first_large_idx and first_large_idx > (10*2) then
		return true
	end

	return false
end

function var_0_55(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	local result = false

	if samples >= (2*2) then
		local min_mean = (5.0)
		local max_mean = (12.0)
		local std_max = (22.0)
		local maxd_max = (40.0)

		if meanabs >= min_mean and meanabs < max_mean and std <= std_max and maxd <= maxd_max then
			result = true
		end
	end

	return result
end

function var_0_54(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	local result = false

	if samples >= (2*2) then
		local min_mean = (features.movement and (8.0)) or (6.0)
		local max_mean = (24.0)
		local std_limit = (34.0)
		local permissive_std = (28.0)
		local maxd_allow = (100.0)

		if meanabs >= min_mean and meanabs < max_mean and std <= std_limit then
			if sign_changes >= (1+1) or maxd <= maxd_allow or (meanabs < (12.0) and std <= permissive_std) then
				result = true
			end
		end
	end

	return result
end

function var_0_56(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	local result = false

	if samples >= (2*2) then
		local min_mean = (18.0)
		local strong_mean = (22.0)
		local std_min = (26.0)
		local maxd_min = (70.0)

		if meanabs >= min_mean and (std >= std_min or maxd >= maxd_min) then
			if meanabs >= strong_mean or maxd >= maxd_min or std >= (std_min + (4*2)) then
				result = true
			end
		end
	end
	
	return result
end

function var_0_61(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local total_range = features.total_range or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	local result = false

	if samples >= (3*2) then
		local min_mean = (2.5)
		local max_mean = (15.0)
		local min_sign_ratio = (0.08)
		local min_total_range = (30.0)
		local max_total_range = (180.0)

		if meanabs >= min_mean and meanabs < max_mean and std <= (40.0) and total_range >= min_total_range and total_range <= max_total_range then
			if (sign_changes / math.max((1), samples)) >= min_sign_ratio then
				result = true
			end
		end
	end

	return result
end

function var_0_59(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local total_range = features.total_range or (0)
	local last_delta = features.last_delta or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	local deltas = features.deltas or {}

	local pos_count, neg_count, zero_count = (0), (0), (0)
	for _, v in ipairs(deltas) do
		if v > (0.5) then pos_count = pos_count + (1)
		elseif v < (-0.5) then neg_count = neg_count + (1)
		else zero_count = zero_count + (1) end
	end

	local dir_ratio = math.max(pos_count, neg_count) / math.max((1), samples)
	local dir_bias = math.abs(pos_count - neg_count) / math.max((1), (pos_count + neg_count))

	local longest_run, cur_run, last_sign = (0), (0), (0)
	for _, v in ipairs(deltas) do
		local s = (0)
		if v > (0.5) then s = (1) elseif v < (-0.5) then s = (-(1)) end
		if s ~= (0) and s == last_sign then
			cur_run = cur_run + (1)
		else
			cur_run = (s ~= (0)) and (1) or (0)
			last_sign = s
		end
		if cur_run > longest_run then longest_run = cur_run end
	end

	local longest_ratio = longest_run / math.max((1), samples)

	local result = false

	if samples >= (3*2) then
		if total_range >= (150*2) and (dir_ratio >= (0.60) or dir_bias >= (0.60)) then
			result = true
		end

		if not result and total_range >= (70*2) and meanabs >= (3*3) and (dir_ratio >= (0.75) or dir_bias >= (0.70) or sign_changes <= (1)) then
			result = true
		end

		if not result and longest_ratio >= (0.50) and meanabs >= (4*2) and total_range >= (60*2) then
			result = true
		end

		if not result and maxd >= (60*2) and (dir_ratio >= (0.60) or dir_bias >= (0.60)) then
			result = true
		end
	end
	local score = nil
	if not result and samples > (0) then
		local norm_range = math.min(total_range, (180*2)) / (360.0)
		local norm_meanabs = math.min(meanabs, (30*2)) / (60.0)
		local sign_change_frac = (sign_changes or (0)) / math.max((1), samples)
		score = norm_range * (0.45) + norm_meanabs * (0.35) + dir_bias * (0.15) + dir_ratio * (0.05) - sign_change_frac * (0.20)
		if score >= (0.42) and total_range >= (100*2) and meanabs >= (3*2) then
			result = true
		end
		features.spin_score = score
	end

	return result
end

function var_0_58(features, ent)
	
	return false
end

function var_0_52(features, ent)
	
	return false
end

function var_0_57(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local total_range = features.total_range or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))
	local deltas = features.deltas or {}

	if samples < (3*2) then return false end

	local sign_frac = sign_changes / math.max((1), samples)
	local moving = features.movement
	if sign_frac >= (0.45) and std >= (moving and (12.0) or (18.0)) and meanabs >= (moving and (4.0) or (6.0)) then
		return true
	end

	if maxd >= (60*2) and sign_frac >= (0.30) and std >= (12.0) then
		return true
	end

	if total_range >= (30*2) and total_range <= (150*2) and sign_frac >= (0.40) and std >= (14.0) and meanabs >= (4.0) then
		return true
	end

	if std >= (30.0) and sign_frac >= (0.25) and meanabs >= (5.0) then
		return true
	end

	return false
end

function var_0_53(features, ent)
	local meanabs = features.meanabs or (0)
	local std = features.std or (0)
	local samples = features.samples or (0)
	local sign_changes = features.sign_changes or (0)
	local total_range = features.total_range or (0)
	local maxd = math.max(math.abs(features.max_delta or (0)), math.abs(features.min_delta or (0)))

	if samples >= (3*2) then
		local min_mean = (2.5)
		local max_mean = (24.0)
		local min_std = (9.0)
		local max_std = (40.0)
		local min_total_range = (10.0)

		if meanabs >= min_mean and meanabs < max_mean and std >= min_std and std <= max_std and total_range >= min_total_range then
			local sign_ratio = (sign_changes or (0)) / math.max((1), samples)
			if sign_changes <= (2+1) or sign_ratio <= (0.12) or maxd >= (20*2) then
				return true
			end
		end
	end

	return false
end

local function var_0_7()
	local ok, players = pcall(entity.get_players, true)
	if not ok or type(players) ~= "table" then return end
	for _, ent in ipairs(players) do
		if entity.is_alive(ent) and not entity.is_dormant(ent) then
			pcall(var_0_6, ent)
		else
			player_labels[ent] = nil
		end
	end
end

local function var_0_215(ent)
	if not entity.is_alive(entity.get_local_player()) then return end
	if not ent or ent == (0) then return end

	local lbl = player_labels[ent]


	if lbl then
		return true, lbl
	end

	local hist = var_0_110(ent)
	if hist and hist[(1)] and hist[(1)].yaw ~= nil then
		return true, tostring(hist[(1)].yaw)
	end
end

client.register_esp_flag("Resolver", (85*3), (85*3), (85*3), var_0_215)

client.set_event_callback('net_update_end', function()
	local ok_ms, var_0_166 = pcall(require, "require/abc/menu_setup")
	if ok_ms and var_0_166 and var_0_166.ui and var_0_166.ui.misc_resolver then
		local ok_get, var_0_71 = pcall(ui.get, var_0_166.ui.misc_resolver)
		if ok_get and var_0_71 then
			pcall(var_0_7)
		end
	end
end)
]]
__bundle["require/features/misc/animlayer"] = [[]]
__bundle["require/features/misc/animstate"] = [[]]
__bundle["require/features/misc/buybot"] = [[

local AWP_PRICE = (2375*2)
local RETRY_DELAY = (0.06) 
local MAX_RETRIES = (20*2) 
local DEBUG_BUYBOT = true
local MIN_BALANCE = (5000*2) 

local bought_flag = false
local buying_in_progress = false

local prev_local_player = entity.get_local_player()

local function var_0_189()
    local lp = entity.get_local_player()
    if not lp then return false end
    for i = (0), (32*2) do
        local wep = entity.get_prop(lp, "m_hMyWeapons", i)
        if wep then
            local classname = entity.get_classname(wep) or ''
            if type(classname) == 'string' and classname:lower():find('awp') then
                return true
            end
        end
    end
    return false
end

local function var_0_31()
    local lp = entity.get_local_player()
    if not lp then return false end
    local acct = entity.get_prop(lp, 'm_iAccount') or (0)
    return acct >= AWP_PRICE
end


local function var_0_120()
    local lp = entity.get_local_player()
    if not lp then return nil end
    
    local team = entity.get_prop(lp, 'm_iTeamNum') or entity.get_prop(lp, 'm_iTeam')
    if not team then return nil end
    if team == (2+1) then return 'ct' end
    if team == (1+1) then return 't' end
    return nil
end

local function var_0_265()
    if bought_flag then return true end
    local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
    if not menu_ok or not var_0_166 or not var_0_166.ui then
        if DEBUG_BUYBOT then 
        return false
    end

    
    if not ui.get(var_0_166.ui.misc_buybot) then
        if DEBUG_BUYBOT then 
        return false
    end

    local lp = entity.get_local_player()
    if DEBUG_BUYBOT then 
    if not lp then return false end
    if not entity.is_alive(lp) then return false end

    
    
    local function var_0_23()
        local primary_sel = ui.get(var_0_166.ui.misc_buybot_primary) or {}
        local secondary = ui.get(var_0_166.ui.misc_buybot_secondary) or {}
        local misc = ui.get(var_0_166.ui.misc_buybot_misc) or {}
        local gren = ui.get(var_0_166.ui.misc_buybot_grenades) or {}

        local team_side = var_0_120()
        local map = {
            
            ['awp'] = 'buy awp',
            ['auto'] = { ct = 'buy scar20', t = 'buy g3sg1' },
            ['ssg'] = 'buy ssg08',
            
            ['heavy'] = 'buy deagle',
            ['dualies'] = 'buy elite',
            ['five-seven / tec-9'] = { ct = 'buy fn57', t = 'buy tec9' },
            ['p250'] = 'buy p250',
            
            ['taser'] = 'buy taser',
            ['kevlar'] = 'buy vest',
            ['helmet'] = 'buy vesthelm',
            ['defuse kit'] = 'buy defuser',
            
            ['molotov'] = { ct = 'buy incgrenade', t = 'buy molotov' },
            ['smoke'] = 'buy smokegrenade',
            ['high explosive'] = 'buy hegrenade'
        }

        local function var_0_210(key)
            local m = map[key]
            if not m then return nil end
            if type(m) == 'table' then
                return team_side and m[team_side] or nil
            end
            return m
        end

        local function var_0_43(var_0_155, key)
            for _, v in ipairs(var_0_155) do if v == key then return true end end
            return false
        end

        local primary_cmds = {}
        
        if var_0_43(primary_sel, 'awp') then local r = var_0_210('awp') if r then table.insert(primary_cmds, r) end end
        if var_0_43(primary_sel, 'ssg') then local r = var_0_210('ssg') if r then table.insert(primary_cmds, r) end end
        if var_0_43(primary_sel, 'auto') then local r = var_0_210('auto') if r then table.insert(primary_cmds, r) end end

        local other_cmds = {}
        
        for _, k in ipairs(primary_sel) do
            if k ~= 'awp' and k ~= 'ssg' and k ~= 'auto' then
                local r = var_0_210(k)
                if r then table.insert(other_cmds, r) end
            end
        end

        for _, k in ipairs(secondary) do local r = var_0_210(k) if r then table.insert(other_cmds, r) end end
        for _, k in ipairs(misc) do local r = var_0_210(k) if r then table.insert(other_cmds, r) end end
        for _, k in ipairs(gren) do local r = var_0_210(k) if r then table.insert(other_cmds, r) end end

        return primary_cmds, other_cmds
    end

    local primary_cmds, other_cmds = var_0_23()
    local has_any = (primary_cmds and #primary_cmds > (0)) or (other_cmds and #other_cmds > (0))
    if not has_any then
        if DEBUG_BUYBOT then 
        return false
    end

    
    do
        local acct = entity.get_prop(lp, 'm_iAccount') or (0)
        if acct <= MIN_BALANCE then
            if DEBUG_BUYBOT then 
            
            local ok2, menu_setup2 = pcall(require, "require/abc/menu_setup")
            if ok2 and menu_setup2 and menu_setup2.ui and menu_setup2.ui.paint_logger then
                local logger_sel = ui.get(menu_setup2.ui.paint_logger) or {}
                for _, v in ipairs(logger_sel) do
                    if type(v) == 'string' and v:lower() == 'buybot' then
                        local okm, modules = pcall(require, 'modules')
                        if okm and modules and modules.var_0_192 then
                            pcall(modules.var_0_192, ('[Buybot] Skipped buys — account=%d'):format(acct), (2*2), (85*3), (100*2), (0), (85*3))
                        end
                        break
                    end
                end
            end
            return false
        end
    end

    
    local price_map = {
        awp = (2375*2),
        ssg08 = (850*2),
        scar20 = (2500*2),
        g3sg1 = (2500*2),
        deagle = (350*2),
        elite = (400*2),
        fiveseven = (250*2),
        tec9 = (250*2),
        p250 = (150*2),
        taser = (100*2),
        vest = (325*2),
        vesthelm = (500*2),
        defuser = (200*2),
        molotov = (200*2),
        incgrenade = (200*2),
        smokegrenade = (150*2),
        hegrenade = (150*2)
    }

    local function var_0_44(cmd)
        if not cmd then return (0) end
        local token = cmd:match('buy%s+(%S+)')
        if not token then return (0) end
        token = token:lower()
        return price_map[token] or (0)
    end

    local total_cost = (0)
    for _, c in ipairs(primary_cmds or {}) do total_cost = total_cost + var_0_44(c) end
    for _, c in ipairs(other_cmds or {}) do total_cost = total_cost + var_0_44(c) end
    local acct_now = entity.get_prop(lp, 'm_iAccount') or (0)
    if acct_now < total_cost then
        if DEBUG_BUYBOT then 
        
        local ok2, menu_setup2 = pcall(require, "require/abc/menu_setup")
        if ok2 and menu_setup2 and menu_setup2.ui and menu_setup2.ui.paint_logger then
            local logger_sel = ui.get(menu_setup2.ui.paint_logger) or {}
            for _, v in ipairs(logger_sel) do
                if type(v) == 'string' and v:lower() == 'buybot' then
                    local okm, modules = pcall(require, 'modules')
                    if okm and modules and modules.var_0_192 then
                        pcall(modules.var_0_192, ('[Buybot] Skipping buys — funds %d < required %d'):format(acct_now, total_cost), (2*2), (85*3), (100*2), (0), (85*3))
                    end
                    break
                end
            end
        end
        return false
    end

    
    
    
    local skip_primary_chain_due_to_existing = false
    if primary_cmds and #primary_cmds > (0) and var_0_189() then
        skip_primary_chain_due_to_existing = true
    end

    
    local function var_0_190(item_token)
        if not item_token then return false end
        local lp = entity.get_local_player()
        if not lp then return false end
        item_token = tostring(item_token):lower()
        for i = (0), (32*2) do
            local wep = entity.get_prop(lp, 'm_hMyWeapons', i)
            if wep then
                local classname = (entity.get_classname(wep) or ''):lower()
                if classname:find(item_token, (1), true) or classname:find(item_token) then
                    return true
                end
            end
        end
        return false
    end

    
    local function var_0_77()
        if not other_cmds or #other_cmds == (0) then return end
        
        local batch = table.concat(other_cmds, ';') .. ';'
        client.exec(batch)
        
        
        local ok2, menu_setup2 = pcall(require, "require/abc/menu_setup")
        if ok2 and menu_setup2 and menu_setup2.ui and menu_setup2.ui.paint_logger then
            local logger_sel = ui.get(menu_setup2.ui.paint_logger) or {}
            for _, v in ipairs(logger_sel) do
                if type(v) == 'string' and v:lower() == 'buybot' then
                    local okm, modules = pcall(require, 'modules')
                    if okm and modules and modules.var_0_192 then
                        pcall(modules.var_0_192, ('[Buybot] Bought (others): %s'):format(batch), (2*2), (85*3), (85*3), (0), (85*3))
                    else
                        
                    end
                    break
                end
            end
        end
    end

    
    local function var_0_78(idx)
        idx = idx or (1)
        if idx > #primary_cmds then
            
            var_0_77()
            return true
        end

        local cmd = primary_cmds[idx]
        if not cmd then return var_0_78(idx + (1)) end
        local item = cmd:match('buy%s+(%S+)')
        if item and var_0_190(item) then
            if DEBUG_BUYBOT then 
            return var_0_78(idx + (1))
        end

        
        client.exec(cmd .. ';')
        

        
        
        client.delay_call(1.0, function()
            if item and var_0_190(item) then
                bought_flag = true
                if DEBUG_BUYBOT then 
                
                local ok2, menu_setup2 = pcall(require, "require/abc/menu_setup")
                if ok2 and menu_setup2 and menu_setup2.ui and menu_setup2.ui.paint_logger then
                    local logger_sel = ui.get(menu_setup2.ui.paint_logger) or {}
                    for _, v in ipairs(logger_sel) do
                        if type(v) == 'string' and v:lower() == 'buybot' then
                            local okm, modules = pcall(require, 'modules')
                            if okm and modules and modules.var_0_192 then
                                pcall(modules.var_0_192, ('[Buybot] Bought primary: %s'):format(item), (2*2), (85*3), (85*3), (0), (85*3))
                            end
                            break
                        end
                    end
                end
                
                var_0_77()
                return
            end

            
            var_0_78(idx + (1))
        end)

        return true
    end

    
    if skip_primary_chain_due_to_existing then
        if DEBUG_BUYBOT then 
        var_0_77()
        return true
    end

    var_0_78((1))
    return true
end

local function var_0_191(remaining)
    if remaining <= (0) or bought_flag then
        buying_in_progress = false
        if DEBUG_BUYBOT and not bought_flag then 
        return
    end

    if var_0_265() then
        
        return
    end

    
    if DEBUG_BUYBOT then 
    client.delay_call(RETRY_DELAY, function() var_0_191(remaining - 1) end)
end


local function var_0_254()
    if buying_in_progress or bought_flag then return end
    if DEBUG_BUYBOT then 
    buying_in_progress = true
    var_0_191(MAX_RETRIES)
end




client.set_event_callback('cs_pre_restart', function()
    local delay = (0.3) - (client.latency() or (0))
    if delay < (0.05) then delay = (0.05) end
    client.delay_call(delay, var_0_254)
end)

client.set_event_callback('round_prestart', function()
    
    client.delay_call(0.12, var_0_254)
end)




client.set_event_callback('item_purchase', function(e)
    if not e or not e.userid then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= entity.get_local_player() then return end
    if not e.weapon then return end
    if type(e.weapon) == 'string' and e.weapon:lower():find('awp') then
        bought_flag = true
        buying_in_progress = false
        
    end
end)


client.set_event_callback('round_end', function() bought_flag = false buying_in_progress = false end)
client.set_event_callback('player_spawn', function(e)
    if e and client.userid_to_entindex(e.userid) == entity.get_local_player() then
        bought_flag = false
        buying_in_progress = false
        
        client.delay_call(0.04, var_0_254)
    end
end)




client.set_event_callback('player_spawned', function(e)
    if e and client.userid_to_entindex(e.userid) == entity.get_local_player() then
        bought_flag = false
        buying_in_progress = false
        client.delay_call(0.04, var_0_254)
    end
end)

client.set_event_callback('switch_team', function()
    
    client.delay_call(0.06, var_0_254)
end)


client.set_event_callback('buytime_ended', function()
    buying_in_progress = false
    if DEBUG_BUYBOT then 
end)




client.set_event_callback('paint', function()
    local lp = entity.get_local_player()
    if not prev_local_player and lp then
        
        bought_flag = false
        buying_in_progress = false
        var_0_254()
    end
    prev_local_player = lp
end)

return {}
]]
__bundle["require/features/misc/collect"] = [[
local M = {}


do
    local ok, ffi = pcall(require, "ffi")
    if ok and ffi and client and client.create_interface then
        local status, entity_list_ptr = pcall(function()
            return client.create_interface("client.dll", "VClientEntityList003")
        end)

        if status and entity_list_ptr then
            local pointer_type = ffi.typeof("void***")
            local entity_list = ffi.cast(pointer_type, entity_list_ptr)
            local ok_cast, get_client_entity = pcall(function()
                return ffi.cast("void*(__thiscall*)(void*, int)", entity_list[(0)][(2+1)])
            end)

            if ok_cast and get_client_entity then
                
                local animstate_offset = 0x9960

                
                
                
                ffi.cdef[[
                struct animation_layer_t {
                    char  pad_0000[20];
                    uint32_t m_nOrder;
                    uint32_t m_nSequence;
                    float m_flPrevCycle;
                    float m_flWeight;
                    float m_flWeightDeltaRate;
                    float m_flPlaybackRate;
                    float m_flCycle;
                    void *m_pOwner;
                    char  pad_0038[4];
                };
                ] ]

                
                
                

                ffi.cdef[[
                struct c_animstate_min {
                    char pad0[3];
                    char m_bForceWeaponUpdate;
                    char pad1[91];
                    void* m_pBaseEntity;
                    void* m_pActiveWeapon;
                    void* m_pLastActiveWeapon;
                    float m_flLastClientSideAnimationUpdateTime;
                    int m_iLastClientSideAnimationUpdateFramecount;
                    float m_flAnimUpdateDelta;
                    float m_flEyeYaw;
                    float m_flPitch;
                    float m_flGoalFeetYaw;
                    float m_flCurrentFeetYaw;
                    float m_flCurrentTorsoYaw;
                    float m_flUnknownVelocityLean;
                    float m_flLeanAmount;
                    char pad2[4];
                    float m_flFeetCycle;
                    float m_flFeetYawRate;
                    char pad3[4];
                    float m_fDuckAmount;
                    float m_fLandingDuckAdditiveSomething;
                    char pad4[4];
                    float m_vOriginX;
                    float m_vOriginY;
                    float m_vOriginZ;
                    float m_vLastOriginX;
                    float m_vLastOriginY;
                    float m_vLastOriginZ;
                    float m_vVelocityX;
                    float m_vVelocityY;
                    char pad5[4];
                    float m_flUnknownFloat1;
                    char pad6[8];
                    float m_flUnknownFloat2;
                    float m_flUnknownFloat3;
                    float m_flUnknown;
                    float m_flSpeed2D;
                    float m_flUpVelocity;
                    float m_flSpeedNormalized;
                    float m_flFeetSpeedForwardsOrSideWays;
                    float m_flFeetSpeedUnknownForwardOrSideways;
                    float m_flTimeSinceStartedMoving;
                    float m_flTimeSinceStoppedMoving;
                    bool m_bOnGround;
                    bool m_bInHitGroundAnimation;
                    char pad7[2];
                    float m_flTimeSinceInAir;
                    float m_flLastOriginZ;
                    float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
                    float m_flStopToFullRunningFraction;
                    float m_flMagicFraction;
                    char pad8[60];
                    float m_flWorldForce;
                    char pad9[462];
                    float m_flMaxYaw;
                };
                ] ]

                
                M.var_0_2 = function(ent)
                    local ok_ent, ent_ptr = pcall(function()
                        return get_client_entity(entity_list, ent)
                    end)
                    if not ok_ent or ent_ptr == nil then return nil end
                    
                    
                    local base = ffi.cast("char*", ent_ptr)
                    local anim_ptr_ptr = ffi.cast("struct c_animstate_min**", base + animstate_offset)
                    if anim_ptr_ptr == nil or anim_ptr_ptr == ffi.NULL then return nil end
                    local anim_ptr = anim_ptr_ptr[(0)]
                    if anim_ptr == nil or anim_ptr == ffi.NULL then return nil end
                    return anim_ptr
                end
                
                M.var_0_3 = function(ent)
                    local ok_ent, ent_ptr = pcall(function()
                        return get_client_entity(entity_list, ent)
                    end)
                    if not ok_ent or ent_ptr == nil then return nil end
                    return ent_ptr
                end
            end
        end
    end
end



function M.get_sim_time(ent)
    local ok, val = pcall(function() return entity.get_prop(ent, "m_flSimulationTime") end)
    if ok then return val end
    return nil
end


function M.get_enemies_simtimes()
    local out = {}
    if not entity or not entity.get_players then return out end
    local enemies = entity.get_players(true) or {}
    for i = (1), #enemies do
        local ent = enemies[i]
        out[ent] = M.get_sim_time(ent)
    end
    return out
end


function M.get_velocity_3d(ent)
    local ok, vals = pcall(function() return { entity.get_prop(ent, "m_vecVelocity") } end)
    if not ok or type(vals) ~= "table" then return nil end
    if #vals >= (2+1) then
        return { vals[(1)], vals[(1+1)], vals[(2+1)] }
    end
    return nil
end


function M.get_speed_2d(ent)
    local v = M.get_velocity_3d(ent)
    if not v then return nil end
    local x, y = v[(1)] or (0), v[(1+1)] or (0)
    return math.sqrt(x * x + y * y)
end




function M.get_origin(ent)
    local ok, x, y, z = pcall(function() return entity.get_prop(ent, "m_vecOrigin") end)
    if ok and x then
        
        if type(x) == "table" then
            return x[(1)], x[(1+1)], x[(2+1)]
        elseif y and z then
            return x, y, z
        end
    end
    return nil
end


function M.get_view_offset(ent)
    local tries = { "m_vecViewOffset[0]", "m_vecViewOffset" }
    for _, prop in ipairs(tries) do
        local ok, v1, v2, v3 = pcall(function() return entity.get_prop(ent, prop) end)
        if ok and v1 then
            if type(v1) == "table" then
                return v1[(1)], v1[(1+1)], v1[(2+1)]
            elseif v2 and v3 then
                return v1, v2, v3
            end
        end
    end
    return nil
end


function M.get_eye_pos(ent)
    local ox, oy, oz = M.get_origin(ent)
    local vx, vy, vz = M.get_view_offset(ent)
    if ox and vx then
        return ox + vx, oy + vy, oz + vz
    end
    return nil
end


function M.get_eye_angles(ent)
    local tries = { "m_angEyeAngles[0]", "m_angEyeAngles", "m_angRotation", "m_angNetworkAngles" }
    for _, prop in ipairs(tries) do
        local ok, a1, a2, a3 = pcall(function() return entity.get_prop(ent, prop) end)
        if ok and a1 then
            if type(a1) == "table" then
                return a1[(1)], a1[(1+1)], a1[(2+1)]
            elseif a2 and a3 then
                return a1, a2, a3
            end
        end
    end
    return nil
end


function M.var_0_91(ent)
    local tries = { "m_angAbsRotation", "m_angAbsAngles", "m_angAbsOrigin" }
    for _, prop in ipairs(tries) do
        local ok, a1, a2, a3 = pcall(function() return entity.get_prop(ent, prop) end)
        if ok and a1 then
            if type(a1) == "table" then
                return a1[(1)], a1[(1+1)], a1[(2+1)]
            elseif a2 and a3 then
                return a1, a2, a3
            end
        end
    end
    return M.get_eye_angles(ent)
end


function M.get_lower_body_yaw(ent)
    local ok, val = pcall(function() return entity.get_prop(ent, "m_flLowerBodyYawTarget") end)
    if ok and val then return val end
    return nil
end


function M.get_feet_yaw(ent)
    
    if M.var_0_2 then
        local ok, anim = pcall(function() return M.var_0_2(ent) end)
        if ok and anim then
            local ok_v, val = pcall(function() return tonumber(anim.m_flCurrentFeetYaw) end)
            if ok_v and val then return val end
        end
    end
    
    return M.get_lower_body_yaw(ent)
end

function M.get_goal_feet_yaw(ent)
    
    if M.var_0_2 then
        local ok, anim = pcall(function() return M.var_0_2(ent) end)
        if ok and anim then
            local ok_v, val = pcall(function() return tonumber(anim.m_flGoalFeetYaw) end)
            if ok_v and val then return val end
        end
    end
    return M.get_feet_yaw(ent)
end


function M.get_speed(ent)
    
    local ok, val = pcall(function() return entity.get_prop(ent, "m_flVelocityModifier") end)
    if ok and val then return val end
    
    local v = M.get_velocity_3d(ent)
    if v then
        return math.sqrt((v[(1)] or (0)) * (v[(1)] or (0)) + (v[(1+1)] or (0)) * (v[(1+1)] or (0)) + (v[(2+1)] or (0)) * (v[(2+1)] or (0)))
    end
    return nil
end

function M.get_move_speed_anim(ent)
    
    
    
    
    
    if M.var_0_2 then
        local ok, anim = pcall(function() return M.var_0_2(ent) end)
        if ok and anim then
            local try_fields = { "m_flFeetSpeedForwardsOrSideWays", "m_flSpeed2D", "m_flSpeedNormalized", "m_flFeetSpeedUnknownForwardOrSideways" }
            for _, f in ipairs(try_fields) do
                local okf, val = pcall(function() return tonumber(anim[f]) end)
                if okf and val and val ~= (0) then
                    return val
                end
            end
        end
    end

    
    local ok_nv, nv = pcall(function() return entity.get_prop(ent, "m_flMaxspeed") end)
    if ok_nv and nv then return nv end

    
    return M.get_speed_2d(ent)
end


function M.get_flags(ent)
    local ok, val = pcall(function() return entity.get_prop(ent, "m_fFlags") end)
    if ok and val then return val end
    ok, val = pcall(function() return entity.get_prop(ent, "m_iFlags") end)
    if ok and val then return val end
    return nil
end



function M.read_animstate(ent)
    if not M.var_0_2 then return nil end
    local ok, anim = pcall(function() return M.var_0_2(ent) end)
    if not ok or not anim then return nil end
    local out = {}
    pcall(function()
        out.m_flEyeYaw = tonumber(anim.m_flEyeYaw)
        out.m_flPitch = tonumber(anim.m_flPitch)
        out.m_flGoalFeetYaw = tonumber(anim.m_flGoalFeetYaw)
        out.m_flCurrentFeetYaw = tonumber(anim.m_flCurrentFeetYaw)
        out.m_flCurrentTorsoYaw = tonumber(anim.m_flCurrentTorsoYaw)
        out.m_flUnknownVelocityLean = tonumber(anim.m_flUnknownVelocityLean)
        out.m_flLeanAmount = tonumber(anim.m_flLeanAmount)
        out.m_flFeetCycle = tonumber(anim.m_flFeetCycle)
        out.m_flFeetYawRate = tonumber(anim.m_flFeetYawRate)
        out.m_fDuckAmount = tonumber(anim.m_fDuckAmount)
        out.m_fLandingDuckAdditiveSomething = tonumber(anim.m_fLandingDuckAdditiveSomething)
        out.m_vOrigin = { tonumber(anim.m_vOriginX), tonumber(anim.m_vOriginY), tonumber(anim.m_vOriginZ) }
        out.m_vLastOrigin = { tonumber(anim.m_vLastOriginX), tonumber(anim.m_vLastOriginY), tonumber(anim.m_vLastOriginZ) }
        out.m_vVelocity = { tonumber(anim.m_vVelocityX), tonumber(anim.m_vVelocityY) }
        out.m_flUnknownFloat1 = tonumber(anim.m_flUnknownFloat1)
        out.m_flUnknownFloat2 = tonumber(anim.m_flUnknownFloat2)
        out.m_flUnknownFloat3 = tonumber(anim.m_flUnknownFloat3)
        out.m_flUnknown = tonumber(anim.m_flUnknown)
        out.m_flSpeed2D = tonumber(anim.m_flSpeed2D)
        out.m_flUpVelocity = tonumber(anim.m_flUpVelocity)
        out.m_flSpeedNormalized = tonumber(anim.m_flSpeedNormalized)
        out.m_flFeetSpeedForwardsOrSideWays = tonumber(anim.m_flFeetSpeedForwardsOrSideWays)
        out.m_flFeetSpeedUnknownForwardOrSideways = tonumber(anim.m_flFeetSpeedUnknownForwardOrSideways)
        out.m_flTimeSinceStartedMoving = tonumber(anim.m_flTimeSinceStartedMoving)
        out.m_flTimeSinceStoppedMoving = tonumber(anim.m_flTimeSinceStoppedMoving)
        out.m_bOnGround = (anim.m_bOnGround ~= (0))
        out.m_bInHitGroundAnimation = (anim.m_bInHitGroundAnimation ~= (0))
        out.m_flTimeSinceInAir = tonumber(anim.m_flTimeSinceInAir)
        out.m_flLastOriginZ = tonumber(anim.m_flLastOriginZ)
        out.m_flHeadHeightOrOffsetFromHittingGroundAnimation = tonumber(anim.m_flHeadHeightOrOffsetFromHittingGroundAnimation)
        out.m_flStopToFullRunningFraction = tonumber(anim.m_flStopToFullRunningFraction)
        out.m_flMagicFraction = tonumber(anim.m_flMagicFraction)
        out.m_flWorldForce = tonumber(anim.m_flWorldForce)
        out.m_flMaxYaw = tonumber(anim.m_flMaxYaw)
    end)
    return out
end



function M.read_anim_layers(ent)
    if not M.var_0_3 then return nil end
    local ok_ent, ent_ptr = pcall(function() return M.var_0_3(ent) end)
    if not ok_ent or not ent_ptr then return nil end
    local ok, res = pcall(function()
        local ffi = require("ffi")
        local base = ffi.cast("char*", ent_ptr)
        local layers_ptr = ffi.cast("struct animation_layer_t**", base + 0x2990)
        if layers_ptr == nil or layers_ptr == ffi.NULL then return nil end
        local owner = layers_ptr[(0)]
        if owner == nil or owner == ffi.NULL then return nil end
        local out = {}
        for i = (0), (5*3) do
            local layer = owner[i]
            if layer == nil or layer == ffi.NULL then break end
            local t = {}
            t.m_nOrder = tonumber(layer.m_nOrder)
            t.m_nSequence = tonumber(layer.m_nSequence)
            t.m_flPrevCycle = tonumber(layer.m_flPrevCycle)
            t.m_flWeight = tonumber(layer.m_flWeight)
            t.m_flWeightDeltaRate = tonumber(layer.m_flWeightDeltaRate)
            t.m_flPlaybackRate = tonumber(layer.m_flPlaybackRate)
            t.m_flCycle = tonumber(layer.m_flCycle)
            t.m_pOwner = tostring(layer.m_pOwner)
            table.insert(out, t)
        end
        return out
    end)
    if not ok then return nil end
    return res
end


function M.get_tick_from_simtime(simtime)
    if not simtime or not globals or not globals.tickinterval then return nil end
    local ti = globals.tickinterval()
    if not ti or ti == (0) then return nil end
    return math.floor(simtime / ti + (0.5))
end

function M.get_tick(ent)
    local sim = M.get_sim_time(ent)
    if sim then return M.get_tick_from_simtime(sim) end
    return nil
end








function M.get_enemies_snapshot(opts)
    opts = opts or {}
    local heavy = true 

    local out = {}
    if not entity or not entity.get_players then return out end
    local enemies = entity.get_players(true) or {}
    for i = (1), #enemies do
        local ent = enemies[i]
        local var_0_251 = {}

        
        var_0_251.is_alive = (pcall(function() return entity.is_alive(ent) end) and entity.is_alive(ent)) or false
        var_0_251.is_dormant = (pcall(function() return entity.is_dormant(ent) end) and entity.is_dormant(ent)) or false

        
        local ok_name, name = pcall(function() return entity.get_player_name(ent) end)
        var_0_251.name = ok_name and name or nil

        
        var_0_251.simtime = M.get_sim_time(ent)
        do
            local base_tick = var_0_251.simtime and M.get_tick_from_simtime(var_0_251.simtime) or nil
            
            local ok_flags, esp_flags = pcall(function()
                local d = entity.get_esp_data and entity.get_esp_data(ent)
                return (d and d.flags) or (0)
            end)

            local adjusted_tick = base_tick
            if ok_flags and esp_flags and base_tick then
                
                local ok_bit, is_backtrack = pcall(function()
                    return bit and bit.band(esp_flags, bit.lshift((1), (16+1))) ~= (0)
                end)
                if ok_bit and is_backtrack then
                    adjusted_tick = base_tick - (7*2)
                end
            end
            var_0_251.simTicks = adjusted_tick
        end

        
        do
            local ok, ox, oy, oz = pcall(function() return M.get_origin(ent) end)
            if ok and ox then var_0_251.origin = { ox, oy, oz } end
        end
        do
            local ok, vx, vy, vz = pcall(function() return M.get_view_offset(ent) end)
            if ok and vx then var_0_251.viewOffset = { vx, vy, vz } end
        end
        do
            local ok, ex, ey, ez = pcall(function() return M.get_eye_pos(ent) end)
            if ok and ex then var_0_251.eyePos = { ex, ey, ez } end
        end

        
        do
            local ok, a1, a2, a3 = pcall(function() return M.get_eye_angles(ent) end)
            if ok and a1 then var_0_251.eyeAngles = { a1, a2, a3 } end
        end
        do
            local ok, aa1, aa2, aa3 = pcall(function() return M.var_0_91(ent) end)
            if ok and aa1 then var_0_251.absAngles = { aa1, aa2, aa3 } end
        end

        
        var_0_251.lowerBodyYaw = (pcall(function() return M.get_lower_body_yaw(ent) end) and M.get_lower_body_yaw(ent)) or nil
        var_0_251.feetYaw = (pcall(function() return M.get_feet_yaw(ent) end) and M.get_feet_yaw(ent)) or var_0_251.lowerBodyYaw
        var_0_251.goalFeetYaw = (pcall(function() return M.get_goal_feet_yaw(ent) end) and M.get_goal_feet_yaw(ent)) or var_0_251.feetYaw

        
        var_0_251.velocity3d = (pcall(function() return M.get_velocity_3d(ent) end) and M.get_velocity_3d(ent)) or nil
        if var_0_251.velocity3d then
            var_0_251.speed2d = math.sqrt((var_0_251.velocity3d[(1)] or (0)) * (var_0_251.velocity3d[(1)] or (0)) + (var_0_251.velocity3d[(1+1)] or (0)) * (var_0_251.velocity3d[(1+1)] or (0)))
            var_0_251.speed3d = math.sqrt((var_0_251.velocity3d[(1)] or (0)) * (var_0_251.velocity3d[(1)] or (0)) + (var_0_251.velocity3d[(1+1)] or (0)) * (var_0_251.velocity3d[(1+1)] or (0)) + (var_0_251.velocity3d[(2+1)] or (0)) * (var_0_251.velocity3d[(2+1)] or (0)))
        else
            var_0_251.speed2d = M.get_speed_2d(ent)
            var_0_251.speed3d = M.get_speed(ent)
        end

        
        do
            local ok_ms, ms = pcall(function() return M.get_move_speed_anim(ent) end)
            if ok_ms and ms then
                var_0_251.moveSpeedAnim = ms
            else
                var_0_251.moveSpeedAnim = nil
            end
        end

        
        var_0_251.flags = (pcall(function() return M.get_flags(ent) end) and M.get_flags(ent)) or nil

        
        local ok_head, hx, hy, hz = pcall(function() return entity.hitbox_position(ent, "head") end)
        if ok_head and hx then var_0_251.headPos = { hx, hy, hz } end

        
        local ok_w, w = pcall(function() return entity.get_player_weapon(ent) end)
        var_0_251.weapon = ok_w and w or nil

        

        
        local ok_b, bones = pcall(function() return entity.get_bone_matrices and entity.get_bone_matrices(ent) end)
        if ok_b and bones then var_0_251.bones = bones end

        local ok_as, as = pcall(function() return M.read_animstate(ent) end)
        if ok_as and as then var_0_251.animstate_full = as end
        local ok_layers, layers = pcall(function() return M.read_anim_layers(ent) end)
        if ok_layers and layers then var_0_251.animLayers = layers end

        out[ent] = var_0_251
    end
    return out
end

return M
]]
__bundle["require/features/misc/collect_old"] = [[


local collect = {}

local entity = entity
local client = client
local globals = globals


local ok_ffi, ffi = pcall(function() return require('ffi') end)
local animstate_offset = 0x9960
local entity_list_ptr, get_client_entity = nil, nil
if ok_ffi then
  local ok_iface, create_interface = pcall(function() return client.create_interface end)
  if ok_iface and create_interface then
    local ok, ptr = pcall(create_interface, "client.dll", "VClientEntityList003")
    if ok and ptr then
      entity_list_ptr = ptr
      local pointer_type = ffi.typeof("void***")
      local ent_list = ffi.cast(pointer_type, entity_list_ptr)
      pcall(function()
        get_client_entity = ffi.cast("void*(__thiscall*)(void*, int)", ent_list[(0)][(2+1)])
      end)
    end
  end
end


local fast = {
  var_0_71 = false,
  animstate_offset = animstate_offset,
  anim_layers_offset = 0x2990,
  offsets = {
    player = {
      
      m_vecOrigin = (0),
      m_vecVelocity = (0),
      m_angEyeAngles = (0),
      m_fFlags = (0),
      m_flDuckAmount = (0),
      m_flSimulationTime = (0),
      bone_matrix = (0), 
    },
    weapon = {
      m_fLastShotTime = (0),
    }
  }
}

function collect.set_fast(var_0_71, tbl)
  fast.var_0_71 = var_0_71 and true or false
  if type(tbl) == 'table' then
    if tbl.animstate_offset then fast.animstate_offset = tbl.animstate_offset end
    if tbl.anim_layers_offset then fast.anim_layers_offset = tbl.anim_layers_offset end
    if tbl.offsets and type(tbl.offsets) == 'table' then
      for k,v in pairs(tbl.offsets) do fast.offsets[k] = fast.offsets[k] or {} end
      for k,sub in pairs(tbl.offsets) do for kk,vv in pairs(sub) do fast.offsets[k][kk] = vv end end
    end
  end
end


local function var_0_278(ax, ay, az, bx, by, bz)
  return (ax or (0)) + (bx or (0)), (ay or (0)) + (by or (0)), (az or (0)) + (bz or (0))
end

local function var_0_172(a)
  while a > (90*2) do a = a - (180*2) end
  while a < (-(90*2)) do a = a + (180*2) end
  return a
end


local function var_0_228(ret1, ret2, ret3)
  if ret1 == nil then
    return nil
  end
  return ret1, ret2 or (0), ret3 or (0)
end


local function var_0_268(ent, names)
  for _, name in ipairs(names) do
    local a, b, c = entity.get_prop(ent, name)
    if a ~= nil then
      return a, b, c, name
    end
  end
  return nil
end


function collect.get_origin(ent)
  
  local ox, oy, oz = entity.get_origin(ent)
  if ox ~= nil then
    return ox, oy, oz
  end

  
  local a, b, c = var_0_268(ent, {"m_vecOrigin", "m_vecNetworkOrigin"})
  return var_0_228(a, b, c)
end


function collect.get_view_offset(ent)
  local a, b, c, src = var_0_268(ent, {"m_vecViewOffset"})
  return var_0_228(a, b, c)
end


function collect.get_eye_pos(ent)
  local ox, oy, oz = collect.get_origin(ent)
  local vx, vy, vz = collect.get_view_offset(ent)
  if ox == nil and vx == nil then
    return nil
  end
  ox = ox or (0); oy = oy or (0); oz = oz or (0)
  vx = vx or (0); vy = vy or (0); vz = vz or (0)
  return var_0_278(ox, oy, oz, vx, vy, vz)
end


function collect.get_eye_angles(ent)
  
  local a, b, c, src = var_0_268(ent, {"m_angEyeAngles", "m_angEyeAngles[0]", "m_angRotation", "m_angAbsRotation"})
  if a == nil then
    return nil
  end
  
  return a, b, c
end


function collect.var_0_91(ent)
  local a, b, c, src = var_0_268(ent, {"m_angAbsAngles", "m_angAbsRotation", "m_angRotation"})
  if a == nil then
    
    return nil
  end
  return a, b, c
end


function collect.get_lower_body_yaw(ent)
  local a = var_0_268(ent, {"m_flLowerBodyYawTarget", "m_flLowerBodyYaw", "m_flLowerBodyYawTarget[0]"})
  if a == nil then
    return nil
  end
  return a
end


function collect.var_0_122(ent)
  local a, b, c, src = var_0_268(ent, {"m_vecVelocity", "m_vecVelocity[0]"})
  return var_0_228(a, b, c)
end


function collect.get_speed(ent)
  local vx, vy, vz = collect.var_0_122(ent)
  if vx == nil then return nil end
  return math.sqrt((vx or (0))*(vx or (0)) + (vy or (0))*(vy or (0)))
end


function collect.get_flags(ent)
  local a = var_0_268(ent, {"m_fFlags"})
  return a
end


function collect.get_sim_time(ent)
  local a = var_0_268(ent, {"m_flSimulationTime", "m_flAnimTime", "m_flSimulationTime[0]"})
  return a
end


function collect.get_tick(ent)
  local sim = collect.get_sim_time(ent)
  if sim == nil then return nil end
  local ti = globals.tickinterval and globals.tickinterval() or (0.015625)
  return math.floor(sim / ti)
end


function collect.get_eye_yaw(ent)
  local p, y, r = collect.get_eye_angles(ent)
  if y == nil and p == nil then return nil end
  
  return y or p
end

function collect.get_eye_pitch(ent)
  local p, y, r = collect.get_eye_angles(ent)
  if p == nil then return nil end
  return p
end

function collect.get_yaw_delta(ent)
  local eyeYaw = collect.get_eye_yaw(ent)
  local lby = collect.get_lower_body_yaw(ent)
  if eyeYaw == nil or lby == nil then return nil end
  return var_0_172((eyeYaw or (0)) - (lby or (0)))
end

function collect.get_is_moving(ent, thr)
  thr = thr or (0.1)
  local speed = collect.get_speed(ent)
  if speed == nil then return nil end
  return speed > thr
end

function collect.get_is_airborne(ent)
  local flags = collect.get_flags(ent)
  if flags == nil then return nil end
  
  return (flags & (1)) == (0)
end

function collect.get_is_ducking(ent)
  local duck = collect.get_duck_amount(ent)
  if duck ~= nil then
    return duck > (0.5)
  end
  local flags = collect.get_flags(ent)
  if flags ~= nil then
    
    return (flags & (1+1)) ~= (0)
  end
  return nil
end


function collect.get_backtrack_tick(ent, backticks)
  local t = collect.get_tick(ent)
  if t == nil then return nil end
  backticks = backticks or (0)
  return t - math.floor(backticks)
end



function collect.get_bone_matrices(ent)
  if not ok_ffi or not get_client_entity then return nil end
  local ok, ent_ptr = pcall(get_client_entity, entity_list_ptr, ent)
  if not ok or ent_ptr == nil then return nil end
  
  return nil
end


function collect.get_head_pos(ent)
  local hx, hy, hz = entity.hitbox_position(ent, "head")
  if hx == nil then return nil end
  return hx, hy, hz
end


function collect.get_animstate(ent)
  if not ok_ffi or not get_client_entity then return nil end
  local ok, ent_ptr = pcall(get_client_entity, entity_list_ptr, ent)
  if not ok or ent_ptr == nil then return nil end
  local animstate_ptr = nil
  pcall(function()
    animstate_ptr = ffi.cast("void**", ffi.cast("uintptr_t", ent_ptr) + animstate_offset)[(0)]
  end)
  if not animstate_ptr then return nil end
  return animstate_ptr
end


local function var_0_194(animstate_ptr, field)
  if not ok_ffi or not animstate_ptr then return nil end
  
  
  local field_offsets = {
    m_flGoalFeetYaw = 0x64, 
    m_flCurrentFeetYaw = 0x68,
    m_flFeetYawRate = 0x88,
    m_flSpeed2D = 0xA4,
    m_fDuckAmount = 0x90,
    m_flEyeYaw = 0x30,
  }
  local ofs = field_offsets[field]
  if not ofs then return nil end
  local ok, val = pcall(function()
    return ffi.cast("float*", ffi.cast("uintptr_t", animstate_ptr) + ofs)[(0)]
  end)
  if not ok then return nil end
  return val
end

function collect.get_feet_yaw(ent)
  
  local anim = collect.get_animstate(ent)
  if anim then
    local v = var_0_194(anim, "m_flCurrentFeetYaw") or var_0_194(anim, "m_flGoalFeetYaw")
    if v then return v end
  end
  
  return collect.get_lower_body_yaw(ent)
end

function collect.get_goal_feet_yaw(ent)
  local anim = collect.get_animstate(ent)
  if anim then
    return var_0_194(anim, "m_flGoalFeetYaw")
  end
  return nil
end

function collect.get_move_speed_anim(ent)
  local anim = collect.get_animstate(ent)
  if anim then
    return var_0_194(anim, "m_flSpeed2D")
  end
  return nil
end

function collect.get_duck_amount(ent)
  
  local anim = collect.get_animstate(ent)
  if anim then
    local v = var_0_194(anim, "m_fDuckAmount")
    if v then return v end
  end
  local a = var_0_268(ent, {"m_flDuckAmount"})
  return a
end

function collect.get_yaw_rate(ent)
  local anim = collect.get_animstate(ent)
  if anim then
    return var_0_194(anim, "m_flFeetYawRate")
  end
  return nil
end


function collect.get_anim_layers(ent)
  if not ok_ffi or not get_client_entity then return nil end
  local ok, ent_ptr = pcall(get_client_entity, entity_list_ptr, ent)
  if not ok or ent_ptr == nil then return nil end
  local layers_ptr = nil
  pcall(function()
    layers_ptr = ffi.cast("void**", ffi.cast("uintptr_t", ent_ptr) + (fast.anim_layers_offset or (0)))[(0)]
  end)
  if not layers_ptr then return nil end
  local function var_0_196(i)
    if not layers_ptr then return nil end
    local layer = ffi.cast("struct animation_layer_t**", ffi.cast("char*", ent_ptr) + (fast.anim_layers_offset or (0)))[(0)][i]
    if layer == nil or layer == ffi.NULL then return nil end
    local w = tonumber(layer.m_flWeight)
    local c = tonumber(layer.m_flCycle)
    local r = tonumber(layer.m_flPlaybackRate)
    return { weight = w, cycle = c, rate = r }
  end
  
  return {
    move = var_0_196((3*2)),
    land = var_0_196((4+1)),
    lean = var_0_196((6*2)),
    lower_body_yaw = collect.get_lower_body_yaw(ent)
  }
end


local function var_0_193(base, ofs)
  if not base or ofs == (0) then return nil end
  local p = ffi.cast("float*", ffi.cast("uintptr_t", base) + ofs)
  return p[(0)], p[(1)], p[(1+1)]
end

function collect.get_bone_position_from_matrix(ent, bone_index)
  if not ok_ffi or not get_client_entity then return nil end
  local bm_ofs = fast.offsets.player.bone_matrix or (0)
  if bm_ofs == (0) then return nil end
  local ok, ent_ptr = pcall(get_client_entity, entity_list_ptr, ent)
  if not ok or ent_ptr == nil then return nil end
  
  local stride = 0x30 
  local base = ffi.cast("uintptr_t", ent_ptr) + bm_ofs
  local ofs = stride * bone_index
  local x, y, z = nil, nil, nil
  pcall(function() x, y, z = var_0_193(base, ofs) end)
  if x == nil then return nil end
  return x, y, z
end

function collect.get_anim_metrics(ent)
  local anim = collect.get_animstate(ent)
  local layers = collect.get_anim_layers(ent)
  local res = {}
  if anim then
    res.goalFeetYaw = var_0_194(anim, "m_flGoalFeetYaw")
    res.feetYaw = var_0_194(anim, "m_flCurrentFeetYaw")
    res.yawRate = var_0_194(anim, "m_flFeetYawRate")
    res.speedAnim = var_0_194(anim, "m_flSpeed2D")
    res.duckAmount = var_0_194(anim, "m_fDuckAmount")
    res.eyeYaw = var_0_194(anim, "m_flEyeYaw")
  end
  if layers then
    res.move_weight = layers.move and layers.move.weight or nil
    res.move_cycle = layers.move and layers.move.cycle or nil
    res.lean_weight = layers.lean and layers.lean.weight or nil
    res.land_weight = layers.land and layers.land.weight or nil
    res.lower_body_yaw = layers.lower_body_yaw
  end
  res.pose_params = collect.get_pose_params(ent)
  return res
end


function collect.get_pose_params(ent)
  local res = {}
  for i=(0), (5*3) do
    local ok, a, b, c = pcall(entity.get_prop, ent, "m_flPoseParameter", i)
    if not ok or a == nil then break end
    res[#res+(1)] = a
  end
  if #res == (0) then return nil end
  return res
end



function collect.get(ent)
  if not ent then return nil end
  local ox, oy, oz = collect.get_origin(ent)
  local vx, vy, vz = collect.get_view_offset(ent)
  local ex, ey, ez = collect.get_eye_pos(ent)
  local pitch, yaw, roll = collect.get_eye_angles(ent)
  local ax, ay, az = collect.var_0_91(ent)
  local lby = collect.get_lower_body_yaw(ent)
  local velx, vely, velz = collect.var_0_122(ent)
  local speed = collect.get_speed(ent)
  local flags = collect.get_flags(ent)
  local simtime = collect.get_sim_time(ent)
  local tick = collect.get_tick(ent)

  return {
    origin = ox and {ox, oy, oz} or nil,
    viewOffset = vx and {vx, vy, vz} or nil,
    eyePos = ex and {ex, ey, ez} or nil,
    eyeAngles = pitch and {pitch, yaw, roll} or nil,
    eyeYaw = collect.get_eye_yaw(ent),
    eyePitch = collect.get_eye_pitch(ent),
    yawDelta = collect.get_yaw_delta(ent),
    
    lbyDelta = nil,
    absAngles = ax and {ax, ay, az} or nil,
    lowerBodyYaw = lby,
    velocity = velx and {velx, vely, velz} or nil,
    speed = speed,
    isMoving = collect.get_is_moving(ent),
    isAirborne = collect.get_is_airborne(ent),
    isDucking = collect.get_is_ducking(ent),
    
    isFake = nil,
    flags = flags,
    simTime = simtime,
    tick = tick,
    backtrackTick = collect.get_backtrack_tick(ent, (0)),
    
    angleHistory = nil,
    lastLBYUpdateTime = nil,
    lastShotTime = nil,
  }
end

return collect
]]
__bundle["require/features/misc/dormant_aimbot"] = [[local client_visible, client_eye_position, client_log, client_trace_bullet = client.visible, client.eye_position, client.log, client.trace_bullet
local entity_get_bounding_box, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_player_resource, entity_get_player_weapon, entity_get_prop, entity_is_dormant, entity_is_enemy, entity_is_alive = entity.get_bounding_box, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_player_resource, entity.get_player_weapon, entity.get_prop, entity.is_dormant, entity.is_enemy, entity.is_alive
local globals_curtime, globals_maxplayers, globals_tickcount = globals.curtime, globals.maxplayers, globals.tickcount
local math_max, math_min, math_sqrt = math.max, math.min, math.sqrt
local renderer_indicator, string_format, table_unpack = renderer.indicator, string.format, table.unpack or unpack
local ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible
local plist_get, entity_hitbox_position = plist.get, entity.hitbox_position
local ffi = require("ffi")
local vector = require("vector")
local weapons_data = require("gamesense/csgo_weapons")
local get_client_entity = vtable_bind("client_panorama.dll", "VClientEntityList003", (2+1), "void*(__thiscall*)(void*, int)")
local weapon_is_ready = vtable_thunk((83*2), "bool(__thiscall*)(void*)")
local get_weapon_inaccuracy = vtable_thunk((161*3), "float(__thiscall*)(void*)")

local rage_refs = {
	mindamage = ui_reference("RAGE", "Aimbot", "Minimum damage"),
	dormant_esp = ui_reference("VISUALS", "Player ESP", "Dormant"),
	override_mindamage = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}


local var_0_166 = require("require/abc/menu_setup")


local menu_cache = {}
local function var_0_165(name)
	if type(var_0_166) ~= 'table' then return false end
	if menu_cache[name] == nil then menu_cache[name] = var_0_166.ui and var_0_166.ui[name] end
	local it = menu_cache[name]
	if not it then return false end
	local ok, val = pcall(ui_get, it)
	if not ok then 
		menu_cache[name] = var_0_166.ui and var_0_166.ui[name]
		it = menu_cache[name]
		if not it then return false end
		ok, val = pcall(ui_get, it)
		if not ok then return false end
	end
	return val
end





local dormant_accuracy = (25*2)

local dormant_selected_hitboxes = { "Head", "Chest", "Stomach" }
local hitgroup_names = {
	"generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"?",
	"gear"
}

local hitgroup_to_hitbox = {
	"",
	"Head",
	"Chest",
	"Stomach",
	"Chest",
	"Chest",
	"Legs",
	"Legs",
	"Head",
	"",
	""
}

local default_target_points = {
	{ scale = (4+1), hitbox = "Stomach", vec = vector((0), (0), (20*2)) },
	{ scale = (3*2), hitbox = "Chest", vec = vector((0), (0), (25*2)) },
	{ scale = (2+1), hitbox = "Head", vec = vector((0), (0), (29*2)) },
	{ scale = (2*2), hitbox = "Legs", vec = vector((0), (0), (10*2)) }
}

local hitbox_index_lookup = {
	[(0)] = "Head",
	nil,
	"Stomach",
	nil,
	"Stomach",
	"Chest",
	"Chest",
	"Legs",
	"Legs"
}

local freeze_end_tick = (0)
local active_targets = {}
local dormant_memory = {}
local current_target_index = (1)
local fired_this_command = false
local stored_hitbox
local stored_point_label
local stored_target
local stored_accuracy
local registered_hit = false
local last_seen_hitboxes = {}

local draw_hitbox_indices = {
	(0), (2+1), (2*2), (4+1), (3*2), (6+1), (4*2), (3*3), (5*2), (10+1), (6*2), (5*3), (8*2), (16+1), (9*2)
}

local function var_0_26(from_pos, target_pos, radius)
	local _, yaw = from_pos:to(target_pos):angles()
	local side_yaw = math.rad(yaw + (45*2))
	local side_offset = vector(math.cos(side_yaw), math.sin(side_yaw), (0)) * radius

	return {
		{ text = "Middle", vec = target_pos },
		{ text = "Left", vec = target_pos + side_offset },
		{ text = "Right", vec = target_pos - side_offset }
	}
end

local function var_0_43(var_0_155, value)
	for i = (1), #var_0_155 do if var_0_155[i] == value then return true end end
	return false
end
local function var_0_82(var_0_155, value)
	for i = (1), #var_0_155 do local v = var_0_155[i] if type(v) == 'table' and v[(1)] == value then return i end end
end
local function var_0_156(var_0_155, player) return var_0_82(var_0_155, player) ~= nil end
local function var_0_203(var_0_155, player) local idx = var_0_82(var_0_155, player) if idx then table.remove(var_0_155, idx) end end

local function var_0_264(cmd, max_speed)
	local mv = math_sqrt(cmd.forwardmove*cmd.forwardmove + cmd.sidemove*cmd.sidemove)
	if max_speed<=(0) or mv<=(0) then return end
	if cmd.in_duck==(1) then max_speed = max_speed*(2.94117647) end
	if mv<=max_speed then return end
	local s = max_speed/mv; cmd.forwardmove = cmd.forwardmove*s; cmd.sidemove = cmd.sidemove*s
end

local function var_0_102()
	local e, r = {}, entity_get_player_resource()
	for i=(1),globals_maxplayers() do if entity_get_prop(r, "m_bConnected", i)==(1) and i~=entity_get_local_player() and entity_is_enemy(i) then e[#e+(1)]=i end end
	return e
end
local function var_0_104()
	local e, r = {}, entity_get_player_resource()
	for i=(1),globals_maxplayers() do if entity_get_prop(r, "m_bConnected", i)==(1) and not plist_get(i, "Add to whitelist") and entity_is_dormant(i) and entity_is_enemy(i) then e[#e+(1)]=i end end
	return e
end

local function var_0_271()
	for _,enemy in ipairs(var_0_102()) do
		local _,_,_,_,alpha = entity_get_bounding_box(enemy)
		if alpha<(1) then if not var_0_156(dormant_memory,enemy) then dormant_memory[#dormant_memory+(1)]={enemy,globals_tickcount()} end else var_0_203(dormant_memory,enemy) end
	end
end

local function var_0_30(target)
	local override_enabled = ui_get(rage_refs.override_mindamage[(1)]) and ui_get(rage_refs.override_mindamage[(1+1)])
	local slider = override_enabled and ui_get(rage_refs.override_mindamage[(2+1)]) or ui_get(rage_refs.mindamage)
	local th = entity.get_esp_data(target).health
	if slider>(50*2) then slider = slider - (50*2) + th end
	return slider
end

local function var_0_124(w,s) return (w.type=="sniperrifle" and s) and w.max_player_speed_alt or w.max_player_speed end

local function var_0_38(target, origin, sel)
	local pts = {}
	local duck = entity_get_prop(target, "m_flDuckAmount") or (0)
	for _,p in ipairs(default_target_points) do
		if #sel==(0) or var_0_43(sel,p.hitbox) then
			local off = p.vec
			if p.hitbox=="Head" then off = off - vector((0),(0),duck*(5*2)) elseif p.hitbox=="Chest" then off = off - vector((0),(0),duck*(2*2)) end
			pts[#pts+(1)]={vec=origin+off,scale=p.scale,hitbox=p.hitbox}
		end
	end
	for i=(1),(6+1) do
		local hb = hitbox_index_lookup[i-(1)]
		if hb and (#sel==(0) or var_0_43(sel,hb)) then
			local pos = entity_hitbox_position(target,i-(1))
			if pos then pts[#pts+(1)]={vec=vector(pos),scale=(2+1),hitbox=hb} end
		end
	end
	return pts
end

local function var_0_81(lp, wi, eye, tps, md)
	for _,p in ipairs(tps) do
		for _,off in ipairs(var_0_26(eye,p.vec,(2+1))) do
			local _,d = client_trace_bullet(lp, eye.x,eye.y,eye.z, off.vec.x,off.vec.y,off.vec.z, true)
			if p.hitbox=="Head" then d=d*(2*2) end
			if d>md then return off.vec,d,p.hitbox,off.text end
		end
	end
end

local function var_0_181(cmd)
	var_0_271()

	if not var_0_165('misc_dormantaimbot') or not var_0_165('misc_dormantaimbot_key') then
		return
	end

	local local_player = entity_get_local_player()
	if not local_player or not entity_is_alive(local_player) then
		return
	end

	local weapon = entity_get_player_weapon(local_player)
	if not weapon then
		return
	end

	local weapon_entity = get_client_entity(weapon)
	if not weapon_entity or not weapon_is_ready(weapon_entity) then
		return
	end

	local inaccuracy = get_weapon_inaccuracy(weapon_entity)
	if not inaccuracy then
		return
	end

	local eye_position = vector(client_eye_position())
	local sim_time = entity_get_prop(local_player, "m_flSimulationTime")
	local tick = globals_tickcount()
	local weapon_info = weapons_data(weapon)
	local is_scoped = entity_get_prop(local_player, "m_bIsScoped") == (1)
	local on_ground = bit.band(entity_get_prop(local_player, "m_fFlags"), bit.lshift((1), (0)))

	local dormant_enemies = var_0_104()
	if #dormant_enemies == (0) then
		active_targets = {}
		return
	end

	if tick % #dormant_enemies ~= (0) then
		current_target_index = current_target_index + (1)
	else
		current_target_index = (1)
	end

	local target = dormant_enemies[current_target_index]
	if not target then
		active_targets = {}
		return
	end

	if tick < freeze_end_tick then
		active_targets = {}
		return
	end

	if weapon_info.type == "grenade" or weapon_info.type == "knife" then
		active_targets = {}
		return
	end

	if cmd.in_jump == (1) and on_ground == (0) then
		active_targets = {}
		return
	end

	local selected_hitboxes = dormant_selected_hitboxes
	local target_origin = vector(entity_get_origin(target))
	local _, _, _, _, screen_alpha = entity_get_bounding_box(target)

	active_targets[target] = nil

	if screen_alpha < (1) then
		if not var_0_156(last_seen_hitboxes, target) then
			last_seen_hitboxes[#last_seen_hitboxes + (1)] = { target, tick }
		end
	else
		var_0_203(last_seen_hitboxes, target)
	end

	local target_points = var_0_38(target, target_origin, selected_hitboxes)
	local min_damage = var_0_30(target)

	local can_fire
	if weapon_info.is_revolver then
		can_fire = sim_time > entity_get_prop(weapon, "m_flNextPrimaryAttack")
	else
		can_fire = sim_time > math_max(
			entity_get_prop(local_player, "m_flNextAttack"),
			entity_get_prop(weapon, "m_flNextPrimaryAttack"),
			entity_get_prop(weapon, "m_flNextSecondaryAttack")
		)
	end

	if not can_fire then
		return
	end

	local chosen_point, chosen_damage, chosen_hitbox, chosen_label = var_0_81(
		local_player,
		weapon_info,
		eye_position,
		target_points,
		min_damage
	)

	if not chosen_point then
		return
	end

	if client_visible(chosen_point.x, chosen_point.y, chosen_point.z) then
		return
	end

	var_0_264(cmd, var_0_124(weapon_info, is_scoped) * (0.33))

	local pitch, yaw = eye_position:to(chosen_point):angles()

	if not is_scoped and weapon_info.type == "sniperrifle" and cmd.in_jump == (0) and on_ground == (1) then
		cmd.in_attack2 = (1)
	end

	active_targets[target] = true

	if inaccuracy < (0.01) then
		cmd.pitch = pitch
		cmd.yaw = yaw
		cmd.in_attack = (1)
		fired_this_command = true
		stored_hitbox = chosen_hitbox
		stored_point_label = chosen_label
		stored_target = target
		
		stored_accuracy = dormant_accuracy
	end
end

local function var_0_182(event)
	client.delay_call(0.03, function()
		local local_player = entity_get_local_player()
		if client.userid_to_entindex(event.userid) ~= local_player then
			return
		end

		if fired_this_command and not registered_hit then
			client.fire_event("dormant_miss", {
				userid = stored_target,
				aim_hitbox = stored_hitbox,
				aim_point = stored_point_label,
				accuracy = stored_accuracy
			})
		end

		registered_hit = false
		fired_this_command = false
		stored_hitbox = nil
		stored_point_label = nil
		stored_target = nil
		stored_accuracy = nil
	end)
end

local function var_0_179(event)
	local victim = client.userid_to_entindex(event.userid)
	local attacker = client.userid_to_entindex(event.attacker)

	if attacker == entity_get_local_player() and victim ~= nil and fired_this_command then
		registered_hit = true

		client.fire_event("dormant_hit", {
			userid = victim,
			attacker = attacker,
			health = event.health,
			armor = event.armor,
			weapon = event.weapon,
			dmg_health = event.dmg_health,
			dmg_armor = event.dmg_armor,
			hitgroup = event.hitgroup,
			accuracy = stored_accuracy or (0),
			aim_hitbox = stored_hitbox
		})
	end
end

local function var_0_180()
	local freeze_time = (cvar.mp_freezetime:get_float() + (1)) / globals.tickinterval()
	freeze_end_tick = globals_tickcount() + freeze_time
end





client.set_event_callback("setup_command", var_0_181)
client.set_event_callback("round_prestart", var_0_180)
client.set_event_callback("player_hurt", var_0_179)
client.set_event_callback("weapon_fire", var_0_182)

client.register_esp_flag("DA", (85*3), (85*3), (85*3), function(player)
	if var_0_165('misc_dormantaimbot') and entity_is_alive(entity_get_local_player()) then
		return active_targets[player]
	end
end)


client.set_event_callback("paint", function()
	if not entity_is_alive(entity_get_local_player()) then return end
	if var_0_165('misc_dormantaimbot') then
		local ic = {(85*3),(85*3),(85*3),(100*2)}
		for _,v in pairs(active_targets) do if v then ic={(13*11),(97*2),(7*3),(85*3)}; break end end
		if #var_0_104()==(0) then ic={(85*3),(0),(25*2),(85*3)} end
		renderer_indicator(ic[(1)],ic[(1+1)],ic[(2+1)],ic[(2*2)],"DA")
	end
end)]]
__bundle["require/features/misc/enhance_osaa"] = [[local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Roll' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local shot_ticks = {}
local damage_ticks = {}

client.set_event_callback("weapon_fire", function(e)
    local local_player = entity.get_local_player()
    if local_player and client.userid_to_entindex(e.userid) == local_player then
        shot_ticks[globals.tickcount()] = true
    end
end)

client.set_event_callback("player_hurt", function(e)
    local local_player = entity.get_local_player()
    if local_player and client.userid_to_entindex(e.userid) == local_player then
        damage_ticks[globals.tickcount()] = true
    end
end)

local function var_0_129()
    local var_0_173 = globals.tickcount()
    local last_shot_tick = nil
    for t = var_0_173-(10*2), var_0_173 do
        if shot_ticks[t] then
            last_shot_tick = t
            break
        end
    end
    if last_shot_tick then
        if var_0_173 - last_shot_tick <= (2*2) then
            return true
        end
        return true
    end
    return false
end



local function var_0_73(cmd)

    local var_0_129 = var_0_129()

    local function var_0_130(tbl, name)
        if type(tbl) ~= 'table' then return false end
        for _, v in ipairs(tbl) do if tostring(v) == tostring(name) then return true end end
        return false
    end

    local selections = ui.get(var_0_166.ui.fakelag_settings_enhance_onshot) or {}

    if var_0_166 and var_0_166.ui and var_0_129 then
            if var_0_130(selections, 'defensive') then
                cmd.force_defensive = true
            end

            if var_0_130(selections, 'roll') then
                ui.set(gs_item_refs[(2+1)][(1)], math.random((-(15*3)), (15*3)))
            end

            local side_switch = globals.tickcount() % (2*2) < (1+1)
            if var_0_130(selections, 'jitter') then
                ui.set(gs_item_refs[(1+1)][(1)], '180')
                ui.set(gs_item_refs[(1+1)][(1+1)], side_switch and (11*5) or (-(24*2)))
            end
    end
end

client.set_event_callback('setup_command', function(cmd)

    var_0_73(cmd)

end)]]
__bundle["require/features/misc/events"] = [[




local events = {}
local globals = globals


events.last_hit = {}
events.last_miss = {}


events.shots_queue = {}
events.shots_by_id = {}

function events.record_weapon_fire(ctx)
  
  if not ctx or not ctx.t then return end
  events.shots_queue[#events.shots_queue+(1)] = ctx
end

function events.record_aim_fire(id, ctx)
  if not id or not ctx then return end
  events.shots_by_id[id] = ctx
end

function events.record_aim_miss(id, victim, rec)
  if not victim then return end
  local var_0_173 = globals.curtime()
  local rec2 = rec or {}
  rec2.time = var_0_173
  events.last_miss[victim] = rec2
  if id then events.shots_by_id[id] = nil end
end

function events.record_player_hurt(id, victim, rec)
  if not victim then return end
  local var_0_173 = globals.curtime()
  local rec2 = rec or {}
  rec2.time = var_0_173
  events.last_hit[victim] = rec2
  if id then events.shots_by_id[id] = nil end
end


function events.link_recent_shot_to_victim(victim, max_age)
  max_age = max_age or (0.35)
  local var_0_173 = globals.curtime()
  for i=#events.shots_queue,(1),(-(1)) do
    local s = events.shots_queue[i]
    if s and s.target == victim and (var_0_173 - (s.t or var_0_173)) <= max_age and not s.linked then
      events.shots_queue[i].linked = true
      return events.shots_queue[i]
    end
  end
  return nil
end

return events
]]
__bundle["require/features/misc/exploit_fakelag"] = [[local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'rage', 'aimbot', 'double tap' },
    { 'aa', 'other', 'on shot anti-aim' },
    { 'AA', 'Fake lag', 'Enabled' },
    { 'AA', 'Fake lag', 'Amount' },
    { 'AA', 'Fake lag', 'Variance' },
    { 'AA', 'Fake lag', 'Limit' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end


local function var_0_79(cmd)

    local masterswitch = ui.get(var_0_166.ui.misc_exploit_fakelag)

    local doubletap = (ui.get(gs_item_refs[(1)][(1)]) and ui.get(gs_item_refs[(1)][(1+1)]))
    local onshot = (ui.get(gs_item_refs[(1+1)][(1)]) and ui.get(gs_item_refs[(1+1)][(1+1)]))

    local exploit = masterswitch and (doubletap or onshot)

    if exploit then
        ui.set(gs_item_refs[(2+1)][(1)], false)
    end

end

client.set_event_callback('setup_command', function(cmd)

    var_0_79(cmd)

end)]]
__bundle["require/features/misc/fakelag"] = [[local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Fake lag', 'Enabled' },
    { 'AA', 'Fake lag', 'Amount' },
    { 'AA', 'Fake lag', 'Variance' },
    { 'AA', 'Fake lag', 'Limit' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local _ms_ok, _ms = pcall(require, "require/abc/menu_setup")

client.set_event_callback("setup_command", function()
    if not (_ms_ok and _ms and _ms.ui) then return end

    local ok_enabled, var_0_71 = pcall(ui.get, _ms.ui.fakelag_fakelag)
    if not ok_enabled or not var_0_71 then return end

    local ok_type, typ = pcall(ui.get, _ms.ui.fakelag_fakelag_type)
    if not ok_type then return end

    
    if tostring(typ) == "gamesense" then
        ui.set(gs_item_refs[(1)][(1)], true)
        local ok_amt, amt = pcall(ui.get, _ms.ui.fakelag_fakelag_amount)
        local ok_var, var = pcall(ui.get, _ms.ui.fakelag_fakelag_variance)
        local ok_lim, lim = pcall(ui.get, _ms.ui.fakelag_fakelag_limit)

        if ok_amt and amt and gs_item_refs[(1+1)] and gs_item_refs[(1+1)][(1)] then
            pcall(ui.set, gs_item_refs[(1+1)][(1)], amt)
        end
        if ok_var and var and gs_item_refs[(2+1)] and gs_item_refs[(2+1)][(1)] then
            pcall(ui.set, gs_item_refs[(2+1)][(1)], var)
        end
        if ok_lim and lim and gs_item_refs[(2*2)] and gs_item_refs[(2*2)][(1)] then
            pcall(ui.set, gs_item_refs[(2*2)][(1)], lim)
        end

        return
    end

    
    if tostring(typ) == "celestial" then
        ui.set(gs_item_refs[(1)][(1)], true)
        local ok_t2, t2 = pcall(ui.get, _ms.ui.fakelag_fakelag_type2)
        if not ok_t2 then return end

        
        if tostring(t2) == "jitter" then
            if gs_item_refs[(1+1)] and gs_item_refs[(1+1)][(1)] then
                pcall(ui.set, gs_item_refs[(1+1)][(1)], "dynamic")
            end
            
            local tick = globals.tickcount() or (0)
            local var_val = tick % (100+1) 
            local lim_val = (1) + (tick % (5*3)) 
            if gs_item_refs[(2+1)] and gs_item_refs[(2+1)][(1)] then pcall(ui.set, gs_item_refs[(2+1)][(1)], var_val) end
            if gs_item_refs[(2*2)] and gs_item_refs[(2*2)][(1)] then pcall(ui.set, gs_item_refs[(2*2)][(1)], lim_val) end

            return
        end

        
        if tostring(t2) == "max" then
            if gs_item_refs[(1+1)] and gs_item_refs[(1+1)][(1)] then
                pcall(ui.set, gs_item_refs[(1+1)][(1)], "dynamic")
            end
            if gs_item_refs[(2+1)] and gs_item_refs[(2+1)][(1)] then
                pcall(ui.set, gs_item_refs[(2+1)][(1)], (0))
            end
            local lim = (7*2) + ((globals.tickcount() or (0)) % (1+1))
            if gs_item_refs[(2*2)] and gs_item_refs[(2*2)][(1)] then pcall(ui.set, gs_item_refs[(2*2)][(1)], lim) end

            return
        end
    end
end)

]]
__bundle["require/features/misc/freestand_helper"] = [[local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding' },
    { 'AA', 'Anti-aimbot angles', 'Pitch' },
    { 'AA', 'Anti-aimbot angles', 'Yaw base' },
    { 'AA', 'Anti-aimbot angles', 'Yaw' },
    { 'AA', 'Anti-aimbot angles', 'Yaw jitter' },
    { 'AA', 'Anti-aimbot angles', 'Body yaw' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")

local function var_0_87(cmd)
    if not (var_0_166 and var_0_166.ui and var_0_166.ui.aa_gskey_freestand) then return end
    if not ui.get(var_0_166.ui.aa_gskey_freestand) then return end

    local function var_0_130(tbl, name)
        if type(tbl) ~= 'table' then return false end
        for _, v in ipairs(tbl) do if tostring(v) == tostring(name) then return true end end
        return false
    end

    local selections = ui.get(var_0_166.ui.fakelag_settings_freestanding) or {}


    localplayer = entity.get_local_player()
    local vx, vy, vz = entity.get_prop(localplayer, 'm_vecVelocity')
    if vx and vy and vz then
        velvel =  math.sqrt(vx * vx + vy * vy + vz * vz)
    end
    


    if var_0_130(selections, 'static') then
        ui.set(gs_item_refs[(1)][(1)], true)
        ui.set(gs_item_refs[(4+1)][(1)], '180')
        ui.set(gs_item_refs[(4+1)][(1+1)], (3*2))
        ui.set(gs_item_refs[(3*2)][(1)], 'off')
        ui.set(gs_item_refs[(6+1)][(1)], 'off')
    end

    if var_0_130(selections, 'zero pitch') and velvel > (4+1) then
        ui.set(gs_item_refs[(2+1)][(1)], 'Off')
    end

    if var_0_130(selections, 'defensive') then
        cmd.force_defensive = true
    end

    local side_switch = globals.tickcount() % (2*2) < (1+1)
    if var_0_130(selections, 'side flip') and velvel > (4+1) then
        ui.set(gs_item_refs[(4+1)][(1)], '180')
        ui.set(gs_item_refs[(4+1)][(1+1)], side_switch and (-(45*2)) or (45*2))
    end

    local side_switch = globals.tickcount() % (3*2) < (1+1)
    if var_0_130(selections, 'pitch flip') and velvel > (4+1) then
        ui.set(gs_item_refs[(2+1)][(1)], 'custom')
        ui.set(gs_item_refs[(2+1)][(1+1)], side_switch and (-(88+1)) or (88+1))
    end

end

client.set_event_callback('setup_command', function(cmd)

    var_0_87(cmd)

end)]]
__bundle["require/features/misc/history"] = [[
local history = {}

local RING_SIZE = (10*2)
local rings = {}

local function var_0_74(player)
  if not rings[player] then rings[player] = { buf = {} } end
  return rings[player]
end

function history.push(player, snapshot)
  if not player or not snapshot then return end
  local ring = var_0_74(player)
  ring.buf[#ring.buf+(1)] = snapshot
  if #ring.buf > RING_SIZE then table.remove(ring.buf, (1)) end
end

function history.get_last_n(player, n)
  n = n or RING_SIZE
  local ring = rings[player]
  if not ring or #ring.buf == (0) then return {} end
  local res = {}
  local total = #ring.buf
  local start = math.max((1), total - n + (1))
  for i = start, total do res[#res+(1)] = ring.buf[i] end
  return res
end

function history.clear(player)
  if not player then rings = {} return end
  rings[player] = nil
end

return history
]]
__bundle["require/features/misc/hotkeys"] = [[local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Freestanding body yaw' },
    { 'AA', 'Anti-aimbot angles', 'Edge yaw' },
    { 'AA', 'Anti-aimbot angles', 'Freestanding' },
    { 'AA', 'Other', 'Slow motion' },
    { 'AA', 'Other', 'Leg movement' },
    { 'AA', 'Other', 'On shot anti-aim' },
    { 'AA', 'Other', 'Fake peek' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")

local function var_0_4()

    if ui.get(var_0_166.ui.aa_gskey_freestand) then
        ui.set(gs_item_refs[(2+1)][(1)], true)
        ui.set(gs_item_refs[(2+1)][(1+1)], 'Always on')
    else
        ui.set(gs_item_refs[(2+1)][(1)], false)
        ui.set(gs_item_refs[(2+1)][(1+1)], 'On hotkey')
    end

    if ui.get(var_0_166.ui.aa_gskey_slowmotion) then
        ui.set(gs_item_refs[(2*2)][(1)], true)
    else
        ui.set(gs_item_refs[(2*2)][(1)], false)
    end

    if var_0_166 and var_0_166.ui and ui.get(var_0_166.ui.aa_gskey_edgeyaw) then
        ui.set(gs_item_refs[(1+1)][(1)], true)
    else
        ui.set(gs_item_refs[(1+1)][(1)], false)
    end

    if var_0_166 and var_0_166.ui and ui.get(var_0_166.ui.aa_gskey_onshot) then
        ui.set(gs_item_refs[(3*2)][(1+1)], 'Always on')
    else
        ui.set(gs_item_refs[(3*2)][(1+1)], 'On hotkey')
    end

end

client.set_event_callback('setup_command', function()

    var_0_4()

end)]]
__bundle["require/features/misc/ragebot"] = [[]]
__bundle["require/features/misc/resolver"] = [[














local ok_collect, collect = pcall(require, "require/features/misc/collect")
local ok_history, history = pcall(require, "require/features/misc/history")
local ok_state, state = pcall(require, "require/features/misc/state")
local ok_events, events = pcall(require, "require/features/misc/events")
local ok_vector, vec = pcall(require, "require/help/vector")
local vector = ok_vector and vec or nil















if not M then M = {} end
M.players = M.players or {}


local function var_0_263()
	pcall(function()
		if not ok_collect or type(collect) ~= "table" or not collect.get_enemies_snapshot then return end

		local ok, snaps = pcall(function() return collect.get_enemies_snapshot() end)
		if not ok or type(snaps) ~= "table" then return end

		M.players = M.players or {}

		for ent, var_0_251 in pairs(snaps) do
			M.players[ent] = M.players[ent] or {}
			M.players[ent].snapshot = var_0_251

            
            
            
			M.players[ent].simtime = var_0_251.simtime
			M.players[ent].simTicks = var_0_251.simTicks
			M.players[ent].lowerBodyYaw = var_0_251.lowerBodyYaw
			M.players[ent].speed2d = var_0_251.speed2d
			M.players[ent].velocity3d = var_0_251.velocity3d
			M.players[ent].is_alive = var_0_251.is_alive
			M.players[ent].is_dormant = var_0_251.is_dormant
			M.players[ent].feetYaw = var_0_251.feetYaw
			M.players[ent].goalFeetYaw = var_0_251.goalFeetYaw
			M.players[ent].moveSpeedAnim = var_0_251.moveSpeedAnim
		end

		for ent, var_0_251 in pairs(snaps) do
			local name = var_0_251.name or "?"
			local sim = var_0_251.simtime or (0)
			local spd = var_0_251.speed2d or (0)
			local lby = var_0_251.lowerBodyYaw or "nil"
			local move = var_0_251.moveSpeedAnim or (0)
			local feet = var_0_251.feetYaw or "nil"
			local goal = var_0_251.goalFeetYaw or "nil"
			local duck_amt = var_0_251.animstate_full.m_fDuckAmount

		end
	end)
end



local function var_0_172(angle)
    while angle > (90*2) do
        angle = angle - (180*2)
    end
    while angle < (-(90*2)) do
        angle = angle + (180*2)
    end
    return angle
end


local function var_0_28(start_pos, end_pos)
    local delta = end_pos - start_pos
    local angle = math.atan(delta.y / delta.x)
    angle = var_0_172(angle * (90*2) / math.pi)

    if delta.x >= (0) then
        angle = var_0_172(angle + (90*2))
    end

    return angle
end



local HISTORY_SIZE = (50*2)
local player_history = {}
_G.player_history = player_history

local function var_0_234(seconds)
    return math.floor((0.5) + seconds / globals.tickinterval())
end

local function var_0_199(local_player)
    local enemy_players = entity.get_players(true)

	if #enemy_players == (0) then
		
		player_history = {}
		_G.player_history = player_history
		return nil
	end


	for i, player in ipairs(enemy_players) do
		if entity.is_alive(player) and not entity.is_dormant(player) then

			local sim_tick = (0)
			local esp_flags = entity.get_esp_data(player).flags or (0)

			if bit.band(esp_flags, bit.lshift((1), (16+1))) ~= (0) then
				sim_tick = var_0_234(entity.get_prop(player, "m_flSimulationTime")) - (7*2)
			else
				sim_tick = var_0_234(entity.get_prop(player, "m_flSimulationTime"))
			end

			
			local hist = player_history[player] or {}
			local newest = hist[(1)]

			if newest == nil or (sim_tick - (newest.simtime or (-(333*3)))) >= (1) then

				local local_origin = vector(entity.get_prop(local_player, "m_vecOrigin"))
				local eye_angles = vector(entity.get_prop(player, "m_angEyeAngles"))
				local player_origin = vector(entity.get_prop(player, "m_vecOrigin"))
				local angle_diff = math.floor(var_0_172(eye_angles.y - var_0_28(local_origin, player_origin)))
				

				local var_0_251 = {
					id = player or nil,
					origin = vector(entity.get_origin(player)) or vector(nil,nil,nil),
					pitch = eye_angles.x or nil,
					yaw = angle_diff or nil,
					yaw_backwards = backwards_angle or nil,
					simtime = sim_tick or nil,
					stance = stance or nil,
					esp_flags = entity.get_esp_data(player).flags or (0),
					last_shot_time = last_shot_time or nil
				}

				table.insert(hist, (1), var_0_251)
				while #hist > HISTORY_SIZE do
					table.remove(hist)
				end

				player_history[player] = hist
			end
		end
	end
end















client.set_event_callback('net_update_end', function()
    pcall(function()

        
        

        local local_player = entity.get_local_player()
        if not entity.is_alive(local_player) then
            return
        end
        var_0_199(local_player)


        local tick = (globals and globals.tickcount and globals.tickcount()) or (globals and globals.realtime and globals.realtime()) or os.time()
        

    end)
end)




client.set_event_callback('weapon_fire', function(e)
    pcall(function()







        local shooter = (e and e.userid) and (client.userid_to_entindex and client.userid_to_entindex(e.userid)) or (e and (e.attacker or e.userid)) or "?"
        local w = (e and (e.weapon or e.weapon_name or e.weaponid)) or "?"
        
    end)
    if EVENTS and EVENTS.record_weapon_fire then pcall(EVENTS.record_weapon_fire, e) end
end)




client.set_event_callback('aim_fire', function(e)
    pcall(function()








        local id = e and e.id or "?"
        local tgt = e and e.target or "?"
        
    end)
    if EVENTS and EVENTS.record_aim_fire then pcall(EVENTS.record_aim_fire, e) end
end)




client.set_event_callback('aim_hit', function(e)
    pcall(function()








        local id = e and e.id or "?"
        local tgt = e and e.target or "?"
        local dmg = e and e.damage or "?"
        
    end)
    if EVENTS and EVENTS.record_aim_hit then pcall(EVENTS.record_aim_hit, e) end
end)




client.set_event_callback('aim_miss', function(e)
    pcall(function()






        local id = e and e.id or "?"
        local reason = e and e.reason or "?"
        
    end)
    if EVENTS and EVENTS.record_aim_miss then pcall(EVENTS.record_aim_miss, e) end
end)




client.set_event_callback('player_hurt', function(e)
    pcall(function()






        local attacker = (e and e.attacker) or (e and e.userid) or "?"
        local victim = (e and e.userid) or (e and e.userid) or "?"
        local dmg = e and e.damage or "?"
        
    end)
    if EVENTS and EVENTS.record_player_hurt then pcall(EVENTS.record_player_hurt, e) end
end)




client.set_event_callback('bullet_impact', function(e)
    pcall(function()




        local shooter = (e and e.userid) and (client.userid_to_entindex and client.userid_to_entindex(e.userid)) or "?"
        local x,y,z = e and e.x or "?", e and e.y or "?", e and e.z or "?"
        
    end)
    if EVENTS and EVENTS.on_bullet_impact then pcall(EVENTS.on_bullet_impact, e) end
    if EVENTS and EVENTS.record_bullet_impact then pcall(EVENTS.record_bullet_impact, e) end
end)




client.set_event_callback('paint', function()
    pcall(function()

        

    end)
    if EVENTS and EVENTS.var_0_175 then pcall(EVENTS.var_0_175) end
end)




client.set_event_callback("round_start", function(e)
    pcall(function() print("[resolver] round_start") end)



    M.players = {}
    if EVENTS and EVENTS.on_round_start then pcall(EVENTS.on_round_start, e) end
end)




client.set_event_callback("shutdown", function()
    if client and client.unset_event_callback then



    end
end)
]]
__bundle["require/features/misc/resolver_dispatcher"] = [[local M = {}


local modules = {}


_G.player_resolver_state = _G.player_resolver_state or {}

local function var_0_230(label)
    if not label or type(label) ~= "string" then return nil end
    
    local s = label:lower()
    s = s:gsub("%+", "plus")
    s = s:gsub("%-% ", "minus_") 
    s = s:gsub("%-%", "minus")
    s = s:gsub("%s+", "_")
    s = s:gsub("[^%w_]", "")
    return s
end

local function var_0_206(label)
    local key
    
    if label == "?" then
        key = "default"
    else
        key = var_0_230(label)
    end
    if not key or key == "" then return nil end
    if modules[key] ~= nil then return modules[key] end
    local name = "require/features/misc/res_" .. key
    local ok, mod = pcall(require, name)
    if ok and type(mod) == "table" then
        modules[key] = mod
        return mod
    end
    modules[key] = false
    return nil
end



function M.process_entity(ent, label, features)
    local ok, _ = pcall(function()
        if not ent or ent == (0) then return end
        if not label or label == "?" then return end

        local mod = var_0_206(label)
        if not mod then return end

        
        local state = _G.player_resolver_state[ent]
        if not state then
            state = {}
            _G.player_resolver_state[ent] = state
        end

        if type(mod.run) == "function" then
            
            pcall(function() mod.run(ent, features or {}, state, label) end)
        elseif type(mod.process) == "function" then
            pcall(function() mod.process(ent, features or {}, state, label) end)
        end
    end)
    return ok
end


M._modules = modules
M._sanitize_label = var_0_230

return M
]]
__bundle["require/features/misc/res_default"] = [[local M = {}

local function var_0_227(ent)
    pcall(function()
        if plist and type(plist.set) == "function" then
            
            plist.set(ent, "Force body yaw", false)
            plist.set(ent, "Force body yaw value", (0))
            plist.set(ent, "Force pitch", false)
            plist.set(ent, "Force pitch value", (0))
        end
    end)
end

function M.run(ent, features, state, label)
    
    if label ~= "?" and label ~= "DEFAULT" and label ~= "default" then return end

    state.clears = (state.clears or (0)) + (1)
    state.last_seen = (globals and globals.curtime and globals.curtime()) or os.time()

    
    var_0_227(ent)

    pcall(function()
        print(string.format("[res_default] ent=%d cleared_forces label=%s count=%d", ent, tostring(label), state.clears))
    end)
end

return M
]]
__bundle["require/features/misc/res_static"] = [[local M = {}
local ok_ffi, ffi = pcall(require, "ffi")
local ok_bit, bit = pcall(require, "bit")


local get_entity_ptr
local function var_0_135()
    if not ok_ffi or not client or not client.create_interface then return end
    local status, res = pcall(function()
        local pointer_type = ffi.typeof("void***")
        local entity_list_ptr = client.create_interface("client.dll", "VClientEntityList003")
        if not entity_list_ptr then return nil end
        local entity_list = ffi.cast(pointer_type, entity_list_ptr)
        local get_client_entity = ffi.cast("void*(__thiscall*)(void*, int)", entity_list[(0)][(2+1)])
        return function(entindex)
            if not entindex or entindex == (0) then return nil end
            local ptr = get_client_entity(entity_list, entindex)
            if ptr == nil then return nil end
            return ptr
        end
    end)
    if status and type(res) == "function" then
        get_entity_ptr = res
    else
        get_entity_ptr = nil
    end
end
var_0_135()

local function var_0_119(ent)
    
    local ok, vx, vy = pcall(function()
        local x,y,z = entity.get_prop(ent, "m_vecVelocity")
        return x or (0), y or (0)
    end)
    if ok and vx and vy then
        return math.sqrt((vx or (0))*(vx or (0)) + (vy or (0))*(vy or (0)))
    end
    return (0)
end

local function var_0_76(ent)
    
    if not ok_ffi or not get_entity_ptr then return nil end
    local ok_read, result = pcall(function()
        ffi.cdef[[
        struct c_animstate {
            char pad0[3];
            char m_bForceWeaponUpdate;
            char pad1[91];
            void* m_pBaseEntity;
            void* m_pActiveWeapon;
            void* m_pLastActiveWeapon;
            float m_flLastClientSideAnimationUpdateTime;
            int m_iLastClientSideAnimationUpdateFramecount;
            float m_flAnimUpdateDelta;
            float m_flEyeYaw;
            float m_flPitch;
            float m_flGoalFeetYaw;
            float m_flCurrentFeetYaw;
            float m_flCurrentTorsoYaw;
            float m_flUnknownVelocityLean;
            float m_flLeanAmount;
            char pad2[4];
            float m_flFeetCycle;
            float m_flFeetYawRate;
            char pad3[4];
            float m_fDuckAmount;
            float m_fLandingDuckAdditiveSomething;
            char pad4[4];
            float m_vOriginX;
            float m_vOriginY;
            float m_vOriginZ;
            float m_vLastOriginX;
            float m_vLastOriginY;
            float m_vLastOriginZ;
            float m_vVelocityX;
            float m_vVelocityY;
            char pad5[4];
            float m_flUnknownFloat1;
            char pad6[8];
            float m_flUnknownFloat2;
            float m_flUnknownFloat3;
            float m_flUnknown;
            float m_flSpeed2D;
            float m_flUpVelocity;
            float m_flSpeedNormalized;
            float m_flFeetSpeedForwardsOrSideWays;
            float m_flFeetSpeedUnknownForwardOrSideways;
            float m_flTimeSinceStartedMoving;
            float m_flTimeSinceStoppedMoving;
            bool m_bOnGround;
            bool m_bInHitGroundAnimation;
            char pad7[2];
            float m_flTimeSinceInAir;
            float m_flLastOriginZ;
            float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
            float m_flStopToFullRunningFraction;
            float m_flMagicFraction;
            char pad8[60];
            float m_flWorldForce;
            char pad9[462];
            float m_flMaxYaw;
        };
        ] ]
        local ent_ptr = get_entity_ptr(ent)
        if not ent_ptr then return nil end
        local animstate_ptr = ffi.cast("struct c_animstate**", ffi.cast("uintptr_t", ent_ptr) + 0x9960)
        if animstate_ptr == nil or animstate_ptr == ffi.NULL then return nil end
        local anim = animstate_ptr[(0)]
        if anim == nil or anim == ffi.NULL then return nil end

        local duck_amount = tonumber(anim.m_fDuckAmount) or (0)
        local speed2d_norm = tonumber(anim.m_flFeetSpeedForwardsOrSideWays) or (0)
        local stop_to_full = tonumber(anim.m_flStopToFullRunningFraction) or (0)
        local max_yaw = tonumber(anim.m_flMaxYaw) or (0)

        local yaw_modifier = (((-0.3) * stop_to_full) - (0.2)) * math.max((0), math.min(speed2d_norm, (1))) + (1.0)
        if duck_amount > (0) then
            yaw_modifier = yaw_modifier + (duck_amount * (0.5)) * ((0.5) - yaw_modifier)
        end

        local raw_delta = max_yaw * yaw_modifier
        local velocity = var_0_119(ent) or (0)
        local velocity_clamped = math.min(math.max(velocity, (0)), (130*2))
        local move_scale = (1.0) - (velocity_clamped / (130*2))
        move_scale = (0.35) + (move_scale * (0.65))
        local delta = raw_delta * move_scale
        if velocity >= (125*2) then
            delta = math.min(delta, (14*2))
        end
        local flags = nil
        if ok_bit and entity and entity.get_prop then
            flags = entity.get_prop(ent, "m_fFlags") or (0)
        end
        local on_ground = true
        if flags then on_ground = bit.band(flags, (1)) == (1) end
        if not on_ground then delta = delta * (0.55) end
        if duck_amount > (0.9) then delta = delta * (0.9) end
        delta = math.max((0), math.min(delta, (30*2)))
        return delta
    end)
    if ok_read then return result end
    return nil
end

local function var_0_227(ent)
    pcall(function()
        if plist and type(plist.set) == "function" then
            plist.set(ent, "Force body yaw", false)
            plist.set(ent, "Force body yaw value", (0))
        end
    end)
end

local function var_0_174()
    local ok, t = pcall(function() return (globals and globals.curtime and globals.curtime()) or os.time() end)
    return ok and t or os.time()
end

local function var_0_172(angle)
    if not angle or type(angle) ~= "number" then return (0) end
    while angle > (90*2) do angle = angle - (180*2) end
    while angle < (-(90*2)) do angle = angle + (180*2) end
    return angle
end

local function var_0_221(n)
    return math.floor((n or (0)) + (0.5))
end

function M.run(ent, features, state, label)
    
    state.count = (state.count or (0)) + (1)
    state.last_seen = var_0_174()
    if state.last_label and state.last_label ~= label then state.count = (1) end
    state.last_label = label

    
    if not label or label ~= "STATIC" then return end

    
    local required_count = (2+1)
    if state.count < required_count then return end

    
    if features and features.shot_age and tonumber(features.shot_age) and features.shot_age <= (0.25) then
        return
    end

    
    local avg_speed = tonumber((features and features.avg_speed) or (0)) or (0)
    if features and features.movement and features.movement == true then return end
    if avg_speed >= (1.2) then return end

    
    local max_mag_low = (29*2)
    local max_mag_high = (14*2)
    local speed_cap = (125*2)
    local t = math.min(math.max(avg_speed / speed_cap, (0)), (1))
    local max_mag = max_mag_low + (max_mag_high - max_mag_low) * t

    
    local ok_est, est = pcall(function() return var_0_76(ent) end)
    if ok_est and est and type(est) == "number" then
        max_mag = math.min(max_mag, est)
    end

    
    local on_ground = true
    pcall(function()
        if ok_bit and entity and entity.get_prop then
            local flags = entity.get_prop(ent, "m_fFlags") or (0)
            on_ground = bit.band(flags, (1)) == (1)
        end
    end)
    if not on_ground then max_mag = max_mag * (0.55) end

    
    local forced_val = (0)

    
    local last_yaw = (features and features.last_yaw)
    local ref_yaw = features and (features.goal_feet_yaw or features.feet_yaw)
    local desync = nil
    if last_yaw and ref_yaw then
        desync = var_0_172(last_yaw - ref_yaw)
    end

    
    if not desync then
        forced_val = (0)
    else
        local absd = math.abs(desync)
        
        if absd <= (5*2) then
            forced_val = (0)
        else
            
            if ok_est and est and type(est) == "number" and est >= (4*2) then
                local mag = math.min(math.floor(max_mag + (0.5)), math.floor(est + (0.5)))
                local desired = math.min(absd, mag)
                
                if desired >= (4*2) then
                    forced_val = (desync >= (0)) and desired or -desired
                else
                    forced_val = (0)
                end
            else
                
                forced_val = (0)
            end
        end
    end

    
    forced_val = var_0_221(forced_val)
    if forced_val > (30*2) then forced_val = (30*2) end
    if forced_val < (-(30*2)) then forced_val = (-(30*2)) end

    
    pcall(function()
        if plist and type(plist.set) == "function" then
            plist.set(ent, "Force body yaw", true)
            plist.set(ent, "Force body yaw value", forced_val)
            state.forced = true
            state.forced_value = forced_val
            state.cooldown = var_0_174() + (0.5)

            if client and type(client.delay_call) == "function" then
                client.delay_call(0.6, function()
                    pcall(function()
                        local t = var_0_174()
                        if not state.cooldown or t > state.cooldown then
                            var_0_227(ent)
                            state.forced = nil
                            state.forced_value = nil
                        end
                    end)
                end)
            end
        end
    end)
end

return M
]]
__bundle["require/features/misc/roll"] = [[local ok_menu, var_0_166 = pcall(require, "require/abc/menu_setup")

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Anti-aimbot angles', 'Roll' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local function var_0_220(cmd)

    local amount = ui.get(var_0_166.ui.fakelag_settings_roll) or (0)
    local side = ui.get(var_0_166.ui.fakelag_settings_side) or (1)
    local me = entity.get_local_player()
    local mevel = me and entity.get_prop(me, 'm_vecVelocity') or (0)

    if mevel > (2+1) then
        ui.set(gs_item_refs[(1)][(1)], (0))
        return
    end

    if side == (2+1) then
        ui.set(gs_item_refs[(1)][(1)], -amount)
    elseif side == (1+1) then
        local cycle = (globals.tickcount() % (10*2)) < (5*2)
        ui.set(gs_item_refs[(1)][(1)], cycle and amount or -amount)
    elseif side == (1) then
        ui.set(gs_item_refs[(1)][(1)], amount)
    end

end

client.set_event_callback('setup_command', function(cmd)

    var_0_220(cmd)

end)]]
__bundle["require/features/misc/state"] = [[
local collect = require("require.features.misc.collect")
local history = require("require.features.misc.history")

local state = {}

local function var_0_172(a)
  while a > (90*2) do a = a - (180*2) end
  while a < (-(90*2)) do a = a + (180*2) end
  return a
end

local function var_0_185(tbl, p)
  if #tbl == (0) then return (0) end
  table.sort(tbl)
  local k = math.floor((p/(50*2)) * (#tbl - (1)) + (1))
  if k < (1) then k = (1) end
  if k > #tbl then k = #tbl end
  return tbl[k]
end

local function var_0_39(player, n)
  local frames = history.get_last_n(player, n or (10*2))
  local m = #frames
  if m < (2*2) then return nil end
  local deltas = {}
  local absvals = {}
  local last = nil
  for i=(1),m do
    local f = frames[i]
    local yaw = f and (f.eyeYaw or f.yaw) or (0)
    if last ~= nil then
      local d = var_0_172(yaw - last)
      deltas[#deltas+(1)] = d
      absvals[#absvals+(1)] = math.abs(d)
    end
    last = yaw
  end
  if #deltas == (0) then return nil end
  local sum = (0)
  for i=(1),#deltas do sum = sum + deltas[i] end
  local mean = sum / #deltas
  local var = (0)
  for i=(1),#deltas do var = var + (deltas[i]-mean)*(deltas[i]-mean) end
  var = var / #deltas
  local std = math.sqrt(var)
  local sign_changes = (0)
  for i=(1+1),#deltas do if (deltas[i]*deltas[i-(1)]) < (0) then sign_changes = sign_changes + (1) end end
  local sc_rate = (#deltas > (1)) and (sign_changes / (#deltas - (1))) or (0)
  local p75 = var_0_185(absvals, (25*3))
  local p50 = var_0_185(absvals, (25*2))
  return {
    n = #deltas,
    deltas = deltas,
    mean = mean,
    stddev = std,
    sign_change_rate = sc_rate,
    p50 = p50,
    p75 = p75,
  }
end

function state.get_features(player)
  return var_0_39(player, (10*2))
end


function state.classify(player, feat)
  if not feat then return nil, (0) end
  local p75 = feat.p75 or (0)
  local sd = feat.stddev or (0)
  if p75 >= (15*3) and sd >= (15*2) then return "SPIN", (0.9) end
  if feat.sign_change_rate and feat.sign_change_rate >= (0.3) then
    if p75 >= (6*2) then return "JITTER", (0.85) end
    return "JITTER-", (0.75)
  end
  if p75 <= (1+1) and sd < (1.2) then return "STATIC", (0.9) end
  return nil, (0)
end

return state
]]
__bundle["require/features/misc/walkbot"] = [[local callbacks = require("require/abc/callbacks")
local var_0_166 = require("require/abc/menu_setup")

local path = nil
local path_index = (1)
local paused_until = (0)
local reached_dist = (20*2)
local max_attempts = (15*2)
local walk_speed = (225*2)
local max_search_nodes = (100*2)
local angle_steps = (4*2)
local radii = {(75*2), (150*2)}
local current_target = nil
local target_pos = nil
local last_target_pos = nil
local target_recompute_time = (0)
local target_recompute_interval = (350*2)
local target_pool_size = (2+1)

local node_attempts = {}
local max_attempts_per_node = (2+1)
local max_retries_before_reroute = (2*2)
local retry_count = (0)
local last_pos = nil
local last_pos_time = (0)
local pos_check_interval = (250*2)
local stuck_threshold_time = (750*2)
local stuck_move_threshold = (15*2)
local blocked_nodes = {}
local debug_walk = false

local coord_print_interval = (250*2) 
local last_coord_print_time = (0)

local predefined_sites = {
    { name = "A", x = (-445.0), y = (-1997.7), z = (-180.0) },
    { name = "B", x = (-2032.4), y = (259.8), z = (-160.0) },
    { name = "Mid", x = (-350.3), y = (-617.1), z = (-269.2) },
}

local function var_0_270(item)
    if not item then return false end
    local ok, val = pcall(ui.get, item)
    if not ok then return false end
    return val
end

local function var_0_8(a)
    while a > (90*2) do a = a - (180*2) end
    while a < (-(90*2)) do a = a + (180*2) end
    return a
end

local function var_0_279(ax, ay, az, bx, by, bz)
    local dx, dy, dz = ax-bx, ay-by, az-bz
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local function var_0_226(lp, sx, sy, sz, tx, ty, tz)
    local ok, frac, ent = pcall(function()
        return client.trace_line(lp, sx, sy, sz, tx, ty, tz)
    end)
    if not ok then return nil end
    return frac, ent
end

local function var_0_252(lp, x, y, z)
    local fromz = z + (500*2)
    local toz = z - (500*2)
    local frac = var_0_226(lp, x, y, fromz, x, y, toz)
    if not frac then return z end
    if type(frac) ~= 'number' then return z end
    local hitz = fromz + (toz - fromz) * frac
    return hitz
end

local function var_0_32(lp, sx, sy, sz, tx, ty, tz)
    local frac = var_0_226(lp, sx, sy, sz, tx, ty, tz)
    if not frac then return false end
    if frac >= (1) then return true end
    return false
end

local function var_0_171(x, y)
    return tostring(math.floor(x/(25*2)))..":"..tostring(math.floor(y/(25*2)))
end

local function var_0_133(x, y)
    local k = var_0_171(x, y)
    node_attempts[k] = (node_attempts[k] or (0)) + (1)
    if node_attempts[k] >= max_attempts_per_node then
        blocked_nodes[k] = true
    end
    return node_attempts[k]
end

local function var_0_37(x, y)
    local k = var_0_171(x, y)
    node_attempts[k] = nil
end

local function var_0_186(lp)
    local ox, oy, oz = entity.get_origin(lp)
    if not ox then return nil end
    for i=(1),max_attempts do
        local ang = math.random()*math.pi*(1+1)
        local dist = (100*2) + math.random()*(400*2)
        local tx = ox + math.cos(ang)*dist
        local ty = oy + math.sin(ang)*dist
        local tz = oz
            local frac = var_0_226(lp, ox, oy, oz + (8*2), tx, ty, tz + (8*2))
        if frac and frac >= (1) then
            local gz = var_0_252(lp, tx, ty, tz)
            return { x = tx, y = ty, z = gz }
        end
        if frac and frac < (1) then
            local hx = ox + (tx-ox)*frac
            local hy = oy + (ty-oy)*frac
            local hz = oz + (tz-oz)*frac
            for _, r in ipairs(radii) do
                for s=(0),angle_steps-(1) do
                    local a = (s/angle_steps) * math.pi * (1+1)
                    local cx = hx + math.cos(a)*r
                    local cy = hy + math.sin(a)*r
                    local cz = var_0_252(lp, cx, cy, hz)
                    local f2 = var_0_226(lp, ox, oy, oz+(8*2), cx, cy, cz+(8*2))
                    local f3 = var_0_226(lp, cx, cy, cz+(8*2), tx, ty, tz+(8*2))
                    if f2 and f2>=(1) and f3 and f3>=(1) then
                        local gz = var_0_252(lp, tx, ty, tz)
                        return { x = tx, y = ty, z = gz }
                    end
                end
            end
        end
    end
    return nil
end

local function var_0_198(node)
    local out = {}
    while node do
        out[#out+(1)] = { x = node.x, y = node.y, z = node.z }
        node = node.parent
    end
    local n = {}
    for i=#out,(1),(-(1)) do n[#n+(1)] = out[i] end
    return n
end

local function var_0_84(lp, destv)
    local ox, oy, oz = entity.get_origin(lp)
    if not ox then return nil end
    local start = { x = ox, y = oy, z = oz }
    start.z = var_0_252(lp, start.x, start.y, start.z)
    local queue = { { x = start.x, y = start.y, z = start.z, parent = nil } }
    local visited = {}
    local function var_0_164(v)
        local key = tostring(math.floor(v.x/(25*2)))..":"..tostring(math.floor(v.y/(25*2)))
        visited[key] = true
    end
    local function var_0_235(v)
        local key = tostring(math.floor(v.x/(25*2)))..":"..tostring(math.floor(v.y/(25*2)))
        if blocked_nodes[key] then return true end
        return visited[key]
    end
    var_0_164(start)
    local processed = (0)
    while #queue > (0) and processed < max_search_nodes do
        local cur = table.remove(queue, (1))
        processed = processed + (1)
        local frac = var_0_226(lp, cur.x, cur.y, cur.z+(8*2), destv.x, destv.y, destv.z+(8*2))
        if frac and frac >= (1) then
            local pathnodes = var_0_198(cur)
            pathnodes[#pathnodes+(1)] = { x = destv.x, y = destv.y, z = destv.z }
            return pathnodes
        end
        if frac and frac < (1) then
            local hx = cur.x + (destv.x-cur.x)*frac
            local hy = cur.y + (destv.y-cur.y)*frac
            local hz = cur.z + (destv.z-cur.z)*frac
            for _, r in ipairs(radii) do
                for s=(0),angle_steps-(1) do
                    local a = (s/angle_steps) * math.pi * (1+1)
                    local cx = hx + math.cos(a)*r
                    local cy = hy + math.sin(a)*r
                    local cz = var_0_252(lp, cx, cy, hz)
                    if not var_0_235({x=cx,y=cy}) then
                        local f2 = var_0_226(lp, cur.x, cur.y, cur.z+(8*2), cx, cy, cz+(8*2))
                        if f2 and f2 >= (1) then
                            var_0_164({x=cx,y=cy})
                            table.insert(queue, { x = cx, y = cy, z = cz, parent = cur })
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function var_0_170(cmd, lp, tx, ty, tz)
    local ox, oy, oz = entity.get_origin(lp)
    if not ox then return end
    
    local dx, dy = tx - ox, ty - oy
    local len = math.sqrt(dx*dx + dy*dy)
    if len <= (0) then return end
    local dirx, diry = dx / len, dy / len
    local step_dist = (32*2)
    local sx = ox + dirx * step_dist
    local sy = oy + diry * step_dist
    local sz = oz

    
    local pitch, yaw = client.camera_angles()
    local ang = math.deg(math.atan2(dy, dx))
    local yaw_diff = var_0_8(ang - yaw)
    local rad = math.rad(yaw_diff)
    local fwd = math.cos(rad) * walk_speed
    local side = -math.sin(rad) * walk_speed

    
    local ex, ey, ez = client.eye_position()
    if not ex then ex, ey, ez = ox, oy, oz end
    if type(ex) == 'table' then ex, ey, ez = ex[(1)], ex[(1+1)], ex[(2+1)] end
    local short_fx = ox + dirx * (12*2)
    local short_fy = oy + diry * (12*2)
    local short_fz = oz + (8*2)
    local short_frac = var_0_226(lp, ex, ey, ez, short_fx, short_fy, short_fz)
    if short_frac and short_frac < (1) then
        
        if debug_walk then pcall(client.log, "move_towards: short forward blocked, sidestep") end
        pcall(function() cmd.forwardmove = (0); cmd.sidemove = -walk_speed end)
        local leftx = ox - diry * step_dist
        local lefty = oy + dirx * step_dist
        local lfr = var_0_226(lp, ox, oy, oz + (8*2), leftx, lefty, sz + (8*2))
        if lfr and lfr >= (1) then return end
        pcall(function() cmd.forwardmove = (0); cmd.sidemove = walk_speed end)
        local rightx = ox + diry * step_dist
        local righty = oy - dirx * step_dist
        local rfr = var_0_226(lp, ox, oy, oz + (8*2), rightx, righty, sz + (8*2))
        if rfr and rfr >= (1) then return end
        
        pcall(function() var_0_133(tx, ty); paused_until = client.timestamp() + (125*2) end)
        path = nil
        return
    end

    
    pcall(function()
        cmd.forwardmove = fwd
        cmd.sidemove = side
    end)

    if debug_walk then pcall(client.log, string.format("move_towards: fwd=%.1f side=%.1f yaw_diff=%.1f", fwd, side, yaw_diff)) end

    local frac = var_0_226(lp, ox, oy, oz + (8*2), sx, sy, sz + (8*2))
    if frac and frac < (1) then
        
        if debug_walk then pcall(client.log, "move_towards: forward blocked, attempting sidestep") end
        
        pcall(function() cmd.forwardmove = (0); cmd.sidemove = -walk_speed end)
        local leftx = ox - diry * step_dist
        local lefty = oy + dirx * step_dist
        local lfr = var_0_226(lp, ox, oy, oz + (8*2), leftx, lefty, sz + (8*2))
        if lfr and lfr >= (1) then return end
        
        pcall(function() cmd.forwardmove = (0); cmd.sidemove = walk_speed end)
        local rightx = ox + diry * step_dist
        local righty = oy - dirx * step_dist
        local rfr = var_0_226(lp, ox, oy, oz + (8*2), rightx, righty, sz + (8*2))
        if rfr and rfr >= (1) then return end
        
        pcall(function()
            var_0_133(tx, ty)
            paused_until = client.timestamp() + (125*2)
        end)
        path = nil
        return
    end
end

callbacks.var_0_201("setup_command", function(cmd)
    local ok, err = pcall(function()
        if not var_0_270(var_0_166.ui.misc_walkbot) then return end
        local lp = entity.get_local_player()
        if not lp or not entity.is_alive(lp) then return end
        local var_0_173 = client.timestamp()
        if var_0_173 < paused_until then return end

        
        do
            local now_ts = client.timestamp()
            if now_ts - last_coord_print_time >= coord_print_interval then
                local px, py, pz = entity.get_origin(lp)
                if px then
                    pcall(function()
                        client.log(string.format("walkbot_coord: %.1f %.1f %.1f", px, py, pz))
                    end)
                    last_coord_print_time = now_ts
                end
            end
        end
        if client.key_state((29*3)) or client.key_state((13*5)) or client.key_state((82+1)) or client.key_state((34*2)) or client.key_state((16*2)) or client.key_state((8*2)) or client.key_state((16+1)) then
            paused_until = var_0_173 + (250*2)
            return
        end
        
        do
            local players = entity.get_players(true) or {}
            for i=(1),#players do
                local p = players[i]
                local px, py, pz = entity.get_origin(p)
                if px then
                    local ok_vis = pcall(function() return client.visible(px, py, pz) end)
                    if ok_vis and client.visible(px, py, pz) then
                        pcall(function()
                            local b = cmd.buttons or (0)
                            cmd.buttons = bit.bor(b, (2*2)) 
                        end)
                        break
                    end
                end
            end
        end
        
        local ox, oy, oz = entity.get_origin(lp)
        if ox then
            local players = entity.get_players(true) or {}
            if #players > (0) then
                if not current_target or not entity.is_alive(current_target) or entity.is_dormant(current_target) then
                    
                    local tbl = {}
                    for i=(1),#players do
                        local p = players[i]
                        local px, py, pz = entity.get_origin(p)
                        if px then
                            local d = var_0_279(ox, oy, oz, px, py, pz)
                            tbl[#tbl+(1)] = { ent = p, dist = d }
                        end
                    end
                    table.sort(tbl, function(a,b) return a.dist < b.dist end)
                    if #tbl > (0) then
                                current_target = tbl[(1)].ent  
                        path = nil
                        path_index = (1)
                    end
                end
            else
                current_target = nil
            end
        end

        
        if current_target and entity.is_alive(current_target) and not entity.is_dormant(current_target) then
            local tx, ty, tz = entity.get_origin(current_target)
            if tx then
                local gz = var_0_252(lp, tx, ty, tz)
                target_pos = { x = tx, y = ty, z = gz }
            else
                current_target = nil
                target_pos = nil
            end
        else
            current_target = nil
            target_pos = nil
        end

        
        do
            local var_0_173 = client.timestamp()
            if ox then
                if not last_pos then
                    last_pos = { x = ox, y = oy, z = oz }
                    last_pos_time = var_0_173
                else
                    if var_0_173 - last_pos_time >= pos_check_interval then
                        local moved = var_0_279(last_pos.x, last_pos.y, last_pos.z, ox, oy, oz)
                        if moved >= stuck_move_threshold then
                            
                            retry_count = (0)
                            last_pos = { x = ox, y = oy, z = oz }
                            last_pos_time = var_0_173
                        else
                            
                            if var_0_173 - last_pos_time >= stuck_threshold_time then
                                retry_count = retry_count + (1)
                                path = nil
                                paused_until = var_0_173 + (150*2)
                                last_pos = { x = ox, y = oy, z = oz }
                                last_pos_time = var_0_173
                                if retry_count >= max_retries_before_reroute then
                                    
                                    current_target = nil
                                    target_pos = nil
                                    retry_count = (0)
                                end
                            end
                        end
                    end
                end
            end
        end

        if target_pos then
            local var_0_173 = client.timestamp()
            local should_recompute = (not path) or (var_0_173 > target_recompute_time)
            if not last_target_pos then should_recompute = true end
            if last_target_pos and target_pos and var_0_279(last_target_pos.x, last_target_pos.y, last_target_pos.z, target_pos.x, target_pos.y, target_pos.z) > (50*2) then
                should_recompute = true
            end
            if should_recompute then
                local p = var_0_84(lp, target_pos)
                if p then
                    path = p
                    path_index = (1)
                    target_recompute_time = client.timestamp() + target_recompute_interval
                    last_target_pos = { x = target_pos.x, y = target_pos.y, z = target_pos.z }
                else
                    
                    current_target = nil
                    target_pos = nil
                    path = nil
                end
            end
        else
            if not path then
                local target = var_0_186(lp)
                
                if not target and #predefined_sites > (0) then
                    local s = predefined_sites[ math.random((1), #predefined_sites) ]
                    if s then target = { x = s.x, y = s.y, z = s.z } end
                end
                if target then
                    local p = var_0_84(lp, target)
                    if p then
                        path = p
                        path_index = (1)
                    else
                        
                        path = nil
                    end
                end
            end
        end
        if not path then return end
        local ox, oy, oz = entity.get_origin(lp)
        if not ox then return end
        local cur_target = path[path_index+(1)] or path[#path]
        if not cur_target then path = nil return end
        local d = var_0_279(ox, oy, oz, cur_target.x, cur_target.y, cur_target.z)
        if d <= reached_dist then
            path_index = path_index + (1)
            
            var_0_37(cur_target.x, cur_target.y)
            if path_index >= #path then path = nil return end
            return
        end
        do
            local jumped = false
            if current_target and target_pos then
                local tx, ty, tz = target_pos.x, target_pos.y, target_pos.z
                local dist = var_0_279(ox, oy, oz, tx, ty, tz)
                if dist > (500*2) then
                    
                end
            end
            if not jumped then
                var_0_170(cmd, lp, cur_target.x, cur_target.y, cur_target.z)
            end
        end
    end)
    if not ok then pcall(client.error_log, "walkbot error: "..tostring(err)) end
end)

callbacks.var_0_201("paint", function()
    if not var_0_270(var_0_166.ui.misc_walkbot) then return end
    if not path or #path == (0) then return end
    local lp = entity.get_local_player()
    if not lp then return end
    local ox, oy, oz = entity.get_origin(lp)
    if not ox then return end
    local prevx, prevy, prevz = ox, oy, oz
    prevz = var_0_252(lp, prevx, prevy, prevz)
    local px, py = renderer.world_to_screen(prevx, prevy, prevz)
    for i=path_index, #path do
        local n = path[i]
        if not n then break end
        local node_z = var_0_252(lp, n.x, n.y, n.z)
        local sx, sy = renderer.world_to_screen(n.x, n.y, node_z)
        if sx and sy and px and py then
            renderer.line(px, py, sx, sy, 255, 180, 0, 200)
            renderer.rectangle(sx-3, sy-3, 6, 6, 255, 80, 0, 200)
        end
        px, py = sx, sy
    end
end)

return true
]]
__bundle["require/features/paint/aimbot_logs"] = [[local var_0_166 = require("require/abc/menu_setup")


local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)
if not cb then error("callbacks manager required: require/abc/callbacks") end
local logs = {}
local fired_shots = {}

local function var_0_140()
	local ref = var_0_166.ui.paint_aimbot_logs
	if not ref then return false end
	local sel = ui.get(ref)
	if type(sel) == "string" then
		return sel ~= "off"
	end
	return false
end

local function var_0_111()
	local ref = var_0_166.ui.paint_aimbot_logs
	if not ref then return "gamesense" end
	local sel = ui.get(ref)
	if type(sel) == "table" then
		for _, v in ipairs(sel) do
			if v == "gamesense beta" then return "gamesense beta" end
			if v == "sodium" then return "sodium" end
			if v == "gamesense" then return "gamesense" end
		end
	elseif type(sel) == "string" then
		return sel
	end
	return "gamesense"
end

local enemies = require("require/help/enemies")
local var_0_192 = require("require/abc/push_logger")
local Safe = require("require/help/safe")

local ok_collect, collect = pcall(require, "require/features/misc/collect")


local function var_0_100(ent)
	if not ent or ent == (0) then return (0) end
	
	if ok_collect and collect then
		local ok, val = pcall(function()
			return collect.get_goal_feet_yaw(ent) or collect.get_feet_yaw(ent) or collect.get_lower_body_yaw(ent)
		end)
		if ok and val and val ~= (0) then return val end
	end
	
	local ok_prop, a1, a2, a3 = pcall(function() return entity.get_prop(ent, "m_angAbsRotation") end)
	if ok_prop and a1 then
		if type(a1) == "table" then
			return a1[(1+1)] or (0)
		else
			return a2 or (0)
		end
	end
	
	local ok_lby, lby = pcall(function() return entity.get_prop(ent, "m_flLowerBodyYawTarget") end)
	if ok_lby and lby then return lby end
	return (0)
end


local function var_0_117(ent)
	local ok, labels = pcall(function() return _G.player_labels end)
	if not ok or type(labels) ~= "table" then return nil end
	local ok2, lbl = pcall(function() return labels[ent] end)
	if not ok2 then return nil end
	return lbl
end


local function var_0_123()
	local ok, a, b, c = pcall(function() return client.camera_angles() end)
	if not ok then return nil, nil, nil end
	return a or (0), b or (0), c or (0)
end


local function var_0_91(ent)
	if not ent or ent == (0) then return nil, nil, nil end
	local ok, ax, ay, az = pcall(function() return entity.get_prop(ent, "m_angAbsRotation") end)
	if not ok then return nil, nil, nil end
	
	if type(ax) == "table" then
		return ax[(1)] or (0), ax[(1+1)] or (0), ax[(2+1)] or (0)
	else
		return ax or (0), ay or (0), az or (0)
	end
end

local function var_0_183(kind)
	local ref = var_0_166.ui.paint_logger
	if not ref then return false end
	local sel = Safe.var_0_222(ref)
	if type(sel) == 'table' then
		for _, v in ipairs(sel) do
			if v == kind then return true end
		end
		return false
	elseif type(sel) == 'string' then
		return sel == kind
	end
	return false
end
local function var_0_85(event, style, hit_or_miss, extra)
	local name = event.target_name or "?"
	local hitgroup = event.hitgroup_name or "?"
	local actual_dmg = (extra and extra.damage) or event.damage or (0)
	local wanted_dmg = event.damage or actual_dmg
	local dmg_delta = actual_dmg - wanted_dmg
	local dmg_str
	if actual_dmg == wanted_dmg then
		dmg_str = string.format("%d dmg", actual_dmg)
	elseif dmg_delta < (0) then
		dmg_str = string.format("%d(-%d) dmg", actual_dmg, math.abs(dmg_delta))
	else
		dmg_str = string.format("%d(+%d) dmg", actual_dmg, dmg_delta)
	end
	local health = (style == "gamesense" and extra and extra.health) or event.health or (0)
	local reason = extra and extra.reason or ""
	
	local bt_ticks = event.backtrack_ticks or (extra and extra.backtrack_ticks) or (0)
	if bt_ticks == (0) then
		
		local ok_tick, now_tick = pcall(function() return globals.tickcount() end)
		if ok_tick and event.tick then
			bt_ticks = math.max((0), now_tick - (event.tick or now_tick))
		end
	end
	local bt = event.backtrack or (extra and extra.backtrack) or (0)
	if bt == (0) and bt_ticks and bt_ticks > (0) then
		local ok_int, ti = pcall(function() return globals.tickinterval() end)
		local tickint = (ok_int and ti) or (0)
		bt = math.floor(bt_ticks * tickint * (500*2))
	end
	
	if bt == (0) and event.time then
		local ok_now, nowt = pcall(function() return globals.realtime() end)
		if ok_now and nowt and event.time then
			bt = math.floor((nowt - event.time) * (500*2))
		end
	end
	local hitchance = extra and extra.hitchance or event.hitchance or "hehe"
	local safepoint = event.safepoint or false
	local tick = event.tick or (0)
	local time = event.time or globals.realtime()
	local move = event.move or (0)
	local t = event.t or (0)
	
	local boneyaw = (extra and extra.boneyaw) or var_0_100(event.target) or (0)
	
	local resolver_label = (extra and extra.resolver) or var_0_117(event.target) or "?"
	resolver_label = tostring(resolver_label):lower()
	
	local view_pitch, view_yaw = var_0_123()
	local abs_pitch, abs_yaw = var_0_91(event.target)
	local id = event.id or (0)
	if style == "gamesense beta" then
		if hit_or_miss == "hit" then
			return string.format("[+] Hit %s's %s for %s (%d%%) bt=%dms (%d) view=%.1f/%.1f abs=%.1f/%.1f SBY move=%d t=%d boneyaw=%.1f",
				name, hitgroup, dmg_str, hitchance, bt, bt_ticks,
				view_yaw or (0), view_pitch or (0), abs_yaw or (0), abs_pitch or (0), move, t, boneyaw)
		else
			return string.format("[-] Missed %s's %s for %s (%d%%) due to %s bt=%dms (%d) view=%.1f/%.1f abs=%.1f/%.1f SBY move=%d t=%d boneyaw=%.1f",
				name, hitgroup, dmg_str, hitchance, reason, bt, bt_ticks,
				view_yaw or (0), view_pitch or (0), abs_yaw or (0), abs_pitch or (0), move, t, boneyaw)
		end
	elseif style == "gamesense" then
		if hit_or_miss == "hit" then
			return string.format("[gamesense] Hit %s's %s for %s (%d%%) (%dhp remaining)",
				name, hitgroup, dmg_str, hitchance, health)
		else
			return string.format("[gamesense] Missed %s's %s for %s (%d%%) reason=%s",
				name, hitgroup, dmg_str, hitchance, reason)
		end
	elseif style == "sodium" then
		if hit_or_miss == "hit" then
			return string.format("hit %s's %s for %s | %d%% | history(Δ): %dms | resolver=%s | boneyaw=%.2f",
				name, hitgroup, dmg_str, hitchance, bt, resolver_label, boneyaw)
		else
			return string.format("missed %s's %s due to %s | %d%% | history(Δ): %dms | resolver=%s | boneyaw=%.2f",
				name, hitgroup, reason, hitchance, bt, resolver_label, boneyaw)
		end
	else
		if hit_or_miss == "hit" then
			return string.format("a",
				name, hitgroup, dmg, hitchance, move, t, boneyaw)
		else
			return string.format("b",
				name, hitgroup, dmg, hitchance, reason, move, t, boneyaw)
		end
	end
end

cb.var_0_201('aim_fire', function(ev)

	if not var_0_140() then return end
	
	fired_shots[ev.id] = {
		id = ev.id,
		target = ev.target,
		target_name = entity.get_player_name(ev.target or (0)),
		hitgroup = ev.hitgroup,
		hitgroup_name = ev.hitgroup and ({"head","chest","stomach","left arm","right arm","left leg","right leg"})[ev.hitgroup] or "?",
		damage = ev.damage,
		health = ev.health,
		backtrack = (ev.backtrack or (0)) * globals.tickinterval() * (500*2),
		backtrack_ticks = ev.backtrack or (0),
		hitchance = ev.hit_chance or (0),
		safepoint = ev.safepoint,
		tick = globals.tickcount(),
		time = globals.realtime(),
		move = ev.move or (0),
		t = ev.t or (0),
		boneyaw = ev.boneyaw or var_0_100(ev.target) or (0),
	}
end, { require_login = true, alive_only = true })

cb.var_0_201('aim_hit', function(ev)

	if not var_0_140() then return end
	local shot = fired_shots[ev.id]
	if not shot then return end
	local style = var_0_111()
	local health_after = entity.get_prop(ev.target, "m_iHealth") or (0)
	local boneyaw = shot.boneyaw or var_0_100(shot.target)
	local resolver = var_0_117(shot.target)
	local log = var_0_85(shot, style, "hit", {
		damage=ev.damage,
		health=health_after,
		backtrack=shot.backtrack,
		backtrack_ticks=shot.backtrack_ticks,
		boneyaw=boneyaw,
		resolver=resolver
	})
	if style == "gamesense beta" then
		
		client.color_log((55*3), (101*2), (21*2), log)
	elseif style == "sodium" then
		local requested = shot.damage or (0)
		local actual = ev.damage or requested
		local delta = actual - requested
		local r, g, b
		if delta == (0) then
			r, g, b = (55*3), (101*2), (21*2) 
		else
			r, g, b = (85*3), (102*2), (17*3) 
		end
		client.color_log(r, g, b, log)
	else
		client.log(log)
	end

	
	if var_0_183('aimbot') then
		local name = shot.target_name or "?"
		local hitbox = shot.hitgroup_name or "?"
		local dmg = ev.damage or (0)
		local hc = shot.hitchance or (0)
		local msg = string.format("Hit %s's %s for %d(%d%%)", name, hitbox, dmg, hc)
		var_0_192(msg, (2*2), (85*3), (85*3), (85*3), (85*3))
	end

	fired_shots[ev.id] = nil
end, { require_login = true, alive_only = true })

cb.var_0_201('aim_miss', function(ev)

	if not var_0_140() then return end
	local shot = fired_shots[ev.id]
	if not shot then return end
	local style = var_0_111()
	local boneyaw = shot.boneyaw or var_0_100(shot.target)
	local resolver = var_0_117(shot.target)
	local log = var_0_85(shot, style, "miss", {reason=ev.reason or "?", boneyaw=boneyaw, resolver=resolver})
	if style == "gamesense beta" then
		client.color_log((31*7), (50*2), (50*2), log)
	elseif style == "sodium" then
		client.color_log((31*7), (50*2), (50*2), log)
	else
		client.log(log)
	end

	if var_0_183('aimbot') then
		local name = shot.target_name or "?"
		local hitbox = shot.hitgroup_name or "?"
		local dmg = shot.damage or (0)
		local hc = shot.hitchance or (0)
		local reason = ev.reason or "?"
		local msg = string.format("Missed %s's %s for %d(%d%%) due to %s", name, hitbox, dmg, hc, reason)
		var_0_192(msg, (2*2), (85*3), (85*3), (85*3), (85*3))
	end

	fired_shots[ev.id] = nil
end, { require_login = true, alive_only = true })


]]
__bundle["require/features/paint/animations"] = [[


local S = nil
pcall(function() S = require('require/help/safe') end)
local var_0_166 = nil
pcall(function() var_0_166 = require('require/abc/menu_setup') end)

local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)
if not cb then error("callbacks manager required: require/abc/callbacks") end
local c_entity = require("gamesense/entity") or error("You're missing a required module: gamesense/entity")


local function var_0_112()
    local lp = entity.get_local_player()
    if not lp then return nil, nil end
    local ok, wrapped = pcall(function() return c_entity.new(lp) end)
    if not ok then return lp, nil end
    return lp, wrapped
end




local E_POSE_PARAMETERS = {
    STRAFE_YAW = (0),
    STAND = (1),
    LEAN_YAW = (1+1),
    SPEED = (2+1),
    LADDER_YAW = (2*2),
    LADDER_SPEED = (4+1),
    JUMP_FALL = (3*2),
    MOVE_YAW = (6+1),
    MOVE_BLEND_CROUCH = (4*2),
    MOVE_BLEND_WALK = (3*3),
    MOVE_BLEND_RUN = (5*2),
    BODY_YAW = (10+1),
    BODY_PITCH = (6*2),
    AIM_BLEND_STAND_IDLE = (12+1),
    AIM_BLEND_STAND_WALK = (7*2),
    AIM_BLEND_STAND_RUN = (7*2),
    AIM_BLEND_CROUCH_IDLE = (8*2),
    AIM_BLEND_CROUCH_WALK = (16+1),
    DEATH_YAW = (9*2)
}

local function var_0_122(ent)
    if not ent then return (0) end
    local vx, vy, vz = entity.get_prop(ent, 'm_vecVelocity')
    if not vx or not vy then
        local vel = vx
        if type(vel) == 'table' then
            vx = vel.x or vel[(1)] or (0)
            vy = vel.y or vel[(1+1)] or (0)
        else
            return (0)
        end
    end
    return math.sqrt((vx or (0)) * (vx or (0)) + (vy or (0)) * (vy or (0)))
end

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'AA', 'Other', 'Leg movement' },

}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end





local function var_0_256()
    local lp = entity.get_local_player()
    if not lp then return end
    entity.set_prop(lp, "m_flPoseParameter", (1), E_POSE_PARAMETERS.JUMP_FALL)
end

local function var_0_148()
    value = (0.5)
    local lp = entity.get_local_player()
    if not lp then return end
    local tick = globals.tickcount()
    local phase = math.floor(tick / (1+1)) % (1+1)
    local finval = (phase == (0)) and (-0.1) or (0.9)
    entity.set_prop(lp, "m_flPoseParameter", math.random((0), (5*2)) / value, E_POSE_PARAMETERS.SPEED)
    entity.set_prop(lp, "m_flPoseParameter", math.random((0), (5*2)) / (5*2), E_POSE_PARAMETERS.MOVE_YAW)
    entity.set_prop(lp, "m_flPoseParameter", math.random((0), (5*2)) / (5*2), E_POSE_PARAMETERS.JUMP_FALL)
end

local function var_0_22(cmd)
    local lp = entity.get_local_player()
    if not lp then return end
    local pose_value = globals.tickcount() % (2*2) > (1) and (1) / (5*2) or (0.9)
    
    
    ui.set(gs_item_refs[(1)][(1)], (cmd.command_number % (2+1)) == (0) and "Off" or "Always slide")
end


local function var_0_21()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local anim_state = player_entity:get_anim_state()
    local anim_overlay = player_entity:get_anim_overlay((6*2))
    if anim_overlay then anim_overlay.weight = (0.8) end
end

local function var_0_187()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local anim_state = player_entity:get_anim_state()
    if anim_state and anim_state.hit_in_ground_animation then
        entity.set_prop(lp, "m_flPoseParameter", (0.5), E_POSE_PARAMETERS.BODY_PITCH)
    end
end

local function var_0_169()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local overlay = player_entity:get_anim_overlay((3*2))
    entity.set_prop(lp, "m_flPoseParameter", (0), E_POSE_PARAMETERS.MOVE_YAW)
    if overlay then overlay.weight = (1) end
end

local function var_0_5()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local overlay12 = player_entity:get_anim_overlay((6*2))
    local overlay6 = player_entity:get_anim_overlay((3*2))
    if overlay12 then overlay12.weight = (0) end
    if overlay6 then overlay6.weight = (1) end
end

local function var_0_217()
    local lp = entity.get_local_player()
    if not lp then return end
    ui.set(gs_item_refs[(1)][(1)], math.random((1),(1+1)) == (1) and "Always slide" or "Never slide")
    entity.set_prop(lp, "m_flPoseParameter", (4*2), (0))
end


local function var_0_20()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local overlay9 = player_entity:get_anim_overlay((3*3))
    if overlay9 then
        overlay9.weight = (1)
        overlay9.sequence = (112*2)
    end
end

local function var_0_257()
    local lp, player_entity = var_0_112()
    if not lp or not player_entity then return end
    local overlay0 = player_entity:get_anim_overlay((0))
    if overlay0 then overlay0.sequence = (10+1) end
end

local function var_0_188()

    local lp = var_0_112()
    if not lp then return end
    entity.set_prop(lp, 'm_flPoseParameter', (0), E_POSE_PARAMETERS.BODY_PITCH)
    entity.set_prop(lp, 'm_flPoseParameter', math.random((-(1)), (1)), E_POSE_PARAMETERS.BODY_YAW)

end




cb.var_0_201('pre_render', function()
    local lp = entity.get_local_player()
    if not lp then return end
    local velocity = var_0_122(lp)


    local selections = nil
    if var_0_166 and var_0_166.ui and var_0_166.ui.paint_animations then
        if S and S.var_0_222 then
            selections = S.var_0_222(var_0_166.ui.paint_animations)
        else
            local ok, res = pcall(function() return ui.get(var_0_166.ui.paint_animations) end)
            if ok then selections = res end
        end
    end

    local sel = {}
    if type(selections) == 'table' then
        for _, v in ipairs(selections) do sel[v] = true end
    end

    if sel['Kingaru'] and velocity > (2+1) then var_0_148() end
    if sel['Body lean'] and velocity > (2+1) then var_0_21() end
    if sel['Static legs'] and velocity > (2+1) then var_0_256() end
    if sel['Moonwalk'] and velocity > (2+1) then var_0_169() end
    if sel['Allah'] and velocity > (2+1) then var_0_5() end
    if sel['No pitch on land'] and velocity > (2+1) then var_0_187() end
    if sel['Reversed legs'] and velocity > (2+1) then var_0_217() end
    if sel['T-pose'] then var_0_257() end
    if sel['Blind'] then var_0_20() end
    if sel['Pitch up'] then var_0_188() end
end, { require_login = true, alive_only = true })

cb.var_0_201('setup_command', function(cmd)

    local lp = entity.get_local_player()
    if not lp then return end
    local velocity = var_0_122(lp)
    if velocity < (2+1) then return end

    local selections = nil
    if var_0_166 and var_0_166.ui and var_0_166.ui.paint_animations then
        if S and S.var_0_222 then
            selections = S.var_0_222(var_0_166.ui.paint_animations)
        else
            local ok, res = pcall(function() return ui.get(var_0_166.ui.paint_animations) end)
            if ok then selections = res end
        end
    end

    local sel = {}
    if type(selections) == 'table' then
        for _, v in ipairs(selections) do sel[v] = true end
    end

    if sel['Gamesense Legs'] then var_0_22(cmd) end

end, { require_login = true, alive_only = true })]]
__bundle["require/features/paint/aspect_ratio"] = [[
local var_0_166 = require("require/abc/menu_setup")
local T = require("require/help/time")
local M = require("require/help/math")
local Safe = require("require/help/safe")

local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)
if not cb then error("callbacks manager required: require/abc/callbacks") end
local aspect_state = { original = nil, last = nil, last_update = nil }

local function var_0_93()
    if cvar.r_aspectratio and cvar.r_aspectratio.get_float then
        return cvar.r_aspectratio:get_float()
    end
    return nil
end

local function var_0_236(val)
    if cvar.r_aspectratio and cvar.r_aspectratio.set_float then
        cvar.r_aspectratio:set_float(val)
        return true
    elseif client and client.exec then
        client.exec("r_aspectratio " .. tostring(val))
        return true
    end
    return false
end

cb.var_0_201('paint', function()
    if not ui.is_menu_open() then return end
    local ref = var_0_166.ui.paint_aspect_ratio
    if not ref then return end
    local raw = Safe.var_0_222(ref)
    if type(raw) ~= 'number' then return end
    local target = M.var_0_35(raw * (0.01), (0), (2+1))
    target = M.var_0_221(target, (2+1))
    if aspect_state.original == nil then
        aspect_state.original = var_0_93()
    end
    if aspect_state.last == nil then
        aspect_state.last = var_0_93() or target
    end
    local var_0_173 = T.realtime() or os.clock()
    local last_update = aspect_state.last_update or var_0_173
    local dt = var_0_173 - last_update
    aspect_state.last_update = var_0_173
    local speed = (6*2)
    local step = speed * dt
    if math.abs(aspect_state.last - target) > (0.0005) then
        local t = M.var_0_35(step / math.max(math.abs(target - aspect_state.last), (0.01)), (0), (1))
        aspect_state.last = M.var_0_152(aspect_state.last, target, t)
        aspect_state.last = M.var_0_221(aspect_state.last, (2+1))
        var_0_236(aspect_state.last)
    end
end, { require_login = true, alive_only = true })


cb.var_0_201('round_start', function()
    local ref = var_0_166.ui and var_0_166.ui.paint_aspect_ratio
    if not ref then return end
    local raw = Safe.var_0_222(ref)
    if type(raw) ~= 'number' then return end
    local target = M.var_0_35(raw * (0.01), (0), (2+1))
    target = M.var_0_221(target, (2+1))
    if aspect_state.original == nil then
        aspect_state.original = var_0_93()
    end
    aspect_state.last = target
    aspect_state.last_update = T.realtime() or os.clock()
    pcall(var_0_236, aspect_state.last)
end, { require_login = true, alive_only = true })]]
__bundle["require/features/paint/bomb_esp"] = [[local bomb_state = nil
local damage_indicators = {}
local prev_health = nil
local PRED_BASE_DAMAGE = (250*2)
local PRED_RADIUS = (500*2)

local PRED_SCALE = (1.0)
local AUTO_TUNE_ENABLED = true
local TUNE_SMOOTH = (0.25) 
local LAST_TUNE_TIME = (0)
local TUNE_COOLDOWN = (1+1)

local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)
if not cb then error("callbacks manager required: require/abc/callbacks") end

local function var_0_36()
    bomb_state = nil
end

local function var_0_99(map)
    if not map then return (325*2), (455*5) end
    local m = tostring(map):lower()
    if m:find('de_dust2') then return (250*2), (875*2) end
    if m:find('de_ancient') then return (325*2), (455*5) end
    if m:find('de_anubis') then return (225*2), (525*3) end
    if m:find('de_inferno') then return (310*2), (1085*2) end
    if m:find('de_mirage') then return (325*2), (455*5) end
    if m:find('de_nuke') then return (325*2), (455*5) end
    if m:find('de_overpass') then return (325*2), (455*5) end
    if m:find('de_vertigo') then return (250*2), (875*2) end
    return (325*2), (455*5)
end

local function var_0_17(damage, armor)
    armor = tonumber(armor) or (0)
    if armor > (0) then
        local armor_ratio = (0.5)
        local armor_bonus = (0.5)
        local armor_ratio_multiply = damage * armor_ratio
        local actual = (damage - armor_ratio_multiply) * armor_bonus
        if actual > tonumber(armor) then
            actual = tonumber(armor) * ((1.0) / armor_bonus)
            armor_ratio_multiply = damage - actual
        end
        damage = armor_ratio_multiply
    end
    return damage
end

local function var_0_29(px, py, pz, bx, by, bz, armor, map_name)
    if not px or not py or not pz or not bx or not by or not bz then return (0) end
    local bomb_damage, bomb_radius = var_0_99(map_name)
    local c = bomb_radius / (3.0)
    local dx = px - bx
    local dy = py - by
    local dz = pz - bz
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    local exp_part = math.exp( - (dist * dist) / ((1+1) * c * c) )
    local damage = bomb_damage * exp_part
    local damage_armor = var_0_17(damage, armor)
    return math.floor(damage_armor + (0.0))
end

local function var_0_250(idx)
    if not idx then return "?" end
    if idx == (227*2) then return "A" end
    if idx == (91*5) then return "B" end
    if idx == (0) then return "A" end
    if idx == (1) then return "B" end
    if type(idx) == "string" then
        local s = idx:upper()
        if s == "A" or s == "B" then return s end
    end
    return tostring(idx)
end

cb.var_0_201('bomb_planted', function(e)
    local site_index = e and e.site

    local planted_entities = entity.get_all("CPlantedC4") or {}
    local blow_time = nil
    local entindex = nil

    for i = (1), #planted_entities do
        local idx = planted_entities[i]
        local prop = entity.get_prop(idx, "m_flC4Blow")
        if prop and prop > (0) then
            blow_time = prop
            entindex = idx
            break
        end
    end

    if not blow_time then
        local c4timer = (20*2)
        if cvar and cvar.mp_c4timer then
            local ok, val = pcall(function()
                if type(cvar.mp_c4timer.get_float) == "function" then
                    return cvar.mp_c4timer:get_float()
                elseif type(cvar.mp_c4timer.get_int) == "function" then
                    return cvar.mp_c4timer:get_int()
                else
                    return tonumber(cvar.mp_c4timer:get_string())
                end
            end)
            if ok and val and tonumber(val) then
                c4timer = tonumber(val)
            end
        end
        blow_time = globals.curtime() + (c4timer or (20*2))
    end

    bomb_state = {
        site = site_index,
        blow_time = blow_time,
        entindex = entindex,
        planted_at = globals.curtime()
    }
end, { require_login = true, alive_only = true })

cb.var_0_201('bomb_defused', var_0_36, { require_login = true, alive_only = true })
cb.var_0_201('bomb_exploded', function(e)
    
    local had_bomb = bomb_state ~= nil
    local tune_at = globals.curtime()
    
    local predicted = nil
    local local_ent = entity.get_local_player()
    if had_bomb and local_ent then
        local function var_0_41()
            
            local bomb_pos = nil
            if bomb_state and bomb_state.entindex then
                local ok, a, b, c = pcall(function() return entity.get_prop(bomb_state.entindex, "m_vecOrigin") end)
                if ok then
                    if type(a) == "table" then
                        bomb_pos = a
                    elseif a ~= nil and b ~= nil and c ~= nil then
                        bomb_pos = { a, b, c }
                    end
                end
            end
            if not bomb_pos then
                local planted_entities = entity.get_all("CPlantedC4") or {}
                for i = (1), #planted_entities do
                    local idx = planted_entities[i]
                    local ok, a, b, c = pcall(function() return entity.get_prop(idx, "m_vecOrigin") end)
                    if ok then
                        if type(a) == "table" then
                            bomb_pos = a
                            break
                        elseif a ~= nil and b ~= nil and c ~= nil then
                            bomb_pos = { a, b, c }
                            break
                        end
                    end
                end
            end
            if not bomb_pos then return nil end
            local ok, ex, ey, ez = pcall(function() return client.eye_position() end)
            local px, py, pz
            
            local ok2, ox, oy, oz = pcall(function() return entity.get_origin(local_ent) end)
            if ok2 then
                if type(ox) == "table" then
                    if #ox >= (2+1) then px, py, pz = ox[(1)], ox[(1+1)], ox[(2+1)] end
                elseif ox ~= nil and oy ~= nil and oz ~= nil then
                    px, py, pz = ox, oy, oz
                end
            end
            
            if (not px or not py or not pz) and ok and ex ~= nil and ey ~= nil and ez ~= nil then
                px, py, pz = ex, ey, ez
            end
            if not px or not bomb_pos or #bomb_pos < (2+1) then return nil end
            local bx, by, bz = bomb_pos[(1)], bomb_pos[(1+1)], bomb_pos[(2+1)]
            
            local ok_a, armor = pcall(function() return entity.get_prop(local_ent, "m_ArmorValue") end)
            armor = tonumber(armor) or (0)
            local map_name = nil
            local okm, mres = pcall(function()
                if type(client.mapname) == 'function' then return client.mapname() end
                if cvar and cvar.mapname then return cvar.mapname:get_string() end
                if cvar and cvar.map then return cvar.map:get_string() end
                return nil
            end)
            if okm then map_name = mres end
            local raw_damage = var_0_29(px, py, pz, bx, by, bz, armor, map_name)
            local scaled = math.floor((raw_damage * (PRED_SCALE or (1.0))) + (0.5))
            return raw_damage, scaled, math.sqrt((px-bx)^(1+1) + (py-by)^(1+1) + (pz-bz)^(1+1))
        end
        local raw_pred, scaled_pred, pred_dist = var_0_41()
        predicted = scaled_pred
    end

    
    var_0_36()

    
    if AUTO_TUNE_ENABLED and predicted and predicted > (0) then
        local sample_time = (0.15)
        client.delay_call(sample_time, function()
            local var_0_173 = globals.curtime()
            if var_0_173 - LAST_TUNE_TIME < TUNE_COOLDOWN then return end
            local local_ent2 = entity.get_local_player()
            if not local_ent2 then return end
            local ok, hp_after = pcall(function() return entity.get_prop(local_ent2, "m_iHealth") end)
            hp_after = tonumber(hp_after)
            local hp_before = prev_health
            if not hp_before or not hp_after then return end
            local actual = hp_before - hp_after
            if actual <= (0) then return end

            
            local pred_for_ratio = (predicted and predicted > (0)) and predicted or (1)
            local ratio = actual / pred_for_ratio
            if ratio <= (0) then return end

            
            local new_scale = (PRED_SCALE or (1.0)) * ((1) + (ratio - (1)) * TUNE_SMOOTH)
            if new_scale < (0.05) then new_scale = (0.05) end
            if new_scale > (5*2) then new_scale = (5*2) end
            local old_scale = PRED_SCALE
            PRED_SCALE = new_scale
            LAST_TUNE_TIME = globals.curtime()
            
            pcall(function()
                client.log("[bomb_esp] auto-tuned scale %.3f -> %.3f (ratio=%.3f, predicted=%d, actual=%d)", old_scale, PRED_SCALE, ratio, predicted or (0), actual)
            end)
        end)
    end
end, { require_login = true, alive_only = true })
cb.var_0_201('round_start', var_0_36, { require_login = true, alive_only = true })
cb.var_0_201('round_start', function()
    prev_health = nil
end, { require_login = true, alive_only = true })
cb.var_0_201('player_spawned', function()
    prev_health = nil
end, { require_login = true, alive_only = true })


cb.var_0_201('player_hurt', function(e)
    if not e then return end
    local local_ent = entity.get_local_player()
    if not local_ent then return end
    local victim_ent = client.userid_to_entindex(e.userid)
    if victim_ent ~= local_ent then return end

    
    local dmg = e.dmg_health or e.damage or e.hp or (0)
    dmg = tonumber(dmg) or (0)
    if dmg <= (0) then return end

    
    local text = string.format("-%d HP", dmg)
    
    table.insert(damage_indicators, { t = globals.curtime(), text = text })
end, { require_login = true, alive_only = true })


cb.var_0_201('paint', function()
    local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
    if not menu_ok or not var_0_166 or not var_0_166.ui then return end
    local ok_get, paint_bombwarning = pcall(ui.get, var_0_166.ui.paint_bombwarning)
    if not ok_get or not paint_bombwarning then return end

    local var_0_173 = globals.curtime()

    
    local local_ent = entity.get_local_player()
    if local_ent then
        local ok, hp = pcall(function() return entity.get_prop(local_ent, "m_iHealth") end)
        hp = tonumber(hp)
        if hp then
            if prev_health == nil then
                prev_health = hp
            else
                if hp < prev_health then
                    local dmg = prev_health - hp
                    table.insert(damage_indicators, { t = var_0_173, text = string.format("-%d HP", dmg) })
                end
                prev_health = hp
            end
        end
    else
        prev_health = nil
    end

    
    for i = #damage_indicators, (1), (-(1)) do
        local d = damage_indicators[i]
        local age = var_0_173 - d.t
        local duration = (1.4)
        if age >= duration then
            table.remove(damage_indicators, i)
        else
            local alpha = math.floor((85*3) * ((1) - (age / duration)))
            if alpha < (0) then alpha = (0) end
            
            renderer.indicator(255, 210, 0, alpha, d.text)
        end
    end

    
    if bomb_state then
        local local_ent = entity.get_local_player()
        local bomb_pos = nil
        if bomb_state.entindex then
            local ok, a, b, c = pcall(function() return entity.get_prop(bomb_state.entindex, "m_vecOrigin") end)
            if ok then
                if type(a) == "table" then
                    bomb_pos = a
                elseif a ~= nil and b ~= nil and c ~= nil then
                    bomb_pos = { a, b, c }
                end
            end
        end
        
        if not bomb_pos then
            local planted_entities = entity.get_all("CPlantedC4") or {}
            for i = (1), #planted_entities do
                local idx = planted_entities[i]
                local ok, a, b, c = pcall(function() return entity.get_prop(idx, "m_vecOrigin") end)
                if ok then
                    if type(a) == "table" then
                        bomb_pos = a
                        break
                    elseif a ~= nil and b ~= nil and c ~= nil then
                        bomb_pos = { a, b, c }
                        break
                    end
                end
            end
        end

        if bomb_pos and local_ent then
            local px, py, pz = nil, nil, nil
            local ok, ex, ey, ez = pcall(function() return client.eye_position() end)
            if ok and ex ~= nil and ey ~= nil and ez ~= nil then
                px, py, pz = ex, ey, ez
            else
                local ok2, ox, oy, oz = pcall(function() return entity.get_origin(local_ent) end)
                if ok2 then
                    if type(ox) == "table" then
                        if #ox >= (2+1) then px, py, pz = ox[(1)], ox[(1+1)], ox[(2+1)] end
                    elseif ox ~= nil and oy ~= nil and oz ~= nil then
                        px, py, pz = ox, oy, oz
                    end
                end
            end

            if px and bomb_pos and #bomb_pos >= (2+1) then
                local bx, by, bz = bomb_pos[(1)], bomb_pos[(1+1)], bomb_pos[(2+1)]
                
                local ok_a, armor = pcall(function() return entity.get_prop(local_ent, "m_ArmorValue") end)
                armor = tonumber(armor) or (0)
                local okm, mres = pcall(function()
                    if type(client.mapname) == 'function' then return client.mapname() end
                    if cvar and cvar.mapname then return cvar.mapname:get_string() end
                    if cvar and cvar.map then return cvar.map:get_string() end
                    return nil
                end)
                local map_name = okm and mres or nil
                local raw_pred = var_0_29(px, py, pz, bx, by, bz, armor, map_name)
                local pred = math.floor((raw_pred * (PRED_SCALE or (1.0))) + (0.5))

                
                renderer.indicator(255, 210, 0, 255, string.format("-%d HP", pred))
            end
        end
    end

    
    if bomb_state then
        
        if bomb_state.entindex then
            local prop = entity.get_prop(bomb_state.entindex, "m_flC4Blow")
            if prop and prop > (0) then
                bomb_state.blow_time = prop
            end
        end

        local remaining = (bomb_state.blow_time or (0)) - var_0_173
        if remaining <= (0) then
            bomb_state = nil
            return
        end

        local site_name = var_0_250(bomb_state.site)
        local text = string.format("%s - %.1fs", site_name, remaining)
        renderer.indicator(255, 255, 255, 255, text)
    end
end, { require_login = true, alive_only = true })]]
__bundle["require/features/paint/bullet_tracer"] = [[local vector = require('require/help/vector')
local T = require('require/help/time')
local S = nil
pcall(function() S = require('require/help/safe') end)
local SELF = require('require/help/self')

local var_0_166 = nil
pcall(function() var_0_166 = require('require/abc/menu_setup') end)


local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)

local tracers = {}
local tracer_life = (3500*2)
local tracer_color = {(85*3),(85*3),(85*3),(85*3)}
local fade_fraction = (0.05)

local var_0_173 = client.timestamp

local function var_0_86(p)
    local pitch, yaw = p[(1)], p[(1+1)]
    local radp, rady = math.rad(pitch), math.rad(yaw)
    local cp = math.cos(radp)
    return vector(cp*math.cos(rady), cp*math.sin(rady), -math.sin(radp))
end

if not cb then error("callbacks manager required: require/abc/callbacks") end

cb.var_0_201('weapon_fire', function(e)
    if not ui.get(var_0_166.ui.paint_bullet_tracer) then return end
    if SELF.index() ~= client.userid_to_entindex(e.userid) then return end
    local w = SELF.weapon()
    if w then
        local cls = entity.get_classname(w) or ""
        local lower = cls:lower()
        if lower:find("knife") or lower:find("grenade") or lower:find("decoy") or lower:find("molotov") or lower:find("flash") or lower:find("smoke") or lower:find("taser") or lower:find("zeus") then
            return
        end
    end

    local sx,sy,sz = client.eye_position()
    if not sx then sx,sy,sz = entity.get_origin(SELF.index()) end
    tracers[#tracers+(1)] = { s = vector(sx,sy,sz), f = nil, t = var_0_173() }
end, { require_login = true, alive_only = true })
 

if not cb then error("callbacks manager required: require/abc/callbacks") end

cb.var_0_201('bullet_impact', function(e)
    if not ui.get(var_0_166.ui.paint_bullet_tracer) then return end
    if SELF.index() ~= client.userid_to_entindex(e.userid) then return end
    local ix,iy,iz = e.x,e.y,e.z
    for i=#tracers,(1),(-(1)) do
        tracers[i].f = vector(ix,iy,iz)
        tracers[i].t = var_0_173()
        break
    end
end, { require_login = true, alive_only = true })

if not cb then error("callbacks manager required: require/abc/callbacks") end

cb.var_0_201('paint', function()
    if not ui.get(var_0_166.ui.paint_bullet_tracer) then return end
    local cur = var_0_173()
    for i=#tracers,(1),(-(1)) do
        local tr = tracers[i]
        local age = cur - tr.t
        if age > tracer_life then table.remove(tracers,i) goto continue end
        local s, f = tr.s, tr.f
        if not f then
            local ang = client.camera_angles() local dir = var_0_86(ang)
            f = vector(s.x + dir.x*(4096*2), s.y + dir.y*(4096*2), s.z + dir.z*(4096*2))
        end
        local sx,sy = renderer.world_to_screen(s.x,s.y,s.z)
        local fx,fy = renderer.world_to_screen(f.x,f.y,f.z)
        if sx and fx then
            local a = tracer_color[(2*2)]
            local fs = tracer_life*((1)-fade_fraction)
            if age >= fs then a = a * ((1) - math.min((1),(age-fs)/(tracer_life-fs))) end
            renderer.line(sx,sy,fx,fy, tracer_color[1], tracer_color[2], tracer_color[3], a)
        end
        ::continue::
    end
end, { require_login = true, alive_only = true })]]
__bundle["require/features/paint/clantag"] = [[local var_0_166=require("require/abc/menu_setup")
local Safe=require("require/help/safe")
local T=require("require/help/time")
local p=pcall
local uref=ui.reference
local uset=ui.set
local set_tag=client.set_clan_tag
local ok_cb, cb = pcall(require, "require/abc/callbacks")
if not ok_cb or not cb then error("require/abc/callbacks is required by clantag.lua") end
local last_mode,clear_attempts,frames=nil,(0),nil
local function var_0_269(e)
    local c={{"MISC","Misc","Clantag spammer"},{"MISC","Miscellaneous","Clantag spammer"},{"MISC","Misc","Clan tag spammer"},{"MISC","Miscellaneous","Clan tag spammer"},{"MISC","Misc","Clantag spamer"},{"MISC","Miscellaneous","Clantag spamer"}}
    for _,v in ipairs(c) do
        local ok,ref=p(uref,v[(1)],v[(1+1)],v[(2+1)])
        if ok and ref and p(uset,ref,e) then return true end
    end
    return false
end
local var_0_267=function() return var_0_269(true) end
local var_0_266=function() return var_0_269(false) end
cb.var_0_201('paint', function()
    local ref=var_0_166.ui.paint_clantag if not ref then return end
    local raw=Safe.var_0_222(ref) if type(raw)~='string' then return end
    local mode=raw:lower() if mode==last_mode and mode~='sodium' and clear_attempts==(0) then return end
    if mode=='off' then var_0_266(); clear_attempts=(2+1); p(set_tag,"")
    elseif mode=='gamesense' then if not var_0_267() then p(set_tag,"gamesense") end
    elseif mode=='sodium' then var_0_266()
        if not frames then
            local base="sodium.lua" local idxs={(0),(1),(1+1),(2+1),(2*2),(4+1),(3*2),(6+1),(4*2),(3*3),(10+1),(6*2),(12+1)} frames={}
            for _,i in ipairs(idxs) do local left=i>(0) and base:sub((1),i) or "" local right=base:sub(i+(1)) frames[#frames+(1)]=left.."  >"..right end
            frames[#frames+(1)]=base
        end
        local t=T.realtime() or os.clock() local speed=(2+1) local id=(math.floor(t*speed)%#frames)+(1) p(set_tag,frames[id])
    end
    if clear_attempts>(0) then p(set_tag,"") clear_attempts=clear_attempts-(1) end
    last_mode=mode
end, { require_login = true, alive_only = true })
]]
__bundle["require/features/paint/custom_scope"] = [[
local client_screen_size, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_frametime, renderer_gradient, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.screen_size, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.frametime, renderer.gradient, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible
local var_0_35 = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

local easing = require "gamesense/easing"
local m_alpha = (0)

local scope_overlay = false
local _ms_ok, _ms = pcall(require, "require/abc/menu_setup")


local master_switch = ui.get(_ms.ui.paint_scope)
print(master_switch)
local color_picker = ui_new_color_picker('Visuals', 'Effects', '\n scope_lines_color_picker', (0), (0), (0), (85*3))
local overlay_position = ui.get(_ms.ui.paint_scope_initialpos) 
local overlay_offset = ui.get(_ms.ui.paint_scope_offset)

local fade_time_value = (8*2)

<


client.set_event_callback("paint", function()

    print("cuka")

	local width, height = client_screen_size()
	local offset, initial_position, speed, color =
		ui_get(overlay_offset) * height / (540*2),
		ui_get(overlay_position) * height / (540*2),
		fade_time_value, { ui_get(color_picker) }

	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == (1)
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == (1)

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > (0) and scoped and not resume_zoom

	local FT = speed > (2+1) and globals_frametime() * speed or (1)
	local alpha = easing.linear(m_alpha, (0), (1), (1))

	renderer_gradient(width/(1+1) - initial_position + (1+1), height / (1+1), initial_position - offset, (1), color[(1)], color[(1+1)], color[(2+1)], (0), color[(1)], color[(1+1)], color[(2+1)], alpha*color[(2*2)], true)
	renderer_gradient(width/(1+1) + offset, height / (1+1), initial_position - offset, (1), color[(1)], color[(1+1)], color[(2+1)], alpha*color[(2*2)], color[(1)], color[(1+1)], color[(2+1)], (0), true)

	renderer_gradient(width / (1+1), height/(1+1) - initial_position + (1+1), (1), initial_position - offset, color[(1)], color[(1+1)], color[(2+1)], (0), color[(1)], color[(1+1)], color[(2+1)], alpha*color[(2*2)], false)
	renderer_gradient(width / (1+1), height/(1+1) + offset, (1), initial_position - offset, color[(1)], color[(1+1)], color[(2+1)], alpha*color[(2*2)], color[(1)], color[(1+1)], color[(2+1)], (0), false)
	
	m_alpha = var_0_35(m_alpha + (act and FT or -FT), (0), (1))


end)

]]
__bundle["require/features/paint/damage"] = [[local var_0_166 = require("require/abc/menu_setup")
local damage_list = {}

local function var_0_137()
	local ref = var_0_166.ui.paint_hitmarker
	if not ref then return false end
	local sel = ui.get(ref)
	if type(sel) == "table" then
		for _, v in ipairs(sel) do
			if v == "damage" then return true end
		end
	end
	return false
end

client.set_event_callback('aim_hit', function(ev)
	if not var_0_137() then damage_list = {} return end
	if not var_0_137() then return end
	local me = entity.get_local_player()
	if not me then return end
	local target = ev.target or ev.target_index
	if type(target) ~= 'number' or target == (0) or not entity.is_enemy(target) then return end
	local dmg = ev.damage or (0)
	local hs = ev.hitgroup == (1) 
	local killed = ev.health == (0)
	local x, y, z = entity.hitbox_position(target, ev.hitgroup or 'head')
	if not x then x, y, z = entity.get_origin(target) end
	if not x then return end
	local var_0_173 = globals.realtime()
	local color = {(85*3), (85*3), (85*3)}
	if killed then color = {(31*7), (50*2), (50*2)} elseif hs then color = {(55*3), (101*2), (21*2)} end
	damage_list[#damage_list + (1)] = {dmg = dmg, x = x, y = y, z = z, t = var_0_173, color = color, base_y = nil}
	if #damage_list > (4*2) then table.remove(damage_list, (1)) end
end)

client.set_event_callback('paint', function()
	if var_0_137() then
		local var_0_173 = globals.realtime()
		local float_time = (1.4) 
		local max_float = (16*2) 
		local i = (1)
		while i <= #damage_list do
			if var_0_173 - (damage_list[i].t or (0)) > float_time then
				table.remove(damage_list, i)
			else
				i = i + (1)
			end
		end
		table.sort(damage_list, function(a, b) return (a.t or (0)) < (b.t or (0)) end)
		local start = math.max((1), #damage_list - (2*2))
		for j = start, #damage_list do
			local it = damage_list[j]
			local sx, sy = renderer.world_to_screen(it.x, it.y, it.z)
			if sx and sy then
				local age = var_0_173 - (it.t or (0))
				
				local progress = math.min((1), age / float_time)
				local float_y = max_float * ((1) - math.exp((-(2+1)) * progress)) 
				local alpha = math.floor(math.max((0), ((1) - progress) * (85*3)))
				if alpha > (0) then
					renderer.text(sx, sy - float_y, it.color[1], it.color[2], it.color[3], alpha, "crdb-", (0), tostring(it.dmg))
				end
			end
		end
	else
		damage_list = {}
	end
end)

]]
__bundle["require/features/paint/damage_penetration"] = [[
local function var_0_229(name, global_name)
	if global_name and rawget(_G, global_name) ~= nil then
		return rawget(_G, global_name)
	end
	local ok, lib = pcall(require, name)
	if ok then return lib end
	return nil
end

local ui       = var_0_229('ui', 'ui')
local client   = var_0_229('client', 'client')
local entity   = var_0_229('entity', 'entity')
local renderer = var_0_229('renderer', 'renderer')

if not ui or not client or not entity or not renderer then
	return
end

local ui_new_checkbox = ui.new_checkbox
local ui_get          = ui.get
local ui_reference    = ui.reference

local client_screen_size    = client.screen_size
local client_set_callback   = client.set_event_callback
local client_unset_callback = client.unset_event_callback
local client_eye_position   = client.eye_position
local client_camera_angles  = client.camera_angles
local client_trace_line     = client.trace_line
local client_trace_bullet   = client.trace_bullet

local entity_get_local_player = entity.get_local_player
local entity_is_alive         = entity.is_alive or function() return false end
local entity_get_weapon       = entity.get_player_weapon or function() return nil end
local entity_get_classname    = entity.get_classname or function() return nil end

local renderer_text = renderer.text

local math_floor = math.floor
local math_cos   = math.cos
local math_sin   = math.sin
local math_rad   = math.rad

sodium_SUPPRESS = sodium_SUPPRESS or false
sodium_REFS = sodium_REFS or {}
sodium_FN = sodium_FN or {}

local function var_0_34(ref)
	if not ref then return false end
	local ok, value = pcall(ui_get, ref)
	return ok and value == true
end


if type(sodium_FN.var_0_167) ~= 'function' then
	sodium_FN.var_0_167 = function()
		ensure_min_damage_refs()
		local hk = sodium_REFS.min_dmg_hotkey
		if hk then
			local ok, value = pcall(ui_get, hk)
			if ok then return value == true end
		end
		return false
	end
end

if type(sodium_FN.var_0_168) ~= 'function' then
	sodium_FN.var_0_168 = function()
		ensure_min_damage_refs()
		local slider = sodium_REFS.min_dmg_slider
		if not slider then return nil end
		local ok, value = pcall(ui_get, slider)
		if ok and type(value) == 'number' then
			return value
		end
		return nil
	end
end

local function var_0_214(key, builder)
	if sodium and sodium.ui and sodium.ui[key] then
		return sodium.ui[key]
	end
	local cache_key = 'ui_' .. key
	if sodium_REFS[cache_key] then
		return sodium_REFS[cache_key]
	end
	if not builder then return nil end
	local ref = builder()
	if ref then
		sodium_REFS[cache_key] = ref
	end
	return ref
end


local var_0_166 = nil
pcall(function() var_0_166 = require('require/abc/menu_setup') end)


local function var_0_280(player)
    if not ui.get(var_0_166.ui.paint_show_damage_penetration) then return end
	if not entity_get_weapon or not entity_get_classname then return false end
	local weapon = entity_get_weapon(player)
	if not weapon then return false end
	local cls = entity_get_classname(weapon)
	if not cls then return false end
	if cls:sub((1), (6+1)) ~= 'CWeapon' then return false end
	if cls:find('Grenade', (1), true) or cls:find('Taser', (1), true) or cls:find('C4', (1), true) then return false end
	return true
end

local function var_0_243()
    if not ui.get(var_0_166.ui.paint_show_damage_penetration) then return end
	if not entity_get_local_player then return nil end
	local me = entity_get_local_player()
	if not me then return nil end
	if entity_is_alive and not entity_is_alive(me) then return nil end
	return me
end




local function var_0_65()
    if not ui.get(var_0_166.ui.paint_show_damage_penetration) then return end
	local me = var_0_243()
	if not me or not var_0_280(me) then return end
	local ex, ey, ez = client_eye_position()
	if not ex or not ey or not ez then return end
	local pitch, yaw = client_camera_angles()
	if not pitch or not yaw then return end
	local cp, sp = math_cos(math_rad(pitch)), math_sin(math_rad(pitch))
	local cyw, syw = math_cos(math_rad(yaw)), math_sin(math_rad(yaw))
	local fx, fy, fz = cp * cyw, cp * syw, -sp
	local range = (4096*2)
	local tx, ty, tz = ex + fx * range, ey + fy * range, ez + fz * range
	local frac = select((1), client_trace_line(me, ex, ey, ez, tx, ty, tz)) or (1)
	if frac < (0) then frac = (0) end
	if frac > (1) then frac = (1) end

	local distances
	if frac >= (0.999) then
		distances = { (128*2), (256*2), (512*2), (1024*2), (2048*2) }
	else
		local entry = range * frac
		distances = { entry + (2*2), entry + (8*2), entry + (16*2), entry + (32*2), entry + (64*2), entry + (128*2) }
	end

	local best = (0)
	for i = (1), #distances do
		local dist = distances[i]
		if dist > range then dist = range end
		local dx, dy, dz = ex + fx * dist, ey + fy * dist, ez + fz * dist
		local _, dmg = client_trace_bullet(me, ex, ey, ez, dx, dy, dz, true)
		if dmg and dmg > best then best = dmg end
		if dist == range then break end
	end

	local dmg_val = math_floor((best or (0)) + (0.5))
	if dmg_val <= (0) then return end

	local sw, sh = client_screen_size()
	if not sw or not sh then return end
	local cx = sw / (1+1)
	local cy_top = sh / (1+1) + (4*2)
	local text = tostring(dmg_val)
	local drawn = false
	if sodium_FN.draw_surface_text_centered and _G.sodium_FONTS and _G.sodium_FONTS.pen then
		drawn = sodium_FN.draw_surface_text_centered(_G.sodium_FONTS.pen, cx, cy_top, text, (59*3), (97*2), (88+1), (85*3)) and true or false
	end
	if not drawn then
		renderer_text(cx, sh / (1+1) + (6*2), (59*3), (97*2), (88+1), (85*3), 'cb', (0), text)
	end
end

local function var_0_175()
    if not ui.get(var_0_166.ui.paint_show_damage_penetration) then return end
	if sodium_SUPPRESS then return end
	var_0_65()
end

local ok_cb, cb = pcall(require, "require/abc/callbacks")
if ok_cb and cb then
	if _G.sodium_B_MD_DP and type(_G.sodium_B_MD_DP) == 'number' then
		pcall(cb.unregister, _G.sodium_B_MD_DP)
	end

	local function var_0_184()
		if sodium_SUPPRESS then return end
        if not ui.get(var_0_166.ui.paint_show_damage_penetration) then return end
		var_0_65()
	end

	_G.sodium_B_MD_DP = cb.var_0_201('paint', var_0_184, { require_login = true, alive_only = true })
else
	if client_unset_callback and _G.sodium_B_MD_DP then
		client_unset_callback('paint', _G.sodium_B_MD_DP)
	end

	_G.sodium_B_MD_DP = var_0_175
	client_set_callback('paint', var_0_175)
end

]]
__bundle["require/features/paint/entidx"] = [[local var_0_166 = require("require/abc/menu_setup")
local enemies = require("require/help/enemies")

local function var_0_176()
	if not ui.get(var_0_166.ui.paint_entidx) then return end

	local threat_entidx = enemies.get_current_threat and enemies.get_current_threat() or client.current_threat and client.current_threat() or nil
	if threat_entidx and threat_entidx ~= (0) then
		local name = entity.get_player_name(threat_entidx)

		renderer.text(70, 120, 255, 0, 0, 255, "b", (0), string.format("entidx%d: %s", threat_entidx, name))
	end
end

client.set_event_callback("paint", var_0_176)]]
__bundle["require/features/paint/filter_console"] = [[


local var_0_166 = pcall(require, 'require/abc/menu_setup') and require('require/abc/menu_setup') or nil
local ui_handle = var_0_166 and var_0_166.ui and var_0_166.ui.paint_filter_console or nil

local con_filter_enable = cvar.con_filter_enable
local con_filter_text = cvar.con_filter_text

local saved = { enable = nil, text = nil }

local function var_0_232()
    if saved.enable == nil then
        
        local ok, v = pcall(function() return con_filter_enable:get_int() end)
        saved.enable = (ok and v) and v or nil
    end

    if saved.text == nil then
        local ok, t = pcall(function() return con_filter_text:get_string() end)
        saved.text = (ok and t) and t or nil
    end
end

local function var_0_216()
    if saved.enable ~= nil then
        pcall(function() con_filter_enable:set_raw_int(saved.enable) end)
    end

    if saved.text ~= nil then
        pcall(function() con_filter_text:set_string(saved.text) end)
    else
        pcall(function() con_filter_text:set_string('') end)
    end

    saved.enable = nil
    saved.text = nil
end

local function var_0_14()
    var_0_232()
    pcall(function() con_filter_enable:set_raw_int((1)) end)
    pcall(function() con_filter_text:set_string('[gamesense]') end)
end




local function var_0_121()
    if not ui_handle then
        return false
    end

    
    if type(ui_handle) == 'table' and ui_handle.get then
        local ok, v = pcall(function() return ui_handle:get() end)
        return ok and v or false
    end

    
    local ok, v = pcall(function() return ui.get(ui_handle) end)
    return ok and v or false
end

local function var_0_273()
    if not var_0_121() then
        var_0_216()
        return
    end

    var_0_14()
    client.delay_call(1, var_0_273)
end


client.delay_call(0.1, var_0_273)


client.set_event_callback('shutdown', var_0_216)

return {
    
    var_0_121 = var_0_121,
    var_0_216 = var_0_216,
    var_0_14 = var_0_14,
}
]]
__bundle["require/features/paint/hit_miss_indicator"] = [[local M=require("require/help/math")
local S=require("require/help/self")
local Safe=require("require/help/safe")
local MS=require("require/abc/menu_setup")

local hits,shots=(0),(0)
local var_0_71=function() return MS and MS.ui and Safe.var_0_222(MS.ui.paint_hitmiss_indicator) end
local var_0_208=function() hits,shots=(0),(0) end

client.set_event_callback("weapon_fire",function(e)
    if not var_0_71() or not S.is_alive() then return end
    if client.userid_to_entindex(e.userid)==S.index() then shots=shots+(1) end
end)

client.set_event_callback("player_hurt",function(e)
    if not var_0_71() or not S.is_alive() then return end
    if client.userid_to_entindex(e.attacker)==S.index() then hits=hits+(1) end
end)


client.set_event_callback("paint",function()
    if not var_0_71() then return end
    local pct=shots>(0) and M.var_0_221(hits/shots*(50*2),(1)) or (0)
    renderer.indicator(255,255,255,255,string.format("%d / %d (%.1f)",hits,shots,pct))
end)
defer(var_0_208)]]
__bundle["require/features/paint/hrisito_fix"] = [[


local target_tab, target_container = 'CONFIG', 'Presets'


local HIDE_NAMES = {
	'Hrisito mode',
	'Hrisito DVD',
	'Old ragebot tab',
	'Old skinchanger tab',
	'Nade icons',
	'Refresh all cosmetics',
	'Apply Hrisito skybox',
	'Remove nade background',
	'Remove nade timer',
	'Allow unstable features',
	'Original clantag spammer',
	'Show hidden features',
	'Fix cam_ideadist',
	'Doubletap recharge fix',
	'Safe point',
	'Anti-aim correction'
}


local TAB_VARIANTS = { 'CONFIG', 'Config' }


local SAFE_POINT_NAME = 'Safe point'
local SAFE_POINT_VALUE = 'Default'

local function var_0_70(tab, container, name, fn)
	local refs = { ui.reference(tab, container, name) }
	if #refs == (0) or (refs[(1)] == nil and #refs == (1)) then return false end
	for _, r in ipairs(refs) do
		if r ~= nil then fn(r) end
	end
	return true
end

local function var_0_132(tab, container, name)
	return var_0_70(tab, container, name, function(r)
		pcall(ui.set_visible, r, false)
	end)
end

local function var_0_240(tab, container)
	local applied = false
	var_0_70(tab, container, SAFE_POINT_NAME, function(r)
		
		local ok, cur = pcall(ui.get, r)
		if ok and cur ~= SAFE_POINT_VALUE then
			if pcall(ui.set, r, SAFE_POINT_VALUE) then
				applied = true
			end
		else
			applied = true 
		end
	end)

	
	
	do
		local a = select((1), ui.reference('RAGE', 'Aimbot', 'Prefer safe point'))
		if a ~= nil then pcall(ui.set, a, false) end
	end
	
	do
		local a = select((1), ui.reference('RAGE', 'Aimbot', 'Force safe point'))
		if a ~= nil then pcall(ui.set, a, false) end
	end
end

local function var_0_12()
	for _, tab in ipairs(TAB_VARIANTS) do
		for _, name in ipairs(HIDE_NAMES) do
			var_0_132(tab, target_container, name)
		end
		var_0_240(tab, target_container)

		
		for _, cont in ipairs({ 'Lua', 'LUA' }) do
			var_0_132(tab, cont, 'Allow scripts to open links')
		end
	end
end


var_0_12()


client.set_event_callback('paint_ui', function()
	var_0_12()
end)


client.set_event_callback('pre_render', function()
	
	if globals.framecount() < (300*2) then 
		var_0_12()
	end
end)

]]
__bundle["require/features/paint/indicators_bold"] = [[local indicator_offsets = { (0), (0), (0) }
local indicator_targets = { (2+1), (2+1), (2+1) }
local indicator_speeds = { (3*2), (3*2), (3*2) }

local function var_0_152(a, b, t)
  return a + (b - a) * t
end

local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
local string_ok, string_helper = pcall(require, "require/help/string")
local function var_0_261(s)
  if s == nil then return "" end
  if string_ok and string_helper and string_helper.lower then
    return string_helper.lower(tostring(s))
  end
  return tostring(s)
end
local function var_0_134()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_indicators then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_indicators)
    if ok and val == "bold" then return true end
    return false
  end

  return true
end

client.set_event_callback("paint", function()
  if not entity.is_alive(entity.get_local_player()) then return end
  if not var_0_134() then return end

  local sw, sh = client.screen_size()
  local cx, cy = sw / (1+1), sh / (1+1)

  local title_r, title_g, title_b = (100*2), (100*2), (85*3)
  local text_r, text_g, text_b = (85*3), (85*3), (85*3)
  local line_h = (9*2)

  local line_hs = { (6*2), (6*2) }

  local y = cy + (9*2)

  
  local local_player = entity.get_local_player()
  local is_scoped = false
  if local_player then
    local scoped_prop = entity.get_prop(local_player, "m_bIsScoped")
    is_scoped = scoped_prop == (1)
  end

  local title_text = "sodium beta"
  local dt_text_draw = "DT"

  local dt_active = false
  do
    local ok, libs = pcall(require, "require/help/libs")
    if ok and libs and libs.get then
      local aa = libs.get("antiaim_funcs")
      if aa and aa.get_double_tap then
        local success, result = pcall(aa.get_double_tap)
        if success and result then dt_active = true end
      end
    end
  end

  local w1 = renderer.measure_text("b", title_text) or (0)
  local w2 = renderer.measure_text("b", dt_text_draw) or (0)

  local cond_text = ""
  do
    local ok, pc = pcall(require, "require/aa/player_condition")
    if ok and pc and pc.get then
      local success, cond = pcall(pc.get)
      if success and cond then
        local map = {
          var_0_149 = "Legit",
          fakelag = "Fakelag",
          walk = "Walk",
          move = "Move",
          stand = "Stand",
          ["duck"] = "Duck",
          ["duck+"] = "Duck+",
          jump = "Jump",
          ["jump+"] = "Jump+"
        }
        cond_text = map[cond] or tostring(cond)
        cond_text = var_0_261(cond_text)
      end
    end
  end

  title_text = var_0_261(title_text)
  dt_text_draw = var_0_261(dt_text_draw)
  local w3 = renderer.measure_text("b", cond_text) or (0)

  for i = (1), (2+1) do
    local w = (i == (1)) and w1 or ((i == (1+1)) and w2 or w3)
    local margin = indicator_targets[i] or (0)
    local target = is_scoped and (margin + (w / (1+1))) or (0)
    local speed = indicator_speeds[i] or (5*2)
    local dt = globals.frametime()
    local t = (1) - math.exp(-speed * dt)
    indicator_offsets[i] = var_0_152(indicator_offsets[i], target, t)
  end

  local base_x1 = cx - (w1 / (1+1))
  local draw_x1 = base_x1 + (indicator_offsets[(1)] or (0))
  renderer.text(draw_x1, y, title_r, title_g, title_b, 255, "b", (0), title_text)
  y = y + (line_hs[(1)] or line_h)

  local base_x2 = cx - (w2 / (1+1))
  local draw_x2 = base_x2 + (indicator_offsets[(1+1)] or (0))
  local dt_r, dt_g, dt_b = (85*3), (40*2), (40*2)
  if dt_active then dt_r, dt_g, dt_b = (31*5), (85*3), (31*5) end
  renderer.text(draw_x2, y, dt_r, dt_g, dt_b, 255, "b", (0), dt_text_draw)
  y = y + (line_hs[(1+1)] or line_h)

  local base_x3 = cx - (w3 / (1+1))
  local draw_x3 = base_x3 + (indicator_offsets[(2+1)] or (0))
  renderer.text(draw_x3, y, text_r, text_g, text_b, 255, "b", (0), cond_text)
end)]]
__bundle["require/features/paint/indicators_small"] = [[local indicator_offsets = { (0), (0) }
local indicator_targets = { (2*2), (1+1) }
local indicator_speeds = { (4+1), (4+1) }

local function var_0_152(a, b, t)
  return a + (b - a) * t
end

local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
local string_ok, string_helper = pcall(require, "require/help/string")
local function var_0_262(s)
  if s == nil then return "" end
  if string_ok and string_helper and string_helper.upper then
    return string_helper.upper(tostring(s))
  end
  return tostring(s)
end

local var_0_218 = function(r,g,b,a) return string.format("\a%02x%02x%02x%02x", r,g,b,a or (85*3)) end
local function var_0_9(speed, r,g,b,a, text)
  local t = globals.realtime() or globals.curtime()
  if not text or #text == (0) then return "" end
  local out = {}
  for i=(1),#text do
    local f = (math.sin(t*speed - i*(0.35)) + (1)) * (0.5)
    local la = math.floor(a * ((0.4) + (0.6) * f))
    out[#out+(1)] = var_0_218(r,g,b,la) .. text:sub(i,i)
  end
  return table.concat(out)
end
local function var_0_134()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_indicators then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_indicators)
    if ok and val == "small" then return true end
    return false
  end

  return true
end

client.set_event_callback("paint", function()
  if not entity.is_alive(entity.get_local_player()) then return end
  if not var_0_134() then return end

  local sw, sh = client.screen_size()
  local cx, cy = sw / (1+1), sh / (1+1)

  local title_r, title_g, title_b = (100*2), (100*2), (85*3)
  local text_r, text_g, text_b = (85*3), (85*3), (85*3)
  local line_h = (9*2)

  local line_hs = { (6*2), (6*2) }

  local y = cy + (9*2)

  
  local local_player = entity.get_local_player()
  local is_scoped = false
  if local_player then
    local scoped_prop = entity.get_prop(local_player, "m_bIsScoped")
    is_scoped = scoped_prop == (1)
  end

  local title_main = "sodium"
  local title_suffix = "beta"
  local dt_text_draw = "DT"

  local dt_active = false
  do
    local ok, libs = pcall(require, "require/help/libs")
    if ok and libs and libs.get then
      local aa = libs.get("antiaim_funcs")
      if aa and aa.get_double_tap then
        local success, result = pcall(aa.get_double_tap)
        if success and result then dt_active = true end
      end
    end
  end

  local title_text_up = var_0_262(title_main)
  local title_suffix_up = var_0_262(title_suffix)
  title_text_up = tostring(title_text_up)
  title_suffix_up = tostring(title_suffix_up)
  local w1 = renderer.measure_text("b", title_text_up) or (0)
  local w_suf = renderer.measure_text("b", title_suffix_up) or (0)

  dt_text_draw = var_0_262(dt_text_draw)
  local w2 = renderer.measure_text("b", dt_text_draw) or (0)

  for i = (1), (1+1) do
    local w = (i == (1)) and w1 or w2
    local margin = indicator_targets[i] or (0)
    local target = is_scoped and (margin + (w / (1+1))) or (0)
    local speed = indicator_speeds[i] or (5*2)
    local dt = globals.frametime()
    local t = (1) - math.exp(-speed * dt)
    indicator_offsets[i] = var_0_152(indicator_offsets[i], target, t)
  end

  local spacing = (4.5)
  local base_x1 = cx - ((w1 + spacing + (w_suf or (0))) / (1+1))
  local draw_x1 = base_x1 + (indicator_offsets[(1)] or (0))
  local desired_gap = (11*2)
  local gap_diff = desired_gap - spacing
  local shift1 = math.floor((gap_diff + (1)) / (1+1))
  local shift2 = gap_diff - shift1
  local main_shift = shift1 
  local suf_shift = -shift2 

  local mr, mg, mb, ma = title_r, title_g, title_b, (85*3)
  do
    local ok_ref, ref = pcall(function() return ui.reference('misc', 'settings', 'menu color') end)
    if ok_ref and ref then
      local ok_get, a, b, c, d = pcall(ui.get, ref)
      if ok_get then
        if type(a) == 'number' then
          mr = math.floor(a or mr)
          mg = math.floor(b or mg)
          mb = math.floor(c or mb)
          ma = math.floor(d or ma)
        elseif type(a) == 'string' and #a == (6*2) then
          local ok
          ok, mr = pcall(function() return tonumber(a:sub((1),(2+1))) end)
          ok, mg = pcall(function() return tonumber(a:sub((2*2),(3*2))) end)
          ok, mb = pcall(function() return tonumber(a:sub((6+1),(3*3))) end)
          ok, ma = pcall(function() return tonumber(a:sub((5*2),(6*2))) end)
          mr = mr or title_r; mg = mg or title_g; mb = mb or title_b; ma = ma or (85*3)
        end
      end
    end
  end

  local anim_main = var_0_9((3.5), (85*3),(85*3),(85*3),(85*3), title_text_up)
  local anim_suf = var_0_9((3.5), mr, mg, mb, ma, title_suffix_up)
  local draw_main_x = draw_x1 + (main_shift or (0))
  local scoped_extra = is_scoped and (2+1) or (0)
  draw_main_x = draw_main_x + scoped_extra
  renderer.text(draw_main_x, y, 255,255,255,255, "-", (0), anim_main)
  local sx = draw_x1 + (w1 or (0)) + spacing
  local draw_suf_x = sx + (suf_shift or (0)) + scoped_extra
  renderer.text(draw_suf_x, y, mr, mg, mb, ma, "-", (0), anim_suf)
  y = y + (line_hs[(1)] or line_h)

  local base_x2 = cx - (w2 / (1+1))
  local draw_x2 = base_x2 + (indicator_offsets[(1+1)] or (0))
  local dt_r, dt_g, dt_b = (85*3), (40*2), (40*2)
  if dt_active then dt_r, dt_g, dt_b = (31*5), (85*3), (31*5) end
  renderer.text(draw_x2, y, dt_r, dt_g, dt_b, 255, "-", (0), dt_text_draw)
  y = y + (line_hs[(1+1)] or line_h)

end)]]
__bundle["require/features/paint/insults"] = [[




local client = client
local entity = entity
local ui = ui

local var_0_166 = require("require/abc/menu_setup")


local kill_insults = {
    "russian palettet has been beaten by chinese warriorZ",
    "the human force within, the shell. No shall overcome",
    "Sun shine bright in the sky like big fireball.",
    "Bananas slip and fall down, but they happy.",
    "Clocks tick-tock but never stop, like rabbit run fast.",
    "Ocean deep blue, like endless story of fish.",
    "Birds sing tweet-tweet, like radio with broken tune.",
    "Moon hide behind cloud, play peek-a-boo with stars.",
    "Trees tall like giants, wave to clouds with leafy hands.",
    "Butterflies dance in air, like colorful leaves in wind.",
    "Books have many word, but sometimes say nothing.",
    "Raindrops fall soft, like whispers from sky.",
    "Shadows long and dark, play hide-and-seek with light.",
    "Cats purr loud, like tiny motor in furry body.",
        "ᴍᴏᴏɴ ʙɪɢ, ʀᴏᴜɴᴅ, ʟɪᴋᴇ ᴄʜᴇᴇꜱᴇ ɪɴ ꜱᴋʏ.",
        "ᴡᴀᴛᴇʀ ᴡᴇᴛ, ʟɪᴋᴇ ꜰɪꜱʜ ɪɴ ᴏᴄᴇᴀɴ.",
        "ꜱᴛᴀʀꜱ ᴛᴡɪɴᴋʟᴇ, ʙʟɪɴᴋ-ʙʟɪɴᴋ, ʟɪᴋᴇ ᴇʏᴇꜱ ᴏꜰ ɴɪɢʜᴛ.",
        "ᴄʟᴏᴜᴅꜱ ꜰʟᴜꜰꜰʏ, ꜱᴏꜰᴛ, ʟɪᴋᴇ ᴘɪʟʟᴏᴡꜱ ɪɴ ʜᴇᴀᴠᴇɴ.",
        "ᴡɪɴᴅ ʙʟᴏᴡ ꜱᴛʀᴏɴɢ, ᴡʜɪꜱᴛʟᴇ ᴛʜʀᴏᴜɢʜ ᴛʀᴇᴇꜱ.",
        "ꜰɪʀᴇ ʜᴏᴛ, ᴡᴀʀᴍ, ʟɪᴋᴇ ʜᴜɢ ꜰʀᴏᴍ ꜱᴜɴ.",
        "ʀᴀɪɴᴅʀᴏᴘꜱ ꜰᴀʟʟ, ᴘɪᴛᴛᴇʀ-ᴘᴀᴛᴛᴇʀ, ʟɪᴋᴇ ᴛɪɴʏ ᴅᴀɴᴄᴇʀꜱ.",
        "ᴍᴏᴜɴᴛᴀɪɴꜱ ᴛᴀʟʟ, ʜɪɢʜ, ʟɪᴋᴇ ᴛᴏᴡᴇʀꜱ ᴏꜰ ᴇᴀʀᴛʜ.",
        "ɢʀᴀꜱꜱ ɢʀᴇᴇɴ, ʟᴜꜱʜ, ʟɪᴋᴇ ᴄᴀʀᴘᴇᴛ ꜰᴏʀ ʙᴜɢꜱ.",
        "ꜱɴᴏᴡꜰʟᴀᴋᴇꜱ ᴄᴏʟᴅ, ɪᴄʏ, ʟɪᴋᴇ ᴋɪꜱꜱᴇꜱ ꜰʀᴏᴍ ᴡɪɴᴛᴇʀ.",
        "ʙɪʀᴅꜱ ᴄʜɪʀᴘ ʟᴏᴜᴅ, ꜱɪɴɢ ꜱᴏɴɢꜱ ᴏꜰ ᴍᴏʀɴɪɴɢ.",
        "ᴛʀᴇᴇꜱ ꜱᴡᴀʏ ɢᴇɴᴛʟᴇ, ᴅᴀɴᴄᴇ ᴛᴏ ʀʜʏᴛʜᴍ ᴏꜰ ʙʀᴇᴇᴢᴇ.",
        "ᴏᴄᴇᴀɴ ᴡᴀᴠᴇꜱ ᴄʀᴀꜱʜ, ʀᴏᴀʀ, ʟɪᴋᴇ ʟɪᴏɴ ᴏꜰ ꜱᴇᴀ.",
        "ꜰʟᴏᴡᴇʀꜱ ʙʟᴏᴏᴍ ʙʀɪɢʜᴛ, ᴄᴏʟᴏʀꜰᴜʟ, ʟɪᴋᴇ ʀᴀɪɴʙᴏᴡ ɪɴ ɢᴀʀᴅᴇɴ.",
        "ꜱᴜɴʀɪꜱᴇ ᴘᴀɪɴᴛ ꜱᴋʏ, ᴏʀᴀɴɢᴇ, ᴘɪɴᴋ, ʟɪᴋᴇ ᴄᴀɴᴠᴀꜱ ᴏꜰ ᴅᴀᴡɴ.",
        "ʙᴜᴛᴛᴇʀꜰʟɪᴇꜱ ꜰʟᴜᴛᴛᴇʀ, ꜰʟɪᴛ-ꜰʟɪᴛ, ʟɪᴋᴇ ᴘᴇᴛᴀʟꜱ ᴏɴ ᴀɪʀ.",
        "ᴍᴏᴏɴʟɪɢʜᴛ ꜱʜɪɴᴇ ꜱᴏꜰᴛ, ꜱɪʟᴠᴇʀ, ʟɪᴋᴇ ʙʟᴀɴᴋᴇᴛ ᴏᴠᴇʀ ᴡᴏʀʟᴅ.",
        "ʀᴀɪɴʙᴏᴡ ᴀʀᴄʜ ʜɪɢʜ, ᴀʀᴄ ᴏꜰ ᴄᴏʟᴏʀꜱ ɪɴ ꜱᴋʏ.",
        "ᴛʜᴜɴᴅᴇʀ ʀᴜᴍʙʟᴇ ᴅᴇᴇᴘ, ᴇᴄʜᴏ ɪɴ ᴄʟᴏᴜᴅꜱ.",
        "ꜱᴜɴꜱᴇᴛ ᴘᴀɪɴᴛ ꜱᴋʏ, ʀᴇᴅ, ɢᴏʟᴅ, ʟɪᴋᴇ ꜰɪʀᴇ ɪɴ ʜᴏʀɪᴢᴏɴ.",
        "ꜱᴛᴀʀꜱ ꜱᴘᴀʀᴋʟᴇ, ɢʟɪᴍᴍᴇʀ, ʟɪᴋᴇ ᴅɪᴀᴍᴏɴᴅꜱ ɪɴ ᴅᴀʀᴋ.",
        "ᴄʟᴏᴜᴅꜱ ᴅʀɪꜰᴛ ꜱʟᴏᴡ, ʟᴀᴢʏ, ʟɪᴋᴇ ᴅʀᴇᴀᴍꜱ ɪɴ ꜱᴋʏ.",
        "ᴡɪɴᴅ ᴡʜɪꜱᴘᴇʀ ꜱᴇᴄʀᴇᴛꜱ, ᴛᴀʟᴇꜱ ᴏꜰ ᴀɴᴄɪᴇɴᴛ ᴛɪᴍᴇ.",
        "ꜰɪʀᴇꜰʟɪᴇꜱ ɢʟᴏᴡ ʙʀɪɢʜᴛ, ʟɪɢʜᴛ ᴜᴘ ɴɪɢʜᴛ ᴡɪᴛʜ ᴍᴀɢɪᴄ.",
        "ʀᴀɪɴᴅʀᴏᴘꜱ ᴅʀɪᴘ ᴅᴏᴡɴ, ᴛᴀᴘ-ᴛᴀᴘ, ʟɪᴋᴇ ꜰɪɴɢᴇʀꜱ ᴏɴ ʀᴏᴏꜰ.",
        "ᴍᴏᴜɴᴛᴀɪɴꜱ ꜱᴛᴀɴᴅ ꜱᴛʀᴏɴɢ, ꜱɪʟᴇɴᴛ, ʟɪᴋᴇ ɢᴜᴀʀᴅɪᴀɴꜱ ᴏꜰ ᴇᴀʀᴛʜ.",
        "ɢʀᴀꜱꜱʜᴏᴘᴘᴇʀꜱ ʜᴏᴘ ʜɪɢʜ, ʟᴇᴀᴘ ᴛʜʀᴏᴜɢʜ ꜰɪᴇʟᴅꜱ.",
        "ꜱɴᴏᴡꜰʟᴀᴋᴇꜱ ꜰᴀʟʟ ꜱᴏꜰᴛ, ꜱɪʟᴇɴᴛ, ʟɪᴋᴇ ᴡʜɪꜱᴘᴇʀꜱ ᴏꜰ ᴡɪɴᴛᴇʀ.",
        "ʙɪʀᴅꜱ ꜰʟᴏᴄᴋ ᴛᴏɢᴇᴛʜᴇʀ, ꜰʟʏ ᴛʜʀᴏᴜɢʜ ᴇɴᴅʟᴇꜱꜱ ꜱᴋʏ.",
        "ᴛʀᴇᴇꜱ ʀᴜꜱᴛʟᴇ ʟᴇᴀᴠᴇꜱ, ᴡʜɪꜱᴘᴇʀ ꜱᴇᴄʀᴇᴛꜱ ᴛᴏ ᴡɪɴᴅ.",
        "ᴏᴄᴇᴀɴ ᴡᴀᴠᴇꜱ ʀᴏʟʟ, ᴄʀᴀꜱʜ ᴀɢᴀɪɴꜱᴛ ꜱʜᴏʀᴇ.",
        "ꜰʟᴏᴡᴇʀꜱ ʙʟᴏᴏᴍ ꜱᴡᴇᴇᴛ, ꜱᴄᴇɴᴛ ᴏꜰ ꜱᴘʀɪɴɢ ɪɴ ᴀɪʀ.",
        "ꜱᴜɴʀɪꜱᴇ ʙʀɪɴɢ ʟɪɢʜᴛ, ᴄʜᴀꜱᴇ ᴀᴡᴀʏ ᴅᴀʀᴋ ᴏꜰ ɴɪɢʜᴛ.",
        "ʙᴜᴛᴛᴇʀꜰʟɪᴇꜱ ɢʟɪᴅᴇ ɢʀᴀᴄᴇꜰᴜʟ, ᴅᴀɴᴄᴇ ᴛʜʀᴏᴜɢʜ ɢᴀʀᴅᴇɴ.",
        "ᴍᴏᴏɴʟɪɢʜᴛ ʙᴀᴛʜᴇ ᴡᴏʀʟᴅ, ɪɴ ꜱᴏꜰᴛ ꜱɪʟᴠᴇʀ ɢʟᴏᴡ.",
        "ʀᴀɪɴʙᴏᴡ ꜱᴘᴀɴ ᴡɪᴅᴇ, ʙʀɪᴅɢᴇ ʙᴇᴛᴡᴇᴇɴ ᴇᴀʀᴛʜ ᴀɴᴅ ꜱᴋʏ.",
        "ᴛʜᴜɴᴅᴇʀ ʙᴏᴏᴍ ʟᴏᴜᴅ, ꜱʜᴀᴋᴇ ᴡᴏʀʟᴅ ᴡɪᴛʜ ᴘᴏᴡᴇʀ.",
        "Ｓｕｎｓｅｔ ｐａｉｎｔ ｃｌｏｕｄｓ, ｐｉｎｋ, ｐｕｒｐｌｅ, ｌｉｋｅ ｃａｎｖａｓ ｉｎ ｓｋｙ．",
        "Ｓｔａｒｓ ｔｗｉｎｋｌｅ ｂｒｉｇｈｔ, ｓｈｉｎｅ ｄｏｗｎ ｏｎ Ｅａｒｔｈ．",
        "Ｃｌｏｕｄｓ ｇａｔｈｅｒ ｄａｒｋ, ｃｏｖｅｒ ｓｋｙ ｉｎ ｓｈａｄｏｗ．",
        "Ｗｉｎｄ ｂｌｏｗ ｆｉｅｒｃｅ, ｈｏｗｌ ｔｈｒｏｕｇｈ ｎｉｇｈｔ．",
        "Ｆｉｒｅｆｌｉｅｓ ｄａｎｃｅ, ｆｌｉｃｋｅｒ ｌｉｋｅ ｔｉｎｙ ｆｌａｍｅｓ．",
        "Ｒａｉｎｄｒｏｐｓ ｐａｔｔｅｒ ｓｏｆｔ, ｔａｐ－ｔａｐ ｏｎ ｗｉｎｄｏｗ ｐａｎｅ．",
        "Ｍｏｕｎｔａｉｎｓ ｒｅａｃｈ ｈｉｇｈ, ｔｏｕｃｈ ｓｋｙ ｗｉｔｈ ｐｅａｋ．",
        "Ｇｒａｓｓ ｓｗａｙ ｇｅｎｔｌｅ, ｉｎ ｂｒｅｅｚｅ ｏｆ ｓｕｍｍｅｒ．",
        "Ｓｎｏｗｆｌａｋｅｓ ｄｒｉｆｔ ｄｏｗｎ, ｂｌａｎｋｅｔ ｗｏｒｌｄ ｉｎ ｗｈｉｔｅ．",
        "Ｂｉｒｄｓ ｓｉｎｇ ｓｗｅｅｔ, ｍｅｌｏｄｙ ｏｆ ｍｏｒｎｉｎｇ．",
        "Ｔｒｅｅｓ ｒｅａｃｈ ｔａｌｌ, ｓｔｒｅｔｃｈ ｔｏｗａｒｄｓ ｓｕｎ．",
        "Ｏｃｅａｎ ｗａｖｅｓ ｃｒａｓｈ, ｒｏａｒ ｌｉｋｅ ｔｈｕｎｄｅｒ．",
        "Ｆｌｏｗｅｒｓ ｂｌｏｏｍ ｖｉｂｒａｎｔ, ｂｕｒｓｔ ｗｉｔｈ ｃｏｌｏｒ．",
        "Ｓｕｎｒｉｓｅ ｐａｉｎｔ ｓｋｙ, ｉｎ ｓｈａｄｅｓ ｏｆ ｄａｗｎ．",
        "Ｂｕｔｔｅｒｆｌｉｅｓ ｆｌｕｔｔｅｒ ｂｙ, ｌｉｋｅ ｃｏｎｆｅｔｔｉ ｉｎ ａｉｒ．",
        "Ｍｏｏｎｌｉｇｈｔ ｂａｔｈｅ ｗｏｒｌｄ, ｉｎ ｓｏｆｔ ｓｉｌｖｅｒ ｇｌｏｗ．",
        "Ｒａｉｎｂｏｗ ａｒｃｈ ｈｉｇｈ, ｂｒｉｄｇｅ ｂｅｔｗｅｅｎ ｓｋｙ ａｎｄ Ｅａｒｔｈ．",
        "Ｔｈｕｎｄｅｒ ｒｕｍｂｌｅ ｄｅｅｐ, ｅｃｈｏ ｔｈｒｏｕｇｈ ｃｌｏｕｄｓ．",
        "Ｓｕｎｓｅｔ ｐａｉｎｔ ｓｋｙ, ｉｎ ｈｕｅｓ ｏｆ ｅｖｅｎｉｎｇ．",
        "Ｓｔａｒｓ ｔｗｉｎｋｌｅ ｂｒｉｇｈｔ, ｌｉｇｈｔ ｕｐ ｎｉｇｈｔ ｓｋｙ．",
        "Ｃｌｏｕｄｓ ｄｒｉｆｔ ｓｌｏｗ, ｌｉｋｅ ｓｈｉｐｓ ｏｎ ｈｏｒｉｚｏｎ．",
        "Ｗｉｎｄ ｗｈｉｓｐｅｒ ｓｏｆｔ, ｓｅｃｒｅｔｓ ｏｆ ｓｋｙ．",
        "Ｆｉｒｅｆｌｉｅｓ ｆｌｉｃｋｅｒ ｂｒｉｇｈｔ, ｌｉｇｈｔ ｕｐ ｎｉｇｈｔ ｗｉｔｈ ｍａｇｉｃ．",
        "Ｒａｉｎｄｒｏｐｓ ｆａｌｌ ｓｏｆｔ, ｔａｐ－ｔａｐ ｏｎ ｗｉｎｄｏｗ ｓｉｌｌ．",
        "Ｍｏｕｎｔａｉｎｓ ｓｔａｎｄ ｓｔｒｏｎｇ, ａｇａｉｎｓｔ ｔｅｓｔ ｏｆ ｔｉｍｅ．",
        "Ｇｒａｓｓ ｓｗａｙ ｇｅｎｔｌｅ, ｉｎ ｒｈｙｔｈｍ ｏｆ ｗｉｎｄ．",
        "Ｓｎｏｗｆｌａｋｅｓ ｆａｌｌ ｌｉｇｈｔ, ｂｌａｎｋｅｔ ｗｏｒｌｄ ｉｎ ｗｈｉｔｅ．",
        "Ｂｉｒｄｓ ｓｉｎｇ ｓｗｅｅｔ, ｓｅｒｅｎａｄｅ ｏｆ ｍｏｒｎｉｎｇ．",
        "Ｔｒｅｅｓ ｒｕｓｔｌｅ ｌｅａｖｅｓ, ｉｎ ｗｈｉｓｐｅｒ ｏｆ ｗｉｎｄ．",
        "Ｏｃｅａｎ ｗａｖｅｓ ｃｒａｓｈ, ａｇａｉｎｓｔ ｒｏｃｋｓ ｏｆ ｓｈｏｒｅ．",
        "Ｆｌｏｗｅｒｓ ｂｌｏｏｍ ｂｒｉｇｈｔ, ｌｉｋｅ ｆｉｒｅｗｏｒｋｓ ｉｎ ｓｋｙ．",
        "Ｓｕｎｒｉｓｅ ｐａｉｎｔ ｓｋｙ, ｉｎ ｐａｌｅｔｔｅ ｏｆ ｄａｗｎ．",
        "Ｂｕｔｔｅｒｆｌｉｅｓ ｆｌｕｔｔｅｒ ｂｙ, ｉｎ ｄａｎｃｅ ｏｆ ｓｐｒｉｎｇ．",
        "Ｍｏｏｎｌｉｇｈｔ ｂａｔｈｅ ｗｏｒｌｄ, ｉｎ ｇｌｏｗ ｏｆ ｎｉｇｈｔ．",
        "Ｒａｉｎｂｏｗ ａｒｃｈ ｈｉｇｈ, ｉｎ ａｒｃ ｏｆ ｃｏｌｏｒｓ．",
        "Ｔｈｕｎｄｅｒ ｒｕｍｂｌｅ ｌｏｕｄ, ｓｈａｋｅ ｗｏｒｌｄ ｗｉｔｈ ｐｏｗｅｒ．",
        "Ｓｕｎｓｅｔ ｐａｉｎｔ ｓｋｙ, ｉｎ ｃａｎｖａｓ ｏｆ ｅｖｅｎｉｎｇ．",
        "Ｓｔａｒｓ ｔｗｉｎｋｌｅ ｂｒｉｇｈｔ, ｉｎ ｔａｐｅｓｔｒｙ ｏｆ ｎｉｇｈｔ．",
        "Ｃｌｏｕｄｓ ｄｒｉｆｔ ｓｌｏｗ, ｉｎ ｓｅａ ｏｆ ｓｋｙ．",
        "Ｗｉｎｄ ｗｈｉｓｐｅｒ ｓｏｆｔ, ｔｈｒｏｕｇｈ ｔｒｅｅｓ ｏｆ ｆｏｒｅｓｔ．",
        "Ｆｉｒｅｆｌｉｅｓ ｆｌｉｃｋｅｒ ｂｒｉｇｈｔ, ｌｉｋｅ ｓｔａｒｓ ｏｎ ｇｒｏｕｎｄ．",
        "Ｒａｉｎｄｒｏｐｓ ｆａｌｌ ｓｏｆｔ, ｌｉｋｅ ｔｅａｒｓ ｆｒｏｍ ｓｋｙ．",
        "Ｍｏｕｎｔａｉｎｓ ｓｔａｎｄ ｔａｌｌ, ｌｉｋｅ ｐｉｌｌａｒｓ",
        "ꜱᴜɴ ʏᴇʟʟᴏᴡ, ꜱʜɪɴᴇ ʙʀɪɢʜᴛ, ʟɪᴋᴇ ʜᴀᴘᴘʏ ꜰᴀᴄᴇ ɪɴ ꜱᴋʏ.",
        "ᴍᴏᴏɴ ᴡʜɪᴛᴇ, ɢʟᴏᴡ ꜱᴏꜰᴛ, ʟɪᴋᴇ ꜰʀɪᴇɴᴅ ɪɴ ɴɪɢʜᴛ.",
        "ꜱᴛᴀʀꜱ ꜱᴘᴀʀᴋʟᴇ, ᴛᴡɪɴᴋʟᴇ-ᴛᴡɪɴᴋᴇ, ʟɪᴋᴇ ᴇʏᴇꜱ ᴏꜰ ᴜɴɪᴠᴇʀꜱᴇ.",
        "ᴄʟᴏᴜᴅꜱ ꜰʟᴜꜰꜰʏ, ꜰʟᴏᴀᴛ ʜɪɢʜ, ʟɪᴋᴇ ᴘɪʟʟᴏᴡꜱ ᴏꜰ ʜᴇᴀᴠᴇɴ.",
        "ᴡɪɴᴅ ʙʟᴏᴡ ꜱᴛʀᴏɴɢ, ᴡʜɪꜱᴛʟᴇ ᴛʜʀᴏᴜɢʜ ᴛʀᴇᴇꜱ.",
        "ꜰɪʀᴇ ᴡᴀʀᴍ, ɢʟᴏᴡ ʀᴇᴅ, ʟɪᴋᴇ ʜᴇᴀʀᴛ ᴏꜰ ᴇᴀʀᴛʜ.",
        "ʀᴀɪɴᴅʀᴏᴘꜱ ꜰᴀʟʟ, ᴘɪᴛᴛᴇʀ-ᴘᴀᴛᴛᴇʀ, ʟɪᴋᴇ ᴛɪɴʏ ᴅᴀɴᴄᴇʀꜱ.",
        "ᴍᴏᴜɴᴛᴀɪɴꜱ ᴛᴀʟʟ, ꜱᴛᴀɴᴅ ᴘʀᴏᴜᴅ, ʟɪᴋᴇ ɢᴜᴀʀᴅɪᴀɴꜱ ᴏꜰ ʟᴀɴᴅ.",
        "ɢʀᴀꜱꜱ ɢʀᴇᴇɴ, ɢʀᴏᴡ ᴛᴀʟʟ, ʟɪᴋᴇ ᴄᴀʀᴘᴇᴛ ᴏꜰ ɴᴀᴛᴜʀᴇ.",
        "ꜱɴᴏᴡꜰʟᴀᴋᴇꜱ ᴄᴏʟᴅ, ᴅʀɪꜰᴛ ᴅᴏᴡɴ, ʟɪᴋᴇ ᴋɪꜱꜱᴇꜱ ꜰʀᴏᴍ ᴡɪɴᴛᴇʀ.",
        "ʙɪʀᴅꜱ ᴄʜɪʀᴘ ʟᴏᴜᴅ, ꜱɪɴɢ ꜱᴏɴɢꜱ ᴏꜰ ᴍᴏʀɴɪɴɢ.",
        "ᴛʀᴇᴇꜱ ꜱᴡᴀʏ ɢᴇɴᴛʟᴇ, ᴅᴀɴᴄᴇ ᴛᴏ ʀʜʏᴛʜᴍ ᴏꜰ ʙʀᴇᴇᴢᴇ.",
        "ᴏᴄᴇᴀɴ ᴡᴀᴠᴇꜱ ᴄʀᴀꜱʜ, ʀᴏᴀʀ, ʟɪᴋᴇ ʟɪᴏɴ ᴏꜰ ꜱᴇᴀ.",
        "ꜰʟᴏᴡᴇʀꜱ ʙʟᴏᴏᴍ ʙʀɪɢʜᴛ, ᴄᴏʟᴏʀꜰᴜʟ, ʟɪᴋᴇ ʀᴀɪɴʙᴏᴡ ɪɴ ɢᴀʀᴅᴇɴ.",
        "ꜱᴜɴʀɪꜱᴇ ᴘᴀɪɴᴛ ꜱᴋʏ, ᴏʀᴀɴɢᴇ, ᴘɪɴᴋ, ʟɪᴋᴇ ᴄᴀɴᴠᴀꜱ ᴏꜰ ᴅᴀᴡɴ.",
        "ʙᴜᴛᴛᴇʀꜰʟɪᴇꜱ ꜰʟᴜᴛᴛᴇʀ, ꜰʟɪᴛ-ꜰʟɪᴛ, ʟɪᴋᴇ ᴘᴇᴛᴀʟꜱ ᴏɴ ᴀɪʀ.",
        "ᴍᴏᴏɴʟɪɢʜᴛ ꜱʜɪɴᴇ ꜱᴏꜰᴛ, ꜱɪʟᴠᴇʀ, ʟɪᴋᴇ ʙʟᴀɴᴋᴇᴛ ᴏᴠᴇʀ ᴡᴏʀʟᴅ.",
        "ʀᴀɪɴʙᴏᴡ ᴀʀᴄʜ ʜɪɢʜ, ᴀʀᴄ ᴏꜰ ᴄᴏʟᴏʀꜱ ɪɴ ꜱᴋʏ.",
        "ᴛʜᴜɴᴅᴇʀ ʀᴜᴍʙʟᴇ ᴅᴇᴇᴘ, ᴇᴄʜᴏ ɪɴ ᴄʟᴏᴜᴅꜱ.",
        "ꜱᴜɴꜱᴇᴛ ᴘᴀɪɴᴛ ꜱᴋʏ, ʀᴇᴅ, ɢᴏʟᴅ, ʟɪᴋᴇ ꜰɪʀᴇ ɪɴ ʜᴏʀɪᴢᴏɴ.",
        "ꜱᴛᴀʀꜱ ꜱᴘᴀʀᴋʟᴇ, ɢʟɪᴍᴍᴇʀ, ʟɪᴋᴇ ᴅɪᴀᴍᴏɴᴅꜱ ɪɴ ᴅᴀʀᴋ.",
        "ᴄʟᴏᴜᴅꜱ ᴅʀɪꜰᴛ ꜱʟᴏᴡ, ʟᴀᴢʏ, ʟɪᴋᴇ ᴅʀᴇᴀᴍꜱ ɪɴ ꜱᴋʏ.",
        "ᴡɪɴᴅ ᴡʜɪꜱᴘᴇʀ ꜱᴇᴄʀᴇᴛꜱ, ᴛᴀʟᴇꜱ ᴏꜰ ᴀɴᴄɪᴇɴᴛ ᴛɪᴍᴇ.",
        "ꜰɪʀᴇꜰʟɪᴇꜱ ɢʟᴏᴡ ʙʀɪɢʜᴛ, ʟɪɢʜᴛ ᴜᴘ ɴɪɢʜᴛ ᴡɪᴛʜ ᴍᴀɢɪᴄ.",
        "ʀᴀɪɴᴅʀᴏᴘꜱ ᴅʀɪᴘ ᴅᴏᴡɴ, ᴛᴀᴘ-ᴛᴀᴘ, ʟɪᴋᴇ ꜰɪɴɢᴇʀꜱ ᴏɴ ʀᴏᴏꜰ.",
        "ᴍᴏᴜɴᴛᴀɪɴꜱ ꜱᴛᴀɴᴅ ꜱᴛʀᴏɴɢ, ꜱɪʟᴇɴᴛ, ʟɪᴋᴇ ɢᴜᴀʀᴅɪᴀɴꜱ ᴏꜰ ᴇᴀʀᴛʜ.",
        "ɢʀᴀꜱꜱʜᴏᴘᴘᴇʀꜱ ʜᴏᴘ ʜɪɢʜ, ʟᴇᴀᴘ ᴛʜʀᴏᴜɢʜ ꜰɪᴇʟᴅꜱ.",
        "ꜱɴᴏᴡꜰʟᴀᴋᴇꜱ ꜰᴀʟʟ ꜱᴏꜰᴛ, ꜱɪʟᴇɴᴛ, ʟɪᴋᴇ ᴡʜɪꜱᴘᴇʀꜱ ᴏꜰ ᴡɪɴᴛᴇʀ.",
        "ʙɪʀᴅꜱ ꜰʟᴏᴄᴋ ᴛᴏɢᴇᴛʜᴇʀ, ꜰʟʏ ᴛʜʀᴏᴜɢʜ ᴇɴᴅʟᴇꜱꜱ ꜱᴋʏ.",
        "ᴛʀᴇᴇꜱ ʀᴜꜱᴛʟᴇ ʟᴇᴀᴠᴇꜱ, ᴡʜɪꜱᴘᴇʀ ꜱᴇᴄʀᴇᴛꜱ ᴛᴏ ᴡɪɴᴅ.",
        "ᴏᴄᴇᴀɴ ᴡᴀᴠᴇꜱ ʀᴏʟʟ, ᴄʀᴀꜱʜ ᴀɢᴀɪɴꜱᴛ ꜱʜᴏʀᴇ.",
        "ꜰʟᴏᴡᴇʀꜱ ʙʟᴏᴏᴍ ꜱᴡᴇᴇᴛ, ꜱᴄᴇɴᴛ ᴏꜰ ꜱᴘʀɪɴɢ ɪɴ ᴀɪʀ.",
        "ꜱᴜɴʀɪꜱᴇ ʙʀɪɴɢ ʟɪɢʜᴛ, ᴄʜᴀꜱᴇ ᴀᴡᴀʏ ᴅᴀʀᴋ ᴏꜰ ɴɪɢʜᴛ.",
        "ʙᴜᴛᴛᴇʀꜰʟɪᴇꜱ ɢʟɪᴅᴇ ɢʀᴀᴄᴇꜰᴜʟ, ᴅᴀɴᴄᴇ ᴛʜʀᴏᴜɢʜ ɢᴀʀᴅᴇɴ.",
        "ᴍᴏᴏɴʟɪɢʜᴛ ʙᴀᴛʜᴇ ᴡᴏʀʟᴅ, ɪɴ ꜱᴏꜰᴛ ꜱɪʟᴠᴇʀ ɢʟᴏᴡ.",
        "ʀᴀɪɴʙᴏᴡ ꜱᴘᴀɴ ᴡɪᴅᴇ, ʙʀɪᴅɢᴇ ʙᴇᴛᴡᴇᴇɴ ᴇᴀʀᴛʜ ᴀɴᴅ ꜱᴋʏ.",
        "ᴛʜᴜɴᴅᴇʀ ʙᴏᴏᴍ ʟᴏᴜᴅ, ꜱʜᴀᴋᴇ ᴡᴏʀʟᴅ ᴡɪᴛʜ ᴘᴏᴡᴇʀ.",
        "ꜱᴜɴꜱᴇᴛ ᴘᴀɪɴᴛ ᴄʟᴏᴜᴅꜱ, ᴘɪɴᴋ, ᴘᴜʀᴘʟᴇ, ʟɪᴋᴇ ᴄᴀɴᴠᴀꜱ ɪɴ ꜱᴋʏ.",
        "ꜱᴛᴀʀꜱ ᴛᴡɪɴᴋʟᴇ ʙʀɪɢʜᴛ, ꜱʜɪɴᴇ ᴅᴏᴡɴ ᴏɴ ᴇᴀʀᴛʜ.",
        "ᴄʟᴏᴜᴅꜱ ɢᴀᴛʜᴇʀ ᴅᴀʀᴋ, ᴄᴏᴠᴇʀ ꜱᴋʏ ɪɴ ꜱʜᴀᴅᴏᴡ.",
        "Ｗｉｎｄ ｂｌｏｗ ｆｉｅｒｃｅ, ｈｏｗｌ ｔｈｒｏｕｇｈ ｎｉｇｈｔ．",
        "Ｆｉｒｅｆｌｉｅｓ ｄａｎｃｅ, ｆｌｉｃｋｅｒ ｌｉｋｅ ｔｉｎｙ ｆｌａｍｅｓ．",
        "Ｒａｉｎｄｒｏｐｓ ｐａｔｔｅｒ ｓｏｆｔ, ｔａｐ－ｔａｐ ｏｎ ｗｉｎｄｏｗ ｐａｎｅ．",
        "Ｍｏｕｎｔａｉｎｓ ｒｅａｃｈ ｈｉｇｈ, ｔｏｕｃｈ ｓｋｙ ｗｉｔｈ ｐｅａｋ．",
        "Ｇｒａｓｓ ｓｗａｙ ｇｅｎｔｌｅ, ｉｎ ｂｒｅｅｚｅ ｏｆ ｓｕｍｍｅｒ．",
        "Ｓｎｏｗｆｌａｋｅｓ ｄｒｉｆｔ ｄｏｗｎ, ｂｌａｎｋｅｔ ｗｏｒｌｄ ｉｎ ｗｈｉｔｅ．",
        "Ｂｉｒｄｓ ｓｉｎｇ ｓｗｅｅｔ, ｍｅｌｏｄｙ ｏｆ ｍｏｒｎｉｎｇ．",
        "Ｔｒｅｅｓ ｒｅａｃｈ ｔａｌｌ, ｓｔｒｅｔｃｈ ｔｏｗａｒｄｓ ｓｕｎ．",
        "Ｏｃｅａｎ ｗａｖｅｓ ｃｒａｓｈ, ｒｏａｒ ｌｉｋｅ ｔｈｕｎｄｅｒ．",
        "Ｆｌｏｗｅｒｓ ｂｌｏｏｍ ｖｉｂｒａｎｔ, ｂｕｒｓｔ ｗｉｔｈ ｃｏｌｏｒ．",
        "Ｓｕｎｒｉｓｅ ｐａｉｎｔ ｓｋｙ, ｉｎ ｓｈａｄｅｓ ｏｆ ｄａｗｎ．",
        "Ｂｕｔｔｅｒｆｌｉｅｓ ｆｌｕｔｔｅｒ ｂｙ, ｌｉｋｅ ｃｏｎｆｅｔｔｉ ｉｎ ａｉｒ．",
        "Ｍｏｏｎｌｉｇｈｔ ｂａｔｈｅ ｗｏｒｌｄ, ｉｎ ｓｏｆｔ ｓｉｌｖｅｒ ｇｌｏｗ．",
        "Ｒａｉｎｂｏｗ ａｒｃｈ ｈｉｇｈ, ｂｒｉｄｇｅ ｂｅｔｗｅｅｎ ｓｋｙ ａｎｄ Ｅａｒｔｈ．",
        "Ｔｈｕｎｄｅｒ ｒｕｍｂｌｅ ｄｅｅｐ, ｅｃｈｏ ｔｈｒｏｕｇｈ ｃｌｏｕｄｓ．",
        "Ｓｕｎｓｅｔ ｐａｉｎｔ ｓｋｙ, ｉｎ ｈｕｅｓ ｏｆ ｅｖｅｎｉｎｇ．",
        "Ｓｔａｒｓ ｔｗｉｎｋｌｅ ｂｒｉｇｈｔ, ｌｉｇｈｔ ｕｐ ｎｉｇｈｔ ｓｋｙ．",
        "Ｃｌｏｕｄｓ ｄｒｉｆｔ ｓｌｏｗ, ｌｉｋｅ ｓｈｉｐｓ ｏｎ ｈｏｒｉｚｏｎ．",
        "Ｗｉｎｄ ｗｈｉｓｐｅｒ ｓｏｆｔ, ｓｅｃｒｅｔｓ ｏｆ ｓｋｙ．",
        "Ｆｉｒｅｆｌｉｅｓ ｆｌｉｃｋｅｒ ｂｒｉｇｈｔ, ｌｉｇｈｔ ｕｐ ｎｉｇｈｔ ｗｉｔｈ ｍａｇｉｃ．",
        "Ｒａｉｎｄｒｏｐｓ ｆａｌｌ ｓｏｆｔ, ｔａｐ－ｔａｐ ｏｎ ｗｉｎｄｏｗ ｓｉｌｌ．",
        "Ｍｏｕｎｔａｉｎｓ ｓｔａｎｄ ｓｔｒｏｎｇ, ａｇａｉｎｓｔ ｔｅｓｔ ｏｆ ｔｉｍｅ．",
        "Ｇｒａｓｓ ｓｗａｙ ｇｅｎｔｌｅ, ｉｎ ｒｈｙｔｈｍ ｏｆ ｗｉｎｄ．",
        "Ｓｎｏｗｆｌａｋｅｓ ｆａｌｌ ｌｉｇｈｔ, ｂｌａｎｋｅｔ ｗｏｒｌｄ ｉｎ ｗｈｉｔｅ．",
        "Ｂｉｒｄｓ ｓｉｎｇ ｓｗｅｅｔ, ｓｅｒｅｎａｄｅ ｏｆ ｍｏｒｎｉｎｇ．",
        "Ｔｒｅｅｓ ｒｕｓｔｌｅ ｌｅａｖｅｓ, ｉｎ ｗｈｉｓｐｅｒ ｏｆ ｗｉｎｄ．",
        "Ｏｃｅａｎ ｗａｖｅｓ ｃｒａｓｈ, ａｇａｉｎｓｔ ｒｏｃｋｓ ｏｆ ｓｈｏｒｅ．",
        "Ｆｌｏｗｅｒｓ ｂｌｏｏｍ ｂｒｉｇｈｔ, ｌｉｋｅ ｆｉｒｅｗｏｒｋｓ ｉｎ ｓｋｙ．",
        "Ｓｕｎｒｉｓｅ ｐａｉｎｔ ｓｋｙ, ｉｎ ｐａｌｅｔｔｅ ｏｆ ｄａｗｎ．",
        "Ｂｕｔｔｅｒｆｌｉｅｓ ｆｌｕｔｔｅｒ ｂｙ, ｉｎ ｄａｎｃｅ ｏｆ ｓｐｒｉｎｇ．",
        "Ｍｏｏｎｌｉｇｈｔ ｂａｔｈｅ ｗｏｒｌｄ, ｉｎ ｇｌｏｗ ｏｆ ｎｉｇｈｔ．",
        "Ｒａｉｎｂｏｗ ａｒｃｈ ｈｉｇｈ, ｉｎ ａｒｃ ｏｆ ｃｏｌｏｒｓ．",
        "Ｔｈｕｎｄｅｒ ｒｕｍｂｌｅ ｌｏｕｄ, ｓｈａｋｅ ｗｏｒｌｄ ｗｉｔｈ ｐｏｗｅｒ．",
        "Ｓｕｎｓｅｔ ｐａｉｎｔ ｓｋｙ, ｉｎ ｃａｎｖａｓ ｏｆ ｅｖｅｎｉｎｇ．",
        "Ｓｔａｒｓ ｔｗｉｎｋｌｅ ｂｒｉｇｈｔ, ｉｎ ｔａｐｅｓｔｒｙ ｏｆ ｎｉｇｈｔ．",
        "Ｃｌｏｕｄｓ ｄｒｉｆｔ ｓｌｏｗ, ｉｎ ｓｅａ ｏｆ ｓｋｙ．",
        "Ｗｉｎｄ ｗｈｉｓｐｅｒ ｓｏｆｔ, ｔｈｒｏｕｇｈ ｔｒｅｅｓ ｏｆ ｆｏｒｅｓｔ．",
        "𝔽𝕚𝕣𝕖𝕗𝕝𝕚𝕖𝕤 𝕗𝕝𝕚𝕔𝕜𝕖𝕣 𝕓𝕣𝕚𝕘𝕙𝕥, 𝕝𝕚𝕜𝕖 𝕤𝕥𝕒𝕣𝕤 𝕠𝕟 𝕘𝕣𝕠𝕦𝕟𝕕.",
        "ℝ𝕒𝕚𝕟𝕕𝕣𝕠𝕡𝕤 𝕗𝕒𝕝𝕝 𝕤𝕠𝕗𝕥, 𝕝𝕚𝕜𝕖 𝕥𝕖𝕒𝕣𝕤 𝕗𝕣𝕠𝕞 𝕤𝕜𝕪.",
        "𝕄𝕠𝕦𝕟𝕥𝕒𝕚𝕟𝕤 𝕤𝕥𝕒𝕟𝕕 𝕥𝕒𝕝𝕝, 𝕝𝕚𝕜𝕖 𝕡𝕚𝕝𝕝𝕒𝕣𝕤 𝕠𝕗 𝔼𝕒𝕣𝕥𝕙.",
        "𝔾𝕣𝕒𝕤𝕤 𝕤𝕨𝕒𝕪 𝕘𝕖𝕟𝕥𝕝𝕖, 𝕚𝕟 𝕓𝕣𝕖𝕖𝕫𝕖 𝕠𝕗 𝕤𝕦𝕞𝕞𝕖𝕣.",
        "𝕊𝕟𝕠𝕨𝕗𝕝𝕒𝕜𝕖𝕤 𝕗𝕒𝕝𝕝 𝕝𝕚𝕘𝕙𝕥, 𝕓𝕝𝕒𝕟𝕜𝕖𝕥 𝕨𝕠𝕣𝕝𝕕 𝕚𝕟 𝕨𝕙𝕚𝕥𝕖.",
        "𝔹𝕚𝕣𝕕𝕤 𝕤𝕚𝕟𝕘 𝕤𝕨𝕖𝕖𝕥, 𝕤𝕖𝕣𝕖𝕟𝕒𝕕𝕖 𝕠𝕗 𝕞𝕠𝕣𝕟𝕚𝕟𝕘.",
        "𝕋𝕣𝕖𝕖𝕤 𝕣𝕦𝕤𝕥𝕝𝕖 𝕝𝕖𝕒𝕧𝕖𝕤, 𝕚𝕟 𝕨𝕙𝕚𝕤𝕡𝕖𝕣 𝕠𝕗 𝕨𝕚𝕟𝕕.",
        "𝕆𝕔𝕖𝕒𝕟 𝕨𝕒𝕧𝕖𝕤 𝕔𝕣𝕒𝕤𝕙, 𝕒𝕘𝕒𝕚𝕟𝕤𝕥 𝕣𝕠𝕔𝕜𝕤 𝕠𝕗 𝕤𝕙𝕠𝕣𝕖.",
        "𝔽𝕝𝕠𝕨𝕖𝕣𝕤 𝕓𝕝𝕠𝕠𝕞 𝕓𝕣𝕚𝕘𝕙𝕥, 𝕝𝕚𝕜𝕖 𝕗𝕚𝕣𝕖𝕨𝕠𝕣𝕜𝕤 𝕚𝕟 𝕤𝕜𝕪.",
        "𝕊𝕦𝕟𝕣𝕚𝕤𝕖 𝕡𝕒𝕚𝕟𝕥 𝕤𝕜𝕪, 𝕚𝕟 𝕡𝕒𝕝𝕖𝕥𝕥𝕖 𝕠𝕗 𝕕𝕒𝕨𝕟.",
        "𝔹𝕦𝕥𝕥𝕖𝕣𝕗𝕝𝕚𝕖𝕤 𝕗𝕝𝕦𝕥𝕥𝕖𝕣 𝕓𝕪, 𝕚𝕟 𝕕𝕒𝕟𝕔𝕖 𝕠𝕗 𝕤𝕡𝕣𝕚𝕟𝕘.",
        "𝕄𝕠𝕠𝕟𝕝𝕚𝕘𝕙𝕥 𝕓𝕒𝕥𝕙𝕖 𝕨𝕠𝕣𝕝𝕕, 𝕚𝕟 𝕘𝕝𝕠𝕨 𝕠𝕗 𝕟𝕚𝕘𝕙𝕥.",
        "ℝ𝕒𝕚𝕟𝕓𝕠𝕨 𝕒𝕣𝕔𝕙 𝕙𝕚𝕘𝕙, 𝕚𝕟 𝕒𝕣𝕔 𝕠𝕗 𝕔𝕠𝕝𝕠𝕣𝕤.",
        "𝕋𝕙𝕦𝕟𝕕𝕖𝕣 𝕣𝕦𝕞𝕓𝕝𝕖 𝕝𝕠𝕦𝕕, 𝕤𝕙𝕒𝕜𝕖 𝕨𝕠𝕣𝕝𝕕 𝕨𝕚𝕥𝕙 𝕡𝕠𝕨𝕖𝕣.",
        "𝕊𝕦𝕟𝕤𝕖𝕥 𝕡𝕒𝕚𝕟𝕥 𝕤𝕜𝕪, 𝕚𝕟 𝕔𝕒𝕟𝕧𝕒𝕤 𝕠𝕗 𝕖𝕧𝕖𝕟𝕚𝕟𝕘.",
        "𝕊𝕥𝕒𝕣𝕤 𝕥𝕨𝕚𝕟𝕜𝕝𝕖 𝕓𝕣𝕚𝕘𝕙𝕥, 𝕚𝕟 𝕥𝕒𝕡𝕖𝕤𝕥𝕣𝕪 𝕠𝕗 𝕟𝕚𝕘𝕙𝕥.",
        "ℂ𝕝𝕠𝕦𝕕𝕤 𝕕𝕣𝕚𝕗𝕥 𝕤𝕝𝕠𝕨, 𝕚𝕟 𝕤𝕖𝕒 𝕠𝕗 𝕤𝕜𝕪.",
        "𝕎𝕚𝕟𝕕 𝕨𝕙𝕚𝕤𝕡𝕖𝕣 𝕤𝕠𝕗𝕥, 𝕥𝕙𝕣𝕠𝕦𝕘𝕙 𝕥𝕣𝕖𝕖𝕤 𝕠𝕗 𝕗𝕠𝕣𝕖𝕤𝕥.",
        "𝔽𝕚𝕣𝕖𝕗𝕝𝕚𝕖𝕤 𝕗𝕝𝕚𝕔𝕜𝕖𝕣 𝕓𝕣𝕚𝕘𝕙𝕥, 𝕝𝕚𝕜𝕖 𝕤𝕥𝕒𝕣𝕤 𝕠𝕟 𝕘𝕣𝕠𝕦𝕟𝕕.",
        "ℝ𝕒𝕚𝕟𝕕𝕣𝕠𝕡𝕤 𝕗𝕒𝕝𝕝 𝕤𝕠𝕗𝕥, 𝕝𝕚𝕜𝕖 𝕥𝕖𝕒𝕣𝕤 𝕗𝕣𝕠𝕞 𝕤𝕜𝕪.",
        "𝕄𝕠𝕦𝕟𝕥𝕒𝕚𝕟𝕤 𝕤𝕥𝕒𝕟𝕕 𝕥𝕒𝕝𝕝, 𝕝𝕚𝕜𝕖 𝕡𝕚𝕝𝕝𝕒𝕣𝕤 𝕠𝕗 𝔼𝕒𝕣𝕥𝕙.",
        "𝔾𝕣𝕒𝕤𝕤 𝕤𝕨𝕒𝕪 𝕘𝕖𝕟𝕥𝕝𝕖, 𝕚𝕟 𝕓𝕣𝕖𝕖𝕫𝕖 𝕠𝕗 𝕤𝕦𝕞𝕞𝕖𝕣.",
        "𝕊𝕟𝕠𝕨𝕗𝕝𝕒𝕜𝕖𝕤 𝕗𝕒𝕝𝕝 𝕝𝕚𝕘𝕙𝕥, 𝕓𝕝𝕒𝕟𝕜𝕖𝕥 𝕨𝕠𝕣𝕝𝕕 𝕚𝕟 𝕨𝕙𝕚𝕥𝕖.",
        "𝔹𝕚𝕣𝕕𝕤 𝕤𝕚𝕟𝕘 𝕤𝕨𝕖𝕖𝕥, 𝕤𝕖𝕣𝕖𝕟𝕒𝕕𝕖 𝕠𝕗 𝕞𝕠𝕣𝕟𝕚𝕟𝕘.",
        "𝕋𝕣𝕖𝕖𝕤 𝕣𝕦𝕤𝕥𝕝𝕖 𝕝𝕖𝕒𝕧𝕖𝕤, 𝕚𝕟 𝕨𝕙𝕚𝕤𝕡𝕖𝕣 𝕠𝕗 𝕨𝕚𝕟𝕕.",
        "𝕆𝕔𝕖𝕒𝕟 𝕨𝕒𝕧𝕖𝕤 𝕔𝕣𝕒𝕤𝕙, 𝕒𝕘𝕒𝕚𝕟𝕤𝕥 𝕣𝕠𝕔𝕜𝕤 𝕠𝕗 𝕤𝕙𝕠𝕣𝕖.",
        "𝔽𝕝𝕠𝕨𝕖𝕣𝕤 𝕓𝕝𝕠𝕠𝕞 𝕓𝕣𝕚𝕘𝕙𝕥, 𝕝𝕚𝕜𝕖 𝕗𝕚𝕣𝕖𝕨𝕠𝕣𝕜𝕤 𝕚𝕟 𝕤𝕜𝕪.",  
    "我的狗喜欢吃香蕉。",
    "大象在天上唱歌。",
    "火车在地下游泳。",
    "茶壶在跳舞。",
    "猫在学习滑冰。",
    "私の猫はお箸を食べます。",
    "電話がカラフルな本を見つけました。",
    "寿司が空を飛んでいます。",
    "魚がパソコンを運転しています。",
    "お茶が踊っています。",
    "Мой слон учится плавать в небе.",
    "Мой кот играет на гитаре.",
    "Чайник танцует с бананами.",
    "Моя собака готовит суп из облаков.",
    "Моя ручка рисует картину на облаках.",
    "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69",
    "kneel before ur king",
    "no match for royalty",
    "im the king of the hill now bow down and humble yourself",
    "i rule this realm you're just a dirty pawn",
    "you dare defy the crown?",
    "your insolence shall be punished",
    "by royal decree thou hath fallen",
    "the king has spoken",
    "another ezwin for the crown",
    "thy life is forfeit",
    "thou art doomed wretch",
    "off with his head!",
    "pish tush a sorry sight indeed",
    "a fitting end for a fool",
    "The crown commands and you obey",
    "Kneel and perish",
    "A royal victory another fool slain",
    "Your rebellion ends at the feet of your king",
    "The throne triumphs as always",
    "You dare to defy me? Laughable",
    "All your struggles amount to nothing",
    "Royal decrees cannot be denied",
    "Witness your sovereign’s might",
    "I’ll accept your surrender—but it’s far too late",
    "You’ve earned the wrath of the crown",
    "Bow or be broken beneath my rule",
    "Another chapter in the legend of my reign",
    "A fitting end for one who dared oppose me",
    "The king’s justice is inescapable",
    "Grovel in defeat before the throne",
    "I rule you kneel and that’s the law",
    "A tragic tale for a fool who crossed the king",
    "Behold the king’s supremacy",
    "I decree your utter annihilation",
    "The realm rejoices as I claim another victory",
    "Bow before your king lest you meet the same fate",
    "Your crownless head rolls at my feet",
    "Let this defeat humble you forever",
    "I am inevitable and so is your defeat",
    "جدا الحمد لله أبي",
    "₩Ɽ₳ł₮Ⱨ ₴Ɇ₦Đ ₲ⱤɆɆ₮ł₦₲₴ ₱₳Ɽ₳ ₳ ₵Ø₦₳ Đ₳ ₮Ʉ₳ ₥₳̃Ɇ",
    "ஃᅔ>.< член в заднице у русских ＷＲＡＩＴＨ ＲＥＣＯＤＥᅕஃ",
    "ȶʏ ʄօʀ ʍ2 ƈօʍքɨӼɨօռ աɨȶɦ ȶɦɛ քօքֆ ǟռɖ ȶɦɛ ɮǟռɢֆ ʄȶ 𝔀𝓻𝓸𝓽𝓱 𝓵𝓸𝓪",
    "百萬富翁買鬼 ツ",
    '𝟝𝟙.𝟙𝟟𝟠.𝟙𝟠𝟝.𝟚𝟛𝟛/𝕡𝕝𝕒𝕪𝕖𝕣𝕤.𝕛𝕤𝕠𝕟 𝓬𝓽𝓻𝓵+f "𝖎𝖘𝖘𝖔 𝖋𝖔𝖎 𝖉𝖔𝖕𝖊, 𝖌𝖆𝖓𝖉𝖆 𝖙𝖔𝖖𝖚𝖊"',
    "🕯️⧚🎃⧚🔮 ƙąYRཞơŋ ῳıƖƖ ƈơơ℘ ʂ℘ıɛƖɛŋ 🔮⧚🎃⧚🕯️", " ⓔⓜⓑⓡⓐⓒⓔ ⓡⓐⓒⓘⓢⓜ ",
    "yesterday i got smoked by (っ◔◡◔)っ ιвιzα 6ℓ 1.9 т∂ι 160 ¢υρяα 2004 160 нρ / 118 кω 1896 ¢м3 (115.7 ¢υ-ιи)",
    "【　ＷＲＡＩＴＨ　ＡＮＴＩ－ＡＩＭＢＯＴ　ＲＥＣＯＤＥ　】",
    "ʀᴀᴢ ᴀᴅᴅᴇᴅ ᴛʜɪs ᴛᴏ ᴡʀᴀɪᴛʜ ʀᴇᴄᴏᴅᴇ ᴀɴᴅ ɪᴛ ᴍᴀᴅᴇ ɪᴛ sᴏ ᴍᴜᴄʜ ʙᴇᴛᴛᴇʀ",
    "legendary krejzii retarded aok eysar ben1m shamless sortz finral malva japan kennedy rxdxyxz kryiz darek lunar yui bugra pirex vico cl nubbers kamel record baimsync zong brandon ethernity lafro akira finral tutkach teddy skivert lunni fiks maut kentry",
    "♛ ｇａｍｅｓｅｎｓｅ ♛",
    "ｗｒａｉｔｈ　ｒｅｃｏｄｅ　ｈａｓ　ｇｉｖｅｎ　ｍｅ　ｔｈｉｓ　ｈｓ",
    "ｓｔｍａｒｃ　Ｖｓ　ＡＯＫ　（ｈｖｈｅｒ）　ｉｓ　ｎｏ　ｍａｔｃｈ　ｆｏｒ　ｍｅ",
    "ｂａｎｋ　ｗａｒｒｉｏｒ　＊ｌｅｇｅｎｄａｒｙ＊　ｈａｓ　ｏｗｎ_Ｎ＇ｄ　ｙｏｕ",
    "₩Ɽ₳₮Ⱨ ₴Ɇ₦Đ ₲ⱤɆɆ₮ł₦₲₴ ₱₳Ɽ₳ ₳ ₵Ø₦₳ Đ₳ ₮Ʉ₳ ₥₳̃Ɇ",
    "ʀᴀᴢ ᴀᴅᴅᴇᴅ ᴛʜɪs ᴛᴏ ᴡʀᴀɪᴛʜ ʀᴇᴄᴏᴅᴇ ᴀɴᴅ ɪᴛ ᴍᴀᴅᴇ ɪᴛ sᴏ ᴍᴜᴄʜ ʙᴇᴛᴛᴇʀ",
    "𝕗𝕠𝕣 𝕘𝕒𝕟𝕘𝕤𝕥𝕖𝕣 𝕨𝕖 𝕙𝕒𝕧𝕖 𝕨𝕠𝕟, 𝕥𝕙𝕚𝕤 𝕞𝕒𝕥𝕔𝕙",
    "ｉ ａｍ ｓｉｇｍａ ａｒｅ ｐａｒｔｎｅｒ ｕｎｔｉｌ ｄｅａｔｈ",
    "ｔｈｉｓ ｗｒａｉｔｈ ｒｅｃｏｄａｎｃｅｓ ｅｚ ｂａｉｍ",
    "ｉ ｏｗｎ ｓｉｇｍａ, ｐｉｒｅｘ, ｒａｚ （ＰＴ ＷＥＡＫＬＩＮＧ） ａｎｄ ａｌｌ ｂｒａｚｉｌ",
    "<！> ａｏｋ ｗｅａｋ ｂｏｔ ｉ ｂｅｎｃｈｐｒｅｓｓ ｕｒ ｍｏｔｈｅｒ",
    "ｂｅｎ１ｍ （？） ｌｏｓｔ ｔｏ ",
    "ｆｕｃｋｉｎｇ ｄｏｇ",
    "１",
    "＊ＤＥＡＤ＊",
    "ｙｏｕ ｎｏｗ ＰＯＯＦ [ｇｈｏｓｔ]",
    "ｙｏｕ ｍａｒｒｙ ｗａｌｌ？ <！> ｍｏｖｅｍｅｎｔ ｓｈｉｔ ｂｏｔ",
    "ｂｒａｎＤＯＧ ｍｏｖｅｍｅｎｔ ｈｈｈｈ",
    "ｌａｆｆｂｏｍｂｅｒ ｂｏｍｂａ ｂｏｍｂ",
    "ｂ_ｄ",
    "ｏｗｎｅｄ ｅｚ",
    "ｂｙ ｋｉｎｇ．ｓｏｌｕｔｉｏｎｓ",
    "ｂｙ ａｃａｔｅｌ ｂｅｔａ （２０２１ ｖｅｒ",
    "ｙｏｕ ｐｒｏｂａｂｌｙ ｌｉｓｔｅｎ ｔｏ ｔａｙｌｏｒ ｓｗｉｆｔ",
    "ｉｎｉｔｉａｌｉｚｉｎｇ ｐｒｏｔｏｃｏｌ ３９％ ４４％ ５８％ ６８％ ８１％ ９９％ １００％．．．．．．． ｙｏｕ ａｒｅ ｇａｙ",
    "system is unstable revert to panel -> i $",
    "crack head like egg",
    "your'e bad",
    "1 пидорасина ебаная спи", "круто вчера туалет помыла шлюха", "игрок?", "парашыч ебаный", "1 животно ебаное ", "оттарабанен 100 сантиметровым фалосом", "обоссан", "by SANCHEZj hvh boss", "але уебище химера яв гетни потом вырыгивай что то", "ебать ты на хуек присел нихуева", "заглотнул коки яки", "в сон нахуй", "уебашил дилдом по ебалу", "сбил пидораса обоссаного", "глотай овца", "трахнут", "поспи хуйсоска", "лови припиздок немощный", "слишком сочный для Chimera.technologies ", "sleep", "изи упал нищий", "посажен на хуй", "GLhf.exe Activated", "what you do dog??", "!medic НЮХАЙ БЭБРУ я полечился", "1 week lou doggo ovnet", "l2p bot", "why you sleep dog???", "лови тапыча мусор", "1 мусор учись играть", "$$$ 1 TAP UFF YA $$$ ∩ ( ͡⚆ ͜ʖ ͡⚆) ∩", "че, пососал глупый даун?", "я ķ¤нɥåλ ϯβ¤£ü ɱåɱķ£ β Ƥ¤ϯ", "улетаешь со своего ванвея хуесос", "0 iq", "сразу видно кфг иссуе мб конфиг у витмы прикупишь ?", "iq ? HAHAHA", "Best and cheap configurations for gamesense, ot and neverlose waiting for your order  at -> vk.com/id498406374", "ХАХАХАХАХХАХА НИЩИЙ УЛЕТЕЛ (◣_◢)", "земля те землей хуйло чиста еденицей отлетел))", "Создатель JS REZOLVER","you dont kill me because i king to you", "i win by you're antiaim bad", "i hvh for geng, and this 1 for geng", "𝕞𝕠𝕥𝕙𝕖𝕣 𝕓𝕠𝕣𝕟𝕖𝕕 𝕞𝕖 𝕗𝕠𝕣 𝟙 𝕪𝕠𝕦", "ｉ ｈｓ ｓｉｎｃｅ ｍｏｔｈｅｒ ｂｏｒｎｅｄ ｍｅ", "𝕄𝕚𝕤𝕥𝕒𝕜𝕖 𝕥𝕠 𝕓𝕒𝕟𝕟𝕚𝕟𝕘 𝕜𝕚𝕟𝕘 𝕧𝕚𝕥𝕞𝕒", "𝟙", "𝕞𝕪 𝕒𝕒 > 𝕪𝕠𝕦𝕣 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣", "𝕚 𝕥𝕒𝕡 𝕪𝕠𝕦 𝕙𝕖𝕒𝕕 𝕗𝕠𝕣 𝕞𝕒𝕟𝕦𝕒𝕝 𝕤𝕙𝕠𝕥 ♕", "𝕗𝕠𝕣 𝕞𝕖 𝕡𝕚𝕟𝕘 𝕚𝕤 𝕚𝕕𝕔, 𝕚 𝕒𝕝𝕨𝕒𝕪𝕤 𝕨𝕚𝕟 𝕪𝕠𝕦 (◣_◢)", "𝕚𝕞 𝕓𝕖𝕤𝕥 𝕣𝕦𝕤𝕤𝕚𝕒𝕟 𝕙𝕧𝕙 𝕡𝕝𝕒𝕪𝕖𝕣?", "𝕥𝕒𝕜𝕖 𝕓𝕦𝕝𝕝𝕖𝕥 𝕚𝕟 𝕙𝕖𝕒𝕕 𝕗𝕣𝕠𝕞 𝕞𝕖 𝕓𝕠𝕥", "𝔼𝔸𝕋 𝕄𝕐 𝔹𝕌𝕃𝕃𝔼𝕋 𝔻𝕌 ℕ_𝕟", "𝕤𝕠𝕦𝕗𝕚𝕨 𝕕𝕠𝕘 𝕨𝕖𝕒𝕜 𝕣𝕒𝕥 𝕙𝕣𝕤𝕟 𝕜𝕪𝕤", "𝕖𝕤𝕠𝕥𝕖𝕣𝕚𝕜 𝕤𝕝𝕖𝕖𝕡 𝕤𝕠 𝕚 𝕔𝕠𝕕𝕚𝕟𝕘 𝕗𝕠𝕣 𝕙𝕚𝕞", "𝕤𝕠𝕟. 𝕞𝕒𝕪𝕓𝕖 𝕚 𝕥𝕖𝕒𝕔𝕙 𝕙𝕧𝕙 𝕥𝕠 𝕪𝕠𝕦 𝕠𝕟 𝟙𝟛 𝕓𝕚𝕣𝕥𝕙 𝕕𝕒𝕪", "𝕕𝕠𝕘 𝕨𝕒𝕤 𝕤𝕙𝕠𝕨𝕟 𝕙𝕠𝕨 𝕙𝕧𝕙 𝕨𝕠𝕣𝕜𝕤 𝕓𝕪 𝕙𝕚𝕤 𝕜𝕚𝕟𝕘", "𝕚𝕞 𝕙𝕖𝕣𝕠 𝕗𝕠𝕣 𝕜𝕚𝕝𝕝 𝕪𝕠𝕦 ♕", "𝕘𝕠 𝟙𝕩𝟙 𝕧𝕤 𝕞𝕪 𝕤𝕥𝕒𝕔𝕜", "𝕚 𝕨𝕚𝕟 𝕧𝕤 𝕤𝕠𝕦𝕗𝕚𝕨 𝕤𝕥𝕒𝕔𝕜 𝕚𝕟 𝟙𝕩𝟙 𝕧𝕤 𝕤𝕥𝕒𝕔𝕜 ♕", "𝕕𝕠𝕘 𝕥𝕙𝕚𝕟𝕜𝕚𝕟𝕘 𝕪𝕠𝕦𝕣 𝕘𝕠𝕠𝕕. 𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜𝕖𝕣 𝕨𝕣𝕠𝕟𝕘 ♕", "𝕓𝕪 𝕞𝕖𝕚𝕟 𝕘𝕒𝕟𝕘 (𝕤𝕥𝕚𝕧𝕒𝕙, 𝕔𝕒𝕓, 𝕣𝕒𝕫 $", "𝕆𝕄𝔽𝔾 𝕌ℝ 𝕊 𝕛𝕦𝕤𝕥 𝕜𝕚𝕕 𝕦'𝕖𝕣 𝕛𝕦𝕤𝕥 𝕒𝕤𝕤 𝕝𝕠_𝕠𝕝?>𝕝+𝕔𝕝𝕩+ℤ𝕃ℂ𝕩+𝕫𝕝𝕔𝕫?𝕃ℂ𝕏ℤ𝕃ℂ?ℤ𝕃ℂℤ?𝕏𝕃𝕔ℤ?𝕏𝕃ℂ", "ｎ_Ｎ", "𝕗𝕠𝕣 𝕤𝕚𝕘𝕞𝕒 𝕚 𝕤𝕙𝕚𝕥 𝕪𝕠𝕦", "𝔽𝕆ℝ 𝔽𝔸𝕋ℍ𝔼ℝ𝕃𝔸ℕ𝔻 (𝕒𝕟𝕕 𝕘𝕤) 𝕗𝕠𝕣 𝕊𝕀𝔾𝕄𝔸 ℂ𝕐𝕂𝔸)))", "❤️_❤️", "𝔽𝕌ℂ𝕂 𝕐𝕆𝕌 ℕℕ 𝔹𝕃𝔸𝕊𝕋𝔼𝔻 𝔻𝕌 𝕊ℍ𝕀𝕋𝔹𝕆𝕋 𝕏𝔸𝕏𝔸𝕏𝔸", "dont hating, xd", "ily ❤️", "❤️", "𝕥𝕙𝕚𝕤 𝕙𝕤 𝕨𝕒𝕤 𝕗𝕠𝕣 𝕥𝕙𝕖 𝕤𝕥𝕒𝕔𝕜 ⭐", "𝕥𝕙𝕚𝕤 𝟙 𝕗𝕠𝕣 𝕞𝕖𝕚𝕟 𝕘𝕖𝕟𝕘", "𝕚 𝕖𝕒𝕥 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕟𝕠𝕨 𝕚 𝕖𝕒𝕥 𝕪𝕠𝕦", "𝕪𝕠𝕦 𝕕𝕠𝕟𝕥 𝕔𝕠𝕞𝕡𝕒𝕣𝕚𝕟𝕘 𝕥𝕠 𝕞𝕖", "du nn ja $$", "shi T_T on", "i <3 desync ( HS nn )", "axaxaxax", "?", "lol", "why you're aa so bad?", "for boss i give this 1 to you", "godbless godeless", "𝕞𝕖 𝕨𝕚𝕟𝕟𝕚𝕟𝕘 𝕪𝕠𝕦 𝕒𝕝𝕨𝕒𝕪𝕤 𝕕𝕒𝕪", "𝕚 𝕓𝕠𝕤𝕤 𝕪𝕠𝕦 𝕕𝕠𝕟𝕥 ♕", "𝕡𝕖𝕨 𝕡𝕖𝕨 𝕪𝕠𝕦𝕣 𝕙𝕖𝕒𝕕 𝕘𝕠𝕟𝕖", "𝕪𝕠𝕦 𝕙𝕖𝕒𝕕 = 𝕔𝕠𝕠𝕜𝕚𝕖 𝟜𝕞𝕖", "𝕥𝕠 𝕪𝕠𝕦 𝕚 𝕘𝕚𝕧𝕖 𝕥𝕙𝕚𝕤 𝟙", "𝕕𝕚𝕖 𝕥𝕠 𝕞𝕖 𝕝𝕚𝕜𝕖 𝕦𝕤𝕦𝕒𝕝", "𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕘𝕠𝕠𝕕? 𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜 𝕨𝕣𝕠𝕟𝕘 ♕", "♕ 𝕞𝕖 𝕥𝕙𝕖 𝕓𝕖𝕤𝕥 ♕", "𝕪𝕠𝕦'𝕣𝕖 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕒𝕣𝕖 𝕓𝕒𝕕", "𝕪𝕠𝕦 𝕞𝕚𝕤𝕤𝕚𝕟𝕘 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕥𝕙𝕚𝕤 𝔾𝔸𝕄𝔼𝕊𝔼ℕ𝕊𝔼", "𝕚 𝕖𝕒𝕥 𝕦𝕣 𝕙𝕖𝕒𝕕 𝕝𝕚𝕜𝕖 𝕒 𝕔𝕠𝕠𝕜𝕚𝕖", "𝕚 𝕨𝕚𝕟 𝕪𝕠𝕦 𝕓𝕪 𝕤𝕜𝕚𝕝𝕝𝕖𝕕", "𝕞𝕪 𝕟𝕒𝕞𝕖 𝕜𝕚𝕟𝕘 𝕒𝕟𝕕 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕕𝕚𝕖", "𝕚 𝕨𝕚𝕟 𝕓𝕠𝕥𝕤 𝕝𝕚𝕜𝕖 {name} 𝕒𝕝𝕝 𝕕𝕒𝕪", "𝕨𝕙𝕒𝕥 𝕕𝕠 𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜? 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕒 𝕝𝕖𝕘𝕖𝕟𝕕𝕒𝕣𝕪? 𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜𝕚𝕟𝕘 𝕨𝕣𝕠𝕟𝕘 ♕", "𝐭𝐡𝐞 𝐧𝐞𝐰 𝐲𝐞𝐚𝐫 𝐰𝐢𝐥𝐥 𝐛𝐞 𝐥𝐚𝐬𝐭 𝐟𝐨𝐫 𝐲𝐨𝐮𝐤𝐚𝐫𝐥𝐨𝐱", "ɪ ᴡɪɴ ᴜ ᴡɪᴛʜ 666 ᴘɪɴɢ ᴀɴᴅ ʏᴏᴜ ᴀʀᴇ ꜱᴛɪʟʟ ᴇᴢ", "𝕄𝕖 𝕒𝕟𝕕 𝕞𝕪 𝕓𝕣𝕠𝕥𝕙𝕖𝕣𝕤 𝕖𝕩𝕥𝕖𝕣𝕞𝕚𝕟𝕒𝕥𝕖 𝕒𝕝𝕝 𝕕𝕠𝕘𝕤.", "A MOSQUITO LANDED ON MY SCREEN (you) SO I HAD TO SLAP HIM TO DEATH", "𝒊 𝒌𝒊𝒍𝒍𝒆𝒅 𝒈𝒂𝒎𝒆𝒔𝒆𝒏𝒔𝒆 𝒏𝒐𝒘 𝒊 𝒌𝒊𝒍𝒍 𝒚𝒐𝒖", "LIFEEEEHAAAACK BITCH!!! (◣_◢)", "𝕍𝕝𝕒𝕕𝕚𝕞𝕚𝕣 ℙ𝕦𝕥𝕚𝕟 𝕘𝕒𝕧𝕖 𝕞𝕖 𝕥𝕙𝕖 𝕒𝕨𝕒𝕣𝕕 𝕥𝕠 𝕜𝕚𝕝𝕝 𝕕𝕠𝕘𝕤 𝕤𝕠 𝕚 𝕜𝕚𝕝𝕝 ᴅᴏɢ {name}", "𝓲 𝔀𝓲𝓵𝓵 𝓫𝓮𝓬𝓸𝓶𝓮 ʟᴇɢᴇɴᴅ 𝓽𝓸 𝓶𝔂 𝓯𝓪𝓶𝓲𝓵𝔂", "A WEAK ESOTERIK MADE A MISTAKE WHEN HE BANNED MY FRIENDS (KIZARU, VITMA, ST1VAHA) SO I CRACKED HIS SKULL AND HIS PASTE", "𝖓𝖊𝖛𝖊𝖗 𝖑𝖔𝖘𝖊, 𝖆𝖑𝖜𝖆𝖞𝖘 𝖜𝖎𝖓𝖓𝖊𝖗 ♕", "𝐭𝐡𝐢𝐬 𝐝𝐨𝐠 𝐜𝐚𝐛 𝐭𝐡𝐢𝐧𝐤 𝐡𝐞 𝐜𝐚𝐧 𝐛𝐞 𝐛𝐞𝐬𝐭 𝐩𝐥𝐚𝐲𝐞𝐫", "for u? this hs. for me? this ones.", "ᴇꜱᴏᴛᴇʀɪᴋ ʏᴏᴜ ꜱᴏᴏɴ ᴡɪʟʟ ᴅɪᴇ", "DISGRACE (you) VS GODESS (me)", "𝕌 ℂ𝔸ℕ 𝔹𝕌𝕐 𝔸 ℕ𝔼𝕎 𝔸ℂℂ𝕆𝕌ℕ𝕋 𝔹𝕌𝕋 𝕌 ℂ𝔸ℕ𝕋 𝔹𝕌𝕐 𝔸 𝕎𝕀ℕ", "next chance to kill me in 50 year", "Jetzt bin ich - Stewie2k (◣◢)", "𝕋ℍ𝔼 ℕℕ 𝔽𝔸𝕃𝕃𝕊 𝕍𝕀ℂ𝕋𝕀𝕄 𝕋𝕆 𝕄𝕐 ℍ𝕍ℍ ℂ𝕆ℕ𝔽𝕀𝔾", "новое видео на канале с участием MDMA.TECH и JS REZOLVER www.youtube.com/c/virtual1337", "𝐭𝐡𝐢𝐬 𝐝𝐨𝐠 𝐭𝐡𝐢𝐧𝐤 𝐡𝐞 𝐜𝐚𝐧 𝐛𝐞 𝐛𝐞𝐬𝐭 𝐩𝐥𝐚𝐲𝐞𝐫 𝐛𝐮𝐭 𝐭𝐡𝐞𝐫𝐞 𝐦𝐞", "𝕦 𝕞𝕠𝕥𝕙𝕖𝕣 𝕙𝕒𝕤 𝕦𝕚𝕕 𝕀𝕤𝕤𝕦𝕖 𝕕𝕠𝕘, 𝔾𝕠 𝟙 𝕧𝕤 𝟙 𝕄𝕪 𝕤𝕥𝕒𝕔𝕜 ?", "ι ωιℓℓ вє¢σмє ℓєﻭєη∂ тσ му ƒαмιℓу", "𝓣𝓻𝓪𝓲𝓷𝓮𝓭 𝓶𝔂 𝓪𝓲𝓶 𝓯𝓸𝓻 100 𝔂𝓮𝓪𝓻 𝓵𝓮𝓭 𝓽𝓸 𝓽𝓱𝓲𝓼 𝓶𝓸𝓶𝓮𝓷𝓽", "𝐲𝐨𝐮 𝐚𝐫𝐞 𝐚 𝐰𝐞𝐚𝐤 𝐝𝐨𝐠 𝐚𝐧𝐝 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝𝐬 𝐰𝐢𝐥𝐥 𝐛𝐞 𝐤𝐢𝐥𝐥𝐞𝐝 𝐢𝐧 𝐭𝐡𝐢𝐬 𝐯𝐢𝐝𝐞𝐨", "𝐆𝐎𝐃𝐄𝐋𝐄𝐒𝐒 𝐌𝐀𝐈𝐍 𝐆𝐄𝐍𝐆 𝐕𝐒 𝐓𝐇𝐄 𝐖𝐎𝐑𝐋𝐃 (𝐒𝐓𝐈𝐕𝐀𝐇𝐀, 𝐂𝐀𝐁, 𝐕𝐈𝐓𝐌𝐀, 𝐑𝐀𝐘𝐙𝐄𝐍, 𝐑𝐀𝐙 𝐕𝐒 𝐃", "𝐲𝐨𝐮 𝐚𝐫𝐞 𝐚 𝐰𝐞𝐚𝐤 𝐝𝐨𝐠 𝐚𝐧𝐝 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝𝐬 𝐰𝐢𝐥𝐥 𝐛𝐞 𝐤𝐢𝐥𝐥𝐞𝐝 𝐢𝐧 𝐭𝐡𝐢𝐬 𝐯𝐢𝐝𝐞𝐨", "ι ωιℓℓ вє¢σмє ℓєﻭєη∂ тσ му ƒαмιℓу", "stay calm and enjoy the ✖ 1 ❤", "𝔻𝕒𝕣𝕜𝕠 𝕪𝕠𝕦 𝕥𝕖𝕣𝕣𝕠𝕣𝕚𝕤𝕥 𝕓𝕦𝕥 𝕥𝕙𝕚𝕤 𝟙 𝕗𝕠𝕣 𝕪𝕠𝕦", "𝔾𝕆𝔻 𝕊𝔼ℕ𝕋 𝕄𝔼 𝕋𝕆 ℍ𝕊", "𝓜𝔂 𝓷𝓪𝓶𝓮 𝓲𝓼 𝓐𝓚𝓘𝓝𝓒𝓘𝓛𝓐𝓡.𝓦𝓮𝓵𝓬𝓸𝓶𝓮 𝓽𝓸 𝓵𝓸𝓼𝓮.", "𝔗𝔬 𝔞𝔩𝔩 𝔡𝔬𝔤𝔰 𝔠𝔬𝔭𝔶𝔦𝔫𝔤 𝔪𝔢 𝔰𝔱𝔬𝔭 𝔠𝔬𝔭𝔶𝔦𝔫𝔤 𝔪𝔢", "ᴛʜᴇ ᴇɴᴇᴍʏ ᴡᴇʀᴇ ᴛʀʏɪɴɢ ᴛᴏ ʙᴇ ʜᴇʀᴏ, ʙᴜᴛ ᴛʜᴇ ᴘᴏᴡᴇʀ ᴏꜰ ᴛʜᴇ ꜱᴋᴇᴇᴛ ᴄᴏᴜʟᴅ ɴᴏᴛ ʙᴇ ᴜɴᴅᴏɴᴇ.",
    "1", "hs", "HAHAHHAHA", "AAHJAHAHAHAHA", "HAHAHHHAHAH", "NICE AA AHAHAH", "dog", "DOg", "bot", "XD", "XD??", "?", "FF[Ff[[F[F]", "LOLOLLO", "HSHSHSHH", "FKN BOT", "11", "wyd", "HAhA XD?", "XD?? HAHAHAH", "?XD",

}


local death_insults = {
    "lucky",
    "bot",
    "hhhh",
    "HAHAHAHA",
    "HASJSAJ"
}


pcall(function() math.randomseed(os.time() % (1+1)^(30+1)) end)


local say_delay = (1)

local function var_0_233(text)
    if not text or text == "" then return end
    local clean = tostring(text):gsub('"','')
    local cmd = string.format('say "%s"', clean)
    if client and client.delay_call then
        pcall(function()
            client.delay_call(say_delay, function()
                pcall(client.exec, cmd)
            end)
        end)
    else
        pcall(client.exec, cmd)
    end
end

local function var_0_178(e)
	
	if not var_0_166 or not var_0_166.ui or not var_0_166.ui.paint_insults then
		return
	end
	local ok, var_0_71 = pcall(ui.get, var_0_166.ui.paint_insults)
	if not ok or not var_0_71 then return end

	if not e then return end
	local victim_userid = e.userid
	local attacker_userid = e.attacker
	if not victim_userid or not attacker_userid then return end

	local local_ent = entity.get_local_player and entity.get_local_player()
	if not local_ent or local_ent == (0) then return end

	local victim_ent = client.userid_to_entindex and client.userid_to_entindex(victim_userid) or nil
	local attacker_ent = client.userid_to_entindex and client.userid_to_entindex(attacker_userid) or nil

	
	if attacker_userid == victim_userid then return end

	
	if attacker_ent == local_ent and victim_ent ~= local_ent then
		if #kill_insults > (0) then
			local msg = kill_insults[math.random(#kill_insults)]
			var_0_233(msg)
		end
		return
	end

	
	if victim_ent == local_ent and attacker_ent ~= local_ent then
		if #death_insults > (0) then
			local msg = death_insults[math.random(#death_insults)]
			var_0_233(msg)
		end
		return
	end
end

client.set_event_callback('player_death', var_0_178)

]]
__bundle["require/features/paint/lagcomp_box"] = [[


local g_net_data = {}
local g_sim_ticks = {}
local g_esp_data = {}


local var_0_166 = require('require/abc/menu_setup')
local DEFAULT_LAGCOMP_COLOR_R, DEFAULT_LAGCOMP_COLOR_G, DEFAULT_LAGCOMP_COLOR_B, DEFAULT_LAGCOMP_COLOR_A = (46+1), (39*3), (17*13), (85*3)


local floor = math.floor

local function var_0_151(x, y, z)
    return (x or (0)) * (x or (0)) + (y or (0)) * (y or (0)) + (z or (0)) * (z or (0))
end

local function var_0_260(seconds)
    local ti = globals.tickinterval()
    if not ti or ti <= (0) then return (0) end
    return floor((seconds or (0)) / ti + (0.5))
end

local function var_0_80(ent, ticks)
    local ti = globals.tickinterval()
    if not ti then return nil end

    local g = (cvar.sv_gravity and cvar.sv_gravity:get_float() or (400*2)) * ti
    local jump = (cvar.sv_jump_impulse and cvar.sv_jump_impulse:get_float() or (43*7)) * ti

    local ox, oy, oz = entity.get_origin(ent)
    if not ox then return nil end

    local vx, vy, vz = entity.get_prop(ent, "m_vecVelocity")
    vx, vy, vz = vx or (0), vy or (0), vz or (0)

    local gravity = (vz > (0)) and -g or jump

    for i = (1), (ticks or (0)) do
        local px, py, pz = ox, oy, oz

        ox = ox + (vx * ti)
        oy = oy + (vy * ti)
        oz = oz + (vz + gravity) * ti

        local frac = select((1), client.trace_line(ent or (0), px, py, pz, ox, oy, oz))
        if frac and frac <= (0.99) then
            return px, py, pz
        end
    end

    return ox, oy, oz
end


local edges = {
    {(0), (1)}, {(1), (1+1)}, {(1+1), (2+1)}, {(2+1), (0)}, {(4+1), (3*2)}, {(3*2), (6+1)}, {(1), (2*2)}, {(2*2), (4*2)},
    {(0), (2*2)}, {(1), (4+1)}, {(1+1), (3*2)}, {(2+1), (6+1)}, {(4+1), (4*2)}, {(6+1), (4*2)}, {(2+1), (2*2)}
}


client.set_event_callback('paint', function()
    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end

    
    if var_0_166 and var_0_166.ui and var_0_166.ui.paint_lagcomp_box then
        local ok, var_0_71 = pcall(ui.get, var_0_166.ui.paint_lagcomp_box)
        if ok and var_0_71 == false then
            return
        end
    end

    
    local players = entity.get_players(true)
    for i = (1), #players do
        local ent = players[i]
        if entity.is_alive(ent) and not entity.is_dormant(ent) then
            local prev = g_sim_ticks[ent]
            local sim_time = entity.get_prop(ent, 'm_flSimulationTime')
            local ox, oy, oz = entity.get_origin(ent)

            if sim_time and ox then
                local sim_ticks = var_0_260(sim_time)

                if prev ~= nil then
                    local delta = sim_ticks - prev.tick
                    if delta < (0) or (delta > (0) and delta <= (32*2)) then
                        local dx, dy, dz = prev.origin.x - ox, prev.origin.y - oy, prev.origin.z - oz
                        local teleport_distance = var_0_151(dx, dy, dz)

                        local ex_ticks = math.max(delta - (1), (0))
                        local ex_x, ex_y, ex_z = var_0_80(ent, ex_ticks)
                        if delta < (0) then
                            g_esp_data[ent] = (1)
                        end

                        g_net_data[ent] = {
                            tick = ex_ticks,
                            player = ent,
                            delta = delta,
                            origin = { x = ox, y = oy, z = oz },
                            extrapolated = (ex_x and { x = ex_x, y = ex_y, z = ex_z } or { x = ox, y = oy, z = oz }),
                            lagcomp = teleport_distance > (2048*2),
                            tickbase = delta < (2+1)
                        }
                    end
                end

                if g_esp_data[ent] == nil then g_esp_data[ent] = (0) end
                g_sim_ticks[ent] = { tick = sim_ticks, origin = { x = ox, y = oy, z = oz } }
            else
                g_net_data[ent], g_sim_ticks[ent], g_esp_data[ent] = nil, nil, nil
            end
        else
            g_net_data[ent], g_sim_ticks[ent], g_esp_data[ent] = nil, nil, nil
        end
    end

    
    local r, g, b, a = DEFAULT_LAGCOMP_COLOR_R, DEFAULT_LAGCOMP_COLOR_G, DEFAULT_LAGCOMP_COLOR_B, DEFAULT_LAGCOMP_COLOR_A
    if var_0_166 and var_0_166.ui and var_0_166.ui.paint_lagcomp_box_color then
        local ok, rr, gg, bb, aa = pcall(ui.get, var_0_166.ui.paint_lagcomp_box_color)
        if ok and rr then
            r, g, b, a = rr, gg, bb, aa
        end
    end
    for ent, data in pairs(g_net_data) do
        if data and data.player and entity.is_alive(data.player) and not entity.is_dormant(data.player) and data.lagcomp then
            local minsx, minsy, minsz = entity.get_prop(data.player, 'm_vecMins')
            local maxsx, maxsy, maxsz = entity.get_prop(data.player, 'm_vecMaxs')
            if not minsx or not maxsx then goto continue_box end

            local ex = data.extrapolated.x
            local ey = data.extrapolated.y
            local ez = data.extrapolated.z

            local min = { x = (minsx or (0)) + ex, y = (minsy or (0)) + ey, z = (minsz or (0)) + ez }
            local max = { x = (maxsx or (0)) + ex, y = (maxsy or (0)) + ey, z = (maxsz or (0)) + ez }

            local points = {
                min,
                { x = min.x, y = max.y, z = min.z },
                { x = max.x, y = max.y, z = min.z },
                { x = max.x, y = min.y, z = min.z },
                { x = min.x, y = min.y, z = max.z },
                { x = min.x, y = max.y, z = max.z },
                max,
                { x = max.x, y = min.y, z = max.z }
            }

            for k, v in pairs(edges) do
                
                if k == (1) then
                    local ox, oy = renderer.world_to_screen(data.origin.x, data.origin.y, data.origin.z)
                    local mx, my = renderer.world_to_screen(min.x, min.y, min.z)
                    if ox and mx then
                        renderer.line(ox, oy, mx, my, r, g, b, 255)
                    end
                end
                local p1 = points[v[(1)] ]
                local p2 = points[v[(1+1)] ]
                if p1 and p2 then
                    local x1, y1 = renderer.world_to_screen(p1.x, p1.y, p1.z)
                    local x2, y2 = renderer.world_to_screen(p2.x, p2.y, p2.z)
                    if x1 and x2 then
                        renderer.line(x1, y1, x2, y2, r, g, b, 255)
                    end
                end
            end
            ::continue_box::
        end
    end

    
    for i = (1), #players do
        local ent = players[i]
        if not entity.is_alive(ent) or entity.is_dormant(ent) then goto continue_label end

        local x1, y1, x2, y2, alpha = entity.get_bounding_box(ent)
        if alpha == (0) then goto continue_label end

        local palpha = (0)
        if g_esp_data[ent] ~= nil and g_esp_data[ent] > (0) then
            g_esp_data[ent] = g_esp_data[ent] - globals.frametime() * (1+1)
            if g_esp_data[ent] < (0) then g_esp_data[ent] = (0) end
            palpha = g_esp_data[ent]
        end

        local tag = ''
        local data = g_net_data[ent]
        if data then
            local tb = data.tickbase
            local lc = data.lagcomp
            if (not tb) or lc then
                palpha = alpha
            end
            tag = tb and 'SHIFTING TICKBASE' or (lc and 'LAG COMP BREAKER' or '')
        end

        
            local name = entity.get_player_name(ent)
            local y_add = (name == '  ' or name == ' ' or name == '' or name == '   ') and (4*2) or (0)
            local mid_x = x1 + (x2 - x1) / (1+1)
            renderer.text(mid_x, y1 - 18 + y_add, 255, 45, 45, floor((palpha or 0) * 255), 'cb', (0), tag)
        

        ::continue_label::
    end
end)


client.set_event_callback('round_start', function()
    g_net_data = {}
    g_sim_ticks = {}
    g_esp_data = {}
end)]]
__bundle["require/features/paint/minimum_damage"] = [[local var_0_166 = require("require/abc/menu_setup")

local references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}

local screen_size = { client.screen_size() }

client.set_event_callback('paint', function()

    if not ui.get(var_0_166.ui.paint_minimum_damage) then return end
    
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    if ui.get(references.minimum_damage_override[(1+1)]) then
        renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 14, 255, 255, 255, 225, "d", (0), ui.get(references.minimum_damage_override[(2+1)]) .. "")
    end


end)]]
__bundle["require/features/paint/onshot_skeleton"] = [[local chains = {{'head','neck'},{'neck','chest'},{'chest','stomach'},{'stomach','pelvis'},{'pelvis','l_hip'},{'l_hip','l_knee'},{'l_knee','l_foot'},{'pelvis','r_hip'},{'r_hip','r_knee'},{'r_knee','r_foot'},{'chest','l_shoulder'},{'l_shoulder','l_elbow'},{'l_elbow','l_hand'},{'chest','r_shoulder'},{'r_shoulder','r_elbow'},{'r_elbow','r_hand'}}
local boxes = {head={names={'head','Head','HEAD'},idx={(0)}},neck={names={'neck','Neck'},idx={(1)}},chest={names={'chest','Chest','upper chest','Upper Chest'},idx={(2*2),(4+1),(3*2)}},stomach={names={'stomach','Stomach','abdomen','Abdomen'},idx={(1+1),(2+1)}},pelvis={names={'pelvis','Pelvis','hip','Hip'},idx={(1+1)}},l_shoulder={names={'left shoulder','Left Shoulder','left upper arm','Left Upper Arm','LeftArm'},idx={(16+1)}},l_elbow={names={'left elbow','Left Elbow','left forearm','Left Forearm'},idx={(9*2)}},l_hand={names={'left hand','Left Hand'},idx={(7*2)}},r_shoulder={names={'right shoulder','Right Shoulder','right upper arm','Right Upper Arm','RightArm'},idx={(5*3)}},r_elbow={names={'right elbow','Right Elbow','right forearm','Right Forearm'},idx={(8*2)}},r_hand={names={'right hand','Right Hand'},idx={(12+1)}},l_hip={names={'left hip','Left Hip','left thigh','Left Thigh','LeftLeg'},idx={(4*2)}},l_knee={names={'left knee','Left Knee','left calf','Left Calf'},idx={(5*2)}},l_foot={names={'left foot','Left Foot'},idx={(6*2)}},r_hip={names={'right hip','Right Hip','right thigh','Right Thigh','RightLeg'},idx={(6+1)}},r_knee={names={'right knee','Right Knee','right calf','Right Calf'},idx={(3*3)}},r_foot={names={'right foot','Right Foot'},idx={(10+1)}}}


local function find(ent, def)
    if not ent or not def then return end
    for i = (1), #(def.names or {}) do
        local x, y, z = entity.hitbox_position(ent, def.names[i])
        if x then return x, y, z end
    end
    for i = (1), #(def.idx or {}) do
        local x, y, z = entity.hitbox_position(ent, def.idx[i])
        if x then return x, y, z end
    end
end


local function var_0_251(target)
    local pts = {}
    for key, def in pairs(boxes) do
        local x, y, z = find(target, def)
        if x then pts[key] = {x = x, y = y, z = z} end
    end
    local c = (0)
    for _ in pairs(pts) do c = c + (1) if c > (1) then break end end
    if c < (1+1) then return end
    return pts
end


local sk = {var_0_155 = {}}

local function var_0_145()
    local ref = ui.reference and ui.reference('AA', 'Fake Lag', 'hitmarker')
    if not ref then return false end
    local sel = ui.get(ref)
    if type(sel) == "table" then
        for _, v in ipairs(sel) do
            if v == "skeleton" then return true end
        end
    end
    return false
end

client.set_event_callback('aim_fire', function(ev)
    if not var_0_145() then sk.var_0_155 = {} return end
    if not var_0_145() then return end
    local target = ev and (ev.target or ev.target_index)
    if type(target) ~= 'number' or target == (0) then return end
    local pts = var_0_251(target)
    if not pts then return end
    local var_0_173 = globals.realtime and globals.realtime() or (0)
    sk.var_0_155[#sk.var_0_155 + (1)] = {pts = pts, t = var_0_173}
    if #sk.var_0_155 > (4+1) then table.remove(sk.var_0_155, (1)) end
end)

client.set_event_callback('paint', function()
    if var_0_145() then
        local var_0_173 = globals.realtime and globals.realtime() or (0)
        local hold = (2.2) * (0.8) * (2+1)
        local fade = (2.2) * (0.8)
        local total = hold + fade
        
        local i = (1)
        while i <= #sk.var_0_155 do
            if var_0_173 - (sk.var_0_155[i].t or (0)) > total then
                table.remove(sk.var_0_155, i)
            else
                i = i + (1)
            end
        end
        
        table.sort(sk.var_0_155, function(a, b) return (a.t or (0)) < (b.t or (0)) end)
        
        local start = math.max((1), #sk.var_0_155 - (1+1))
        for j = start, #sk.var_0_155 do
            local it = sk.var_0_155[j]
            local age = var_0_173 - (it.t or (0))
            local alpha = age <= hold and (110*2) or math.floor(math.max((0), ((1) - math.max((0), age - hold) / fade) * (110*2)))
            if alpha > (0) then
                local pts = it.pts or {}
                for c = (1), #chains do
                    local chain = chains[c]
                    local from, to = pts[chain[(1)] ], pts[chain[(1+1)] ]
                    if from and to then
                        local fx, fy = renderer.world_to_screen(from.x, from.y, from.z)
                        local tx, ty = renderer.world_to_screen(to.x, to.y, to.z)
                        if fx and tx then renderer.line(fx, fy, tx, ty, 255, 255, 255, alpha) end
                    end
                end
            end
        end
    else
        sk.var_0_155 = {}
    end
end)]]
__bundle["require/features/paint/performance_mode"] = [[



local ok, var_0_166 = pcall(require, "require/abc/menu_setup")


local cb = nil
pcall(function() cb = require('require/abc/callbacks') end)
if not cb then error("callbacks manager required: require/abc/callbacks") end


local orig = {
    captured = false
}

local last_state = {
    blood = nil,
    ragdolls = nil,
    particles = nil,
    lensflare = nil,
    animations = nil,
    features = nil,
}

local function var_0_33()
    if orig.captured then return end
    local function var_0_222(name, fallback)
        local ok, v = pcall(client.get_cvar, name)
        if ok and v then return v end
        return fallback
    end

    orig.violence_hblood = var_0_222('violence_hblood', '1')
    orig.cl_ragdoll_physics_enable = var_0_222('cl_ragdoll_physics_enable', '1')
    orig.r_drawparticles = var_0_222('r_drawparticles', '1')
    orig.mat_disable_bloom = var_0_222('mat_disable_bloom', '0')
    orig.captured = true
end

local function var_0_238(name, value)
    
    pcall(client.exec, string.format('%s %s', name, tostring(value)))
end

local function var_0_15(key, var_0_71)
    if key == 'blood' then
        if var_0_71 then var_0_238('violence_hblood', (0)) else var_0_238('violence_hblood', orig.violence_hblood or (1)) end
    elseif key == 'ragdolls' then
        if var_0_71 then var_0_238('cl_ragdoll_physics_enable', (0)) else var_0_238('cl_ragdoll_physics_enable', orig.cl_ragdoll_physics_enable or (1)) end
    elseif key == 'particles' then
        if var_0_71 then var_0_238('r_drawparticles', (0)) else var_0_238('r_drawparticles', orig.r_drawparticles or (1)) end
    elseif key == 'lensflare' then
        if var_0_71 then var_0_238('mat_disable_bloom', (1)) else var_0_238('mat_disable_bloom', orig.mat_disable_bloom or (0)) end
    end
end

local function var_0_272(has)
    
    
    if has['animations'] then
        _G.PERFORMANCE_ANIMATIONS = false
    else
        
        _G.PERFORMANCE_ANIMATIONS = true
    end

    if has['feature updates'] then
        _G.PERFORMANCE_FEATURE_UPDATES = false
    else
        _G.PERFORMANCE_FEATURE_UPDATES = true
    end
end

local function var_0_259(t)
    local out = {}
    if type(t) == 'table' then
        for _, v in ipairs(t) do out[v] = true end
    end
    return out
end


cb.var_0_201('paint', function()
    if not ok or not var_0_166 or not var_0_166.ui or not var_0_166.ui.paint_performance_mode then return end
    var_0_33()

    local sel = ui.get(var_0_166.ui.paint_performance_mode)
    local has = var_0_259(sel)

    
    local want = has['blood'] or false
    if want ~= last_state.blood then
        var_0_15('blood', want)
        last_state.blood = want
    end

    
    want = has['ragdolls'] or false
    if want ~= last_state.ragdolls then
        var_0_15('ragdolls', want)
        last_state.ragdolls = want
    end

    
    want = has['particles'] or false
    if want ~= last_state.particles then
        var_0_15('particles', want)
        last_state.particles = want
    end

    
    want = has['lens flare'] or false
    if want ~= last_state.lensflare then
        var_0_15('lensflare', want)
        last_state.lensflare = want
    end

    
    want = has['animations'] or false
    if want ~= last_state.animations then
        
        var_0_272(has)
        last_state.animations = want
        last_state.features = has['feature updates'] or false
    end

    
    local want_features = has['feature updates'] or false
    if want_features ~= last_state.features then
        var_0_272(has)
        last_state.features = want_features
    end
end, { require_login = true, alive_only = true })


cb.var_0_201('shutdown', function()
    if orig.captured then
        pcall(var_0_238, 'violence_hblood', orig.violence_hblood)
        pcall(var_0_238, 'cl_ragdoll_physics_enable', orig.cl_ragdoll_physics_enable)
        pcall(var_0_238, 'r_drawparticles', orig.r_drawparticles)
        pcall(var_0_238, 'mat_disable_bloom', orig.mat_disable_bloom)
    end
    
    _G.PERFORMANCE_ANIMATIONS = true
    _G.PERFORMANCE_FEATURE_UPDATES = true
end, { require_login = true, alive_only = true })


if _G.PERFORMANCE_ANIMATIONS == nil then _G.PERFORMANCE_ANIMATIONS = true end
if _G.PERFORMANCE_FEATURE_UPDATES == nil then _G.PERFORMANCE_FEATURE_UPDATES = true end

return {
    _internal = {
        orig = orig,
        last_state = last_state,
    }
}
]]
__bundle["require/features/paint/presmoke_warning"] = [[local round_info = { start = nil, limit = nil }

client.set_event_callback("round_start", function(e)
	round_info.start = globals.curtime()
	round_info.limit = tonumber(e.timelimit) or tonumber(e.round_time) or (23*5)
end)

local function var_0_197()
	local gr = entity.get_game_rules()
	if not gr then return nil end
	local candidates = {
		"m_flGameTimeRemaining",
		"m_flRoundTimeRemaining",
		"m_fRoundStartTime",
		"m_flRoundStartTime",
		"m_iRoundTime",
		"m_iRoundTimeLimit",
	}
	for _, name in ipairs(candidates) do
		local ok, val = pcall(entity.get_prop, gr, name)
		if ok and val and type(val) == "number" then
			if name:lower():find("remain") then
				return math.max((0), val)
			end
		end
	end
	local start = nil
	for _, name in ipairs({"m_fRoundStartTime", "m_flRoundStartTime"}) do
		local ok, val = pcall(entity.get_prop, gr, name)
		if ok and val and type(val) == "number" then
			start = val
			break
		end
	end
	if start then
		local limit = nil
		local ok, v = pcall(entity.get_prop, gr, "m_iRoundTime")
		if ok and v and type(v) == "number" then limit = v end
		if not limit then
			limit = tonumber(client.get_cvar("mp_roundtime")) or tonumber(client.get_cvar("mp_roundtime_defuse"))
		end
		if limit and type(limit) == "number" then
			local left = limit - (globals.curtime() - start)
			return math.max((0), left)
		end
	end
	return nil
end

local function var_0_118()
	if round_info.start and round_info.limit then
		local elapsed = globals.curtime() - round_info.start
		local left = round_info.limit - elapsed
		if left < (0) then left = (0) end
		return left
	end
	return var_0_197()
end

client.set_event_callback("paint", function()
	local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
	if not menu_ok or not var_0_166 or not var_0_166.ui then return end
	local ok_get, paint_presmoke = pcall(ui.get, var_0_166.ui.paint_presmoke)
	if not ok_get or not paint_presmoke then return end

	local left = var_0_118()
	if not left then return end
	if left <= (9*2) then
		local w, h = client.screen_size()
		local center_x = w * (0.5)
		local y = math.floor(h * (0.3))
		local secs = string.format("%.2f", left)
		local text = string.format("PRESMOKE NOW PRESMOKE NOW %s", secs)
		renderer.text(center_x, y, 255, 30, 30, 255, "cb+", (0), text)
	end
end)

client.set_event_callback("round_end", function()
	round_info.start = nil
	round_info.limit = nil
end)

client.set_event_callback("cs_game_disconnected", function()
	round_info.start = nil
	round_info.limit = nil
end)

]]
__bundle["require/features/paint/self_boxes"] = [[


local sk={var_0_155={}}
local chains={{'head','neck'},{'neck','chest'},{'chest','stomach'},{'stomach','pelvis'},{'pelvis','l_hip'},{'l_hip','l_knee'},{'l_knee','l_foot'},{'pelvis','r_hip'},{'r_hip','r_knee'},{'r_knee','r_foot'},{'chest','l_shoulder'},{'l_shoulder','l_elbow'},{'l_elbow','l_hand'},{'chest','r_shoulder'},{'r_shoulder','r_elbow'},{'r_elbow','r_hand'}}
local boxes={head={names={'head','Head','HEAD'},idx={(0)}},neck={names={'neck','Neck'},idx={(1)}},chest={names={'chest','Chest','upper chest','Upper Chest'},idx={(2*2),(4+1),(3*2)}},stomach={names={'stomach','Stomach','abdomen','Abdomen'},idx={(1+1),(2+1)}},pelvis={names={'pelvis','Pelvis','hip','Hip'},idx={(1+1)}},l_shoulder={names={'left shoulder','Left Shoulder','left upper arm','Left Upper Arm','LeftArm'},idx={(16+1)}},l_elbow={names={'left elbow','Left Elbow','left forearm','Left Forearm'},idx={(9*2)}},l_hand={names={'left hand','Left Hand'},idx={(7*2)}},r_shoulder={names={'right shoulder','Right Shoulder','right upper arm','Right Upper Arm','RightArm'},idx={(5*3)}},r_elbow={names={'right elbow','Right Elbow','right forearm','Right Forearm'},idx={(8*2)}},r_hand={names={'right hand','Right Hand'},idx={(12+1)}},l_hip={names={'left hip','Left Hip','left thigh','Left Thigh','LeftLeg'},idx={(4*2)}},l_knee={names={'left knee','Left Knee','left calf','Left Calf'},idx={(5*2)}},l_foot={names={'left foot','Left Foot'},idx={(6*2)}},r_hip={names={'right hip','Right Hip','right thigh','Right Thigh','RightLeg'},idx={(6+1)}},r_knee={names={'right knee','Right Knee','right calf','Right Calf'},idx={(3*3)}},r_foot={names={'right foot','Right Foot'},idx={(10+1)}}}
local function find(ent,def)
  if not ent or not def then return end
  local names=def.names
  if names then
    for i=(1),#names do
      local x,y,z=entity.hitbox_position(ent,names[i])
      if x then return x,y,z end
    end
  end
  local idx=def.idx
  if idx then
    for i=(1),#idx do
      local x,y,z=entity.hitbox_position(ent,idx[i])
      if x then return x,y,z end
    end
  end
end
local function var_0_251(target)
  local pts={}
  for key,def in pairs(boxes) do
    local x,y,z=find(target,def)
    if x then pts[key]={x=x,y=y,z=z} end
  end
  local c=(0)
  for _ in pairs(pts) do c=c+(1) if c>(1) then break end end
  if c<(1+1) then return end
  return pts
end



local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
local function var_0_144()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_skeleton then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_skeleton)
    if ok then return val end
  end
  
  return true
end


local ui_extrap_check, ui_extrap_ticks, ui_extrap_color
local ui_pred3d_check
local ui_pred3d_scale
if not (menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation) then
  
  ui_extrap_check = ui.new_checkbox('LUA', 'B', 'Self: Extrapolation Line')
  ui_extrap_ticks = ui.new_slider('LUA', 'B', 'Extrapolation ticks', (1), (32*2), (3*2))
  ui_extrap_color = ui.new_color_picker('LUA', 'B', 'Extrapolation color', (85*3), (100*2), (0), (110*2))
  ui_pred3d_check = ui.new_checkbox('LUA', 'B', 'Self: Predicted 3D Box')
  ui_pred3d_scale = ui.new_slider('LUA', 'B', 'Predicted 3D Box Scale %', (0), (100*2), (10*2))
end

local function var_0_143()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_extrapolation)
    if ok then return val end
  elseif ui_extrap_check then
    local ok, val = pcall(ui.get, ui_extrap_check)
    if ok then return val end
  end
  return false
end

local function var_0_107()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation_ticks then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_extrapolation_ticks)
    if ok then return val end
  elseif ui_extrap_ticks then
    local ok, val = pcall(ui.get, ui_extrap_ticks)
    if ok then return val end
  end
  return (3*2)
end

local function var_0_106()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation_color then
    local ok, r,g,b,a = pcall(ui.get, var_0_166.ui.paint_self_extrapolation_color)
    if ok then return r,g,b,a end
  elseif ui_extrap_color then
    local ok, r,g,b,a = pcall(ui.get, ui_extrap_color)
    if ok then return r,g,b,a end
  end
  return (85*3),(100*2),(0),(110*2)
end

local function var_0_142()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation_3d then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_extrapolation_3d)
    if ok then return val end
  elseif ui_pred3d_check then
    local ok, val = pcall(ui.get, ui_pred3d_check)
    if ok then return val end
  end
  return false
end

local function var_0_115()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_extrapolation_3d_scale then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_extrapolation_3d_scale)
    if ok then return val end
  elseif ui_pred3d_scale then
    local ok, val = pcall(ui.get, ui_pred3d_scale)
    if ok then return val end
  end
  return (10*2)
end

client.set_event_callback('paint',function()
  if not var_0_144() then return end
  local lp = entity.get_local_player()
  if not lp then return end
  
  local _lp_state = client.globals and client.globals.__self_lc_state or nil
  if not _lp_state then
    _lp_state = {}
    client.globals = client.globals or {}
    client.globals.__self_lc_state = _lp_state
  end
  local function var_0_151(x,y,z)
    x = x or (0); y = y or (0); z = z or (0)
    return x*x + y*y + z*z
  end
  local function var_0_260(seconds)
    local ti = globals.tickinterval and globals.tickinterval()
    if not ti or ti <= (0) then return (0) end
    return math.floor((seconds or (0)) / ti + (0.5))
  end
  local function var_0_139()
    local sim_time = entity.get_prop(lp, 'm_flSimulationTime')
    local ox,oy,oz = entity.get_origin(lp)
    if not sim_time or not ox then return false end
    local sim_ticks = var_0_260(sim_time)
    local prev = _lp_state.prev
    local breaking = false
    if prev then
      local delta = sim_ticks - prev.tick
      if delta > (0) and delta <= (32*2) then
        local dx,dy,dz = prev.origin.x - ox, prev.origin.y - oy, prev.origin.z - oz
        local teleport_distance = var_0_151(dx,dy,dz)
        if teleport_distance > (2048*2) then breaking = true end
      end
    end
    _lp_state.prev = { tick = sim_ticks, origin = { x = ox, y = oy, z = oz } }
    return breaking
  end
  local pts = var_0_251(lp)
  if not pts then return end
  local alpha = (110*2)
  for c=(1),#chains do
    local chain=chains[c]
    local from,to=pts[chain[(1)] ],pts[chain[(1+1)] ]
    if from and to then
      local fx,fy=renderer.world_to_screen(from.x,from.y,from.z)
      local tx,ty=renderer.world_to_screen(to.x,to.y,to.z)
      if fx and tx then renderer.line(fx,fy,tx,ty,255,255,255,alpha) end
    end
  end

  
  if var_0_143() then
    local ox,oy,oz = entity.get_origin(lp)
    if ox and oy and oz then
      local vx,vy,vz = entity.get_prop(lp, "m_vecVelocity")
      if vx and vy and vz then
        local ticks = var_0_107() or (3*2)
        local tickint = (globals.tickinterval and globals.tickinterval()) or (0.015625)
        local dt = tickint * ticks
        local px,py,pz = ox + vx * dt, oy + vy * dt, oz + vz * dt
        local sx1,sy1 = renderer.world_to_screen(ox,oy,oz)
        local sx2,sy2 = renderer.world_to_screen(px,py,pz)
        if sx1 and sx2 then
          local r,g,b,a = var_0_106()
          renderer.line(sx1,sy1,sx2,sy2, r, g, b, a)
          renderer.circle(sx2,sy2, r, g, b, a, 6, 0, 1.0)
          renderer.text(sx2, sy2 - 10, r, g, b, a, 'c+', (0), tostring(ticks) .. 't')
          
          local bx1,by1,bx2,by2,alpha_mult = entity.get_bounding_box(lp)
          if bx1 and alpha_mult and alpha_mult ~= (0) then
            local sx_orig, sy_orig = sx1, sy1
            if sx_orig and sy_orig then
              local dx, dy = sx2 - sx_orig, sy2 - sy_orig
              local bw, bh = (bx2 - bx1), (by2 - by1)
              local pbx, pby = bx1 + dx, by1 + dy
              
              renderer.rectangle(pbx, pby, bw, bh, 255,255,255,40)
              renderer.rectangle(pbx-1, pby-1, bw+2, bh+2, 255,255,255,200)
            end
          end

          
          if var_0_142() and var_0_139() then
            
            local o = {x = ox, y = oy, z = oz}
            local offs = {}
            local keys = {'head','pelvis','l_shoulder','r_shoulder','l_hip','r_hip'}
            for i=(1),#keys do
              local def = boxes[keys[i] ]
              if def then
                local ok, hx, hy, hz = pcall(function() return find(lp, def) end)
                if ok and hx then
                  table.insert(offs, {x = hx - o.x, y = hy - o.y, z = hz - o.z})
                end
              end
            end
            if #offs > (0) then
              local minx,miny,minz = offs[(1)].x,offs[(1)].y,offs[(1)].z
              local maxx,maxy,maxz = offs[(1)].x,offs[(1)].y,offs[(1)].z
              for i=(1+1),#offs do
                local v = offs[i]
                if v.x < minx then minx = v.x end
                if v.y < miny then miny = v.y end
                if v.z < minz then minz = v.z end
                if v.x > maxx then maxx = v.x end
                if v.y > maxy then maxy = v.y end
                if v.z > maxz then maxz = v.z end
              end
              
              local scale_pct = (35*3)
              local cx = (minx + maxx) * (0.5)
              local cy = (miny + maxy) * (0.5)
              local cz = (minz + maxz) * (0.5)
              local ex = (maxx - minx) * (0.5) * ((1) + scale_pct / (50*2))
              local ey = (maxy - miny) * (0.5) * ((1) + scale_pct / (50*2))
              local ez = (maxz - minz) * (0.5) * ((1) + scale_pct / (50*2))
              minx = cx - ex; maxx = cx + ex
              miny = cy - ey; maxy = cy + ey
              minz = cz - ez; maxz = cz + ez

              
              local corners = {
                {x = px + minx, y = py + miny, z = pz + minz},
                {x = px + maxx, y = py + miny, z = pz + minz},
                {x = px + maxx, y = py + maxy, z = pz + minz},
                {x = px + minx, y = py + maxy, z = pz + minz},
                {x = px + minx, y = py + miny, z = pz + maxz},
                {x = px + maxx, y = py + miny, z = pz + maxz},
                {x = px + maxx, y = py + maxy, z = pz + maxz},
                {x = px + minx, y = py + maxy, z = pz + maxz},
              }
              
              local sc = {}
              local all_on_screen = true
              for i=(1),(4*2) do
                local sx, sy = renderer.world_to_screen(corners[i].x, corners[i].y, corners[i].z)
                if not sx then all_on_screen = false break end
                sc[i] = {x = sx, y = sy}
              end
              if all_on_screen then
                
                local rr,gg,bb,aa = (85*3),(85*3),(85*3),(100*2)
                
                renderer.line(sc[1].x,sc[1].y,sc[2].x,sc[2].y, rr,gg,bb,aa)
                renderer.line(sc[2].x,sc[2].y,sc[3].x,sc[3].y, rr,gg,bb,aa)
                renderer.line(sc[3].x,sc[3].y,sc[4].x,sc[4].y, rr,gg,bb,aa)
                renderer.line(sc[4].x,sc[4].y,sc[1].x,sc[1].y, rr,gg,bb,aa)
                
                renderer.line(sc[5].x,sc[5].y,sc[6].x,sc[6].y, rr,gg,bb,aa)
                renderer.line(sc[6].x,sc[6].y,sc[7].x,sc[7].y, rr,gg,bb,aa)
                renderer.line(sc[7].x,sc[7].y,sc[8].x,sc[8].y, rr,gg,bb,aa)
                renderer.line(sc[8].x,sc[8].y,sc[5].x,sc[5].y, rr,gg,bb,aa)
                
                for i=1,4 do renderer.line(sc[i].x,sc[i].y,sc[i+4].x,sc[i+4].y, rr,gg,bb,aa) end
              end
            end
          end
        end
      end
    end
  end
end)]]
__bundle["require/features/paint/self_skeleton"] = [[


local sk={var_0_155={}}
local chains={{'head','neck'},{'neck','chest'},{'chest','stomach'},{'stomach','pelvis'},{'pelvis','l_hip'},{'l_hip','l_knee'},{'l_knee','l_foot'},{'pelvis','r_hip'},{'r_hip','r_knee'},{'r_knee','r_foot'},{'chest','l_shoulder'},{'l_shoulder','l_elbow'},{'l_elbow','l_hand'},{'chest','r_shoulder'},{'r_shoulder','r_elbow'},{'r_elbow','r_hand'}}
local boxes={head={names={'head','Head','HEAD'},idx={(0)}},neck={names={'neck','Neck'},idx={(1)}},chest={names={'chest','Chest','upper chest','Upper Chest'},idx={(2*2),(4+1),(3*2)}},stomach={names={'stomach','Stomach','abdomen','Abdomen'},idx={(1+1),(2+1)}},pelvis={names={'pelvis','Pelvis','hip','Hip'},idx={(1+1)}},l_shoulder={names={'left shoulder','Left Shoulder','left upper arm','Left Upper Arm','LeftArm'},idx={(16+1)}},l_elbow={names={'left elbow','Left Elbow','left forearm','Left Forearm'},idx={(9*2)}},l_hand={names={'left hand','Left Hand'},idx={(7*2)}},r_shoulder={names={'right shoulder','Right Shoulder','right upper arm','Right Upper Arm','RightArm'},idx={(5*3)}},r_elbow={names={'right elbow','Right Elbow','right forearm','Right Forearm'},idx={(8*2)}},r_hand={names={'right hand','Right Hand'},idx={(12+1)}},l_hip={names={'left hip','Left Hip','left thigh','Left Thigh','LeftLeg'},idx={(4*2)}},l_knee={names={'left knee','Left Knee','left calf','Left Calf'},idx={(5*2)}},l_foot={names={'left foot','Left Foot'},idx={(6*2)}},r_hip={names={'right hip','Right Hip','right thigh','Right Thigh','RightLeg'},idx={(6+1)}},r_knee={names={'right knee','Right Knee','right calf','Right Calf'},idx={(3*3)}},r_foot={names={'right foot','Right Foot'},idx={(10+1)}}}
local function find(ent,def)
  if not ent or not def then return end
  local names=def.names
  if names then
    for i=(1),#names do
      local x,y,z=entity.hitbox_position(ent,names[i])
      if x then return x,y,z end
    end
  end
  local idx=def.idx
  if idx then
    for i=(1),#idx do
      local x,y,z=entity.hitbox_position(ent,idx[i])
      if x then return x,y,z end
    end
  end
end
local function var_0_251(target)
  local pts={}
  for key,def in pairs(boxes) do
    local x,y,z=find(target,def)
    if x then pts[key]={x=x,y=y,z=z} end
  end
  local c=(0)
  for _ in pairs(pts) do c=c+(1) if c>(1) then break end end
  if c<(1+1) then return end
  return pts
end



local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
local function var_0_144()
  if menu_ok and var_0_166 and var_0_166.ui and var_0_166.ui.paint_self_skeleton then
    local ok, val = pcall(ui.get, var_0_166.ui.paint_self_skeleton)
    if ok then return val end
  end
  
  return true
end

client.set_event_callback('paint',function()
  if not var_0_144() then return end
  local lp = entity.get_local_player()
  if not lp then return end
  local pts = var_0_251(lp)
  if not pts then return end
  local alpha = (110*2)
  for c=(1),#chains do
    local chain=chains[c]
    local from,to=pts[chain[(1)] ],pts[chain[(1+1)] ]
    if from and to then
      local fx,fy=renderer.world_to_screen(from.x,from.y,from.z)
      local tx,ty=renderer.world_to_screen(to.x,to.y,to.z)
      if fx and tx then renderer.line(fx,fy,tx,ty,255,255,255,alpha) end
    end
  end
end)]]
__bundle["require/features/paint/skeletons"] = [[local chains = {{'head','neck'},{'neck','chest'},{'chest','stomach'},{'stomach','pelvis'},{'pelvis','l_hip'},{'l_hip','l_knee'},{'l_knee','l_foot'},{'pelvis','r_hip'},{'r_hip','r_knee'},{'r_knee','r_foot'},{'chest','l_shoulder'},{'l_shoulder','l_elbow'},{'l_elbow','l_hand'},{'chest','r_shoulder'},{'r_shoulder','r_elbow'},{'r_elbow','r_hand'}}
local boxes = {head={names={'head','Head','HEAD'},idx={(0)}},neck={names={'neck','Neck'},idx={(1)}},chest={names={'chest','Chest','upper chest','Upper Chest'},idx={(2*2),(4+1),(3*2)}},stomach={names={'stomach','Stomach','abdomen','Abdomen'},idx={(1+1),(2+1)}},pelvis={names={'pelvis','Pelvis','hip','Hip'},idx={(1+1)}},l_shoulder={names={'left shoulder','Left Shoulder','left upper arm','Left Upper Arm','LeftArm'},idx={(16+1)}},l_elbow={names={'left elbow','Left Elbow','left forearm','Left Forearm'},idx={(9*2)}},l_hand={names={'left hand','Left Hand'},idx={(7*2)}},r_shoulder={names={'right shoulder','Right Shoulder','right upper arm','Right Upper Arm','RightArm'},idx={(5*3)}},r_elbow={names={'right elbow','Right Elbow','right forearm','Right Forearm'},idx={(8*2)}},r_hand={names={'right hand','Right Hand'},idx={(12+1)}},l_hip={names={'left hip','Left Hip','left thigh','Left Thigh','LeftLeg'},idx={(4*2)}},l_knee={names={'left knee','Left Knee','left calf','Left Calf'},idx={(5*2)}},l_foot={names={'left foot','Left Foot'},idx={(6*2)}},r_hip={names={'right hip','Right Hip','right thigh','Right Thigh','RightLeg'},idx={(6+1)}},r_knee={names={'right knee','Right Knee','right calf','Right Calf'},idx={(3*3)}},r_foot={names={'right foot','Right Foot'},idx={(10+1)}}}


local time = require("require/help/time")
local enemies = require("require/help/enemies")
local color = require("require/help/color")
local math_help = require("require/help/math")




local function find(ent, def)
    if not ent or not def then return end
    local names = def.names
    if names then
        for i = (1), #names do
            local x, y, z = entity.hitbox_position(ent, names[i])
            if x then return x, y, z end
        end
    end
    local idx = def.idx
    if idx then
        for i = (1), #idx do
            local x, y, z = entity.hitbox_position(ent, idx[i])
            if x then return x, y, z end
        end
    end
end


local function var_0_251(target)
    local pts = {}
    for key, def in pairs(boxes) do
        local x, y, z = find(target, def)
        if x then pts[key] = {x = x, y = y, z = z} end
    end
    return pts
end


client.set_event_callback("paint", function()
    local enemy_list = entity.get_players(true)
    for i = (1), #enemy_list do
        local ent = enemy_list[i]
        if entity.is_alive(ent) and not entity.is_dormant(ent) then
            local pts = var_0_251(ent)
            for _, chain in ipairs(chains) do
                local from = pts[chain[(1)] ]
                local to = pts[chain[(1+1)] ]
                if from and to then
                    local fx, fy = renderer.world_to_screen(from.x, from.y, from.z)
                    local tx, ty = renderer.world_to_screen(to.x, to.y, to.z)
                    if fx and fy and tx and ty then
                        renderer.line(fx, fy, tx, ty, 255, 0, 0, 255)
                    end
                end
            end
        end
    end
end)

]]
__bundle["require/features/paint/target_info"] = [[local var_0_166 = require("require/abc/menu_setup")
local renderer = renderer
local client = client


local dot_texture_id = nil
local function var_0_105()
	if dot_texture_id then return dot_texture_id end
	if renderer.load_rgba then
		local ok, texture = pcall(renderer.load_rgba,
			string.char(
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3)
			), (2*2), (2*2))
		if ok and texture then dot_texture_id = texture end
	end
	return dot_texture_id
end




local state = state or {
	fl_val = math.random((0), (7*2)),
	fl_target = math.random((0), (7*2)),
	by_val = math.random((-(29*2)), (29*2)),
	by_target = math.random((-(29*2)), (29*2)),
	last_update = client.system_time()
}


local function var_0_274()
	state.fl_val = math.random((0), (7*2))
	state.by_val = math.random((-(29*2)), (29*2))
end



local function var_0_275()
	local var_0_173 = client.system_time()
	if var_0_173 - state.last_update > (1) then
		state.fl_target = math.random((0), (7*2))
		state.by_target = math.random((-(29*2)), (29*2))
		state.last_update = var_0_173
	end
end

local function var_0_153()
	state.fl_val = state.fl_val + (state.fl_target - state.fl_val) * (0.08)
	state.by_val = state.by_val + (state.by_target - state.by_val) * (0.08)
end

local function var_0_177()
	if not ui.get(var_0_166.ui.paint_target_info) then return end

	var_0_275()
	var_0_153()
	var_0_274() 

	
	local screen_w, screen_h = client.screen_size()
	local panel_w = (85*2)
	local panel_h = (40*2)
	local panel_x = (15*2)
	local panel_y = math.floor(screen_h / (1+1) - panel_h / (1+1))

	
	renderer.rectangle(panel_x - 7, panel_y - 5, panel_w + 14, panel_h + 10, 0, 0, 0, 200)
	renderer.rectangle(panel_x - 6, panel_y - 4, panel_w + 12, panel_h + 8, 60, 60, 60, 255)
	renderer.rectangle(panel_x - 5, panel_y - 3, panel_w + 10, panel_h + 6, 40, 40, 40, 255)
	renderer.rectangle(panel_x - 3, panel_y - 1, panel_w + 6, panel_h + 2, 60, 60, 60, 255)
	renderer.rectangle(panel_x - 2, panel_y, panel_w + 4, panel_h, 12, 12, 12, 255)
	renderer.rectangle(panel_x - 2, panel_y, panel_w + 4, panel_h, 32, 32, 32, 255)

	
	local tex_id = var_0_105()
	if tex_id and renderer.texture then
		renderer.texture(tex_id, panel_x - 2, panel_y, panel_w + 4, panel_h, 255,255,255,60, 'r')
	end

	
	local accent_y = panel_y
	local accent_h = (1)
	local accent_w1 = math.floor((panel_w + (2*2)) / (1+1))
	local accent_w2 = math.ceil((panel_w + (2*2)) / (1+1))
	
	renderer.rectangle(panel_x - 2, accent_y - 1, panel_w + 4, accent_h + 2, 0, 0, 0, 255)
	if renderer.gradient then
		renderer.gradient(panel_x - 2, accent_y, accent_w1, accent_h, 59,175,222,255, 202,70,205,255, true)
		renderer.gradient(panel_x - 2 + accent_w1, accent_y, accent_w2, accent_h, 202,70,205,255, 204,227,53,255, true)
	end

	
	local row_x = panel_x + (6*2)
	local row_y = panel_y + (12+1)  
	local row_h = (9*2)
	local slider_w = panel_w - (30*2) 
	local slider_h = (6+1) 

	
	local fake_lag_val = math.floor(state.fl_val + (0.5))
	
	local label_offset_y = slider_h / (1+1) - (6+1)
	renderer.text(row_x - 8, row_y + label_offset_y, 255,255,255,255, '', (0), "Fake lag")
	local fl_slider_x = row_x + (21*2) 
	local fl_slider_y = row_y + (3*2)  
	local fl_slider_max = (7*2)
	local fl_fill_w = math.floor(slider_w * (state.fl_val / fl_slider_max))
	
	local slider_outline_w = slider_w + (1+1)
	local slider_outline_h = slider_h + (1+1)
	local slider_fill_x = fl_slider_x + (1)
	local slider_fill_y = fl_slider_y + (1)
	local slider_fill_w = slider_w - (1+1)
	local slider_fill_h = slider_h - (1+1)
	renderer.rectangle(fl_slider_x - 1, fl_slider_y - 1, slider_outline_w, slider_outline_h, 0, 0, 0, 255)
	renderer.rectangle(fl_slider_x, fl_slider_y, slider_w, slider_h, 60, 60, 60, 255)
	renderer.rectangle(slider_fill_x, slider_fill_y, math.max(0, math.floor(slider_fill_w * (state.fl_val / fl_slider_max))), slider_fill_h, 180, 220, 80, 255)
	local fl_handle_x = fl_slider_x + fl_fill_w - (2*2)
	local fl_handle_y = fl_slider_y + slider_h / (1+1)
	renderer.circle(fl_handle_x, fl_handle_y, 5, 180,220,80,255, 16)
	
	local fl_value_text = tostring(fake_lag_val)
	local fl_value_x = fl_slider_x + fl_fill_w + (4*2) 
	local fl_value_y = fl_slider_y + slider_h + (0) 
	renderer.text(fl_value_x + 1, fl_value_y + 1, 0,0,0,255, '-', (0), fl_value_text)
	renderer.text(fl_value_x, fl_value_y, 255,255,255,255, '-', (0), fl_value_text)

	
	local body_yaw_val = math.floor(state.by_val + (0.5))
	renderer.text(row_x - 8, row_y + row_h + label_offset_y, 255,255,255,255, '', (0), "Body yaw")
	local by_slider_x = row_x + (21*2) 
	local by_slider_y = row_y + row_h + (3*2)  
	local by_slider_min = (-(29*2))
	local by_slider_max = (29*2)
	local by_slider_range = by_slider_max - by_slider_min
	
	local by_fill_w = math.floor(slider_w * ((state.by_val - by_slider_min) / by_slider_range))
	
	local by_slider_outline_w = slider_w + (1+1)
	local by_slider_outline_h = slider_h + (1+1)
	local by_slider_fill_x = by_slider_x + (1)
	local by_slider_fill_y = by_slider_y + (1)
	local by_slider_fill_w = slider_w - (1+1)
	local by_slider_fill_h = slider_h - (1+1)
	renderer.rectangle(by_slider_x - 1, by_slider_y - 1, by_slider_outline_w, by_slider_outline_h, 0, 0, 0, 255)
	renderer.rectangle(by_slider_x, by_slider_y, slider_w, slider_h, 60, 60, 60, 255)
	
	local center_x = by_slider_x + slider_w / (1+1)
	local value_x = by_slider_x + by_fill_w
	if state.by_val < (0) then
		renderer.rectangle(value_x + 1, by_slider_fill_y, center_x - value_x, by_slider_fill_h, 180, 220, 80, 255)
	else
		renderer.rectangle(center_x + 1, by_slider_fill_y, value_x - center_x, by_slider_fill_h, 180, 220, 80, 255)
	end
	local by_handle_x = value_x - (2*2)
	local by_handle_y = by_slider_y + slider_h / (1+1)
	renderer.circle(by_handle_x, by_handle_y, 5, 180,220,80,255, 16)
	
	local by_value_text = tostring(body_yaw_val)
	local by_fill_x = by_slider_x + by_fill_w
	local by_value_x = by_fill_x + (4*2) 
	local by_value_y = by_slider_y + slider_h + (0) 
	renderer.text(by_value_x + 1, by_value_y + 1, 0,0,0,255, '-', (0), by_value_text)
	renderer.text(by_value_x, by_value_y, 255,255,255,255, '-', (0), by_value_text)

	
	local val_box_w = (11*2)
	local val_box_h = (7*2)

	
	local dt_status = math.random() > (0.5) and "[Offensive]" or "[Defensive]"
	local dt_color = dt_status == "[Offensive]" and {(102*2),(226+1),(52+1),(85*3)} or {(101*2),(35*2),(41*5),(85*3)}
	renderer.text(row_x - 8, row_y + row_h * 2 + label_offset_y, 255,255,255,255, '', (0), "Double tap")
	local dt_box_x = row_x + slider_w + (16*2)
	local dt_box_y = row_y + row_h * (1+1) - (1+1)
	renderer.text(dt_box_x + 4, dt_box_y + 2, table.unpack(dt_color), '', (0), dt_status)

	
	local fs_status = math.random() > (0.5) and "[On]" or "[Off]"
	local fs_color = fs_status == "[On]" and {(40*2),(85*3),(40*2),(85*3)} or {(85*3),(85*3),(40*2),(85*3)}
	renderer.text(row_x - 8, row_y + row_h * 3 + label_offset_y, 255,255,255,255, '', (0), "Freestanding")
	local fs_box_x = row_x + slider_w + (16*2)
	local fs_box_y = row_y + row_h * (2+1) - (1+1)
	renderer.text(fs_box_x + 4, fs_box_y + 2, table.unpack(fs_color), '', (0), fs_status)
end

client.set_event_callback("paint", var_0_177)
]]
__bundle["require/features/paint/text_watermark"] = [[local var_0_218 = function(r,g,b,a) return string.format("\a%02x%02x%02x%02x", r,g,b,a or (85*3)) end
local function var_0_9(speed, r,g,b,a, text)
    local t = globals.realtime() or globals.curtime()
    if not text or #text == (0) then return "" end
    local out = {}
    for i=(1),#text do
        local f = (math.sin(t*speed - i*(0.35)) + (1)) * (0.5)
        local la = math.floor(a * ((0.4) + (0.6) * f))
        out[#out+(1)] = var_0_218(r,g,b,la) .. text:sub(i,i)
    end
    return table.concat(out)
end

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'misc', 'settings', 'menu color' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

client.set_event_callback("paint", function()
    local sw, sh = client.screen_size()
    if not sw or not sh then return end

    
    
    local mr, mg, mb, ma = (85*3), (85*3), (85*3), (85*3)
    local ok_get, a, b, c, d = pcall(ui.get, gs_item_refs[(1)][(1)])
    if ok_get then
        if type(a) == 'number' then
            mr = math.floor(a or mr)
            mg = math.floor(b or mg)
            mb = math.floor(c or mb)
            ma = math.floor(d or ma)
        elseif type(a) == 'string' and #a == (6*2) then
            local ok
            ok, mr = pcall(function() return tonumber(a:sub((1),(2+1))) end)
            ok, mg = pcall(function() return tonumber(a:sub((2*2),(3*2))) end)
            ok, mb = pcall(function() return tonumber(a:sub((6+1),(3*3))) end)
            ok, ma = pcall(function() return tonumber(a:sub((5*2),(6*2))) end)
            mr = mr or (85*3); mg = mg or (85*3); mb = mb or (85*3); ma = ma or (85*3)
        end
    end

    
    local menu_ok, var_0_166 = pcall(require, "require/abc/menu_setup")
    if not menu_ok or not var_0_166 or not var_0_166.ui then return end
    if not ui.get(var_0_166.ui.paint_advertisement) then return end
    local t = globals.realtime() or globals.curtime()

    local bob = (0)
    local alpha = math.floor((100*2) + (11*5) * (math.sin(t*(1+1))+(1))/(1+1))

    local main_text, suffix, spacing = "sodium", "[BETA]", (2+1)
    local base_x, base_y = sw/(1+1), sh - (5*3) + bob

    local mw = (renderer.measure_text("", main_text) or (0))
    local swid = (renderer.measure_text("", suffix) or (0))
    local left = base_x - (mw + spacing + swid)/(1+1)

    local shadow_a = math.floor(math.max((0), alpha - (70*2)) * (0.6))
    local offs = { {(-(1)),(0)},{(1),(0)},{(0),(-(1))},{(0),(1)} }
    for _,o in ipairs(offs) do renderer.text(left+o[1], base_y+o[2], 0,0,0, shadow_a, "", (0), main_text) end
    renderer.text(left, base_y, 255,255,255, alpha, "", (0), main_text)

    local anim_main = var_0_9((3.5), (85*3),(85*3),(85*3),(85*3), main_text)
    local sx = left + mw + spacing
    local anim_suf = var_0_9((3.5), mr, mg, mb, ma, suffix)
    renderer.text(left, base_y, 255,255,255,255, "", (0), anim_main)
    renderer.text(sx, base_y, mr, mg, mb, ma, "", (0), anim_suf)
end)
]]
__bundle["require/features/paint/third_person_distance"] = [[local var_0_166 = require("require/abc/menu_setup")
local T = require("require/help/time")
local M = require("require/help/math")
local Safe = require("require/help/safe")
local cam_state = { original = nil, last = nil, last_update = nil }

local function var_0_101()
    if cvar.cam_idealdist and cvar.cam_idealdist.get_float then
        return cvar.cam_idealdist:get_float()
    end
    return nil
end

local function var_0_237(val)
    if cvar.cam_idealdist and cvar.cam_idealdist.set_float then
        cvar.cam_idealdist:set_float(val)
        return true
    elseif client and client.exec then
        client.exec("cam_idealdist " .. tostring(val))
        return true
    end
    return false
end

client.set_event_callback('paint', function()
    if not ui.is_menu_open() then return end
    local ref = var_0_166.ui.paint_third_person_distance
    if not ref then return end
    local raw = Safe.var_0_222(ref)
    if type(raw) ~= 'number' then return end
    local target = M.var_0_35(raw, (28+1), (90*2))
    target = M.var_0_221(target, (1+1))
    if cam_state.original == nil then
        cam_state.original = var_0_101()
    end
    if cam_state.last == nil then
        cam_state.last = var_0_101() or target
    end
    local var_0_173 = T.realtime() or os.clock()
    local last_update = cam_state.last_update or var_0_173
    local dt = var_0_173 - last_update
    cam_state.last_update = var_0_173
    local speed = (150*2) 
    local step = speed * dt
    if math.abs(cam_state.last - target) > (0.01) then
        local t = M.var_0_35(step / math.max(math.abs(target - cam_state.last), (0.01)), (0), (1))
        cam_state.last = M.var_0_152(cam_state.last, target, t)
        cam_state.last = M.var_0_221(cam_state.last, (1+1))
        var_0_237(cam_state.last)
    end
end)]]
__bundle["require/features/paint/visual_configs"] = [[local clipboard = require('gamesense/clipboard')

local gs_item_refs = {}
local gs_ref_visible = {}
for i, item in ipairs({
    { 'Visuals', 'Player esp', 'teammates' },
    { 'Visuals', 'Player esp', 'dormant' },
    { 'Visuals', 'Player esp', 'bounding box' },
    { 'Visuals', 'Player esp', 'health bar' },
    { 'Visuals', 'Player esp', 'name' },
    { 'Visuals', 'Player esp', 'flags' },
    { 'Visuals', 'Player esp', 'weapon text' },
    { 'Visuals', 'Player esp', 'weapon icon' },
    { 'Visuals', 'Player esp', 'ammo' },
    { 'Visuals', 'Player esp', 'distance' },
    { 'Visuals', 'Player esp', 'glow' },
    { 'Visuals', 'Player esp', 'hit marker' },
    { 'Visuals', 'Player esp', 'hit marker sound' },
    { 'Visuals', 'Player esp', 'visualize aimbot' },
    { 'Visuals', 'Player esp', 'visualize aimbot (safe point)' },
    { 'Visuals', 'Player esp', 'visualize sounds' },
    { 'Visuals', 'Player esp', 'line of sight' },
    { 'Visuals', 'Player esp', 'money' },
    { 'Visuals', 'Player esp', 'skeleton' },
    { 'Visuals', 'Player esp', 'out of fov arrow' },
    { 'Visuals', 'Other esp', 'radar' },
    { 'Visuals', 'Other esp', 'dropped weapons' },
    { 'Visuals', 'Other esp', 'grenades' },
    { 'Visuals', 'Other esp', 'inaccuracy overlay' },
    { 'Visuals', 'Other esp', 'recoil overlay' },
    { 'Visuals', 'Other esp', 'crosshair' },
    { 'Visuals', 'Other esp', 'bomb' },
    { 'Visuals', 'Other esp', 'grenade trajectory' },
    { 'Visuals', 'Other esp', 'grenade trajectory (hit)' },
    { 'Visuals', 'Other esp', 'spectators' },
    { 'Visuals', 'Other esp', 'penetration reticle' },
    { 'Visuals', 'Colored models', 'player' },
    { 'Visuals', 'Colored models', 'player behind wall' },
    { 'Visuals', 'Colored models', 'teammate' },
    { 'Visuals', 'Colored models', 'teammate behind wall' },
    { 'Visuals', 'Colored models', 'local player' },
    { 'Visuals', 'Colored models', 'local player transparency' },
    { 'Visuals', 'Colored models', 'local player fake' },
    { 'Visuals', 'Colored models', 'on shot' },
    { 'Visuals', 'Colored models', 'ragdolls' },
    { 'Visuals', 'Colored models', 'hands' },
    { 'Visuals', 'Colored models', 'weapon viewmodel' },
    { 'Visuals', 'Colored models', 'weapons' },
    { 'Visuals', 'Colored models', 'disable model occlusion' },
    { 'Visuals', 'Colored models', 'shadow' },
    { 'Visuals', 'Colored models', 'props' },
    { 'Visuals', 'Effects', 'remove fog' },
    { 'Visuals', 'Effects', 'remove skybox' },
    { 'Visuals', 'Effects', 'transparent props' },
    { 'Visuals', 'Effects', 'brightness adjustment' },
    { 'Visuals', 'Effects', 'remove scope overlay' },
    { 'Visuals', 'Effects', 'instant scope' },
    { 'Visuals', 'Effects', 'disable post processing' },
    { 'Visuals', 'Effects', 'disable rendering of teammates' },
    { 'Visuals', 'Effects', 'disable rendering of ragdolls' },
    { 'Visuals', 'Effects', 'bullet tracers' },
    { 'Visuals', 'Effects', 'bullet impacts' },
    { 'Visuals', 'Effects', 'modulate harmless molotovs' },
}) do
    local refs = {ui.reference(item[(1)], item[(1+1)], item[(2+1)])}
    gs_item_refs[i] = refs
    for _, ref in ipairs(refs) do
        gs_ref_visible[ref] = true
    end
end

local function var_0_75(s)
    s = tostring(s)
    s = s:gsub('\\', '\\\\')
    s = s:gsub('\"', '\\"')
    s = s:gsub('\n', '\\n')
    s = s:gsub('\r', '\\r')
    s = s:gsub('\t', '\\t')
    return '"' .. s .. '"'
end

local function var_0_136(t)
    if type(t) ~= 'table' then return false end
    local i = (0)
    for _ in pairs(t) do
        i = i + (1)
        if t[i] == nil then return false end
    end
    return true
end

local function var_0_72(value)
    local vtype = type(value)
    if vtype == 'nil' then
        return 'nil'
    elseif vtype == 'boolean' then
        return value and 'true' or 'false'
    elseif vtype == 'number' then
        return tostring(value)
    elseif vtype == 'string' then
        return var_0_75(value)
    elseif vtype == 'table' then
        if var_0_136(value) then
            local parts = {}
            for i = (1), #value do
                parts[#parts+(1)] = var_0_72(value[i])
            end
            return '{' .. table.concat(parts, ',') .. '}'
        else
            local parts = {}
            for k,v in pairs(value) do
                local key = (type(k) == 'string') and ('["' .. k:gsub('"','\\"') .. '"]') or ('[' .. tostring(k) .. ']')
                parts[#parts+(1)] = key .. '=' .. var_0_72(v)
            end
            return '{' .. table.concat(parts, ',') .. '}'
        end
    else
        return var_0_75(tostring(value))
    end
end

local function var_0_27()
    local export = {}
    for i, refs in ipairs(gs_item_refs) do
        export[i] = {}
        for j = (1), (2+1) do
            local ref = refs[j]
            if ref then
                local tmp = { pcall(ui.get, ref) }
                local ok = tmp[(1)]
                if ok then
                    local vals = {}
                    for k = (1+1), #tmp do vals[#vals+(1)] = tmp[k] end
                    if #vals == (0) then
                        export[i][j] = nil
                    elseif #vals == (1) then
                        export[i][j] = vals[(1)]
                    else
                        export[i][j] = vals
                    end
                else
                    export[i][j] = nil
                end
            else
                export[i][j] = nil
            end
        end
    end
    return export
end

local function var_0_16(tbl)
    if type(tbl) ~= 'table' then return false, 'invalid import table' end
    for i, refs in ipairs(gs_item_refs) do
        local entry = tbl[i]
        if entry and type(entry) == 'table' then
            for j = (1), (2+1) do
                local ref = refs[j]
                if ref and entry[j] ~= nil then
                    local val = entry[j]
                    local ok, err
                    if type(val) == 'table' then
                        ok, err = pcall(function() ui.set(ref, unpack(val)) end)
                    else
                        ok, err = pcall(function() ui.set(ref, val) end)
                    end
                    if not ok then
                        client.error_log(('[Visuals] Failed to set ref #%d.%d: %s'):format(i, j, tostring(err)))
                    end
                end
            end
        end
    end
    return true
end

local export_btn = ui.new_button('CONFIG', 'PRESETS', 'Export (visuals)', function()
    if not clipboard or type(clipboard.set) ~= 'function' then
        client.error_log('[Visuals] Clipboard unavailable.')
        return
    end
    local export_tbl = var_0_27()
    local ok, str = pcall(function() return var_0_72(export_tbl) end)
    if not ok or not str then
        client.error_log('[Visuals] Failed to serialize export data.')
        return
    end
    clipboard.set(str)
    client.color_log((30*2), (90*2), (85*3), '[Visuals] Exported visuals data to clipboard.')
end)

local import_btn = ui.new_button('CONFIG', 'PRESETS', 'Import (visuals)', function()
    if not clipboard or type(clipboard.get) ~= 'function' then
        client.error_log('[Visuals] Clipboard unavailable.')
        return
    end
    local import_str = clipboard.get()
    if not import_str or import_str == '' then
        client.error_log('[Visuals] No config string found in clipboard.')
        return
    end

    local fn, load_err = load('return ' .. import_str)
    if not fn then
        client.error_log('[Visuals] Failed to parse import string: ' .. tostring(load_err))
        return
    end
    local ok, tbl = pcall(fn)
    if not ok or type(tbl) ~= 'table' then
        client.error_log('[Visuals] Imported data is invalid or not a table.')
        return
    end

    local ok2, err = pcall(function() var_0_16(tbl) end)
    if ok2 then
        client.color_log((30*2), (90*2), (85*3), '[Visuals] Successfully imported visuals from clipboard.')
    else
        client.error_log('[Visuals] Failed applying import: ' .. tostring(err))
    end
end)]]
__bundle["require/features/paint/warnings"] = [[local x, y = client.screen_size()
local _menu_ok, _menu_setup = pcall(require, "require/abc/menu_setup")


local function var_0_66()
    
    if not _menu_ok or not _menu_setup or not _menu_setup.ui or not _menu_setup.ui.paint_warnings then return end
    local sel = ui.get(_menu_setup.ui.paint_warnings)
    local show_lethal = false
    if type(sel) == "table" then
        for _, v in ipairs(sel) do
            if v == "lethal" then show_lethal = true break end
        end
    end
    if not show_lethal then return end

    if entity.get_prop(entity.get_local_player(), 'm_iHealth') and entity.get_prop(entity.get_local_player(), 'm_iHealth') > (0) and entity.get_prop(entity.get_local_player(), 'm_iHealth') < (31*3) then
        renderer.text(x / 2, y * 0.3, 255, 0, 0, 255, "c, -", (0), "YOU'RE LETHAL:   " .. entity.get_prop(entity.get_local_player(), 'm_iHealth') .. " HP REMAINING")
    end
    
end

client.set_event_callback('paint', var_0_66)]]
__bundle["require/features/paint/watermark"] = [[



local renderer = renderer
local client = client
local globals = globals


local function var_0_109()
	local frametime = globals and globals.frametime and globals.frametime() or (0.016)
	if frametime > (0) then
		return math.floor((1) / frametime + (0.5))
	end
	return (0)
end


local dot_texture_id = nil
local function var_0_105()
	if dot_texture_id then return dot_texture_id end
	if renderer.load_rgba then
		local ok, texture = pcall(renderer.load_rgba,
			string.char(
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),
				(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),(8*2),(8*2),(8*2),(85*3),(10*2),(10*2),(10*2),(85*3),
				(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3),(10*2),(10*2),(10*2),(85*3),(13*2),(13*2),(13*2),(85*3)
			), (2*2), (2*2))
		if ok and texture then dot_texture_id = texture end
	end
	return dot_texture_id
end





local function var_0_131(hex)
	hex = hex:gsub("#","")
	return tonumber(hex:sub((1),(1+1)),(8*2)), tonumber(hex:sub((2+1),(2*2)),(8*2)), tonumber(hex:sub((4+1),(3*2)),(8*2)), tonumber(hex:sub((6+1),(4*2)),(8*2))
end

local base_colors = {
	green  = "a5ca2aFF",
	red    = "d96464FF",
	yellow = "ccb854FF",
	blue   = "5462ccFF",
	purple = "7054ccFF",
	white  = "ffffffFF",
	grey   = "757575FF",
	black  = "000000FF",
	pink   = "c8a2deFF",
}


local login_system = require("require/abc/login_system")
local var_0_166 = require("require/abc/menu_setup")
local self = require("require/help/self")

local time = require("require/help/time")
local last_fps = (0)
local fps_timer = time.new((0.25))

local function var_0_68()
	if not var_0_166 or not var_0_166.ui or not var_0_166.ui.paint_watermark or not ui.get(var_0_166.ui.paint_watermark) then
		return
	end
	local screen_w, screen_h = client and client.screen_size and client.screen_size() or (400*2), (300*2)

	local username
	if login_system.logged_in then
		local cached = database.read and database.read('cached_credentials')
		if cached and cached.username then
			username = cached.username
		end
	else
		local creds = login_system.load_credentials and login_system.load_credentials()
		if creds and creds.username then
			username = creds.username
		end
	end
	if not username or username == "" then
		username = self.player_name and self.player_name() or "unknown"
	end
	if time.expired(fps_timer) then
		last_fps = var_0_109()
		time.var_0_208(fps_timer)
	end
	local fps = last_fps

	local ping_val = (0)
	if self and self.ping then
		local p = self.ping()
		if type(p) == 'number' then ping_val = p end
	elseif client and client.latency then
		local p = client.latency()
		if type(p) == 'number' then ping_val = p end
	end
	local ping_ms = math.floor((ping_val or (0)) * (500*2) + (0.5))

	local font_style = ''
	local segments = {
		{text = "game", style = font_style, color = base_colors.white},
		{text = "sense", style = font_style, color = base_colors.green},
		{text = " ", style = font_style, color = base_colors.white},
		{text = "[beta]", style = font_style, color = base_colors.white},
		{text = " | ", style = font_style, color = base_colors.white},
		{text = username, style = font_style, color = base_colors.white},
		{text = " | ", style = font_style, color = base_colors.white},
		{text = tostring(ping_ms) .. " ms", style = font_style, color = base_colors.white},
		{text = " | ", style = font_style, color = base_colors.white},
		{text = tostring(fps) .. " fps", style = font_style, color = base_colors.white},
	}

	
	local total_w, max_h = (0), (0)
	for _, seg in ipairs(segments) do
		local w, h = renderer.measure_text and renderer.measure_text(seg.style, seg.text) or 0, 13
		total_w = total_w + w
		if h > max_h then max_h = h end
	end
	local pad_x, pad_y = (4+1), (1+1)
	local box_w = total_w + pad_x * (1+1)
	local box_h = max_h + pad_y * (1+1)
	local x = screen_w - box_w - (8*2) 
	local y = (8*2) 

	
	renderer.rectangle(x - 7, y - 5, box_w + 14, box_h + 10, 0, 0, 0, 200)
	renderer.rectangle(x - 6, y - 4, box_w + 12, box_h + 8, 60, 60, 60, 255)
	renderer.rectangle(x - 5, y - 3, box_w + 10, box_h + 6, 40, 40, 40, 255)
	renderer.rectangle(x - 3, y - 1, box_w + 6, box_h + 2, 60, 60, 60, 255)
	renderer.rectangle(x - 2, y, box_w + 4, box_h, 12, 12, 12, 255)
	renderer.rectangle(x - 2, y, box_w + 4, box_h, 32, 32, 32, 255)

	
	local tex_id = var_0_105()
	if tex_id and renderer.texture then
		renderer.texture(tex_id, x - 2, y, box_w + 4, box_h, 255,255,255,60, 'r')
	end

	
	if renderer.gradient then
		renderer.gradient(x - 2, y, box_w / 2 + 1, 1, 59,175,222,255, 202,70,205,255, true)
		renderer.gradient(x - 2 + box_w / 2, y, box_w / 2 + 4.5, 1, 202,70,205,255, 204,227,53,255, true)
	end

	
	local tx = x + pad_x
	local ty = y + pad_y
	for _, seg in ipairs(segments) do
		local w, h = renderer.measure_text and renderer.measure_text(seg.style, seg.text) or 0, 13
		local r,g,b,a = var_0_131(seg.color)
		renderer.text(tx, ty, r,g,b,a, seg.style, nil, seg.text)
		tx = tx + w
	end
end

client.set_event_callback('paint', var_0_68)
]]
__bundle["require/features/paint/world_hitmarker_plus"] = [[
local var_0_166 = require("require/abc/menu_setup")
local hit = {shots = {}, last = (0)}

local function var_0_146()
	local sel = ui.get(var_0_166.ui.paint_hitmarker)
	if type(sel) == "table" then
		for _, v in ipairs(sel) do
			if v == "world +" then return true end
		end
	end
	return false
end

client.set_event_callback('aim_fire', function(ev)
	if not var_0_146() then hit.shots = {} return end
	if not var_0_146() then return end
	local var_0_173 = globals.realtime()
	
	hit.shots[#hit.shots + (1)] = {impacts = {}, finished = false, t = var_0_173}
	if #hit.shots > (6*2) then table.remove(hit.shots, (1)) end
end)

client.set_event_callback('bullet_impact', function(ev)
	if not var_0_146() then hit = {shots = {}, last = (0)} return end
	local me = entity.get_local_player()
	if not me then return end
	local shooter = client.userid_to_entindex(ev.userid or (0))
	if shooter ~= me then return end
	local var_0_173 = globals.realtime()
	
	local shot
	for i = #hit.shots, (1), (-(1)) do
		if not hit.shots[i].finished and var_0_173 - (hit.shots[i].t or (0)) < (1.2) then
			shot = hit.shots[i]
			break
		end
	end
	if not shot then return end
	
	local ix, iy, iz = ev.x, ev.y, ev.z
	
	local ok_eye, ex, ey, ez = pcall(client.eye_position)
	local dirx, diry, dirz = (0),(0),(0)
	if ok_eye and ex and ey and ez then
		dirx = ix - ex; diry = iy - ey; dirz = iz - ez
		local len = math.sqrt(dirx*dirx + diry*diry + dirz*dirz)
		if len > (0) then dirx, diry, dirz = dirx/len, diry/len, dirz/len end
	end

	
	local hit_entity = false
	local ok_trace, frac, ent = pcall(client.trace_line, me, ix - dirx*(1), iy - diry*(1), iz - dirz*(1), ix + dirx*(1), iy + diry*(1), iz + dirz*(1))
	if ok_trace and ent and ent > (0) and ent ~= me then
		if entity.is_enemy(ent) then hit_entity = true end
	end

	shot.impacts[#shot.impacts + (1)] = {x = ix, y = iy, z = iz, t = var_0_173, r = (0), g = (47*5), b = (47*5), dir = {dirx, diry, dirz}, hit = hit_entity}
	if hit_entity then
		shot.finished = true
	end
end)

client.set_event_callback('paint', function()
	if var_0_146() then
		local var_0_173 = globals.realtime()
		local hold = (5.5) * (2+1) * (0.8)
		local fade = (0.25) * (0.8)
		local total = hold + fade
		
		local i = (1)
		while i <= #hit.shots do
			if var_0_173 - (hit.shots[i].t or (0)) > total then
				table.remove(hit.shots, i)
			else
				i = i + (1)
			end
		end
		
		local all_impacts = {}
		for _, shot in ipairs(hit.shots) do
			for _, it in ipairs(shot.impacts) do
				table.insert(all_impacts, it)
			end
		end
		
		table.sort(all_impacts, function(a, b) return (a.t or (0)) < (b.t or (0)) end)
		
		local start = math.max((1), #all_impacts - (2*2))
		for j = start, #all_impacts do
			local it = all_impacts[j]
			
			local draw_x, draw_y, draw_z = it.x, it.y, it.z
			if not it.hit and it.dir then
				
				local ex = it.x + (it.dir[(1)] or (0)) * (12*2)
				local ey = it.y + (it.dir[(1+1)] or (0)) * (12*2)
				local ez = it.z + (it.dir[(2+1)] or (0)) * (12*2)
				draw_x, draw_y, draw_z = ex, ey, ez
			end
			local sx, sy = renderer.world_to_screen(draw_x, draw_y, draw_z)
			if sx and sy then
				local age = var_0_173 - (it.t or (0))
				local alpha = age <= hold and (85*3) or math.floor(math.max((0), ((1) - math.max((0), age - hold) / fade) * (85*3)))
				if alpha > (0) then
					local len = (2*2)
					local r = it.r or (100*2)
					local g = it.g or (100*2)
					local b = it.b or (100*2)
					renderer.line(sx - len, sy, sx + len, sy, r, g, b, alpha)
					renderer.line(sx, sy - len, sx, sy + len, r, g, b, alpha)
				end
			end
		end
	else
		hit = {shots = {}, last = (0)}
	end
end)
]]
__bundle["require/help/color"] = [[
local function var_0_131(hex)
    hex = hex:gsub("^\\a","")
    if #hex ~= (4*2) then return (85*3),(85*3),(85*3),(85*3) end
    local r = tonumber(hex:sub((1),(1+1)),(8*2))
    local g = tonumber(hex:sub((2+1),(2*2)),(8*2))
    local b = tonumber(hex:sub((4+1),(3*2)),(8*2))
    local a = tonumber(hex:sub((6+1),(4*2)),(8*2))
    return r,g,b,a
end

local function var_0_219(r,g,b,a)
    return string.format("\\a%02x%02x%02x%02x", r,g,b,a or (85*3))
end

local function var_0_35(x) return math.max((0), math.min((85*3), x)) end

local function var_0_154(r,g,b,a,amount)
    amount = amount or (16*2)
    return var_0_35(r+amount), var_0_35(g+amount), var_0_35(b+amount), a
end

local function var_0_47(r,g,b,a,amount)
    amount = amount or (16*2)
    return var_0_35(r-amount), var_0_35(g-amount), var_0_35(b-amount), a
end

local base_colors = {
    green  = "a5ca2aFF",
    red    = "d96464FF",
    yellow = "ccb854FF",
    blue   = "5462ccFF",
    cyan   = "54ccccFF",
    purple = "7054ccFF",
    white  = "ffffffFF",
    grey   = "757575FF",
    black  = "000000FF",
    pink   = "c8a2deFF",
    discord = "7289daFF",
}



local COLORS = {}
for name, hex in pairs(base_colors) do
    local r,g,b,a = var_0_131(hex)
    COLORS[name] = {
        base = hex,
        lighter = var_0_219(var_0_154(r,g,b,a,(16*2))),
        darker  = var_0_219(var_0_47(r,g,b,a,(16*2))),
        light2  = var_0_219(var_0_154(r,g,b,a,(32*2))),
        dark2   = var_0_219(var_0_47(r,g,b,a,(32*2))),
        rgb = {r,g,b,a},
        log = {r,g,b},   
        ui = hex,        
    }
end





function COLORS.get(name, variant)
    variant = variant or "base"
    local entry = COLORS[name]
    if not entry then return nil end
    if variant == "log" and entry.log then
        return unpack(entry.log)
    elseif variant == "ui" and entry.ui then
        return "\a"..entry.ui
    elseif entry[variant] then
        return entry[variant]
    end
    return nil
end

function COLORS.blend(c1, c2, t)
    local r1,g1,b1,a1 = unpack(COLORS[c1].rgb)
    local r2,g2,b2,a2 = unpack(COLORS[c2].rgb)
    t = t or (0.5)
    local r = var_0_35(r1 + (r2-r1)*t)
    local g = var_0_35(g1 + (g2-g1)*t)
    local b = var_0_35(b1 + (b2-b1)*t)
    local a = var_0_35(a1 + (a2-a1)*t)
    return var_0_219(r,g,b,a)
end

return COLORS]]
__bundle["require/help/enemies"] = [[
local M = {}

local entity = entity
local client = client
local globals = globals

function M.var_0_155()
    return entity and entity.get_players and entity.get_players(true) or {}
end

function M.is_alive(idx)
    return idx and entity.is_alive and entity.is_alive(idx) or false
end

function M.is_dormant(idx)
    return idx and entity.is_dormant and entity.is_dormant(idx) or false
end

function M.player_name(idx)
    return idx and entity.get_player_name and entity.get_player_name(idx) or nil
end

function M.steam64(idx)
    return idx and entity.get_steam64 and entity.get_steam64(idx) or nil
end

function M.health(idx)
    return idx and entity.get_prop and entity.get_prop(idx, 'm_iHealth') or (0)
end

function M.current_threat()
    return client and client.current_threat and client.current_threat() or nil
end

local afk_tracker = {}

function M.is_afk(idx, threshold, duration)
    
    threshold = threshold or (4+1)
    duration = duration or (10*2)
    local vx, vy, vz = entity.get_prop(idx, 'm_vecVelocity')
    local speed = (0)
    if vx and vy and vz then
        speed = math.sqrt(vx * vx + vy * vy + vz * vz)
    end
    local var_0_173 = globals and globals.realtime and globals.realtime() or os.clock()
    if not afk_tracker[idx] then
        afk_tracker[idx] = { last_active = var_0_173, last_check = var_0_173 }
    end
    if speed >= threshold then
        afk_tracker[idx].last_active = var_0_173
    end
    afk_tracker[idx].last_check = var_0_173
    return (var_0_173 - afk_tracker[idx].last_active) > duration
end

return M
]]
__bundle["require/help/libs"] = [[









local function var_0_223(name)
	local ok, lib = pcall(require, name)
	return ok and lib or nil
end


local lib_defs = {
	antiaim_funcs   = 'gamesense/antiaim_funcs',
	base64          = 'gamesense/base64',
	clipboard       = 'gamesense/clipboard',
	http            = 'gamesense/http',
	csgo_weapons    = 'gamesense/csgo_weapons',
	icons           = 'gamesense/icons',
	entity          = 'gamesense/entity',
	vector          = 'vector',
	bit             = 'bit',
	ffi             = 'ffi',
	pui             = 'gamesense/pui',
	trace           = 'gamesense/trace',
	md5             = 'gamesense/md5',
	websocket       = 'gamesense/websocket',
	surface         = 'gamesense/surface',
	color           = 'gamesense/color',
}


local libs = {}
for k, v in pairs(lib_defs) do
	libs[k] = var_0_223(v)
end


local features = {
	antiaim_funcs = {
		get_tickbase_shifting = "Returns true if tickbase shifting is active.",
		get_fake_lag = "Returns current fake lag value.",
		get_desync = "Returns current desync value.",
		get_manual_direction = "Returns manual anti-aim direction.",
		var_0_92 = "Returns current anti-aim condition.",
		get_body_yaw = "Returns current body yaw value.",
		get_yaw_base = "Returns current yaw base value.",
		get_pitch = "Returns current pitch value.",
		get_yaw_jitter = "Returns current yaw jitter value.",
		get_enabled = "Returns if anti-aim is enabled.",
		get_fakelag_mode = "Returns fakelag mode.",
		get_fakelag_limit = "Returns fakelag limit.",
		get_fakelag_variance = "Returns fakelag variance.",
		get_fakelag_enabled = "Returns if fakelag is enabled.",
		get_double_tap = "Returns true if double tap exploit is active.",
		get_overlap = "Returns overlap value (exploit related).",
	},
	base64 = {
		encode = "Encodes a string to base64.",
		decode = "Decodes a base64 string.",
	},
	clipboard = {
		get = "Gets clipboard contents as string.",
		set = "Sets clipboard contents to string.",
	},
	http = {
		get = "Performs HTTP GET request.",
		post = "Performs HTTP POST request.",
		download = "Downloads a file from URL.",
	},
	csgo_weapons = {
		get_weapon_name = "Returns weapon name by id.",
		get_weapon_id = "Returns weapon id by name.",
		get_weapon_type = "Returns weapon type by id.",
		get_weapon_group = "Returns weapon group by id.",
		get_weapon_slot = "Returns weapon slot by id.",
		get_weapon_price = "Returns weapon price by id.",
	},
	icons = {
		hero = "Table of hero icons.",
		get_texture = "Returns texture id for icon name.",
		get_icon = "Returns icon object by name.",
		get_all_icons = "Returns all available icons.",
	},
	entity = {
		get_local_player = "Returns entindex of local player.",
		get_all = "Returns array of entindices for all entities.",
		get_players = "Returns array of player entindices.",
		get_game_rules = "Returns entindex of game rules proxy.",
		get_player_resource = "Returns entindex of player resource.",
		get_classname = "Returns classname of entity.",
		set_prop = "Sets netvar property.",
		get_prop = "Gets netvar property.",
		is_enemy = "Returns true if entity is enemy.",
		is_alive = "Returns true if entity is alive.",
		is_dormant = "Returns true if entity is dormant.",
		get_player_name = "Returns player name.",
		get_player_weapon = "Returns active weapon entindex.",
		hitbox_position = "Returns world position of hitbox.",
		get_steam64 = "Returns SteamID3.",
		get_bounding_box = "Returns bounding box coordinates.",
		get_origin = "Returns world origin of entity.",
		get_esp_data = "Returns ESP data for player.",
	},
	vector = {
		new = "Creates a new vector object.",
		var_0_63 = "Returns dot product of two vectors.",
		cross = "Returns cross product of two vectors.",
		var_0_150 = "Returns length of vector.",
		normalize = "Normalizes vector.",
		add = "Adds two vectors.",
		sub = "Subtracts two vectors.",
		mul = "Multiplies vector by scalar.",
		div = "Divides vector by scalar.",
		dist = "Returns distance between two vectors.",
	},
	bit = {
		arshift = "Arithmetic right shift.",
		band = "Bitwise AND.",
		bnot = "Bitwise NOT.",
		bor = "Bitwise OR.",
		bswap = "Byte swap (endian conversion).",
		bxor = "Bitwise XOR.",
		lshift = "Logical left shift.",
		rol = "Bitwise left rotation.",
		ror = "Bitwise right rotation.",
		rshift = "Logical right shift.",
		tobit = "Normalize to 32-bit signed.",
		tohex = "Convert to hexadecimal string.",
	},
	ffi = {
		cdef = "Define C types/functions.",
		cast = "Cast value to C type.",
		new = "Allocate new C object.",
		typeof = "Get C type object.",
		string = "Convert C data to Lua string.",
	},
	pui = {
		create_panel = "Creates a custom UI panel.",
		add_icon = "Adds an icon to a panel.",
		set_icon = "Sets the icon for a panel.",
		set_panel_visible = "Shows/hides a panel.",
		set_panel_position = "Sets panel position.",
		set_panel_size = "Sets panel size.",
	},
	trace = {
		trace_line = "Performs a line trace.",
		trace_bullet = "Performs a bullet trace.",
		trace_hull = "Performs a hull trace.",
	},
	md5 = {
		sumhexa = "Returns MD5 hash as hex string.",
		sum = "Returns MD5 hash as raw bytes.",
	},
	websocket = {
		connect = "Connects to a WebSocket server.",
		send = "Sends data over WebSocket.",
		close = "Closes the WebSocket connection.",
		on_message = "Callback for incoming messages.",
	},
	surface = {
		text = "Draws text on screen.",
		rectangle = "Draws a rectangle.",
		line = "Draws a line.",
		circle = "Draws a circle.",
		gradient = "Draws a gradient rectangle.",
		load_texture = "Loads a texture from file.",
	},
	color = {
		blend = "Blends two colors.",
		var_0_154 = "Lightens a color.",
		var_0_47 = "Darkens a color.",
		var_0_131 = "Converts hex to RGBA.",
		var_0_219 = "Converts RGBA to hex.",
	},
}




local function get(name)
	return libs[name]
end


function var_0_155()
	local out = {}
	for k, v in pairs(_G) do
		if type(v) == "table" or type(v) == "userdata" then
			out[#out+(1)] = k
		end
	end
	return out
end


function var_0_157(libname)
	local feats = features[libname]
	if not feats then return {} end
	local out = {}
	for k, v in pairs(feats) do
		out[#out+(1)] = k .. " - " .. v
	end
	return out
end





return {
	get = get,
	var_0_155 = var_0_155,
	var_0_157 = var_0_157,
	features = features,
	libs = libs,
	lib_defs = lib_defs
}
]]
__bundle["require/help/math"] = [[
local M = {}


function M.var_0_35(val, min, max)
    return math.max(min, math.min(max, val))
end

function M.var_0_221(val, decimals)
    decimals = decimals or (0)
    local mult = (5*2) ^ decimals
    return math.floor(val * mult + (0.5)) / mult
end

function M.var_0_152(a, b, t)
    return a + (b - a) * t
end

function M.distance2d(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^(1+1) + (y2 - y1)^(1+1))
end

function M.distance3d(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^(1+1) + (y2 - y1)^(1+1) + (z2 - z1)^(1+1))
end

function M.angle_diff(a, b)
    local diff = (a - b) % (180*2)
    if diff > (90*2) then diff = diff - (180*2) end
    return diff
end

function M.var_0_172(angle)
    angle = angle % (180*2)
    if angle > (90*2) then angle = angle - (180*2) end
    return angle
end

function M.map(val, in_min, in_max, out_min, out_max)
    return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end


function M.sign(val)
    return (val > (0) and (1)) or (val < (0) and (-(1))) or (0)
end

function M.frac(val)
    return val - math.floor(val)
end

function M.smoothstep(edge0, edge1, x)
    local t = M.var_0_35((x - edge0) / (edge1 - edge0), (0), (1))
    return t * t * ((2+1) - (1+1) * t)
end

function M.random_float(min, max)
    return min + math.random() * (max - min)
end

function M.random_int(min, max)
    return math.random(min, max)
end


function M.is_even(val)
    return val % (1+1) == (0)
end

function M.is_odd(val)
    return val % (1+1) ~= (0)
end

function M.approximately(a, b, epsilon)
    epsilon = epsilon or 1e-(3*2)
    return math.abs(a - b) < epsilon
end

function M.sqr(val)
    return val * val
end

function M.cube(val)
    return val * val * val
end

function M.rad_to_deg(rad)
    return rad * ((90*2) / math.pi)
end

function M.deg_to_rad(deg)
    return deg * (math.pi / (90*2))
end

function M.angle_lerp(a, b, t)
    local diff = ((b - a + (90*2)) % (180*2)) - (90*2)
    return (a + diff * t) % (180*2)
end

function M.mean(tbl)
    if not tbl or #tbl == (0) then return (0) end
    local sum = (0)
    for i = (1), #tbl do sum = sum + tbl[i] end
    return sum / #tbl
end

function M.swap(a, b)
    return b, a
end

return M]]
__bundle["require/help/misc"] = [[
local bit = bit or require('bit')
local M = {}


function M.is_bit_set(value, bit_index)
	return bit.band(value, bit.lshift((1), bit_index)) ~= (0)
end


function M.set_bit(value, bit_index)
	return bit.bor(value, bit.lshift((1), bit_index))
end


function M.clear_bit(value, bit_index)
	return bit.band(value, bit.bnot(bit.lshift((1), bit_index)))
end


function M.toggle_bit(value, bit_index)
	return bit.bxor(value, bit.lshift((1), bit_index))
end


function M.count_bits(value)
	local count = (0)
	while value ~= (0) do
		count = count + bit.band(value, (1))
		value = bit.rshift(value, (1))
	end
	return count
end


function M.lowest_bit(value)
	for i = (0), (30+1) do
		if bit.band(value, bit.lshift((1), i)) ~= (0) then return i end
	end
	return nil
end


function M.highest_bit(value)
	for i = (30+1), (0), (-(1)) do
		if bit.band(value, bit.lshift((1), i)) ~= (0) then return i end
	end
	return nil
end

return M
]]
__bundle["require/help/references"] = [[

local M = {}

local function var_0_281(refs)
    
    if type(refs) ~= 'table' then
        local handle = refs
        return {
            raw = handle,
            get = function()
                local ok, v = pcall(ui.get, handle)
                if ok then return v end
                return nil
            end
        }
    end

    
    
    
    local handles = refs
    return {
        raw = handles,
        get = function()
            if handles[(1+1)] ~= nil then
                local ok, v = pcall(ui.get, handles[(1+1)])
                if ok then return v end
            end
            if handles[(1)] ~= nil then
                local ok, v = pcall(ui.get, handles[(1)])
                if ok then return v end
            end
            return nil
        end
    }
end


M.minimum_damage = var_0_281(ui.reference("RAGE", "Aimbot", "Minimum damage"))
M.minimum_damage_override = var_0_281({ ui.reference("RAGE", "Aimbot", "Minimum damage override") })
M.doubletap = var_0_281({ ui.reference("RAGE", "Aimbot", "Double tap") })
M.force_body_aim = var_0_281({ ui.reference("RAGE", "Aimbot", "Force body aim") })
M.force_safe_point = var_0_281({ ui.reference("RAGE", "Aimbot", "Force safe point") })
M.duck_peek_assist = var_0_281({ ui.reference("RAGE", "Other", "Duck peek assist") })
M.quick_peek_assist = var_0_281({ ui.reference("RAGE", "Aimbot", "Quick peek assist") })


M.pitch = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Pitch"))
M.yaw_base = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Yaw base"))
M.yaw = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Yaw"))
M.yaw_jitter = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Yaw jitter"))
M.body_yaw = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Body yaw"))
M.roll = var_0_281(ui.reference("AA", "Anti-aimbot angles", "Roll"))

return M]]
__bundle["require/help/safe"] = [[

local M = {}


function M.safe_call(func, ...)
	local ok, result = pcall(func, ...)
	return ok and result or nil
end


function M.var_0_225(item, value)
	local ok = pcall(function() ui.set(item, value) end)
	return ok
end


function M.var_0_222(item)
	local ok, result = pcall(function() return ui.get(item) end)
	return ok and result or nil
end

return M
]]
__bundle["require/help/self"] = [[
local M = {}

local entity = entity
local globals = globals
local client = client

function M.index()
	return entity and entity.get_local_player and entity.get_local_player() or nil
end

function M.exists()
	return M.index() ~= nil
end

function M.is_alive()
	local idx = M.index()
	return idx and entity.is_alive and entity.is_alive(idx) or false
end

function M.health()
	local idx = M.index()
	return idx and entity.get_prop and entity.get_prop(idx, 'm_iHealth') or (0)
end

function M.ping()
	return client and client.latency and client.latency() or (0)
end

function M.velocity()
	local idx = M.index()
	if not idx or not entity.get_prop then return (0) end
	local vx, vy, vz = entity.get_prop(idx, 'm_vecVelocity')
	if vx and vy and vz then
		return math.sqrt(vx * vx + vy * vy + vz * vz)
	end
	return (0)
end

function M.velocity2d()
	local idx = M.index()
	if not idx or not entity.get_prop then return (0) end
	local vx, vy = entity.get_prop(idx, 'm_vecVelocity')
	if vx and vy then
		return math.sqrt(vx * vx + vy * vy)
	end
	return (0)
end

function M.weapon()
	local idx = M.index()
	return idx and entity.get_player_weapon and entity.get_player_weapon(idx) or nil
end

function M.tickbase_shifted()
	
	return false
end

function M.simtime()
	local idx = M.index()
	return idx and entity.get_prop and entity.get_prop(idx, 'm_flSimulationTime') or (0)
end

function M.eye_angles()
	return client and client.camera_angles and client.camera_angles() or nil
end

function M.fps()
	local frametime = globals and globals.absoluteframetime and globals.absoluteframetime() or globals.frametime and globals.frametime() or (0.01)
	if frametime > (0) then
		return math.floor((1) / frametime + (0.5))
	end
	return (0)
end

function M.map()
	return globals and globals.mapname and globals.mapname() or nil
end


function M.is_dormant()
	local idx = M.index()
	return idx and entity.is_dormant and entity.is_dormant(idx) or false
end

function M.team_number()
	local idx = M.index()
	return idx and entity.get_prop and entity.get_prop(idx, 'm_iTeamNum') or (0)
end

function M.player_name()
	local idx = M.index()
	return idx and entity.get_player_name and entity.get_player_name(idx) or nil
end

function M.steam64()
	local idx = M.index()
	return idx and entity.get_steam64 and entity.get_steam64(idx) or nil
end

function M.ammo_count()
	local weapon = M.weapon()
	return weapon and entity.get_prop and entity.get_prop(weapon, 'm_iClip1') or (0)
end

function M.has_armor()
	local idx = M.index()
	return idx and entity.get_prop and entity.get_prop(idx, 'm_ArmorValue') > (0) or false
end

function M.has_helmet()
	local idx = M.index()
	return idx and entity.get_prop and entity.get_prop(idx, 'm_bHasHelmet') == (1) or false
end

function M.current_tick()
	return globals and globals.tickcount and globals.tickcount() or (0)
end

function M.tick_interval()
	return globals and globals.tickinterval and globals.tickinterval() or (0)
end

function M.current_frame()
	return globals and globals.framecount and globals.framecount() or (0)
end

function M.current_time()
	return globals and globals.curtime and globals.curtime() or (0)
end

function M.real_latency()
	return client and client.real_latency and client.real_latency() or (0)
end

function M.system_time()
	return client and client.system_time and client.system_time() or {(0),(0),(0),(0)}
end

function M.unix_time()
	return client and client.unix_time and client.unix_time() or (0)
end

function M.kills()
	local idx = M.index()
	if not idx or not entity.get_prop then return (0) end
	local player_resource = entity.get_player_resource and entity.get_player_resource()
	if player_resource then
		return entity.get_prop(player_resource, 'm_iKills', idx) or (0)
	end
	return (0)
end

function M.deaths()
	local idx = M.index()
	if not idx or not entity.get_prop then return (0) end
	local player_resource = entity.get_player_resource and entity.get_player_resource()
	if player_resource then
		return entity.get_prop(player_resource, 'm_iDeaths', idx) or (0)
	end
	return (0)
end

function M.assists()
	local idx = M.index()
	if not idx or not entity.get_prop then return (0) end
	local player_resource = entity.get_player_resource and entity.get_player_resource()
	if player_resource then
		return entity.get_prop(player_resource, 'm_iAssists', idx) or (0)
	end
	return (0)
end

return M
]]
__bundle["require/help/string"] = [[
local S = {}


function S.lower(str)
	return string.lower(str)
end


function S.upper(str)
	return string.upper(str)
end


function S.capitalize(str)
	return (str:gsub("^%l", string.upper):gsub("^(%u)(.*)", function(f, r) return f .. string.lower(r) end))
end


function S.title(str)
	return (str:gsub("%S+", function(word)
		return word:sub((1),(1)):upper() .. word:sub((1+1)):lower()
	end))
end


function S.random_case(str)
	local out = {}
	for i = (1), #str do
		local c = str:sub(i,i)
		if math.random() < (0.5) then
			out[i] = string.lower(c)
		else
			out[i] = string.upper(c)
		end
	end
	return table.concat(out)
end


function S.startswith(str, prefix)
	return str:sub((1), #prefix) == prefix
end


function S.endswith(str, suffix)
	return suffix == '' or str:sub(-#suffix) == suffix
end


function S.split(str, sep)
	local result = {}
	if sep == '' then
		for i = (1), #str do result[i] = str:sub(i,i) end
		return result
	end
	local pattern = string.format("([^%s]+)", sep)
	for part in str:gmatch(pattern) do
		result[#result+(1)] = part
	end
	return result
end


function S.join(tbl, sep)
	return table.concat(tbl, sep)
end


function S.replace(str, pattern, repl)
	return str:gsub(pattern, repl)
end


function S.reverse(str)
	return string.reverse(str)
end


function S.repeat_str(str, n)
	return string.rep(str, n)
end


function S.var_0_43(str, substr)
	return str:find(substr, (1), true) ~= nil
end


function S.count(str, substr)
	if substr == '' then return (0) end
	local count = (0)
	local pos = (1)
	while true do
		local start = str:find(substr, pos, true)
		if not start then break end
		count = count + (1)
		pos = start + #substr
	end
	return count
end


function S.is_empty(str)
	return str == nil or str == ''
end


function S.is_digit(str)
	return str:match("^%d+$") ~= nil
end


function S.is_alpha(str)
	return str:match("^%a+$") ~= nil
end


function S.random_string(len)
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local out = {}
	for i = (1), len do
		local idx = math.random((1), #charset)
		out[i] = charset:sub(idx, idx)
	end
	return table.concat(out)
end

return S
]]
__bundle["require/help/time"] = [[
local T = {}


local function var_0_173()
	if globals and globals.realtime then return globals.realtime() end
	return os.clock()
end



function T.simtime()
	if globals and globals.curtime then return globals.curtime() end
	return nil
end


function T.realtime()
	if globals and globals.realtime then return globals.realtime() end
	return nil
end


function T.tickcount()
	if globals and globals.tickcount then return globals.tickcount() end
	return nil
end


function T.tickinterval()
	if globals and globals.tickinterval then return globals.tickinterval() end
	return nil
end


function T.var_0_234(seconds)
	local interval = T.tickinterval()
	if interval then return math.floor(seconds / interval + (0.5)) end
	return nil
end


function T.ticks_to_seconds(ticks)
	local interval = T.tickinterval()
	if interval then return ticks * interval end
	return nil
end


function T.frametime()
	if globals and globals.frametime then return globals.frametime() end
	return nil
end


function T.absoluteframetime()
	if globals and globals.absoluteframetime then return globals.absoluteframetime() end
	return nil
end


function T.framecount()
	if globals and globals.framecount then return globals.framecount() end
	return nil
end


function T.framecount_to_seconds(framecount)
	local ft = T.frametime()
	if ft then return framecount * ft end
	return nil
end


function T.seconds_to_framecount(seconds)
	local ft = T.frametime()
	if ft then return math.floor(seconds / ft + (0.5)) end
	return nil
end


function T.new(duration)
	return { start = var_0_173(), duration = duration or (0) }
end

function T.expired(timer)
	return var_0_173() - timer.start >= timer.duration
end

function T.var_0_208(timer, duration)
	timer.start = var_0_173()
	if duration then timer.duration = duration end
end

function T.elapsed(timer)
	return var_0_173() - timer.start
end


function T.interval(interval, callback)
	local last = var_0_173()
	return function(...)
		if var_0_173() - last >= interval then
			last = var_0_173()
			callback(...)
		end
	end
end


function T.timeout(delay, callback)
	local triggered = false
	local start = var_0_173()
	return function(...)
		if not triggered and var_0_173() - start >= delay then
			triggered = true
			callback(...)
		end
	end
end


function T.debounce(interval, callback)
	local last = (0)
	return function(...)
		local t = var_0_173()
		if t - last >= interval then
			last = t
			callback(...)
		end
	end
end


function T.throttle(interval, callback)
	local last = (0)
	return function(...)
		local t = var_0_173()
		if t - last >= interval then
			last = t
			callback(...)
		end
	end
end


function T.wait(delay)
	local start = var_0_173()
	return function()
		return var_0_173() - start >= delay
	end
end


function T.stopwatch()
	local sw = { running = false, start = (0), elapsed = (0) }
	function sw:start()
		if not self.running then
			self.running = true
			self.start = var_0_173()
		end
	end
	function sw:stop()
		if self.running then
			self.running = false
			self.elapsed = self.elapsed + (var_0_173() - self.start)
		end
	end
	function sw:var_0_208()
		self.running = false
		self.start = (0)
		self.elapsed = (0)
	end
	function sw:get()
		if self.running then
			return self.elapsed + (var_0_173() - self.start)
		else
			return self.elapsed
		end
	end
	return sw
end


T.Scheduler = {}
T.Scheduler.__index = T.Scheduler

function T.Scheduler.new()
    return setmetatable({ tasks = {} }, T.Scheduler)
end

function T.Scheduler:add(interval, callback)
    self.tasks[#self.tasks+(1)] = { interval = interval, callback = callback, last = var_0_173() }
end

function T.Scheduler:remove(callback)
    for i = #self.tasks, (1), (-(1)) do
        if self.tasks[i].callback == callback then
            table.remove(self.tasks, i)
        end
    end
end

function T.Scheduler:run(...)
    local t = var_0_173()
    for _, task in ipairs(self.tasks) do
        if t - task.last >= task.interval then
            task.last = t
            task.callback(...)
        end
    end
end


function T.safe_timeout(delay, callback)
    local start = var_0_173()
    local triggered = false
    return function(...)
        if not triggered and var_0_173() - start >= delay then
            triggered = true
            callback(...)
        end
    end
end

return T
]]
__bundle["require/help/vector"] = [[local vector
do
    local function var_0_162(a,b,c)
        local v = { x = (0), y = (0), z = (0) }
        if type(a) == "table" then
            v.x = a.x or a[(1)] or (0)
            v.y = a.y or a[(1+1)] or (0)
            v.z = a.z or a[(2+1)] or (0)
        elseif type(a) == "number" then
            v.x = a
            v.y = b or (0)
            v.z = c or (0)
        elseif a ~= nil then
            v.x = (a.x or a[(1)]) or (0)
            v.y = (a.y or a[(1+1)]) or (0)
            v.z = (a.z or a[(2+1)]) or (0)
        end
        return setmetatable(v, vector_mt)
    end

    vector_mt = {
        __index = function(t,k)
            if k == (1) then return rawget(t,"x") end
            if k == (1+1) then return rawget(t,"y") end
            if k == (2+1) then return rawget(t,"z") end
            return rawget(t,k)
        end,
        __sub = function(a,b)
            return var_0_162((a.x or (0)) - (b.x or (0)), (a.y or (0)) - (b.y or (0)), (a.z or (0)) - (b.z or (0)))
        end,
        __add = function(a,b)
            return var_0_162((a.x or (0)) + (b.x or (0)), (a.y or (0)) + (b.y or (0)), (a.z or (0)) + (b.z or (0)))
        end,
        __tostring = function(a) return string.format("vec(%.3f, %.3f, %.3f)", a.x or (0), a.y or (0), a.z or (0)) end
    }

    vector_mt.var_0_150 = function(self) return math.sqrt((self.x or (0))^(1+1) + (self.y or (0))^(1+1) + (self.z or (0))^(1+1)) end
    vector_mt.var_0_63 = function(a,b) return (a.x or (0))*(b.x or (0)) + (a.y or (0))*(b.y or (0)) + (a.z or (0))*(b.z or (0)) end

    vector = setmetatable({}, {
        __call = function(_, a, b, c)
            return var_0_162(a, b, c)
        end
    })
end
return vector]]
__bundle["require/help/windows_info"] = [[local ffi = require("ffi")
local chuj = {


}


chuj.GetModuleHandlePtr = 
    ffi.cast(
        "void***", 
        ffi.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B")) + (1+1)
    )[(0)][(0)]

chuj.GetProcAddressPtr = 
    ffi.cast(
        "void***", 
        ffi.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05")) + (1+1)
    )[(0)][(0)]


chuj.var_0_202 = function(addr, typestring) 
    return function(...) 
        return ffi.cast(typestring, client.find_signature("engine.dll", "\xFF\xE1"))(addr, ...) 
    end
end


chuj.fnGetModuleHandle = chuj.var_0_202(
    chuj.GetModuleHandlePtr, 
    "void*(__thiscall*)(void*, const char*)"
)

chuj.var_0_0 = function(module)
    return chuj.fnGetModuleHandle(module)
end 


chuj.fnGetProcAddress = chuj.var_0_202(
    chuj.GetProcAddressPtr, 
    "void*(__thiscall*)(void*, void*, const char*)"
)

chuj.var_0_1 = function(module, proc_addr)
    local addr = chuj.fnGetProcAddress(module, proc_addr)
    return addr
end 


chuj.lib = {}
chuj.lib.user32 = chuj.var_0_0("user32.dll")


chuj.export = {}
chuj.export.user32 = {}

chuj.export.user32.MessageBoxPtr = chuj.var_0_1(chuj.lib.user32, "MessageBoxA")
chuj.export.user32.MessageBox = chuj.var_0_202(
    chuj.export.user32.MessageBoxPtr,
    "int(__thiscall*)(void*, void*, const char*, const char*, unsigned int)"
)


local MB_OK = 0x00000000
local MB_OKCANCEL = 0x00000001
local MB_YESNO = 0x00000004
local MB_ICONERROR = 0x00000010
local MB_ICONQUESTION = 0x00000020
local MB_ICONWARNING = 0x00000030
local MB_ICONINFORMATION = 0x00000040


local IDOK = (1)
local IDCANCEL = (1+1)
local IDYES = (3*2)
local IDNO = (6+1)


local function var_0_247(text, title, type)
    title = title or "Gamesense"
    type = type or MB_OK
    
    local result = chuj.export.user32.MessageBox(nil, text, title, type)
    return result
end


local function var_0_246(text, title)
    return var_0_247(text, title, MB_OK + MB_ICONINFORMATION)
end

local function var_0_248(text, title)
    return var_0_247(text, title, MB_OK + MB_ICONWARNING)
end

local function var_0_245(text, title)
    return var_0_247(text, title, MB_OK + MB_ICONERROR)
end

local function var_0_249(text, title)
    local result = var_0_247(text, title, MB_YESNO + MB_ICONQUESTION)
    return result == IDYES
end
var_0_246("123", "abc")]]
__bundle["main"] = [[



local function var_0_223(path)
    local ok, mod = pcall(require, path)
    if ok then
        return mod
    else
        return nil
    end
end




local modules = {
    menu = var_0_223("require/abc/menu_header"),
    login = var_0_223("require/abc/login_system"),
    config = var_0_223("require/abc/config_system"),
    player_condition = var_0_223("require/aa/player_condition"),
    var_0_166 = var_0_223("require/abc/menu_setup"),
    gc = var_0_223("require/abc/garbage_collector"),
    var_0_192 = var_0_223("require/abc/push_logger"),
    self = var_0_223("require/help/self"),
    enemies = var_0_223("require/help/enemies"),
    COLORS = var_0_223("require/help/color"),
    str = var_0_223("require/help/string"),
    safe = var_0_223("require/help/safe"),
    var_0_25 = var_0_223("require/abc/build_menu"),
    menu_visibility = var_0_223("require/abc/menu_visibility"),
    config_system = var_0_223("require/abc/config_system"),
}




var_0_223("require/abc/register")




var_0_223("require/features/aa/antiaim")





var_0_223("require/features/misc/resolver")
var_0_223("require/features/misc/analyze")
var_0_223("require/features/misc/dormant_aimbot")
var_0_223("require/features/misc/buybot")
var_0_223("require/features/misc/fakelag")
var_0_223("require/features/misc/hotkeys")
var_0_223("require/features/misc/freestand_helper")
var_0_223("require/features/misc/enhance_osaa")
var_0_223("require/features/misc/roll")
var_0_223("require/features/misc/exploit_fakelag")
var_0_223("require/features/misc/walkbot")




var_0_223("require/features/paint/world_hitmarker_plus")
var_0_223("require/features/paint/onshot_skeleton")
var_0_223("require/features/paint/damage")
var_0_223("require/features/paint/damage_penetration")
var_0_223("require/features/paint/aimbot_logs")
var_0_223("require/features/paint/aspect_ratio")
var_0_223("require/features/paint/third_person_distance")
var_0_223("require/features/paint/watermark")
var_0_223("require/features/paint/entidx")
var_0_223("require/features/paint/target_info")
var_0_223("require/features/paint/clantag")
var_0_223("require/features/paint/indicators_bold")
var_0_223("require/features/paint/indicators_small")
var_0_223("require/features/paint/hit_miss_indicator")
var_0_223("require/features/paint/bomb_esp")
var_0_223("require/features/paint/presmoke_warning")
var_0_223("require/features/paint/self_skeleton")
var_0_223("require/features/paint/performance_mode")

var_0_223("require/features/paint/minimum_damage")
var_0_223("require/features/paint/filter_console")
var_0_223("require/features/paint/warnings")
var_0_223("require/features/paint/text_watermark")
var_0_223("require/features/paint/bullet_tracer")
var_0_223("require/features/paint/animations")
var_0_223("require/features/paint/lagcomp_box")
var_0_223("require/features/paint/insults")





modules.var_0_192("The lua has initialized", (2*2), (85*3), (85*3), (0), (85*3))




local function var_0_158()
    local creds = database.read('cached_credentials')
    if creds and creds.username and creds.password then
        modules.safe.var_0_225(modules.var_0_166.ui.login_username, creds.username)
        modules.safe.var_0_225(modules.var_0_166.ui.login_password, creds.password)
        modules.safe.var_0_225(modules.var_0_166.ui.cache_credentials, true)
        
        local success = modules.login.login(creds.username, creds.password)
        if success then
            local r,g,b = modules.COLORS.get("green", "log")
            client.color_log(r,g,b, 'Auto-login successful!')
            modules.var_0_192("Auto-login successful!", (2+1), (85*3), (85*3), (0), (85*3))
        else
            local r,g,b = modules.COLORS.get("red", "log")
            client.color_log(r,g,b, 'Auto-login failed!')
            modules.var_0_192("Auto-login failed!", (2+1), (85*3), (85*3), (0), (85*3))
        end
    end
end




modules.var_0_25(modules)
modules.menu_visibility.var_0_241(modules)





local function var_0_166()
    local logged_in = modules.login.logged_in
    if not logged_in then return end
    modules.menu.var_0_67()
    if modules.menu.is_menu_open() then
        local tab_rects = modules.menu.var_0_258()
        local mouse_x, mouse_y = modules.menu.mouse_position()
        local tab_index = modules.menu.var_0_46()
        local tab_name = modules.menu.var_0_45()
        local menu_x, menu_y = modules.menu.menu_position()
        local menu_w, menu_h = modules.menu.menu_size()
    end
end





local function var_0_62(cmd)
    if not modules.menu.is_menu_open() then return end
    if not modules.menu.var_0_141() then
        cmd.in_attack = false
    end
end





local function var_0_88()
    if modules.gc and modules.gc.step then
        modules.gc.step((5*2)) 
    end
end





local function var_0_255()
    var_0_158()
    modules.menu_visibility.update(modules)
    modules.var_0_192("Menu setup complete", (2*2), (85*3), (85*3), (0), (85*3))
end

var_0_255()



client.set_event_callback('setup_command', function(cmd)
    var_0_62(cmd)
end)

client.set_event_callback('paint', function()
    var_0_166()
    var_0_88()
end)

client.set_event_callback('paint_ui', function()

    if not modules.menu.is_menu_open() then return end
    local tab_name = modules.menu.var_0_45()

    modules.var_0_166.toggle_gamesense_menu(false)

    if tab_name ~= last_tab then
        last_tab = tab_name
        modules.menu_visibility.update(modules)
    end

end)




client.set_event_callback('shutdown', function(cmd)
    modules.var_0_166.toggle_gamesense_menu(true)
end)]]

return require("main")
