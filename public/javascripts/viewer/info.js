/*
* Nifty.viewerInfo
*
*	schema: <SchemaGUID>
*	pageAddresses: [<PageAddress>,...]
*	page: {mainOptions: {}, sideOptions:{}, dependent: [<ElementGUID>,...]}
*	elements: {'<ElementGUID>': {options: <{ElementOptions}>, dependent: [<ElementGUID>,...]}}
*
*/
var Nifty = {};

Nifty.viewerInfo = {
	schema: 'bc3014604dac012bad310014512145e8',
	pageAddresses: ['/','search', 'inbox'],
	pages:{	"/":{
				"mainPanel":{
					"title": "Welcome!",
					"items":[
						{
							"xtype": "box",
							"autoEl":{"tag":"div", "html":"Welcome!!!"}
						}
					]
				},
				
			}	
		},

	elements: {}
}