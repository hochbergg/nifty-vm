/*
 * Ext JS Library 2.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

/**
 * @class Nifty.widgets.FieldEditor
 * @extends Ext.Component
 * A base editor field that handles displaying/hiding on demand and has some built-in sizing and event handling logic.
 * @constructor
 * Create a new Editor
 * @param {Ext.form.Field} field The Field object (or descendant)
 * @param {Object} config The config object
 */
Nifty.widgets.FieldEditor = function(field, config){
    this.field = field;

    Nifty.widgets.FieldEditor.superclass.constructor.call(this, config);
};

Ext.extend(Nifty.widgets.FieldEditor, Ext.Container, {
    layout: 'fieldeditorlayout',


	startEdit: function(itemIndex){
		// render if not rendered yet
		if(!this.renderd){
			this.applyToMarkup('nifty-field-editor-' + this.field.fieldId);
			this.getEl().setVisibilityMode(Ext.Element.VISIBILITY );
		};
		
		this.currentNode = this.field.getNode(itemIndex);
		this.currentRecord = this.field.getRecord(this.currentNode);
		
		this.currentRecord.beginEdit();
		
		// position the editor
		this.rePosition();
		
		this.setData();
		
		this.setEvents();
		
		this.setFocus();
		
	},
	
	
	rePosition: function(){
		var el = this.getEl();
		el.alignTo(this.currentNode, 'tl-tl',[0,-3]);
		var fieldWidth = this.field.getEl().getWidth(true)
		this.setWidth(fieldWidth);
		el.setVisible(true);
	},
	
	setData: function(){
		for(var k in this.currentRecord.data){
			var fitem = this.find('identifier',k)[0];
			fitem.setValue(this.currentRecord.get(k));
		}
	},
	
	setFocus: function(){
		this.items.first().focus();
	},
	
	setEvents: function(){
		this.focusedItems = {};
		// when leaving the field
		this.items.each(function(item){
			item.on('specialkey', this.specialKey, this);
			item.on('blur', this.onItemBlur, this, {delay: 20});
			item.on('focus', this.onItemFocus, this);
		},this);
	},
	
	unsetEvents: function(){
		delete this.focusedItems;
		this.items.each(function(item){
			item.un('specialkey', this.specialKey, this);
			item.un('blur', this.onItemBlur, this);
			item.un('focus', this.onItemFocus, this);
		},this);	
	},
	
	onItemBlur: function(field){
		if(!this.focusedItems){return;};
		delete this.focusedItems[field.id]
		var focus = false;
		
		for(var k in this.focusedItems){
			focus = true;
		}
		if(!focus){
			this.finishEdit();
		}
	},
	
	onItemFocus: function(field){
		this.focusedItems[field.id] = true;
	},
	
	specialKey: function(field,e){

		if(e.getKey() === Ext.EventObject.ENTER){e.stopEvent();this.finishEdit()};
		if(e.getKey() === Ext.EventObject.ESC){e.stopEvent();this.cancelEdit()};

	},
	
	finishEdit: function(e){
	   for(var k in this.currentRecord.data){
	   		var fitem = this.find('identifier',k)[0];

			if(fitem.getValue() !== this.currentRecord.data[k]){ // if the data has changed
				if(!this.currentRecord.modified){this.currentRecord.modified = {}};
				this.currentRecord.modified[k] = {};
				Ext.apply(this.currentRecord.modified[k], this.currentRecord.data[k]);
				this.currentRecord.data[k] = fitem.getValue();
				this.currentRecord.dirty = true;
			}
	   }
	
		this.currentRecord.endEdit();
		this.hide();
		if(this.currentRecord.dirty){this.markChanged()};
	},
	
	cancelEdit: function(){
		this.currentRecord.cancelEdit();
		this.hide();
	},
	
	hide: function(){
		this.unsetEvents();
		this.el.setVisible(false);
	},
	
	markChanged: function(){
		Ext.fly(this.field.getNode(this.index)).frame('#10DF06',1, {duration: 0.4});
	}
});

Ext.reg('fieldeditor', Nifty.widgets.FieldEditor);