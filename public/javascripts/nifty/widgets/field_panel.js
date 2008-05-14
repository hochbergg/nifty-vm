Nifty.widgets.FieldPanel = Ext.extend(Ext.Container, {
	fieldlets: [],
	subtitle: null,
	title: null,
	fieldId: null,
	default_instances: 1,
	maximum_instances: null,
	lastInstance: -1,
	editing: false,
	autoEl: {tag: 'div', cls: 'x-panel-nifty-field'},
	isFormField: true, // for form layout
	
	// Override other inherited methods 
    onRender: function(){

        // Before parent code
		this.load();
   
        // Call parent (required)
        Nifty.widgets.FieldPanel.superclass.onRender.apply(this, arguments);
   
        // After parent code

		// set as edit if this is new entity
		this.setEditIfnew();
		
		
	}, 
	
	
	
	addSideTitle: function(){
		this.add({xtype: 'box' ,cls: 'x-nifty-field-side-title', 
				id: this.fieldId + '-side-title',
				overCls: 'x-nifty-field-side-title-over',
				listeners: {
					'render': function(){
						Ext.get(this.fieldId + '-Edit-But').on('click', this.toggleEdit, this)
					},
					scope: this
				},
				autoEl: {tag: 'div', 
					html: String.format('<a id="{0}" class="x-nifty-field-edit"></a><span>{1}</span>', this.fieldId + '-Edit-But', this.title + ':')
				}})
	},
	
	load: function(){
		// if only fieldset
		if(!this.fieldId)
			return; 
		
		
		field = Nifty.pages.EntityPage.entityStore.fields[this.fieldId];
		
		if(field == null){
			return this.addEmptyInstances();
		}
		
		for(instance in field){
			this.addInstance({id: instance,field: field[instance], fieldlets: this.fieldlets});
		}
	
	},
	
	addEmptyInstances: function(){
		this.addInstance({id: (this.lastInstance + 1), fieldlets: this.fieldlets});
		return true;
	},
	
	addInstance: function(options){
		this.lastInstance = parseInt(options.id);
		
		this.add({	instanceId: options.id,
					field: options.field,
					items: options.fieldlets,
					xtype: 'fieldInstance'
				})
			
	},
	
	removeInstance: function(instance_id){
		console.log("removing: " + instance_id);
	},
	
	toggleEdit: function(){
		if(this.editing){
			this.removeClass('x-panel-nifty-field-edited');
			this.editing = false;
		} else {
			this.addClass('x-panel-nifty-field-edited');
			this.editing = true;
		}
	},
	
	
	// check if new, if true, set as edit
	setEditIfnew: function(){
		if (Nifty.pages.EntityPage.entityStore.data.isNew)
			this.toggleEdit();
	}
});