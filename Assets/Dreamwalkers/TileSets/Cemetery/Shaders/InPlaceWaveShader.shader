Shader "Dreamwalkers/StandingWaveFlowShader"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _FlowSpeed("Flow Speed", Float) = 1
        _FlowOscillation("Flow Oscillation", Float) = 1
        _WaveAmplitude("Wave Amplitude", Float) = 1
        _WaveDensity("Wave Density", Float) = 1
        _OutlineWidth("Outline Width", Float) = 0.1
        _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
        _Horizontal("Horizontal", Float) = 1
        _Vertical("Vertical", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass // down outline
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _OutlineWidth;
            float4 _OutlineColor;

            v2f vert(appdata v)
            {
                float outlineWidth = _OutlineWidth;
                float3 outlineVertex = float3(v.vertex.x, v.vertex.y + outlineWidth, v.vertex.z);

                // pass the data to the fragment shader
                v2f o;
                o.vertex = UnityObjectToClipPos(outlineVertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = _OutlineColor.rgb * col.a;
                return col;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float3 stretch(float3 vec, float x, float y)
            {
                float2x2 stretchMatrix = float2x2(x, 0, 0, y);
                return float3(mul(stretchMatrix, vec.xy), vec.z).xyz;
            };

            float modulus(float x, float y)
            {
                return x - y * floor(x / y);
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float _FlowSpeed;
            float _WaveAmplitude;
            float _WaveDensity;
            float _Horizontal;
            float _Vertical;
            float _FlowOscillation;

            fixed4 frag(v2f i) : SV_Target
            {
                // parse the data
                float flowSpeed = _FlowSpeed;
                float waveAmp = _WaveAmplitude;
                float waveDens = _WaveDensity;
                float flowOsc = _FlowOscillation;

                // flow along x and wave along y
                float2 offsetX = float2(sin(_Time[1] * flowOsc) * flowSpeed, sin(i.uv.x * UNITY_PI * 2 * waveDens + _Time[1])* waveAmp);
                float2 offsetY = float2(sin(i.uv.y * UNITY_PI * 2 * waveDens + _Time[1]) * waveAmp, _Time[1] * flowSpeed);
                float2 offset = offsetX * _Horizontal + offsetY * _Vertical;
                
                float2 pos = float2(modulus(offset.x + i.uv.x, 1), modulus(offset.y + i.uv.y, 1));
                
                // output
                float4 o = tex2D(_MainTex, pos);
                return o;
            }
            ENDCG
        }
    }
}
