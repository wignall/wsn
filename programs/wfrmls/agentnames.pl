#!/usr/bin/perl

use Encode;
use DBI;

$dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls","ggathrig","9521304");
$dbh->do("delete from wfrmls.list_agent_names");
$query = "INSERT INTO wfrmls.list_agent_names (listno,list_agent_name) VALUES (?,?)";
$sth=$dbh->prepare($query);
@files =`ls /home/ggathrig/research/data/wfrmls/data_listings2db/temp_csv/`;
foreach my $file (@files){
	chomp($file);
	print "$file\n";
	open F_IN, "<:encoding(cp437)", "/home/ggathrig/research/data/wfrmls/data_listings2db/temp_csv/$file";
	my $first=<F_IN>;
	if($first=~m/^<html>$/){next}	
	while(<F_IN>){
		chomp;
		s/^'|'$//;
		my @columns= split /','/;
		my ($listno,$name) = @columns[0,4];
		$name=~s/\s+/ /g;
		$name=~s/\"/\'/g;
		#if(not $name=~/\w/){next}
		$sth->execute($listno,$name);
	}
}
$dbh->disconnect;
