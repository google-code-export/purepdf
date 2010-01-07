
#include <stdlib.h>
#include <stdio.h>
#include "AS3.h"

AS3_Val byte(void* self, AS3_Val args )
{
	int value = AS3_IntValue( args );
	AS3_Release(args);

	return AS3_Int((char)value);
}


AS3_Val floatToRawIntBits(void* self, AS3_Val args)
{
	float value = AS3_NumberValue( args );
	AS3_Release(args);
	
	union {
		int i;
	   float f;
	} u;

	u.f = (float)value;

	return AS3_Int( u.i );
}

AS3_Val intBitsToFloat(void* self, AS3_Val args)
{
	int value = AS3_IntValue(args);
	AS3_Release(args);
    union {
        int i;
        float f;
    } u;
    u.i = (long)value;


    return AS3_Number(u.f);
}


int main()
{

	AS3_Val byteMethod 					= AS3_Function( NULL, byte );
	AS3_Val floatToRawIntBitsMethod	= AS3_Function( NULL, floatToRawIntBits );
	AS3_Val intBitsToFloatMethod		= AS3_Function( NULL, intBitsToFloat );

	AS3_Val result = AS3_Object( "byte: AS3ValType, floatToRawIntBits: AS3ValType, intBitsToFloat: AS3ValType", 
		byteMethod, 
		floatToRawIntBitsMethod, 
		intBitsToFloatMethod
	);

	AS3_Release( byteMethod );
	AS3_Release( floatToRawIntBitsMethod );
	AS3_Release( intBitsToFloatMethod );

	AS3_LibInit( result );

	return 0;
}
