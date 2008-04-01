/*
* Nifty Data Classes. 
* Includes entity data stores
*/


/* Record */
Nifty.Data.Fieldlet = function(){
	var record = Ext.data.Record.create([
    	{name: 'id', mapping: 'id', type: 'int'},
    	{name: 'value', mapping: 'value'},
    	{name: 'instance_id', mapping: 'instance_id'},
    	{name: 'type', mapping: 'type'}])
	
	var reader = new Ext.data.JsonReader({id: "id"}, record) 
	return {
		getReader: function(){
			return reader;
		}
	}
}();




