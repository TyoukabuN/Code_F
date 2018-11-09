-- local panel = UISystem.GetPanel(PanelName.Loading)
-- if(panel)then
--     UISystem.CloseLoading()
-- else
--     UISystem.OpenLoading()
-- end

-- local panel = UISystem.OpenPanel(PanelName.Test)


-- local count = 1
-- Timer.New(function() printc(count) count= count + 1 end,1,30):Start()
-- Timer.New(function() printc("执行") end,5):Start()

-- local testUpdate = function()
--     -- printc(Time.deltaTime)
--     printc(Time.unscaledDeltaTime)
-- end

-- EnUpdate(testUpdate)

UISystem.OpenPanel(PanelName.Tween)


-- printc(math.cos(1))
-- print(math.cos(0))
-- printc(2^(-10*1))
-- print(2^(-10*0))

-- print(math.cos(0*20)*2^(0*-10))
-- print(math.cos(1*20)*2^(1*-10))

-- cos(x*20)*2^(-10*x)

-- printc(map(3,0,3,-math.pi/2,math.pi/2))
-- printc(math.sin( math.pi/2))


-- class WenzyAni {
--     public: float ratio; // 内部表示完成进度 （范围一般为 0 到 1）
--     float startVal,endVal; // 开始的数值，结束的数值
--     float val; // 当前的数值
--     float time; // 完成整个动画所需的时间
--     int aniMode; // 决定数值的变化曲线类型
--      bool startMoving; // 是否开始运动
--      float startTick; // 开始的时刻记录
--      WenzyAni(){ }
--      WenzyAni(float time_,float startVal_,float endVal_,int mode_ = 0)
--      {    time = time_;
--      startVal = startVal_;
--         endVal = endVal_;
--          aniMode = mode_;
--           startMoving = false;
--            val = startVal_;
--         } void update(){
--               if(startMoving){
--                       ratio = MIN(time,ofGetElapsedTimef() - startTick)/time;
--                if(aniMode == 0){ // 匀速平滑过渡
--                                  val = ofMap(ratio,0,1,startVal,endVal);
--                 }else if(aniMode == 1){            // 先加速后减速（经过 sin 函数处理）
--                          float ratio2 = ofMap(sin(ofMap(ratio,0,1,-PI/2,PI/2)),-1,1,0,1);
--                         val = ofMap(ratio2,0,1,startVal,endVal);
--                   }else if(aniMode == 2){            // 持续减速（指数衰减）
--                            val = ofMap(pow(2,-10 * ratio),1,0,startVal,endVal);
--                     }else if(aniMode == 3){            // 弹簧效果
--                             val = ofMap(cos(ratio * 20) * pow(2,-10 * ratio),1,0,startVal,endVal);
--                     }else if(aniMode == 4){            // cos 式往复
--                         float n = 2; // n 表示往复次数
--                      val = ofMap(cos(ratio * n * 2 * PI + PI),1,-1,startVal,endVal);
--                      }
--                     }
--                  } void start(){    startMoving = true;    startTick = ofGetElapsedTimef(); } };