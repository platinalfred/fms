//format numbers to currency format
function curr_format(n) {
	return n.toString().replace(/./g, function(c, i, a) {
		return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "," + c : c;
	});
}
//sum up values in an array
function array_total(arr, idx) {
	var total = 0.0;
	$.each(arr, function(key, value){
		total += parseFloat(value[idx]);
	});
	return total;
}