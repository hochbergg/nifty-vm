
/**
 * @class Nifty.simpleReader
 * @extends Ext.data.DataReader
 * Data reader class to create an Array of {@link Ext.data.Record} objects from a JSON response
 * based on mappings in a provided {@link Ext.data.Record} constructor.<br>
 * <p>
 * Example code:
 * <pre><code>
var Employee = Ext.data.Record.create([
    {name: 'firstname'},                  // Map the Record's "firstname" field to the row object's key of the same name
    {name: 'job', mapping: 'occupation'}  // Map the "job" field to the row object's "occupation" key
]);
*/
Nifty.data.simpleReader = function(meta, recordType){
    meta = meta || {};
    Nifty.data.simpleReader.superclass.constructor.call(this, meta, recordType || meta.fields);
};
Ext.extend(Nifty.data.simpleReader, Ext.data.DataReader, {
    /**
     * This JsonReader's metadata as passed to the constructor, or as passed in
     * the last data packet's <b><tt>metaData</tt></b> property.
     * @type Mixed
     * @property meta
     */
    /**
     * This method is only used by a DataProxy which has retrieved data from a remote server.
     * @param {Object} response The XHR object which contains the JSON data in its responseText.
     * @return {Object} data A data block which is used by an Ext.data.Store object as
     * a cache of Ext.data.Records.
     */
    read : function(array){
        return this.readRecords(array);
    },

    /**
     * Create a data block containing Ext.data.Records from a JSON object.
     * @param {Object} o An object which contains an Array of row objects in the property specified
     * in the config as 'root, and optionally a property, specified in the config as 'totalProperty'
     * which contains the total size of the dataset.
     * @return {Object} data A data block which is used by an Ext.data.Store object as
     * a cache of Ext.data.Records.
     */
    readRecords : function(array){
        /**
         * After any data loads, the raw JSON data is available for further custom processing.  If no data is
         * loaded or there is a load exception this property will be undefined.
         * @type Object
         */


        var records = [];
		if(!array){array = []}
		for(var i=0;i<array.length;i++){
			var h = array[i];
			
			for(var k in h){
				if(k !== 'instance'){
					h['f' + k] = h[k];
					delete h[k];
				}
			}
			
			records.push(new this.recordType(h,h.instance));
		}

	    return {
	        success : true,
	        records : records,
	        totalRecords : records.length
	    };
    }
});