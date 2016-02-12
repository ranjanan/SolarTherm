model TroughWagner
	extends SolarTherm.Systems.GenericSystem(
		weaFile="resources/AUS_NT.Alice.Springs.Airport.943260_RMY.motab", //*
		// USA CA Daggett (TMY2).csv
		// Need to get weather data above and also to handle switching between
		// hemispheres.  Maybe have an alignment parameter or automatically calc
		// this from the latitude.  Assume all flux are aligned north.
		fluxFile="resources/troughwagner_flux.motab",
		SM=1.9343,
		P_gross=111e6,
		P_rate=100e6,
		eff_cyc=0.3774,
		t_storage=6,
		ini_frac=0.1,
		rec_T_amb_des=298.15,
		tnk_T_amb_des=298.15,
		blk_T_amb_des=293.15,
		par_T_amb_des=293.15,
		rec_fr=0.071,
		tnk_fr=0.7*24*1e-3, // 0.7kWt/MW-hr-cap converted to capacity frac per day
		par_fr=0.10, // not accounting for fixed parasitic load of 0.0055MWe/MWcap
		rec_ci={0, 4.75, -8, 4.5, -0.25}, // Our formulation is more generic, raising power to get equivalent
		rec_ca={1},
		rec_cw={1},
		tnk_cf={0, 1}, // Actual value is c0=1
		tnk_ca={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		C_cap=676.118e6,
		C_main=0.065*100e6, // Not including cost by generation of 4$/MWh
		r_disc=0.055,
		t_life= 25,
		t_cons=0,
		const_dispatch=true
		//const_dispatch=false,
		//sch(
		//	file="resources/daily_sch_0.motab",
		//	ndaily=5, // needs to match file
		//	wmap={
		//		{2,2,2,2,2,3,3},
		//		{4,4,4,4,4,5,5}
		//		},
		//	mmap={1,1,1,2,2,2,2,2,2,1,1,1}
		//	)
		);
	// Adapted data from:
	// Wagner, M. J.; Zhu, G. (2011). "Generic CSP Performance Model for NREL's System Advisor Model", SolarPACES 2011
	// * indicates where substitute data was used (either missing or replacement)
end TroughWagner;