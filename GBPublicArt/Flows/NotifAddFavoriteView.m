//Для показа лейбла при добавлении точки в избранное

#define NOTIF_ADD_FAVORITE_TEXT @"Point add to favorite!"

#import "NotifAddFavoriteView.h"

@interface NotifAddFavoriteView()

@property(strong, nonatomic) UILabel *notifLable;
@property (nonatomic, assign) BOOL isAnimated;

@end

@implementation NotifAddFavoriteView

+ (instancetype)sheredInstance {
    static NotifAddFavoriteView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotifAddFavoriteView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = UIColor.blueColor;
    [self addSubview:backgroundView];
    [self createLable];
    
}

- (void)createLable {
    
    _notifLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _notifLable.text = NOTIF_ADD_FAVORITE_TEXT;
    [_notifLable setFont:[UIFont systemFontOfSize:20.0]];
    [_notifLable setTextColor:UIColor.whiteColor];
    [_notifLable sizeToFit];
    [self addSubview:_notifLable];
    
}

- (void)startAnimating {
    
    [UIView animateWithDuration:2 animations:^{
        self->_notifLable.frame = CGRectMake(self.bounds.size.width / 2 - (self->_notifLable.frame.size.width / 2),
                                             (self.bounds.size.height / 2),
                                             self.bounds.size.width,
                                             40.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show {
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self startAnimating];
}

@end
