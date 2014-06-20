//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2014 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;

/// <summary>
/// Trivial script that fills the label's contents gradually, as if someone was typing.
/// </summary>

[RequireComponent(typeof(UILabel))]
[AddComponentMenu("NGUI/Examples/Typewriter Effect")]
public class TypewriterEffect : MonoBehaviour
{
	/// <summary>
	/// How many characters will be printed per second.
	/// </summary>

	public int charsPerSecond = 20;

	/// <summary>
	/// How long to pause when a period is encountered (in seconds).
	/// </summary>

	public float delayOnPeriod = 0f;

	/// <summary>
	/// How long to pause when a new line character is encountered (in seconds).
	/// </summary>

	public float delayOnNewLine = 0f;

	/// <summary>
	/// If a scroll view is specified, its UpdatePosition() function will be called every time the text is updated.
	/// </summary>

	public UIScrollView scrollView;

	UILabel mLabel;
	string mText;
	int mOffset = 0;
	float mNextChar = 0f;
	bool mReset = true;

	void OnEnable () { mReset = true; }

	void Update ()
	{
		if (mReset)
		{
			mOffset = 0;
			mReset = false;
			mLabel = GetComponent<UILabel>();
			mText = mLabel.processedText;
		}

		if (mOffset < mText.Length && mNextChar <= RealTime.time)
		{
			charsPerSecond = Mathf.Max(1, charsPerSecond);

			// Periods and end-of-line characters should pause for a longer time.
			float delay = 1f / charsPerSecond;
			char c = mText[mOffset];

			if (c == '.')
			{
				if (mOffset + 2 < mText.Length && mText[mOffset + 1] == '.' && mText[mOffset + 2] == '.')
				{
					delay += delayOnPeriod * 3f;
					mOffset += 2;
				}
				else delay += delayOnPeriod;
			}
			else if (c == '!' || c == '?')
			{
				delay += delayOnPeriod;
			}
			else if (c == '\n') delay += delayOnNewLine;

			// Automatically skip all symbols
			NGUIText.ParseSymbol(mText, ref mOffset);

			mNextChar = RealTime.time + delay;
			mLabel.text = mText.Substring(0, ++mOffset);

			// If a scroll view was specified, update its position
			if (scrollView != null) scrollView.UpdatePosition();
		}
	}
}
