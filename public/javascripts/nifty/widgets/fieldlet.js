Nifty.widgets.Fieldlet = Ext.extend(Ext.Container,{
	autoEl: {tag: 'span', cls: 'x-nifty-fieldlet'},
	
	editItemOptions: null,
	displayItemOptions: null,
	
	defaultValue: null, 
	
	// sets the value for the display and the edit field
	setValue: function(value){
		this.setDisplayValue(this.getDisplayCmp(), value);
		this.setEditValue(this.getEditCmp(), value);
	},
	
	
	// sets the ID & the name for the form elemnt
	setId: function(id){
		Ext.apply(this.editItem, {id: id});
		Ext.apply(this.displayItem, {id: (id + 'display')});	
	},
		
	// overrideable - default for XTemplate
	setDisplayValue: function(item, value){
	   if(item.el && this.tpl){
	      this.tpl.overwrite(item.el, {value: value});
	   }
	},
	
	// overrideable
	setEditValue: function(item, value){
		item.setValue(value);
	},
	
	// overrideable
	getEditValue: function(){
		return this.getEditCmp().getValue();
	},
	
	updateDisplayWithEditValue: function(){
		this.setDisplayValue(this.getDisplayCmp(), this.getEditValue());
	},
	
	
	getEditCmp: function(){
		return Ext.getCmp(this.formId);
	},
	
	getDisplayCmp: function(){
		return Ext.getCmp(this.formId + 'display');
	},
	
	
	onRender: function(){
		Nifty.widgets.Fieldlet.superclass.onRender.apply(this, arguments);
		
		this.setValue(this.value || this.defaultValue);
		this.initEvents();
	},
	
    // set our instance to be dirty!
	isDirty: function(editItem){
		if(editItem.isDirty()){
			this.fireEvent('dirty', this, editItem);
		}
	},

	initComponent : function(){
		delete this.displayItem;
		delete this.editItem;
		
		Ext.apply(this, {
			displayItem: this.di,
			editItem: this.ei
		})
		
		// apply options to items:
		Ext.apply(this.displayItem, this.displayItemOptions || {});
		Ext.apply(this.editItem, this.editItemOptions || {});
		
		
		// sets the display item & inital value if xTemplate
		this.setDisplayItemIfXTemplate();
		
		this.initEvents(); /// setup events
		
		
		this.setId(this.formId);
		
		if(!this.displayItem.cls)
			this.displayItem.cls = 'fieldlet-display-item';

		if(!this.editItem.cls)
			this.editItem.cls = 'fieldlet-edit-item';

        Nifty.widgets.Fieldlet.superclass.initComponent.call(this);

		this.add(this.displayItem);
		this.add(this.editItem);
		
		this.bindEditItemEvents();
		this.clear();
	},
	
	// clear the already loaded data 
	clear: function(){
		//delete this.di;
		//delete this.ei;
		//delete this.displayItemOptions;
		//delete this.editItemOptions;
		//delete this.displayItem;
		//delete this.editItem;
	},
	
	// setup all the events
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
		
		
		// add the editItem to the form
		this.on('add', this.addEditItemToForm);
		
		
		// toggle focused status
		this.on('focus', function(){
			this.focused = true;
		}, this)
		
		this.on('blur', function(){
			this.focused = false;
		}, this)
	},
	
	
	// relay events to the edit item
	bindEditItemEvents: function(){
		this.relayEvents(this.getEditCmp(), ['focus', 'blur','invalid']);
		
		
		// update the display value when changed!
		this.getEditCmp().on('change', this.updateDisplayWithEditValue, this);
        
		// mark the instance as dirty
		this.getEditCmp().on('change', this.isDirty, this);
	},
	
	
	addEditItemToForm: function(container, component, index){
		if(component.xtype != 'box'){
			Nifty.pages.current.form.items.add(component);
		}
	},
	
	setDisplayItemIfXTemplate: function(){
		if (Ext.type(this.displayItem.compileTpl) == 'function'){ // template? 
			this.tpl = this.displayItem;
			console.log(this.value || this.defaultValue);
			this.displayItem = {xtype:'box', autoEl: {tag: 'span', html: this.markupForDisplay(this.value || this.defaultValue)}};
		}
	},
	
	
	// return html markup for display items
	markupForDisplay: function(value){
		return this.tpl.apply({value: value})
	}
	
	
	
})