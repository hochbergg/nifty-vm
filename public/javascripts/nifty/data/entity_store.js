
/**
 * @class Nifty.data.EntityStore
 * @extends Ext.util.Observable
 * @constructor
 * Creates a new Store.
 * @param {Object} config A config object containing the objects needed for the Store to access data,
 * and read the data into Records.
 */
Nifty.data.EntityStore = function(config){

    Ext.apply(this, config);

    this.addEvents(
        /**
         * @event beforeload
         * Fires before a request is made for a new data object.  If the beforeload handler returns false
         * the load action will be canceled.
         * @param {Store} this
         * @param {Object} options The loading options that were specified (see {@link #load} for details)
         */
        'beforeload',
        /**
         * @event load
         * Fires after a new set of Records has been loaded.
         * @param {Store} this
         * @param {Object} options The loading options that were specified (see {@link #load} for details)
         */
        'load',
        /**
         * @event loadexception
         * Fires if an exception occurs in the Proxy during loading.
         * Called with the signature of the Proxy's "loadexception" event.
         */
        'loadexception'
    );


	
    Nifty.data.EntityStore.superclass.constructor.call(this);

};
Ext.extend(Nifty.data.EntityStore, Ext.util.Observable, {
    

    load : function(options){
        options = options || {};
        if(this.fireEvent("beforeload", this, options) !== false){

			// Ajax Request
			Ext.Ajax.request({
			       url: '/entities/' + options['id'] + '.js',
			       success: this.loadRecords,
				   failure: this.failedLoading,
			       method: 'get',
				   scope: this
     	     });


            return true;
        } else {
          return false;
        }
    },

	
	failedLoading: function(options){
		console.warn('failed loading: ' + options['id']);
		this.fireEvent("loadexception", this, options);
	},
	
    // private
    // Called as a callback by the Reader during a load operation.
    loadRecords : function(response,options){
		this.data = Ext.util.JSON.decode(response.responseText)
		
		this.fetchFieldlets();
		
        this.fireEvent("load", this, this.data,options);
    },

	fetchFieldlets: function(){
		this.fields = {}; //clear the fields
		this.fieldlets = this.data['fieldlets'];
		
		for(i=0;i<this.fieldlets.length;i++){
			fieldlet = this.fieldlets[i];
			
			if (this.fields[fieldlet.field_id] == null)
				this.fields[fieldlet.field_id] = {};
			
			if (this.fields[fieldlet.field_id][fieldlet.instance_id] == null)
				this.fields[fieldlet.field_id][fieldlet.instance_id] = {};
			
			
			this.fields[fieldlet.field_id][fieldlet.instance_id][fieldlet.type] = fieldlet;	
		}
	}

});