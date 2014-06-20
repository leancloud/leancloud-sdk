using UnityEngine;
using System.Collections;

public class move : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (!GameManager.gameOver && GameManager.gameStart)
            transform.Translate(-Time.deltaTime * 2.3f, 0, 0);
    }
}
