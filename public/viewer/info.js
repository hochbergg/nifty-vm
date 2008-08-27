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
	schema: 'd1d8ab47557f0f5a',
	pageAddresses: ['search', 'inbox'],
	pages:{	"/":{
				"mainPanel":{
					"title": "Amazonifty!",
					"items":[
						{
							"xtype": "box",
							"autoEl":{"tag":"div", "html":"Welcome!!!"}
						}
					]
				},
				"sidePanel": {
					"title": "SidePanel!",
					"items": [
						{
							"xtype": "newEntityButton"
						}
					]
				}
				
			}	
		},

	elements: {
		"6889382093645507246":{
			instanceLayout: [
				{kind: "2371742841881571621"},
				{xtype: "box", autoEl: {tag: "br"}},
				{kind: "18232848293383512778"}
			]
		}
	}
}