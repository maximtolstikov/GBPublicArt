// Для описания аннотации метки

#import "MyMarkerAnnotation.h"

@implementation MyMarkerAnnotation

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
//    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.calloutOffset = CGPointMake(5, 5);
    self.canShowCallout = YES;
    
    UILabel *customSubtitle = [UILabel new];
    customSubtitle.text = annotation.subtitle;
    customSubtitle.numberOfLines = 0;
    customSubtitle.textColor = UIColor.redColor;
    customSubtitle.font = [UIFont systemFontOfSize:13];
    self.detailCalloutAccessoryView = customSubtitle;

}

@end
