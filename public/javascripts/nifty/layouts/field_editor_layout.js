
Nifty.layout.FieldEditorLayout = Ext.extend(Ext.layout.FormLayout, {
    /**
     * @cfg {String} labelStyle
     * A CSS style specification string to add to each field label in this layout (defaults to '').
     */
    /**
     * @cfg {String} elementStyle
     * A CSS style specification string to add to each field element in this layout (defaults to '').
     */
    /**
     * @cfg {String} labelSeparator
     * The standard separator to display after the text of each form label (defaults to a colon ':').  To turn off
     * separators for all fields in this layout by default specify empty string '' (if the labelSeparator value is
     * explicitly set at the field level, those will still be displayed).
     */
    labelSeparator : '',

    // private
    getAnchorViewSize : function(ct, target){
        return ct.el.getStyleSize();
    },

    // private
    setContainer : function(ct){
		ct.labelAlign = 'top';
		
            // the default field template used by all form layouts
            var t = new Ext.Template(
                '<div class="x-form-item {5} x-nifty-fieldlet-container" tabIndex="-1">',
                    '<div class="x-form-element" id="x-form-el-{0}" style="{3}"></div>',
                    '<label for="{0}" style="{2}" class="x-form-item-label x-nifty-fieldlet-label">{1}{4}</label>',
                    '<div class="{6}"></div>',
                '</div>'
            );
            t.disableFormats = true;
            t.compile();
            Nifty.layout.FieldEditorLayout.prototype.fieldTpl = t;


        Nifty.layout.FieldEditorLayout.superclass.setContainer.call(this, ct);
    }
});

Ext.Container.LAYOUTS['fieldeditorlayout'] = Nifty.layout.FieldEditorLayout;