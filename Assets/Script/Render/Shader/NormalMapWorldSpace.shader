// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "shader training/NormalMapWorldSpace"
{
	Properties {
		_MainTex("贴图",2D) = "white" {}
		_Color ("贴图的颜色", Color) = (1.0,1.0,1.0,1.0)
		_BumpMap ("发线的颜色", 2D) = "bump"{}
		_BumpScale ("发线贴图的影响程度", Float) = 1.0
		_Diffuse ("漫反射", Color) = (1.0,1.0,1.0,1.0)
		_Specular("高光",Color) = (1.0,1.0,1.0,1.0)
		_Gloss("光泽度",Range(8,255)) = 20

		_RimColor("边缘发光颜色",Color) = (0.5,0.5,0.5,1)
		_RimPower("边缘发光强度",Range(0.0,36)) = 0.1
		_RimIntensity("边缘发光强度",Range(0.0,100)) = 3
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
			sampler2D _BumpMap;
			fixed4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Diffuse;
			fixed4	_Specular;
			float _Gloss;

			fixed4 _RimColor;
			float	_RimPower;
			float _RimIntensity;

			struct  a2v {
				float4 vertex :POSITION;
				float3 normal :NORMAL;
				float4 texcoord:TEXCOORD0;
				float4 tangent : TANGENT;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
			};

			#include "Lighting.cginc"

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				fixed3 worldNormal = mul(unity_ObjectToWorld,v.normal);//UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = mul(unity_ObjectToWorld,v.tangent.xyz);//UnityObjectToWorldDir(v.tangent.xyz);
				fixed3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

				o.TtoW0 = fixed4(worldTangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
				o.TtoW1 = fixed4(worldTangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
				o.TtoW2 = fixed4(worldTangent.z,worldBinormal.z,worldNormal.z,worldPos.z);
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				float3 worldPos = float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);

				// float3 tangentLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				float3 tangentLightDir = normalize(_WorldSpaceLightPos0.xyz);
				// float3 tangentViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float3 tangentViewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

				// fixed3 tangentLightDir = normalize(i.lightDir);
				// fixed3 tangentViewDir = normalize(i.viewDir);

				// fixed4 packedNormal = tex2D(_BumpMap,i.uv.zw);
				// fixed3 tangentNormal;

				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap,i.uv.zw));
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));
				tangentNormal = normalize(half3(dot(i.TtoW0.xyz,tangentNormal),dot(i.TtoW1.xyz,tangentNormal),dot(i.TtoW2.xyz,tangentNormal)));


				fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse =  albedo * _LightColor0 * _Diffuse.rgb * max(0,dot(tangentNormal,tangentLightDir));//saturate(dot(worldNormal,worldLightDir));
				// fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));

				// fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);

				//边缘发光强度
				half emission = 1 - saturate(dot(tangentNormal,tangentViewDir));
				//计算颜色
				fixed4 emissionColor = _RimColor * pow(emission,_RimPower) * _RimIntensity;

				// fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(viewDir,reflectDir)),_Gloss) ;
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(tangentNormal,halfDir)) ,_Gloss) ;
				return  fixed4(diffuse + ambient + specular,1.0) + emissionColor;
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
