local CRAFTING_MACHINE_TYPES = {
  "assembling-machine",
  "furnace",
  "rocket-silo",
}

local function contains(haystack, needle)
  for _, x in pairs(haystack or {}) do
    if x == needle then return true end
  end
  return false
end

local function format_oneline_icons(entity_names)
  local out = {"", {"made-in.description-header"}}
  for _, name in ipairs(entity_names) do
    table.insert(out, ("[entity=%s] "):format(name))
  end
  return out
end

local function format_oneline_names(entity_names)
  local out = {"", {"made-in.description-header"}}
  for _, name in ipairs(entity_names) do
    table.insert(out, {"entity-name."..name})
    table.insert(out, ", ")
  end
  out[#out] = nil -- remove trailing separator
  return out
end

local function format_icons_and_names(entity_names)
  local out = {"", {"made-in.description-header"}, "\n"}
  for _, name in ipairs(entity_names) do
    table.insert(out, ("[entity=%s] "):format(name))
    table.insert(out, {"entity-name."..name})
    table.insert(out, "\n")
  end
  out[#out] = nil -- remove trailing separator
  return out
end

local FORMATTERS = {
  oneline_icons = format_oneline_icons,
  oneline_names = format_oneline_names,
  icons_and_names = format_icons_and_names,
}

local _machines_for_category_cache = {}
local function machines_for_category(category)
  local machines = _machines_for_category_cache[category]
  if not machines then
    machines = {}
    for _, crafting_machine_type in pairs(CRAFTING_MACHINE_TYPES) do
      for name, proto in pairs(data.raw[crafting_machine_type]) do
        if not contains(proto.flags, "hidden") and contains(proto.crafting_categories, category) then
          machines[#machines+1] = name
        end
      end
    end
    table.sort(machines)
    _machines_for_category_cache[category] = machines
  end
  return machines
end

local function create_description(recipe)
  local formatter = FORMATTERS[settings.startup["made-in-format"].value]
  local machines = machines_for_category(recipe.category or "crafting")
  local machines_section = formatter(machines)

  if recipe.localised_description then
    local new_desc = {""}
    table.insert(new_desc, recipe.localised_description)
    table.insert(new_desc, "\n")
    table.insert(new_desc, machines_section)
  else
    return machines_section
  end
  return new_desc
end


for _, recipe in pairs(data.raw.recipe) do
  if settings.startup["made-in-show-vanilla"].value then
    recipe.always_show_made_in = true
  end
  recipe.localised_description = create_description(recipe)
end
