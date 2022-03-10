using Godot;
using System;

public class PlayerController : Node
{
    private Player _player;

    public override void _Ready()
    {
        _player = GetParent<Player>();
    }

    public override void _Process(float delta)
    {
        Vector2 move_vector = Vector2.Zero;
        Vector3 p3D = _player.Transform.origin;
        Vector2 p2D = new Vector2(p3D.x, p3D.z);

        if (Input.IsActionPressed("Move Up"))
            move_vector += Vector2.Up;
        if (Input.IsActionPressed("Move Down"))
            move_vector += Vector2.Down;
        if (Input.IsActionPressed("Move Left"))
            move_vector += Vector2.Left;
        if (Input.IsActionPressed("Move Right"))
            move_vector += Vector2.Right;

        _player.set_destination(p2D + move_vector);

        set_player_look_at();
    }

    private void set_player_look_at()
    {
        var camera = GetViewport().GetCamera();
        var space_state = _player.GetWorld().DirectSpaceState;
        var mouse_position = GetViewport().GetMousePosition();
        var ray_origin = camera.ProjectRayOrigin(mouse_position);
        var ray_end = ray_origin + camera.ProjectRayNormal(mouse_position) * 2000.0f;
        var intersection = space_state.IntersectRay(ray_origin, ray_end);
        if (intersection.Count != 0)
            _player.look_at((Vector3)intersection["position"]);
    }
}
