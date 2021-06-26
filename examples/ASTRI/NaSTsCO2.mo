within examples.ASTRI;

model NaSTsCO2
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  extends Modelica.Icons.Example;
  // Parameters
  // System Level [SYS]
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Working fluid of the system";
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value";
  //arameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
  parameter Real SM = metadata_list[23] "Real solar multiple";


  // Heliostat Field and Tower [H&T]
  parameter String field_type = "surround";
  parameter String opt_file(fixed = false);
  parameter String casefolder = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/sodium");
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter SI.Area A_heliostat = 148.84 "Area of one heliostat";
  parameter SI.Length H_tower = 188.567344 "Height of the tower";
  parameter Real[24] metadata_list = SolarTherm.Utilities.Metadata_Solstice_Optics_and_Therm(opt_file);
  parameter Integer n_heliostat = SolarTherm.Utilities.Round(metadata_list[1]) "Number of heliostats";
  parameter Real eff_opt_des = metadata_list[3];
  parameter SI.Area A_field = A_heliostat * n_heliostat "Area of the entire field (reflective area)";
  parameter SI.Area A_land = metadata_list[24] "Land area occupied by the plant";


  // Receiver [RCV]
  parameter SI.Length H_recv = 19.810327;
  parameter SI.Length D_recv = 19.012482;
  parameter SI.Area A_recv = if field_type == "polar" then H_recv * D_recv else H_recv * D_recv * CN.pi "Receiver area";
  parameter Integer N_pa_recv = 20 "Number of panels in receiver";
  parameter SI.Thickness t_tb_recv = 1.25e-3 "Receiver tube wall thickness";
  parameter SI.Diameter D_tb_recv = 40e-3 "Receiver tube outer diameter";
  //parameter SI.Efficiency ab_recv = 0.961 "Receiver coating absorptance";
  //parameter SI.Efficiency em_recv = 0.92 "Receiver coating emissivity";
  parameter SI.Efficiency eff_abs = metadata_list[21] "Effective absorptance";
  parameter SI.Efficiency eff_emi = metadata_list[22] "Effective emmitance";
  parameter SI.CoefficientOfHeatTransfer h_conv_recv = 10.0 "W/m2K";
  parameter Real[4] CL = {metadata_list[8], metadata_list[9], metadata_list[10], metadata_list[11]};
  parameter Real[4] C4L = {metadata_list[12], metadata_list[13], metadata_list[14], metadata_list[15]};
  parameter Real[5] CH = {metadata_list[16], metadata_list[17], metadata_list[18], metadata_list[19], metadata_list[20]};
	parameter Real rec_fr = 1 - metadata_list[7] "Receiver loss fraction of radiance at design point";
	parameter SI.RadiantPower Q_rec_out_des=Q_flow_defocus*(1 - rec_fr) "Input power to receiver at design point";


  // Storage [ST]
  parameter Real t_storage(unit = "h") = 8.0 "Hours of storage";
  parameter SI.Temperature T_max = 740.0 + 273.15 "Ideal high temperature of the storage";
  parameter SI.Temperature T_min = 510.0 + 273.15 "Ideal low temperature of the storage";
  parameter SI.Length d_p = 0.10 "Filler diameter";    
  parameter Real ar = 2.0 "Tank aspect ratio";  


  // Power Block [PB]
  parameter String engine_brand = "SES" "Power block brand {SES,75%Carnot}";
  parameter SI.Power P_gross_des = 100e6 "Power block gross rating at design point";
  parameter SI.Power P_name_des = 100e6 "Power block nameplate rating";
  parameter SI.Power P_name = P_name_des;
  parameter SI.Power P_gross = P_gross_des / (1 - par_fr);
  parameter SI.Efficiency eff_blk_des = 0.51 "Power block efficiency at design point";
  parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";

  // Control [CTRL]
  parameter SI.TemperatureDifference T_tol_recv = 60.0 "Temperature tolerance above design receiver input temperature before receiver is shut off";
  parameter SI.TemperatureDifference T_tol_PB = 60.0 "Temperature tolerance below design PB input temperature before PB is shut off";
  //Controls, pumps , etc
  parameter SI.Temperature T_recv_max = T_min + T_tol_recv "Maximum temperature at bottom of tank when it can no longer be pumped into the receiver";
  parameter SI.Temperature T_recv_start = T_min + 0.5 * T_tol_recv "Temperature at bottom of tank when it can start being pumped into the receiver again";
  parameter SI.Temperature T_PB_start = T_max - 0.5 * T_tol_PB "Temperature at top of tank where PB can start";
  parameter SI.Temperature T_PB_min = T_max - T_tol_PB "Temperature at top of tank where PB must stop";
  parameter Real L_recv_max = 0.874215;
  //L_4
  parameter Real L_recv_start = 0.816403;
  //L_3
  parameter Real L_PB_start = 0.186413;
  //L_2
  parameter Real L_PB_min = 0.125861;
  //L_1
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter Real nu_start = 0.4 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";


  //Enthalpies
  parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_max)) "Specific enthalpy of sodium entering PB at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_min)) "Specific enthalpy of sodium leaving PB at design pt";
  parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_min)) "Specific enthalpy of sodium entering receiver at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_max)) "Specific enthalpy of sodium leaving receiver at design pt";


  //Heat Flow Rates
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * eff_emi * A_recv * ((0.5 * T_max + 0.5 * T_min + 273.15) ^ 4 - 298.15 ^ 4) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * eff_abs - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk + Q_flow_rec_loss_des) / eff_abs "Solar field thermal power at defocused state";
	parameter SI.HeatFlowRate Q_flow_des=Q_flow_ref_blk "Heat to power block at design, By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";

  //Mass flow rates
  parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
  parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
 


  // Finance [FN]
  // Cost data in USD (default) or AUD
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Real r_i = 0.025 "Inflation rate";
  parameter Real r_disc_nom = 0.0701 "[FN] Nominal discount rate";
  parameter Real r_disc = (1 + r_disc_nom) / (1 + r_i) - 1 "[FN] Real discount rate : Calculated using Fisher equation";
  parameter Integer t_life(unit = "year") = 30 "[FN] Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 0 "[FN] Years of construction";
  parameter Real r_cur = 0.71 "[FN] The currency rate from AUD to USD valid for 2019. See https://www.rba.gov.au/";
  parameter Real r_contg = 0.1 "[FN] Contingency rate";
  parameter Real r_cons = 0.09 "[FN] Construction cost rate";

  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  parameter FI.AreaPrice pri_site = 10.00 "Site improvements cost per area [USD/m2 of heliostat]";

  parameter FI.Money_USD C_land = pri_land * A_land  "Land cost";
  parameter FI.AreaPrice pri_land = 10000 / 4046.86 "Land cost per area [USD/m2]";

  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.AreaPrice pri_field = 75 "Field cost per design aperture area ($/m2)";

  parameter FI.Money_USD C_tower = 16339938 "Tower cost";

  parameter FI.Money_USD C_receiver = C_recv_fix + C_recv_ref * (D_recv / D_recv_ref) * (H_recv / H_recv_ref) ^ recv_exp "Receiver cost";
  parameter FI.Money_USD C_recv_fix = 4780420 "Receiver fixed Cost";
  parameter FI.Money_USD C_recv_ref = 35400613 "Receiver reference Cost";
  parameter SI.Diameter D_recv_ref = 20 "Receiver reference diameter";
  parameter SI.Height H_recv_ref = 18.4 "Receiver reference height";
  parameter Real recv_exp = 0.6 "Receiver reference height";

	//storage cost
	//parameter FI.Money_USD C_storage = pri_storage * E_max / (1e3 * 3600) "Storage cost";

  parameter FI.Money C_storage = eNTU.C_storage/r_cur;

	parameter FI.Money_USD C_block = pri_block * P_gross_des;
parameter FI.PowerPrice pri_block = 1360.00 / 1e3 "Power block cost per gross rated power";
  // SAM 2018 cost data: 1040
  //parameter FI.Money_USD C_block = P_gross_ref/1000*pri_block_ref*(P_gross/P_gross_ref)^power_block_exp "Power block cost";
 // parameter Real pri_block_ref(unit="$/kWe") = 600 "Power block reference unit price";
 // parameter Real power_block_exp = 0.7 "Power block scaling exponent";
//	parameter SI.Power P_gross_ref = 111e6 "Power block reference size";
	
  parameter FI.Money_USD C_bop = pri_bop * P_gross / 1e3 "Balance of plant cost";
  parameter FI.PowerPrice pri_bop = 0 "Balance of plant cost per gross rated power";
  //SAM 2018 cost data: 290

	// Operation and maintenance cost
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name / 1e3 "Fixed O&M cost per year";
  parameter Real pri_om_name(unit = "$/kWe/year") = 40 "Fixed O&M cost per nameplate per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod / (1e6 * 3600) "Variable O&M cost per production per year";
  parameter Real pri_om_prod(unit = "$/MWh/year") = 3 "Variable O&M cost per production per year";

	// Total capital investment
	parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
	parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_contingency = f_contingency * C_cap_dir_sub "Contingency costs";
	parameter Real f_contingency = 0.1 "Contingency factor";


	parameter FI.Money_USD C_cap_dir_sub = (1 - f_Subs) * (C_receiver + C_tower + C_storage + C_block + C_field + C_site + C_bop) "Direct capital cost subtotal"; // i.e. purchased equipment costs
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";


  // System component models
  // Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-120, 82}, {-90, 110}}, rotation = 0)));

  // DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-114, 60}, {-94, 80}}, rotation = 0)));

  // Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{120, 70}, {100, 90}}, rotation = 0)));

  // WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-118, 38}, {-92, 58}}, rotation = 0)));

  // pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{120, 86}, {100, 106}}, rotation = 0)));
 
  // parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {121, 64}, extent = {{-13, -10}, {13, 10}}, rotation = 180)));

  // Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));

  // Heliostat field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolstice heliostatsField(
		A_h = A_heliostat, 
		Q_design = Q_flow_defocus, 
		Wspd_max = Wspd_max, 
		ele_min(displayUnit = "deg") = ele_min, 
		he_av = he_av_design, 
		lat = data.lat, 
		lon = data.lon, 
		nu_defocus = nu_defocus, 
		nu_min = nu_min_sf, 
		nu_start = nu_start, 
		use_defocus = false, 
		use_on = true, 
		use_wind = true, 
		psave = casefolder, 
		H_tower = H_tower, 
		H_rcv = H_recv, 
		W_rcv = D_recv, 
		W_helio = sqrt(A_heliostat), 
		H_helio = sqrt(A_heliostat)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));

  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.SodiumReceiverASTRI receiver(
      redeclare package Medium = Medium, 
	  CL = CL,
	  C4L = C4L,
	  CH = CH,      
      H_rcv = H_recv, 
      D_rcv = D_recv, 
      N_pa = N_pa_recv, 
      D_tb = D_tb_recv, 
      t_tb = t_tb_recv, 
      ab = eff_abs, 
      em = eff_emi, 
      T_0 = T_min, 
      Q_des_blk = Q_flow_ref_blk, 
      T_max = T_max) annotation(
    Placement(visible = true, transformation(origin = {-28, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Storage
  SolarTherm.Models.Storage.eNTU eNTU(
		t_storage=t_storage, 
		E_max = t_storage * 3600 * Q_flow_ref_blk, 
		T_min = T_min, 
		T_max = T_max,
		psave=".", 
		d_p=d_p,
		ar = ar ,
		L_start = L_PB_min) annotation(
    Placement(visible = true, transformation(origin = {42, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));



  // Power Block
  SolarTherm.Models.PowerBlocks.PBS_PowerBlockModel_sCO2NREL_100MWe_700C_510C powerBlock(redeclare package Medium = Medium, nu_net = 1.0, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des, T_in_ref = T_max, T_out_ref = T_min, Q_flow_ref = Q_flow_ref_blk, redeclare model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling) annotation(
    Placement(visible = true, transformation(origin = {107, 21}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));

  // Cold pump (receiver)
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 6}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));

  // Hot Pump (power block)
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {66, 68}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  // Controller
  SolarTherm.Models.Control.StorageLevelController Control(redeclare package HTF = Medium, T_target = T_max, m_flow_PB_des = m_flow_blk_des, Q_des_blk = Q_flow_ref_blk, L_1 = L_PB_min, L_2 = L_PB_start, L_3 = L_recv_start, L_4 = L_recv_max) annotation(
    Placement(visible = true, transformation(origin = {48, -54}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  // Tee Junctions
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {42, 7}, extent = {{-10, -9}, {10, 9}}, rotation = 180)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {26, 59}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));

  // Market
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(origin = {144, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  //Annual Simulation variables
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";

initial algorithm
  opt_file := heliostatsField.optical.tablefile;

equation
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-93, 70}, {-83, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-91, 48}, {-100.35, 48}, {-100.35, 30}, {-88, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-56, 27.5}, {-44, 27.5}, {-44, 29}}, color = {191, 0, 0}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{107, 64}, {107, 51}, {113, 51}, {113, 38}}, color = {0, 0, 127}));
  connect(powerBlock.T_amb, Tamb_input.y) annotation(
    Line(points = {{101, 38}, {101, 59}, {99, 59}, {99, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{122, 20}, {132, 20}}, color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{99, 80}, {-28, 80}, {-28, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{34, 0}, {11, 0}, {11, 6}, {2, 6}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-6, 6}, {-14, 6}, {-14, 10}, {-24, 10}, {-24, 10}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, Splitter_top.fluid_a) annotation(
    Line(points = {{-22, 32}, {-18, 32}, {-18, 68}, {18, 68}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{70, 68}, {82, 68}, {82, 31}, {94, 31}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, Splitter_bot.fluid_a) annotation(
    Line(points = {{90, 8}, {58, 8}, {58, 0}, {50, 0}}, color = {0, 127, 255}));
  connect(Splitter_top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{34, 68}, {62, 68}}, color = {0, 127, 255}));
  connect(receiver.Q_rcv_raw, Control.Q_rcv_raw) annotation(
    Line(points = {{-24, 20}, {10, 20}, {10, -49}, {40, -49}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.Q_defocus, receiver.Q_defocus) annotation(
    Line(points = {{39, -61}, {-18, -61}, {-18, 16}, {-24, 16}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.defocus, receiver.defocus) annotation(
    Line(points = {{57, -57}, {70, -57}, {70, -26}, {-38, -26}, {-38, 20}, {-34, 20}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(Control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{57, -49}, {70, -49}, {70, -2}, {14, -2}, {14, 14}, {-2, 14}, {-2, 10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{57, -53}, {76, -53}, {76, 76}, {66, 76}, {66, 72}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.h_out_signal, Control.h_PB_outlet) annotation(
    Line(points = {{84, 4}, {84, -19.5}, {52, -19.5}, {52, -45}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_top.fluid_c, eNTU.fluid_a) annotation(
    Line(points = {{26, 54}, {26, 50}, {42, 50}}, color = {0, 127, 255}));
  connect(eNTU.fluid_b, Splitter_bot.fluid_c) annotation(
    Line(points = {{42, 34}, {42, 7}}, color = {0, 127, 255}));
  connect(eNTU.level, Control.level) annotation(
    Line(points = {{39, 46}, {14, 46}, {14, -47}, {40, -47}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(eNTU.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{38.5, 35.5}, {38.5, -14}, {45, -14}, {45, -45}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Pres_input.y, eNTU.p_amb) annotation(
    Line(points = {{100, 96}, {47, 96}, {47, 42}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, receiver.Wspd) annotation(
    Line(points = {{-90, 48}, {-32, 48}, {-32, 36}, {-32, 36}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {0, 6}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 12, fontName = "CMU Serif"), Text(origin = {12, 2}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-16, 10}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 12, fontName = "CMU Serif"), Text(origin = {0, -12}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 12, fontName = "CMU Serif"), Text(origin = {8, -2}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-42, -34}, extent = {{80, 12}, {128, -8}}, textString = "Controller", fontSize = 12, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> Updated from Z. Kee: SolarTherm/Systems/Publications/Thermocline/System_Models/PBS_Surround_SCO2NREL_CurveFit.mo (f0eebdd) </li>
	</ul>

	</html>"));
end NaSTsCO2;