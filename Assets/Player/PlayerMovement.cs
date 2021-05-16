using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{


    public float speed = 10.0f;


    //private variables
    private bool touchEnabled;
    private Vector2 target;
    private Vector2 position;
    private Camera cam;
    private bool pressed;
    private Rigidbody2D rigidbody;


    // Start is called before the first frame update
    void Start()
    {
        //touchEnabled = Input.multiTouchEnabled;

        touchEnabled = false;
        pressed = false;

        //print(touchEnabled);


        position = gameObject.transform.position;
        target = position;

        cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        if (touchEnabled) TouchUpdate(); else ClickUpdate();
    }

    private void TouchUpdate()
    {
        int nbTouches = Input.touchCount;

        if (nbTouches > 0)
        {
            for (int i = 0; i < nbTouches; i++)
            {
                Touch touch = Input.GetTouch(i);
                if (touch.phase == TouchPhase.Began)
                {
                    //walk
                }
            }
        }
        else
        {
            // stop moving
        }
    }


    private void ClickUpdate()
    {

        float step = speed * Time.deltaTime;


        if (Input.GetMouseButtonUp(0))
        {
            pressed = false;
            target = gameObject.transform.position;
        }
        if (Input.GetMouseButtonDown(0))
        {
            pressed = true;
        }

        if (pressed)
        {
            target = cam.ScreenToWorldPoint(Input.mousePosition);
        }

        transform.position = Vector2.MoveTowards(transform.position, target, step);

    }
}
