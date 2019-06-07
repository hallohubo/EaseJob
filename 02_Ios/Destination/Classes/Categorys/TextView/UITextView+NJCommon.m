//
//  UITextView+NJCommon.m
//  Destination
//
//  Created by TouchWorld on 2019/1/10.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "UITextView+NJCommon.h"

@implementation UITextView (NJCommon)
+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limitNumber:(NSInteger)limitNumber
{
    NSString * str = [NSString stringWithFormat:@"%@%@", textView.text, text];

    if(str.length > limitNumber)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:limitNumber];
        if(rangeIndex.length == 1)//字数限制
        {
            textView.text = [str substringToIndex:limitNumber];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
//            self.totalTextLabel.text = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)textView.text.length, (long)NJMaxTextNumber];
            
        }
        else
        {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limitNumber)];
            textView.text = [str substringWithRange:range];
            
        }
        return NO;
    }
    return YES;
    
}
@end
