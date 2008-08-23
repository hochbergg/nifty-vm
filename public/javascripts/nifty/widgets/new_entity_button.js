
Nifty.widgets.newEntityButton = Ext.extend(Ext.Button,{
	text: 'Create New',
	
	initComponent: function(){
		var actions = [];

		Ext.each(Nifty.schema.loaded.entities, function(kind){
			actions.push({
				text: kind.name,
				iconCls: 'small-entity-' + kind.id,
				handler: function(){
					Nifty.Router.go('#/entities/new/' + kind.id);
				}
			})
		});
		
		this.menu = actions;
		
		Nifty.widgets.newEntityButton.superclass.initComponent.call(this, arguments);		
	}
});

Ext.reg('newEntityButton', Nifty.widgets.newEntityButton);