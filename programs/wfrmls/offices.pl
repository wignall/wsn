#! /usr/bin/perl
use LWP::UserAgent;
use DBI;

my $ua = LWP::UserAgent->new();
$dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls","ggathrig","1Nephi11");

$query = 'select officeids from officeids2';
$sth = $dbh->prepare($query);
$sth->execute();
$array_ref = $sth->fetchall_arrayref();
@officeids=@$array_ref;
while(@officeids){
	@list_ids=();
	for(1..200){
		$ref = pop @officeids;
		if (defined $ref){push(@list_ids,pop @$ref );}
	}
	$listnums=join ',',@list_ids;
	my @header=(
		'Host'=>'www.wfrmls.com',
		'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.6) Gecko/20061201 Firefox/2.0.0.6 (Ubuntu-feisty)',
		'Accept'=>'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
		'Accept-Language'=>'en-us,en;q=0.5',
		'Accept-Encoding'=>'gzip,deflate',
		'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
		'Keep-Alive'=>'300',
		'Connection'=>'keep-alive',
		'Referer'=>'http://www.wfrmls.com/reports/roster/office/index.wfr',
		'Cookie'=>'PHPSESSID=0bda4b90a0fa7a0f2f106b44d12410a1; cookie=1; USERAGENT=2; timeBomb=1200529492; KICKOUT=0; AGTOFFICEID=9900000; USERNAME=99010295; LOGONNAME=gatgra; AGTRIGHTS=2; PASSWORD=mdogh; RptGrafs=No',
		'Content-Type'=>'application/x-www-form-urlencoded',
	);

#	@list_ids=(0,17507,1195,3709,13318,19960,24464,28240,30371,30812,32098,32424,33749,34131,36327,37457,37820,37906,38990,39685,40734,42375,42577,43836,44939,45490,46646,49032,49491,50815,54948,55442,55927,56615,57801,58262,59028,59036,59374,61044,62351,67890,67993,68084,68090,68226,68252,68333,68374,68440,68465,68490,68506,68664,68766,68949,69023,69049,69098,69115,69117,69178,69185,69280,69306,69308,90003006);

	@header= (@header, ':content_file'=>"offices_html/$count.gz");
	$count++;
		
	$res = $ua->post('http://www.wfrmls.com/reports/roster/office/index.wfr',
		['Search'=>'roster/office/index.wfr',
		'OrderBy'=>'Order by r_office.officeid',
		#'Parameters'=>'state=&offactive=1&offcity=Provo&',
#		'ListNum'=>'0,17507,67890,69023,68440,69185,39685,33749,37906,55442,59028,36327,40734,68506,13318,49032,59374,28240,68465,24464,46646,68084,69178,57801,68664,32098,42577,37457,68226,50815,32424,54948,67993,68090,69049,19960,56615,68949,44939,38990,68490,69280,69098,68374,59036,69117,58262,3709,30371,68766,30812,34131,42375,69306,69115,55927,68252,37820,90003006,69308,43836,1195,61044,62351,49491,45490,68333',
		'ListNum'=>$listnums,
		'State'=>'',
		'frmReport'=>'pick',
		'menu.x'=>'159',
		'menu.y'=>'10',
		'CheckNum[]'=>\@list_ids],
		@header); 

	sleep(2);
}
