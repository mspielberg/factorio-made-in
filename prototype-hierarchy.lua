if not serpent then
  serpent = require "serpent"
end

local hierarchy = {
  ["achievement"] = {
    ["build-entity-achievement"] = {},
    ["combat-robot-count"] = {},
    ["construct-with-robots-achievement"] = {},
    ["deconstruct-with-robots-achievement"] = {},
    ["deliver-by-robots-achievement"] = {},
    ["dont-build-entity-achievement"] = {},
    ["dont-craft-manually-achievement"] = {},
    ["dont-use-entity-in-energy-production-achievement"] = {},
    ["finish-the-game-achievement"] = {},
    ["group-attack-achievement"] = {},
    ["kill-achievement"] = {},
    ["player-damaged-achievement"] = {},
    ["produce-achievement"] = {},
    ["produce-per-hour-achievement"] = {},
    ["research-achievement"] = {},
    ["train-path-achievement"] = {},
  },
  ["ammo-category"] = {},
  ["autoplace-control"] = {},
  ["custom-input"] = {},
  ["damage-type"] = {},
  ["Entity"] = {
    ["arrow"] = {},
    ["artillery-projectile"] = {},
    ["beam"] = {},
    ["character-corpse"] = {},
    ["cliff"] = {},
    ["corpse"] = {
      ["rail-remnants"] = {},
    },
    ["deconstructible-tile-proxy"] = {},
    ["entity-ghost"] = {},
    ["EntityWithHealth"] = {
      ["accumulator"] = {},
      ["artillery-turret"] = {},
      ["beacon"] = {},
      ["boiler"] = {},
      ["character"] = {},
      ["Combinator"] = {
        ["arithmetic-combinator"] = {},
        ["decider-combinator"] = {},
      },
      ["constant-combinator"] = {},
      ["container"] = {
        ["logistic-container"] = {
          ["infinity-container"] = {},
        },
      },
      ["CraftingMachine"] = {
        ["assembling-machine"] = {
          ["rocket-silo"] = {},
        },
        ["furnace"] = {},
      },
      ["electric-energy-interface"] = {},
      ["electric-pole"] = {},
      ["unit-spawner"] = {},
      ["fish"] = {},
      ["FlyingRobot"] = {
        ["combat-robot"] = {},
        ["RobotWithLogisticInterface"] = {
          ["construction-robot"] = {},
          ["logistic-robot"] = {},
        },
      },
      ["gate"] = {},
      ["generator"] = {},
      ["heat-interface"] = {},
      ["heat-pipe"] = {},
      ["inserter"] = {},
      ["lab"] = {},
      ["lamp"] = {},
      ["land-mine"] = {},
      ["market"] = {},
      ["mining-drill"] = {},
      ["offshore-pump"] = {},
      ["pipe"] = {
        ["infinity-pipe"] = {},
      },
      ["pipe-to-ground"] = {},
      ["player-port"] = {},
      ["power-switch"] = {},
      ["programmable-speaker"] = {},
      ["pump"] = {},
      ["radar"] = {},
      ["Rail"] = {
        ["curved-rail"] = {},
        ["straight-rail"] = {},
      },
      ["RailSignalBase"] = {
        ["rail-chain-signal"] = {},
        ["rail-signal"] = {},
      },
      ["reactor"] = {},
      ["roboport"] = {},
      ["simple-entity"] = {},
      ["simple-entity-with-owner"] = {},
      ["simple-entity-with-force"] = {},
      ["solar-panel"] = {},
      ["storage-tank"] = {},
      ["train-stop"] = {},
      ["TransportBeltConnectable"] = {
        ["loader"] = {},
        ["splitter"] = {},
        ["transport-belt"] = {},
        ["underground-belt"] = {},
      },
      ["tree"] = {},
      ["turret"] = {
        ["ammo-turret"] = {},
        ["electric-turret"] = {},
        ["fluid-turret"] = {},
      },
      ["unit"] = {},
      ["Vehicle"] = {
        ["car"] = {},
        ["RollingStock"] = {
          ["artillery-wagon"] = {},
          ["cargo-wagon"] = {},
          ["fluid-wagon"] = {},
          ["locomotive"] = {},
        },
      },
      ["wall"] = {},
    },
    ["explosion"] = {
      ["flame-thrower-explosion"] = {},
    },
    ["fire"] = {},
    ["stream"] = {},
    ["flying-text"] = {},
    ["highlight-box"] = {},
    ["item-entity"] = {},
    ["item-request-proxy"] = {},
    ["particle"] = {
      ["artillery-flare"] = {},
      ["leaf-particle"] = {},
    },
    ["particle-source"] = {},
    ["projectile"] = {},
    ["resource"] = {},
    ["rocket-silo-rocket"] = {},
    ["rocket-silo-rocket-shadow"] = {},
    ["Smoke"] = {
      ["smoke-with-trigger"] = {},
    },
    ["speech-bubble"] = {},
    ["sticker"] = {},
    ["tile-ghost"] = {},
  },
  ["Equipment"] = {
    ["active-defense-equipment"] = {},
    ["battery-equipment"] = {},
    ["belt-immunity-equipment"] = {},
    ["energy-shield-equipment"] = {},
    ["generator-equipment"] = {},
    ["movement-bonus-equipment"] = {},
    ["night-vision-equipment"] = {},
    ["roboport-equipment"] = {},
    ["solar-panel-equipment"] = {},
  },
  ["equipment-category"] = {},
  ["equipment-grid"] = {},
  ["fluid"] = {},
  ["fuel-category"] = {},
  ["gui-style"] = {},
  ["item"] = {
    ["ammo"] = {},
    ["capsule"] = {},
    ["gun"] = {},
    ["item-with-entity-data"] = {},
    ["item-with-label"] = {
      ["item-with-inventory"] = {
        ["blueprint-book"] = {},
      },
      ["item-with-tags"] = {},
      ["selection-tool"] = {
        ["blueprint"] = {},
        ["copy-paste-tool"] = {},
        ["deconstruction-item"] = {},
        ["upgrade-item"] = {},
      },
    },
    ["module"] = {},
    ["rail-planner"] = {},
    ["tool"] = {
      ["armor"] = {},
      ["repair-tool"] = {},
    },
  },
  ["item-group"] = {},
  ["item-subgroup"] = {},
  ["module-category"] = {},
  ["noise-expression"] = {},
  ["noise-layer"] = {},
  ["optimized-decorative"] = {},
  ["recipe"] = {},
  ["recipe-category"] = {},
  ["resource-category"] = {},
  ["shortcut"] = {},
  ["technology"] = {},
  ["tile"] = {},
  ["trivial-smoke"] = {},
  ["tutorial"] = {},
  ["utility-sprites"] = {},
  ["virtual-signal"] = {},
}

local function to_set(list)
  local out = {}
  for k,v in pairs(list) do
    out[v] = true
  end
  return out
end

local direct = {}
local function populate_direct(t)
  for k,v in pairs(t) do
    direct[k] = v
    populate_direct(v)
  end
end
populate_direct(hierarchy)

local isa_cache = {}
local function populate_isa_cache(parents, t)
  for k,v in pairs(t) do
    if k:find("^[a-z]") then
      -- concrete
      isa_cache[k] = to_set(parents)
      -- isa is a reflexive operation
      isa_cache[k][k] = true
    end
    parents[#parents+1] = k
    populate_isa_cache(parents, v)
    parents[#parents] = nil
  end
end 
populate_isa_cache({}, hierarchy)

local function isa(x, supertype)
  if type(x) == "table" then
    x = x.type
  end
  return (isa_cache[x] and isa_cache[x][supertype]) or false
end

local function generate_subtypes_recur(t, out)
  for k,v in pairs(t) do
    if k:find("^[a-z]") then
      out[#out+1] = k
    end
    generate_subtypes_recur(v, out)
  end
end

local function generate_subtypes(supertype)
  local out = {}
  local root = direct[supertype]
  if not root then return out end
  generate_subtypes_recur(root, out)
  return out
end

local subtypes_cache = {}
for supertype, direct_subtypes in pairs(direct) do
  if next(direct_subtypes) then
    local subtypes = generate_subtypes(supertype)
    table.sort(subtypes)
    subtypes_cache[supertype] = subtypes
  end
end

local function subtypes(supertype)
  return subtypes_cache[supertype] or {}
end

return {
  isa = isa,
  subtypes = subtypes,
}
