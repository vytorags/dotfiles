require("full-border"):setup()
require("git"):setup()
require("yatline"):setup({
    show_background = true,

    display_header_line = true,
    display_status_line = true,

    component_positions = { "header", "tab", "status" },
    section_separator = { open = "", close = "" },
    part_separator = { open = "", close = "" },
    inverse_separator = { open = "", close = "" },
    header_line = {
        left = {
            section_a = {
                { type = "line", custom = false, name = "tabs", params = { "left" } },
            },
            section_b = {},
            section_c = {},
        },
        right = {
            section_a = {
                { type = "coloreds", custom = true, name = { { " 󰇥 ", "#3c3836" } } },
            },
            section_b = {},
            section_c = {
                { type = "coloreds", custom = false, name = "count" },
            },
        },
    },

    status_line = {
        left = {
            section_a = {
                { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
                { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_path" },
                { type = "coloreds", custom = false, name = "count" },
            },
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
                { type = "string", custom = false, name = "cursor_percentage" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
                { type = "coloreds", custom = false, name = "permissions" },
            },
        },
    },
})
