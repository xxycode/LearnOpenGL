//
//  ViewController.m
//  LearnOpenGL_triangle
//
//  Created by XiaoXueYuan on 2017/12/28.
//  Copyright © 2017年 xxycode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

// Shaders
const GLchar* vertexShaderSource = "#version 300 core\n"
"layout (location = 0) in vec4 vPosition;\n"                         //定了输入变量的位置值
"void main()\n"
"{\n"
"gl_Position = vPosition;\n"
"}\0";

const GLchar* fragmentShaderSource = "#version 300 core\n"
"precision mediump float;\n"
"out vec4 color;\n"
"void main()\n"
"{\n"
"color = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
"}\n\0";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
