#! /usr/bin/perl

use HTML::TreeBuilder;
use DBI;

`mysql -u ggathrig --password=1Nephi11 < par_tables.sql`;
$dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls","ggathrig","1Nephi11");

@files = `ls "/home/ggathrig/data/wfrmls/par/reports/Salt\ Lake/"`;
foreach(@files){
	chomp;
	/([^.]+).gz/;
	$command = "INSERT INTO wfrmls.par (taxid,par) VALUES ('$1','')";
	$rowsaffected=$dbh->do($command);
	$temp=`gzip -cd9 "/home/ggathrig/data/wfrmls/par/reports/Salt\ Lake/$_"`;
	my $root = HTML::TreeBuilder->new_from_content($temp);
	my @tr=$root->find_by_tag_name('tr');
	foreach (@tr){
		if(defined $_->attr("bgcolor")){
			@record = ();
			@kids= $_->content_list();
			foreach (@kids){
				$temp= $_->as_text();
				$temp =~s/(\d\d)\/(\d\d)\/(\d\d)/\3-\1-\2/;
				$temp =~s/\s+$//;
				$temp ="'$temp'";
				push @record, $temp;
			}
			$command = "INSERT INTO wfrmls.changes (listno,taxid,office,changedt,changedby,field,oldvalue,newvalue) VALUES (".join(',',@record).")";
			$rowsaffected=$dbh->do($command);

		}
	}
	$root->delete();
#	print $_."\n";
}
