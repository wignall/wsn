#!/usr/bin/perl

use Encode;
use DBI;
use strict;

`mysql -u ggathrig --password=9521304 < listings_table08.sql`;
my $dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls08","ggathrig","9521304");


my @listings_table_fields=(acres,additinfo,area,backdim,bsmntfin,city,compbac,compdays,compsac,contact,contph1,contph2,contractdt,county,crprtcap,daysonmkt,deck,dirpost,dirpre,dvr,entrdby,entrydt,ewcoord,expdtdisp,frontage,garagcap,hoafee,housenbr,irregular,latitude,listdt,listno,listtype,longitude,lstprice,nscoord,numdish,numdispose,numovrng,numrefg,offmktdt,openhsedt,owner,p1bar,p1bed,p1bthfull,p1bthhalf,p1bthtq,p1famden,p1fire,p1formal,p1kitch,p1laundry,p1rent,p1semiform,p1sqf,p2bar,p2bed,p2bthfull,p2bthhalf,p2bthtq,p2famden,p2fire,p2formal,p2kitch,p2laundry,p2rent,p2semiform,p2sqf,p3bar,p3bed,p3bthfull,p3bthhalf,p3bthtq,p3famden,p3fire,p3formal,p3kitch,p3laundry,p3rent,p3semiform,p3sqf,p4bar,p4bed,p4bthfull,p4bthhalf,p4bthtq,p4famden,p4fire,p4formal,p4kitch,p4laundry,p4rent,p4semiform,p4sqf,p5bar,p5bed,p5bthfull,p5bthhalf,p5bthtq,p5famden,p5fire,p5formal,p5kitch,p5laundry,p5rent,p5semiform,p5sqf,patio,possess,proptype,publicid,quadrant,reinstdt,remarks,rmpricelow,rstrct,schother,sidedim,slagentid,slagentpub,sldofcid,slrpaidcns,solddt,soldprice,soldterms,statcode,statdate,state,status,street,strtype,style,subagncy,subdiv,taxes,taxid,timeclause,totairelc,totairevp,totairgas,totairpmp,totairsol,totairwelc,totbar,totbed,totbthful,totbthhal,totbth,totbthtq,totfamrm,totfire,totformal,totkitch,totldy,totrent,totsemi,totsqf,totwinevp,undrcnst,unitnbr,winele1,winele2,winele3,winele4,winevp1,winevp2,winevp3,winevp4,withdrdt,yearblt,zip,zoning);
my @files =`ls /home/ggathrig/_research/data/wfrmls/data_listings/exported08/`;
open F_OUT2, ">redo";
foreach(@files){
#	print "$_";
	chomp;
	my $file=$_;
	`gzip -cd9 /home/ggathrig/_research/data/wfrmls/data_listings/exported08/$_ > /home/ggathrig/_research/data/wfrmls/data_listings2db/temp_csv/$_.csv`;
	open F_IN, "<:encoding(cp437)", "/home/ggathrig/_research/data/wfrmls/data_listings2db/temp_csv/$_.csv";
	my $first = 1;
	my $flag = 0;
    my @header;
	while(<F_IN>){
		if(/^<html>$/){last}	
		chomp;
		if ($flag){
			$_=$part." $_";
			$flag=0;
		}
		if (/([^'])$/){
			$part = $_;
			$flag=1;
			next;
		}
		my @listings_table_values=();
		my @listings_table_fields2insert=();
		s/^'//;
		s/'$//;
		my @columns= split /','/;
		if($first){
			$first = 0;
			my $count=0;
			foreach(@columns){
				$header{lc($_)}=$count++;
			}
			next;
		}
		else{
			$columns[$header{'compbac'}] =~ s/%//;
			$columns[$header{'compsac'}] =~ s/%//;
			$columns[$header{'contractdt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'entrydt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'expdtdisp'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'listdt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'offmktdt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'reinstdt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'solddt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'withdrdt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'openhsedt'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'statdate'}] =~ s/(\d\d)\/(\d\d)\/(\d\d\d\d)/\3\1\2/;
			$columns[$header{'irregular'}] =~ s/YES/1/i;
			$columns[$header{'irregular'}] =~ s/NO/0/i;
			$columns[$header{'undrcnst'}] =~ s/YES/1/i;
			$columns[$header{'undrcnst'}] =~ s/NO/0/i;
			$columns[$header{'lstprice'}] =~ s/,//;
			$columns[$header{'soldprice'}] =~ s/,//;
			$columns[$header{'publicid'}] =lc($columns[$header{'publicid'}]);
			$columns[$header{'slagentpub'}] =lc($columns[$header{'slagentpub'}]);
			
			foreach(@listings_table_fields){
				if($columns[$header{$_}] eq ''){next}
				$columns[$header{$_}] =~ s/\\/\\\\/g;
				$columns[$header{$_}] =~ s/"/\\"/g;
				if(/p\d/){
					$columns[$header{$_}] =~ s/Y/1/i;
					$columns[$header{$_}] =~ s/N/0/i;
				}
				if(/sqf/){
					$columns[$header{$_}] =~ s/,//;
				}
				if(/\w/){
					$columns[$header{$_}] = "\"$columns[$header{$_}]\"";
				}
				push(@listings_table_values,$columns[$header{$_}]);
				push(@listings_table_fields2insert,$_);
		
			}
			
		#	print "$columns[$header{'listno'}]\n";
        	$command = "INSERT INTO wfrmls08.listings (".join(',',@listings_table_fields2insert).") VALUES (".join(',',@listings_table_values).")";
        	$rowsaffected=$dbh->do($command);
			#check for duplication problem
			if(not $rowsaffected){
				print F_OUT2 "$file\n";
				last;
			}
		}
	}
}

$dbh->disconnect;
