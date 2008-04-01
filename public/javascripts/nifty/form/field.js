

Nifty.form.Field = Ext.extend(Ext.Panel, {
   
    baseCls:'x-nifty-field',
    /**
     * @cfg {String} layout The {@link Ext.Container#layout} to use inside the fieldset (defaults to 'form').
     */
    layout: 'form',

    // private
    onRender : function(ct, position){
        if(!this.el){
            this.el = document.createElement('fieldset');
            this.el.id = this.id;
            this.el.appendChild(document.createElement('legend')).className = 'x-nifty-field-header';
        }

        Nifty.form.Field.superclass.onRender.call(this, ct, position);
    }
    
});

Ext.reg('niftyField', Nifty.form.Field);

