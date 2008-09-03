/*
 * Ext JS Library 2.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

/**
 * @class Nifty.data.entityStoreProxy
 * @extends Ext.data.DataProxy
 * An implementation of {@link Ext.data.DataProxy} that reads a data object from a {@link Ext.data.Connection Connection} object
 * configured to reference a certain URL.<br>
 * <p>
 * <b>Note that this class cannot be used to retrieve data from a domain other than the domain
 * from which the running page was served.<br>
 * <p>
 * For cross-domain access to remote data, use a {@link Ext.data.ScriptTagProxy ScriptTagProxy}.</b><br>
 * <p>
 * Be aware that to enable the browser to parse an XML document, the server must set
 * the Content-Type header in the HTTP response to "text/xml".
 * @constructor
 * @param {Object} conn an {@link Ext.data.Connection} object, or options parameter to {@link Ext.Ajax#request}.
 * If an options parameter is passed, the singleton {@link Ext.Ajax} object will be used to make the request.
 */
Nifty.data.entityStoreProxy = function(config){
    Nifty.data.entityStoreProxy.superclass.constructor.call(this);

	this.fieldId = config.fieldId;
};

Ext.extend(Nifty.data.entityStoreProxy, Ext.data.DataProxy, {
  
   
    load : function(params, reader, callback, scope, arg){
        if(this.fireEvent("beforeload", this, params) !== false){

            var  o = {
                params : params || {},
                request: {
                    callback : callback,
                    scope : scope,
                    arg : arg
                },
                reader: reader,
                callback : this.loadResponse,
                scope: this
            };

			// UGLY

	        try {
	            result = o.reader.read(this.getFieldData());
	        }catch(e){
	            this.fireEvent("loadexception", this, o, e);
	            o.request.callback.call(o.request.scope, null, o.request.arg, false);
	            return;
	        }
	        this.fireEvent("load", this, o, o.request.arg);
	        o.request.callback.call(o.request.scope, result, o.request.arg, true);

        }else{
            callback.call(scope||this, null, arg, false);
        }
    },


	getFieldData: function(){
		return Nifty.data.currentStore.fields[this.fieldId];
	}
});