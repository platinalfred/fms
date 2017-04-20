<?php

function getUrlContent($url){
	$client_id = "IKIA794905AF56402FB3948B99E0F770AE8B8BFD284E";
	$client_id_base64 = base64_encode($client_id);
	$client_secret = "ovbg/L/i8+eMrY41x0oz209XXpve1zWuRoCV27jslwaX+br9BPoMxzvDLV1E9Au";
	$authorization_realm = "InterswitchAuth";
	$authorization = $authorization_realm + " " + $client_id_base64;
	$nonce = str_replace("-","",uniqid(1));
	
	$headers = [
    'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Encoding: gzip, deflate',
    'Accept-Language: en-US,en;q=0.5',
    'Cache-Control: max-age=0',
    'Host: localhost',
    'Referer: http://www.example.com/index.php', //Your referrer address
    'User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0',
    'AUTHORIZATION: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0'
    'TIMESTAMP: '.time();
    'NONCE: '.$nonce;
    'SIGNATURE_METHOD: SHA512'
    'SIGNATURE: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0"'
	];
	
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HEADER, 1); 
	curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); 
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
	curl_setopt($ch, CURLOPT_TIMEOUT, 5);
	$data = curl_exec($ch);
	$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	curl_close($ch);
	return ($httpcode>=200 && $httpcode<300) ? $data : "Nothing";
}
echo (getUrlContent("http://172.23.1.248:9080/api/v1/quickteller/transactions/inquirys"));
?>