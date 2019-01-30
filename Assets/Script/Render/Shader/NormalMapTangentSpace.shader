// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "shader training/NormalMapTangentSpace"
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
				// fixed3 worldNormal : TEXCOORD0;
				// fixed3 worldPos : TEXCOORD1;
				float4 uv : TEXCOORD0;
				float3 lightDir :TEXCOORD1;
				float3 viewDir :TEXCOORD2;
			};

			#include "Lighting.cginc"

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				// float3 binormal = cross(normalize(v.normal),normalize(v.tangent.xyz)) * v.tangent.w;
				//float3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);
				//unity内建的求旋转矩阵的方法
				TANGENT_SPACE_ROTATION;
				o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;

				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				// fixed3 worldNormal = normalize(i.worldNormal);
				// fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				fixed4 packedNormal = tex2D(_BumpMap,i.uv.zw);
				fixed3 tangentNormal;

				tangentNormal = UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));



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
