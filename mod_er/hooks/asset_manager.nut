// Roster size and formation slots.
// Vanilla allows 20 brothers and hardcodes 27 formation slots (18 battle + 9 reserve) in getFormation and
// updateFormation, so both are reimplemented here with ::ER.FormationSlots (36 = 18 battle + 18 reserve).
// The number of brothers allowed in battle (BrothersMaxInCombat) is unchanged.
::ER.HookMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.BrothersMax = ::ER.RosterMax;

	// Vanilla resets BrothersMax to 20 when a new campaign starts
	q.resetToDefaults = @(__original) { function resetToDefaults()
	{
		__original();
		this.m.BrothersMax = ::ER.RosterMax;
	}}.resetToDefaults;

	// Copy of vanilla with ::ER.FormationSlots instead of the hardcoded 27
	q.getFormation = @() { function getFormation()
	{
		local ret = [];
		ret.resize(::ER.FormationSlots, null);

		foreach (b in ::World.getPlayerRoster().getAll())
		{
			ret[b.getPlaceInFormation()] = b;
		}

		return ret;
	}}.getFormation;

	// Copy of vanilla with ::ER.FormationSlots instead of the hardcoded 27:
	// keeps everyone on a free slot, puts brothers without a valid slot on the first free one
	// (battle slots first while there is room for more brothers in battle) and keeps at least one in battle.
	q.updateFormation = @() { function updateFormation( considerMaxBros = false )
	{
		local NOT_IN_FORMATION = 255;
		local formation = [];
		formation.resize(::ER.FormationSlots, false);
		local roster = ::World.getPlayerRoster().getAll();
		local hasUnplaced = false;
		local inCombat = 0;

		foreach (b in roster)
		{
			local slot = b.getPlaceInFormation();
			if (slot != NOT_IN_FORMATION && formation[slot] == false && (!considerMaxBros || inCombat < this.m.BrothersMaxInCombat))
			{
				formation[slot] = true;
				if (slot < ::ER.FirstReserveSlot)
					inCombat++;
			}
			else
			{
				b.setPlaceInFormation(NOT_IN_FORMATION);
				hasUnplaced = true;
			}
		}

		if (hasUnplaced)
		{
			foreach (b in roster)
			{
				if (b.getPlaceInFormation() != NOT_IN_FORMATION)
					continue;

				// battle formation full -> start searching in the reserves
				local i = inCombat >= this.m.BrothersMaxInCombat ? ::ER.FirstReserveSlot : 0;
				for (; i < formation.len(); i++)
				{
					if (formation[i] == false)
					{
						b.setPlaceInFormation(i);
						formation[i] = true;
						if (i < ::ER.FirstReserveSlot)
							inCombat++;
						break;
					}
				}
			}
		}

		// Nobody in battle formation: put the first brother on slot 3 (vanilla behavior)
		if (inCombat == 0 && roster.len() != 0)
		{
			roster[0].setPlaceInFormation(3);
		}
	}}.updateFormation;
});
