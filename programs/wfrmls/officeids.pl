#! /usr/bin/perl
use LWP::UserAgent;

my $ua = LWP::UserAgent->new();

my @header=(
	'Host'=>'www.wfrmls.com',
'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20061201 Firefox/2.0.0.5 (Ubuntu-feisty)',
	'Accept'=>'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
	'Accept-Language'=>'en-us,en;q=0.5',
	'Accept-Encoding'=>'gzip,deflate',
	'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
	'Keep-Alive'=>'300',
	'Connection'=>'keep-alive',
	'Referer'=>'http://www.wfrmls.com/searches/full/count.wfr',
    'Cookie'=>'PHPSESSID=d03219540a1b6fdf048d2be33eb166b2; cookie=1; USERAGENT=2; timeBomb=1223911763; KICKOUT=0; AGTOFFICEID=9900000; USERNAME=99010295; LOGONNAME=gatgra; AGTRIGHTS=2; PASSWORD=qdam; RptGrafs=Yes',
	'Content-Type' => 'application/x-www-form-urlencoded',
);

open F_FILES , "count_files";
@files=`ls ../ids_listings/listnums08/`;
foreach (@files){
	chomp;	
	$content = `gzip -cd9 "../ids_listings/listnums08/$_"`;
	if ($content =~ m/'Please limit'/){die("Bad listnum file");}
	else{
		$content =~ m/<input type="hidden" name="Parameters" value="([^"]*)">/;
		$Parameters = $1;

		$content =~ m/<INPUT TYPE="hidden" NAME="ListNum" VALUE="([^"]*)">/;
		$listnum = $1;
	}
	@header= (@header, ':content_file' => "officeids08/$_");
	$ua->post('http://www.wfrmls.com/reports/index.wfr',
	[
	'ptype'=>'res',
	'Search'=>'full/res/index.wfr',
	'Parameters'=>$Parameters,
	'state'=>'ut',
	'CheckNum'=>'0',
	'history'=>'1',
	'ListNum'=>$listnum,
	'cma_vars'=>'',	
	'cmdNoGrafs.x'=>'42',
	'cmdNoGrafs.y'=>'11',
	'cmdNoGrafs'=>'1',
	'SORTORDER1'=>'LSTPRICE ASC',
	'SORTORDER2'=>''
	],@header);
	sleep(2);	
}
