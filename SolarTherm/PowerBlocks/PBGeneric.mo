within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_des = 0.5 "Power cycle design efficiency";
	parameter SI.HeatFlowRate Q_flow_max "Maximum energy out to power block";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf[:] "Fraction operation factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	input SolarTherm.Interfaces.WeatherBus wbus;
	SI.Power P_out "Electrical output power";
protected
	SI.Efficiency eff "Efficiency";
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
equation
	P_out = eff*Q_flow;
	eff = eff_des*fac_fra.y*fac_amb.y;
	fac_fra.x = Q_flow/Q_flow_max;
	fac_amb.x = wbus.Tdry - T_amb_des;
end PBGeneric;
