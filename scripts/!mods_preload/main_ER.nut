::ER <- {
	ID = "mod_ER",
	Name = "Expanded Roster",
	Version = "0.1.0",
	FavoriteIDs = {},
	ForSaleIDs = {}
};

::ER.HookMod <- ::Hooks.register(::ER.ID, ::ER.Version, ::ER.Name);
::ER.HookMod.require("mod_msu > 1.2.0");
::ER.HookMod.conflictWith("mod_smartLoot");

::ER.HookMod.queue(">mod_msu", ">mod_reforged", function() {
	::ER.Mod <- ::MSU.Class.Mod(::ER.ID, ::ER.Version, ::ER.Name)
	::include("mod_er/load.nut");
})

/*::ER.HookMod.queue(">mod_msu", function(){
	::ER.JSConnection <- ::new("scripts/ui/mods/eimo_js_connection");
	::MSU.UI.registerConnection(::ER.JSConnection);
}, ::Hooks.QueueBucket.AfterHooks);*/
