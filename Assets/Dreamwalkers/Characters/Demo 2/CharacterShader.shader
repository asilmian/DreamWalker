// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Dreamwalkers/CharacterShader"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _OutlineWidth("Outline Width", Float) = 0.1
        _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

        Pass // left outline
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

            v2f vert (appdata v)
            {
                float outlineWidth = _OutlineWidth;
                float3 outlineVertex = float3(v.vertex.x + outlineWidth, v.vertex.yz);
                
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

        Pass // right outline
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
                float3 outlineVertex = float3(v.vertex.x - outlineWidth, v.vertex.yz);

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

        Pass // up outline
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
                float3 outlineVertex = float3(v.vertex.x, v.vertex.y - outlineWidth, v.vertex.z);

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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
