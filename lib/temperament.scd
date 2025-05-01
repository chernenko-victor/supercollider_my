(
~equal_temper = {
	arg degree_num = 12, interval = 2;
	var min_inrerval;
	min_inrerval = pow(interval, 1/degree_num);
Array.fill((degree_num + 1), {
		arg indx;
		pow(min_inrerval, indx);
	})
};

~et12_8_ratios_arr = ~equal_temper.value();
~et17_8_ratios_arr = ~equal_temper.value(degree_num: 17);
~et21_12_ratios_arr = ~equal_temper.value(21, (2 + (3/2)));
)