using Godot;
using System;

public class Player : KinematicBody
{
    [Export]
    private float move_speed = 10f;
    private Vector2 _destination;

    public override void _PhysicsProcess(float delta)
    {
        Vector3 des = new Vector3(_destination.x, 0, _destination.y);
        Vector3 aim = (des - Transform.origin).Normalized();
        MoveAndSlide(aim * move_speed);
    }

    public void set_destination(Vector2 destination_)
    {
        _destination = destination_;
        GD.Print(_destination);
    }

    public void look_at(Vector3 aim)
    {
        LookAt(aim, Vector3.Up);
    }
}
