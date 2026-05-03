shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float time = 0.0;
uniform float scanline_strength = 0.2;
uniform float aberration = 0.03;
uniform float distortion = 0.1;
uniform float vignette_strength = 0.2;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV;
    
    // Пузатый экран
	vec2 curved = uv * 2.0 - 1.0;
	curved += curved * curved.yx * distortion;
	uv = curved * 0.5 + 0.5;
    
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		float r = texture(screen_texture, uv + vec2(aberration, 0.0)).r;
		float g = texture(screen_texture, uv).g;
		float b = texture(screen_texture, uv - vec2(aberration, 0.0)).b;
	    
		float scanline = 1.0 - sin(uv.y * 600.0) * scanline_strength;
		float noise = rand(uv + vec2(time)) * 0.03;
	    
		float vignette = uv.x * (1.0 - uv.x) * uv.y * (1.0 - uv.y) * 15.0;
		vignette = pow(vignette, vignette_strength);
	    
		COLOR = vec4(
			(r + noise) * scanline * vignette,
			(g + noise) * scanline * vignette,
			(b + noise) * scanline * vignette,
			1.0
		);
	}
}