// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "shader training/Test_Shader_2"
{
	Properties{
		_MainTex("主贴图",2D) = "white"{}
		_Diffuse("漫反射颜色",Color) = (1.0,1.0,1.0,1.0)
        _Cutoff("_Cutoff",Range(0,1)) = 0.01
	}

	SubShader
	{
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}

		Pass{
			Tags{"LightMode"="ForwardBase"}

Cull Off

			CGPROGRAM

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			#pragma vertex vert
			#pragma fragment frag

            fixed4 _Diffuse;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutoff;

			struct  v2f {
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
                float2 uv : TEXCOORD2;
			};

			v2f vert(appdata_base In)
			{
				v2f OUT;
				OUT.pos = UnityObjectToClipPos(In.vertex);
				OUT.worldNormal = UnityObjectToWorldNormal(In.normal);
				OUT.worldPos = mul(unity_ObjectToWorld,In.vertex);
				OUT.uv = TRANSFORM_TEX(In.texcoord,_MainTex);
				return OUT;
			}

			fixed4 frag(v2f i):SV_Target
			{
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed4 texColor = tex2D(_MainTex,i.uv);

                clip(texColor.a - _Cutoff);

                // fixed3 albedo = texColor.rgb * _Diffuse.rgb;

                // fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                // fixed3 diffuse = _LightColor0.rgb * albedo ;

                // return fixed4(ambient + diffuse,1.0);
				return texColor;
			}
			ENDCG
		}
	}
}
