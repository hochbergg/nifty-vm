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
							"autoEl":{"tag":"div", "html":"<h3> What is Amazonifty? </h3><p> a simple sample for the nifty-vm system</p>"}
						},
						{
							"xtype": "box",
							"autoEl":{"tag":"br"}
						},
						{
							"xtype": "box",
							"autoEl":{"tag":"div", "html":"<h3> Sample Entities </h3><p> Here are some sample entities for checking the system:</p><br/>"}
						},
						{
							"xtype": "box",
							"autoEl":{"tag":"div", cls: 'links', "html":'<a href="#/entities/b3f454c70a7fc47" class="icon-small-2090736770146440206 entity-link">Test</a>'}
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
		"5f9c00833dad6aae":{
			instanceFragments: [
				{kind: "fd0816ebcab622ca"},
				'<br/>',
				'<span class="small"> -</span>',
				{kind: "20ea1f8c74ed3125", cls: 'small bold'}
			]
		},
		
		"5bbe3d13c443372c":{
			instanceFragments: [
				{kind: "2aab167708c27f7b", cls: 'bold'},
				': ',
				{kind: "2209ceaece034343"}
			]
		},
		
		"20ea1f8c74ed3125":{anchor: '99%'},
		"fd0816ebcab622ca":{anchor: '99%'}
		
		
		
		
	}
};