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

~markov_func__stokhastic_lib = {
	arg last_index, markov_arr; //, index_arr
	var index_arr;
	index_arr = (0..(markov_arr[0].size - 1));
	index_arr.wchoose(markov_arr[last_index]);
};

/* =====================================================================
=================== different types of distribution ====================

1    discrete uniform
2    continuous uniform
3    continuous linear min
4    continuous linear max
5    continuous triangle
6    discrete weighted
//2DO
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
	    , markov_last_indx = 0
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
		~lin_min_distr.value(min_val, max_val)
	  }
	  {4} {
		~lin_max_distr.value(min_val, max_val)
	  }
	  {5} {
		~tri_distr.value(min_val, max_val)
	  }
	  {6} {
		weight_arr = weight_arr.normalizeSum;
		value_arr.wchoose(weight_arr);
	  }
	  {7} {
		~markov_func__stokhastic_lib.(markov_last_indx, markov2d_arr);
	  }
	;
};

)
