

#import "DJPageView.h"

@interface DJPageView ()

@property(retain,nonatomic) NSTimer* timer;
@property (retain, nonatomic) UIScrollView *page_scroll;
@property (retain, nonatomic) DianJinDDPageControl *page_control;

@end

@implementation DJPageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadView];
}

-(void)loadView
{
    UIScrollView* scrollView = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)] autorelease];
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.pagingEnabled = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:scrollView];
    self.page_scroll = scrollView;
    self.page_scroll.delegate = self;
    
    self.page_control = [[[DianJinDDPageControl alloc] init] autorelease];
    [self.page_control setCenter:CGPointMake(self.frame.size.width / 2, 20)];
    self.page_control.type = DDPageControlTypeOnFullOffEmpty;
    self.page_control.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.page_control.offColor = RGB(255, 255, 255);
    self.page_control.indicatorDiameter = 7.0;
//    self.page_control.onColor = RGB(248, 165, 43);;
    self.page_control.userInteractionEnabled = NO;
    [self addSubview:_page_control];
    
}

#pragma mark -

-(void)handleTap:(UIControl *)controlr
{
    NSNumber* index = [NSNumber numberWithLong:controlr.tag];
    if (self.didTap) {
        self.didTap(index);
    }
}

- (void)update {
    self.page_control.hidden = NO;
    [self.page_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.page_scroll.contentSize  = CGSizeZero;
    self.page_scroll.contentOffset  = CGPointZero;
    self.page_control.numberOfPages = self.count;
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    if (self.count >= 2) {
        for (int i=0;i<self.count;i++) {
            UIControl *control = [[[UIControl alloc] init] autorelease];
            control.frame = CGRectMake((i + 1)*width, 0, width, height);
            [control addSubview:self.fetchView(@(i), control.bounds)];
            control.tag = i;
            control.clipsToBounds = YES;
            [control addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.page_scroll addSubview:control];
        }
        UIControl *firstView = [[[UIControl alloc] init] autorelease];
        firstView.clipsToBounds = YES;
        UIControl *lastView = [[[UIControl alloc] init] autorelease];
        lastView.clipsToBounds = YES;
        firstView.frame = CGRectMake((self.count+1)*width, 0, width, height);
        [firstView addSubview:self.fetchView(@(0), firstView.bounds)];
        firstView.tag = 0;
        [self.page_scroll addSubview:firstView];
        lastView.frame = CGRectMake(0, 0, width, height);
        [lastView addSubview:self.fetchView(@(self.count - 1), lastView.bounds)];
        lastView.tag = self.count - 1;
        [self.page_scroll addSubview:lastView];
        self.page_scroll.contentSize  = CGSizeMake((self.count + 2)*width,0);
        self.page_scroll.contentOffset  = CGPointMake(width, 0);
    } else if (self.count == 1){
        self.page_control.hidden = YES;
        UIControl *control = [[[UIControl alloc] init] autorelease];
        control.frame = CGRectMake(0, 0, width, height);
        [control addSubview:self.fetchView(@(0), control.bounds)];
        control.tag = 0;
        control.clipsToBounds = YES;
        [control addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.page_scroll addSubview:control];
    } else {
        UIImageView *placeHolderView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollView"]] autorelease];
        placeHolderView.frame = self.page_scroll.bounds;
        [self.page_scroll addSubview:placeHolderView];
    }
}

- (void)updateWithView:(UIView *(^)(NSNumber* index, CGRect frame)) fetch {
    self.fetchView = fetch;
    [self update];
}

- (void)updateWithView:(UIView *(^)(NSNumber* index, CGRect frame)) fetch count:(int) count {
    self.fetchView = fetch;
    self.count = count;
    [self update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-

-(void)nextPage
{
    if (self.count < 2) {
        return;
    }
    NSUInteger pageindex = self.page_control.currentPage + 2l;
    NSUInteger offsetX =  pageindex* self.frame.size.width;
    
    [self.page_scroll setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    if(pageindex == self.count + 1)
    {
        pageindex  = 1;
        [self performSelector:@selector(page_scrolltofirst) withObject:nil afterDelay:0.5];
    }
    if(pageindex == 0)
    {
        pageindex = self.count;
        [self performSelector:@selector(page_scrolltolast) withObject:nil afterDelay:0.5];
    }
    self.page_control.currentPage = pageindex-1;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.count < 2) {
        return;
    }

    int offsetX = scrollView.contentOffset.x;
    NSUInteger pageindex = offsetX / self.frame.size.width;
    if(pageindex == self.count + 1)
    {
        pageindex  = 1;
        [self performSelector:@selector(page_scrolltofirst) withObject:nil];
    }
    if(pageindex == 0)
    {
        pageindex = self.count;
        [self performSelector:@selector(page_scrolltolast) withObject:nil];
    }
    self.page_control.currentPage = pageindex -1;
    if (self.timer) {
        [self endPlay];
        [self startPlay];
    }
}
-(void) page_scrolltofirst
{
    [self.page_scroll setContentOffset:CGPointMake(self.frame.size.width, 0)];
}
-(void)page_scrolltolast
{
    [self.page_scroll setContentOffset:CGPointMake(self.count*self.frame.size.width, 0)];
}
-(void)startPlay
{
    [self performSelector:@selector(start) withObject:self afterDelay:3];
    if (self.count < 2) {
        return;
    }
    NSUInteger pageindex = self.page_control.currentPage + 1l;
    NSUInteger offsetX =  pageindex* self.frame.size.width;
    [self.page_scroll setContentOffset: CGPointMake(offsetX, 0) animated:NO];
    
}
-(void)start
{
    //计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage)  userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)endPlay
{

    [self.timer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.count < 2) {
        return;
    }
    NSUInteger pageindex = self.page_control.currentPage + 1l;
    NSUInteger offsetX =  pageindex* self.frame.size.width;
    [self.page_scroll setContentOffset: CGPointMake(offsetX, 0) animated:NO];

}

#pragma mark-

- (void)dealloc {
    [super dealloc];
}

@end
