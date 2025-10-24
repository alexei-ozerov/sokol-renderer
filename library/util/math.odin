package library


Vec2 :: [2]f32
Vec3 :: [3]f32 
Vec4 :: [4]f32
Mat4 :: matrix[4, 4]f32

Vertex :: struct {
    pos: Vec3,
    col: Vec4,
    uv: Vec3,
    tex_id: int,
}
