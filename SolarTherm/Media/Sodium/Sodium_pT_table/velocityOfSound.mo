within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends velocityOfSound "Return velocity of sound"
	algorithm
		a := vs_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end velocityOfSound;