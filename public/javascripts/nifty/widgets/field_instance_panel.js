Nifty.widgets.FieldInstancePanel = Ext.extend(Ext.Container, {
	fieldlets: [],
	field: null,
	instanceId: null,
	border: false,
	autoEl: {tag: 'div', cls: 'x-nifty-field-instance'},
	
	initComponent: function(){
		// set the ids & values of the fieldlets
		Ext.each(this.items,function(item){
			item.xtype = 'Fieldlet' + item.kind;
			item.formId = String.format('entity[{0}][{1}]', item.kind, this.instanceId);
			item.instance = this;
			
			delete item.value;
			
			if(this.field && this.field[item.xtype]){
				item.value = this.field[item.xtype].value;
			}
		}, this);
		
		
		// init the events
		this.initEvents();
		
		
		Nifty.widgets.FieldInstancePanel.superclass.initComponent.apply(this, arguments);
		
	},
	
	
	// sets events on the fieldlets
	bindFieldletsEvents: function(){
		
		this.fieldletComponents[fieldletComponents.length - 1].on('blur', this.isTabbedOut, this);
	},
	
	
	// checkd if all the fieldlet in this instance are blured
	isBlured: function(event){
		focused = false;
		Ext.each(this.fieldletComponents, function(fieldlet){
			if(fieldlet.focused)
				focused = true;
		}, this);
		
		if(!focused)
			this.fireEvent('blur', this);
	},
	
	
	// checks if the given event made by tab key
	isTabbedOut: function(e){
		if(e.getKey() == Ext.EventManager.TAB)
			this.fireEvent('tabbedout', this, this.container);
	},
	
	
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
             * @event dirty
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
		if(!container.fieldletComponents)
			container.fieldletComponents = []; // create an array if not available
		
		
		// set events
		this.relayEvents(component, ['focus', 'dirty', 'invalid']);
		component.on('blur', this.isBlured, this);
		
		
		container.fieldletComponents.push(component);
	},
	
	
	// Override other inherited methods 
    onRender: function(){

		
        // Call parent (required)
        Nifty.widgets.FieldInstancePanel.superclass.onRender.apply(this, arguments);
        // After parent code
		
	},
	
	// mark self with "dirty" class
	setDirty: function(){
		this.addClass('x-nifty-field-instance-dirty')
	}
	
	
	
});

Ext.reg('fieldInstance', Nifty.widgets.FieldInstancePanel);