within SolarTherm.Sources;
package Weather

import SI = Modelica.SIunits;
import nSI = Modelica.SIunits.Conversions.NonSIunits;
import Modelica.SIunits.Conversions.from_degC;

block WeatherSource "Weather source including tabular data and other calculators"
	import SolarTherm.Sources.Solar.SolarPositionDB;
	parameter String weaFile "File containing TMY data";
	parameter nSI.Angle_deg lat = meta.lat "Latitude";
	parameter nSI.Angle_deg lon = meta.lon "Longitude";
	// Delay could be added to metadata.
	// By default we assume no delay as it appears to depend on the weather file
	// whether or not it lines up better.
	parameter SI.Time delay[8] = {0,0,0,0,0,0,0,0} "Time delay of table columns";
	output SolarTherm.Interfaces.WeatherBus wbus;
protected
	parameter String weaFileAct = weatherFileChecker(weaFile);
	parameter Metadata meta = getMetadata(weaFileAct);
	WeatherTable wtab(
		each tableOnFile=true,
		each fileName=weaFileAct,
		each tableName="weather",
		each smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		each columns=2:9,
		delay=delay
		);
	SolarTherm.Sources.Date.SimpleDate date(toyoffset=meta.tstart);
	SolarPositionDB spos(lon=lon, lat=lat, tzone=meta.tzone);
	SI.Irradiance dni_l;
	SI.Irradiance ghi_l;
	SI.Velocity wspd_l;
	SI.Temperature Tdry_K;
	SI.Temperature Tdew_K;
equation
	connect(date.t, spos.t);

	// In order for connections to expandable connector to work outside here,
	// the values needed to be connected here (so they are registered)
	connect(date.t, wbus.t);
	connect(date.tod, wbus.tod);
	connect(date.dow, wbus.dow);
	connect(date.moy, wbus.moy);

	connect(spos.alt, wbus.alt);
	connect(spos.azi, wbus.azi);
	connect(spos.elo, wbus.elo);
	connect(spos.hra, wbus.hra);
	//connect(wbus.ghi, wtab.y[1]);
	//ghi_l = noEvent(if wtab.y[1] > 0 then wtab.y[1] else 0);
	//ghi_l = if noEvent(wtab.y[1] > 0) then wtab.y[1] else 0;
	//ghi_l = if wtab.y[1] >= 0 then wtab.y[1] else 0;
	ghi_l = max(wtab.y[1], 0);
	connect(ghi_l, wbus.ghi);
	//connect(wbus.dni, wtab.y[2]); // must be used
	// For some reason need to connect because otherwise these constraints
	// don't show up...
	//wbus.dni = if wtab.y[2] < 0 then 0 else wtab.y[2]; // under-determined
	//wbus.dni = wtab.y[2]; // under-determined
	//wbus.dni = 5.0;
	//dni_l = noEvent(if wtab.y[2] > 0 then wtab.y[2] else 0); // diff result
	//dni_l = if noEvent(wtab.y[2] > 0) then wtab.y[2] else 0; // diff result

	//dni_l = if wtab.y[2] >= 0 then wtab.y[2] else 0; // diff result
	dni_l = max(wtab.y[2], 0);
	connect(dni_l, wbus.dni);
	Tdry_K = from_degC(wtab.y[3]);
	connect(Tdry_K, wbus.Tdry);
	Tdew_K = from_degC(wtab.y[4]);
	connect(Tdew_K, wbus.Tdew);
	connect(wtab.y[7], wbus.wdir);
	//connect(wbus.wspd, wtab.y[8]);
	//wspd_l = noEvent(if wtab.y[8] > 0 then wtab.y[8] else 0);
	//wspd_l = if noEvent(wtab.y[8] > 0) then wtab.y[8] else 0;
	//wspd_l = if wtab.y[8] >= 0 then wtab.y[8] else 0;
	wspd_l = max(wtab.y[8], 0);
	connect(wspd_l, wbus.wspd);
end WeatherSource;

block WeatherTable "Weather data stored in table"
	extends Modelica.Blocks.Tables.CombiTable1D(verboseRead=false);
	// The interpolation for things like wdir can be bad
	parameter SI.Time delay[:] = zeros(size(columns, 1)) "Delay in table time";
equation
	for i in 1:size(columns, 1) loop
		u[i] = time + delay[i];
	end for;
end WeatherTable;

record Metadata "Metadata for weather file"
	String name "Station name";
	nSI.Angle_deg lat "Latitude";
	nSI.Angle_deg lon "Longitude";
	SI.Length elev "Elevation";
	nSI.Time_hour tzone "Time zone";
	SI.Time tstart "Local time difference between time=0 and start of year";
end Metadata;

// Should technically be defined as impure but have errors so ignoring
function getMetadata "Get metadata from file"
	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;
	input String fileName;
	output Metadata meta;
protected
	String line;
	Integer i;
	Integer j;
algorithm
	line := Streams.readLine(fileName, 7);
	Streams.close(fileName);
	// scanString expects string literals, so doing manually
	// Check first part is #METADATA
	i := Strings.find(line, ",", 1);
	assert(i > 0, "Metadata cannot be read " + fileName);
	assert(Strings.substring(line, 1, i-1) == "#METADATA",
		"Metadata cannot be read " + fileName);
	j := Strings.find(line, ",", i+1);
	meta.name := Strings.substring(line, i+1, j-1);
	(meta.lat, j) := Strings.scanReal(line, j+1,
		message="Metadata cannot be read " + fileName);
	(meta.lon, j) := Strings.scanReal(line, j+1,
		message="Metadata cannot be read " + fileName);
	(meta.elev, j) := Strings.scanReal(line, j+1,
		message="Metadata cannot be read " + fileName);
	(meta.tzone, j) := Strings.scanReal(line, j+1,
		message="Metadata cannot be read " + fileName);
	(meta.tstart, j) := Strings.scanReal(line, j+1,
		message="Metadata cannot be read " + fileName);
end getMetadata;

// Should technically be defined as impure but have errors so ignoring
function checkVersion "Check if file is correct version"
	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;
	input String fileName;
	output Boolean pass;
protected
	// Change these as the format changes
	constant String metal = "#METALABELS,name,lat,lon,elev,tzone,tstart";
	constant String metau = "#METAUNITS,str,deg,deg,m,h,s";
	constant String tablel = "#TABLELABELS,time,ghi,dni,dry,dew,rhum,p,wdir,wspd";
	constant String tableu = "#TABLEUNITS,s,W/m2,W/m2,degC,degC,%,mbar,deg,m/s";
	constant Integer ncol = 9;
	String line;
	Integer nr;
	Integer nc;
	Integer i;
algorithm
	pass := (Streams.readLine(fileName, 1) == "#1")
			and (Streams.readLine(fileName, 3) == metal)
			and (Streams.readLine(fileName, 4) == metau)
			and (Streams.readLine(fileName, 5) == tablel)
			and (Streams.readLine(fileName, 6) == tableu)
			;
	if pass then
		// The scan functions assert that Integer is found
		line := Streams.readLine(fileName, 2);
		i := Strings.find(line, "(");
		(nr, i) := Strings.scanInteger(line, i+1);
		i := Strings.find(line, ",");
		(nc, i) := Strings.scanInteger(line, i+1);
		pass := (nc == ncol);
	end if;
	Streams.close(fileName);
end checkVersion;

// Should technically be defined as impure but have errors so ignoring
function weatherFileChecker "Check and possibly convert weather file"
	import Modelica.Utilities.System.command;
	input String fileName;
	output String newName;
protected
	String dir;
	String name;
	String ext;
	Integer result;
algorithm
	// Should add parameter for whether or not to overwrite existing .motab file.
	(dir, name, ext) := Modelica.Utilities.Files.splitPathName(fileName);
	if ext == ".motab" then
		assert(checkVersion(fileName), "Selected .motab file version mismatch, "
			+ "select original source to reconvert " + fileName);
		newName := fileName;
	else
		result := command("st_wea_to_mo " + fileName);
		assert(result == 0, "Failed to convert weather file " + fileName);
		newName := dir + name + ".motab";
		assert(checkVersion(newName), "Converted weather file version mismatch "
			+ newName);
	end if;
end weatherFileChecker;

end Weather;