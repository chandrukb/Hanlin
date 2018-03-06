//
//  HRegisterVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HRegisterVC.h"
#import "HNConstants.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "JSON.h"
#import "HNUtility.h"
#import "HNTextField.h"
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNServiceManager.h"

@interface HRegisterVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CSLazyLoadControllerDelegate>
{
    NSArray *textFields;
    UIImage *selectedImage;
    BOOL keyboardIsShown;
}
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidFullname;
@property (weak, nonatomic) IBOutlet HNTextField *tfFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidEmail;
@property (weak, nonatomic) IBOutlet HNTextField *tfEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidContactNumber;
@property (weak, nonatomic) IBOutlet HNTextField *tfContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidPassword;
@property (weak, nonatomic) IBOutlet HNTextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *signINContainerView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;


- (IBAction)onSignUpClicked:(id)sender;
- (IBAction)onSignInClicked:(id)sender;
- (IBAction)addProfileImageTapped:(id)sender;

@end

@implementation HRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textFields = [[NSArray alloc] initWithObjects:self.tfFullname,self.tfEmail,self.tfContactNumber,self.tfPassword, nil];
    [self prepareUIForRegistration];
    // Do any additional setup after loading the view.
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    _btnCancel.hidden=YES;
    
    if (_isFromProfile) {
        [_btnSignUp setTitle:@"更新" forState:UIControlStateNormal];
        _passwordView.hidden = YES;
        _signINContainerView.hidden = YES;
        _btnCancel.hidden=NO;
        [self.view bringSubviewToFront:_btnCancel];
        
        _tfFullname.text=[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_NAME];
        _tfEmail.text=[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERNAME];
        _tfContactNumber.text=[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_PHONE];
        
        self.lazyLoadController = [[CSLazyLoadController alloc] init];
        self.lazyLoadController.delegate = self;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *imageUrl = [defaults valueForKey:HN_LOGIN_PROFILE_IMG];
        NSLog(@"profile url: %@",[HN_ROOTURL stringByAppendingString:imageUrl]);
        UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl]]]; // Find image in RAM memory.
        self.ivProfileImage.image = image;
        selectedImage=image;
        // If there is not image download it
        if (!image) {
            NSIndexPath *indexpath = [[NSIndexPath alloc] init];
            indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.lazyLoadController startDownload:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl] parameters:nil method:CSHTTPMethodPOST]
                                      forIndexPath:indexpath];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if([segue.identifier isEqualToString:@"ShowLoginPage"] && canShowLoginScreen)
//    {
//
//    }
}

-(void)prepareUIForRegistration
{
//    [self.ivProfileImage addGestureRecognizer:self.tagGesture];
//    for(UITextField *field in textFields)
//    {
//        field.textContentType = UITextContentTypeEmailAddress;
//    }
    // Add regex for validating email id
    [self.tfFullname addRegx:@"[A-Za-z]+ [A-Za-z]+" withMsg:@"Enter valid fullname."];
    // Add regex for validating email id
    [self.tfEmail addRegx:@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" withMsg:@"Enter valid email."];
    // Add regex for validating phone number
    [self.tfContactNumber addRegx:@"[0-9]{10}" withMsg:@"Phone number must be 10 digits"];
    // Add regex for validating characters limit
    [self.tfPassword addRegx:@"^.{6,12}$" withMsg:@"Password characters limit should be between 6-12"];
    // Add regex for validating alpha numeric characters
    [self.tfPassword addRegx:@"[A-Za-z0-9]{6,12}" withMsg:@"Password must contain alpha numeric characters."];
}

- (IBAction)addProfileImageTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Upload from gallery" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       NSLog(@"Chose to upload an image from gallery");
                                                       [self selectPictureFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                                                   }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       NSLog(@"Chose to take a picture");
                                                       [self selectPictureFromSource:UIImagePickerControllerSourceTypeCamera];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {}];
    [alert addAction:galleryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onSignUpClicked:(id)sender {
    if([HNUtility checkIfInternetIsAvailable])
    {
        [self prepareRequest];
    }
    else
    {
        [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}


- (IBAction)onSignInClicked:(id)sender {
    //present the sign in screen
    [self performSegueWithIdentifier:@"ShowLoginPage" sender:self];
}


-(void)selectPictureFromSource:(UIImagePickerControllerSourceType)source
{
    if([UIImagePickerController isSourceTypeAvailable:source]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = source;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{        
        [HNUtility showAlertWithTitle:HN_CAMERA_UNAVAILABLE_TITLE andMessage:HN_CAMERA_UNAVAILABLE_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}

-(void)prepareRequest
{
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setObject:self.tfFullname.text forKey:HN_REQ_NAME];
    [payload setObject:self.tfEmail.text forKey:HN_REQ_EMAIL];
    [payload setObject:self.tfContactNumber.text forKey:HN_REQ_PHONE];
    [payload setObject:selectedImage forKey:HN_REQ_USERFILE];
    if (_isFromProfile) {
        [payload setObject:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:HN_REQ_USERID];
        [HNServiceManager updateUserWithAction:HN_UPDATE_USER completionHandler:^(NSDictionary *response) {
            BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
            NSString * message = [response valueForKey:HN_RES_MSG];
            if(responseStatus == true)
            {
                [HNUtility saveLoginDetailsToPersistance:response];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setValue:[response valueForKey:@"email"] forKey:HN_LOGIN_USERNAME];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
        } ErrorHandler:^(NSError *error) {
            NSLog(@"Error : %@",error.localizedDescription);
        } payLoadDictionary:payload];
    }
    else
    {
        [payload setObject:self.tfPassword.text forKey:HN_REQ_PASSWORD];
        [HNServiceManager updateUserWithAction:HN_REGISTER_USER completionHandler:^(NSDictionary *response) {
            BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
            NSString * message = [response valueForKey:HN_RES_MSG];
            if(responseStatus == true)
            {
                [self performSegueWithIdentifier:@"ShowLoginPage" sender:self];
            }
            [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
        } ErrorHandler:^(NSError *error) {
            NSLog(@"Error : %@",error.localizedDescription);
        } payLoadDictionary:payload];
    }
}

#pragma mark- UIImagePicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        selectedImage = [HNUtility imageWithImage:tempImage convertToSize:CGSizeMake(200, 200)];
        [self.ivProfileImage setImage:selectedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITextField Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)iRange replacementString:(NSString *)iText {
    if([textField isEqual:self.tfFullname])
    {
        if ( (iRange.location > 0 && [iText length] > 0 &&
              [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[iText characterAtIndex:0]] &&
              [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[[textField text] characterAtIndex:iRange.location - 1]]) )
        {
            textField.text = [textField.text stringByReplacingCharactersInRange:iRange withString:@""];
            return NO;
        }
        else
        {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:iRange withString:iText];
            NSString *abnRegex = @"[A-Za-z ]+";
            NSPredicate *abnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abnRegex];
            return ([abnTest evaluateWithObject:newString] || newString.length == 0);
        }
    }
    else if([textField isEqual:self.tfContactNumber])
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:iRange withString:iText];
        NSString *numberRegEx = @"[0-9]+";
        NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
        return ([numberTest evaluateWithObject:newString] || newString.length == 0);
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger fieldIndex = [textFields indexOfObject:textField];
    if(fieldIndex < [textFields count] - 1)
    {
        [textField resignFirstResponder];
        [[textFields objectAtIndex:fieldIndex+1] becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark- Keyboard notification methods
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height += keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the view
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

-(IBAction)CancelHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Lazyloader Delegate
// Controller asks us for URL so give him image URL
- (CSURL *)lazyLoadController:(CSLazyLoadController *)loadController
       urlForImageAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imageUrl = [defaults valueForKey:HN_LOGIN_PROFILE_IMG];
    return (imageUrl.length > 0) ? [CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl]]:nil;
}

// Image has finished with downloading so update the cell
- (void)lazyLoadController:(CSLazyLoadController *)loadController
            didReciveImage:(UIImage *)image
                   fromURL:(CSURL *)url
                 indexPath:(NSIndexPath *)indexPath {
    self.ivProfileImage.image = image;
}

@end
