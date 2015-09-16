//
//  AlertViewController.m
//  GuessTheCar2
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "AlertViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIFont+CustomFont.h"
#import "Localization.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (nonatomic, strong) NSString *stringTitle;
@property (nonatomic, strong) NSString *stringButton1;
@property (nonatomic, strong) NSString *stringButton2;

@end

@implementation AlertViewController

-(id)initWithMessage:(NSString*)message button1Title:(NSString*)btn1Title button2Title:(NSString *)btn2Title
{
    NSString *nibName = isPad ? @"AlertViewController_iPad" : @"AlertViewController_iPhone";
    
    
    if (self = [self initWithNibName:nibName bundle:nil])
    {
        _tag = 0;
        _stringTitle = message;
        _stringButton1 = btn1Title;

        _showMailController = NO;
    }
    
    return self;
}

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
    // Do any additional setup after loading the view from its nib.
    
    _lbTitle.text = _stringTitle;
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor blackColor];
    _lbTitle.font = [UIFont fontWithMaxSize:18 constrainedToSize:_lbTitle.frame.size forText:_lbTitle.text];
    _lbTitle.numberOfLines = 0;
    _lbTitle.lineBreakMode = NSLineBreakByWordWrapping;
    _lbTitle.adjustsFontSizeToFitWidth = YES;
    
    [_button1 setTitle:_stringButton1 forState:UIControlStateNormal];
    [_button1.titleLabel setTextColor:[UIColor whiteColor]];
    [_button1.titleLabel setFont:[UIFont myFontSize:18]];
    _button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
   
    if (_showMailController)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMail)];
        _lbTitle.userInteractionEnabled = YES;
        [_lbTitle addGestureRecognizer:tap];
    }
    
}

-(void)showMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:@"buhlak@emperorlab.com", nil];
        [mailer setToRecipients:toRecipients];
        NSString *subject = [NSString stringWithFormat:@"%@, [%@], [iOS %@]",[[Localization instance] stringWithKey:@"txt_appName"],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]];
        [mailer setSubject:subject];
        //        [mailer setMessageBody:_textViewText.text isHTML:NO];
        
        if (isPad) {
            mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        }
        [self presentViewController:mailer animated:YES completion:nil];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil message:[[Localization instance] stringWithKey:@"txt_mailLinkError"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                        message:@"Email failed to send. Please try again."
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
    }
    
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClose:(id)sender {
    [_delegate alertDidDismissed:self];
}
- (IBAction)didButton:(UIButton *)sender {
    [_delegate alertControllerDidClose:self withButtonTag:sender.tag];
}

@end
