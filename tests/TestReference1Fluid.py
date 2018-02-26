#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestReference1Fluid(unittest.TestCase):
	def setUp(self):
		fn = '../examples/Reference_1_fluid.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_reference1_fluid(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.assertAlmostEqual(self.perf[0], 429982.95, 2) # epy
		self.assertAlmostEqual(self.perf[1], 147.92, 2) # LCOE
		self.assertAlmostEqual(self.perf[2], 49.08, 2) # Capacity factor
		print(self.perf);
if __name__ == '__main__':
	unittest.main()
