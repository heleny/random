//
//  ImageViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-08-01.
//
//

#import "ImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) MTStatusBarOverlay *overlay;
@end

@implementation ImageViewController

@synthesize imageView = _imageView, overlay = _overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
      TODO:
      - add spinner while fetching remote image
      - add image cache
    */
    
   //    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
//        if ([data length] > 0 && error == nil) {
//            [self dataReceived:data];
//        }
//    }];
    
//    NSString *url = @"http://farm4.staticflickr.com/3598/3551599565_db282cf840_o.jpg";
    NSString *url = @"http://farm1.staticflickr.com/196/475048208_c94a81b8c3_b.jpg";
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//
//    NSLog(@"Received %d bytes", [data length]);
//    [req setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:1024*1024*10];
//        
//    UIImage *image = [UIImage imageWithData:data];

//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
//    scrollView.contentSize = image.size;
//    scrollView.delegate = self;
//    [scrollView setScrollEnabled:YES];
//    [scrollView setMaximumZoomScale:0.5];
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    self.imageView.image = image;
//    [scrollView addSubview:self.imageView];
//    [self.view addSubview:scrollView];

    // using AFNetworking for downloading image
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"splash.png"]];
    if (self.overlay == nil) {
        self.overlay = [MTStatusBarOverlay sharedInstance];
        self.overlay.animation = MTStatusBarOverlayAnimationFallDown;
        self.overlay.detailViewMode = MTDetailViewModeHistory;
        self.overlay.delegate = self;
        self.overlay.progress = 0.0;
        [self.overlay postMessage:@"Loading image..."];
        self.overlay.progress = 1.0;
        [self.overlay postFinishMessage:@"Image is loaded successfully." duration:3.0 animated:YES];
    }
    
//    [self.imageView setImageWithURLRequest:[NSURL URLWithString:url]
//                          placeholderImage:[UIImage imageNamed:@"splash.png"]
//                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                              NSLog(@"********* Load image successfully.");
//                              scrollView.contentSize = image.size;
//                              self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//                              
//                          }
//                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                              NSLog(@"********* error: failed to load image.");
//                          }
//    ];

    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    scrollView.contentSize = self.imageView.image.size;
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setMaximumZoomScale:0.5];

    [scrollView addSubview:self.imageView];
    [self.view addSubview:scrollView];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.imageView = nil;
    self.overlay = nil;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
