using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using AVOSCloud;

public class GameManager : MonoBehaviour
{
    public static bool gameOver = false;
    public static bool gameStart = false;
    public static int score = 0;
    public static int totalGames = 0;
    // Use this for initialization
    void Start()
    {
        score = 0;
        gameOver = false;
        gameStart = false;
    }

    // Update is called once per frame
void Update()
{
    if (!gameStart)
    {
        if (Input.GetMouseButtonDown(0))
        {
            AVAnalytics.StartEvent("OneGame", new Dictionary<string, object> 
            {
                {"startSilgelGameTime",DateTime.UtcNow.ToString()}
            });//记录玩家点击屏幕游戏开始的时间。
            gameStart = true;
            totalGames++;
        }
    }
    if (gameStart)
        if (Input.GetKeyUp(KeyCode.Escape))
        {
            AVAnalytics.TrackEvent("QuitGame", new Dictionary<string, object> 
            {
                {"totalGames",totalGames}
            });
            Application.Quit();
        }
}
}
