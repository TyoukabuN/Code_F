Shader "Makin/Normal Mapping"
{
    Properties{
        _Color ("Color",Color) = (1.0,1.0,1.0,1.0)
        _MainTex ("MainTex",2D) = "white" {}
        _NormalTex ("NormalMap",2D) = "bump" {}
        _NormalIns ("NormalIns",float) = 0.5

        _emissionColor("emissionColor",Color) = (1.0,1.0,1.0,1.0)
		_RimPower("边缘发光强度",Range(0.0,36)) = 0.1
		_RimIntensity("边缘发光强度",Range(0.0,100)) = 3
    }

    SubShader
    {
        Tags{ "Queue"="Transparent"
        "RenderType"="Transparent"
        }

        Cull off

        Pass{
            Tags{ "LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
            };

            struct v2f{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float3 tangentSpaceLight : TEXCOORD2;
                float3 worldNormal:TEXCOORD3;
                float3 worldPos : TEXCOORD4;
            };

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NormalTex;
            float4 _NormalTex_ST;
            float _NormalIns;

            fixed4 _emissionColor;
            float _RimPower;
            float _RimIntensity;

            v2f vert(a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv,_NormalTex);

                o.worldPos = mul(unity_ObjectToWorld,v.vertex);

                float3 normal = UnityObjectToWorldNormal(v.normal);
                float3 tangent = UnityObjectToWorldNormal(v.tangent.xyz);
                float3 bitangent = cross(normal,tangent) * v.tangent.w;
                float3x3 rotation = float3x3(tangent,bitangent,normal);

                o.worldNormal = normalize(normal);
                // TANGENT_SPACE_ROTATION;
				o.tangentSpaceLight = mul(rotation,_WorldSpaceLightPos0);

                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
				float3 tangentLightDir = normalize(_WorldSpaceLightPos0.xyz);


				float3 tangentNormal = UnpackNormal(tex2D(_NormalTex, i.uv2));
                tangentNormal.xy *=  _NormalIns;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                float normal = max(0,dot(tangentNormal, i.tangentSpaceLight) );

                fixed3 albedo = tex2D(_MainTex,i.uv2) * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = albedo * _LightColor0 * normal;

                float3 tangentViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));


                float4 emission = 1 - saturate(dot(tangentNormal, tangentViewDir));
                float4 emissionColor  =  _emissionColor * pow(emission,_RimPower) * _RimIntensity;

				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);

				fixed3 specular = _LightColor0.rgb * fixed3(1,1,1) * pow(max(0,dot(tangentNormal,halfDir)) ,1) ;
				return  fixed4(ambient + diffuse ,1) + emissionColor;
            }

            ENDCG
        }
    }
}