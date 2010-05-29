//
// rating Plugin
// By Chris Richards
//
// Turns a select box into a star rating control.
//

//Keeps 'jQuery' pointing to the jQuery version
(function (jQuery) { 
	
	jQuery.fn.rating = function(options)
	{
		//
		// Settings
		//
		var settings =
		{
			showCancel: true,
			cancelValue: null,
			startValue: null,
			disabled: false
		};
		jQuery.extend(settings, options);
		
		//
		// Events API
		//
		var events =
		{
			hoverOver: function(evt)
			{
				var elm = jQuery(evt.target);
				
				//Are we over the Cancel or the star?
				if( elm.hasClass("ui-rating-cancel") )
				{
					elm.addClass("ui-rating-cancel-full");
				} 
				else 
				{
					elm.prevAll().andSelf()
						.not(".ui-rating-cancel")
						.addClass("ui-rating-hover");
				}
			},
			hoverOut: function(evt)
			{
				var elm = jQuery(evt.target);
				//Are we over the Cancel or the star?
				if( elm.hasClass("ui-rating-cancel") )
				{
					elm.addClass("ui-rating-cancel-empty")
						.removeClass("ui-rating-cancel-full");
				}
				else
				{
					elm.prevAll().andSelf()
						.not(".ui-rating-cancel")
						.removeClass("ui-rating-hover");
				}
			},
			click: function(evt)
			{
				var elm = jQuery(evt.target);
				var value = settings.cancelValue;
				//Are we over the Cancel or the star?
				if( elm.hasClass("ui-rating-cancel") )
				{
					//Clear all of the stars
					events.empty(elm);
				}
				else
				{
					//Set us, and the stars before us as full
					elm.closest(".ui-rating-star").prevAll().andSelf()
						.not(".ui-rating-cancel")
						.attr("className", "ui-rating-star ui-rating-full");
					//Set the stars after us as empty 
					elm.closest(".ui-rating-star").nextAll()
						.not(".ui-rating-cancel")
						.attr("className", "ui-rating-star ui-rating-empty");
					//Uncheck the cancel
					elm.siblings(".ui-rating-cancel")
						.attr("className", "ui-rating-cancel ui-rating-cancel-empty");
					//Use our value
					value = elm.attr("value");
				}
				
				//Set the select box to the new value
				if( !evt.data.hasChanged )
				{
					jQuery(evt.data.selectBox).val( value ).trigger("change");
				}
			},
			change: function(evt)
			{
				var value =  jQuery(this).val();
				events.setValue(value, evt.data.container, evt.data.selectBox);
			},
			setValue: function(value, container, selectBox)
			{
				//Set a new target and let the method know the select has already changed.
				var evt = {"target": null, "data": {}};
				evt.target = jQuery(".ui-rating-star[value="+ value +"]", container);
				evt.data.selectBox = selectBox;
				evt.data.hasChanged = true;
				events.click(evt);
			},
			empty: function(elm)
			{
				//Clear all of the stars
				elm.attr("className", "ui-rating-cancel ui-rating-cancel-empty")
					.nextAll().attr("className", "ui-rating-star ui-rating-empty");
			}
		};
		
		//
		// HTML API
		//
		var HTML =
		{
			// Creates the holding container for the rating control
			createContainer: function(elm)
			{
				var div = jQuery("<div/>").attr({
	                title: elm.title,
	                className: "ui-rating"
	            }).insertAfter( elm );
				return div;
			},
			// Creates a Star
			createStar: function(elm, div)
			{
				jQuery("<a/>").attr({
					className: "ui-rating-star ui-rating-empty",
					title: jQuery(elm).text(),
					value: elm.value
				}).appendTo(div);
			},
			// Create the Cancel Button
			createCancel: function(elm, div)
			{
				jQuery("<a/>").attr({
					className: "ui-rating-cancel ui-rating-cancel-empty",
					title: "Cancel"
				}).appendTo(div);
			}
		};
		
		//
		// Process the matched elements
		//
		return this.each(function(){
			//We only do select types
			if( jQuery(this).attr("type") !== "select-one" ) { return; }
			//Save 'this' for ease of development
			var selectBox = this;
			//Hide the selectBox
			jQuery(selectBox).css("display", "none");
			//Does it have an ID? if not generate one
			var id = jQuery(selectBox).attr("id");
			if( "" === id ) { id = "ui-rating-" + jQuery.data(selectBox); jQuery(selectBox).attr("id", id); }
			
			//Create the holding container
			var div = HTML.createContainer(selectBox);
			
			//Should we do any binding?
			if( true !== settings.disabled && jQuery(selectBox).attr("disabled") !== true )
			{	
			    //Bind our events to the container
			    jQuery(div).bind("mouseover", events.hoverOver)
				    .bind("mouseout", events.hoverOut)
				    .bind("click",{"selectBox": selectBox}, events.click);
			}	
			//Should we create the Cancel button?
			if( settings.showCancel )
			{
				HTML.createCancel(this, div);
			}
			
			//Now loop over every option in the select box.
			jQuery("option", selectBox).each(function(){
				//Create a Star
				HTML.createStar(this, div);
			});
			
			//Is there an element with the select option set?
			if( 0 !== jQuery("#" + id + " option[selected]").size() ) 
			{
				//Set the Starting Value
				events.setValue( jQuery(selectBox).val(), div, selectBox );
			} else {
				//Use a start value if we have it, otherwise use the cancel value.
				var val = null !== settings.startValue ? settings.startValue : settings.cancelValue;
				events.setValue( val, div, selectBox );
				//Make sure the selectbox knows our desision
				jQuery(selectBox).val(val);
			}
			//Update the stars if the selectbox value changes.
			
			jQuery(this).bind("change", {"selectBox": selectBox, "container": div},  events.change);
		});
		
	};

})(jQuery);
