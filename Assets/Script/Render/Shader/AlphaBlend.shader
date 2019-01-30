Shader "shader training/AlphaBlend"{
    Properties{
        _Color("color",Color) = (1.0,1.0,1.0,1.0)
        _MainTex("MainTex",2D) = "white" {}
        _AlphaScale ("Alpha Scale",Range(0,1)) = 1
    }
    SubShader
    {
        Tags{"Queue"="AlphaTest" "RenderType"="TransparentCutout" "IgnoreProjector"="True"}
        //开始深度检查的透明度检查
        Pass{
            Tags{"LightMode"="ForwardBase"}
            ZWrite On
            ColorMask 0
        }

        Pass{
            Tags{"LightMode"="ForwardBase"}

            // Blend SrcFactor DisFactor
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed _AlphaScale;

            #pragma vertex vert
            #pragma fragment frag

            struct v2f{
                float4 pos:SV_POSITION;
                float3 worldPos:TEXCOORD0;
                fixed3 worldNormal:TEXCOORD1;
                fixed2 uv : TEXCOORD2;
            };

            v2f vert(appdata_base i) {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.worldPos = mul(unity_ObjectToWorld,i.vertex);
                o.worldNormal = UnityObjectToWorldNormal(i.normal);
                o.uv = i.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f o) :SV_Target{
                fixed3 worldNormal = normalize(o.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(o.worldPos));

                fixed4 texColor = tex2D(_MainTex,o.uv);
                //环境光的影响
                fixed3 albedo = texColor * _Color;
                fixed3 ambient =  UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.xyz;
                //计算固有色
                fixed3 diffuse = _LightColor0 * albedo * max(0,dot(worldNormal,worldLightDir));

                return fixed4(ambient + diffuse,texColor.a * _AlphaScale);
            }

            ENDCG
        }
    }
    Fallback "Transparent/VertexList"
}