//
//  ViewController.m
//  WebViewSmple
//
//  Created by 李蛋伯 on 2016/8/2.
//  Copyright © 2016年 李蛋伯. All rights reserved.
//

#import "ViewController.h"

//代码中需要使用WKWebVIew、WKNavigationDelegate和WKNavigation，所以需要引入<WebKit/WebKit.h>头文件。（在Swift中则是引入WebKit模块）
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate, UITextFieldDelegate>

@property(strong, nonatomic)WKWebView *webView;
@property(strong, nonatomic)UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WebViewSample";

#pragma mark -- 按钮栏按钮
    //按钮栏宽
    CGFloat buttonBarWidth = 316;
    
    //按钮栏
    UIView *buttonBar = [[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - buttonBarWidth)/2, 94, buttonBarWidth, 30)];
    
    [self.view addSubview:buttonBar];
    
    //添加LoadMTMLString按钮
    UIButton *buttonLoadMTMLString = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonLoadMTMLString setTitle:@"LoadHTMLString" forState:UIControlStateNormal];
    buttonLoadMTMLString.frame = CGRectMake(0, 0, 117, 30);
    
    //指定事件处理方法
    [buttonLoadMTMLString addTarget:self action:@selector(testLoadHTMLString:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonBar addSubview:buttonLoadMTMLString];
    
    //添加LoadData按钮
    UIButton *buttonLoadData = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonLoadData setTitle:@"LoadData" forState:UIControlStateNormal];
    buttonLoadData.frame = CGRectMake(137, 0, 67, 30);
    
    //指定事件处理方法
    [buttonLoadData addTarget:self action:@selector(testLoadData:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonBar addSubview:buttonLoadData];
    
    //添加LoadRequest按钮
    UIButton *buttonLoadRequest = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonLoadRequest setTitle:@"LoadRequest" forState:UIControlStateNormal];
    buttonLoadRequest.frame = CGRectMake(224, 0, 92, 30);
    
    //指定事件处理方法
    [buttonLoadRequest addTarget:self action:@selector(testLoadRequest) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonBar addSubview:buttonLoadRequest];
    
#pragma mark -- WKWebView
    //添加WKWebView
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 124, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 124)];
    
    [self.view addSubview:_webView];
    
#pragma mark -- 输入栏
    //添加输入栏
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 30)];
    
    //设置输入框类型
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //设置return键类型
    _textField.returnKeyType = UIReturnKeyGo;
    
    //设置键盘类型
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    //设置消除按钮类型
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //设置提示文本
    _textField.placeholder = @"Please input addrees.";
    
    //预留文本
    _textField.text = @"http://";

    //将当前视图控制器self赋值给textField控件的delegate委托属性
    _textField.delegate = self;
    
    [self.view addSubview:_textField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 三个按钮的方法
- (void)testLoadHTMLString:(id)sender{
    
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
    NSError *error = nil;
    
    NSString *html = [[NSString alloc]initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) {
        [_webView loadHTMLString:html baseURL:bundleUrl];
    }
}
- (void)testLoadData:(id)sender{
    
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
    NSData *htmlData = [[NSData alloc]initWithContentsOfFile:htmlPath];
    
    [_webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:bundleUrl];
    
}
- (void)testLoadRequest{
    
    NSURL *url = [NSURL URLWithString:_textField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.navigationDelegate = self;
    
}

#pragma mark -- 实现WKNavigationDelegate委托协议
//开始加载时调用。Provisional：临时的，暂时的，暂定的。
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"开始加载");
}
//当内容开始返回时调用。Commit：把...交付给...
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"内容开始返回");
}
//加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"加载完成");
}
//加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"加载失败 error：%@",error.description);
}

#pragma mark -- 实现textField委托协议
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //点击return，网页加载开始
    [self testLoadRequest];
    
    return TRUE;
    
}


@end
