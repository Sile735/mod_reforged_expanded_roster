// Expanded Roster - preload / registration
// Raises the company roster limit to 30 and adds a second row of reserve slots to the character screen.

::ER <- {
	ID = "mod_ER",
	Name = "Expanded Roster",
	Version = "0.2.0",	// keep in sync with the GitHub release tag
	GitHubURL = "https://github.com/Sile735/mod_reforged_expanded_roster",

	RosterMax = 30,			// maximum number of brothers in the company (vanilla: 20)
	FormationSlots = 36,	// formation slots: 18 battle slots + 18 reserve slots (vanilla: 18 + 9 = 27)
	FirstReserveSlot = 18	// slots 0-17 are the battle formation, 18+ are reserves (same as vanilla)
};
// The JS side (ui/mods/er/character_screen_brothers_list_module.js) uses the same slot numbers.

::ER.HookMod <- ::Hooks.register(::ER.ID, ::ER.Version, ::ER.Name);
::ER.HookMod.require("mod_msu > 1.2.0");
::ER.HookMod.conflictWith("mod_smartLoot");

// ">" = load after MSU and Reforged
::ER.HookMod.queue(">mod_msu", ">mod_reforged", function() {
	::ER.Mod <- ::MSU.Class.Mod(::ER.ID, ::ER.Version, ::ER.Name);

	// In-game "new version available" notification via MSU
	::ER.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::ER.GitHubURL);
	::ER.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_er/load.nut");
});
