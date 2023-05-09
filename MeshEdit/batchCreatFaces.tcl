*createmarkpanel comps 1 "select the comps"
set compsId [hm_getmark comps 1]
foreach compId $compsId {
	set compName [hm_entityinfo name comps $compId]
	set elemsID [hm_elemlist id $compName]
	*createmark elements 1 $elemsID
	*findfaces elements 1
	set newCompId [hm_entityinfo maxid comps]
	set newCompName [hm_entityinfo name comps $newCompId]
	set newElemsID [hm_elemlist id $newCompName]
	*createmark elements 1 $newElemsID
	*movemark elements 1 $compName
	*createmark components 1 $newCompName
	*deletemark components 1
 } 