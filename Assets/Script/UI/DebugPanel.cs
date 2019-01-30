using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Net;

public class DebugPanel : MonoBehaviour {

    private UISlots _uislots;
    private Button _btn_luaEntrance;
    private InputField _input_x;
    private InputField _input_y;
    private Button _btn_change;
	// Use this for initialization
	void Start () {
        _uislots = GetComponent<UISlots>();
        _btn_luaEntrance = _uislots.GetObject(0).GetComponent<Button>();
        _input_x = _uislots.GetObject(1).GetComponent<InputField>();
        _input_y = _uislots.GetObject(2).GetComponent<InputField>();
        _btn_change = _uislots.GetObject(3).GetComponent<Button>();
        Text _user_agent = _uislots.GetObject(4).GetComponent<Text>();

        _user_agent.text = string.Concat(System.Net.Dns.GetHostName());
        IPAddress[] ipadress = Dns.GetHostAddresses(Dns.GetHostName());
        for (int i = 0; i < ipadress.Length; i++)
        {
            _user_agent.text += "\n" + ipadress[i].ToString();
        }
        _user_agent.text = string.Empty;

        _btn_change.onClick.AddListener(() => {
            print(_input_x.text);
            print(_input_y.text);
            if (!string.IsNullOrEmpty(_input_x.text) && !string.IsNullOrEmpty(_input_y.text))
            {
                Screen.SetResolution(int.Parse(_input_x.text), int.Parse(_input_y.text),true,60);
            }
        });
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
