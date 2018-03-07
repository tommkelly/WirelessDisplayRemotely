$(document).ready(function() {
	var socket=io('/users');
	socket.on('message', function(message){
		$('#display').text(message);
	});
	$('#send').click(function(){
		socket.emit('message', $('#message').val());
	});
});