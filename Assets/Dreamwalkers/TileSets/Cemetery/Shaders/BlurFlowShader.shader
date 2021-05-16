Shader "Dreamwalkers/BlurFlowShader"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _BlurRadiusInner("Blur Radius Inner", Float) = 0.1
        _InnerBlurIntensity("Inner Blur Intensity", Float) = 0.5
        _BlurRadiusOuter("Blur Radius Outer", Float) = 0.1
        _OuterBlurIntensity("Outer Blur Intensity", Float) = 0.25

        _NoiseMap("Texture", 2D) = "white" {}
        _NoiseFactor("Noise Factor", Float) = 1

        _FlowSpeedHorizontal("Flow Speed Horizontal", Float) = 2
        _FlowSpeedVertical("Flow Speed Vertical", Float) = 2

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

            float _BlurRadiusInner;
            float _InnerBlurIntensity;
            float _BlurRadiusOuter;
            float _OuterBlurIntensity;
            sampler2D _NoiseMap;
            float _NoiseFactor;
            float _FlowSpeedHorizontal;
            float _FlowSpeedVertical;

            fixed4 frag(v2f i) : SV_Target
            {
                // parse the data
                float blurRadiusInner = _BlurRadiusInner;
                float innerBlurIntensity = _InnerBlurIntensity;
                float blurRadiusOuter = _BlurRadiusOuter;
                float outerBlurIntensity = _OuterBlurIntensity;
                float noiseFactor = _NoiseFactor;
                float xFlowSpeed = _FlowSpeedHorizontal;
                float yFlowSpeed = _FlowSpeedVertical;

                // offset by the noisemap value
                float noiseOffset = modulus(_Time[1] * noiseFactor, 1);
                float2 offset = tex2D(_NoiseMap, float2( modulus( (i.uv.x * noiseFactor + noiseOffset)* xFlowSpeed, 1 ), modulus( (i.uv.y * noiseFactor + noiseOffset)* yFlowSpeed, 1) ) ).xy;
                //float2 offset = float2(tex2D(_NoiseMap, float2(sin(_Time[1] * 0.01), 0)).r, tex2D(_NoiseMap, float2(0, sin(_Time[1] * 0.01))).r ) / 20;
                float2 pos = float2(modulus(offset.x + i.uv.x, 1), modulus(offset.y + i.uv.y, 1));

                // the blurring parameters
                float3 a = tex2D(_MainTex, pos).rgb;
                float3 b = tex2D(_MainTex, pos + float2(blurRadiusInner, blurRadiusInner)).rgb;
                float3 c = tex2D(_MainTex, pos + float2(blurRadiusInner, -blurRadiusInner)).rgb;
                float3 d = tex2D(_MainTex, pos + float2(-blurRadiusInner, blurRadiusInner)).rgb;
                float3 e = tex2D(_MainTex, pos + float2(-blurRadiusInner, -blurRadiusInner)).rgb;
                float3 f = tex2D(_MainTex, pos + float2(blurRadiusOuter, blurRadiusOuter)).rgb;
                float3 g = tex2D(_MainTex, pos + float2(blurRadiusOuter, -blurRadiusOuter)).rgb;
                float3 h = tex2D(_MainTex, pos + float2(-blurRadiusOuter, blurRadiusOuter)).rgb;
                float3 j = tex2D(_MainTex, pos + float2(-blurRadiusOuter, -blurRadiusOuter)).rgb;
                float3 col = (a + (b + c + d + e) * innerBlurIntensity * 0.25 + (f + g + h + j) * outerBlurIntensity * 0.25) / (1 + innerBlurIntensity + outerBlurIntensity);

                // output
                float4 o = float4(col, 1);
                return o;
            }
            ENDCG
        }
    }
}
