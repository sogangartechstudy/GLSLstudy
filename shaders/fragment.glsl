#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
// float rectShape(vec2 st,vec2 scale){
	// 	scale=vec2(.5)-scale*.5;
	// 	vec2 shaper=vec2(step(scale.x,st.x),step(scale.y,st.y));
	// 	shaper*=vec2(step(scale.x,1.-st.x),step(scale.y,1.-st.y));
	// 	return shaper.x*shaper.y;
// }

float random(float x){
	return fract(sin(x)*1e4);
}

float random(vec2 st){
	return fract(sin(dot(st.xy,vec2(12.9898,78.23)))*23432.);
}
float randomSeries(float x,float freq,float t){
	return step(.5,random(vec2(floor(x*freq)-floor(t))));
}

void main(){
	vec2 st=gl_FragCoord.xy/u_resolution;
	vec3 color=vec3(0.);
	
	float cols=2.;
	
	float freq=random(floor(u_time))+abs(atan(u_time)*.1);
	freq+=random(st.y);
	float t=60.+u_time*(1.-freq)*30.;
	
	if(fract(st.y*cols*.5)<.5){
		t*=-1.;
	}
	
	color=vec3(randomSeries(st.x,freq*100.,t),randomSeries(st.x,freq*100.,t),randomSeries(st.x,freq*100.,t));
	
	// // float rnd=random(tile);
	gl_FragColor=vec4(color,1.);
}
