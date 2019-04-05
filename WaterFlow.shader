Shader "Custom/WaterFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map",2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range(0,2)) = 1
		_ScrollXspeed("Scroll X Speed",Range(0,10)) = 2
		_ScrollYspeed("Scroll Y Speed",Range(0,10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _NormalTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_NormalTex;
        };

        float4 _Color;
		float _NormalIntensity;
		fixed _ScrollXspeed;
		fixed _ScrollYspeed;

				
		float2 TextureNomral(float2 ScrollVal)
		{
			float2 scroll = ScrollVal;
			float xScrollNormal = _ScrollXspeed * _Time;
			float yScrollNormal = _ScrollYspeed * _Time;

			scroll += fixed2(xScrollNormal, yScrollNormal);

			return scroll;
		}
		

        void surf (Input IN, inout SurfaceOutput o)
        {
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, TextureNomral(IN.uv_NormalTex))).rgb;//scrolledNormal
			normalMap.x *= _NormalIntensity;
			normalMap.y *= _NormalIntensity;
			o.Normal = normalize(normalMap);

            fixed4 c = tex2D (_MainTex, TextureNomral(IN.uv_MainTex)) * _Color;//scrollTex
            o.Albedo = c.rgb;
        }

		/*
		//First Version
		void surf (Input IN, inout SurfaceOutput o)
        {

			float2 scrolledNormal = IN.uv_NormalTex;
		
			float xScrollNormal = _ScrollXspeed * _Time;
			float yScrollNormal = _ScrollYspeed * _Time;

			scrolledNormal += fixed2(xScrollNormal, yScrollNormal);

			float3 normalMap = UnpackNormal(tex2D(_NormalTex, scrolledNormal)).rgb;
			normalMap.x *= _NormalIntensity;
			normalMap.y *= _NormalIntensity;
			o.Normal = normalize(normalMap);

			float2 scrollTex = IN.uv_MainTex;

			scrollTex += fixed2(xScrollNormal, yScrollNormal);

            fixed4 c = tex2D (_MainTex, scrollTex) * _Color;
            o.Albedo = c.rgb;
        }
		*/


        ENDCG
    }
    FallBack "Diffuse"
}
