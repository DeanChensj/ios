//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dean Chen on 16/4/1.
//  Copyright © 2016年 Dean Chen. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;

@end

@implementation ViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck: [self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    [self.mySegmentControl setEnabled:NO];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    self.resultLabel.text = self.game.tag;
}


- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


- (IBAction)restartButton:(UIButton *)sender {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck: [self createDeck]];
    
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardback"]
                              forState:UIControlStateNormal];
        [cardButton setTitle:@""
                    forState:UIControlStateNormal];
        
        cardButton.enabled = YES;
    }
    self.scoreLabel.text = @"Score:0";
    self.resultLabel.text = @"";
    [self.mySegmentControl setEnabled:YES];
    self.game.is2CardMatch = _mySegmentControl.selectedSegmentIndex ? NO : YES;
}

- (IBAction)segmentControler:(UISegmentedControl *)sender {
    self.game.is2CardMatch = _mySegmentControl.selectedSegmentIndex ? NO : YES;    
}

- (void) viewDidLoad
{
    [_mySegmentControl setSelectedSegmentIndex:0];
    self.game.is2CardMatch = YES;
}



@end
