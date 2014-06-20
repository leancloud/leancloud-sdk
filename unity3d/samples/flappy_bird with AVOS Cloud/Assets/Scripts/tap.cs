using UnityEngine;
using AVOSCloud;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class tap : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        renderer.enabled = true;

        AVQuery<AVObject> query = new AVQuery<AVObject>("GameScore");//建立对GameScore的查询。
        query.Limit(1).OrderByDescending("score").FindAsync().ContinueWith(t =>//获取排名最高的玩家，这算法未必是最佳选择，但是这里只提供一种最简单的算法。
        {
            var results = t.Result.FirstOrDefault();
            var name = results["playerName"].ToString();
            var score = (int)results["score"];

            PlayerPrefs.SetInt("highscore", score);//将最高分记录到系统，下次再打开游戏的时候，会刷新这个最高分。
        });
    }

    // Update is called once per frame
    void Update()
    {
        if (GameManager.gameStart)
            renderer.enabled = false;

    }
}
