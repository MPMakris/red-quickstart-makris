local path_g = '__red-quickstart-makris__/graphics/'
local path_i = path_g .. 'icons/'

local eq_size = (settings.startup['req-quickstart-extra-cheese'].value and 1) or 2
local enabled = settings.startup['req-quickstart-recipes'].value
local e_count = (settings.startup['req-quickstart-cost'].value) or 10

------------------------------------------

local robot = table.deepcopy(data.raw['construction-robot']['construction-robot'])
robot.name = 'rr-construction-robot'
robot.icon = path_i .. 'rr-construction-robot.png'
robot.minable = { mining_time = 0.1, result = 'rr-construction-robot' }
robot.resistances = { { type = 'fire', percent = 100 }, { type = 'acid', percent = 100 } }
robot.max_payload_size = 1 * 10
robot.speed = 0.06 * 10
robot.max_energy = '100MJ'
robot.energy_per_tick = '0kJ' -- "0.05kJ" AA constant drain
robot.speed_multiplier_when_out_of_energy = 0.8
robot.energy_per_move = '0kJ'
robot.idle.filename = path_g .. 'construction-robot/construction-robot.png'
robot.in_motion.filename = path_g .. 'construction-robot/construction-robot.png'
robot.working.filename = path_g .. 'construction-robot/construction-robot-working.png'

local logistic = table.deepcopy(data.raw['logistic-robot']['logistic-robot'])
logistic.name = 'rr-logistic-robot'
logistic.icon = path_i .. 'rr-logistic-robot.png'
logistic.minable = { mining_time = 0.1, result = 'rr-logistic-robot' }
logistic.resistances = { { type = 'fire', percent = 100 }, { type = 'acid', percent = 100 } }
logistic.max_payload_size = 1 * 10
logistic.speed = 0.06 * 10
logistic.max_energy = '100MJ'
logistic.energy_per_tick = '0kJ' -- "0.05kJ" AA constant drain
logistic.speed_multiplier_when_out_of_energy = 0.8
logistic.energy_per_move = '0kJ'
logistic.idle.filename = path_g .. 'logistic-robot/logistic-robot.png'
logistic.idle_with_cargo.filename = path_g .. 'logistic-robot/logistic-robot.png'
logistic.in_motion.filename = path_g .. 'logistic-robot/logistic-robot.png'
logistic.in_motion_with_cargo.filename = path_g .. 'logistic-robot/logistic-robot.png'

------------------------------------------

data:extend({
  -- Battery
  {
    type = 'battery-equipment',
    name = 'rr-battery',
    sprite = { filename = path_g .. 'rr-battery.png', width = 64, height = 128, priority = 'medium', scale = 0.5 },
    shape = { width = 1, height = 2, type = 'full' },
    energy_source = { type = 'electric', buffer_capacity = '1TJ', usage_priority = 'tertiary' },
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-battery',
    localised_description = { 'item-description.rr-battery' },
    icon = path_i .. 'rr-battery.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-battery',
    subgroup = 'equipment',
    order = 'b[battery]-b[battery-equipment-mk3]',
    default_request_amount = 5,
    stack_size = 20,
  },
  -- Energy Shield
  {
    type = 'energy-shield-equipment',
    name = 'rr-energy-shield',
    sprite = { filename = path_g .. 'rr-energy-shield.png', width = 128, height = 128, priority = 'medium', scale = 0.5 },
    shape = { width = eq_size, height = eq_size, type = 'full' },
    max_shield_value = 10000,
    energy_source = {
      type = 'electric',
      buffer_capacity = '1MJ',
      input_flow_limit = '1MW',
      usage_priority = 'primary-input',
    },
    energy_per_shield = '1J',
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-energy-shield',
    localised_description = { 'item-description.rr-energy-shield' },
    icon = path_i .. 'rr-energy-shield.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-energy-shield',
    subgroup = 'military-equipment',
    order = 'a[shield]-b[energy-shield-equipment-mk3]',
    default_request_amount = 5,
    stack_size = 20,
  },
  -- Fusion Reactor
  {
    type = 'generator-equipment',
    name = 'rr-fusion-reactor',
    sprite = { filename = path_g .. 'rr-fusion-reactor.png', width = 256, height = 256, priority = 'medium', scale = 0.5 },
    shape = { width = eq_size * eq_size, height = eq_size * eq_size, type = 'full' },
    energy_source = { type = 'electric', usage_priority = 'primary-output' },
    power = '1TW',
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-fusion-reactor',
    icon = path_i .. 'rr-fusion-reactor.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-fusion-reactor',
    subgroup = 'equipment',
    order = 'a[energy-source]-b[fusion-reactor-mk2]',
    default_request_amount = 1,
    stack_size = 20,
  },
  -- Personal Laser defense
  {
    type = 'active-defense-equipment',
    name = 'rr-personal-laser-defense',
    sprite = {
      filename = path_g .. 'rr-personal-laser-defense.png',
      width = 128,
      height = 128,
      priority = 'medium',
      scale = 0.5,
    },
    shape = { width = eq_size, height = eq_size, type = 'full' },
    energy_source = { type = 'electric', usage_priority = 'secondary-input', buffer_capacity = '1MJ' },

    attack_parameters = {
      type = 'beam',
      cooldown = 40,
      range = 32,
      damage_modifier = 3 * 100,
      ammo_category = 'laser',
      ammo_type = {
        category = 'laser',
        energy_consumption = '0MJ',
        action = {
          type = 'direct',
          action_delivery = {
            type = 'beam',
            beam = 'laser-beam',
            max_length = 32,
            duration = 40,
            source_offset = { 0, -1.31439 },
          },
        },
      },
    },
    automatic = true,
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-personal-laser-defense',
    icon = path_i .. 'rr-personal-laser-defense.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-personal-laser-defense',
    subgroup = 'military-equipment',
    order = 'b[active-defense]-a[personal-laser-defense-equipment]-mk2',
    default_request_amount = 5,
    stack_size = 20,
  },
  -- Exoskeleton
  {
    type = 'movement-bonus-equipment',
    name = 'rr-exoskeleton',
    sprite = { filename = path_g .. 'rr-exoskeleton.png', width = 128, height = 256, priority = 'medium', scale = 0.5 },
    shape = { width = eq_size, height = 2 * eq_size, type = 'full' },
    energy_source = { type = 'electric', usage_priority = 'secondary-input' },
    energy_consumption = '1W',
    movement_bonus = 2,
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-exoskeleton',
    icon = path_i .. 'rr-exoskeleton.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-exoskeleton',
    subgroup = 'utility-equipment',
    order = 'd[exoskeleton]-b[exoskeleton-equipment-mk2]',
    default_request_amount = 5,
    stack_size = 20,
  },
  -- Personal Roboport
  {
    type = 'roboport-equipment',
    name = 'rr-personal-roboport',
    take_result = 'rr-personal-roboport',
    sprite = {
      filename = path_g .. 'rr-personal-roboport.png',
      width = 128,
      height = 128,
      priority = 'medium',
      scale = 0.5,
    },
    shape = { width = eq_size, height = eq_size, type = 'full' },
    energy_source = {
      type = 'electric',
      buffer_capacity = '1TJ',
      input_flow_limit = '1TW',
      usage_priority = 'secondary-input',
    },
    charging_energy = '1TW',

    robot_limit = 500,
    construction_radius = 32,
    spawn_and_station_height = 0.4,
    spawn_and_station_shadow_height_offset = 0.5,
    charge_approach_distance = 2.6,
    robots_shrink_when_entering_and_exiting = true,

    recharging_animation = {
      filename = '__base__/graphics/entity/roboport/roboport-recharging.png',
      draw_as_glow = true,
      priority = 'high',
      width = 37,
      height = 35,
      frame_count = 16,
      scale = 1.5,
      animation_speed = 0.5,
    },
    recharging_light = { intensity = 0.2, size = 3, color = { r = 0.5, g = 0.5, b = 1.0 } },
    stationing_offset = { 0, -0.6 },
    charging_station_shift = { 0, 0.5 },
    charging_station_count = 250,
    charging_distance = 1.6,
    charging_threshold_distance = 5,
    categories = { 'armor' },
  },
  {
    type = 'item',
    name = 'rr-personal-roboport',
    localised_description = { 'item-description.rr-personal-roboport' },
    icon = path_i .. 'rr-personal-roboport.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_as_equipment_result = 'rr-personal-roboport',
    subgroup = 'utility-equipment',
    order = 'e[robotics]-b[personal-roboport-mk3-equipment]',
    default_request_amount = 1,
    stack_size = 20,
  },
  -- Equipment Grid
  {
    type = 'equipment-grid',
    name = 'rr-equipment-grid',
    width = 11,
    height = 12,
    equipment_categories = { 'armor' }
  },
  -- Power Armor
  {
    type = 'armor',
    name = 'rr-power-armor',
    icon = path_i .. 'rr-power-armor.png',
    icon_size = 64,
    icon_mipmaps = 4,
    resistances = {
      { type = 'physical', decrease = 1000, percent = 90 },
      { type = 'acid', decrease = 1000, percent = 90 },
      { type = 'explosion', decrease = 1000, percent = 90 },
      { type = 'fire', decrease = 1000, percent = 90 },
    },
    subgroup = 'armor',
    order = 'e[power-armor-mk3]',
    stack_size = 1,
    infinite = true,
    equipment_grid = 'rr-equipment-grid',
    inventory_size_bonus = 100,
    provides_flight = feature_flags.space_travel,
    open_sound = { filename = '__base__/sound/armor-open.ogg', volume = 1 },
    close_sound = { filename = '__base__/sound/armor-close.ogg', volume = 1 },
  },
  -- Construction Robot
  robot,
  {
    type = 'item',
    name = 'rr-construction-robot',
    icon = path_i .. 'rr-construction-robot.png',
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = 'logistic-network',
    order = 'a[robot]-b[construction-robot-mk2]',
    place_result = 'rr-construction-robot',
    stack_size = 500,
  },
})

local char = data.raw.character and data.raw.character.character
if char then
  local armor_list = char.animations and char.animations[#char.animations]
  if armor_list and armor_list.armors then
    table.insert(armor_list.armors, 'rr-power-armor')
  end
  data.raw['character-corpse']['character-corpse'].armor_picture_mapping['rr-power-armor'] = #char.animations
end

if not enabled then
  return
end

data:extend({
  -- Battery
  {
    type = 'recipe',
    name = 'rr-battery',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = 15 },
      { type = 'item', name = 'low-density-structure', amount = 5 },
      { type = 'item', name = 'battery-mk2-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-battery', amount = 1 }},
  },
  -- Energy Shield
  {
    type = 'recipe',
    name = 'rr-energy-shield',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = 5 },
      { type = 'item', name = 'low-density-structure', amount = 5 },
      { type = 'item', name = 'energy-shield-mk2-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-energy-shield', amount = 1 }},
  },
  -- Fusion Reactor
  {
    type = 'recipe',
    name = 'rr-fusion-reactor',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = 200 },
      { type = 'item', name = 'low-density-structure', amount = 50 },
      { type = 'item', name = 'uranium-fuel-cell', amount = 4 },
      { type = 'item', name = 'fission-reactor-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-fusion-reactor', amount = 1 }},
  },
  -- Personal Laser Defense
  {
    type = 'recipe',
    name = 'rr-personal-laser-defense',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = 20 },
      { type = 'item', name = 'low-density-structure', amount = 5 },
      { type = 'item', name = 'personal-laser-defense-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-personal-laser-defense', amount = 1 }},
  },
  -- Exoskeleton
  {
    type = 'recipe',
    name = 'rr-exoskeleton',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'steel-plate', amount = 20 },
      { type = 'item', name = 'processing-unit', amount = 10 },
      { type = 'item', name = 'exoskeleton-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-exoskeleton', amount = 1 }},
  },
  -- Personal Roboport
  {
    type = 'recipe',
    name = 'rr-personal-roboport',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = 100 },
      { type = 'item', name = 'low-density-structure', amount = 20 },
      { type = 'item', name = 'personal-roboport-mk2-equipment', amount = e_count },
    },
    results = {{ type = 'item', name = 'rr-personal-roboport', amount = 1 }},
  },
  -- Armor
  {
    type = 'recipe',
    name = 'rr-power-armor',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'processing-unit', amount = e_count * 60 },
      { type = 'item', name = 'electric-engine-unit', amount = e_count * 40 },
      { type = 'item', name = 'low-density-structure', amount = e_count * 30 },
      { type = 'item', name = 'speed-module-2', amount = e_count * 25 },
      { type = 'item', name = 'efficiency-module-2', amount = e_count * 25 },
      { type = 'item', name = 'power-armor-mk2', amount = 1 },
    },
    results = {{ type = 'item', name = 'rr-power-armor', amount = 1 }},
  },
  -- Robots
  -- -- construction
  {
    type = 'recipe',
    name = 'rr-construction-robot',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'construction-robot', amount = e_count },
      { type = 'item', name = 'fission-reactor-equipment', amount = 1 },
    },
    results = {{ type = 'item', name = 'rr-construction-robot', amount = 1 }},
  },
  -- -- logistic
  logistic,
  {
    type = 'item',
    name = 'rr-logistic-robot',
    icon = path_i .. 'rr-logistic-robot.png',
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = 'logistic-network',
    order = 'a[robot]-b[logistic-robot-mk2]',
    place_result = 'rr-logistic-robot',
    stack_size = 500,
  },
  {
    type = 'recipe',
    name = 'rr-logistic-robot',
    enabled = false,
    ingredients = {
      { type = 'item', name = 'logistic-robot', amount = e_count },
      { type = 'item', name = 'fission-reactor-equipment', amount = 1 },
    },
    results = {{ type = 'item', name = 'rr-logistic-robot', amount = 1 }},
  },
  -- Technology
  {
    type = 'technology',
    name = 'rr-equipments',
    icon = path_g .. 'rr-equipments.png',
    icon_size = 256,
    effects = {
      { type = 'unlock-recipe', recipe = 'rr-battery' },
      { type = 'unlock-recipe', recipe = 'rr-energy-shield' },
      { type = 'unlock-recipe', recipe = 'rr-fusion-reactor' },
      { type = 'unlock-recipe', recipe = 'rr-personal-laser-defense' },
      { type = 'unlock-recipe', recipe = 'rr-exoskeleton' },
      { type = 'unlock-recipe', recipe = 'rr-personal-roboport' },
      { type = 'unlock-recipe', recipe = 'rr-power-armor' },
      { type = 'unlock-recipe', recipe = 'rr-construction-robot' },
      { type = 'unlock-recipe', recipe = 'rr-logistic-robot' },      
    },
    prerequisites = { 'power-armor-mk2', 'space-science-pack' },
    unit = {
      count = 5000,
      ingredients = {
        { 'automation-science-pack', 1 },
        { 'logistic-science-pack', 1 },
        { 'chemical-science-pack', 1 },
        { 'military-science-pack', 1 },
        { 'production-science-pack', 1 },
        { 'utility-science-pack', 1 },
        { 'space-science-pack', 1 },
      },
      time = 60,
    }
  },
})
