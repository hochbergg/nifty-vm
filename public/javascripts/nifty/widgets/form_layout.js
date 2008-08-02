/*
* FormLayout
*
*
*/



Nifty.layout.FormLayout = Ext.extend(Ext.layout.FormLayout,{
	
    setContainer : function(ct){
		// set default options
		Ext.apply(ct, {	labelAlign: 'left'});
		
		// prepare layout
		var t = new Ext.Template(
            '<div class="x-form-item {5}" tabIndex="-1">',
                '<label for="{0}" id="label-for-{0}" style="{2}" class="x-form-item-label x-nifty-field-side-title">',
				'<a id="edit-{0}" class="x-nifty-field-edit"></a>{1}{4}</label>',
                '<div class="x-form-element" id="x-form-el-{0}" style="{3}">',
                '</div><div class="{6}"></div>',
            '</div>'
        );
        t.disableFormats = true;
        t.compile();
		
		Ext.apply(this, {fieldTpl: t});
		
        Nifty.layout.FormLayout.superclass.setContainer.call(this, ct);
	},
	
	
	
	renderItem : function(c, position, target){
		Nifty.layout.FormLayout.superclass.renderItem.apply(this, arguments);
        
		if(c && c.rendered && c.isFormField && c.inputType != 'hidden'){
        
			// Setup lables
			var fieldCmp = Ext.getCmp(c.id);
			
			
			Ext.fly('label-for-' + c.id).addClassOnOver('x-nifty-field-side-title-over');
			
			Ext.fly('edit-' + c.id).on('click', function(){
				fieldCmp.toggleEdit();
			})
			
			Ext.fly('label-for-' + c.id).on('click', function(){
				fieldCmp.toggleEdit();
			})
		}
	}
	
});

Ext.Container.LAYOUTS['niftyform'] = Nifty.layout.FormLayout;