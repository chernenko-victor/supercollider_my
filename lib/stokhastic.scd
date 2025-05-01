/////////////////////////////////////////////////////////
////////////////////////    function     ////////////////
/////////////////////////////////////////////////////////
/*
     Functions for different random distribution.
*/

(
~equal_distr = {
	arg min, max;
	(max-min).rand + min;
};

~lin_min_distr = {
	arg min, max;
	var rand1, rand2;
	rand1 = ~equal_distr.value(min, max);
	rand2 = ~equal_distr.value(min, max);
	min(rand1, rand2);
};

~lin_max_distr = {
	arg min, max;
	var rand1, rand2;
	rand1 = ~equal_distr.value(min, max);
	rand2 = ~equal_distr.value(min, max);
	max(rand1, rand2);
};

~tri_distr = {
	arg min, max;
	var rand1, rand2;
	rand1 = ~equal_distr.value(min, max);
	rand2 = ~equal_distr.value(min, max);
	(rand1 + rand2)/2;
};

/* =====================================================================
=================== different types of distribution ====================

1    discrete uniform
2    continuous uniform
3    continuous linear min
4    continuous linear max
5    continuous triangle
//2DO
//6    discrete weighted
//7    markov 2d
======================================================================== */
~get_rand_val = {
	arg
	      distr_type = 1
	    , value_arr = []
	    , min_val = 0.0
	    , max_val = 1.0
	    , weight_arr = [] // normalized
	    , markov2d_arr = [] // normalized
	;

	switch(distr_type)
	  {1} {
		//~midi_pitch1_resr_arr.choose;
		value_arr.choose;
	  }
	  {2} {
		// min_val + ((max_val-min_val).rand);
		~equal_distr.value(min_val, max_val)
	  }
	  {3} {
		~equal_distr.value(min_val, max_val)
	  }
	  {4} {
		~lin_max_distr.value(min_val, max_val)
	  }
	  {5} {
		~tri_distr.value(min_val, max_val)
	  }
	;

};

)