//
//  XYGLView.m
//  LearnOpenGL_triangle
//
//  Created by XiaoXueYuan on 2017/12/28.
//  Copyright © 2017年 xxycode. All rights reserved.
//

#import "XYGLView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>

#define GLLayer self.glLayer

@interface XYGLView()

@property (nonatomic, strong) EAGLContext *context;
@property (readonly) CAEAGLLayer *glLayer;

@end

@implementation XYGLView

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        return self;
    }
    return nil;
}

- (void)commonInit{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_context];
    
    GLLayer.opaque = YES;
    GLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    GLLayer.contentsScale = [UIScreen mainScreen].nativeScale;
    
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:GLLayer];
    
    GLint renderbufferWidth, renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    
    //1.顶点着色器
    
    const GLchar* vertexShaderSource = "#version 300 core\n"
    "layout (location = 0) in vec4 vPosition;\n"                         //定了输入变量的位置值
    "void main()\n"
    "{\n"
    "gl_Position = vPosition;\n"
    "}\0";
    
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    int  success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if(!success){
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::VERTEX::COMPILATION_FAILED\n%s",infoLog);
    }
    
    
    
    
    //2.片段着色器
    const GLchar* fragmentShaderSource = "#version 300 core\n"
    "precision mediump float;\n"
    "out vec4 color;\n"
    "void main()\n"
    "{\n"
    "color = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n\0";
    
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if(!success){
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n%s",infoLog);
    }
    
    //3.着色器程序
    //着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本
    GLuint shaderProgram;
    shaderProgram = glCreateProgram();
    
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if(!success){
        glGetProgramInfoLog(shaderProgram,512,NULL,infoLog);
        NSLog(@"EROOR:LINKEDFAILED\n%s",infoLog);
    }
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    glUseProgram(shaderProgram);
    
    //4.VOA VOB
    float vertices[] = {
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.0f,  0.5f, 0.0f
    };
    
    //4.0 初始化VAO,VBO
    GLuint VBO,VAO;
    glGenVertexArrays(1,&VAO);
    glGenBuffers(1, &VBO);

    //4.1 绑定VAO
    glBindVertexArray(VAO);

    //4.2 把顶点数组复制到缓冲中供OpenGL使用
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //4.3 设置顶点属性指针,函数告诉OpenGL该如何解析顶点数据
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
    
    //绘制物体
    glViewport(0, 0, renderbufferWidth, renderbufferHeight);
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(0);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (CAEAGLLayer *)glLayer{
    return (CAEAGLLayer *)self.layer;
}

@end
