local title_shadow = {
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

local title_sharp = {
    [[                                                                       ]],
    [[                                                                     ]],
    [[       ████ ██████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      █████████ ███████████████████ ███   ███████████   ]],
    [[     █████████  ███    █████████████ █████ ██████████████   ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    [[                                                                       ]],
}


local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local footer = function()
    local plugins = #vim.tbl_keys(require("lazy").plugins())
    local lsps = #require("mason-registry").get_installed_package_names()
    local v = vim.version()
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    return string.format("󱘖 %d 󱈗 %d  %d.%d.%d  %s", plugins, lsps, v.major, v.minor, v.patch, datetime)
end

local getUpdates = function()
    vim.fn.timer_start(1000, function()
        if require("lazy.status").has_updates() then
            local dashboard = require("alpha.themes.dashboard")
            local oldVal = dashboard.section.buttons.val[5].val
            dashboard.section.buttons.val[5].val = oldVal .. "[" .. require("lazy.status").updates() .. "]"
            require("alpha").redraw()
        end
    end)
end

local tips = function()
    local tip = vim.fn.system("curl -s " .. "https://vtip.43z.one")
    if tip == "" then
        return ""
    end
    return "  " .. tip
end

local dashboard = require("alpha.themes.dashboard")

-- Add padding
table.insert(dashboard.config.layout, 1, {})
dashboard.config.layout[1].type = "padding"
dashboard.config.layout[1].val = 1

dashboard.section.header.val = title_sharp
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert | echo '' <CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("p", "󱘖  Plugins ", "<Cmd>Lazy<CR>"),
    dashboard.button("l", "󱈗  LSPs", "<Cmd>Mason<CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}
for _, v in pairs(dashboard.section.buttons.val) do
    v.opts.cursor = 0
    v.val = "   " .. v.val
end



dashboard.section.footer.val = footer()

-- Add padding
table.insert(dashboard.config.layout, {})
dashboard.config.layout[7].type = "padding"
dashboard.config.layout[7].val = 0

-- Add Tip
table.insert(dashboard.config.layout, {})
dashboard.config.layout[8].type = "text"
dashboard.config.layout[8].val = tips()
dashboard.config.layout[8].opts = {
    position = "center",
    hl = "@parameter" -- orange italic
}


dashboard.section.footer.opts.hl = "Type"      -- yellow
dashboard.section.header.opts.hl = "@function" -- blue
dashboard.section.buttons.opts.hl = "Keyword"  -- white

dashboard.config.opts.noautocmd = true
alpha.setup(dashboard.config)

getUpdates() -- set callback in 2sec to check for updates
