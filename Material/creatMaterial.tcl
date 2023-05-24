# 创建材料及对应截面属性

namespace eval ::material {
    variable creatElasticMat
    variable filepath;
}

namespace eval ::Mat {
	variable Elastic
	variable Elastic1D
	variable Plastic
}

set ::material::filepath [file dirname [info script]]
source $::material::filepath/CreatMat.tcl

# 线弹性材料:Elastic(名称) [弹性模量(MPa) 泊松比 密度]
set ::Mat::Elastic(Defult) [list 0 0.3]
set ::Mat::Elastic(Peek) [list 572 0.3]
set	::Mat::Elastic(SawBone15) [list 123 0.3]
set ::Mat::Elastic(Ti) [list 114000 0.3]
set ::Mat::Elastic(Steel) [list 220000 0.3]

set ::Mat::Elastic(C_Cor) [list 12000 0.29]
set ::Mat::Elastic(C_Can) [list 450 0.29]
set ::Mat::Elastic(C_EndP) [list 500 0.4]
set ::Mat::Elastic(C_Post) [list 3500 0.29]
set ::Mat::Elastic(C_AF) [list 3.4 0.4]
set ::Mat::Elastic(C_NP) [list 1 0.49]
set ::Mat::Elastic(C_FACET) [list 2 0.3]

set ::Mat::Elastic(T_Cor) [list 12000 0.29]
set ::Mat::Elastic(T_Can) [list 450 0.29]
set ::Mat::Elastic(T_EndP) [list 500 0.4]
set ::Mat::Elastic(T_Post) [list 500 0.4]
set ::Mat::Elastic(T_AF) [list 500 0.4]
set ::Mat::Elastic(T_NP) [list 500 0.4]
set ::Mat::Elastic(T_FACET) [list 500 0.4]

set ::Mat::Elastic(L_Cor) [list 12000 0.29]
set ::Mat::Elastic(L_Can) [list 200 0.29]
set ::Mat::Elastic(L_EndP) [list 1000 0.4]
set ::Mat::Elastic(L_Post) [list 3500 0.25]
set ::Mat::Elastic(L_AF) [list 4.2 0.4]
set ::Mat::Elastic(L_NP) [list 1 0.48]
set ::Mat::Elastic(L_FACET) [list 10 0.4]

# 线弹性材料:Elastic(名称) [弹性模量(MPa) 泊松比 截面积 ?不可压缩 密度]
set ::Mat::Elastic1D(C_TL) [list 17.1 0.4 0.62 1]
set ::Mat::Elastic1D(C_AL) [list 11.4 0.4 0.4 1]
set ::Mat::Elastic1D(C_ALL) [list 30 0.4 0.61 1]
set ::Mat::Elastic1D(C_PLL) [list 20 0.4 0.54 1]
set ::Mat::Elastic1D(C_LF) [list 10 0.4 8.5 1]
set ::Mat::Elastic1D(C_ISL) [list 10 0.4 1.31 1]
set ::Mat::Elastic1D(C_JCL) [list 20 0.4 5.1 1]

set ::Mat::Elastic1D(L_ALL) [list 7.8 0.3 15.0 1]
set ::Mat::Elastic1D(L_PLL) [list 10.0 0.3 2.0 1]
set ::Mat::Elastic1D(L_LF) [list 15.0 0.3 3.0 1]
set ::Mat::Elastic1D(L_ISL) [list 10.0 0.4 1.5 1]
set ::Mat::Elastic1D(L_SSL) [list 10.0 0.4 16.0 1]
set ::Mat::Elastic1D(L_JCL) [list 7.5 0.4 0.3 1]
set ::Mat::Elastic1D(L_ITL) [list 10 0.4 0.2 1]

set ::Mat::Elastic1D(Fibers) [list 400 0.3 0.00015 1]

# 线弹性材料:Elastic(名称) [弹性模量(MPa) 泊松比 屈服强度List 密度]
set ::Mat::Plastic(Porous_Diamond) [list 1985.96 0.3 [list 65.34 0]]
set ::Mat::Plastic(Porous_12hedron) [list 1721.44 0.3 [list 63.16 0]]
set ::Mat::Plastic(Porous_BodyCenter) [list 1221.43 0.3 [list 49.67 0]]

proc creatElasticMat {name} {

	set E [lindex $::Mat::Elastic($name) 0]
	set NU [lindex $::Mat::Elastic($name) 1]
	
	# 设置材料、属性
	createElasticMaterial $name $E $NU
	createPropertiesSolid $name
	puts \t创建线弹性材料：$name\t\t弹性模量：$E\t\t泊松比：$NU
	}
	
proc creat1DElasticMat {name} {

	set E [lindex $::Mat::Elastic1D($name) 0]
	set NU [lindex $::Mat::Elastic1D($name) 1]
	set AREA [lindex $::Mat::Elastic1D($name) 2]
	set noCompress [lindex $::Mat::Elastic1D($name) 3]
	
	# 设置材料、属性
	createElasticMaterial $name $E $NU $noCompress
	createPropertiesSolid1D $name $AREA
	puts \t创建线弹性材料：$name\t\t弹性模量：$E\t\t泊松比：$NU\t\t横截面积：$AREA
	}
	
proc creatPlasticMat {name} {

	set E [lindex $::Mat::Plastic($name) 0]
	set NU [lindex $::Mat::Plastic($name) 1]
	set YS [lindex $::Mat::Plastic($name) 2]
	
	# 设置材料、属性
	createPlasticMaterial $name $E $NU $YS
	createPropertiesSolid $name
	puts \t创建弹塑性材料：$name\t\t弹性模量：$E\t\t泊松比：$NU\t\t屈服强度：[lindex $YS 0]
	}