# /usr/bin/perl
use warnings;
use strict;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new();

my @header=(
	'Host'=>'www.wfrmls.com',
	'User-Agent'=>'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.5) Gecko/20070713 Firefox/2.0.0.5',
	'Accept'=>'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
	'Accept-Language'=>'en-us,en;q=0.5',
	'Accept-Encoding'=>'gzip,deflate',
	'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
	'Keep-Alive'=>'300',
	'Connection'=>'keep-alive',
	'Referer'=>'http://www.wfrmls.com/searches/full/res/full_res_main.wfr',
    'Cookie'=>'USERAGENT=2; PASSWORD=qdam; AGTRIGHTS=2; LOGONNAME=gatgra; USERNAME=99010295; AGTOFFICEID=9900000; timeBomb=1220746318; KICKOUT=0; cookie=1; PHPSESSID=49fc837851c4b59bb55498e28e4c8125',
	'Content-Type' => 'application/x-www-form-urlencoded',
	'Content-Length' => '2108',
);

sub post{
	my ($date,$s_ndx,$p_ndx,$y_ndx) =@_;
	my $count=0;
	my @status=([],[1],[3,4,5,6],[8]);
	my @ptype=([],[1],[2],[16,32]);
	my @yearblt=([,],[1994,],[1995,1999],[2000,]);
    my ($maxyear,$minyear) =$yearblt[$y_ndx];
	my $date1=$date;
	$date1 =~ s/-//g;
	my $filename="$date1-$s_ndx-$p_ndx-$y_ndx";
	my @header0= (@header, ':content_file' => "listnums2/$filename");
	my $redo=1;
	my $attempts=0;
	while($redo){
		my $response = $ua->post('http://www.wfrmls.com/searches/full/count.wfr',
		[
			'Search'=>'full%2Fres%2Findex.wfr',
			'propclass'=>'1',
			'ptype'=>'res',
			'prospid'=>'587049',
			'act'=>'load',
			'state'=>'ut',
			'status[]'=>\@{$status[$s_ndx]},
			'proptypebit[]'=>\@{$ptype[$p_ndx]},
			'listdt1'=>$date,
			'listdt2'=>$date,
			'history'=>'1',
            'yearblt1'=>$minyear,
            'yearblt2'=>$maxyear,
			'x'=>'34',
			'y'=>'13'
			],@header0);
		sleep(20);

		if(not $response->is_success){
			$attempts++;
		}
		elsif($attempts>3){
			print F_OUT join(',',@_).'\n';
			$redo=0;
		}
		else{	
			$redo=0;
			$_ = `gzip -cd9 listnums2/$filename`;
			if (/Limit search to/){
				return 0;
			}
		}
	}
	return 1;
}

open F_CAL, "cal";
open F_OUT, ">redo2";
while (<F_CAL>){
	chomp;
	m/(\d\d\d\d)(\d\d)(\d\d)\s(\d+)/;
	if($1==2008 and $2==8){last}
	my $date = "$1-$2-$3";	
    &breakup($date,-1,0,0,0);
}
    
sub breakup{
    my ($date,$flag,@ndx)=@_;
    if($flag>2){die "Problem with $date @ndx";}
    if(&post($date,@ndx) ){return}
    else{$flag++}
    foreach(1..3){
        $ndx[$flag]=$_;
        &breakup($date,$flag,@ndx);
    }
}
