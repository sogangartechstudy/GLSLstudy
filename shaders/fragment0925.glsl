#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_time;

vec2 random2(vec2 p){
	return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main(){
	vec2 st=gl_FragCoord.xy/u_resolution;
	
	vec3 color=vec3(0);
	
	//scale
	st*=3.;
	
	//min dis
	float m_dist=1.;// minimum distance
	
	//Tile the space
	vec2 i_st=floor(st);
	vec2 f_st=fract(st);
	
	for(int y=-1;y<=-1;y++){
		for(int x=-1;x<=-1;x++){
			//Neighbor place in the grid
			vec2 neighbor=vec2(float(x),float(y));
			
			vec2 point=random2(i_st+neighbor);
			point=.5+.5*sin(u_time+point);
			
			// Vector between the pixel and the point
			vec2 diff=neighbor+point-f_st;
			
			// Distance to the point
			float dist=length(diff);
			
			m_dist=min(m_dist,dist);
			
		}
	}
	// Draw the min distance (distance field)
	color+=m_dist;
	
	// Draw cell center
	color+=1.-step(.02,m_dist);
	
	gl_FragColor=vec4(color,1.);
	
}