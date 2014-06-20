using UnityEngine;
using System.Collections;

public class destroy : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
    }
    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter2D(Collider2D other)
    {
        Destroy(other.gameObject);
    }
}
