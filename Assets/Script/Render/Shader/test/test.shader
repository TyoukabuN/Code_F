Shader "shader training/shader 101" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CutOff("Alpha CutoOff Threshold",Range(0,1)) = 0.01
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0,1)) = 1
		_equrt("_equrt", Range(0,1)) = 1
	}
	SubShader {
		Tags {
			"Queue"="Transparent"
			"PreviewType" = "Plane"
			}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM


			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
			// #pragma target 3.0

			fixed4 _Color;
			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _DisplaceTex;
			float _CutOff;
			float _Magnitude;

			struct a2v{
				fixed4 vertex : POSITION;
				fixed2 texcoord : TEXCOORD0;
			};

			struct v2f{
				// fixed4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvo : TEXCOORD1;
			};

			v2f vert(a2v v,out fixed4 outpos : SV_POSITION)
			{
				v2f o;
				// o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uvo = v.texcoord;
				outpos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float _equrt;

			fixed4 frag(v2f i,UNITY_VPOS_TYPE screenPos : VPOS):SV_Target
			{
				screenPos.xy = floor(screenPos.xy * _equrt) * 0.5;
                float checker = -frac(screenPos.r + screenPos.g);

                clip(checker);

				float2 disp = tex2D(_DisplaceTex, i.uv).xy;

				disp = ((disp * 2) - 1) * _Magnitude;//_CosTime.w;//_Magnitude ;//(0.05*(cos(4 *1)+1))

				fixed4 texColor = tex2D(_MainTex,i.uv + disp);

				fixed3 albedo = texColor * _Color.rgb;

				float lum = albedo.r * 0.3 + albedo.g * 0.59 + albedo.b * 0.11;

				return fixed4(albedo,texColor.a);

			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}
