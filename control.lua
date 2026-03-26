local item_list = {
	{  1, 'rr-power-armor'},
	{  5, 'rr-battery'},
	{  3, 'rr-exoskeleton'},
	{  1, 'rr-fusion-reactor'},
	{ 15, 'rr-personal-laser-defense'},
	{  3, 'rr-energy-shield'},
	{  1, 'rr-personal-roboport'},
	{500, 'rr-construction-robot'},
	{  1, 'belt-immunity-equipment'},
	{  1, 'night-vision-equipment'},
	{  1, 'solar-panel-equipment'},
	{  20, 'boiler'},
	{  40, 'steam-engine'},
	{  50, 'burner-mining-drill'},
	{  200, 'electric-mining-drill'},
	{  2, 'offshore-pump'},
	{  200, 'stone-furnace'},
	{  50, 'assembling-machine-1'},
	{  50, 'assembling-machine-2'},
	{  50, 'iron-chest'},
	{  500, 'steel-chest'},
	{  6000, 'transport-belt'},
	{  300, 'underground-belt'},
	{  300, 'splitter'},
	{  4, 'burner-inserter'},
	{  1500, 'inserter'},
	{  300, 'long-handed-inserter'},
	{  700, 'fast-inserter'},
	{  900, 'small-electric-pole'},
	{  600, 'small-lamp'},
	{  600, 'pipe'},
	{  250, 'pipe-to-ground'},
	{  300, 'medium-electric-pole'},
	{  200, 'big-electric-pole'},
	{  10, 'lab'},
	{  10, 'train-stop'},
	{  200, 'rail-chain-signal'},
	{  200, 'rail-signal'},
	{  200, 'arithmetic-combinator'},
    {  200, 'decider-combinator'},
	{  200, 'constant-combinator'},
	{  10, 'locomotive'},
	{  40, 'cargo-wagon'},
	{  4000, 'straight-rail'},
}

-- Add items to player inventory
local function insert_into_inventory(player)
	if not (player and player.valid and player.name) then
		return
	end

	for _, item in pairs(item_list) do
		if prototypes.item[item[2]] ~= nil then
			player.insert{ name = item[2], count = item[1]}
		else
			player.print('Unable to add ' .. item[2] .. ' to inventory, please check spelling.')
		end
	end

	storage.players[player.name] = true
end

local function arm_player(player)
	if not (player and player.valid and player.name) then
		return
	end

	if not storage.players[player.name] then
		insert_into_inventory(player)
	end
end


-- Setup
script.on_init(function()
	storage.players = {}

	for _, player in pairs(game.players) do
		arm_player(player)
	end
end)

script.on_configuration_changed(function(ConfigurationChangedData)
	storage.players = storage.players or {}

	if ConfigurationChangedData.mod_changes['red-quickstart'] then
		for _, player in pairs(game.players) do
			local already_given = false
			-- check armor inventory
			local armor_inventory = player.get_inventory(defines.inventory.character_armor)
			if armor_inventory then
				local item, _ = armor_inventory.find_item_stack('rr-power-armor')
				if item then
					already_given = true
				end
			end
			-- check main inventory
			local main_inventory = player.get_main_inventory()
			if main_inventory then
				local item, _ = main_inventory.find_item_stack('rr-power-armor')
				if item then
					already_given = true
				end
			end
			if already_given then
				storage.players[player.name] = true
			else
				arm_player(player)
			end
		end
	end
end)

-- Add items to inventory
script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]
	pcall(player.exit_cutscene)

	arm_player(player)
end)

script.on_event(defines.events.on_player_joined_game, function(event)
	local player = game.players[event.player_index]

	arm_player(player)
end)
