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
							"autoEl":{"tag":"div", cls: 'links', "html":'<a href="#/entities/17454" class="icon-small-2090736770146440206 entity-link">Bobos in Paradise: The New Upper Class and How They Got There</a><br/><a href="#/entities/11794" class="icon-small-8190433569609209457 entity-link">Italica Press</a><br/><a href="#/entities/16186" class="icon-small-18279707579104455630 entity-link">Evelyn Higginbotham</a><br/><a href="#/entities/778" class="icon-small-2090736770146440206 entity-link">Hamburger Hill</a><br/><a href="#/entities/424" class="icon-small-8190433569609209457 entity-link">Lippincott Williams & Wilkins</a><br/><a href="#/entities/2019" class="icon-small-18279707579104455630 entity-link">Sally Perkins</a><br/><a href="#/entities/17199" class="icon-small-2090736770146440206 entity-link">The Encyclopedia of Tibetan Symbols and Motifs</a><br/><a href="#/entities/15864" class="icon-small-2090736770146440206 entity-link">The Golems of Gotham</a><br/><a href="#/entities/13716" class="icon-small-8190433569609209457 entity-link">Mcgraw-Hill (Tx)</a><br/><a href="#/entities/628" class="icon-small-8190433569609209457 entity-link">Palgrave Macmillan</a><br/><a href="#/entities/13361" class="icon-small-18279707579104455630 entity-link">David Kennedy</a><br/><a href="#/entities/1361" class="icon-small-2090736770146440206 entity-link">The Unraveling of Representative Democracy in Venezuela</a><br/><a href="#/entities/2933" class="icon-small-8190433569609209457 entity-link">Zondervan/Youth Specialties</a><br/><a href="#/entities/1571" class="icon-small-2090736770146440206 entity-link">The Complete Illustrated Guide to Joinery</a><br/><a href="#/entities/2367" class="icon-small-8190433569609209457 entity-link">Overlook Hardcover</a><br/><a href="#/entities/5015" class="icon-small-18279707579104455630 entity-link">David Lesch</a><br/><a href="#/entities/617" class="icon-small-18279707579104455630 entity-link">Jim Sterne</a><br/><a href="#/entities/13319" class="icon-small-18279707579104455630 entity-link">Willard Palmer</a><br/><a href="#/entities/14761" class="icon-small-18279707579104455630 entity-link">Virginia Andersen</a><br/><a href="#/entities/18124" class="icon-small-18279707579104455630 entity-link">Lucia Guarnotta</a><br/>'}
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
			instanceFragments: [
				{kind: "18232848293383512778"},
				'<br/>',
				'<span class="small"> -</span>',
				{kind: "2371742841881571621", cls: 'small bold'}
			]
		},
		
		"6610788458132879148":{
			instanceFragments: [
				{kind: "3074575871114379131", cls: 'bold'},
				': ',
				{kind: "2452718722255897411"}
			]
		},
		
		
	}
};