# CMCore

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## 导入

CMCore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CMCore'				# 导入整个库
pod 'CMCore/HTTP'			# 导入"网络请求"子库
pod 'CMCore/DataBase'		# 导入"数据库"子库
pod 'CMCore/Storage'		# 导入"存储器"子库
pod 'CMCore/Crypto'			# 导入"加密"子库
pod 'CMCore/Compression'	# 导入"压缩"子库
pod 'CMCore/ImageUtil'		# 导入"图片工具"子库
```

## 结构
`CMCore`是 iOS 开发平台的基础库，分为如下子库
* `HTTP`：网路请求子库
* `DataBase`：数据库子库
* `Storage`：文件存储子库
* `Crypto`：加密子库
* `Compression`：压缩子库
* `ImageUtil`：图片处理子库

### HTTP：网路请求
主要分为四个类：
* **`CMHTTPRequest`**：基本请求类，用于配置请求信息和回调处理
* **`CMHTTPSession`**：请求会话类，用于发送、管理网络请求
* **`CMHTTPSerialization`**：请求序列化类，用于将请求数据转化为系统的`HTTP`请求
* **`CMHTTPDeserialization`**：请求反序列化类，将响应数据转化为业务数据

### DataBase：数据库
主要是**`CMDataBase`**类， 是数据管理类，主要封装有数据库的 `SQL` 语句的执行接口。
`SQL` 语句的执行接口分为两个
* 更新接口
```
	- (BOOL)executeUpdate:(NSString *)sql, ...;
```
* 查询接口
```
	- (NSArray *_Nullable)executeQuery:(NSString *)sql, ...;
```

### Storage：文件存储
主要是**`CMStorager`**类，功能是统一管理碎片文件路径，设计思路是以`key`来存取文件的路径
* 存
```
	/// 复制文件
	- (BOOL)copyFilePath:(NSString *)fromPath withKey:(NSString *)key;
	/// 移动文件
	- (BOOL)moveFilePath:(NSString *)fromPath withKey:(NSString *)key;
	/// 保存Data数据
	- (BOOL)saveContents:(NSData *)contents withKey:(NSString *)key;
```

* 取
```
	/// 获取数据
	- (NSData *_Nullable)contentsWithKey:(NSString *)key;
	/// 根据 key 查找或生成路径
	- (NSString *_Nullable)filePathForKey:(NSString *)key;
```

### Crypto：加密子库
现封装有`AES`、`DES`、`MD5`的工厂方法
* **`AES`**
```
	@interface CMCryptor
    + (NSString *)stringEncryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;
    + (NSString *)stringDecryptedByAESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;
	+ (NSData *)dataEncryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;
    + (NSData *)dataDecryptedByAESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;
	@end
```

* **`DES`**
```
	@interface CMCryptor
    + (NSString *)stringEncryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;
    + (NSString *)stringDecryptedByDESWithString:(NSString *)string key:(id)key iv:(id)iv error:(NSError **)error;
	+ (NSData *)dataEncryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;
    + (NSData *)dataDecryptedByDESWithData:(NSData *)data key:(id)key iv:(id)iv error:(NSError **)error;
	@end
```

* **`MD5`**
```
	@interface NSString (CMCrypto)
	- (NSString *)cm_MD5String; // 字符串MD5
	@end

	@interface NSData (CMCrypto)
	- (NSData *)cm_MD5Data;	// Data的MD5
	@end
```

### Compression：压缩
主要所有：
* **`CMCompressor`**：压缩器协议，定义通用的压缩接口。
```
	@protocol CMCompressor <NSObject>
    + (BOOL)isCompressedWithData:(NSData *)data;
    + (NSData *_Nullable)dataCompressedWithData:(NSData *)data error:(NSError *__autoreleasing *)error;
    + (NSData *_Nullable)dataDecompressedWithData:(NSData *)data error:(NSError *__autoreleasing *)error;
    + (BOOL)compressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError *__autoreleasing *)error;
    + (BOOL)decompressFile:(NSURL *)sourceFile toFile:(NSURL *)destinationFile error:(NSError *__autoreleasing *)error;
    @end
```

* **`CMGZipCompressor`**：GZip压缩器，实现压缩器协议，实现`GZip`压缩。

#### ImageUtil：图片处理
主要封装有图片的压缩的方法，都是`UIIamge`的类别方法 实现，分为两类以分辨率压缩和以质量压缩
```
- (UIImage *)cm_imageResizedToSize:(CGSize)size;
- (UIImage *)cm_imageResizedToBytes:(NSUInteger)bytes;
- (UIImage *)cm_imageResizedToSize:(CGSize)size andBytes:(NSUInteger)bytes;
```

## Author

彭涛,  pengt@cmrh.com

## License

CMCore is available under the MIT license. See the LICENSE file for more info.
