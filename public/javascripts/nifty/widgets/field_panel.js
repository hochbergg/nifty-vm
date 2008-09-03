Nifty.widgets.field = Ext.extend(Ext.DataView, {
	/**
     * @cfg {String} fieldId
     * <b>This is a required setting</b> the field we will work with;
     */
	/**
     * @cfg {String} beforeFragment
     * XTemplate style fragment wich will be added before the field instances
     * 
     */
	/**
     * @cfg {String} afterFragment
     * XTemplate style fragment wich will be added after the field instances
     * 
     */
	/**
     * @cfg {String} seperatorFragment
     * XTemplate style fragment wich will be added between the field instances
     * 
     */
	/**
     * @cfg {Array} instanceFramgents
     * <b>This is a required setting</b> a mixed array of XTemplate style strings and objects of the type 
	 * {kind: <fieldletKindHash>, cls: <optionalFieldletClass>}
	 * will be used to construct the instance template
     * 
     */
	
	// used with the form layout
	isFormField: true,
	
	initComponent: function(){
		this.fieldId = this.identifier;
		// setup labels
		this.fieldLabel = this.name;
		
		// hookup template and store

		this.store = Ext.StoreMgr.lookup(this.fieldId);
		if(!this.children){this.children = Nifty.schema.loaded.elements[this.fieldId]};
		
		if(!this.seperatorFragment){this.seperatorFragment = '<br/>'};
		
		if(!this.instanceFragments){
			this.instanceFragments = [];
			Ext.each(this.children,function(child){
				this.instanceFragments.push({kind: child});
			},this);
			
		}
		this.itemSelector = 'span.x-nifty-field-instance';
		this.tpl = new Ext.XTemplate(this.buildTemplate());
		
		// call the to superclass 
		Nifty.widgets.field.superclass.initComponent.call(this);
	},
	
	
	buildTemplate: function(){
		var templateFragments = [];
		
		if(this.beforeFragment){templateFragments.push(this.beforeFragment)};
		
		templateFragments.push('<tpl for="."><span class="x-nifty-field-instance">');
		templateFragments.push('<tpl if="xindex &gt; 1">');
		templateFragments.push(this.seperatorFragment);
		templateFragments.push('</tpl>');
		Ext.each(this.instanceFragments, function(fragment){
			if(typeof fragment === 'string'){
				templateFragments.push(fragment);
			} else {
				var schemaFieldlet = Nifty.schema.loaded.elements[fragment.kind];
				var fieldlet = Nifty.widgets.fieldlets[schemaFieldlet.preferences.type];
				
				templateFragments.push(String.format('<tpl for="f{0}">', fragment.kind))
					templateFragments.push(String.format('<span class="{0} {1}">', fieldlet.cls, 
															Ext.util.Format.undef(fragment.cls)));
					
					if (typeof fieldlet.displayTpl === 'string'){
						templateFragments.push(fieldlet.displayTpl);
					} else {
						templateFragments = templateFragments.concat(fieldlet.displayTpl)
					}
					
				templateFragments.push('</span></tpl>');
			}
		},this);
		templateFragments.push('</span></tpl>');

		if(this.afterFragment){templateFragments.push(this.afterFragment)};		
		
		return templateFragments;
	}
});










//Nifty.widgets.field = Ext.extend(Ext.Container, {
//	
//	// defalut seperator
//	seperator: {xtype: 'component', autoEl: {tag: 'br'}},
//
//	// autoElement generation for the Ext.Container
//	autoEl: {tag: 'div', cls: 'x-panel-nifty-field'},
//	
//	// used with the form layout
//	isFormField: true,
//	
//	initComponent: function(){
//		this.fieldLabel = this.name;
//	
//	
//	    Nifty.widgets.field.superclass.initComponent.apply(this, arguments);
//    	
//	},
//	
//	// Override other inherited methods 
//    onRender: function(){
//		// load the field data from the entity store
//		
//		this.setupHeader();
//		
//		this.load();
//		
//		this.setupFooter();
//   
//        // Call parent (required)
//        Nifty.widgets.field.superclass.onRender.apply(this, arguments);
//   
//        // After parent code
//
//		// set as edit if this is new entity
//		this.setEditIfnew();
//	}, 
//	
//	// load the field data from the entity store
//	load: function(){
//		// we can't load anything if we have no fieldId
//		if(!this.identifier){return;}
//				
//		if(this.children && !this.instanceLayout){ // if no layout, create a default one
//			this.instanceLayout = [];
//			Ext.each(this.children, function(i){
//				this.instanceLayout.push({kind: i});
//			},this);
//		};
//		
//	
//		this.data = this.getStore().fields[this.identifier];
//		
//		if(this.data == null){
//			return this.addEmptyInstances();
//		}
//
//		// add instnaces 
//		for(instance=0;instance<this.data.length;instance++){
//			this.addInstance(this.data[instance]);
//		}
//	
//	},
//	
//	
//	// add the header to the items
//	setupHeader: function(){
//		if(!this.header)
//			return;
//		
//		this.add(this.header);
//	},
//	
//	setupFooter: function(){
//		if(!this.footer)
//			return;
//		
//		this.add(this.footer);
//	},
//	
//	addEmptyInstances: function(){
//		this.addInstance({});
//		return true;
//	},
//	
//	addInstance: function(data){
//		this.addSeperatorIfNeeded();
//		this.add({
//					data: data,
//					instanceLayout: this.instanceLayout,
//					xtype: 'fieldInstance'
//				});
//	},
//	
//	// will add the seperator only if the last element on the items is
//	// another fieldInstance! 
//	addSeperatorIfNeeded: function(){
//		if(this.items && this.items.last().initialConfig.xtype === 'fieldInstance'){
//			this.add(this.seperator);
//		}
//	},
//	
//	removeInstance: function(instance_id){
//	//	console.log("removing: " + instance_id);
//	},
//	
//	toggleEdit: function(){
//		if(this.editing){
//			this.removeClass('x-panel-nifty-field-edited');	
//			this.editing = false;
//		} else {
//			// call the beforeEdit for each instance
//			this.items.each(function(item){
//				if(item.beforeEnteringEditMode){
//					item.beforeEnteringEditMode();
//				}
//			});			
//			
//			this.addClass('x-panel-nifty-field-edited');
//			this.editing = true;	
//		}
//	},
//	
//	getStore: function(){
//		if(this.store){return this.store};
//		return this.store = Nifty.pages.current.entityStore;
//	},
//	
//	// check if new, if true, set as edit
//	setEditIfnew: function(){
//		if (this.getStore().data.isNew){
//			this.toggleEdit();}
//	}
//});