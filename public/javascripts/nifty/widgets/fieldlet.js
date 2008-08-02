Nifty.widgets.Fieldlet = Ext.extend(Ext.Container,{
	autoEl: {tag: 'span', cls: 'x-nifty-fieldlet'},
	isFieldlet: true,
	
	
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
		return this.editCmp || (this.editCmp = Ext.getCmp(this.formId));
	},
	
	getDisplayCmp: function(){
		return this.displayCmp || (this.displayCmp =  Ext.getCmp(this.formId + 'display'));
	},
	
	
	onRender: function(){
		Nifty.widgets.Fieldlet.superclass.onRender.apply(this, arguments);
		
		this.setValue(this.value || this.defaultValue);
		this.initEvents();
		
		// by default, the fieldlets are disabled
		if(!this.dontDisable){
			this.getEditCmp().disable();
		} else {
			// we are in new entity mode, let's add the fieldlet to the form items, 
			// so it could be removed if not dirty when submitted
			this.addEditItemToForm(this, this.getEditCmp());
		}
	},
	
    // set our instance to be dirty!
	isDirty: function(){
	    if(this.getEditCmp().isDirty()){
	    	this.fireEvent('dirty', this, this.getEditCmp());
	    }
	},

	initComponent : function(){
		// apply options to items:
		Ext.apply(this.displayItem, this.displayItemOptions || {});
		Ext.apply(this.editItem, this.editItemOptions || {});
				
		// sets the display item & inital value if xTemplate
		this.setDisplayItem();
		
		this.initEvents(); /// setup events
		
		this.setId(this.formId);
		
		if(!this.displayItem.cls)
			this.displayItem.cls = '';
		
		this.displayItem.cls += ' fieldlet-display-item';

		if(!this.editItem.cls)
			this.editItem.cls = '';
			
		this.editItem.cls += ' fieldlet-edit-item';

        Nifty.widgets.Fieldlet.superclass.initComponent.call(this);

		this.add(this.displayItem);
		this.add(this.editItem);
		
		this.bindEditItemEvents();
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
			'invalid',
			
			/**
             * @event edited
             * Fires when the fieldlet becomes ready for editing
             * @param {Ext.Container} this
             * @param {ContainerLayout} layout The ContainerLayout implementation for this container
             */
			'edited'
		)
		
		
		// add the editItem to the form
		this.on('edited', this.addEditItemToForm)
		
		
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
	
	// TODO: this is not so good. will be a problem for editable lists! 
	addEditItemToForm: function(container, component, index){
		formItems = Nifty.pages.current.form.items
		if(component.xtype != 'box' && !formItems.contains(component)){
			formItems.add(component);
			component.enable();
		}
	},
	
	
	// initiate the display item if its an xtemplate
	setDisplayItem: function(){
		if (Ext.type(this.displayItem) == 'string'){ // template? 
			this.tpl = new Ext.XTemplate(this.displayItem);
			this.displayItem = {xtype:'box', autoEl: {tag: 'span', html: this.markupForDisplay(this.value || this.defaultValue)}};
		}
	},
	
	
	// return html markup for display items
	markupForDisplay: function(value){
		return this.tpl.apply({value: value})
	},
	
	// called by the field when entering to edit mode
	beforeEnteringEditMode: function(){
		this.dontDisable = true;
		this.fireEvent('edited', this, this.getEditCmp());
	},

	
})