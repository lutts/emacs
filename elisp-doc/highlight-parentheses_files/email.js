function despamEmail(where) {
	var add='ed.muhcsn%sgub';
	var res='';
	for (var i = add.length-1; i >= 0; i--)
		res += add[i]=='%' ? '@' : add[i];
	where.setAttribute('href', 'mai'+'lto:'+res);
}
