#! /usr/bin/perl 

use LWP;
use URI::Escape;

my %county_id=(
"Salt Lake"=>"1",
"Cache"=>"2",
"Summit"=>"3",
"Wasatch"=>"4",
"Utah"=>"5",
"Juab"=>"6",
"Tooele"=>"7",
"Weber"=>"8",
"Morgan"=>"9",
"Cache"=>"10",
"Rich"=>"11",
"Box Elder"=>"12",
"Millard"=>"13",
"Sanpete"=>"14",
"Sevier"=>"15",
"Beaver"=>"16",
"Piute"=>"17",
"Wayne"=>"18",
"Iron"=>"19",
"Washington"=>"20",
"Garfield"=>"21",
"Kane"=>"22",
"San Juan"=>"23",
"Grand"=>"24",
"Emery"=>"25",
"Carbon"=>"26",
"Duchesne"=>"27",
"Uintah"=>"28",
"Daggett"=>"29");

$browser = LWP::UserAgent->new();

@header=(
    'Cookie'=>'PHPSESSID=f807966e378a661d76d7e824856034cf; cookie=1; USERAGENT=2; timeBomb=1222349081; KICKOUT=0; AGTOFFICEID=9900000; USERNAME=99010295; LOGONNAME=gatgra; AGTRIGHTS=2; PASSWORD=qdam',
	'Content-Type'=>'application/x-www-form-urlencoded',
	'Host'=>'www.wfrmls.com',
	'User-Agent'=>'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.5) Gecko/20070713 Firefox/2.0.0.5',
	'Accept'=>'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
	'Accept-Language'=>'en-us,en;q=0.5',
	'Accept-Encoding'=>'gzip,deflate',
	'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
	'Keep-Alive'=>'300',
	'Connection'=>'keep-alive'
);

@done = `ls "reports/Cache"`;
foreach(@done){
	s/.gz//;
	$done{$_}=1;
}

open F_IDS, "out";
while (<F_IDS>){
	chomp;
#	if(not m/^(\d\d)-(\d\d\d)-(\d\d\d\d)$/){next};
	if(not $_){next};
	if($done{$_}){next};
	@timedata = localtime(time);
	$hour = $timedata[2];
	$url = "http://www.wfrmls.com/searches/par/par_load.wfr?ptype=res&countycode=$county_id{'Cache'}&taxid=$_";
	@header0= (@header, ':content_file' => "reports/Cache/$_.gz");
	$response = $browser->get($url,@header0);
	$file = "reports/Cache/$_.gz";
	$temp=`gzip -cd9 "$file"`;
	if(not $temp=~m/There is no activity recorded for this property/){
		$temp =~m/top.location = '([^']+)';/;
		$temp = $1;
		$temp =~s/\/index.wfr\?throw_error=&goto=//;
		$url = uri_unescape($temp);
		$response = $browser->get($url,@header0);
	}
	if($hour >3){sleep 2;}
	else{sleep 1;}
}
