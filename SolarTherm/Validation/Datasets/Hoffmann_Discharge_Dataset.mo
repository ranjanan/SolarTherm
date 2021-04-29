within SolarTherm.Validation.Datasets;

package Hoffmann_Discharge_Dataset "Provides the initial temerature and enthalpy distributions of the validation case used by Hoffmann (2016) based on Pacheco (2002) experimental data"
  package Fluid = SolarTherm.Materials.SolarSalt;
  package Filler = SolarTherm.Materials.Quartzite;

  //Hoffman's Simulation Output
    	constant SI.Length z_f_sim_0p0h[31] = {0.006635708,0.116234888,0.2101836203,0.2884614401,0.3980657363,0.4919837714,0.6015727191,0.7189945649,0.8442186117,0.9224708505,1.0477000135,1.1572787287,1.2433331685,1.3215444777,1.399760903,1.4858153428,1.5874997655,1.6735235081,1.8299717074,1.9551957542,2.0491496027,2.2292499825,2.3858670164,2.5738514563,2.7774812278,2.965470784,3.3962801834,3.5842492748,3.8427349145,4.1090483361,4.4066984667};
  	constant SI.Temperature T_f_sim_degC_0p0h[31] = {322.7041149575,324.8987589811,326.5447419987,328.3736120183,330.3853690398,333.1286740692,335.6890920967,338.2495101241,341.9072501633,344.6505551927,348.1254082299,351.0516002613,354.8922273024,359.0986283475,363.1221423906,366.9627694317,372.0836054866,377.0215545395,384.5199216199,388.177661659,389.6407576747,391.6525146963,393.115610712,393.2984977139,394.2129327237,394.2129327237,394.2129327237,394.9444807315,394.9444807315,395.1273677335,395.1273677335};
  	constant SI.Length z_f_sim_0p5h[40] = {0.2817029433,0.5715099433,0.7046487475,0.8259716938,0.8767525108,0.9001591137,0.9469979007,0.993821339,1.0250454915,1.0563156898,1.087555191,1.1579745316,1.2597459296,1.3380084008,1.463268261,1.5337080664,1.6354641158,1.7372048167,1.8780946599,1.9798302446,2.0737329311,2.183275833,2.2536849412,2.3319218313,2.4023002423,2.5352497472,2.605648623,2.6838752808,2.7777728511,2.9108195637,3.03608454,3.2083571379,3.3728121861,3.5216321352,3.7644315137,3.9367501573,4.2108964772,4.5007085933,4.8218420698,5.1038315202};
  	constant SI.Temperature T_f_sim_degC_0p5h[40] = {289.9673416068,290.3331156107,291.0646636186,294.1737426519,298.9288047028,302.2207707381,307.8902677988,314.1084258654,317.9490529066,320.1436969301,323.4356629654,326.1789679948,328.1907250163,330.5682560418,332.9457870673,334.9575440888,337.5179621163,340.6270411496,344.2847811888,347.576747224,350.8687132593,355.0751143044,358.1841933377,361.476159373,365.682560418,373.1809274984,376.6557805356,380.3135205748,383.788373612,387.8118876551,390.0065316786,391.8354016982,393.115610712,393.2984977139,394.0300457218,394.2129327237,394.3958197257,394.5787067276,395.1273677335,394.9444807315};
  	constant SI.Length z_f_sim_1p0h[32] = {1.3391390804,1.5349564185,1.6289307318,1.7306663165,1.7697335996,1.8322791124,1.8791281318,1.9338509788,2.0120008936,2.0823383751,2.176225713,2.301454876,2.4501571525,2.5675738822,2.6771577136,2.7945539784,2.9119195461,3.0371333605,3.1075373525,3.2718337986,3.3500604564,3.43610978,3.5064830748,3.5690490524,3.6864299686,3.8586104749,4.0465130557,4.2736108245,4.4850734942,4.6730579341,4.9706978323,5.158677156};
  	constant SI.Temperature T_f_sim_degC_1p0h[32] = {290.1502286088,290.3331156107,291.0646636186,294.3566296538,297.8314826911,302.0378837361,307.3416067929,311.1822338341,317.5832789027,323.2527759634,327.0934030046,330.5682560418,334.9575440888,337.7008491182,340.4441541476,343.9190071848,348.4911822338,352.5146962769,355.8066623122,362.7563683867,366.4141084259,370.437622469,374.826910516,378.3017635532,382.3252775963,387.4461136512,390.5551926845,392.5669497061,393.4813847159,393.6642717178,394.0300457218,394.3958197257};
  	constant SI.Length z_f_sim_1p5h[30] = {0.4618596013,0.8535096261,1.2451545347,1.8091283193,2.083269523,2.4279119264,2.5610251495,2.6471102865,2.7175040461,2.7722013121,2.8190605638,2.8737731785,2.9284909094,3.0144993033,3.1161939585,3.2570582206,3.4136036277,3.5779870492,3.695357733,3.9458007105,4.0318602664,4.094426244,4.1804755676,4.2899980047,4.3916875436,4.5012099807,4.6185704321,4.7672727087,4.9003347698,5.1822372449};
  	constant SI.Temperature T_f_sim_degC_1p5h[30] = {289.9673416068,289.7844546048,289.7844546048,289.6015676029,289.9673416068,290.1502286088,291.7962116264,294.5395166558,298.197256695,302.9523187459,307.8902677988,312.0966688439,316.120182887,321.6067929458,326.3618549967,330.9340300457,334.9575440888,338.79817113,343.187459177,350.6858262573,354.3435662965,357.8184193338,361.8419333769,366.7798824298,371.7178314827,376.6557805356,381.4108425865,385.8001306336,389.2749836708,392.2011757022};
  	constant SI.Length z_f_sim_2p0h[29] = {0.548016365,0.9240005935,1.276475895,1.7072904107,2.0519328141,2.4749041992,2.8508884277,3.1720526013,3.3835255034,3.5244409275,3.579199588,3.6495933476,3.704326427,3.7668668237,3.8372298861,3.8997549341,3.9622850984,4.0874733318,4.2048542481,4.4553279227,4.5492408416,4.6353208623,4.729228665,4.8153240344,4.8935711569,4.9796358291,5.0656851526,5.1595520258,5.1751615439};
  	constant SI.Temperature T_f_sim_degC_2p0h[29] = {290.1502286088,289.9673416068,290.1502286088,289.9673416068,290.1502286088,290.3331156107,290.1502286088,289.6015676029,290.1502286088,292.8935336381,295.4539516656,299.1116917048,302.586544742,306.975832789,311.73089484,316.6688438929,321.4239059438,326.3618549967,330.3853690398,336.7864141084,339.7126061398,342.6387981711,345.7478772044,348.1254082299,351.0516002613,354.5264532985,358.5499673416,363.1221423906,365.1338994121};
  	
  	//Sandia's experimental data
  	constant SI.Length z_f_exp_0p0h[49] = {0.337236534,0.4145199063,0.4777517564,0.6533957845,0.8079625293,0.8220140515,0.8782201405,0.9414519906,1.0117096019,1.0960187354,1.2365339578,1.3419203747,1.4051522248,1.4402810304,1.4613583138,1.5386416862,1.5667447307,1.6299765808,1.6510538642,1.6932084309,1.756440281,1.8266978923,1.8758782201,1.9953161593,2.0515222482,2.262295082,2.5152224824,2.6557377049,2.7259953162,3.0772833724,3.224824356,3.3793911007,3.5480093677,3.7166276347,3.9133489461,4.1170960187,4.3208430913,4.5245901639,4.6159250585,4.6861826698,4.7915690867,4.8618266979,4.9039812646,5.0725995316,5.3957845433,5.2833723653,5.4871194379,5.6487119438,5.831381733};
  	
  	constant SI.Temperature T_f_exp_degC_0p0h[49] = {331.2625431258,334.1536067829,337.0442194511,338.9755789569,338.4028231898,341.2918573973,345.5302500733,348.4208627416,350.7339842605,353.0475567682,351.3189167249,354.4034545742,357.1014950278,360.7614945769,364.6136153517,368.4675400816,371.1644530633,374.2476379462,377.1368976481,379.8342616186,382.1471576431,385.2305680204,387.3504408415,390.0502852504,391.0149502785,391.7920039687,393.5332716982,393.152637157,393.7326087447,394.1290278937,394.7114799197,394.1387241527,395.1069970911,396.0752700295,397.0444449455,397.4361287122,397.4426680497,398.0269240309,397.8372832435,394.9509549688,392.4508985952,389.1794258913,387.2550567118,389.9564795815,387.2708413196,389.5780999842,389.1994948926,390.1675423366,389.4031163326};
  	
  	constant SI.Length z_f_exp_0p5h[54] = {0.3442622951,0.5409836066,0.6533957845,0.850117096,0.8711943794,0.8922716628,0.9484777518,1.018735363,1.0960187354,1.1030444965,1.1803278689,1.2576112412,1.2786885246,1.3840749415,1.4613583138,1.4613583138,1.5245901639,1.5737704918,1.644028103,1.6651053864,1.700234192,1.81264637,1.8618266979,1.8829039813,1.9601873536,1.981264637,1.9953161593,2.1990632319,2.1990632319,2.2201405152,2.2552693208,2.2693208431,2.4309133489,2.5362997658,2.6838407494,2.7540983607,2.9297423888,3.0983606557,3.2107728337,3.3793911007,3.5199063232,3.8290398126,4.0608899297,4.3489461358,4.5878220141,4.7845433255,4.9180327869,5.1147540984,5.2552693208,5.2903981265,5.37470726,5.5152224824,5.6978922717,5.8243559719};
  	
  	constant SI.Temperature T_f_exp_degC_0p5h[54] = {291.400320202,290.4437729722,292.9508196721,293.3422779444,295.8463932171,300.0836584211,304.1294788825,307.4054614743,311.0668139897,312.9927616299,309.5289422058,308.1834171421,312.420682346,316.2755090536,319.936861569,323.2105892169,327.8343518164,330.7245134958,333.4227794439,337.4674724333,340.7423275532,342.6716576093,344.9841026451,347.8733623469,351.7272870769,354.6165467788,356.1575754843,357.5121203238,360.2081313279,362.7122466007,366.3722461497,371.3795747176,376.5842108824,381.2093264482,385.4506505513,388.5340609286,389.8877037906,387.9673935103,390.4744402102,390.0947076465,391.8323674657,393.1902947212,394.1605971092,394.9401312377,395.525514691,395.5318285341,396.1138295713,395.3498545561,393.8137867274,391.3114754098,389.9661758405,391.3186912305,391.5171262994,390.5583241256};
  	
  	constant SI.Length z_f_exp_1p0h[56] = {0.3302107728,0.4918032787,0.5971896956,0.6674473068,0.7728337237,0.8711943794,0.9203747073,1.0046838407,1.1241217799,1.243559719,1.1733021077,1.2857142857,1.4473067916,1.5878220141,1.644028103,1.6932084309,1.7283372365,1.8477751756,1.8969555035,1.9601873536,1.9601873536,1.9601873536,1.9953161593,2.0163934426,2.1358313817,2.2201405152,2.2552693208,2.2833723653,2.2903981265,2.4800936768,2.5714285714,2.6697892272,2.7400468384,2.831381733,2.9227166276,3.0983606557,3.1545667447,3.1826697892,3.2669789227,3.4355971897,3.62529274,3.6955503513,3.7798594848,3.8782201405,4.018735363,4.1662763466,4.3840749415,4.6159250585,4.8196721311,5.0093676815,5.1077283372,5.2271662763,5.3887587822,5.5433255269,5.7330210773,5.8173302108};
  	
  	constant SI.Temperature T_f_exp_degC_1p0h[56] = {289.666719282,289.6719056531,291.7935824295,292.5661262318,290.0660698582,294.6909599296,297.5811216091,298.7392608294,298.3579498049,291.2366112702,295.2783728324,288.5419532325,288.354567389,290.4773716373,294.7157643133,297.028209349,300.1104922543,302.6177644486,305.1227816989,308.7836832255,312.2499830879,315.1385663066,317.257988139,320.7249644846,320.7287978894,323.6200870408,327.2800865898,329.5918551424,333.636097143,335.9530520667,339.6148555708,342.5065957111,346.3602949467,350.40724288,353.683901955,352.726678242,355.8096376305,358.3139783976,361.2052675491,364.6769792771,369.3048007757,373.1585000113,376.4349335919,380.2895348051,383.95291677,386.8462353711,388.9715200577,391.0972557332,393.0295172165,394.5761832818,394.3867679888,391.887162604,388.6186213273,389.7790154915,389.9776760548,389.2100931292};
  	
  	constant SI.Length z_f_exp_1p5h[46] = {0.3723653396,0.5339578454,0.62529274,0.7447306792,0.8149882904,0.9484777518,1.1241217799,1.18735363,1.243559719,1.3911007026,1.5878220141,1.7775175644,2.0093676815,2.1639344262,2.3325526932,2.5222482436,2.5995316159,2.6978922717,2.7611241218,2.8454332553,2.9016393443,2.9859484778,3.112412178,3.2037470726,3.2599531616,3.4707259953,3.6393442623,3.7798594848,3.9344262295,4.0468384075,4.1662763466,4.3489461358,4.4543325527,4.7072599532,4.7915690867,4.8477751756,4.9601873536,5.0515222482,5.206088993,5.2833723653,5.3044496487,5.3114754098,5.3817330211,5.4871194379,5.6276346604,5.7962529274};
 	
  	constant SI.Temperature T_f_exp_degC_1p5h[46] = {289.4755000338,289.6732586195,292.75734548,291.2206011681,289.87485061,292.7677182222,295.8545110154,293.3531016754,289.503461339,288.3527634338,289.8996549936,290.483459986,291.453762374,289.7255733195,291.4641351162,291.0850790358,295.1315759803,299.1787494081,303.8025120076,309.1972399486,313.0504881954,318.0600717072,321.3378582542,325.3848061876,327.8900489323,330.9779691975,334.2571087108,337.7279184612,342.5471847025,346.594809119,350.6426590299,356.2331161071,362.3988093896,366.8360881232,372.808532708,378.7800753151,383.4054163754,387.4523643087,391.1161972625,387.0746611947,383.4164656008,378.024669087,376.2937740997,380.1486008073,384.9674160597,386.7059778565};
  	
  	constant SI.Length z_f_exp_2p0h[41] = {0.3653395785,0.5339578454,0.6393442623,0.8290398126,1.0117096019,1.1170960187,1.1943793911,1.3419203747,1.5386416862,1.6932084309,1.8266978923,1.981264637,2.1007025761,2.2833723653,2.3817330211,2.4871194379,2.6346604215,2.7049180328,2.8173302108,2.9156908665,3.2037470726,3.5269320843,3.7868852459,3.8922716628,4.0117096019,4.131147541,4.2084309133,4.3840749415,4.6018735363,4.81264637,4.9039812646,4.9461358314,4.9882903981,5.0444964871,5.1077283372,5.1428571429,5.2271662763,5.3606557377,5.5854800937,5.6978922717,5.8173302108};
 	
  	constant SI.Temperature T_f_exp_degC_2p0h[41] = {287.5495523936,287.3623920446,289.6766410355,286.7941461655,288.533158951,290.4622635128,289.3093106636,287.5808961147,288.5500710307,289.9030374095,291.0627550905,291.2602881818,290.3012605137,290.4996955826,292.0434302208,290.8913793492,292.051548019,291.2835141047,290.3242609421,288.9794123616,288.6035132027,290.5396080907,293.6291068167,298.2542223826,303.8426500101,310.201366496,315.9810133718,322.726678242,329.8588405078,336.4130606354,343.7337362167,348.356822333,354.3279139513,360.1068843439,365.8860802309,372.0495185695,375.7110965793,378.2188197623,381.6923354455,383.0439488579,382.4700656189};


  function Initial_Temperature_f "Input a height array, obtain a Temperature array"
    input SI.Length[:] z_f;
    output SI.Temperature[size(z_f,1)] T_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          T_f[i] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          T_f[i] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          break;
        elseif z_f[i] > z_data[29] then
          T_f[i] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Temperature_f;
  
  function Initial_Enthalpy_f "Input height array, output enthalpy array based on constant SolarSalt properties"
    input SI.Length[:] z_f;
    output SI.SpecificEnthalpy[size(z_f,1)] h_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Temperature[N_f] T_f;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          T_f[i] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          T_f[i] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        elseif z_f[i] > z_data[30] then
          T_f[i] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Enthalpy_f;
  
  function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
    input SI.Length[:] z_f;
    input Integer N_p;
    output SI.Temperature[size(z_f,1),N_p] T_p;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          end for;
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          end for;
          break;
        elseif z_f[i] > z_data[30] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          end for;
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Temperature_p;
  
  function Initial_Enthalpy_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
    input SI.Length[:] z_f;
    input Integer N_p;
    output SI.SpecificEnthalpy[size(z_f,1),N_p] h_p;
  protected
    Integer N_f = size(z_f,1);
    Real T;
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          for k in 1:N_p loop
            T := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
            h_p[i,k] := Filler.h_Tf(T,0);
            
          end for;
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          for k in 1:N_p loop
            T := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
            h_p[i,k] := Filler.h_Tf(T,0);
          end for;
          break;
        elseif z_f[i] > z_data[30] then
          for k in 1:N_p loop
            T := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
            h_p[i,k] := Filler.h_Tf(T,0);
          end for;
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Enthalpy_p;
end Hoffmann_Discharge_Dataset;