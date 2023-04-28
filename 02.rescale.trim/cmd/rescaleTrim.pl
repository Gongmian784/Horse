#!/usr/bin/perl

use Cwd;
use POSIX;

my $line;
my $minimum = 0.00000001;

my $folder = $ARGV[0];
my $filem = $ARGV[0].'misincorporation.txt';

### PARSING MAPDAMAGE COUNTS

my $counts;
my $max = 0;

open(FILE,"<$filem");
while ( $line = <FILE> ) {
	chomp($line);
	unless ( ( $line =~ m/^#/) || ( $line =~ m/^Chr/) ) {
		my @temp = split(/\t/,$line);
		$counts{$temp[1]}->{$temp[3]}->{'GA'} += $temp[9];
		$counts{$temp[1]}->{$temp[3]}->{'CT'} += $temp[10];
		$counts{$temp[1]}->{$temp[3]}->{'AG'} += $temp[11];
		$counts{$temp[1]}->{$temp[3]}->{'TC'} += $temp[12];
		$counts{$temp[1]}->{$temp[3]}->{'AC'} += $temp[13];
		$counts{$temp[1]}->{$temp[3]}->{'AT'} += $temp[14];
		$counts{$temp[1]}->{$temp[3]}->{'CG'} += $temp[15];
		$counts{$temp[1]}->{$temp[3]}->{'CA'} += $temp[16];
		$counts{$temp[1]}->{$temp[3]}->{'TG'} += $temp[17];
		$counts{$temp[1]}->{$temp[3]}->{'TA'} += $temp[18];
		$counts{$temp[1]}->{$temp[3]}->{'GC'} += $temp[19];
		$counts{$temp[1]}->{$temp[3]}->{'GT'} += $temp[20];
		$counts{$temp[1]}->{$temp[3]}->{'A'} += $temp[4];
		$counts{$temp[1]}->{$temp[3]}->{'C'} += $temp[5];
		$counts{$temp[1]}->{$temp[3]}->{'G'} += $temp[6];
		$counts{$temp[1]}->{$temp[3]}->{'T'} += $temp[7];
		if ( $temp[3] >= $max ) { $max = $temp[3]; }
		}
	}
close(FILE);

# CALCULATING ERROR RATE CT GA others

my @subst = ('GA','CT','AG','TC','AC','AT','CG','CA','TG','TA','GC','GT');
my @base  = ('G', 'C', 'A', 'T', 'A', 'A', 'C', 'C', 'T', 'T', 'G', 'G');

my %freq;
my %oth_n; # NUMERATOR OF NON-DEAM SUBST
my %oth_d; # DENOMINATOR OF NON-DEAM SUBST

my %obj1;
my %obj2;

foreach my $p ('3p','5p') {
	foreach my $i (0..scalar(@subst)-1) {
		if ( ( $subst[$i] eq 'CT' ) || ( $subst[$i] eq 'GA' ) ) {
			foreach my $position ( 1..$max ) {	
				unless ( $counts{$p}->{$position}->{$base[$i]} == 0 ) {
					my $val = $counts{$p}->{$position}->{$subst[$i]} / $counts{$p}->{$position}->{$base[$i]};
					$freq{$p}->{$subst[$i]}->{$position} = $val;
					}
				}
			}
		unless ( ( ($subst[$i] eq 'CT' ) && ( $p eq '5p' ) ) || ( ( $subst[$i] eq 'GA' ) && ( $p eq '3p') ) ) {
			foreach my $position ( 1..$max ) {
				$obj1{$p}->{$position} += $counts{$p}->{$position}->{$subst[$i]};
				$obj2{$p}->{$position} += $counts{$p}->{$position}->{$base[$i]};
				}
			}
		}
	}

foreach my $position ( 1..$max ) {
	if ( $counts{'5p'}->{$position}->{'C'} == 0 ) {
		print "$position\t0\n"; #MIAN: base count = 0
		}
	else {
		print "$position\t$freq{'5p'}->{'CT'}->{$position}\n";
		}
	}

foreach my $position ( 1..$max ) {
	if ( $counts{'3p'}->{$position}->{'G'} == 0 ) {
		print "$position\t0\n"; #MIAN: base count = 0
		}
	else {
		print "$position\t$freq{'3p'}->{'GA'}->{$position}\n";
		}
	}

foreach my $position ( 1..$max ) {
	if ( $obj2{'5p'}->{$position} > 0 ) {
		my $var = $obj1{'5p'}->{$position} / $obj2{'5p'}->{$position};
		print "$position\t$var\n";
		}
	else {
		print "$position\t0\n";
		}
	}

foreach my $position ( 1..$max ) {
	if ( $obj2{'3p'}->{$position} > 0 ) {	
 	       my $var = $obj1{'3p'}->{$position} / $obj2{'3p'}->{$position};
        	print "$position\t$var\n";
		}
	else {
                print "$position\t0\n";
                }
        }

exit;

