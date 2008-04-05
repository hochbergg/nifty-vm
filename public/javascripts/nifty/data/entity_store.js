/*
 * Ext JS Library 2.0.1
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

/**
 * @class Nifty.data.EntityStore
 * @extends Ext.util.Observable
 * The Store class encapsulates a client side cache of {@link Ext.data.Record Record}
 * objects which provide input data for Components such as the {@link Ext.grid.GridPanel GridPanel},
 * the {@link Ext.form.ComboBox ComboBox}, or the {@link Ext.DataView DataView}</p>
 * <p>A Store object uses its {@link #proxy configured} implementation of {@link Ext.data.DataProxy DataProxy}
 * to access a data object unless you call {@link #loadData} directly and pass in your data.</p>
 * <p>A Store object has no knowledge of the format of the data returned by the Proxy.</p>
 * <p>A Store object uses its {@link #reader configured} implementation of {@link Ext.data.DataReader DataReader}
 * to create {@link Ext.data.Record Record} instances from the data object. These Records
 * are cached and made available through accessor functions.</p>
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
         * @param {Ext.data.Record[]} records The Records that were loaded
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
    

    /**
     * Loads the Record cache from the configured Proxy using the configured Reader.
     * <p>If using remote paging, then the first load call must specify the <tt>start</tt>
     * and <tt>limit</tt> properties in the options.params property to establish the initial
     * position within the dataset, and the number of Records to cache on each read from the Proxy.</p>
     * <p><b>It is important to note that for remote data sources, loading is asynchronous,
     * and this call will return before the new data has been loaded. Perform any post-processing
     * in a callback function, or in a "load" event handler.</b></p>
     * @param {Object} options An object containing properties which control loading options:<ul>
     * <li><b>params</b> :Object<p class="sub-desc">An object containing properties to pass as HTTP parameters to a remote data source.</p></li>
     * <li><b>callback</b> : Function<p class="sub-desc">A function to be called after the Records have been loaded. The callback is
     * passed the following arguments:<ul>
     * <li>r : Ext.data.Record[]</li>
     * <li>options: Options object from the load call</li>
     * <li>success: Boolean success indicator</li></ul></p></li>
     * <li><b>scope</b> : Object<p class="sub-desc">Scope with which to call the callback (defaults to the Store object)</p></li>
     * <li><b>add</b> : Boolean<p class="sub-desc">Indicator to append loaded records rather than replace the current cache.</p></li>
     * </ul>
     * @return {Boolean} Whether the load fired (if beforeload failed).
     */
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