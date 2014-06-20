using UnityEngine;
using System.Collections;
using AVOSCloud;

public class guiManager : MonoBehaviour
{
    public GUISkin MyCustomSkin;
    private Rect windowRect0;
    public Texture2D scoreBoard;
    public Texture2D gameOver;
    public Texture2D goldGray;
    public Texture2D goldGold;
    public static bool medal = false;

    // Use this for initialization
    void Start()
    {
        medal = false;
    }

    // Update is called once per frame
    void Update()
    {

    }
    void OnGUI()
    {
        var windowWidth = Screen.width / 1.2f;
        var windowHeight = Screen.height / 3.5f;
        var windowX = (Screen.width - windowWidth) / 2f;
        var windowY = (Screen.height - windowHeight) / 2.1f;

        if (GameManager.gameStart)
        {
            MyCustomSkin.GetStyle("font").fontSize = Screen.height / 18;
            GUI.Label(new Rect(Screen.width / 2f, Screen.height / 6f, 100, 20), GameManager.score.ToString(), MyCustomSkin.GetStyle("font"));
        }
        else
        {
            //if (GUI.Button(new Rect(Screen.width / 15f, Screen.height / 80f, Screen.width / 4f, Screen.height / 10f), "", MyCustomSkin.GetStyle("leaderBoard")))
            //{

            //}
        }

        if (GameManager.gameOver)
        {
            GUI.DrawTexture(new Rect(windowX, windowY / 1.35f, windowWidth, windowHeight / 2.8f), gameOver);
            GUI.DrawTexture(new Rect(windowX, windowY, windowWidth, windowHeight), scoreBoard);
            if (!medal)
                GUI.DrawTexture(new Rect(windowX / 0.57f, windowY / 0.8f, windowWidth / 3.2f, windowHeight / 2f), goldGray);
            if (medal)
                GUI.DrawTexture(new Rect(windowX / 0.57f, windowY / 0.8f, windowWidth / 3.2f, windowHeight / 2f), goldGold);

            MyCustomSkin.GetStyle("font").normal.textColor = Color.white;
            MyCustomSkin.GetStyle("font").fontSize = Screen.height / 20;
            GUI.Label(new Rect(Screen.width / 1.5f, Screen.height / 2.3f, 100, 20), GameManager.score.ToString(), MyCustomSkin.GetStyle("font"));
            GUI.Label(new Rect(Screen.width / 1.5f, Screen.height / 1.85f, 100, 20), PlayerPrefs.GetInt("highscore").ToString(), MyCustomSkin.GetStyle("font"));
            if (GUI.Button(new Rect(Screen.width / 5.4f, Screen.height / 1.6f, Screen.width / 4f, Screen.height / 10f), "", MyCustomSkin.GetStyle("play")))
            {
                GameManager.gameOver = false;
                GameManager.gameStart = false;
                GameManager.score = 0;
                Application.LoadLevel(0);
            }

            if (GUI.Button(new Rect(Screen.width / 1.7f, Screen.height / 1.6f, Screen.width / 4f, Screen.height / 10f), "", MyCustomSkin.GetStyle("leaderBoard")))
            {
                //
            }
        }

    }
    void UserForm(int windowID)
    {
    }
}
