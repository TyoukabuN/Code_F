Shader "shader training/Test_Shader_2"
{
	Properties{
		_Diffuse("固有色",Color) = (1.0,1.0,1.0,1.0)
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Diffuse;

			struct a2v {
				float4 vertex:POSITION;
				fixed3 normal :NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				SHADOW_COORDS(2)
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
			 	TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f o):SV_Target
			{
				fixed3 worldNormal = normalize(o.worldNormal) ;
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse = _Diffuse.rgb * _LightColor0.rgb  *  max(0,dot(worldNormal,worldLightDir));
				fixed shadow = SHADOW_ATTENUATION(o);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				return fixed4(ambient + diffuse * shadow,1.0)  ;
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
