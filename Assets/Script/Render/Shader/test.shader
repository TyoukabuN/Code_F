// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "shader training/Test_Shader_1"
{
	Properties{
		_MainTex("主贴图",2D) = "white"{}
		_Color ("贴图的颜色", Color) = (1.0,1.0,1.0,1.0)
		_Diffuse("漫反射颜色",Color) = (1.0,1.0,1.0,1.0)
		_BumpTex("法线贴图",2D) = "bump" {}
		_BumpScale("法线程度", Float) = 1.0
		_Specular("高光颜色",Color) = (1.0,1.0,1.0,1.0)
		_Gloss("光泽度",Range(8.0,256)) = 20

		_RimColor("边缘发光颜色",Color) = (0.5,0.5,0.5,1)
		_RimPower("边缘发光强度",Range(0.0,36)) = 0.1
		_RimIntensity("边缘发光强度",Range(0.0,100)) = 30
	}
	SubShader{

		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#include "Lighting.cginc"

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadercaster

			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _BumpTex;
			fixed4 _BumpTex_ST;
			float _BumpScale;
			fixed4 _Color;
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			fixed4 _RimColor;
			float	_RimPower;
			float _RimIntensity;

			struct a2v {
				float4 vertex :POSITION;
				fixed3 normal : NORMAL;
				fixed3 texcoord : TEXCOORD0;
				float4 tangent : TANGENT;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				fixed3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

				o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord,_BumpTex);

				//unity build-in function
				// o.uv = TRANSFORM_TEX(v.texcoord,_MainTex)

				o.TtoW0 = fixed4(worldTangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
				o.TtoW1 = fixed4(worldTangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
				o.TtoW2 = fixed4(worldTangent.z,worldBinormal.z,worldNormal.z,worldPos.z);
				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				fixed3 worldNormal = normalize(fixed3(i.TtoW0.z,i.TtoW1.z,i.TtoW2.z));
				float3 worldPos = float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

				//tangent
				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpTex,i.uv.zw));
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));
				tangentNormal = normalize(half3(dot(i.TtoW0.xyz,tangentNormal),dot(i.TtoW1.xyz,tangentNormal),dot(i.TtoW2.xyz,tangentNormal)));

				fixed3 albedo = tex2D(_MainTex,i.uv.xy) * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = albedo * _LightColor0 * _Diffuse.rgb * max(0,dot(tangentNormal,lightDir));

				fixed3 halfDir = normalize(lightDir + viewDir);

				half emission = 1 - saturate(dot(worldNormal,viewDir));

				fixed4 emissionColor =  _RimColor * pow(emission,_RimPower) * _RimIntensity;

				fixed3 specular = _LightColor0.rgb * _Specular.rgb *  pow(max(0,dot(tangentNormal,halfDir)),_Gloss);

				return fixed4(ambient + diffuse + specular,1.0) + emissionColor;
			}

			ENDCG
		}

	}

	Fallback "Diffuse"
}
