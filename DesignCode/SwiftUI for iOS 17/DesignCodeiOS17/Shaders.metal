//
//  Shaders.metal
//  DesignCodeiOS17
//
//  Created by MK on 10/20/24.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4
angledFill(float2 position, float width, float angle, half4 color)
{
	float pMagnitude = sqrt(position.x * position.x + position.y * position.y);
	float pAngle = angle +
		(position.x == 0.0f ? (M_PI_F / 2.0f) : atan(position.y / position.x));
	float rotatedX = pMagnitude * cos(pAngle);
	float rotatedY = pMagnitude * sin(pAngle);
	return (color + color * fmod(abs(rotatedX + rotatedY), width) / width) / 2;
}
