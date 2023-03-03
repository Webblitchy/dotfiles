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

local function file_exists(name)
    -- function taken from real source code
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- open file under cursor
function startMenuEnterPressed() -- must be global
    local filename = vim.trim(vim.api.nvim_get_current_line())
    filename = string.gsub(filename, "%[%d%] (.+)", "%1")
    filename = vim.fn.fnamemodify(filename, ":p")
    vim.cmd [[:source ~/.config/nvim/init.lua]] -- restore default parameters
    if file_exists(filename) then
        vim.cmd("e " .. filename) -- quit menu and open file
    else
        require("startup").check_line() -- execute_command
    end
    -- require("startup.utils").set_buf_options() -- restore startup parameters (not working here)
end

local settings = {
    -- every line should be same width without escaped \
    header = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 5,
        content = title_sharp,
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    -- name which will be displayed and command
    body = {
        type = "mapping",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,
        content = {
            { " Recent Files", "Telescope oldfiles",              "<leader>of" },
            { " Browser",      "Telescope file_browser",          "<leader>fb" },
            { " Find File",    "Telescope find_files",            "<leader>ff" },
            --{ " Find Word", "Telescope live_grep", "<leader>lg" },
            { " New File",     "lua require'startup'.new_file()", "<leader>nf" },
            { " Quit",         ":q",                              "ZQ" },
        },
        highlight = "String",
        default_color = "",
        oldfiles_amount = 0,
    },
    body_2 = {
        type = "oldfiles",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Oldfiles of Directory",
        margin = 5,
        content = {},
        highlight = "String",
        default_color = "#FFFFFF",
        oldfiles_amount = 5,
    },
    clock = {
        type = "text",
        content = function()
            local clock = " " .. os.date("%H:%M")
            local date = " " .. os.date("%d-%m-%y")
            return { clock, date }
        end,
        oldfiles_directory = false,
        align = "right",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },
    footer = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Footer",
        margin = 5,
        content = { "startup.nvim" },
        highlight = "Number",
        default_color = "",
        oldfiles_amount = 0,
    },
    options = {
        after = function()
            require("startup").create_mappings({ ["<CR>"] = "<cmd>lua startMenuEnterPressed()<CR>" })
        end,
        mapping_keys = false, -- to show the mapping
        cursor_column = 0.5, -- center the cursor
        empty_lines_between_mappings = true,
        disable_statuslines = true,
        paddings = { 1, 3, 3, 0 },
    },
    mappings = {
        -- cannot be execute_command and open_file the same (so I made startMenuEnterPressed)
        execute_command = "e", -- UNUSED
        open_file = "o", -- UNUSED
        open_file_split = "<c-o>",
        open_section = "<TAB>",
        open_help = "?",
    },
    colors = {
        background = "#1f2227",
        folded_section = "#56b6c2",
    },
    -- Apparently cannot have more than 4 parts
    parts = {
        "header",
        "body",
        "body_2",
        "clock",
        -- "footer"
    },
}
return settings
