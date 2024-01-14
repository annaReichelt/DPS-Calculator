-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
	DPSCalculator = {}
 
	-- This isn't strictly necessary, but we'll use this string later when registering events.
	-- Better to define it in a single place rather than retyping the same string.
	DPSCalculator.name = "DPSCalculator"
	 
	-- Next we create a function that will initialize our addon
	function DPSCalculator.Initialize()
	  DPSCalculator.inCombat = IsUnitInCombat("player");

	  EVENT_MANAGER:RegisterForEvent(DPSCalculator.name, EVENT_PLAYER_COMBAT_STATE, DPSCalculator.OnPlayerCombatState);
	end
	 
	-- Then we create an event handler function which will be called when the "addon loaded" event
	-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
	function DPSCalculator.OnAddOnLoaded(event, addonName)
	  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
	  if addonName == DPSCalculator.name then
		DPSCalculator.Initialize()
		--unregister the event again as our addon was loaded now and we do not need it anymore to be run for each other addon that will load
		EVENT_MANAGER:UnregisterForEvent(DPSCalculator.name, EVENT_ADD_ON_LOADED) 
	  end
	end

	function DPSCalculator.OnPlayerCombatState(event, inCombat)
		-- The ~= operator is "not equal to" in Lua.
		if inCombat ~= DPSCalculator.inCombat then
		  -- The player's state has changed. Update the stored state...
		  DPSCalculator.inCombat = inCombat
	   
		  -- ...and then announce the change.
		  if inCombat then
			d("Boobas")
		  else
			d("Exiting combat.")
		  end
	   
		end
	  end
	 
	-- Finally, we'll register our event handler function to be called when the proper event occurs.
	-->This event EVENT_ADD_ON_LOADED will be called for EACH of the addns/libraries enabled, this is why there needs to be a check against the addon name
	-->within your callback function! Else the very first addon loaded would run your code + all following addons too.
	EVENT_MANAGER:RegisterForEvent(DPSCalculator.name, EVENT_ADD_ON_LOADED, DPSCalculator.OnAddOnLoaded)