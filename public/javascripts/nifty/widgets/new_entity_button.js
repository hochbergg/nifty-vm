Nifty.entities.actions.newItems = function(){
	var actions = [];
	
	Ext.each(Nifty.entities.kinds, function(kind){
		actions.push({
			text: kind.singleName,
			iconCls: 'small-entity' + kind.id,
			handler: function(){
				Nifty.Router.go('#/entities/new/' + kind.id);
			}
		})
	});
	
	return actions;
}();

Nifty.entities.newEntityButton = {
	xtype: 'button', 
	text: 'Create New',
	menu: {
		xtype: 'menu',
		items: 	Nifty.entities.actions.newItems
	}
}
