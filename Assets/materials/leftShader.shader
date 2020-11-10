Shader "Custom/leftShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BorderTex("_BorderTex", 2D) = "white" {}
		_BorderRange("_BorderRange", Range( 0, 8)) = 0
	}
	SubShader {
	    
	    Pass{
		Tags {  "RenderQueue"="Transparent"  }

		CGPROGRAM
        #include "UnityCG.cginc"
        #pragma fragment frag
        #pragma vertex vert

		sampler2D _MainTex;
        sampler2D _BorderTex;
        float4 _MainTex_ST;
        float4 _BorderTex_ST;
		
		struct a2v{
		    float4 vert : POSITION;
		    float4 texcoord : TEXCOORD0;
		    float4 texcoordBorder : TEXCOORD1;
		};
		
		struct v2f{
		    float4 pos : SV_POSITION;
		    float2 uv : TEXCOORD0;
		    float2 uvBorder : TEXCOORD1;
		};
		
		v2f vert (a2v a ) {
		    v2f f;
		    f.pos = UnityObjectToClipPos( a.vert  );
		    
		    f.uv = TRANSFORM_TEX( a.texcoord, _MainTex );
            
            if( _BorderRange >=8 ){
                
            }
		    f.uvBorder = TRANSFORM_TEX( a.texcoordBorder, _BorderTex);
            float2 uvTemp = float2( 1- f.uvBorder.y, 1- f.uvBorder.x);
		    f.uvBorder = uvTemp;
		    return f;
		};
		
		fixed4 frag( v2f i) : SV_Target {
            fixed4 main = tex2D( _MainTex, i.uv ).rgba;
		    fixed4 border = tex2D( _BorderTex, i.uvBorder).rgba;
		    fixed4 color =  fixed4 (  border );
		    return color;
		};
		
		ENDCG
	}
	}
	FallBack "Diffuse"
}
