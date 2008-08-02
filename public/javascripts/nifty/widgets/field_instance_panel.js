/*
 TODO: fix the whole events thingy

*/



// new field instance delimiter, used for grouping new fields when submitting to the server
Nifty.fields.newFieldInstanceIdDelimiter = 0; 

Nifty.widgets.FieldInstancePanel = Ext.extend(Ext.Container, {
	autoEl: {tag: 'div', cls: 'x-nifty-field-instance'},

	// insert the items according to the instanceLayout
	initComponent: function(){ 
		this.instanceId = this.data['instanceId'] || Nifty.fields.newFieldInstanceIdDelimiter++;
		
		if(!this.instanceLayout){
			this.instanceLayout = [];
		}	
		
		// setup the items
		this.items = [];
		
		// build the instanceLayout
		Ext.each(this.instanceLayout, function(item){
			if(!item.kind){ // not fieldlet
				this.items.push(item) // just add it
				return;
			} 
			
			// fetch the fieldlet value from the fieldInstance
			if(this.data && this.data[item.kind]){ // we have data
				item.value = this.data[item.kind].value;
				item.formId = String.format('entity[{0}][{1}]', this.data[item.kind].id, item.kind);
			} else { // we don't have any data
				item.formId = String.format('entity[new][{0}][{1}]', this.instanceId ,item.kind);		
			}
			
			
			item.xtype = 'Fieldlet' + item.kind; //set xtype
			item.instance = this
			
			// add the item
			this.items.push(item);
		}, this);
		
		// init the events
		this.initEvents();
		
		Nifty.widgets.FieldInstancePanel.superclass.initComponent.apply(this, arguments);
		
	},
	
//	// checkd if all the fieldlet in this instance are blured
//	isBlured: function(event){
//		focused = false;
//		Ext.each(this.fieldletComponents, function(fieldlet){
//			if(fieldlet.focused)
//				focused = true;
//		}, this);
//		
//		if(!focused)
//			this.fireEvent('blur', this);
//	},
//	
//	
//	// checks if the given event made by tab key
//	isTabbedOut: function(e){
//		if(e.getKey() == Ext.EventManager.TAB)
//			this.fireEvent('tabbedout', this, this.container);
//	},
	
	
	initEvents: function(){
        this.addEvents(
            /**
             * @event focus
             * Fires when the fieldinstance is in focus (one of the fieldlets is in focus)
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */
            'focus',

            /**
             * @event blur
             * Fires when non of the fieldlets are in focus (after they were)
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */

			'blur',
			
			
			
			/**
             * @event leave
             * Fires when the last fieldlet is blured by a 'tab' click
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */
			'tabbedout',
			
			/**
             * @event dirty
             * Fires when one of the fieldlet is dirty
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */			
			'dirty', 
			
			
			/**
             * @event invalid
             * Fires when one (or more) of the fieldlets is invalid
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */
			'invalid'
		)
		
		// fired when a fieldlet is added to an instance
		this.on('add', this.addFieldletComponents);
	
		
		// mark self as dirty
		this.on('dirty', this.setDirty,this);
	},
	
	
	// pushes the fieldlets to an array, for later binding with events
	addFieldletComponents: function(container, component){
		if(!component.isFieldlet) // only fieldlets
			return;
		
		if(!container.fieldletComponents)
			container.fieldletComponents = []; // create an array if not available
		
		
		// set events
		this.relayEvents(component, ['focus', 'dirty', 'invalid']);
		//component.on('blur', this.isBlured, this);
		
		
		container.fieldletComponents.push(component);
	},
	
	
	// mark self with "dirty" class
	setDirty: function(){
		this.addClass('x-nifty-field-instance-dirty')
	},
	
	
	beforeEnteringEditMode: function(){
		this.items.each(function(item){
			if(item.beforeEnteringEditMode){
			item.beforeEnteringEditMode();}
		});
	}, 
	

});

Ext.reg('fieldInstance', Nifty.widgets.FieldInstancePanel);