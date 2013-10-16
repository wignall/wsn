#! /usr/bin/perl
use LWP::UserAgent;
use DBI;

my $ua = LWP::UserAgent->new();
$dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls","ggathrig","1Nephi11");

$query = 'select agentid from agentids';
$sth = $dbh->prepare($query);
$sth->execute();
$array_ref = $sth->fetchall_arrayref();
@ids=@$array_ref;
while(@ids){
	@list_ids=();
	for(1..200){
		$ref = pop @ids;
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
		'Referer'=>'http://www.wfrmls.com/reports/roster/agent/index.wfr',
		'Cookie'=>'PHPSESSID=0bda4b90a0fa7a0f2f106b44d12410a1; cookie=1; USERAGENT=2; timeBomb=1200529492; KICKOUT=0; AGTOFFICEID=9900000; USERNAME=99010295; LOGONNAME=gatgra; AGTRIGHTS=2; PASSWORD=mdogh; RptGrafs=No',
		'Content-Type'=>'application/x-www-form-urlencoded',
	);

	@header= (@header, ':content_file'=>"agents_html/$count.gz");
	$count++;
		
	$res = $ua->post('http://www.wfrmls.com/reports/roster/agent/index.wfr',
		['Search'=>'roster/agent/index.wfr',
		'ListNum'=>$listnums,
		'frmReport'=>'pick',
		'menu.x'=>'159',
		'menu.y'=>'10',
		'CheckNum[]'=>\@list_ids],
		@header); 

}
