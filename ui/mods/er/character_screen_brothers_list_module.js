{   
    
    CharacterScreenBrothersListModule.prototype.createBrotherSlots = function (_parentDiv)
    {
        var self = this;

        this.mSlots = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null ];

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

            // number in formation is limited
            if (self.mNumActive >= self.mNumActiveMax && drag.data('idx') > 17 && drop.data('idx') <= 17 && self.mSlots[drop.data('idx')].data('child') == null)
            {
                return false;
            }

            // always keep at least 1 in formation
            if (self.mNumActive == 1 && drag.data('idx') <= 17 && drop.data('idx') > 17 && self.mSlots[drop.data('idx')].data('child') == null)
            {
                return false;
            }

            // do the swapping
            self.swapSlots(drag.data('idx'), drop.data('idx'));
        };

        for (var i = 0; i < 36; ++i)
        {
            if(i < 18)
                this.mSlots[i] = $('<div class="ui-control is-brother-slot is-roster-slot"/>');
            else
                this.mSlots[i] = $('<div class="ui-control is-brother-slot is-reserve-slot"/>');

            _parentDiv.append(this.mSlots[i]);

            this.mSlots[i].data('idx', i);
            this.mSlots[i].data('child', null);
            this.mSlots[i].drop("end", dropHandler);
        }

        /*$('.is-brother-slot')
          .drop("start", function ()
          {
              $(this).addClass("is-active-slot");
          })
          .drop("end", function ()
          {
              $(this).removeClass("is-active-slot");
          });*/
    }
    }