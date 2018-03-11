    #/usr/bin/perl -w
    use strict;
    use warnings;
    use WWW::Mechanize; 

    my $username = '13888888888';
    my $pass = '222222';
    my $nasIp = '133.133.133.133'; 
    my $nasPortId = 'lag-1:8888.888';   
    my $url = 'https://wlan.ct10000.com/?basetype=3&nasPortId='.$nasPortId.'&UserInputURL=http://www.baidu.com/&nasIp='.$nasIp;
    
    my $impcontent;
    #打开浏览器
    my $ua = WWW::Mechanize->new(); 
    $ua->cookie_jar(HTTP::Cookies->new()); 
    $ua->agent_alias('Windows IE 6');
    
    #打开网址
    my $response = $ua->get($url);
    my $decontent =$response->decoded_content;
    
    $decontent =~ s/\n//g;
                
   #打开框架网址            
   if($decontent =~ /mainFrame\" src=\"(.*)\" noresize/)
   {
   	 $url = 'https://wlan.ct10000.com'.$1;

   }
    $response = $ua->get($url);           
    $decontent =$response->decoded_content; 
    $decontent =~ s/\n/0D0A/g;
    $decontent =~ s/\s//g;
 
    
    #取出框架要素
    my $paramStr='';
    if($decontent =~ /id=\"paramStr\"value=\"(.*)?\"\/>0D0A<inputtype=\"hidden\"name=\"paramStrEnc\"/)  
    {
    	 $paramStr=$1;   	  
    }
    my $paramStrEnc='';
    if($decontent =~ /id=\"paramStrEnc\"value=\"(.*)?\"\/>0D0A<inputtype=\"hidden\"name=\"province\"id=\"province\"/)
    {
    	 $paramStrEnc=$1;
    }
    my $province='telecom.dynamic@ish';
    my $prefix='NE';
    my $logintype='2';
   
    #简易uri编码，不用调用URI::Encode
    $paramStr =~ s/([^^A-Za-z0-9\-_.!~*'()])/ sprintf "%%%02X", ord $1 /eg;
    $paramStr =~ s/0D0A/\%0D\%0A/g;
    $paramStrEnc =~ s/([^^A-Za-z0-9\-_.!~*'()])/ sprintf "%%%02X", ord $1 /eg;
    $province =~ s/([^^A-Za-z0-9\-_.!~*'()])/ sprintf "%%%02X", ord $1 /eg;
    my $location = 'https://wlan.ct10000.com/style/ish_fx/index.jsp?paramStr=' . $paramStr;
    
    my $content =  'paramStr=' . $paramStr . '&paramStrEnc=' . $paramStrEnc  . '&province=' . $province . '&prefix=' . $prefix . '&logintype=' . $logintype . '&UserName=' . $username . '&PassWord=' . $pass;  
    print $content;  
    
    my $url2='https://wlan.ct10000.com/authServlet';
    #发起登陆
    $response =  $ua->post($url2,              
                        'Accept' =>  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                        'Accept-Encoding' =>  'gzip, deflate',
                        'Accept-Language' =>  'zh-CN,zh;q=0.8',
                        'Cache-Control' =>  'max-age=0',
                        'Connection' =>  'keep-alive',
                        'Content-Length' =>  '1067',
                        'Content-Type' =>  'application/x-www-form-urlencoded',
                        'Cookie' =>  'JSESSIONID=22B2B92222C0F258866778895E2F4450F80',
                        'Host' =>  'wlan.ct10000.com',
                        'Origin' =>  'https://wlan.ct10000.com',
                        'Referer' =>   $location,  
                        'Upgrade-Insecure-Requests' =>  '1',
                        'User-Agent' =>  'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5',
                        'Content' => $content
                        );
                        
       
   # $decontent = $response->decoded_content;       
   # print $decontent;