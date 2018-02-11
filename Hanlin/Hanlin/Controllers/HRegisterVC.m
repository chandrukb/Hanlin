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

@interface HRegisterVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray *textFields;
    UIImage *selectedImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidFullname;
@property (weak, nonatomic) IBOutlet UITextField *tfFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidContactNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

- (IBAction)onSignUpClicked:(id)sender;
- (IBAction)onSignInClicked:(id)sender;
- (IBAction)addProfileImageTapped:(id)sender;

@end

@implementation HRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textFields = [[NSArray alloc] initWithObjects:self.tfFullname,self.tfEmail,self.tfContactNumber,self.tfPassword, nil];
    for(UITextField *field in textFields)
    {
        field.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareUIForView
{
//    [self.ivProfileImage addGestureRecognizer:self.tagGesture];
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
    //check internet connection
    //validate the fields
    //perform the request
    [self prepareRequest];
}


- (IBAction)onSignInClicked:(id)sender {
    //present the sign in screen
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
    // Start request
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_REGISTER_USER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.tfFullname.text forKey:HN_REQ_NAME];
    [request setPostValue:self.tfEmail.text forKey:HN_REQ_EMAIL];
    [request setPostValue:self.tfContactNumber.text forKey:HN_REQ_PHONE];
    [request setPostValue:self.tfPassword.text forKey:HN_REQ_PASSWORD];
    //TO DO: need to be removed at actual implementation
//    [request setPostValue:@"Balachandran Kaliyamoorthy" forKey:HN_REQ_NAME];
//    [request setPostValue:@"balachandrank1983@gmail.com" forKey:HN_REQ_EMAIL];
//    [request setPostValue:@"9884403674" forKey:HN_REQ_PHONE];
//    [request setPostValue:@"1234567" forKey:HN_REQ_PASSWORD];
    //add the image data to the request
    [request setData:UIImagePNGRepresentation(selectedImage) forKey:HN_REQ_USERFILE];
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
        NSDictionary *responseDict = [resString JSONValue];
//        NSString *unlockCode = [responseDict objectForKey:@"unlock_code"];
//
//        if ([unlockCode compare:@"com.razeware.test.unlock.cake"] == NSOrderedSame) {
////            textView.text = @"The cake is a lie!";
//        } else {
////            textView.text = [NSString stringWithFormat:@"Received unexpected unlock code: %@", unlockCode];
//        }
        
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
        NSString *numberRegEx = @"[0-9]{10}";
        NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
        if ([numberTest evaluateWithObject:textField.text] == YES)
            return YES;
        else
            return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
@end
