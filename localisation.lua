local hierarchy = require "prototype-hierarchy"

local dr = data.raw

local function get_item(name)
  for _, proto_type in pairs(hierarchy.subtypes("item")) do
    local proto = dr[proto_type][name]
    if proto then
      return proto
    end
  end
end

-- @return table of RecipeData
local function get_recipe_difficulties(recipe)
  local out = {}
  if recipe.normal then
    out[#out+1] = recipe.normal
  end
  if recipe.expensive then
    out[#out+1] = recipe.expensive
  end
  if not next(out) then
    out[#out+1] = recipe
  end
  return out
end

-- @return Prototype
local function get_product(product_prototype)
  if product_prototype.type == "fluid" then
    return dr.fluid[product_prototype.name]
  end
  return get_item(product_prototype.name)
end

-- @return ProductPrototype
local function get_main_product(recipe)
  for _, difficulty in pairs(get_recipe_difficulties(recipe)) do
    local results = difficulty.results or {
      name  = difficulty.result,
      count = difficulty.result_count or 1,
    }
    if difficulty.main_product then
      for _, result in pairs(results) do
        if result.name == difficulty.main_product then
          return get_product(result)
        end
      end
    else
      return get_product(results[1])
    end
  end
end

-- @param prototype Prototype
local function get_localised_name(prototype)
  if prototype.localised_name then
    return prototype.localised_name
  end

  local proto_type = prototype.type
  if proto_type == "recipe" then
    return get_localised_name(get_main_product(recipe))
  elseif hierarchy.isa(proto_type, "Entity") then
  elseif hierarchy.isa(proto_type, "Item") then
  end
end

local function get_localised_description(prototype)
  if prototype.localised_description then
    return prototype.localised_description
  end
end

return {
  get_localised_name = get_localised_name,
  get_localised_description = get_localised_description,
}
