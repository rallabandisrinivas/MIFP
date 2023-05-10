# hypermesh 2021
*createmarkpanel comps 1 "select the comps"
set compsId [hm_getmark comps 1]
if {$compsId == []} { return [] }

set featureMarkId 0
set meshSize [hm_getfloat "mesh Size = " "input string"]
set featureAngle 30
set meshType 1
set projectType 0
set minCheckval 0 
set systemId 0
set creatHoleElem 0
set holePatchSize 0
set gapPatchSize 0

if {$meshSize == 0.0} {
	return
}

proc mesh2WrapMesh {compsId featureMarkId meshSize featureAngle meshType projectType minCheckval systemId creatHoleElem holePatchSize gapPatchSize} {
	*shrinkwrapmesh components 1 $featureMarkId $meshSize $featureAngle $meshType $projectType $minCheckval $systemId $creatHoleElem $holePatchSize $gapPatchSize
}


set compId [lindex $compsId 0]
set compName [hm_entityinfo name comps $compId]
set fullStr "$compName Wrap"
set fullStr [join $fullStr "_"]
*createentity comps includeid=0 name="$fullStr"

mesh2WrapMesh $compsId $featureMarkId $meshSize $featureAngle $meshType $projectType $minCheckval $systemId $creatHoleElem $holePatchSize $gapPatchSize
