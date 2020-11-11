within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Tank
extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial;
  
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter Real ar = 2.0 "Aspect ratio of tank";
  parameter Real eta = 0.22 "Porosity";
  parameter SI.Length d_p = 0.015 "Filler sphere diameter";
  parameter SI.Temperature T_min = CV.from_deg(290);
  parameter SI.Temperature T_max = CV.from_deg(574);
  parameter Integer N_f = 10;
  parameter Integer N_p = 5;
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";

  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-46, 0},extent={{-6, -6}, {6, 6}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={46, 0},extent={{6, -6}, {-6, 6}},
        rotation=0)));
  
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, Correlation = Correlation, E_max = E_max, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f, N_p = N_p, U_loss_tank = U_loss_tank);
  //Try
  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;
  //End Try
  //Costs
  parameter Real C_filler = Tank_A.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid;
  parameter Real C_total = Tank_A.C_section;
  parameter Real C_tank = Tank_A.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation;
  //Theoretical Tank Level
  Real Level;
  parameter Real ZDH[N_f] = Tank_A.ZDH;
  Real T_f_degC[N_f](start=fill(T_min,N_f));
equation
  Level = Tank_A.Level;
  T_f_degC = (Tank_A.T_f).-273.15;
  /*
  Tank_A.m_flow = -1.0*fluid_a.m_flow;
  fluid_a.m_flow = -1.0*fluid_b.m_flow;
  if fluid_a.m_flow > 0.0 then //Hot Fluid is flowing into the top (charging)
  //if fluid_a.m_flow > 0.0 then //Hot Fluid is flowing into the top (charging)
    Tank_A.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = Tank_A.h_top;
    fluid_b.h_outflow = Tank_A.h_bot;
  else //Cold fluid is flowing to the bottom
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = Tank_A.h_top;
    fluid_b.h_outflow = Tank_A.h_bot;
  end if;
  */
  //Try
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  fluid_top.T = Tank_A.T_top;
  fluid_bot.T = Tank_A.T_bot;
  
  h_bot_outlet = max(Tank_A.h_f[1],fluid_bot.h);
  //h_bot_outlet = fluid_bot.h;
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  if fluid_a.m_flow > 1e-2 then// charging
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  elseif fluid_a.m_flow < -1e-2 then //discharing
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  else //force standby
    Tank_A.m_flow = 0.0;
    //fluid_a.h_outflow = inStream(fluid_b.h_outflow);
    //fluid_b.h_outflow = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
    //Tank_A.h_top = Tank_A.h_bot;//inStream(fluid_a.h_outflow);
    //Tank_A.h_top = Tank_A.h_f[N_f];
    Tank_A.h_bot = Tank_A.h_f[1];
  end if;
  //End try
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f];
  T_bot_measured = Tank_A.T_f[1];

annotation(
    Icon(graphics = {Text(origin = {7, -16}, extent = {{-49, 42}, {35, -10}}, textString = "TC"), Ellipse(origin = {-36, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {62, 12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -65}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {48, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {49, 70}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b")}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Tank;