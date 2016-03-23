//
//  DBUtil.m
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "DBUtil.h"
#import "ChatMessage.h"

@implementation DBUtil

+(DBUtil*)sharedInstance
{
    static DBUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        
        NSString *registeredEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kUDEmail];
        
        /*
        self.messages = [NSMutableArray new];

        ChatMessage *chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"4feetunda"];
        [chatMsg setImgName:@"4feetunda.png"];
        [chatMsg setSentTime:@"03:13"];
        [chatMsg setMessage:@"How many subs won the pre-release single DLs from last week???!"];
        [self.messages addObject:chatMsg];
        
        chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"TrapzMasta6"];
        [chatMsg setImgName:@"TrapzMasta6.png"];
        [chatMsg setSentTime:@"03:13"];
        [chatMsg setMessage:@"Yay!  I made it in time for the stream!!!"];
        [self.messages addObject:chatMsg];

        chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"TitanikStrgl"];
        [chatMsg setImgName:@"TitanikStrgl.png"];
        [chatMsg setSentTime:@"03:13"];
        [chatMsg setMessage:@"Canada rep’n in da house as always,   @Jklazzy #SwagStarz, yah"];
        [self.messages addObject:chatMsg];
        
        chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"DrizFan434"];
        [chatMsg setImgName:@"DrizFan434.png"];
        [chatMsg setSentTime:@"03:13"];
        [chatMsg setMessage:@"What’s up Drake?   Hello again to all the #SwagStarz rep’n 2nite"];
        [self.messages addObject:chatMsg];

        chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"BollowieBBY"];
        [chatMsg setImgName:@"BollowieBBY.png"];
        [chatMsg setSentTime:@"03:13"];
        [chatMsg setMessage:@"Has he given away the backstage passes to subs yet?"];
        [self.messages addObject:chatMsg];

        chatMsg = [ChatMessage new];
        [chatMsg setUsername:@"DannyDi11"];
        [chatMsg setImgName:@"DannyDi11.png"];
        [chatMsg setSentTime:@"03:14"];
        [chatMsg setMessage:@"Hello Drizzy!!!  I LOVED \xE2\x9D\xA4 That interview you gave last week!"];
        [self.messages addObject:chatMsg];
         */
        
        self.liveProfiles = @[
                              @{@"title" : @"Kevin Hart", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Kevin+Hart+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/coverimages/Comedy+-+Kevin+Hart.png", @"isOnline" : @YES, @"isMA" : @YES, @"text" : @"Kevin Hart exploded onto the scene as one of the most versatile comedic actors in both television and film; and he’s making history. The funniest comedian in America is fresh off his his newest nationwide What Now tour.", @"videoURL" : @"", @"viewers" : @"1,391,237", @"subscribers" : @"13,753,111", @"liveText" : @"Live @EssenseFestival #WhatNowTour using a stolen camera", @"subscribeText" : @"How many of my Subs were in Memphis last night?"},

                              @{@"title" : @"Kendall Jenner", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Kendall+Jenner+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Kendall+Jenner+2.png", @"isOnline" : @YES, @"isMA" : @NO, @"text" : @"Kendall Jenner is an American fashion model and television personality. Jenner first came to public attention for appearing in the E! reality television show Keeping Up with the Kardashians.", @"videoURL" : @"", @"viewers" : @"1,445,873", @"subscribers" : @"14,845,873", @"liveText" : @"Preparing for my Fendi shoot to Justine Skye, join me!", @"subscribeText" : @"Got some Estee Lauder for some of my Subs!"},
                              
                              
                              @{@"title" : @"Chris Brown", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Chris+Brown+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Chris+Brown+2.png", @"isOnline" : @YES, @"isMA" : @NO, @"text" : @"Chris Brown is a Grammy award winning American recording artist, dancer and actor. In addition to his solo and commercial success, Brown founded the record label CBE under Interscope Records with signed acts, Kevin McCall and Sevyn Streeter.", @"videoURL" : @"", @"viewers" : @"1,012,637", @"subscribers" : @"16,201,239", @"liveText" : @"Getting mad love in Israel right now!", @"subscribeText" : @"Adding to a sub's sneaker game tonight!"},
                              
                              @{@"title" : @"Jen Selter", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Jen+Selter+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Jen+Selter+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Jen Selter is an American fitness model from Long Island, New York. Selter is a fitness fan-favorite and has attracted significant media attention for her body type, initially on the photo-sharing website Instagram.", @"videoURL" : @"", @"viewers" : @"1,119,472", @"subscribers" : @"16,201,239", @"liveText" : @"Taking you guys with me to Pilates today", @"subscribeText" : @"Got a little treat for a lucky Sub!"},
                              
                              @{@"title" : @"Cam Newton", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Cam+Newton+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Cam+Newton+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Cam Newton is an NFL quarterback for the Carolina Panthers. He is the only player in the modern era to be awarded the Heisman Trophy, win a national championship, and become the first pick in the NFL draft all in a one-year span.", @"videoURL" : @"", @"viewers" : @"1,003,291", @"subscribers" : @"16,201,239", @"liveText" : @"Touring the training camp", @"subscribeText" : @"Sub giveaways starting soon!"},
                              
                              @{@"title" : @"Floyd Mayweather", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/FM+2.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/FM+2.png", @"isOnline" : @NO, @"isMA" : @YES, @"text" : @"Floyd Mayweather is an undefeated American professional boxer and is a five-division world champion. Mayweather topped the Forbes and Sports Illustrated lists as the highest paid athlete in the world.", @"videoURL" : @"", @"viewers" : @"1,000,736", @"subscribers" : @"16,201,239", @"liveText" : @"Who wants to fly with me on AirMayweather?", @"subscribeText" : @"Giving away lots of shit to my #TMT"},
                              
                              @{@"title" : @"Ruby Rose", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Ruby+Rose+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Ruby+Rose+2.png", @"isOnline" : @NO, @"isMA" : @YES, @"text" : @"Ruby Rose, is an Australian model, DJ, recording artist, actress, television presenter, and former MTV VJ. She is the face of Maybelline New York in Australia, and also stars on Orange Is the New Black as Stella Carlin.", @"videoURL" : @"", @"viewers" : @"948,672", @"subscribers" : @"16,201,239", @"liveText" : @"You're live with me at Pacha in Spain", @"subscribeText" : @"It's super Sub Tuesday again..."},
                              
                              @{@"title" : @"Ronda Rousey", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Ronda+Rousey+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Ronda+Rousey+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Ronda Rousey is an American mixed martial artist and actress. She is the first and current UFC Women's Bantamweight Champion and is undefeated in mixed martial arts.", @"videoURL" : @"", @"viewers" : @"784,211", @"subscribers" : @"16,201,239", @"liveText" : @"Follow me on the Road to UFC 190", @"subscribeText" : @"Always showing my Subs love"},
                              
                              @{@"title" : @"Big Sean", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Big+Sean+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Big+Sean+2.png", @"isOnline" : @NO, @"isMA" : @YES, @"text" : @"Big Sean is an American hip hop recording artist from Detroit, Michigan. Sean's album Dark Sky Paradise was released in 2015 and earned him his first No. 1 on the Billboard 200.", @"videoURL" : @"", @"viewers" : @"762,101", @"subscribers" : @"16,201,239", @"liveText" : @"Yah gonna be in the crib with me tonight", @"subscribeText" : @"I got that bb cream for my peeps"},
                              
                              @{@"title" : @"Amber Rose", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Amber+Rose+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Amber+Rose+2.png", @"isOnline" : @NO, @"isMA" : @YES, @"text" : @"Amber Rose, is an American hip hop model, hip hop artist, fashion designer and actress. Rose gained notoriety after posing for a Louis Vuitton print advertisement and has become the spokesperson for several leading brands.", @"videoURL" : @"", @"viewers" : @"43,219", @"subscribers" : @"16,201,239", @"liveText" : @"Swimming with Sebastian!", @"subscribeText" : @"Doing giveaway for this - @Drake #WitDrizzyBackStage"},
                              
                              @{@"title" : @"Nash Grier", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Nash+Grier+2.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Nash+Grier+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Nash Grier is an American actor and social media phenom who became nationally known in 2013 for online Vine videos. Nash has developed a large, engaged fan base thanks to his mix of slapstick comedy, song parodies, and videos that often co-star his friends and family.", @"videoURL" : @"", @"viewers" : @"1,012,388", @"subscribers" : @"16,201,239", @"liveText" : @"Live Streaming from Hawaii", @"subscribeText" : @"I'll do \"almost\" anything my Subs say"},
                              
                              @{@"title" : @"Russell Westbrook", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Russell+Westbrook+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Russell+Westbrook+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Russell Westbrook is an NBA basketball player for the Oklahoma City Thunder. Taking the league by storm in recent years, Westbrook is a four-time NBA All-Star, and was named the All-Star Game Most Valuable Player in 2015.", @"videoURL" : @"", @"viewers" : @"1,098,735", @"subscribers" : @"16,201,239", @"liveText" : @"Practice with me live!", @"subscribeText" : @"I got lots of stuff to giveaway!"},
                              
                              @{@"title" : @"Draya Michele", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Draya+Michele+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Draya+Michele+2.png", @"isOnline" : @NO, @"isMA" : @YES, @"text" : @"Draya Michele is an American model, reality television star, entrepreneur and aspiring actress. The native of Eastern Pennsylvania, Draya's career took off big when she starred in the VH1 Network: Basketball Wives LA.", @"videoURL" : @"", @"viewers" : @"790,404", @"subscribers" : @"16,201,239", @"liveText" : @"Just relax with me tonight everybody", @"subscribeText" : @"Giving away mint-swim merch. today to Subs"},
                              
                              @{@"title" : @"Nicole Mejia", @"CoverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Nicole+Mejia+1.png", @"BigImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Nicole+Mejia+2.png", @"isOnline" : @NO, @"isMA" : @NO, @"text" : @"Nicole Mejia, is an American fitness model and the founder of Fit and Thick, a body positive movement that encourages women to accept and become the best version of themselves through health and fitness.", @"videoURL" : @"", @"viewers" : @"810,328", @"subscribers" : @"16,201,239", @"liveText" : @"Come Train with me live", @"subscribeText" : @"Giving away NatureChemistry products today!"}];
        
        
        self.channelsArray = @[@[@[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/live/Basketball+-+Courtside.png"}, // 1
                                   @{@"type" : @"title", @"title" : @"Courtside", @"titleDescription" : @"Watch courtside with the NBA's most Vaunted.", @"viewTrailer" : @YES, @"trailerVideoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/D%27Angelo+Russell/stream.m3u8", @"text" : @"COURTSIDE is a close-up look at the lifestyles of the most influential NBA players. Episodes are a \rseries of short films that access the mindset and day-to-day dealings of the \"Life of a Baller\"."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/lbj_beats_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Beats+by+Dre-+%27Re-Established+2014%E2%80%9D+Trailer/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/2b.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/loading/login_LILLARD.png"}, // 2
                                   @{@"type" : @"title", @"title" : @"The Journey", @"text" : @"Journey into the world and lives of NBA players.  \"We are all on a journey, we are all going somewhere, working towards something. These are our stories\"."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/st_vincent_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Beats+by+Dre+Present-+LeBron+James+in+%27St.Vincent+St.+Mary%27s%27/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"Different experiences throughout our journey make us who we are. They craft our future and set the path.\"\r\rDamian Lillard"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/4a.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/5.png"}, // 3
                                   @{@"type" : @"title", @"title" : @"Put in Work", @"text" : @"The journey begins day one of the off-season.\rCourtside takes you to the workouts, facilities, and training sessions that prepare some of the most ferocious ballers in the league for the next season."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/lebron_chest.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Re-Established+2014-+The+Workout+ft.+Lebron+James/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"My main thing was to outwork everybody because I knew that would be my way to get people's attention.. by constantly getting better and putting in that work.\"\r\rJames Harden"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/James+Harden+-+Workout.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/7.png"}, // 4
                                   @{@"type" : @"title", @"title" : @"How I'm Living", @"text" : @"It's no secret that many professional athletes, especially the top NBA players, are living the high life. Massive houses, fancy cars, private jets and even yachts. Lets see how these guys are living."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/lebron_swimming.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/LEBRON+JAMES+2014+PLAYOFF%27S+PREP+WEEK+2+OF+5+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"Russell Westbrook coins himself the \"Fashion King of the NBA.\" His flash off the court is only trumped by his style on it.\r\rRussell Westbrook"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/8a.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/9.png"}, // 5
                                   @{@"type" : @"title", @"title" : @"The Giveback", @"text" :  @"NBA players consistently show profound generosity and heart for their communities. In this segment courtside introduces players off the court giving back."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/hickory_video_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Beats+by+Dre+Presents-+Gloria+James+in+%27439+Hickory+St.%27/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"This is a blessing to have that opportunity, to be a professional athlete, to come back to different communities where I'm from and where I'm playing professionally and give back.\"\r\rJohn Wall"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/10.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/11.png"}, // 6
                                   @{@"type" : @"title", @"title" : @"Hometown", @"text" : @"Players reflect on picking up their first ball in their beloved hometowns. This is where their hearts still lie and where the roots are that helped shape the men we see today. Join us courtside at Rucker Park, Venice Beach, Barry Farms and King Drew Magnet."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/akron1.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Beats+by+Dre+Presents-+LeBron+James+in+%27Akron%27/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"Do you want to be good or do you want to be great? That's my mantra.\"\r\rLebron James"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/12a.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/13.png"}, // 7
                                   @{@"type" : @"title", @"title" : @"Heart of the City", @"text" : @"Draft day is the beginning of the journey for D’Angelo Russell. Over the course of the season, Courtside chronicles the life of a teenager, entering the NBA. From his name being called by the commissioner to becoming the Heart of the City"},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/heartofcity_videocover.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/D%27Angelo+Russell/stream.m3u8"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"I am the heart of the city...My Journey has just begun\"...I am\r\rD'Angelo Russell."},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/14.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/15.png"}, // 8
                                   @{@"type" : @"title", @"title" : @"Hollywood", @"text" : @"Every athlete wants to be in Hollywood while every Hollywood star wants to be an athlete. This segment takes the best from both worlds.  Nick Young and Iggy Azalea are a prime example of a power couple.  A star athlete matched with a famous entertainer in Hollywood of all places."},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/2a.png"}]],
                               
                               
                               
                               @[@[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Candice 1.png"}, // 1
                                   @{@"type" : @"title", @"title" : @"Runway", @"titleDescription" : @"Meet the world's most vaunted supermodels on Runway", @"viewTrailer" : @YES, @"trailerVideoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4", @"text" : @"Runway is a close-up look at the lifestyles of the most desirable women in the world.  Episodes are a series of short films with exclusive access into the glamorous life of a supermodel."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_1_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Candice+Swanepoel+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Candice+2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Joan+1.png"}, // 2
                                   @{@"type" : @"title", @"title" : @"Beauty & Style", @"text" : @"Puerto Rico native Joan Smalls is a bonafide supermodel for a new generation. Since 2011, Smalls has starred as a brand ambassador and the face of Estée Lauder cosmetics. \"The word supermodel is overused, but if there's any woman who deserves the title, it's Joan.\" – Richard Ferretti / Estée Lauder"},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_2_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++UNPLUGGED+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Joan+2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Lily+1.png"}, // 3
                                   @{@"type" : @"title", @"title" : @"Angels", @"text" : @"Los Angeles, California native Aldridge is one of Victoria’s secret angels. Whether they’re relaxing at home, road tripping, or rocking a photo shoot in some far-off locale, the Angels make the most of the sunny days and sultry nights of summer."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_3_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++MESMERIZED+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Lily+2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Gigi+1.png"}, // 4
                                   @{@"type" : @"title", @"title" : @"Free Spirit", @"text" : @"Gigi Hadid, the accomplished volleyball player, esquestrian-turned-model, and native Los Angeleno, is an international hybrid of California-cool. Long blond tresses and sun-kissed skin, paired with exotic blue-green eyes and cherubic features, Gigi is a reflection of her Palestinian parentage."},
                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_4_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++UNPLUGGED+on+Vimeo+1.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Gigi+2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Jourdan+1.png"}, // 5
                                   @{@"type" : @"title", @"title" : @"The Runway", @"text" :  @"Episodes explore the every day lives of the worlds most accomplished runway models."}, @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_5_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Jourdan+2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Candice+3.png"}, // 6
                                   @{@"type" : @"title", @"title" : @"How She Does It", @"text" : @"Watch the intense workout routines and beauty regiments to find out what it takes to look good for a living."}, @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/Black-Slate-Slab.png", @"text" : @"\"I’m an athlete – I use every muscle when I pose. It’s important for me to feel strong\".\r\rCandice Swanepoel"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Candice+4.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Shanina.png"}, // 7
                                   @{@"type" : @"title", @"title" : @"The Wild One", @"text" : @"A journey into the untamed Australian landscape calls for a spirit of adventure. Off-duty, the Australian expat, Shanina Shaik, enjoys kickboxing, and indulging with chocolate chip cookie dough ice cream while cheering on her favorite sports team, the NY Knicks."},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Shanina+1.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Gigi+3.png"}, // 8
                                   @{@"type" : @"title", @"title" : @"Exotic Traveler", @"text" : @"Episodes take you on countless adventures with models that live life for a living."},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/models/Gigi+4.png"}]],
                               
                               @[@[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/coverimages/Sports+-+World+Premiere.png"}, // 1
                                   @{@"type" : @"title", @"title" : @"World Premiere", @"titleDescription" : @"Embrace the prowess of some of the world's foremost athletic talents on World Premiere.", @"viewTrailer" : @YES, @"trailerVideoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Neymar/260103690.mp4", @"text" : @"World Premiere takes us on a journey into the everyday lives of soccer’s biggest superstars. Episodes offer up-close access to the personal and professional lifestyles of some of the most celebrated sports figures in the world."}],
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_1_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/Candice+Swanepoel+on+Vimeo.mp4"},
//                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/2---neymar-2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/2---neymar-2.png"}, // 2
                                   @{@"type" : @"title", @"title" : @"New Breed", @"text" : @"\"A quicker, more agile, more dynamic game has emerged.\" Lithe, agile, and a little bit mischievous, Neymar fever is engulfing the soccer universe. Neymar was named the \"most marketable athlete\" in the world, beating LeBron James."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_2_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++UNPLUGGED+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/3---neymar-3.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/3---renaldo-1.png"}, // 3
                                   @{@"type" : @"title", @"title" : @"Adventure in style", @"text" : @"Catch a glimpse of Portuguese heartthrob, Cristiano Ronaldo’s bold off-the-field attitude and irreverent approach to style. When asked who he thought the most stylish soccer player joked, \"Me!\" before more humbly clarifying, \"Everyone; everyone has their own thing going and that's what makes things beautiful.\""},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_3_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++MESMERIZED+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/4---renaldo-2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/5---messi-1.png"}, // 4
                                   @{@"type" : @"title", @"title" : @"Messi", @"text" : @"We get a preview of the fanatical exuberance surrounding the Argentinean Lionel Messi. This segment documents days in his life this past summer and the run-up to the World Cup."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_4_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++UNPLUGGED+on+Vimeo+1.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/6---messi-2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/7---beckham-1.png"}, // 5
                                   @{@"type" : @"title", @"title" : @"Front Row", @"text" :  @"It's New York Fashion Week and seasoned celebrities David and Victoria Beckham take us backstage and front row at our favorite shows and into their lifestyle."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_5_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/8---beckham-2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/11---luis-suarez-1.png"}, // 7
                                   @{@"type" : @"title", @"title" : @"Suarez", @"text" : @"One of football's most divisive figures, Luis Suarez is a supremely gifted player who is tainted by an inability to stay out of trouble. His talent has never been in question but controversy never seems to be far from him."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_5_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/12---luis-suarez-2.png"}],
                                 
                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/13---mario-gotze-1.png"}, // 8
                                   @{@"type" : @"title", @"title" : @"Striker", @"text" : @"Mario Gotze, still just 22 years old, gives us an inside look at what winning the World Cup for your country with a glorious extra-time goal can do for you."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_5_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/14---mario-gotze-2.png"}],

                                 @[@{@"type" : @"coverImage", @"coverImage" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/15---kaka-1.png"}, // 9
                                   @{@"type" : @"title", @"title" : @"Kaka", @"text" : @"Kaka takes his mind back to the days when he was one of the original world superstars, the Cristiano Ronaldo and Lionel Messi of his day, when he was deemed the best player on the planet."},
//                                   @{@"type" : @"videoCover", @"videoCover" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/courtside/candice_5_still.png", @"videoURL" : @"https://d27u6i01i8lsjh.cloudfront.net/videos/CANDICE+SWANEPOEL++HEAT+on+Vimeo.mp4"},
                                   @{@"type" : @"image", @"filename" : @"http://d2mfxjpe4qh8ou.cloudfront.net/images/soccer/16---kaka-2.png"}]
                                ]];
    }
    
    return self;
}

- (NSArray *)searchItems:(NSString *)searchText {
    if (!searchText || [searchText length] == 0) {
        return nil;
    }
    searchText = [searchText lowercaseString];
    
    NSMutableArray *keywords = (NSMutableArray *)[searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([keywords count] > 1) {
        [keywords removeObject:@""];
    }
    
    NSMutableArray *itemsArray = [NSMutableArray new];
    for (NSMutableArray *sections in self.channelsArray) {
        for (NSArray *section in sections) {
            
            // extract all texts
            NSString *allStrings = @"";
            for (NSDictionary *itemDict in section) {
                NSString *title = [[itemDict objectForKey:@"title"] lowercaseString];
                NSString *titleDescription = [[itemDict objectForKey:@"titleDescription"] lowercaseString];
                NSString *text = [[itemDict objectForKey:@"text"] lowercaseString];
                if (title) {
                    allStrings = [allStrings stringByAppendingFormat:@" %@", title];
                }
                if (titleDescription) {
                    allStrings = [allStrings stringByAppendingFormat:@" %@", titleDescription];
                }
                if (text) {
                    allStrings = [allStrings stringByAppendingFormat:@" %@", text];
                }
            }
           
            // make tags
            NSMutableArray *tags = (NSMutableArray *)[allStrings componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([tags count] > 1) {
                [tags removeObject:@""];
            }
            
            // search
            BOOL found = YES;
            for (NSString *keyword in keywords) {
                BOOL contained = NO;
                for (NSString *tag in tags) {
                    if ([tag rangeOfString:keyword].location == 0) {
                        contained = YES;
                        break;
                    }
                }
                
                if (!contained) {
                    found = false;
                    break;
                }
            }
            if (found) {
                [itemsArray addObject:section];
            }
        }
    }
    
    return itemsArray;
}

@end
