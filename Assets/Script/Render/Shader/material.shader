// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "shader training/material"
{
	Properties {
		_MainTex("贴图",2D) = "white" {}
		_Color ("贴图的颜色", Color) = (1.0,1.0,1.0,1.0)
		_Diffuse ("漫反射", Color) = (1.0,1.0,1.0,1.0)
		_Specular("高光",Color) = (1.0,1.0,1.0,1.0)
		_Gloss("光泽度",Range(8,255)) = 20
	}
	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Diffuse;
			fixed4	_Specular;
			float _Gloss;

			struct  a2v {
				float4 vertex :POSITION;
				float3 normal :NORMAL;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 worldNormal : TEXCOORD0;
				fixed3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			#include "Lighting.cginc"

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal) ;//normalize(mul(v.normal,(fixed3x3)unity_WorldToObject));
				o.worldPos = mul(v.vertex,unity_ObjectToWorld).xyz;
				o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));


				fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse =  albedo * _LightColor0 * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir));
				fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));

				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLightDir + viewDir);

				// fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(viewDir,reflectDir)),_Gloss) ;
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal,halfDir)) ,_Gloss) ;
				return  fixed4(diffuse + ambient + specular,1.0);
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
