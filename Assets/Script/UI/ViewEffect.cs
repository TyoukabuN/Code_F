using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

[SerializeField]
public class ViewEffect : MonoBehaviour {

    public RectTransform UIRoot = null;

    public CanvasGroup CanvasGroup = null;

    public float ScaleYAnim_Duration = 0.3f;

    //public float AlphaAnim_Duration = 0.2f;
    [Range(0, 1)]
    public float Alpha_BeginValue = 0.0f;

    private void Awake()
    {
        if (CanvasGroup==null)
        {
            CanvasGroup = GetComponent<CanvasGroup>() ?? gameObject.AddComponent<CanvasGroup>();
        }
    }

    private void OnEnable()
    {
        Show();
    }
    public void Show()
    {
        UIRoot.localScale = new Vector3(1,0,1);
        if (UIRoot) {
            DOTween.To(() => { return UIRoot.localScale.y; },
            (float scaY) => { UIRoot.localScale = new Vector3(1, scaY, 1); },
            1.0f,
            ScaleYAnim_Duration
            );
        }

        if (CanvasGroup)
        {
            CanvasGroup.alpha = 0.0f;
            DOTween.To(() => { return CanvasGroup.alpha; },
            (float alpha) => { CanvasGroup.alpha = alpha; },
            1.0f,
            ScaleYAnim_Duration * 1.6f
            );
        }
    }
}
