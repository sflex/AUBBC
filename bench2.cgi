#!perl
$| = 1;
use strict;
use warnings;

use lib '.';

my %loaded;

my $code = <<'EOM';
##smileys
[br][b]The Very common UBBC Tags[/b]
[[b]Bold[/b]] = [b]Bold[/b][br]
[[strong]Strong[/strong]] = [strong]Strong[/strong][br]
[[small]Small[/small]] = [small]Small[/small][br]
[[big]Big[[/big] = [big]Big[/big][br]
[[h1]Head 1[[/h1] = [h1]Head 1[/h1][br]
through.....[br]
[h6]]Head 6[[/h6] = [h6]Head 6[/h6][br]
[utf://#91]i]Italic[[/i] = [i]Italic[/i][br]
[[u]Underline[[/u] = [u]Underline[/u][br]
[b]More Tags[/b]
[[strike]Strike[[/strike] = [strike]Strike[/strike][br]
[left]]Left Align[[/left] = [left]Left Align[/left][br]
[utf://#91]center]Center Align[[/center] = [center]Center Align[/center][br]
[right]]Right Align[[/right] = [right]Right Align[/right][br]
[utf://#91]em]Emotion[/em]] = [em]Emotion[/em]
[sup]]Sup[/sup]] = [sup]Sup[/sup][br]
[sub]]Sub[/sub]] = [sub]Sub[/sub][br]
[pre]]Pre[utf://#91]/pre] = [pre]Pre[/pre][br]
[b]Image tags[/b]
[img]]http://www.google.com/intl/en/images/about_logo.gif[utf://#91]/img] =
[img]http://www.google.com/intl/en/images/about_logo.gif[/img]
[right_img]]http://www.google.com/intl/en/images/about_logo.gif[[/right_img] =
[right_img]http://www.google.com/intl/en/images/about_logo.gif[/right_img]
[left_img]]http://www.google.com/intl/en/images/about_logo.gif[[/left_img] =
[left_img]http://www.google.com/intl/en/images/about_logo.gif[/left_img][br]
[b]Link tags[/b]
[url]]http://www.google.com[utf://#91]/url] = [url]http://www.google.com[/url]
[url=URL]Name[/url] = [url=http://www.google.com]Google[/url]
[[https[utf://#58]//google.com]] = [https://google.com]
[[https[utf://#58]//google.com|Google]] = [https://google.com|Google]
[[ftp://google.com]] = [ftp://google.com]
[[ftp://google.com|ftp Google]] = [ftp://google.com|ftp Google][br]
[email]]Email[/email] = [email]some@email.com[/email] Recommended Not to Post your email in a public area[br]
[email]javascript:someMy();[/email] #bad
[b]Code Tags[/b]
[code]]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};[[/code] =[br]
[code]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};[/code][br]
[b]Code Tags[/b]
[c]]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};[/c]] =[br]
[c]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};[/c][br]
[[c=My Code]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};[/c]] =[br]
[c=My Code]# Some Code ......
my %hash = ( stuff => { '1' => 1, '2' => 2 }, );
print $hash{stuff}{'1'};1[[1[[2]]2]]?[/c][br][br]
[b]Quote Tags[/b]
[quote]]Some thing to Quote.[/quote]] = [quote]Some thing to Quote.[/quote][br]
[quote=Flex]]Some thing to Quote.[/quote]] = [quote=Flex]Some thing to Quote.[/quote][br]
[color=Red]]Color[/color]] = [color=Red]Color[/color][br]
[blockquote]]Your Text here[[/blockquote] = [blockquote]Your Text here[/blockquote]
[[hr] = [hr]
[list]
[*=1]stuff
[*]stuff2
[*]stuff3
[/list]

[ol]
[li=1].....[/li]
[li].....[/li]
[li].....[/li]
[/ol]

[b]Unicode Support[/b][br]
[[utf://#x3A3]] = [utf://#x3A3][br]
[utf://#x263a]] = [utf://#x263a][br]
[utf://#0931]] = [utf://#0931][br]
[utf://iquest]] = [utf://iquest][br]
[b]Other Stuff[/b]
[http://www.crap.com|dfsdff]
[http://www.crap.com]
[video width=120 height=90]http://www.www.com[/video] # good
[;video width=120 height=190]http://www.www.com[/video;] # bad
[video width=120 height=90 height=190]http://www.www.com[/video] # bad
[video width=5 height=60 controls=00]http://www.www.com[/video] # bad
[mp4=90 width=115]http://www.www.com[/mp4] # good

1) [img]/cgi-bin/001/index.tgi?op=clock;module=Clock[/img]
2) [right_img]/001/images/icon/xx.gif[/right_img]
3) [left_img]/001/images/icon/xx.gif[/left_img]

4) [email]ddsds@djdj.com[/email]
5) [email]www.ass.com?@dfsdfsdfsd.fdd[/email] # bad
6) [img]/crap/stuff.js[/img] bad
6) [img]/crap/stuff.js?pop=3[/img] bad
6) [img]/view-source:window.open();[/img] bad?
7) [right_img]javascript:window.open();[/right_img]
8) [email]javascript:window.open();[/email]
9) [url]javascript: window.open();[/url]
9) [url]http://192.168.5/cgi-bin/001/index.cgi[/url]
9) [url=http://192.168.5/cgi-bin/001/index.cgi]crap URL[/url]
9) [url=javascript:window.open();]javascript:window.open();[/url]
9) [url=http://192.168.5/cgi-bin/001/index.cgi]javascript:window.open();[/url]
9) [url]www.google.com[/url]
4)
4)

[color=#0000cc]Brown[/color]
[boom=e5-.:,!?_@+ bam= e342dsf \ ()|'"-<> 3424.:_,45435csf $ 33erdesr33* /fdsf sd! fsdfsdfs? 5+6 ]Test the bomb[/boom]
1)[sec1]
2)[sec2]
3)[sec3]
EOM

my $au2 = &create_au2;

my $rendered = "AUBBC2-v$loaded{AUBBC2}<br />\n";
 $rendered .= $au2->parse_bbcode($code)."<br />\n";
 $rendered .= $au2->tag_list('html')."<br />\n";
 $rendered .= "<br />\n<br />\nAUBBC Errors:<br />\n";
 $rendered .= $au2->script_escape($au2->error_message());
 $rendered .= "End<br />\n";
 my $smiley = chr(0x263a); #"\x{263a}"
 $rendered = <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Title of the document</title>
</head>

<body>
<p>$rendered</p>
<p>&#x263a; Test &#x543;
HTML
 my $rendered2 = <<HTML;
</p>
</body>

</html>
HTML

# Letf print the hole HTML5 in UTF-8
 use Encode qw{encode};
 binmode STDOUT, ":raw";
 # render header done above...
 # embed a Unicode character :)
 $rendered .= $smiley;
 # render footer
 $rendered .= $rendered2;
 # encode in utf-8
 $rendered = encode(utf8 =>$rendered);
 # Get length in bytes
 my $byte_count =  length($rendered);

print <<"HEADER";
Content-Length: $byte_count
Content-Type: text/html; charset=utf-8

HEADER

print $rendered;
exit;

sub create_au2 {

use AUBBC2;
$AUBBC2::CONFIG = 'C:\xampp\cgi-bin\Flex2\lib\AUBBC2\BBcode_Config.pl';
$AUBBC2::MEMOIZE = 1;
$AUBBC2::ACCESS_LOG = 1;


$loaded{AUBBC2} = AUBBC2->VERSION;
my $au2 = AUBBC2->new();

# Administrator, Guest
$au2->user_level('Guest');

return $au2;
}

