// Expanded Roster: the character screen's brother list gets 36 slots instead of vanilla's 27
// (18 battle formation slots + 18 reserve slots, i.e. two reserve rows).
// Must match ::ER.FormationSlots / ::ER.FirstReserveSlot in scripts/!mods_preload/main_ER.nut.
{
    var ER_FORMATION_SLOTS = 36;
    var ER_FIRST_RESERVE_SLOT = 18;

    // Replaces vanilla's createBrotherSlots, which hardcodes 27 slots
    CharacterScreenBrothersListModule.prototype.createBrotherSlots = function (_parentDiv)
    {
        var self = this;

        this.mSlots = [];
        for (var n = 0; n < ER_FORMATION_SLOTS; ++n)
        {
            this.mSlots.push(null);
        }

        var dropHandler = function (ev, dd)
        {
            var drag = $(dd.drag);
            var drop = $(dd.drop);
            var proxy = $(dd.proxy);

            if (proxy === undefined || proxy.data('idx') === undefined || drop === undefined || drop.data('idx') === undefined)
            {
                return false;
            }

            drag.removeClass('is-dragged');

            if (drag.data('idx') == drop.data('idx'))
            {
                return false;
            }

            var fromReserve = drag.data('idx') >= ER_FIRST_RESERVE_SLOT;
            var toReserve = drop.data('idx') >= ER_FIRST_RESERVE_SLOT;
            var dropSlotEmpty = self.mSlots[drop.data('idx')].data('child') == null;

            // number in formation is limited
            if (self.mNumActive >= self.mNumActiveMax && fromReserve && !toReserve && dropSlotEmpty)
            {
                return false;
            }

            // always keep at least 1 in formation
            if (self.mNumActive == 1 && !fromReserve && toReserve && dropSlotEmpty)
            {
                return false;
            }

            // do the swapping
            self.swapSlots(drag.data('idx'), drop.data('idx'));
        };

        for (var i = 0; i < ER_FORMATION_SLOTS; ++i)
        {
            if (i < ER_FIRST_RESERVE_SLOT)
                this.mSlots[i] = $('<div class="ui-control is-brother-slot is-roster-slot"/>');
            else
                this.mSlots[i] = $('<div class="ui-control is-brother-slot is-reserve-slot"/>');

            _parentDiv.append(this.mSlots[i]);

            this.mSlots[i].data('idx', i);
            this.mSlots[i].data('child', null);
            this.mSlots[i].drop("end", dropHandler);
        }
    };
}
