#! /usr/bin/perl
use warnings;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new();

my @header=(
	'Host'=>'www.wfrmls.com',
	'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.6) Gecko/20061201 Firefox/2.0.0.6 (Ubuntu-feisty)',
	'Accept'=>'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
	'Accept-Language'=>'en-us,en;q=0.5',
	'Accept-Encoding'=>'gzip,deflate',
	'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
	'Keep-Alive'=>'300',
	'Connection'=>'keep-alive',
	'Referer'=>'http://www.wfrmls.com/reports/index.wfr',
    'Cookie'=>'PHPSESSID=9d5b442b71bf50ae56bb1ec8dc84fcb0; cookie=1; USERAGENT=2; KICKOUT=0; timeBomb=1221073762; AGTOFFICEID=9900000; USERNAME=99010295; LOGONNAME=gatgra; AGTRIGHTS=2; PASSWORD=qdam',
	'Content-Type'=>'application/x-www-form-urlencoded',
);

my @files=`ls /home/ggathrig/_research/data/wfrmls/ids_listings/listnums08`;
foreach(@files){
	chomp;	
	$content = `gzip -cd9 /home/ggathrig/_research/data/wfrmls/ids_listings/listnums08/$_`;
	if ($content =~ m/'Please limit'/){die("Problem with $_")}
	else{
		$content =~ m/<input type="hidden" name="Parameters" value="([^"]*)">/;
		$Parameters = $1;

		$content =~ m/<INPUT TYPE="hidden" NAME="ListNum" VALUE="([^"]*)">/;
		$listnum = $1;
	}
	@header= (@header, ':content_file'=>"exported08/$_");

	@list_ids = split(/,/,$listnum);
	$checknum_string='';
	foreach $id (@list_ids){
		$checknum_string = $checknum_string."'CheckNum[]'=>'$id',";
	}
	
$res = $ua->post('http://www.wfrmls.com/reports/index.wfr',
	['Search'=>'full/res/index.wfr',
	'SORTORDER1'=>'LSTPRICE ASC',
	'SORTORDER2'=>'',
	'ptype'=>'res',
	'Parameters'=>$Parameters,
	'cma_vars'=>'',
	'ListNum'=>$listnum,
	'menu_x'=>'',
	'State'=>'',
	'frmReport'=>'custom',
	'where'=>'',
	'query_count'=>'',
	'page'=>'1',
	'history'=>'1',
	'report'=>'export',
	'CheckNum[]'=>\@list_ids,
	'CAPTCHAString'=>$ARGV[0],
	'to'=>'csv',
	'REALLY'=>'CLICK HERE TO DOWNLOAD DATA FILE',
	'LeftCheckNumCnt'=>'0',
	'LeftCheckNum'=>'',
	'RightCheckNum'=>''],
	@header); 
	
	sleep(2);
}
