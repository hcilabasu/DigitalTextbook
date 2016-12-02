//
//  Readebook.m
//  eBookReader
//
//  Created by Andreea Danielescu on 2/6/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "EBookImporter.h"

@implementation EBookImporter

@synthesize docsDir;
@synthesize dirPaths;
@synthesize library;

- (id) init {
	if (self = [super init]) {
        library = [[NSMutableArray alloc] init];
        [self findDocDir];
	}
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

// finds the documents directory for the application
- (void) findDocDir {
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    //NSLog(@"documents directory: %@", docsDir);
}

/* This method looks through the Documents directory of the app to find all the books in the
 library. */
-(NSMutableArray*) importLibrary {
    NSFileManager *filemgr;
    NSArray *docFileList;
    
    //Starting from the Documents directory of the app.
    filemgr =[NSFileManager defaultManager];
    docFileList = [filemgr contentsOfDirectoryAtPath:docsDir error:NULL];

    //Find all the authors directories. 
    for (NSString* item in docFileList) {
        NSString* authorPath = [docsDir stringByAppendingString:@"/"];
        authorPath = [authorPath stringByAppendingString:item];
        
        NSDictionary *attribs = [filemgr attributesOfItemAtPath:authorPath error: NULL];
        
        if([attribs objectForKey:NSFileType] == NSFileTypeDirectory) {            
            NSArray* authorBookList = [filemgr contentsOfDirectoryAtPath:authorPath error:NULL];
            
            //Find all the book directories for this author.
            for(NSString* bookDir in authorBookList) {
                NSString* bookPath = [authorPath stringByAppendingString:@"/"];
                bookPath = [bookPath stringByAppendingString:bookDir];
                
                NSDictionary *attribsBook = [filemgr attributesOfItemAtPath:bookPath error: NULL];
                
                if([attribsBook objectForKey:NSFileType] == NSFileTypeDirectory) {
                    if(![[(NSString*) bookDir substringToIndex:1] isEqualToString:@"."]) {
                        
                        //Find all the files for this book.
                        NSArray* fileList = [filemgr contentsOfDirectoryAtPath:bookPath error:NULL];
                        
                        for(NSString* file in fileList) {
                            NSString* filePath = [bookPath stringByAppendingString:@"/"];
                            filePath = [filePath stringByAppendingString:file];
                            
                            NSDictionary *attribsFile = [filemgr attributesOfItemAtPath:filePath error: NULL];
                            
                            //make sure we're looking at a file and not a directory. 
                            if([attribsFile objectForKey:NSFileType] != NSFileTypeDirectory) {
                                NSRange fileExtensionLoc = [file rangeOfString:@"."];
                                NSString* fileExtension = [file substringFromIndex:fileExtensionLoc.location];

                                //find the epub file and unzip it.
                                if([fileExtension isEqualToString:@".epub"]) {
                                    [self unzipEpub:bookPath :file];
                                }                                
                            }
                        }
                    }
                }

            }
        
        }
    }
    
    return library;
    //[filemgr release];
}

//Unzips the epub. 
-(void) unzipEpub:(NSString*) filepath :(NSString*) filename{
    NSString *epubFilePath = [filepath stringByAppendingString:@"/"];
    epubFilePath = [epubFilePath stringByAppendingString:filename];

    NSString *epubDirectoryPath = [filepath stringByAppendingString:@"/epub/"];
    //NSString *filepath = [[NSBundle mainBundle] pathForResource:@"ZipFileName" ofType:@"zip"];
    
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    
    [zipArchive UnzipOpenFile:epubFilePath];
    [zipArchive UnzipFileTo:epubDirectoryPath overWrite:YES];
    [zipArchive UnzipCloseFile];
    
    [zipArchive release];
    
    //read the container to find the path for the opf.
    [self readContainerForBook:filepath];
}

-(Book*) importEBook:(NSString*) bookTitle{
    NSRange dashRange = [bookTitle rangeOfString:@" - "];
    NSString* title = [bookTitle substringToIndex:dashRange.location];
    NSString* author = [bookTitle substringFromIndex:dashRange.location + dashRange.length];
    
    for(Book *book in library) {
        if(([book.title compare:title] == NSOrderedSame) && ([book.author compare:author] == NSOrderedSame)){
            return book;
            break;
        }
    }
    
    return nil;
}

-(void) readContainerForBook:(NSString*)filepath {
     NSString* containerPath = [filepath stringByAppendingString:@"/epub/META-INF/container.xml"];
    
    //Get xml data of the container file.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:containerPath];
    
    NSError *error;
    GDataXMLDocument *containerDoc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                                    options:0 error:&error];
    
    //Find the name of the opf file for the book.
    NSArray *rootFiles = [containerDoc.rootElement elementsForName:@"rootfiles"];
    GDataXMLElement *rootFilesElement = (GDataXMLElement *) [rootFiles objectAtIndex:0];
    
    NSArray *rootFileItem = [rootFilesElement elementsForName:@"rootfile"];
    GDataXMLElement *rootFileItemElement = (GDataXMLElement *) [rootFileItem objectAtIndex:0];
    
    NSString *mediaType = [[rootFileItemElement attributeForName:@"media-type"] stringValue];
    
    if([mediaType isEqualToString:@"application/oebps-package+xml"]) {
        NSString* opfBookFile = [[rootFileItemElement attributeForName:@"full-path"] stringValue];
        //Once opf file has been found, read the opf file for the book.
        [self readOpfForBook:opfBookFile :filepath];
    }

}

-(void) readOpfForBook:(NSString*)filename :(NSString*)filepath {
    //Get the filepath of the opf book file.
    NSString *opfFilePath = [filepath stringByAppendingString:@"/epub/"];
    opfFilePath = [opfFilePath stringByAppendingString:filename];
    
    //Get xml data of the opf file.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:opfFilePath];
    
    NSError *error;
    GDataXMLDocument *opfDoc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                              options:0 error:&error];
    
    //Extract metadata, which includes author and title information.
    NSArray *metadataElement = [opfDoc.rootElement elementsForName:@"metadata"];
    GDataXMLElement *metadata = (GDataXMLElement *) [metadataElement objectAtIndex:0];
    Book *book;
    
    //Extract title.
    NSArray *titleElement = [metadata elementsForName:@"dc:title"];
    GDataXMLElement *titleData = (GDataXMLElement *) [titleElement objectAtIndex:0];
    NSString* title = titleData.stringValue;
    
    //Extract author.
    NSArray *authorElement = [metadata elementsForName:@"dc:creator"];
    GDataXMLElement *authorData = (GDataXMLElement *) [authorElement objectAtIndex:0];
    NSString* author = authorData.stringValue;
    
    //if there is no title and author information, go ahead and just list it as Unknown.
    if(title == nil)
        title = @"Unknown";
    if(author == nil)
        author = @"Unknown";
    
    //Create Book with author and title.
    book = [[Book alloc] initWithTitleAndAuthor:filepath :title :author];

    //set the mainContentPath so we can access the cover image and all other files of the book.
    NSRange rangeOfContentFile = [opfFilePath rangeOfString:@"content.opf"];
    if(rangeOfContentFile.length!=0){
    [book setMainContentPath:[opfFilePath substringToIndex:rangeOfContentFile.location]];
    }else{
        [book setMainContentPath:nil];
        // [book setMainContentPath:[opfFilePath substringToIndex:rangeOfContentFile.location]];
        
    }
    
    //Extract the cover if it has one. 
    //cover image is in <meta content=<> name<>/> inside of metadata.
    //content is the id of the jpg that can be found in the manifest.
    //name is always cover for the cover page.
    //can also be found in the guide as an html, but I'm not sure that will work in this instance.
    NSString* coverFilePath = nil;
    NSString* coverId = nil;
    
    NSArray* metaElement = [metadata elementsForName:@"meta"];
    
    for(GDataXMLElement *element in metaElement) {
         NSString* name = [[element attributeForName:@"name"] stringValue];
        
        if([name compare:@"cover"] == NSOrderedSame) {
            coverId = [[element attributeForName:@"content"] stringValue];
        }
    }
    
    //read manifest items and store them in an NSDictionary for easy access.
    NSArray *manifest = [opfDoc.rootElement elementsForName:@"manifest"];
    GDataXMLElement *manifestElement = (GDataXMLElement *)[manifest objectAtIndex:0];
    
    NSArray *items = [manifestElement elementsForName:@"item"];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    NSMutableArray *hrefs = [[NSMutableArray alloc] init];
    
    for(GDataXMLElement* item in items) {
        NSString* itemId = [[item attributeForName:@"id"] stringValue];
        NSString* itemHref = [[item attributeForName:@"href"] stringValue];
        
        [ids addObject:itemId];
        [hrefs addObject:itemHref];
    }
    
    NSDictionary *bookItems = [[NSDictionary alloc] initWithObjects:hrefs forKeys:ids]; //create NSDictionary.
    [book setBookItems:bookItems]; //it may be unnecessary to store the dictionary directly in the book object...instead we may want to store it elsewhere, or process this data and store it in some other way.
    
    //read spine and store that for the time being. See comment above re: bookItems.
    NSArray *spine = [opfDoc.rootElement elementsForName:@"spine"];
    GDataXMLElement *spineElement = (GDataXMLElement *)[spine objectAtIndex:0];
    
    NSArray* itemOrderElement = [spineElement elementsForName:@"itemref"];
    NSMutableArray *itemOrder = [[NSMutableArray alloc] init];
    
    for(GDataXMLElement* itemRef in itemOrderElement) {
        NSString* itemId = [[itemRef attributeForName:@"idref"] stringValue];
        [itemOrder addObject:itemId];
    }
    
    [book setItemOrder:itemOrder];
    
    if(coverId != nil) {
        NSString* coverFilename = [bookItems objectForKey:coverId];

        coverFilePath = [[book mainContentPath] stringByAppendingString:@"/"];
        coverFilePath = [coverFilePath stringByAppendingString:coverFilename];
        [book setCoverImagePath:coverFilePath];
    }
  
    //add the book to the library. 
    [library addObject:book];
}

@end
