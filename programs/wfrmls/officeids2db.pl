#! /usr/bin/perl

use HTML::TreeBuilder;
use DBI;
use strict;

`mysql -u ggathrig --password=9521304 < table_officeids.sql`;
my $dbh=DBI->connect("DBI:mysql:host=localhost;database=wfrmls08","ggathrig","9521304");

my $query = "INSERT INTO wfrmls08.officeids (listno,list_id,sell_id,co_id,list_office,sell_office,list_name,sell_name,co_name,list_office_name,sell_office_name) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
my $sth=$dbh->prepare($query);

my @files = `ls officeids08/`;
foreach(@files){
	chomp;	
	my $content= `gzip -cd9 officeids08/$_`;
	my $root = HTML::TreeBuilder->new_from_content($content);
	my @tr=$root->find_by_tag_name('tr');
	foreach(@tr){
		if(defined $_->attr("bgcolor")){
			my @record;
			my @list=$_->content_list();
			my @text;
			foreach(@list){
				my $node = $_->look_down('href',qr/ListNum=(\d*)/);
				if( defined $node){
					my $href = $node->attr('href');
					$href =~ m/ListNum=(\d*)/;
					push @record, $1;
					push @text,$node->as_text();
				}
			}
			$sth->execute(@record,@text[1..$#text]);
		}
	}
	$root->delete();
	print $_."\n";
}
