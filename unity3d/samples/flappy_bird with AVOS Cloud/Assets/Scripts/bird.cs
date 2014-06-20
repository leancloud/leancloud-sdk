using UnityEngine;
using AVOSCloud;
using System.Collections;
using System.Collections.Generic;
using System;

public class bird : MonoBehaviour
{
    public float upForce;
    public float rotz;
    public float some;
    public float downVel;
    private Vector3 birdPos;
    public AudioClip hit;

    // Use this for initialization
    void Start()
    {
        rotz = 0;
        birdPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if (!GameManager.gameStart)
            rigidbody2D.gravityScale = 0f;
        else
            rigidbody2D.gravityScale = 0.5f;
        var pos = new Vector3(birdPos.x, transform.position.y, transform.position.z);
        transform.position = pos;
        if ((Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0)) && !GameManager.gameOver && GameManager.gameStart)
        {
            AVAnalytics.TrackEvent("Tap");
            rigidbody2D.velocity = new Vector2(0f, upForce);
        }
        if (rigidbody2D.velocity.y < upForce - some && transform.rotation.y > -90 && GameManager.gameStart)
        {
            rotz = Mathf.Lerp(rotz, -90f, Time.deltaTime);
            var rot = Quaternion.Euler(0, 0, rotz);
            transform.rotation = rot;
        }
        else
        {
            if (!GameManager.gameOver && GameManager.gameStart)
            {
                rotz = Mathf.Lerp(rotz, 25f, Time.deltaTime * 6);
                var rot = Quaternion.Euler(0, 0, rotz);
                transform.rotation = rot;
            }
        }

        if (!GameManager.gameStart)
        {
            Vector3 temp = new Vector3(transform.position.x, 0.9118328f, transform.position.z);
            transform.position = temp;
        }

        if (transform.position.y < -2.72)
        {
            Vector3 temp = new Vector3(transform.position.x, -2.72f, transform.position.z);
            var tempRot = Quaternion.Euler(0, 0, -90f);
            transform.position = temp;
            transform.rotation = tempRot;
        }

        if (rigidbody2D.velocity.y < downVel)
        {
            Vector3 tempVel = new Vector3(0f, downVel, 0f);
            rigidbody2D.velocity = tempVel;
        }
    }
void OnTriggerEnter2D(Collider2D other)
{
    if (other.gameObject.tag == "scoreMaker")
    {
        GameManager.score += 1;
        Destroy(other.gameObject);
    }
    else
    {

        AVAnalytics.StopEvent("OneGame");//本局结束，只要调用一下事件终止方法，SDK会自动计算开始到结束之间的间隔发送到服务端。

        #region 把这次的分数记录到AVOS Cloud的服务端

        AVObject gameScore = new AVObject("GameScore");
        gameScore["score"] = GameManager.score;
        gameScore["playerName"] = "DemoUser";
        gameScore["deviceID"] = SystemInfo.deviceUniqueIdentifier;
        gameScore.SaveAsync();

        #endregion

        gameObject.collider2D.isTrigger = false;
        AudioSource.PlayClipAtPoint(hit, Camera.main.transform.position);
        if (GameManager.score > PlayerPrefs.GetInt("highscore"))
        {
            guiManager.medal = true;
        }
        GameManager.gameOver = true;
    }
}
}
