local DEFAULT_OPTS = require'springtime'.DEFAULT_OPTS
local util = require'springtime.util'

local M = {}

local function create_dynamic_section(selected, values)
    local result = {}
    for i, v in pairs(values) do
        table.insert(result, { (selected == i and util.CHECKED_ICON or util.UNCHECKED_ICON) .. v })
    end
    return result
end

function M.space_key_event()
    vim.cmd[[setl ma]]
    local line_nr = vim.fn.line('.')
    if line_nr > 1 and line_nr < 5 then
       local lines = { 2, 3, 4 }
       for _, v in pairs(lines) do
            if v == line_nr then
                local selected = vim.fn.getline('.')
                local final = tostring(selected):gsub(util.UNCHECKED_ICON, util.CHECKED_ICON)
                vim.fn.setline(line_nr, final)
                DEFAULT_OPTS.project.selected = line_nr - 1
            else
                local unselected = vim.fn.getline(v)
                local final = tostring(unselected):gsub(util.CHECKED_ICON, util.UNCHECKED_ICON)
                vim.fn.setline(v, final)
            end
       end
    end
    vim.cmd[[setl noma]]
end

-- TODO devolver content y los index de cada seccion
function M.create_content()
    local content = {
        { "󰏖  Project", "Type" },
        { (DEFAULT_OPTS.project.selected == 1 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Gradle (Groovy)" },
        { (DEFAULT_OPTS.project.selected == 2 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Gradle (Kotlin)" },
        { (DEFAULT_OPTS.project.selected == 3 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Maven" },
        { "" },
        { "  Language", "Type" },
        { (DEFAULT_OPTS.language.selected == 1 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Java" },
        { (DEFAULT_OPTS.language.selected == 2 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Kotlin" },
        { (DEFAULT_OPTS.language.selected == 3 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Groovy" },
        { "" },
        { "  Packaging", "Type" },
        { (DEFAULT_OPTS.packaging.selected == 1 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "Jar" },
        { (DEFAULT_OPTS.packaging.selected == 2 and util.CHECKED_ICON or util.UNCHECKED_ICON) .. "War" },
        { "" },
        { "  Spring Boot", "Type" }
    }

    local spring_boot = create_dynamic_section(DEFAULT_OPTS.spring_boot.selected, DEFAULT_OPTS.spring_boot.values)

    local java_version_label = {
        { "" },
        { " Java Version", "Type" }
    }

    local java_version = create_dynamic_section(DEFAULT_OPTS.java_version.selected, DEFAULT_OPTS.java_version.values)

    local project_metadata = {
        { "" },
        { " Project Metadata", "Type" },
        { "Group        󰁕 " .. DEFAULT_OPTS.project_metadata.group },
        { "Artifact     󰁕 " .. DEFAULT_OPTS.project_metadata.artifact },
        { "Name         󰁕 " .. DEFAULT_OPTS.project_metadata.name },
        { "Package Name 󰁕 " .. DEFAULT_OPTS.project_metadata.package_name },
        { "" },
        { "  Dependencies", "Type" },
        { "" }
    }

    local function add_to_content(values)
        for _, v in pairs(values) do
            table.insert(content, v)
        end
    end

    add_to_content(spring_boot)
    add_to_content(java_version_label)
    add_to_content(java_version)
    add_to_content(project_metadata)

    return content
end

return M