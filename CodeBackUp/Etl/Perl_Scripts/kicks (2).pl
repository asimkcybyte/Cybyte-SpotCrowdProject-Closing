use strict;
use POSIX;
use HTTP::Cookies;
use LWP::UserAgent;
use HTML::Entities;
use WWW::Mechanize;
use URI::Escape;
use LWP::Simple;
use Encode qw(encode);
use DateTime;
my $ua = LWP::UserAgent->new(show_progress=>1);
$ua->agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)");
$ua->timeout(30);
$ua->cookie_jar({});
my $date = DateTime->now->ymd;
$date =~ s/\-//igs;
my $filename ="AA_Kickstarter_".$date;
my $cookie_file = $filename."_cookie.txt";
unlink($cookie_file);
my $cookie = HTTP::Cookies->new(file=>$cookie_file,autosave=>1);
$ua->cookie_jar($cookie);
my $url = "https://www.kickstarter.com/discover/advanced?sort=popularity";
my $content = &lwp_get($url);
# open sr,">kick.html";
# print sr $content;
# close sr;
open lk, ">".$filename.".csv";
# print lk "
# SNO\tName of Project\tName of project owner\tHow many updates\tHow many backers\tAll of the Backers or crowd funder names and emails\tBacker or crowd funder City and State\tHow many comments\tScrap the home project page content (this data will be sentiment analyzed) \tBacker or crowd funder City & State, and Country or Location\tCategory\tFunding Goal or Pledged Goal \tGauge Bar\tFunding Days Left or Days to Go\tFully Funded or Funded\tPerks\tPledge $2 or more, Pledge $5 or more, Pledge $20 or more, Pledge $25 or more, Pledge $35 or more, and etc…\tShare\tTwitter\tFace book Friends\tHow many people\tVideo link\tStaff Picks of that Site (This is the number one startup who the platform pick.)\tPhone Numbers\tImageLink\tWebsite\tFacebookUrl\tSourceUrl\n";
#print lk "\"".'SNO'."\"".","."\"".'Name of Project'."\"".","."\"".'Name of project owner'."\"".","."\"".'How many updates'."\"".","."\"".'How many backers'."\"".","."\"".'All of the Backers or crowd funder names and emails'."\"".","."\"".'Backer or crowd funder City and State'."\"".","."\"".'City'."\"".","."\"".'State'."\"".","."\"".'How many comments'."\"".","."\"".'Scrap the home project page content (this data will be sentiment analyzed) '."\"".","."\"".'Backer or crowd funder City & State, and Country or Location'."\"".","."\"".'Category'."\"".","."\"".'Funding Goal or Pledged Goal '."\"".","."\"".'Gauge Bar'."\"".","."\"".'Funding Days Left or Days to Go'."\"".","."\"".'Fully Funded or Funded'."\"".","."\"".'Perks'."\"".","."\"".'Pledge $2 or more, Pledge $5 or more, Pledge $20 or more, Pledge $25 or more, Pledge $35 or more, and etc…'."\"".","."\"".'Share'."\"".","."\"".'Twitter'."\"".","."\"".'Face book Friends'."\"".","."\"".'How many people'."\"".","."\"".'Video link'."\"".","."\"".'Staff Picks of that Site (This is the number one startup who the platform pick.)'."\"".","."\"".'Phone Numbers'."\"".","."\"".'ImageLink'."\"".","."\"".'Website'."\"".","."\"".'FacebookUrl'."\"".","."\"".'SourceUrl'."\""."\n";
print lk "\""."SNO"."\"".","."\""."Name of Project"."\"".","."\""."Name of project owner"."\"".","."\""."How many updates"."\"".","."\""."How many backers"."\"".","."\""."All of the Backers or crowd funder names and emails"."\"".","."\""."Backer or crowd funder City and State"."\"".","."\""."City"."\"".","."\""."State"."\"".","."\""."How many comments"."\"".","."\""."Scrap the home project page content (this data will be sentiment analyzed) "."\"".","."\""."Backer or crowd funder City & State, and Country or Location"."\"".","."\""."Category"."\"".","."\""."Funding Goal or Pledged Goal "."\"".","."\""."Gauge Bar"."\"".","."\""."Funding Days Left or Days to Go"."\"".","."\""."Fully Funded or Funded"."\"".","."\""."Perks"."\"".","."\""."Pledge $2 or more, Pledge $5 or more, Pledge $20 or more, Pledge $25 or more, Pledge $35 or more, and etc…"."\"".","."\""."Share"."\"".","."\""."Twitter"."\"".","."\""."Face book Friends"."\"".","."\""."How many people"."\"".","."\""."Video link"."\"".","."\""."Staff Picks of that Site (This is the number one startup who the platform pick.)"."\"".","."\""."Phone Numbers"."\"".","."\""."ImageLink"."\"".","."\""."Website"."\"".","."\""."FacebookUrl"."\"".","."\""."SourceUrl"."\"".","."\""."Small Desc"."\"".","."\""."Start Date"."\"".","."\""."End Date"."\"".","."\""."Limit"."\""."\n";

close lk;
my $total = $1 if($content =~ m/<b\s*class\=\"count\s*green\">\s*([^>]*?)\s*projects\s*<\/b>/is);
$total =~ s/\,//igs;
$total = ceil($total/20);
my $pcount = 1;
my $count;
AGain:
while($content =~ m/class\=\"green\-dark\"\s*href\=\"([^>]*?)\"/igs)
{
	my $purl = $1;
	$purl = "https://www.kickstarter.com".$purl unless($purl =~ m/^http/is);
	next if($purl =~ m/urls\.web\.project/is);
	my $procont = &lwp_get($purl);
	# open sr,">kick2.html";
	# print sr $procont;
	# close sr;
	$count++;
	# exit;
	my ($title,$created,$updatenew,$backers,$comments,$pro_pledged,$pledged_goal,$durationDate, $location,$created2,$backed,$facebookComment,$category,$days);
	my $title = &clean($1) if($procont =~ m/<div\s*class\=\"title[^>]*?>\s*<h2[^>]*?>\s*([\w\W]*?)\s*<\/h2>/is);
	my $created =  &clean($1) if($procont =~ m/<span\s*class\=\"creator\">\s*by\s*([\w\W]*?)\s*<\/a>/is);
	$created  =~ s/by//igs;
	$updatenew =  &clean($1) if($procont =~ m/id\=\"updates_nav\">\s*Updates\s*([\w\W]*?)\s*<\/a>/is);
	$backers =  &clean($1) if($procont =~ m/id\=\"backers_nav\">\s*Backers\s*([\w\W]*?)\s*<\/a>/is);
	$comments =  &clean($1) if($procont =~ m/id\=\"comments_nav\">\s*Comments\s*([\w\W]*?)\s*<\/a>/is);
	$pro_pledged =  &clean($1) if($procont =~ m/itemprop\=\"Project\[pledged\][^>]*?>\s*([^>]*?)\s*<\/data>/is);
	$days =  &clean($1) if($procont =~ m/property\=\"twitter\:text\:time\"\s*content\=\"([^>]*?)\s+[^>]*?"/is);
	$pledged_goal =  &clean($1) if($procont =~ m/<\/div>\s*pledged\s*of([\w\W]*?)goal/is);
	my $furl = "https://graph.facebook.com/".$purl."?callback=FB.__globalCallbacks.f293a0a32842104&method=get&pretty=0&sdk=joey";
	my $fcontent = &lwp_get($furl);
	my $fshares = &clean($1) if($fcontent =~ m/\"shares\"\:([^>]*?)\}/is);
	my ($twitter,$fbfriend);
	$twitter =  &clean($1) if($procont =~ m/class\=\"twitter[^>]*?>\s*<a\s*href\=\"([^>]*?)\"/is);
	$fbfriend =  &clean($1) if($procont =~ m/<\/a>\s*<span\s*class\=\"number\">\s*([^>]*?)\s*friends/is);
	$durationDate =  &clean($1) if($procont =~ m/id\=\"project_duration_data\">([\w\W]*?)<\/h5>/is);
	my ($startDate, $endDate, $Limit);
	if($procont =~ m/>\s*Funding\s*period\s*<\/h5>\s*<p[^>]*?>\s*<time[^>]*?>\s*([^>]*?)\s*<\/time>\s*\-\s*<time[^>]*?>\s*([^>]*?)\s*<\/time>\s*([^>]*?)\s*<\/p>/is)
	{
		$startDate = &clean($1);
		$endDate   = &clean($2);
		$Limit     = &clean($3);
	}
	
		
	
	
	$location = &clean($1) if($procont =~ m/class\=\"location[^>]*?>\s*([\w\W]*?)\s*<\/a>/is);
	my ($city,$state) = split(/\;/,$location);
	$created2 = &clean($1) if($procont =~ m/>\s*([^>]*?)\s+created\s*<\/a>/is);
	$backed = &clean($1) if($procont =~ m/>\s*([^>]*?)\s+backed\s*<\/a>/is);
	$facebookComment = &clean($1) if($procont =~ m/<\/li>\s*<li\s*class\=\"facebook\">\s*([\w\W]*?)\s*<\/li>\s*<\/ul>/is);
	$category = &clean($1) if($procont =~ m/class\=\"category\"[^>]*?>\s*([\w\W]*?)\s*<\/a>/is);
	my ($smallDesc,$fullDesc,$faqs,$pageLocation,$furl,$web,$image,$video);
	$smallDesc = &clean($1) if($procont =~ m/class\=\"short_blurb\">\s*([\w\W]*?)\s*<\/div>/is);
	$fullDesc = &clean($1) if($procont =~ m/class\=\"full\-description\">\s*([\w\W]*?)\s*<\/div>\s*<\/div>/is);
	$faqs = &clean($1) if($procont =~ m/class\=\"faqs\">\s*([\w\W]*?)\s*<\/div>\s*<\/div>/is);
	$pageLocation = &clean($1) if($procont =~ m/ref\=project_page_location\">\s*([\w\W]*?)\s*<\/a>/is);
	$furl = &clean($1) if($procont =~ m/<li\s*class\=\"facebook\-connected\">\s*<span[^>]*?>\s*<\/span>\s*<span[^>]*?>\s*<a\s*href\=\"([^>]*?)\"\s*class\=\"popup\"/is);
	$web = &clean($1) if($procont =~ m/<li\s*class\=\"links\">\s*<span[^>]*?>\s*<\/span>\s*<span[^>]*?>\s*<a\s*href\=\"([^>]*?)\"\s*class\=\"popup\"/is);
	$video = &clean($1) if($procont =~ m/data\-video\-url\=\"([^>]*?)\"/is);
	$image = &clean($1) if($procont =~ m/data\-image\=\"([^>]*?)\"/is);
	print "$count--$title\n";
	open SR, ">>".$filename.".csv";
	# print SR "$count\t$title\t$created\t$updatenew\t$backers\t\t$location\t$comments\t\t$location\t$category\t$pledged_goal\t\t$days\t$pro_pledged\t\t$pro_pledged\t$fshares\t$twitter\t$fbfriend\tLike\t$video\t\t\t$image\t$web\t$furl\t$purl\t$smallDesc\n";
	# print SR "\"".$count."\"".","."\"".$title."\"".","."\"".$created."\"".","."\"".$updatenew."\"".","."\"".$backers."\"".","."\"".''."\"".","."\"".$location."\"".","."\"".$city."\"".","."\"".$state."\"".","."\"".$comments."\"".","."\"".''."\"".","."\"".$location."\"".","."\"".$category."\"".","."\"".$pledged_goal."\"".","."\"".''."\"".","."\"".$days."\"".","."\"".$pro_pledged."\"".","."\"".''."\"".","."\"".$pro_pledged."\"".","."\"".$fshares."\"".","."\"".$twitter."\"".","."\"".$fbfriend."\"".","."\"".'Like'."\"".","."\"".$video."\"".","."\"".''."\"".","."\"".''."\"".","."\"".$image."\"".","."\"".$web."\"".","."\"".$furl."\"".","."\"".$purl."\"".","."\"".$smallDesc."\""."\n";
	print SR "\""."$count"."\"".","."\""."$title"."\"".","."\""."$created"."\"".","."\""."$updatenew"."\"".","."\""."$backers"."\"".","."\"".""."\"".","."\""."$location"."\"".","."\""."$city"."\"".","."\""."$state"."\"".","."\""."$comments"."\"".","."\"".""."\"".","."\""."$location"."\"".","."\""."$category"."\"".","."\""."$pledged_goal"."\"".","."\"".""."\"".","."\""."$days"."\"".","."\""."$pro_pledged"."\"".","."\"".""."\"".","."\""."$pro_pledged"."\"".","."\""."$fshares"."\"".","."\""."$twitter"."\"".","."\""."$fbfriend"."\"".","."\""."'Like'"."\"".","."\""."$video"."\"".","."\"".""."\"".","."\"".""."\"".","."\""."$image"."\"".","."\""."$web"."\"".","."\""."$furl"."\"".","."\""."$purl"."\"".","."\""."$smallDesc"."\"".","."\""."$startDate"."\"".","."\""."$endDate"."\"".","."\""."$Limit"."\""."\n";
	close SR;
}
if($pcount < $total)
{
	$pcount++;
	sleep 10;
	$content = &lwp_get("https://www.kickstarter.com/discover/advanced?page=$pcount&sort=popularity&seed=");
	goto AGain;
}
sub lwp_get() 
{ 
    REPEAT: 
    # sleep 15; 
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
        sleep 500; 
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
	$var=~s/\,/\;/igs;
	return ($var);
}


