Shader "Custom/texShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		
	}
	SubShader {
	    
	    Pass{
		Tags {  "RenderQueue"="Transparent"  }

		CGPROGRAM
        #include "UnityCG.cginc"
        #pragma fragment frag
        #pragma vertex vert

		sampler2D _MainTex;
        float4 _MainTex_ST;
        
        float _BorderRange;
        float _BorderRange2;
        
		
		struct a2v{
		    float4 vert : POSITION;
		    float4 texcoord : TEXCOORD0;
		};
		
		struct v2f{
		    float4 pos : SV_POSITION;
		    float2 uv : TEXCOORD0;
		};
		
		v2f vert (a2v a ) {
		    v2f f;
		    f.pos = UnityObjectToClipPos( a.vert  );
		    f.uv = TRANSFORM_TEX( a.texcoord, _MainTex ); //主贴图
            		    
		    return f;
		};
		
		fixed4 frag( v2f i) : SV_Target { 
            fixed4 main = tex2D( _MainTex, i.uv ).rgba; //草地贴图
		    
		    return fixed4( main.rgba);
		};
		
		ENDCG
	}
	}
	FallBack "Diffuse"
	

}
