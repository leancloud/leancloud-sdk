using UnityEngine;
using System.Collections;

public class obstacle : MonoBehaviour
{
    public bool up;
    public bool down;

    public GameObject pipes;
    public float delayTime;
    private float respawnTimer;
    // Use this for initialization
    void Start()
    {
        respawnTimer = 1;
    }

    // Update is called once per frame
    void Update()
    {
        if (GameManager.gameStart && !GameManager.gameOver)
        {
            if (up)
            {
                respawnTimer += Time.deltaTime;
                if (respawnTimer > delayTime)
                {
                    var tolerance = Random.Range(0f, 3f);
                    Vector3 pos = new Vector3(transform.position.x, transform.position.y + tolerance, transform.position.z);
                    var newObject = Instantiate(pipes, pos, transform.rotation);
                    respawnTimer = 0.0f;
                }

            }
            if (down)
            {
                respawnTimer += Time.deltaTime;
                if (respawnTimer > delayTime)
                {
                    var tolerance = Random.Range(0f, 3f);
                    Vector3 pos = new Vector3(transform.position.x, transform.position.y + tolerance, transform.position.z);
                    var newObject = Instantiate(pipes, pos, transform.rotation);
                    respawnTimer = 0.0f;
                }

            }
        }
    }
}
