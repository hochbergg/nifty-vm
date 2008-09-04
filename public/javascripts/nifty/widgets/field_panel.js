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
	/**
     * @cfg {string} placement
     * sets if the fieldlets will be place in a block mode (like list items)
     * in an inline mode (like a seperated list - tag list for example)
	 * in a table view 
     */
	/**
     * @cfg {string} instanceTagName
     * 
     * 
	 * 
     */
	
	
	// used with the form layout
	isFormField: true,
	
	initComponent: function(){
		this.fieldId = this.identifier;
		// setup labels
		this.fieldLabel = this.name;
		
		this.trackOver = true;
		// hookup template and store

		this.store = Ext.StoreMgr.lookup(this.fieldId); //setup the store
		
		if(!this.children){this.children = Nifty.schema.loaded.elements[this.fieldId]};
		
		if(!this.placement){this.placement = 'block'}
		
		if(!this.instanceTagName && this.placement === 'block'){this.instanceTagName = 'div'};
		if(!this.instanceTagName && this.placement === 'inline'){this.instanceTagName = 'span'};		
		if(!this.instanceTagName && this.placement === 'table'){this.instanceTagName = 'tr'};
				
		if(!this.instanceFragments){
			this.instanceFragments = [];
			Ext.each(this.children,function(child){
				this.instanceFragments.push({kind: child});
			},this);
			
		}
		this.itemSelector = this.instanceTagName + '.x-nifty-field-instance';
		
		// speed up things with a little bit of caching
		if(Nifty.cache.elements[this.identifier]){
			this.tpl = Nifty.cache.elements[this.identifier];
		} else {
			this.tpl = Nifty.cache.elements[this.identifier] = new Ext.XTemplate(this.buildTemplate());
		}
				
		// call the to superclass 
		Nifty.widgets.field.superclass.initComponent.call(this);
		
		this.on('render', this.setupActionTab, this, {delay:20})
	},
	
	setupActionTab: function(){
		this.tabEl = Ext.get('nifty-tab-' + this.fieldId);
		if(!this.tabEl){return};
		this.tabEl.setVisibilityMode(Ext.Element.VISIBILITY);
		
		this.hookActionTab();
	},


	hookActionTab: function(){
		this.on('mouseenter', this.tabEvents.mouseEnter, this, {stopPropagation: true});
		this.tabEl.on('click',this.tabEvents.startEdit,this, {delegate: 'img.x-nifty-tab-edit'});
		this.tabEl.on('click',this.tabEvents.deleteInstance,this, {delegate: 'img.x-nifty-tab-delete'});
		this.el.on('mouseout', this.tabEvents.mouseOut, this)
	},
	
	
	
	tabEvents: {
		// called when the mouse enter
		mouseEnter: function(dv, recordNumber, node, e){
			if(this.tabEl.currentItem === recordNumber){return;}
			this.tabEl.alignTo(node, 'tr-tl');
			this.tabEl.currentItem = recordNumber;
			this.tabEl.setVisible(true); // showit
		},
		
		mouseOut: function(e){
			t = e.getRelatedTarget();
			if(!t){return;}
			if(t.id == this.el.id){return;}
			if(e.within(this.el,true)){return;}
			
			this.tabEl.setVisible(false);
		},
		
		
		startEdit: function(){
			alert('editing ' + this.tabEl.currentItem);
		},
		
		deleteInstance: function(){
			alert('delete ' + this.tabEl.currentItem);
		}
	},
	
	buildActionTab: function(){
		var items = [];
		items.push(String.format('<img class="x-nifty-tab-delete" src="{0}"/>',Ext.BLANK_IMAGE_URL));
		items.push(String.format('<img class="x-nifty-tab-edit" src="{0}"/>',Ext.BLANK_IMAGE_URL));

		return items.join('');
	},
	
	buildTemplate: function(){
		var templateFragments = [];
		
		if(this.beforeFragment){templateFragments.push(this.beforeFragment)};
		
		templateFragments.push(String.format('<tpl for="."><{0} class="x-nifty-field-instance">', this.instanceTagName));
		if(this.seperatorFragment){
			templateFragments.push('<tpl if="xindex &gt; 1">');
			templateFragments.push(this.seperatorFragment);
			templateFragments.push('</tpl>');			
		}
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
		templateFragments.push(String.format('</{0}></tpl>', this.instanceTagName));

		if(this.afterFragment){templateFragments.push(this.afterFragment)};	
		templateFragments.push(String.format('<span class="x-nifty-action-tab" id="nifty-tab-{0}">',this.fieldId));	
		templateFragments.push(this.buildActionTab());
		templateFragments.push('</span>')
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