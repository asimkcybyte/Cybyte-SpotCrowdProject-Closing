use strict;
use POSIX;
use HTTP::Cookies;
use LWP::UserAgent;
use HTML::Entities;
use WWW::Mechanize;
use URI::Escape;
use LWP::Simple;
use Encode qw(encode);
my $ua = LWP::UserAgent->new(show_progress=>1);
$ua->agent("Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0");
$ua->timeout(30);
$ua->cookie_jar({});
my $filename ="AA_indiegogo";
my $cookie_file = $filename."_cookie.txt";
unlink($cookie_file);
my $cookie = HTTP::Cookies->new(file=>$cookie_file,autosave=>1);
$ua->cookie_jar($cookie);
my $url = "https://www.indiegogo.com/explore?filter_browse_balance=true&filter_quick=popular_all";
my $content = &lwp_get($url);
open sr,">indiegogo.html";
print sr $content;
close sr;
open lk, ">".$filename."Output.csv";
#print lk "
# SNO\tName of Project\tName of project owner\tHow many updates\tHow many backers\tAll of the Backers or crowd funder names and emails\tBacker or crowd funder City and State\tHow many comments\tScrap the home project page content (this data will be sentiment analyzed) \tBacker or crowd funder City & State, and Country or Location\tCategory\tFunding Goal or Pledged Goal \tGauge Bar\tFunding Days Left or Days to Go\tFully Funded or Funded\tPerks\tPledge $2 or more, Pledge $5 or more, Pledge $20 or more, Pledge $25 or more, Pledge $35 or more, and etc…\tShare\tTwitter\tFace book Friends\tHow many people\tVideo link\tStaff Picks of that Site (This is the number one startup who the platform pick.)\tPhone Numbers\tImageLink\tWebsite\tFacebookUrl\tSourceUrl\tSmallDesc\n";
print lk "\"".'SNO'."\"".","."\"".'Name of Project'."\"".","."\"".'Name of project owner'."\"".","."\"".'How many updates'."\"".","."\"".'How many backers'."\"".","."\"".'All of the Backers or crowd funder names and emails'."\"".","."\"".'Backer or crowd funder City and State'."\"".","."\"".'How many comments'."\"".","."\"".'Scrap the home project page content (this data will be sentiment analyzed) '."\"".","."\"".'Backer or crowd funder City & State, and Country or Location'."\"".","."\"".'Category'."\"".","."\"".'Funding Goal or Pledged Goal '."\"".","."\"".'Gauge Bar'."\"".","."\"".'Funding Days Left or Days to Go'."\"".","."\"".'Fully Funded or Funded'."\"".","."\"".'Perks'."\"".","."\"".'Pledge $2 or more, Pledge $5 or more, Pledge $20 or more, Pledge $25 or more, Pledge $35 or more, and etc…'."\"".","."\"".'Share'."\"".","."\"".'Twitter'."\"".","."\"".'Face book Friends'."\"".","."\"".'How many people'."\"".","."\"".'Video link'."\"".","."\"".'Staff Picks of that Site (This is the number one startup who the platform pick.)'."\"".","."\"".'Phone Numbers'."\"".","."\"".'ImageLink'."\"".","."\"".'Website'."\"".","."\"".'FacebookUrl'."\"".","."\"".'SourceUrl'."\"".","."\"".'SmallDesc'."\""."\n";
close lk;
# my $total = $1 if($content =~ m/<b\s*class\=\"count\s*green\">\s*([^>]*?)\s*projects\s*<\/b>/is);
# $total =~ s/\,//igs;
# $total = ceil($total/20);
# my $pcount = 1;
my $count;
my $next_page = 12;
while($content =~ m/<a[^<]*?href\="[^>]*?>\s*show\s*more\s*</igs)
{
	$next_page = $next_page+12;
	my $next = "https://www.indiegogo.com/explore?filter_browse_balance=true&filter_quick=popular_all&per_page=".$next_page;
	print "next :: $next \n";
	$content = &lwp_get($next);
	sleep rand 10;
	# open sr, ">play1.html";
	# print sr $content;
	# close sr;
	# exit;
	# goto AGain;
}
AGain:
while($content =~ m/href\=\"([^>]*?)\"\s*class\=\"i\-project\">/igs)
{
	my $purl = $1;
	$purl = "http://www.indiegogo.com".$purl unless($purl =~ m/^http/is);
	# next;
	$purl =~ s/\/pinw$//igs;
	my $procont = &lwp_get($purl);
	# open sr,">indiegogo2.html";
	# print sr $procont;
	# close sr;
	$count++;
	# exit;
	my ($title, $created, $location, $smallDesc, $updatenew,$backers,$comments,$pro_pledged,$pledged_goal,$durationDate,$created2,$backed,$facebookComment,$category,$days);
	$title =  &clean($1) if($procont =~ m/<h1>\s*([^>]*?)\s*<\/h1>/is);
	$smallDesc =  &clean($1) if($procont =~ m/id\=\"tabanchor\">\s*([\w\W]*?)<\/div>/is);
	$location =  &clean($1) if($procont =~ m/class\=\"i\-byline\-location\-link\">\s*([^>]*?)\s*<\/a>/is);
	$category =  &clean($1) if($procont =~ m/class\=\"i\-keep\-it\-together\">([\w\W]*?)<\/div>/is);
	$updatenew =  &clean($1) if($procont =~ m/>\s*Updates\s*<\/a>\s*<span[^>]*?>\s*([^>]*?)\s*<\/span>/is);
	$backers =  &clean($1) if($procont =~ m/>\s*Funders\s*<\/a>\s*<span[^>]*?>\s*([^>]*?)\s*<\/span>/is);
	$comments =  &clean($1) if($procont =~ m/>\s*Comments\s*<\/a>\s*<span[^>]*?>\s*([^>]*?)\s*<\/span>/is);
	$pro_pledged =  &clean($1) if($procont =~ m/\"currency\s*currency\-xlarge\">\s*<span>([^>]*?)<\/span>/is);
	$days =  &clean($1) if($procont =~ m/class\=\"i\-time\-left\">\s*([\w\W]*?)\s*<\/div>/is);
	$pledged_goal =  &clean($1) if($procont =~ m/<span>([^>]*?)<\/span>\s*<\/span>\s*Goal/is);
	my $furl = "https://graph.facebook.com/".$purl."?callback=FB.__globalCallbacks.f293a0a32842104&method=get&pretty=0&sdk=joey";
	my $fcontent = &lwp_get($furl);
	my $fshares = &clean($1) if($fcontent =~ m/\"shares\"\:([^>]*?)\}/is);
	my ($twitter,$fbfriend);
	$twitter =  &clean($1) if($procont =~ m/href\=\"([^>]*?)\"\s*class\=\"link\s*Twitter\"/is);
	$fbfriend =  &clean($1) if($procont =~ m/<\/a>\s*<span\s*class\=\"number\">\s*([^>]*?)\s*friends/is);
	$durationDate =  &clean($1) if($procont =~ m/id\=\"project_duration_data\">([\w\W]*?)<\/h5>/is);
	my ($startDate, $endDate, $Limit);
	if($procont =~ m/>\s*Funding\s*period\s*<\/strong>\s*<br>\s*([^>]*?)\-\s*([^>]*?)\(\s*([^>]*?)\)\s*<\/p>/is)
	{
		$startDate = &clean($1);
		$endDate = &clean($2);
		$Limit = &clean($3);
	}
	$created2 = &clean($1) if($procont =~ m/>\s*([^>]*?)\s+created\s*<\/a>/is);
	$backed = &clean($1) if($procont =~ m/>\s*([^>]*?)\s+backed\s*<\/a>/is);
	$facebookComment = &clean($1) if($procont =~ m/<\/li>\s*<li\s*class\=\"facebook\">\s*([\w\W]*?)\s*<\/li>\s*<\/ul>/is);
	my ($fullDesc,$faqs,$pageLocation,$furl,$web,$image,$video);
	$smallDesc = &clean($1) if($procont =~ m/class\=\"short_blurb\">\s*([\w\W]*?)\s*<\/div>/is);
	$fullDesc = &clean($1) if($procont =~ m/class\=\"full\-description\">\s*([\w\W]*?)\s*<\/div>\s*<\/div>/is);
	$faqs = &clean($1) if($procont =~ m/class\=\"faqs\">\s*([\w\W]*?)\s*<\/div>\s*<\/div>/is);
	$pageLocation = &clean($1) if($procont =~ m/ref\=project_page_location\">\s*([\w\W]*?)\s*<\/a>/is);
	$furl = &clean($1) if($procont =~ m/href\=\"([^>]*?)\"\s*class\=\"link\s*facebook\"/is);
	$web = &clean($1) if($procont =~ m/href\=\"([^>]*?)\"\s*class\=\"link\s*external\"/is);
	$image = &clean($1) if($procont =~ m/og\:image\"\s*content\=\"([^>]*?)\"/is);
	$video = &clean($1) if($procont =~ m/\"pitchvideo\">\s*<iframe\s*src\=\"([^>]*?)\"/is);
	print "$count -> $title\n";
	open SR, ">>".$filename."Output.csv";
	# print SR "$count\t$title\t$created\t$updatenew\t$backers\t\t$location\t$comments\t\t$location\t$category\t$pledged_goal\t\t$days\t$pro_pledged\t\t$pro_pledged\t$fshares\t$twitter\t$fbfriend\tLike\t$video\t\t\t$image\t$web\t$furl\t$purl\t$smallDesc\n";
	print SR "\"".$count."\"".","."\"".$title."\"".","."\"".$created."\"".","."\"".$updatenew."\"".","."\"".$backers."\"".","."\"".''."\"".","."\"".$location."\"".","."\"".$comments."\"".","."\"".''."\"".","."\"".$location."\"".","."\"".$category."\"".","."\"".$pledged_goal."\"".","."\"".''."\"".","."\"".$days."\"".","."\"".$pro_pledged."\"".","."\"".''."\"".","."\"".$pro_pledged."\"".","."\"".$fshares."\"".","."\"".$twitter."\"".","."\"".$fbfriend."\"".","."\"".'Like'."\"".","."\"".$video."\"".","."\"".''."\"".","."\"".''."\"".","."\"".$image."\"".","."\"".$web."\"".","."\"".$furl."\"".","."\"".$purl."\"".","."\"".$smallDesc."\""."\n";
	close SR;
}
sub lwp_get() 
{ 
    REPEAT: 
    sleep rand 5; 
    my $req = HTTP::Request->new(GET=>$_[0]); 
    $req->header("Accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"); 
    $req->header("Content-Type"=>"application/x-www-form-urlencoded"); 
    my $res = $ua->request($req); 
    $cookie->extract_cookies($res); 
    $cookie->save; 
    $cookie->add_cookie_header($req); 
    my $code = $res->code(); 
    print $code,"\n"; 
    if($code =~ m/50/is) 
    { 
        sleep 1000; 
        goto REPEAT; 
    } 
    return($res->content()); 
} 
sub clean()
{
	my $var=shift;
	$var=~s/<[^>]*?>/ /igs;
	$var=~s/\&nbsp\;|amp\;/ /igs;
	$var=decode_entities($var);
	$var=~s/\s+/ /igs;
	return ($var);
}