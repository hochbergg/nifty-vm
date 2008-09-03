/*
*	Simple Fieldset for nifty
*
*
*/ 


Nifty.widgets.formGroup = Ext.extend(Ext.Panel, {
	collapsible:true,
	animCollapse: false,
	titleCollapse:true,
	hideCollapseTool: true,
	baseCls:'nifty-form-group',
	layout: 'form'
});
Ext.reg('formgroup', Nifty.widgets.formGroup);