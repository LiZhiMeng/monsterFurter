Shader "Custom/BorderShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BorderTex("_BorderTex", 2D) = "white" {}
		//_BorderTex2("_BorderTex2", 2D) = "white" {}
		_BorderRange("边界一", Range( 0, 4)) = 0
		_BorderRange2("边界二", Range( 0,4)) = 0
		_SideAlphaControl("透明边控制", Range( 0,1)) = 0.18
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
        //sampler2D _BorderTex2;
        float4 _MainTex_ST;
        float4 _BorderTex_ST;
        //float4 _BorderTex2_ST;
        
        float _BorderRange;
        float _BorderRange2;
        float _SideAlphaControl;
		
		struct a2v{
		    float4 vert : POSITION;
		    float4 texcoord : TEXCOORD0;
		    float4 texcoordBorder : TEXCOORD1;
		    float4 texcoordBorder2 : TEXCOORD2;
		};
		
		struct v2f{
		    float4 pos : SV_POSITION;
		    float2 uv : TEXCOORD0;
		    float2 uvBorder : TEXCOORD1;
		    float2 uvBorder2 : TEXCOORD2;
		};
		
		v2f vert (a2v a ) {
		    v2f f;
		    f.pos = UnityObjectToClipPos( a.vert  );
		    f.uv = TRANSFORM_TEX( a.texcoord, _MainTex ); //主贴图
            
            //float2 uvTemp = float2( 1- f.uvBorder.y, 1- f.uvBorder.x); //上
            //float2 uvTemp = float2(  f.uvBorder.y,  f.uvBorder.x); //下
            //float2 uvTemp = float2(  f.uvBorder.x,  f.uvBorder.y); //左
            //float2 uvTemp = float2(  1- f.uvBorder.x, f.uvBorder.y); //右
            
            f.uvBorder = TRANSFORM_TEX(  a.texcoordBorder , _BorderTex); //第一边界判断
            if(_BorderRange>=4){
                f.uvBorder = float2( 1- f.uvBorder.x, f.uvBorder.y); //右
            }else if(_BorderRange>=3){
                f.uvBorder = float2( f.uvBorder.x,  f.uvBorder.y); //左
            }else if(_BorderRange>=2){
                f.uvBorder = float2( f.uvBorder.y,  f.uvBorder.x); //下
            }else if(_BorderRange>=1){
                f.uvBorder = float2( 1- f.uvBorder.y, 1- f.uvBorder.x); //上
            }else{
                f.uvBorder = float2( 0,0); //无
            }
            
            //第二边界判断
            f.uvBorder2 = TRANSFORM_TEX(  a.texcoordBorder2 , _BorderTex); //右
            f.uvBorder2 = float2(  f.uvBorder2.y, f.uvBorder2.x); //上
            f.uvBorder2 = TRANSFORM_TEX(  a.texcoordBorder , _BorderTex);
            if(_BorderRange2>=4){
                f.uvBorder2 = float2( 1- f.uvBorder2.x, f.uvBorder2.y); //右
            }else if(_BorderRange2>=3){
                f.uvBorder2 = float2( f.uvBorder2.x,  f.uvBorder2.y); //左
            }else if(_BorderRange2>=2){
                f.uvBorder2 = float2( f.uvBorder2.y,  f.uvBorder2.x); //下
            }else if(_BorderRange2>=1){
                f.uvBorder2 = float2( 1- f.uvBorder2.y, 1- f.uvBorder2.x); //上
            }else{
                f.uvBorder2 = float2( 0,0); //无
            }
            		    
		    return f;
		};
		
		fixed4 frag( v2f i) : SV_Target { 
            fixed4 main = tex2D( _MainTex, i.uv ).rgba; //草地贴图
		    fixed4 border = tex2D( _BorderTex, i.uvBorder).rgba; //边界贴图 
		    fixed4 border2 = tex2D( _BorderTex, i.uvBorder2).rgba; //边界贴图 
		    fixed4 col =  main.rgba; //先获取草地贴图颜色， 如果当前点 边界也有颜色，则使用边界颜色，否则使用草地颜色
		    //if( border.a == 0 ){  //如果边界取样点颜色不是透明的，
		      //  color = fixed4 (  main );
		    //}
		    
		    
		    
		    col.rgb = border.rgb * border.a  + main.rgb * (1 - border.a) ;
		    col.rgb = border2.rgb * border2.a + col.rgb *( 1- border2.a);
		    
		    
		    
		    //col.rgb = border.rgb * border.a + border2.rgb * border2.a +  main.rgb * (1 - border.a*border2.a) ;
		    
		    return fixed4( col.rgb,1);
		};
		
		ENDCG
	}
	}
	FallBack "Diffuse"
	
	            
            //if(_BorderRange >=3 ){
                
            //}
            
            
		    //f.uvBorder = TRANSFORM_TEX( a.texcoordBorder, _BorderTex);
            

		    
		    //if( _BorderRange2 >=3) {
		      //  f.uvBorder2 = float2(  1- f.uvBorder2.x, f.uvBorder2.y); //右
		    //}
		    
		    /*
            if(_BorderRange>=4){
                if(i.uv.x < _SideAlphaControl){
                    col.rgb = border.rgb * border.a  + main.rgb * (1 - border.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border.rgb * border.a;
                    col.a = border.a;
                }
            }else if(_BorderRange>=3){
                if(i.uv.x > _SideAlphaControl){
                    col.rgb = border.rgb * border.a  + main.rgb * (1 - border.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border.rgb * border.a;
                    col.a = border.a;
                }
            }else if(_BorderRange>=2){
                if(i.uv.y > _SideAlphaControl){
                    col.rgb = border.rgb * border.a  + main.rgb * (1 - border.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border.rgb * border.a;
                    col.a = border.a;
                }
            }else if(_BorderRange>=1){
                if(i.uv.y < _SideAlphaControl){
                    col.rgb = border.rgb * border.a  + main.rgb * (1 - border.a) ;
                    
                }else{
                    col.rgb = border.rgb * border.a;
                    
                }
            }else{
                col.a = 1;
            }
            
            
            if(_BorderRange2>=4){
                if(i.uv.x < _SideAlphaControl){
                    col.rgb = border2.rgb * border2.a  + col.rgb * (1 - border2.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border2.rgb * border2.a;
                    col.a = border2.a;
                }
            }else if(_BorderRange2>=3){
                if(i.uv.x > _SideAlphaControl){
                    col.rgb = border2.rgb * border2.a  + col.rgb * (1 - border2.a) ;
                    //col.a = 1;
                }else{
                    col.rgb = border2.rgb * border2.a;
                    //col.a = border2.a;
                }
            }else if(_BorderRange2>=2){
                if(i.uv.y > _SideAlphaControl){
                    col.rgb = border2.rgb * border2.a  + col.rgb * (1 - border2.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border2.rgb * border2.a;
                    col.a = border2.a;
                }
            }else if(_BorderRange2>=1){
                if(i.uv.y < _SideAlphaControl){
                    col.rgb = border2.rgb * border2.a  + col.rgb * (1 - border2.a) ;
                    col.a = 1;
                }else{
                    col.rgb = border2.rgb * border2.a;
                    col.a = border2.a;
                }
            }else{
                col.a = 1;
            }
		    */
}
