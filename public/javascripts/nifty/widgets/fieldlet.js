Nifty.widgets.Fieldlet = Ext.extend(Ext.Container,{
	autoEl: {tag: 'span', cls: 'x-nifty-fieldlet'},
	
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
		
		this.setValue(this.value);
		this.initEvents();
	},
	
	initEvents: function(){
		
		// update the display value when changed!
		this.getEditCmp().on('change', this.updateDisplayWithEditValue, this);
		
		// mark the instance as dirty
		this.getEditCmp().on('change', this.markInstnaceAsDirty, this);
	},
	
    // set our instance to be dirty!
	markInstnaceAsDirty: function(editItem){
		if(editItem.isDirty()){
			this.instance.setDirty();
		}
	},

	initComponent : function(){
		Ext.apply(this, {
			displayItem: this.di,
			editItem: this.ei
		})
		
		// apply options to items:
		Ext.apply(this.displayItem, this.displayItemOptions);
		Ext.apply(this.editItem, this.editItemOptions);		
		
		// sets the display item & inital value if xTemplate
		this.setDisplayItemIfXTemplate();
		
		this.on('add', this.addEditItemToForm);
		this.setId(this.formId);
		
		if(!this.displayItem.cls)
			this.displayItem.cls = 'fieldlet-display-item';

		if(!this.editItem.cls)
			this.editItem.cls = 'fieldlet-edit-item';

        Nifty.widgets.Fieldlet.superclass.initComponent.call(this);

		this.add(this.displayItem);
		this.add(this.editItem);
	},
	
	addEditItemToForm: function(container, component, index){
		if(component.xtype != 'box'){
			Nifty.pages.current.form.items.add(component);
		}
	},
	
	setDisplayItemIfXTemplate: function(){
		if (Ext.type(this.displayItem.compileTpl) == 'function'){ // template? 
			this.tpl = this.displayItem;
			this.displayItem = {xtype:'box', autoEl: {tag: 'span', html: this.tpl.apply({value: this.value})}};
		}
	}
})