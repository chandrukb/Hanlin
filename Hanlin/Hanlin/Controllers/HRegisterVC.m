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

@interface HRegisterVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)onSignUpClicked:(id)sender;
- (IBAction)onSignInClicked:(id)sender;
- (IBAction)addProfileImageTapped:(id)sender;
- (IBAction)canceBtnAction:(id)sender;

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
    
    if (_isFromProfile) {
        [_btnSignUp setTitle:@"Update" forState:UIControlStateNormal];
        _passwordView.hidden = YES;
        _signINContainerView.hidden = YES;
        _cancelBtn.hidden = NO;
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

- (IBAction)canceBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onSignUpClicked:(id)sender {
//    if([HNUtility checkIfInternetIsAvailable])
//    {
//        [self prepareRequest];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                       message:@"Unable to connect to the internet."
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    [self prepareRequest];
//    if (!_isFromProfile) {
//    [self prepareRequest];
//    }
//    else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                   message:@"Unable to find a camera on your device."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

-(void)prepareRequest
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    // Start request
    NSURL *url = _isFromProfile ? [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_UPDATE_USER]]
                                : [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_REGISTER_USER]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    if (_isFromProfile) {
//        [request setPostValue:@"Sabareesh Balachandran" forKey:HN_REQ_NAME];
//        [request setPostValue:@"sabareesh8@gmail.com" forKey:HN_REQ_EMAIL];
//        [request setPostValue:@"9638527410" forKey:HN_REQ_PHONE];
//        [request setPostValue:@"33" forKey:HN_REQ_USERID];
        
        [request setPostValue:self.tfFullname.text forKey:HN_REQ_NAME];
        [request setPostValue:self.tfEmail.text forKey:HN_REQ_EMAIL];
        [request setPostValue:self.tfContactNumber.text forKey:HN_REQ_PHONE];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:HN_REQ_USERID];
    }
    else{
//        [request setPostValue:@"Sabareesh Balachandran" forKey:HN_REQ_NAME];
//        [request setPostValue:@"sabareesh8@gmail.com" forKey:HN_REQ_EMAIL];
//        [request setPostValue:@"9638527413" forKey:HN_REQ_PHONE];
//        [request setPostValue:@"123456" forKey:HN_REQ_PASSWORD];
        
        [request setPostValue:self.tfFullname.text forKey:HN_REQ_NAME];
        [request setPostValue:self.tfEmail.text forKey:HN_REQ_EMAIL];
        [request setPostValue:self.tfContactNumber.text forKey:HN_REQ_PHONE];
        [request setPostValue:self.tfPassword.text forKey:HN_REQ_PASSWORD];
    }
   
    //add the image data to the request
    [request setData:UIImagePNGRepresentation(selectedImage) withFileName:@"png" andContentType:@"multipart/form-data" forKey:HN_REQ_USERFILE];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //handle the request
    if (request.responseStatusCode == 400) {
        NSLog(@"Invalid code");
    } else if (request.responseStatusCode == 403) {
        NSLog(@"Code already used");
    } else if (request.responseStatusCode == 200) {
        NSString *resString = [request responseString];
        NSArray *responseArray = [resString JSONValue];
        NSDictionary *response = responseArray[0];
        BOOL responseStatus = [[response valueForKey:@"success"] boolValue];
        NSString * message = [response valueForKey:@"msg"];
        if(responseStatus == true)
        {
            [self performSegueWithIdentifier:@"ShowLoginPage" sender:self];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        NSLog(@"dictionary value: %@", response);
        //to do: present an alert to the user and navigate to the login or the home screen
    } else {
        NSLog(@"Unexpected error");
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error : %@",error.localizedDescription);
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

@end
