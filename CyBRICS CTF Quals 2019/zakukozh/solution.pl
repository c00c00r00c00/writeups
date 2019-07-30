#!/usr/bin/perl
use feature 'say';

for my $aa (0..256) {
  for my $bb (0..256) {
    $str = '';
    open (FILE1, "zakukozh.bin"); 
    while ( read(FILE1,$byte,1) ) {
      $i = unpack('C', $byte);
      $c = chr( ( $aa * ( $i - $bb) ) % 256);
      $str.=$c;
    }
    close(FILE1);
    if(grep(/PNG/, $str)) {
      open(my $fh, '>', "decoded_${aa}_${bb}.png");
      $res = pack('C*', $str);
      say "$aa - $bb";
      print $fh $str;
      close($fh);
    }
  }
}
