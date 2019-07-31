#!/usr/bin/perl
use feature 'say';
use strict; use warnings;

open my $fh, '<', 'zakukozh.bin' or die "Can't open file $!";
read $fh, my $file_content, -s $fh;
close($fh);

$| = 1;
for my $aa (0..256) {
  for my $bb (0..256) {
    print "\e[1K\r";
    printf("bruteforcing, a: %3d, b: %3d", $aa, $bb);
    
    my @arr = unpack('C*', $file_content);
    my $str = join '', map { chr( ($aa * ( $_ - $bb ) ) % 256 ) } @arr;

    if(grep(/^.PNG/, $str)) {
      open(my $fh, '>', "decoded_${aa}_${bb}.png");
      say "\t FOUND PNG";
      print $fh $str;
      close($fh);
    }
  }
}
print "\e[1K\rc0c0\n";
