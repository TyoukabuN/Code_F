    Shader "shader training/ShadowCast"
{
    Properties{
        _Diffuse("固有色",Color) = (1.0,1.0,1.0,1.0)
        _Specular("高光色",Color) = (1.0,1.0,1.0,1.0)
        _Gloss("光泽度",Range(0,256)) = 8
    }

    SubShader
    {
        Pass{
            Tags{"LightMode"="ForwardBase"}

            CGPROGRAM
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment fragment

            fixed4 _Diffuse;
            fixed4 _Specular;
            fixed4 _Gloss;

            struct OUT {
                V2F_SHADOW_CASTER;
            };

            OUT vert(appdata_base v){
                OUT o;
                TRANSFER_SHADOW_CASTER(o);
                return o;
            }

            fixed4 fragment(OUT o) : SV_Target{
                 SHADOW_CASTER_FRAGMENT(o);
            }

            ENDCG
        }
    }
}