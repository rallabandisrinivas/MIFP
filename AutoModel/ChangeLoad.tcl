# 设置载荷
namespace eval ::Test {
	variable Compress [*loadsupdatecurve 1 1 1 1 0 0 -1 0 0 0 1 165 0 0 1 0 0 0 0 0 0 0 0]
	variable Shear [*loadsupdatecurve 1 1 1 1 0.707106781 0 -0.707106781 0 0 0 1 155.56349 0 0 1 0 0 0 0 0 0 0 0]
	variable Torque [*loadsupdatecurve 1 1 1 1 0 0 -1 0 0 0 1 110 0 0 1 0 0 0 0 0 0 0 0]
	}

# Compress
*currentcollector loadcols "Load"
*createmark loads 1 1
*loadsupdatecurve 1 1 1 1 0 0 -1 0 0 0 1 165 0 0 1 0 0 0 0 0 0 0 0

# Shear
*currentcollector loadcols "Load"
*createmark loads 1 1
*loadsupdatecurve 1 1 1 1 0.707106781 0 -0.707106781 0 0 0 1 155.56349 0 0 1 0 0 0 0 0 0 0 0

# Torque
*currentcollector loadcols "Load"
*createmark loads 1 1
*loadsupdatecurve 1 1 1 1 0 0 -1 0 0 0 1 110 0 0 1 0 0 0 0 0 0 0 0

# Compress:110
*currentcollector loadcols "Load"
*createmark loads 1 1
*loadsupdatecurve 1 1 1 1 0 0 -1 0 0 0 1 110 0 0 1 0 0 0 0 0 0 0 0