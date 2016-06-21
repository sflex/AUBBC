# BBcode_Config.pl
# The fastest way to configure bbcodes. add_tag seems to drop speed more.
# Configuration File for AUBBC2
# - Customize internal regex, settings and BBcode tags
# Customize internal regex and names for message and attribute
%REGEX = (
 href => qr'[a-z]+\://[\w\.\/\-\~\@\:\;\=]+(?:\?[\w\~\.\;\:\,\$\-\+\!\*\?/\=\&\@\#\%]+?)?',
 src  => qr'[a-z]+\://[\w\.\/\-\~\@\:\;\=]+|\/[\w\.\/\-\~\@\:\;\=]+',
 any  => qr'.+?', # not for very deep multiple line matching
 any_line  => qr'(?s).+?', # deep multiple line matching
 );
 
# Hardcoded BBcode tags
# The function will not be checked as it does in add_tag.
# message and attribute will not change names src to regex
# Does all the tags AUBBC can do better.
@TAGS = (
  { # This is the first tag to parse, so tag ID would be 0
  'tag' => 'aubbc_escape', # useless name for strip type
  'type' => 'strip', # have to set a type for it to parse
  'link' => 0, # could be used for any type
  'group' => 'bbcode', # bbcode group
# becuase this does about the same as #bbcode bypass but single tags
  'security' => 0,
  'error' => '',# convert ]] to ]
  'description' => 'This tag can be used to escape tags so you can type [[http://place.com]] and that tag will not convert, will not convert //]]> pattern.',
  'function' => '', # can be used to expand strip and can do swap
  'message' => qr'(?<!\/\/})\]\](?!>)', # what we use to match with strip type
  'attribute' => '', # not used in strip type
  'markup' => '%]temp]%&#93;', # output if function swap wasnt used
 },
  {
  'tag' => 'aubbc_escape',
  'type' => 'strip',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'This tag can be used to escape tags so you can type [[http://place.com]] and that tag will not convert.',
  'function' => '',# convert [[ to [
  'message' => qr'\[\[',
  'attribute' => '',
  'markup' => '%[temp[%&#91;',
 },
 {
 'tag' => qr'code|c', # tag names to look for
  'type' => 'balanced',
  'link' => 1, # would not parse well in a html link
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'Code tag, used to display programing codes.',
  'function' => \&code_highlight,
  'message' => $REGEX{any_line},
  'attribute' => '', # this tag has no attribute
  'markup' => '<div%code_class%><code>
%{message}
</code></div>%code_extra%',
 },
  {
 'tag' => qr'code|c',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'Code tag, used to display programing codes.',
  'function' => \&code_highlight,
  'message' => $REGEX{any_line},
  'attribute' => $REGEX{any},
  'markup' => '# %{attribute}:<br%html_type%>
<div%code_class%><code>
%{message}
</code></div>%code_extra%',
 },
  {
 'tag' => qr'url',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'URL tag, used to place a link.',
  'function' => '',   # \&BBcode_sub::fix_message
  'message' => $REGEX{any},
  'attribute' => $REGEX{href},
  'markup' => '<a href="%{attribute}"%href_target%%href_class%>%{message}</a>',
 },
  {
 'tag' => qr'url',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'URL tag, used to place a link.',
  'function' => '', # \&BBcode_sub::fix_url
  'message' => $REGEX{href},
  'attribute' => '',
  'markup' => '<a href="%{message}"%href_target%%href_class%>%{message}</a>',
 },
  {
 'tag' => qr'color',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'Color tag, change text color.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => qr'[\w#]+',
  'markup' => '<div style="color:%{attribute};">%{message}</div>',
 },
  {
 'tag' => qr'email', # this is not by current standards
  'type' => 'strip',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'Strips emails based on old email standards.',
  'function' => '',
  'message' => qr'\[email\](?![a-z\.\-\&\+]+\@[a-z\.\-]+).+?\[\/email\]',
  'attribute' => '',
  'markup' => '[<font color=red>Error</font>]email',
 },
   {
 'tag' => qr'email', # this is not by current standards
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'Converts emails based on old email standards.',
  'function' => \&protect_email,
  'message' => qr'[a-z\.\-\&\+]+\@[a-z\.\-]+',
  'attribute' => '',
  'markup' => '',
 },
  {
 'tag' => qr'li',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'li tag for number lists.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => qr'\d+',
  'markup' => '<li value="%{attribute}">%{message}</li>',
 },
  {
 'tag' => qr'u',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'u tag underline text.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => '',
  'markup' => '<div style="text-decoration: underline;">%{message}</div>',
 },
  {
 'tag' => qr'strike',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'strike tag strike through text.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => '',
  'markup' => '<div style="text-decoration: line-through;">%{message}</div>',
 },
  {
 'tag' => qr'center|left|right',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'left right and center tags for text align.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => '',
  'markup' => '<div style="text-align: %{tag};">%{message}</div>',
 },
  {
 'tag' => qr'quote',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'quote tag [quote=Smith]Some thing Smith said.[/quote].',
  'function' => '',
  'message' => $REGEX{any_line},
  'attribute' => qr'[\w\s]+',
  'markup' => '<div%quote_class%><small><strong>%{attribute}:</strong></small><br%html_type%>
%{message}
</div>%quote_extra%',
 },
  {
 'tag' => qr'quote',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'quote tag [quote]Some thing said.[/quote].',
  'function' => '',
  'message' => $REGEX{any_line},
  'attribute' => '',
  'markup' => '<div%quote_class%>%{message}</div>%quote_extra%',
 },
  {
 'tag' => qr'img|right_img|left_img',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'img, right_img, left_img tags display an image.',
  'function' => \&fix_image,
  'message' => $REGEX{src},
  'attribute' => '',
  'markup' => '',
 },
  {
  'tag' => qr'blockquote|big|h[123456]|[ou]l|li|em|pre|s(?:mall|trong|u[bp])|[bip]',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'A big mix of text manipulation tags.',
  'function' => '',
  'message' => $REGEX{any_line},
  'attribute' => '',
  'markup' => '<%{tag}>%{message}</%{tag}>',
 },
  {
  'tag' => qr'br|hr',
  'type' => 'single',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'br line break and hr thematic break tags.',
  'function' => '',
  'message' => '', # not used for single type
  'attribute' => '', # not used for single type
  'markup' => '<%{tag}%html_type%>',
 },
  {
  'tag' => qr'video',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'video tag.',
  'function' => '',
  'message' => $REGEX{src},
  'attribute' => '-|width/n\{90-120\},height/n\{60-90\}',
  'markup' => '<video width="X{width}" height="X{height}" controls="controls">
<source src="%{message}" type="video/mp4" />
Your browser does not support the video tag.
</video>',
 },
  {
  'tag' => qr'mp4',
  'type' => 'balanced',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'mp4 tag, just another video tag.',
  'function' => '',
  'message' => $REGEX{src},
  'attribute' => '-|mp4/n\{90-120\},width/n\{90-120\}',
  'markup' => '<video width="X{width}" height="X{mp4}" controls="controls">
<source src="%{message}" type="video/mp4" />
Your browser does not support the video tag.
</video>',
 },
  {  # 1st
  'tag' => qr'https?|ftp',
  'type' => 'linktag',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'http,https or ftp link tags with name option [ftp://a.com|name].',
  'function' => '',
  'message' => qr'(?!&#124;).+?',
  'attribute' => $REGEX{any},
  'markup' => '<a href="%{tag}://%{message}"%href_target%%href_class%>%{attribute}</a>',
 },
  {  # 2nt
  'tag' => qr'https?|ftp',
  'type' => 'linktag',
  'link' => 1,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'http,https or ftp link tags [ftp://a.com].',
  'function' => '',
  'message' => qr'[\w\.\/\-\~\@\:\;\=]+(?:\?[\w\~\.\;\:\&\,\$\-\+\!\*\?/\=\@\#\%]+?)?',
  'attribute' => '',
  'markup' => '<a href="%{tag}://%{message}"%href_target%%href_class%>%{tag}&#58;//%{message}</a>',
 },
  {
  'tag' => qr'utf',
  'type' => 'linktag',
  'link' => 0,
  'group' => 'utf',
  'security' => 0,
  'error' => '',
  'description' => 'utf tags [utf://#x263a] to show html entities.',
  'function' => '',
  'message' => qr'\#?\w+',
  'attribute' => '',
  'markup' => '&%{message};',
 },
  {
  'tag' => 'aubbc_escape',
  'type' => 'strip',
  'link' => 0,
  'group' => 'filter',
  'security' => 0,
  'error' => '',
  'description' => 'removes the temp escape mark.',
  'function' => '',
  'message' => qr'\%[\[\]]temp[\[\]]\%',
  'attribute' => '',
  'markup' => '',
 },
  {
  'tag' => qr'boom',
  'type' => 'balanced',
  'link' => 0,
  'group' => 'bbcode',
  'security' => 0,
  'error' => '',
  'description' => 'boom tags used to test attribute range matching. Can be removed.',
  'function' => '',
  'message' => $REGEX{any},
  'attribute' => '-|boom/w\{9500\},bam/w\{9000\}',
  'markup' => '===X{boom}<br />
==X{bam}<br />%{message}',
 },
  {
  'tag' => qr'sec1',
  'type' => 'single',
  'link' => 0,
  'group' => 'smileys',
  'security' => 1,
  'error' => ' ',
  'description' => 'Security Test, level and remove tag',
  'function' => '',
  'message' => '',
  'attribute' => '',
  'markup' => '%{tag}',
 },
  {
  'tag' => qr'sec2',
  'type' => 'single',
  'link' => 0,
  'group' => 'smileys',
  'security' => 2,
  'error' => '',
  'description' => 'Security Test, level and dont change tag',
  'function' => '',
  'message' => '',
  'attribute' => '',
  'markup' => '%{tag}',
 },
  {
  'tag' => qr'sec3',
  'type' => 'single',
  'link' => 0,
  'group' => 'smileys',
  'security' => 0,
  'error' => '',
  'description' => 'a smiley',
  'function' => '',
  'message' => '',
  'attribute' => '',
  'markup' => '&#x263a;',
 },
  {
  'tag' => 'some_name',
  'type' => 'strip',
  'link' => 0,
  'group' => 'filter',
  'security' => 0,
  'error' => '',
  'description' => 'a test',
  'function' => \&test_strip,
  'message' => qr'%%tag%%',
  'attribute' => '',
  'markup' => '',
 },
  {
  'tag' => 'some_name',
  'type' => 'strip',
  'link' => 0,
  'group' => 'filter',
  'security' => 0,
  'error' => '',
  'description' => 'a test',
  'function' => \&test_strip_swap,
  'message' => qr'%%swap%%',
  'attribute' => '',
  'markup' => '',
 }
);# END @TAGS

# Tags main %setting% hash
%AUBBC        = (
    image_hight         => '60',
    image_width         => '90',
    image_border        => '0',
    image_wrap          => ' ',
    highlight           => 1, # ...
    html_type           => ' /',
    href_target         => ' target="_blank"',
    code_download       => '^Download above code^',
    href_class          => '',
    code_class          => ' class="codepost"',
    code_extra          => '<div style="clear: left"> </div>',
    quote_class         => ' class="border"',
    quote_extra         => '<div style="clear: left"> </div>',
    email_message       => '&#67;&#111;&#110;&#116;&#97;&#99;&#116;&#32;&#69;&#109;&#97;&#105;&#108;',
    icon_image          => 0,
    highlight_class1    => ' class="highlightclass1"',
    highlight_class2    => ' class="highlightclass2"',
    highlight_class3    => ' class="highlightclass1"',
    highlight_class4    => ' class="highlightclass1"',
    highlight_class5    => ' class="highlightclass5"',
    highlight_class6    => ' class="highlightclass6"',
    highlight_class7    => ' class="highlightclass7"',
    highlight_class8    => ' class="highlightclass5"',
    highlight_class9    => ' class="highlightclass5"',
    );

# Test if function works for strip type
sub test_strip {
my ($type, $tag, $message, $markup, $extra, $attrs) = @_;
# message is what was matched and if there is markup with tags
# then it will change those markup tags
return ($message, 'Test 1 %{message} -image_hight-> %image_hight%');
}

# Test if function swap works for strip type
sub test_strip_swap {
my ($type, $tag, $message, $markup, $extra, $attrs) = @_;
# message is what was matched,
# markup needs to be '' blank in the @TAGS[#]{markup} or set in here for swap to work.
return ('Swap Me then this will not change %{message} -image_hight-> %image_hight% this is what you need to know about swap.', $markup);
}

sub protect_email {
 my ($type, $tag, $email, $markup, $extra, $attrs) = @_;
 my $option = 4;
 my @key64   = ('A'..'Z','a'..'z',0..9,'+','/'); # protect email tag
 my ($email1, $email2, $ran_num, $protect_email, @letters) = ('', '', '', '', split ('', $email));
 $protect_email = '[' if $option eq 3 || $option eq 4;
 foreach my $character (@letters) {
  $protect_email .= '&#' . ord($character) . ';' if ($option eq 1 || $option eq 2);
  $protect_email .= ord($character) . ',' if $option eq 3;
  $ran_num = int(rand(64)) || 0 if $option eq 4;
  $protect_email .= '\'' . (ord($key64[$ran_num]) ^ ord($character)) . '\',\'' . $key64[$ran_num] . '\',' if $option eq 4;
 }
 return ("<a href=\"&#109;&#97;&#105;&#108;&#116;&#111;&#58;$protect_email\">$protect_email</a>",'') if $option eq 1;
 ($email1, $email2) = split ("&#64;", $protect_email) if $option eq 2;
 $protect_email = "'$email1' + '&#64;' + '$email2'" if $option eq 2;
 $protect_email =~ s/\,\z/]/ if $option eq 3 || $option eq 4;
 return ("
<a href=\"javascript:MyEmCode('$option',$protect_email);\">&#67;&#111;&#110;&#116;&#97;&#99;&#116;&#32;&#69;&#109;&#97;&#105;&#108;</a>
", '') if $option eq 2 || $option eq 3 || $option eq 4;
}

# will be moved
#sub js_print {
#my $self = shift;
#print <<'JS';
#Content-type: text/javascript

#/*
#Fully supports dynamic view in XHTML.
#*/
#function MyEmCode (type, content) {
# var returner = false;
# if (type == 4) {
# var farray= new Array(content.length,1);
#  for(farray[1];farray[1]<farray[0];farray[1]++) {
#   returner+=String.fromCharCode(content[farray[1]].charCodeAt(0)^content[farray[1]-1]);farray[1]++;
#  }
# } else if (type == 3) {
#  for (i = 0; i < content.length; i++) { returner+=String.fromCharCode(content[i]); }
# } else if (type == 2) { returner=content; }
# if (returner) { window.location='mailto:'+returner; }
#}
#JS
#exit(0);
#}
# this was a fix, if you had an encoding that
# converter bear URL's. so that the message would not get
# converted as a link. making a double link.
# Converting bear URL's is not a good idea, because
# if the user ment to type "some://thing.then other stuff"
# it would make a link out of it.
# the better way is to just bracket around what you want
# as a link [https://www.google.com]. Then we dont have to
# program around so much junk.
#sub fix_message { #not used
# my ($type, $tag, $txt, $markup, $extra, $attrs) = @_;
# $txt =~ s/\./&#46;/g;
# $txt =~ s/\:/&#58;/g;
# return ($txt, $markup);
#}
#sub fix_url { # not used
# my ($type, $tag, $txt, $markup, $extra, $attrs) = @_;
# $markup =~ s/%\{message}/$txt/;
# $txt =~ s/\./&#46;/g;
# $txt =~ s/\:/&#58;/g;
# $markup =~ s/%\{message}/$txt/;
# $txt = '';
# return ($txt, $markup);
#}
my @code_comp = (
qr'(?:%\[temp\[%|\[)',
qr'(?:%\]temp\]%|\])',
qr'(&#60;&#60;(?:&#39;)?(\w+)(?:&#39;)?&#59;(?s)[^\2]+\b\2\b)',
qr'(?<![\&\$])(\#.*?(?:<br \/>))',
qr'(\bsub\b(?:\s+))(\w+)',
qr'(\w+(?:\-&#62;)?(?:\w+)?&#40;(?:.+?)?&#41;(?:&#59;)?)',
qr'((?:&amp;)\w+&#59;)',
qr'(&#39;(?s).*?(?<!&#92;)&#39;)',
qr'(&#34;(?s).*?(?<!&#92;)&#34;)',
qr'(?<![\#|\w])(\d+)(?!\w)',
qr'(&#124;&#124;|&amp;&amp;|\b(?:strict|package|return|require|for|my|sub|if|eq|ne|lt|ge|le|gt|or|xor|use|while|foreach|next|last|unless|elsif|else|not|and|until|continue|do|goto)\b)',
qr'(?<!&#92;)((?:&#37;|\$|\@)\w+(?:(?:&#91;.+?&#93;|&#123;.+?&#125;)+|))'
);
sub code_highlight {
my $type = shift;
my $tag = shift;
local $_ = shift;
my $markup = shift;
my $extra = shift;
my $attrs = shift;
 s[:][&#58;]g;
 # aubbc_escape change back for code
 s[$code_comp[0]][&#91;]g;  #$code_comp[0]
 s[$code_comp[1]][&#93;]g;
 s[\{][&#123;]g;
 s[\}][&#125;]g;
 s[%][&#37;]g;
 s[(?<!>)\n][<br \/>\n]g;
 if ($AUBBC{highlight}) {
  s[\z][<br \/>] unless m'<br \/>\z';
  s[$code_comp[2]][<span$AUBBC{highlight_class1}>$1<\/span>]g;
  s[$code_comp[3]][<span$AUBBC{highlight_class2}>$1<\/span>]g;
  s[$code_comp[4]][$1<span$AUBBC{highlight_class8}>$2<\/span>]g;
  s[$code_comp[5]][<span$AUBBC{highlight_class9}>$1<\/span>]g;
  s[$code_comp[6]][<span$AUBBC{highlight_class9}>$1<\/span>]g;
  s[$code_comp[7]][<span$AUBBC{highlight_class3}>$1<\/span>]g;
  s[$code_comp[8]][<span$AUBBC{highlight_class4}>$1<\/span>]g;
  s[$code_comp[9]][<span$AUBBC{highlight_class5}>$1<\/span>]g;
  s[$code_comp[10]][<span$AUBBC{highlight_class6}>$1<\/span>]g;
  s[$code_comp[11]][<span$AUBBC{highlight_class7}>$1<\/span>]g;
 }
 return ($_, $markup);
}

sub fix_image {
my $type = shift;
my $tag = shift;
my $msg = shift;
my $markup = shift;
my $extra = shift;
my $attrs = shift;
#my ($type, $tag, $msg, $markup, $extra, $attrs) = @_;
 if ($msg !~ m'\A\w+:\/\/|\/' || $msg =~ m'/\?|\#|\.\bjs\b\z'i) {
  $msg = "[<font color=red>BAD_MESSAGE</font>]$tag";
 }
  else {
  $tag = '' if $tag eq 'img';
  $tag = ' align="right"' if $tag eq 'right_img';
  $tag = ' align="left"' if $tag eq 'left_img';
  $msg = $AUBBC{icon_image}
   ? make_link($msg,make_image($tag,$msg,$AUBBC{image_width},
      $AUBBC{image_hight},'icon'),'',1).$AUBBC{image_wrap}
   : make_image($tag,$msg,'','','normal').$AUBBC{image_wrap};
 }
 return ($msg, '');

}

sub make_image {
my $align = shift;
my $src = shift;
my $width = shift;
my $height = shift;
my $alt = shift;
 my $img = "<img$align src=\"$src\"";
 $img .= " width=\"$width\"" if $width;
 $img .= " height=\"$height\"" if $height;
 return $img." alt=\"$alt\" border=\"$AUBBC{image_border}\"$AUBBC{html_type}>";
}

sub make_link {
 my $link = shift;
 my $name = shift;
 my $javas = shift;
 my $targ = shift;
 my $linkd = "<a href=\"$link\"";
 $linkd .= " onclick=\"$javas\"" if $javas;
 $linkd .= $AUBBC{href_target} if $targ;
 $linkd .= $AUBBC{href_class}.'>';
 $linkd .= $name ? $name : $link;
 return $linkd.'</a>';
}
1;
