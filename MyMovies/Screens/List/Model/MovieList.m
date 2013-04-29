//
// Created by tomvanzummeren on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MovieList.h"
#import "Movie.h"
#import "Section.h"


@implementation MovieList {
    NSMutableArray *sections;

    NSMutableDictionary *sectionsIndexByTitle;

    Section *defaultSection;
}

- (id) init {
    self = [super init];
    if (self) {
        sections = [NSMutableArray array];
        sectionsIndexByTitle = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) addMovie:(Movie *) movie inSection:(NSString *) sectionTitle {
    Section *section = sectionsIndexByTitle[sectionTitle];
    if (!section) {
        section = [[Section alloc] initWithTitle:sectionTitle];
        sectionsIndexByTitle[sectionTitle] = section;
        [sections addObject:section];
    }
    [section.movies addObject:movie];
}

+ (MovieList *) movieListWithOneSection:(NSArray *) movies {
    MovieList *movieList = [MovieList new];
    for (Movie *movie in movies) {
        [movieList addMovie:movie];
    }
    return movieList;
}

- (void) addMovie:(Movie *) movie {
    // Add movie to default section
    if (!defaultSection) {
        defaultSection = [Section new];
        [sections addObject:defaultSection];
    }
    [defaultSection.movies addObject:movie];
}

- (void) moveMovieFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath {
    Section *fromSection = sections[(NSUInteger) fromIndexPath.section];
    Section *toSection = sections[(NSUInteger) toIndexPath.section];

    Movie *selectedMovie = fromSection.movies[(NSUInteger) fromIndexPath.row];
    [fromSection.movies removeObjectAtIndex:(NSUInteger) fromIndexPath.row];
    [toSection.movies insertObject:selectedMovie atIndex:(NSUInteger) toIndexPath.row];

}

- (void) removeMovieAtIndexPath:(NSIndexPath *) indexPath {
    Section *section = sections[(NSUInteger) indexPath.section];
    [section.movies removeObjectAtIndex:(NSUInteger) indexPath.row];
}

- (NSIndexPath *) indexPathForMovie:(Movie *) movie {
    NSInteger sectionIndex = 0;
    for (Section *section in sections) {
        NSUInteger row = [section.movies indexOfObject:movie];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow:row inSection:sectionIndex];
        }
        sectionIndex ++;
    }
    return nil;
}

- (Movie *) movieAtIndexPath:(NSIndexPath *) indexPath {
    Section *section = sections[(NSUInteger) indexPath.section];
    return section.movies[(NSUInteger) indexPath.row];
}

- (NSUInteger) numberOfSections {
    return [sections count];
}

- (NSUInteger) numberOfMoviesInSection:(NSUInteger) sectionIndex {
    Section *section = sections[sectionIndex];
    return [section.movies count];
}

- (NSString *) titleForHeaderInSection:(NSInteger) sectionIndex {
    Section *section = sections[(NSUInteger) sectionIndex];
    return section.title;
}

- (void) insertMovie:(Movie *) movie atIndexPath:(NSIndexPath *) indexPath {
    Section *section = sections[(NSUInteger) indexPath.section];
    [section.movies insertObject:movie atIndex:(NSUInteger) indexPath.row];
}

- (NSInteger) sectionIndexForTitle:(NSString *) title {
    Section *section = [sectionsIndexByTitle objectForKey:title];
    return [sections indexOfObject:section];
}

@end