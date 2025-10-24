package library

import sg "../../vendor/sokol/gfx"


Vec2 :: [2]f32
Vec3 :: [3]f32 
Vec4 :: [4]f32
Mat4 :: matrix[4, 4]f32

Vertex :: struct {
    pos: Vec3,
    col: Vec4,
    uv: Vec2,
}

// Helpers sokol:gfx
sg_range :: proc {
	sg_range_from_struct,
	sg_range_from_slice,
}

sg_range_from_struct :: proc(s: ^$T) -> sg.Range where intrinsics.type_is_struct(T) {
	return {ptr = s, size = size_of(T)}
}

sg_range_from_slice :: proc(s: []$T) -> sg.Range {
	return {ptr = raw_data(s), size = len(s) * size_of(s[0])}
}
